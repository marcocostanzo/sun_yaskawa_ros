ARG FROM_IMAGE=ros:noetic-ros-base
ARG OVERLAY_WS=/yaskawa_ws


FROM $FROM_IMAGE 

# Usefull packages
RUN apt update -y \
    && apt upgrade -y \
    && apt install -y \
    python3-pip \
    git \
    python3-catkin-tools \ 
    ros-noetic-catkin \
    libblas-dev \ 
    liblapack-dev \ 
    && pip install vcstool 
    
################# Clone required repositories ######################
ARG OVERLAY_WS
WORKDIR $OVERLAY_WS/src


# Clone sun_yaskawa_ros
RUN echo "\
repositories: \n\
  sun_yaskawa_ros: \n\
    type: git \n\
    url: https://github.com/marcocostanzo/sun_yaskawa_ros.git \n\
    version: main \n\
" > ../overlay.repos
RUN vcs import ./ < ../overlay.repos

# Clone sun_robot_ros
RUN echo "\
repositories: \n\
  sun_robot_ros: \n\
    type: git \n\
    url: https://github.com/marcocostanzo/sun_robot_ros.git \n\
    version: master \n\
" > ../overlay.repos
RUN vcs import ./ < ../overlay.repos

# Clone sun_robot_lib
RUN echo "\
repositories: \n\
  sun_robot_lib: \n\
    type: git \n\
    url: https://github.com/marcocostanzo/sun_robot_lib.git \n\
    version: separate_clik \n\
" > ../overlay.repos
RUN vcs import ./ < ../overlay.repos

# Clone sun_math_toolbox
RUN echo "\
repositories: \n\
  sun_math_toolbox: \n\
    type: git \n\
    url: https://github.com/marcocostanzo/sun_math_toolbox.git \n\
    version: master \n\
" > ../overlay.repos
RUN vcs import ./ < ../overlay.repos


# Clone ros_toon
RUN echo "\
repositories: \n\
  ros_toon: \n\
    type: git \n\
    url: https://github.com/marcocostanzo/ros_toon.git \n\
    version: master \n\
" > ../overlay.repos
RUN vcs import ./ < ../overlay.repos

# Clone sun_ros_msgs
RUN echo "\
repositories: \n\
  sun_ros_msgs: \n\
    type: git \n\
    url: https://github.com/marcocostanzo/sun_ros_msgs.git \n\
    version: master \n\
" > ../overlay.repos
RUN vcs import ./ < ../overlay.repos

# Clone sun_traj_lib
RUN echo "\
repositories: \n\
  sun_traj_lib: \n\
    type: git \n\
    url: https://github.com/marcocostanzo/sun_traj_lib.git \n\
    version: master \n\
" > ../overlay.repos
RUN vcs import ./ < ../overlay.repos

######################################################


# copy manifests for caching
WORKDIR /opt
RUN mkdir -p /tmp/opt && \
    find ./ -name "package.xml" | \
      xargs cp --parents -t /tmp/opt && \
    find ./ -name "CATKIN_IGNORE" | \
      xargs cp --parents -t /tmp/opt || true


# install overlay dependencies
ARG OVERLAY_WS
WORKDIR $OVERLAY_WS
RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
    apt-get update && rosdep install --from-paths src --ignore-src -r -y \
    && rm -rf /var/lib/apt/lists/* 

# build overlay source
RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
    catkin build 

RUN echo "source devel/setup.bash" >> ~/.bashrc

ARG OVERLAY_WS
WORKDIR $OVERLAY_WS  

