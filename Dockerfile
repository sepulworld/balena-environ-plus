### Export all of the enviro+ sensor data to a Prometheus exporter ###

# Built from /base_image/Dockerfile
FROM sighmon/balena-enviro-plus:v1

RUN pip3 install prometheus_client

WORKDIR /usr/src

COPY enviroplus_exporter/enviroplus_exporter.py enviroplus_exporter.py

# Uses temperature adjustment of 2.25
CMD ["python3", "enviroplus_exporter.py", "-f", "2.25"]
