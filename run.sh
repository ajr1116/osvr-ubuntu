#!/bin/bash

docker run -ti --rm \
           -e DISPLAY=$DISPLAY \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           tislaamo/osvr-ubuntu:latest
