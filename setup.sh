#!/bin/bash

set -e

# Import repositories from vcs file
mkdir -p src
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

install_poetry() {
    echo "Installing Poetry..."
    python3 -m pip install poetry
    echo "Installed Poetry succesfully."
}

if command -v poetry &> /dev/null
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
poetry lock
poetry install --no-interaction --no-root
poetry add -e /acados/interfaces/acados_template
cd ../..
echo "Done."


# Install dependencies
sudo apt-get update -y
rosdep update
rosdep install -y -r --from-paths src --ignore-src --rosdistro $ROS_DISTRO
