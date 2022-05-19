FROM nvidia/cudagl:10.2-devel-ubuntu16.04

RUN apt-get update -y
RUN apt-get install -y git cmake build-essential libusb-1.0

# Install libuvc
RUN git clone https://github.com/ktossell/libuvc && \
    cd libuvc && mkdir build && cd build && cmake .. && make && make install

# Pangolin Deps
RUN apt-get install -y libglew-dev && \
    apt-get install -y ffmpeg libavcodec-dev libavutil-dev libavformat-dev libswscale-dev && \
    apt-get install -y libjpeg-dev libpng12-dev libtiff5-dev libopenexr-dev
    
# Install Pangolin
RUN git clone https://github.com/stevenlovegrove/Pangolin.git && \
    cd Pangolin && \
    git checkout 7987c9ba6b6c2c46fdcf50baae28bfa4f8352696 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j 
    
        
# Get dart examples
RUN git clone https://github.com/matthuisman/gdrivedl && \
    apt-get install -y python3
    
RUN python3 gdrivedl/gdrivedl.py 'https://drive.google.com/uc?export=download&id=1HXvOsUcgS6THn17hME-SKQU3FQVUJr_z'


# MOTHER FUVK
# Install ASSIMP
# RUN git clone --depth 1 https://github.com/assimp/assimp.git
# RUN cd assimp && \
#     sed 's/VERSION 3.10/VERSION 3.5/g' CMakeLists.txt > CMakeLists2.txt && \
#    rm -f CMakeLists.txt && mv CMakeLists2.txt CMakeLists.txt && \
#    echo "$( cat CMakeLists.txt )" && \
#    mkdir build && cd build && \
#    cmake .. && \ 
#    make -j 

RUN apt-get install -y libassimp-dev


# Install Dart deps
RUN apt-get install -y freeglut3-dev libeigen3-dev libmatheval-dev libpng-dev libjpeg-dev libtinyxml-dev wget

# Clone Dart
RUN git clone https://github.com/tschmidt23/dart
RUN tar -xzf dartExample.tar.gz -C .


# Edit CMake and shit
RUN cd dart && \
    sed 's/add_definitions(-std=c++11)/add_definitions(-std=c++14)/g' CMakeLists.txt > CMakeLists2.txt && \
    sed '228 d' CMakeLists2.txt > CMakeLists3.txt && \
    cp CMakeLists3.txt CMakeLists.txt
        
# Copy helper_math over
RUN wget https://raw.githubusercontent.com/NVIDIA/cuda-samples/master/Common/helper_math.h && \
    cp helper_math.h /dart/src/util/ 

# Build Dart
RUN cd dart && \
    git checkout 3e44530adac0a32f051cd9098840f92a2c37856c && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j

    
# Build dart examples
RUN cd /usr/include && \
    ln -sf eigen3/Eigen Eigen && \
    ln -sf eigen3/unsupported unsupported 
    
RUN cd dartExample && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j 


    

    
    
    

    
