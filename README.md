# Balena enviro+

Deploy an [Enviro+](https://shop.pimoroni.com/products/enviro) environment sensor (with [PMS5003](https://shop.pimoroni.com/products/pms5003-particulate-matter-sensor-with-cable) particle sensor) using [Balena](https://www.balena.io) and export the data for [Prometheus](https://prometheus.io).

## Getting Started

To try this on your Raspberry Pi using Docker:

Install Docker.

* `curl -sSL https://get.docker.com | sh`
* `sudo usermod -aG docker pi`
* Reboot your Pi

Build and run the Docker image.

* `docker build -t sighmon/enviroplus_exporter:v1 .`
* `docker run --privileged -p 8000:8000 sighmon/enviroplus_exporter:v1`
* Open your favourite browser and visit: [raspberrypi.local:8000](http://raspberrypi.local:8000)

## Post to InfluxDB as well as exporting to Prometheus

I've added the ability to post to InfluxDB. To enable this, add your [InfluxDB-Cloud](https://www.influxdata.com/products/influxdb-cloud/) environment variables to the `Dockerfile`:

```env
ENV INFLUXDB_URL="https://your_server_location.gcp.cloud2.influxdata.com"
ENV INFLUXDB_TOKEN="your_token"
ENV INFLUXDB_ORG_ID="your_organisation_id"
ENV INFLUXDB_BUCKET="your_bucket_name"
ENV INFLUXDB_SENSOR_LOCATION="your_sensor_location"
ENV INFLUXDB_TIME_BETWEEN_POSTS="number_of_seconds_between_posts"
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
