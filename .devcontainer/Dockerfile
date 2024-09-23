# catkin_ws/.devcontainer/Dockerfile
FROM osrf/ros:noetic-desktop-full

ARG USERNAME=r2c1
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y python3-pip git wget

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-rosdep \
    python3-colcon-common-extensions \
    python3-vcstool \
    python3-wstool \
    python3-catkin-tools \
    python3.8-venv \
    iproute2 \
    && rm -rf /var/lib/apt/lists/*

# Setup ROS environment
RUN echo "source /opt/ros/noetic/setup.bash" >> /root/.bashrc
RUN echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/workspace/acados/lib" >> /root/.bashrc
RUN echo "export ACADOS_SOURCE_DIR=/workspace/acados" >> /root/.bashrc

ENV SHELL /bin/bash

# Env vars for the nvidia-container-runtime.
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute
ENV QT_X11_NO_MITSHM 1

# Set the working directory
WORKDIR /workspace
USER $USERNAME
CMD ["/bin/bash"]