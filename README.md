# Yaskawa ROS1

## Description
This repo allows you to communicate and control the SIA5F Yaskawa robot on ROS1 noetic. Currently, the support for the FS100 controller on ROS2 is not available (refers to [official repo](https://github.com/Yaskawa-Global/motoros2)). If you need to use it with ROS2, you can use the docker container and a ros bridge as described below.

### Using 
If you want to use the packages on your local machine follow the instruction in [local setup](#local-setup), otherwise you can use a docker container as in [docker setup](#docker-setup).

## Local setup
Follow the steps below to set up the package on your local machine. 

1. **Add the repository to your ROS workspace**
    ```bash
    cd ~/my_ros_ws/src
    git clone https://github.com/sara9915/uclv_yaskawa_ros.git
    ```

2. **Install packages dependencies**
   
    The packages listed in `https.rosinstall` have to be installed. You can use `wstool` as follows:
   ```bash
    # In the src of your ros ws
    wstool init #if not already initialized
    wstool merge https://raw.githubusercontent.com/sara9915/uclv_yaskawa_ros/main/https.rosinstall
    wstool update
    ```
   Check dependecies package as follows:
   ```bash
    cd ~/my_ros_ws
    rosdep install -i --from-path src --rosdistro ${ROS_DISTRO} -y
    ```

   Finally, install the following libraries:
   ```bash
    sudo apt-get install libblas-dev liblapack-dev
    ```
   
4. **Build**
    ```bash
    cd ~/my_ros_ws
    catkin build 
    ```


## Docker setup
First, create the docker image:
```bash
docker build -t ros_noetic:yaskawa https://raw.githubusercontent.com/sara9915/uclv_yaskawa_ros/main/Dockerfile
```
Then, create the docker container:
```bash
docker run -it --name yaskawa_container ros_noetic:yaskawa
```
Now you are able to launch the ros nodes.

## Launch nodes


