FROM osrf/ros:noetic-desktop-full

# Install Python and other dependencies
RUN apt-get update && apt-get install -y \
    git \
    python3-pip \
    ros-noetic-tf \
    ros-noetic-tf2-ros \
    ros-noetic-tf2-sensor-msgs \
    ros-noetic-actionlib \
    ros-noetic-sensor-msgs \
    && rm -rf /var/lib/apt/lists/*

# Create a catkin workspace
RUN mkdir -p /catkin_ws/src
WORKDIR /catkin_ws/src

# Clone the required repositories
RUN git clone https://github.com/ICRA-2024/abeleinin_gp-navigation.git
RUN git clone https://github.com/merose/diff_drive.git

WORKDIR /catkin_ws

# Install Python dependencies
RUN pip3 install -r src/abeleinin_gp-navigation/requirements.txt

# Build the workspace
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && catkin_make"

# Set up the entrypoint
ENTRYPOINT ["/bin/bash", "-c", "source devel/setup.bash && exec \"$@\"", "--"]
CMD ["bash"]
