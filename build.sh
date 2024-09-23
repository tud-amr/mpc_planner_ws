#!/bin/bash
# Arguments: system_type generate_solver
cd /workspace
clear

. /opt/ros/noetic/setup.sh

# Source the workspace if it exists
if [ -f workspace/devel/setup.sh ]; then
  . workspace/devel/setup.sh
fi

# Acados
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/workspace/acados/lib
export ACADOS_SOURCE_DIR="/workspace/acados"

# Generate a solver if enabled
if [ -z "$2" ]; then
  echo "Not rebuilding the solver."
else
  # Check if the argument equals "True" or "true"
  if [ "$2" = "True" ] || [ "$2" = "true" ]; then
    cd src/mpc_planner
    python3 -m poetry run python mpc_planner_$1/scripts/generate_$1_solver.py

    if  [ ${PIPESTATUS[0]} -eq 0 ]
    then
      echo "Solver built successfully."
    else
      echo "Failed to build the solver."
      exit 0
    fi
    cd ../..

  else
    echo "Not building the solver."
  fi
fi

BUILD_TYPE=RelWithDebInfo # Release, Debug, RelWithDebInfo, MinSizeRel
catkin config --cmake-args -DCMAKE_BUILD_TYPE=$BUILD_TYPE

catkin build mpc_planner_$1
