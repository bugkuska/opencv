#!/bin/bash

############## WELCOME #############
# Get command line argument for verbose
echo "Welcome to OpenCV Installation Script for Raspbian Buster"
echo "This script is provided by LearnOpenCV.com and edit for rasbian Buster by Aj.Sompoch"

echo "Preparing system for installation..."
sudo apt-get -y purge wolfram-engine
sudo apt-get -y purge libreoffice*
sudo apt-get -y clean
sudo apt-get -y autoremove

######### VERBOSE ON ##########
# Step 1: Update packages
echo "Updating packages"
sudo apt-get -y update
sudo apt-get -y upgrade
echo "================================"
echo "Complete"

# Step 2: Install OS libraries
echo "Installing OS libraries"
sudo apt-get -y remove x264 libx264-dev
## Install dependencies
sudo apt-get -y install build-essential checkinstall cmake unzip pkg-config yasm
sudo apt-get -y install libjpeg-dev libpng-dev libtiff-dev
sudo apt-get -y install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
sudo apt-get -y install libxvidcore-dev libx264-dev
sudo apt-get -y install libgtk-3-dev
sudo apt-get -y install libcanberra-gtk*
sudo apt-get -y install libatlas-base-dev gfortran 
sudo apt-get -y install python3-dev
sudo apt-get -y install libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev
sudo apt-get -y install libgtk2.0-dev libtbb-dev qt5-default
sudo apt-get -y install libatlas-base-dev
sudo apt-get -y install libmp3lame-dev libtheora-dev
sudo apt-get -y install libvorbis-dev libxvidcore-dev libx264-dev
sudo apt-get -y install libopencore-amrnb-dev libopencore-amrwb-dev
sudo apt-get -y install libavresample-dev
sudo apt-get -y install x264 v4l-utils
# Optional dependencies
sudo apt-get -y install libprotobuf-dev protobuf-compiler
sudo apt-get -y install libgoogle-glog-dev libgflags-dev
sudo apt-get -y install libgphoto2-dev libeigen3-dev libhdf5-dev doxygen
echo "================================"
echo "Complete"


# Step 3: Install Python libraries
echo "Install Python libraries"
sudo apt-get -y install python3-dev python3-pip python3-venv virtualenv
sudo -H pip3 install -U pip numpy pillow
sudo apt-get -y install python3-testresources

# Install virtual environment
echo "Creating Python environments"
mkdir /home/pi/.virtualenvs
virtualenv /home/pi/.virtualenvs/py3cv4
echo "# Virtual Environment Wrapper" >> ~/.profile
echo " export WORKON_HOME=$HOME/.virtualenvs" >> ~/.profile
echo "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> ~/.profile
source /home/pi/.virtualenvs/py3cv4/bin/activate
echo "================================"
echo "Complete"

############ For Python 3 ############
# now install python libraries within this virtual environment
sudo sed -i 's/CONF_SWAPSIZE=100/CONF_SWAPSIZE=2048/g' /etc/dphys-swapfile
sudo /etc/init.d/dphys-swapfile stop
sudo /etc/init.d/dphys-swapfile start
pip install numpy dlib
######################################
echo "================================"
echo "Complete"

# Step 4: Download opencv and opencv_contrib
cd /home/pi
wget -O opencv.zip https://github.com/opencv/opencv/archive/4.0.0.zip && unzip opencv.zip && mv opencv-4.0.0 opencv
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.0.0.zip && unzip opencv_contrib.zip && mv opencv_contrib-4.0.0 opencv_contrib
echo "================================"
echo "Complete"

# Step 5: Compile and install OpenCV with contrib modules
echo "================================"
echo "Compiling and installing OpenCV with contrib modules"
cd /home/pi/opencv
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
-D CMAKE_INSTALL_PREFIX=/usr/local \
-D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
-D ENABLE_NEON=ON \
-D ENABLE_VFPV3=ON \
-D BUILD_TESTS=OFF \
-D OPENCV_ENABLE_NONFREE=ON \
-D INSTALL_PYTHON_EXAMPLES=OFF \
-D BUILD_EXAMPLES=OFF ..

echo "While make -j4 it take along time depend on your processor"
# -j4 refer your processor core
make -j4
make install
sudo ldconfig

sudo sed -i 's/CONF_SWAPSIZE=2048/CONF_SWAPSIZE=100/g' /etc/dphys-swapfile
sudo /etc/init.d/dphys-swapfile stop
sudo /etc/init.d/dphys-swapfile start

cd /home/pi/.virtualenvs/py3cv4/lib/python3.7/site-packages/
ln -s /usr/local/python/cv2/python-3.7/cv2.cpython-37m-arm-linux-gnueabihf.so cv2.so

cd ~

