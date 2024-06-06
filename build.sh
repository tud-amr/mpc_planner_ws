clear

. /opt/ros/noetic/setup.sh
. workspace/devel/setup.sh

# BUILD_TYPE=Debug # Release, Debug, RelWithDebInfo, MinSizeRel
BUILD_TYPE=RelWithDebInfo # Release, Debug, RelWithDebInfo, MinSizeRel
catkin config --cmake-args -DCMAKE_BUILD_TYPE=$BUILD_TYPE

# catkin build mpc_planner_jackalsimulator
catkin build mpc_planner_jackal
