#!/bin/bash
# Arguments: system_type generate_solver
clear

. /opt/ros/noetic/setup.sh
. workspace/devel/setup.sh

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

  else
    echo "Not building the solver."
  fi
fi

# BUILD_TYPE=Debug # Release, Debug, RelWithDebInfo, MinSizeRel
BUILD_TYPE=RelWithDebInfo # Release, Debug, RelWithDebInfo, MinSizeRel
catkin config --cmake-args -DCMAKE_BUILD_TYPE=$BUILD_TYPE

# catkin build mpc_planner_jackalsimulator
catkin build mpc_planner_jackal
