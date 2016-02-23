FROM ubuntu:14.04

MAINTAINER Lauri Junkkari

# Heavy weight stuff separately
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    software-properties-common \
    libopencv-dev \
    libboost1.55-dev \
    libboost-thread1.55-dev \
    libboost-program-options1.55-dev \
    libboost-filesystem1.55-dev \
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

RUN mkdir -p libfunctionality/build && \
    cd libfunctionality/build  && \
    cmake .. && make && make install && \
    cd ../.. && \
    mkdir -p jsoncpp/build && \
    cd jsoncpp/build && \
    cmake .. -DJSONCPP_WITH_CMAKE_PACKAGE=ON -DJSONCPP_LIB_BUILD_SHARED=OFF -DCMAKE_CXX_FLAGS=-fPIC && make && make install && \
    cd ../.. && \
    mkdir -p OSVR-Core/build && \
    cd OSVR-Core/build && \
    cmake .. && make && make install

WORKDIR /opt/osvr

# Additional dependecies
RUN apt-get install -y --no-install-recommends \
    libxext-dev \
    libxrender-dev \
    libxtst-dev

VOLUME ["/tmp/.X11-unix"]
