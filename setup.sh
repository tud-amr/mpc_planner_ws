#!/bin/bash

set -e

# Import repositories from vcs file
echo "Cloning repositories ..."
mkdir -p src
vcs import < planner.repos src --recursive 
# vcs import < lab.repos src --recursive # Uncomment to clone lab packages
echo "Done cloning repositories."

# Switch to ROS1 mode
echo "Switching to ROS 1 ..."
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
echo "Done, all repos are in ROS1 mode."

# Install Acados
if [ ! -d "/workspace/acados/build" ]; then
    echo "Installing Acados ..."
    git clone https://github.com/acados/acados.git
    cd acados
    git submodule update --recursive --init
    mkdir -p build
    cd build
    cmake -DACADOS_SILENT=ON ..
    make install -j4
    cd ../bin
    wget https://github.com/acados/tera_renderer/releases/download/v0.0.34/t_renderer-v0.0.34-linux
    mv t_renderer-v0.0.34-linux t_renderer
    chmod +x t_renderer
    cd ../..
fi
echo "Acados is installed."

install_poetry() {
    echo "Installing Poetry ..."
    pip install poetry
    echo "Installed Poetry succesfully."
}

echo "Checking the poetry installation"
if ! command -v python3 -m poetry &> /dev/null
then
    echo "Poetry is not installed."
    if [[ "$1" == "-y" ]]; then
        install_poetry
    else
         # Ask the user for confirmation
        read -p "Do you want to install Poetry now? (y/n): " response
        case "$response" in
            [yY][eE][sS]|[yY])
                install_poetry
                ;;
            [nN][oO]|[nN])
                echo "Installation aborted."
                exit 0
                ;;
            *)
                echo "Invalid input. Please enter y or n."
                exit 0
                ;;
        esac
    fi
fi

echo "Poetry is installed."
cd src/mpc_planner
python3 -m poetry lock
python3 -m poetry install --no-interaction --no-root
python3 -m poetry add -e /workspace/acados/interfaces/acados_template
cd ../..
echo "Done."


# Install dependencies
sudo apt-get update -y
rosdep update
rosdep install -y -r --from-paths src --ignore-src --rosdistro $ROS_DISTRO
