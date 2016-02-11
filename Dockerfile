FROM ubuntu:14.04

MAINTAINER Lauri Junkkari

# Heavy weight stuff separately
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    software-properties-common \
    libopencv-dev \
    libboost1.54-dev \
    libboost-thread1.54-dev \
    libboost-program-options1.54-dev \
    libboost-filesystem1.54-dev \
    libusb-1.0-0-dev

# Cmake
RUN add-apt-repository ppa:george-edison55/cmake-3.x && \
    apt-get update && \
    apt-get install -y --no-install-recommends cmake

# Basic dependecies
RUN apt-get install -y --no-install-recommends \
    build-essential \
    git-core

WORKDIR /usr/src

RUN git clone --recursive https://github.com/OSVR/libfunctionality.git && \
    git clone --recursive https://github.com/VRPN/jsoncpp && \
    git clone --recursive https://github.com/OSVR/OSVR-Core.git

RUN cd libfunctionality/src && \
    cmake .. && make install && \
    cd ../.. && \
    cd jsoncpp/src && \
    cmake .. -DJSONCPP_WITH_CMAKE_PACKAGE=ON -DJSONCPP_LIB_BUILD_SHARED=OFF -DCMAKE_CXX_FLAGS=-fPIC && make install && \
    cd ../.. && \
    cd OSVR-Core/src && \
    cmake .. && make install

WORKDIR /opt/osvr

# Additional dependecies
RUN apt-get install -y --no-install-recommends \
    libxext-dev \
    libxrender-dev \
    libxtst-dev

VOLUME ["/tmp/.X11-unix"]
