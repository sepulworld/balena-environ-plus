#!/usr/bin/env python

import requests
import time
from bme280 import BME280
from pms5003 import PMS5003, ReadTimeoutError
from subprocess import PIPE, check_output, run

try:
    from smbus2 import SMBus
except ImportError:
    from smbus import SMBus

try:
    bus = SMBus(1)
except Exception as e:
    print(e)

# Create BME280 instance
try:
    bme280 = BME280(i2c_dev=bus)
except Exception as e:
    print(e)

# Create PMS5003 instance
try:
    pms5003 = PMS5003()
except Exception as e:
    print(e)


# Read values from BME280 and PMS5003 and return as dict
def read_values():
    values = {}
    cpu_temp = get_cpu_temperature()
    raw_temp = bme280.get_temperature()
    comp_temp = raw_temp - ((cpu_temp - raw_temp) / comp_factor)
    values["temperature"] = "{:.2f}".format(comp_temp)
    values["pressure"] = "{:.2f}".format(bme280.get_pressure() * 100)
    values["humidity"] = "{:.2f}".format(bme280.get_humidity())
    try:
        pm_values = pms5003.read()
        values["P2"] = str(pm_values.pm_ug_per_m3(2.5))
        values["P1"] = str(pm_values.pm_ug_per_m3(10))
    except ReadTimeoutError:
        pms5003.reset()
        pm_values = pms5003.read()
        values["P2"] = str(pm_values.pm_ug_per_m3(2.5))
        values["P1"] = str(pm_values.pm_ug_per_m3(10))
    return values


# Get CPU temperature to use for compensation
def get_cpu_temperature():
    process = run(['vcgencmd', 'measure_temp'], stdout=PIPE)
    output = process.stdout.decode('utf-8')
    return float(output.split('=')[1].split("'")[0])


# Get Raspberry Pi serial number to use as ID
def get_serial_number():
    with open('/proc/cpuinfo', 'r') as f:
        for line in f:
            if line[0:6] == 'Serial':
                return str(line.split(":")[1].strip())


# Check for Wi-Fi connection
def check_wifi():
    if check_output(['hostname', '-I']):
        return True
    else:
        return False


def send_to_luftdaten(values, id):
    pm_values = dict(i for i in values.items() if i[0].startswith("P"))
    temp_values = dict(i for i in values.items() if not i[0].startswith("P"))

    resp_1 = requests.post("https://api.luftdaten.info/v1/push-sensor-data/",
             json={
                 "software_version": "enviro-plus 0.0.1",
                 "sensordatavalues": [{"value_type": key, "value": val} for
                                      key, val in pm_values.items()]
             },
             headers={
                 "X-PIN":    "1",
                 "X-Sensor": id,
                 "Content-Type": "application/json",
                 "cache-control": "no-cache"
             }
    )

    resp_2 = requests.post("https://api.luftdaten.info/v1/push-sensor-data/",
             json={
                 "software_version": "enviro-plus 0.0.1",
                 "sensordatavalues": [{"value_type": key, "value": val} for
                                      key, val in temp_values.items()]
             },
             headers={
                 "X-PIN":    "11",
                 "X-Sensor": id,
                 "Content-Type": "application/json",
                 "cache-control": "no-cache"
             }
    )

    if resp_1.ok and resp_2.ok:
        return True
    else:
        return False


# Compensation factor for temperature
comp_factor = 1.2

# Raspberry Pi ID to send to Luftdaten
id = "raspi-" + get_serial_number()

# Main loop to read data and send to Luftdaten
while True:
    values = None
    try:
        values = read_values()
        print(values)
        resp = send_to_luftdaten(values, id)
        print("Response: {}\n".format("ok" if resp else "failed"))
        time.sleep(30)
    except Exception as e:
        print(e)
