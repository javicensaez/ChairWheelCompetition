FROM  javicensaez/acroba_core:1.0

USER root
RUN /bin/bash -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN /bin/bash -c "curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -"
RUN sudo apt-get update || echo


RUN rosdep init &&\
    rosdep update --as-root apt:false

RUN sudo apt-get install -y --no-install-recommends build-essential git cmake libasio-dev
RUN sudo apt install -y --no-install-recommends ros-noetic-teleop-twist-keyboard 
RUN sudo apt install -y --no-install-recommends ros-noetic-joint-state-publisher-gui
RUN sudo apt install -y --no-install-recommends ros-noetic-ros-controllers


USER ubuntu

# Copy acroba workspace into docker
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && \
                  mkdir -p /home/ubuntu/agilex_ws/src && \
                  cd /home/ubuntu/agilex_ws/src && \
                  git clone https://github.com/agilexrobotics/ugv_sdk.git &&\
                  git clone https://github.com/agilexrobotics/tracer_ros.git &&\
		  git clone https://github.com/aws-robotics/aws-robomaker-bookstore-world &&\
                  cd .. &&\
                  catkin_make"

RUN /bin/bash -c "echo 'source /home/ubuntu/agilex_ws/devel/setup.bash' >> /home/ubuntu/.bashrc"



