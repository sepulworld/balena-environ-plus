# Balena enviro+

Deploy an [Enviro+](https://shop.pimoroni.com/products/enviro) environment sensor (with [PMS5003](https://shop.pimoroni.com/products/pms5003-particulate-matter-sensor-with-cable) particle sensor) using [Balena](https://www.balena.io) and export the data for [Prometheus](https://prometheus.io).

## Getting Started

To try this on your Raspberry Pi using Docker:

Install Docker.

* `curl -sSL https://get.docker.com | sh`
* `sudo usermod -aG docker pi`
* Reboot your Pi

Clone this repo, and initialise the submodule.

* `git clone https://github.com/sighmon/balena-enviro-plus`
* `cd balena-enviro-plus`
* `git submodule update --init`

Build and run the Docker image in the background.

* `docker build -t sighmon/enviroplus_exporter:v1 .`
* `docker run -d --privileged -p 8000:8000 sighmon/enviroplus_exporter:v1`
* Open your favourite browser and visit: [raspberrypi.local:8000](http://raspberrypi.local:8000)
* See the running container with `docker ps`
* Check the logs with `docker logs <containaer_name>`

## Post to InfluxDB as well as exporting to Prometheus

If you'd like to also post your data to InfluxDB, enable this by adding your [InfluxDB-Cloud](https://www.influxdata.com/products/influxdb-cloud/) environment variables to the `Dockerfile`:

```env
ENV INFLUXDB_URL="https://your_server_location.gcp.cloud2.influxdata.com"
ENV INFLUXDB_TOKEN="your_token"
ENV INFLUXDB_ORG_ID="your_organisation_id"
ENV INFLUXDB_BUCKET="your_bucket_name"
ENV INFLUXDB_SENSOR_LOCATION="Adelaide"
ENV INFLUXDB_TIME_BETWEEN_POSTS="5"
# To see all debug messages
ENV DEBUG="true"
```

## Post to Luftdaten as well as exporting to Prometheus

If you'd like to also post your data to [Luftdaten](https://meine.luftdaten.info), set the time between posts in the `Dockerfile`:

```env
ENV LUFTDATEN_TIME_BETWEEN_POSTS="30"
# To see all debug messages
ENV DEBUG="true"
```

## Enabling Particulates on RPi 3, 4, & ZeroW

If you're using Enviro+ on a RPi3, 4 or Zero W you'll need to set `"pi3-miniuart-bt"` in your Balena Dashboard / Device/Fleet Settings / "Define DT overlays" section for it to read from the serial interface for the PMS5003 particulate monitor. 

* [Balena Docs](https://www.balena.io/docs/learn/develop/hardware/i2c-and-spi/#using-uart-or-serial-on-raspberry-pi-3) 
* [Raspberry Pi Docs](https://www.raspberrypi.org/documentation/configuration/uart.md).

You'll also need to disable the Serial port on the Balena Host by masking the serial getty service. 

```
# SSH to Balena Host
mount -o remount,rw /
systemctl mask serial-getty@serial0.service
reboot
```

## Deploy with Balena

Once you're happy that it works on your Pi, use the Balena CLI to push it to a Balena app. 

* `balena push <your_app_name>`

## Build your own base image

If you'd prefer to build your own base image, follow these instructions:

* `cd base_image`
* `docker build -t <your_name>/balena-enviro-plus:v1 .`
* Create a repository on [Docker Hub](https://hub.docker.com/)
* `docker push <your_name>/balena-enviro-plus:v1`

## Acknowledgments

Thanks to [Zane Williamson](https://github.com/sepulworld/balena-environ-plus) for his work.
