#!/bin/bash

set -e

# Import repositories from vcs file
vcs import < planner.repos src --recursive 
# vcs import < lab.repos src --recursive # Uncomment to clone lab packages

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

# Install Acados
git clone https://github.com/acados/acados.git
cd acados
git submodule update --recursive --init
mkdir -p build
cd build
cmake -DACADOS_SILENT=ON ..
make install -j4
make shared_library

if command -v poetry &> /dev/null
then
    echo "Poetry is installed."
else
    cd src/mpc_planner
    poetry lock
    poetry install --no-interaction --no-root
    poetry add -e /acados/interfaces/acados_template
    cd ../..
    echo "Done."
fi

# Install dependencies
sudo apt-get update -y
rosdep update
rosdep install -y -r --from-paths src --ignore-src --rosdistro $ROS_DISTRO
