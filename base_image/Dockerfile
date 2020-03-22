FROM balenalib/raspberry-pi-debian-python:3.7.4-build

WORKDIR /usr/src

RUN pip3 install enviroplus \
  requests \
  spidev \
  RPi.GPIO

RUN install_packages \
  python3-smbus \
  python3-pil \
  libatlas-base-dev \
  python3-dev \
  python3-setuptools \
  python3-numpy
