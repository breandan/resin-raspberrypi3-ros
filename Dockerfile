FROM maidbot/resin-raspberrypi3-qemu

MAINTAINER Spyros Maniatopoulos spyros@maidbot.co

RUN [ "cross-build-start" ]

# Switch on systemd init system in container and set various other variables
ENV INITSYSTEM="on" \
    TERM="xterm" \
    ROS_DISTRO="indigo"

RUN echo "deb http://packages.ros.org/ros/ubuntu trusty main" > /etc/apt/sources.list.d/ros-latest.list \
    && apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net --recv-key 0xB01FA116

RUN apt-get update \
    && apt-get install -yq --no-install-recommends \
      locales locales-all \
      python-dev python-pip \
      python-rosdep python-rosinstall python-vcstools \
      python-catkin-tools \
    && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

RUN rosdep init \
    && rosdep update

RUN apt-get update \
    && apt-get install -y --fix-missing ros-indigo-ros-base \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y --fix-missing ros-indigo-navigation \
    && rm -rf /var/lib/apt/lists/*

COPY ./ros_entrypoint.sh .

RUN [ "cross-build-end" ]

ENTRYPOINT ["bash", "ros_entrypoint.sh"]

CMD ["bash"]
