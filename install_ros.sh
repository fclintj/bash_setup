#!/bin/bash
# setup source list
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

# setup keys
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

# installation
sudo apt-get update
sudo apt-get install ros-kinetic-desktop-full

# find available packages
apt-cache search ros-kinetic

# initialize rosdep
sudo rosdep init
rosdep update

# install dependencies
sudo apt install -y python-rosinstall python-rosinstall-generator python-wstool build-essential
