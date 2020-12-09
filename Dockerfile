### Export all of the enviro+ sensor data to a Prometheus exporter ###

# Built from /base_image/Dockerfile
FROM sighmon/balena-enviro-plus:v1

WORKDIR /usr/src
RUN sudo pip3 install prometheus_client influxdb-client SafecastPy python-periphery
COPY enviroplus_exporter/enviroplus_exporter.py enviroplus_exporter.py
COPY enviroplus_exporter/notecard/notecard/notecard.py notecard/notecard/notecard.py

# InfluxDB settings
ENV INFLUXDB_URL="https://location.gcp.cloud2.influxdata.com"
ENV INFLUXDB_TOKEN="your_token"
ENV INFLUXDB_ORG_ID="your_organisation_id"
ENV INFLUXDB_BUCKET="your_bucket_name"
ENV INFLUXDB_SENSOR_LOCATION="your_sensor_location"
ENV INFLUXDB_TIME_BETWEEN_POSTS="number_of_seconds_between_posts"

# Luftdaten settings
ENV LUFTDATEN_TIME_BETWEEN_POSTS="30"

# Safecast settings
ENV SAFECAST_TIME_BETWEEN_POSTS="300"
ENV SAFECAST_DEV_MODE="false"
ENV SAFECAST_API_KEY="your_api_key"
ENV SAFECAST_API_KEY_DEV="your_dev_api_key"
ENV SAFECAST_LATITUDE="your_sensor_latitude"
ENV SAFECAST_LONGITUDE="your_sensor_longitude"
ENV SAFECAST_DEVICE_ID="226"
ENV SAFECAST_LOCATION_NAME="your_sensor_location"

# Blues Notecard settings
ENV NOTECARD_TIME_BETWEEN_POSTS="600"

# See debug output
ENV DEBUG="true"

# Compensation factor OR temperature/humidity adjustment to take into account the CPU temperature
# ENV COMPENSATION_FACTOR="2.25"
ENV TEMPERATURE_COMPENSATION="6.6"
ENV HUMIDITY_COMPENSATION="24.7"

# Uses temperature adjustment factor of 2.25 and also posts to all other services
# CMD ["sh", "-c", "python3 enviroplus_exporter.py --factor $COMPENSATION_FACTOR --influxdb true --luftdaten true --safecast true --notecard false"]

# Uses temperature compensation of 6.6 and humidity compensation of 24.7 and posts to influxdb and luftdaten
CMD ["sh", "-c", "python3 enviroplus_exporter.py --temp $TEMPERATURE_COMPENSATION --humid $HUMIDITY_COMPENSATION --influxdb true --luftdaten true"]
