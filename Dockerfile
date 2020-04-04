### Export all of the enviro+ sensor data to a Prometheus exporter ###

# Built from /base_image/Dockerfile
FROM sighmon/balena-enviro-plus:v1

WORKDIR /usr/src
RUN sudo pip3 install prometheus_client influxdb-client
COPY enviroplus_exporter/enviroplus_exporter.py enviroplus_exporter.py

# InfluxDB settings
ENV INFLUXDB_URL="https://location.gcp.cloud2.influxdata.com"
ENV INFLUXDB_TOKEN="your_token"
ENV INFLUXDB_ORG_ID="your_organisation_id"
ENV INFLUXDB_BUCKET="your_bucket_name"
ENV INFLUXDB_SENSOR_LOCATION="your_sensor_location"
ENV INFLUXDB_TIME_BETWEEN_POSTS="number_of_seconds_between_posts"

# Uses temperature adjustment of 2.25 and also posts to InfluxDB
CMD ["python3", "enviroplus_exporter.py", "--factor", "2.25", "--influxdb", "true"]
