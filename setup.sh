#!/bin/bash

set -e

# Import repositories from vcs file
vcs import < planner.repos src --recursive 

# Switch to ROS1 mode
cd src
cd mpc_planner
python3 switch_to_ros.py 1
cd ..

cd ros_tools
python3 switch_to_ros.py 1
cd ..

cd guidance_planner
python3 switch_to_ros.py 1
cd ..

cd pedestrian_simulator
python3 switch_to_ros.py 1
cd ..
cd ..

# Install dependencies
sudo apt-get update -y
rosdep update
rosdep install -y -r --from-paths src --ignore-src --rosdistro $ROS_DISTRO
