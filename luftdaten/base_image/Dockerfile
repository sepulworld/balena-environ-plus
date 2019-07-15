FROM balenalib/raspberry-pi-debian-python:3.7.3-stretch-build

WORKDIR /usr/src

# Not very fast on pi1, fyi
RUN pip3 install numpy --user --no-binary :all:

# Runs pretty quick
RUN pip3 install enviroplus \
  requests \
  smbus \
  spidev \
  RPi.GPIO

RUN install_packages python3-pil libatlas-base-dev python3-dev
