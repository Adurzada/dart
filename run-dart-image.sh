# Sample script to run a command in a Docker container

# Usage Example:
# ./run_docker.sh turtlebot3_base "roslaunch turtlebot3_gazebo turtlebot3_world.launch"

# Or for interactive shell:
# ./run_docker.sh turtlebot3_base

xhost + local:docker > /dev/null

# Define Docker volumes and environment variables
DOCKER_VOLUMES="
--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
--volume="/dev:/dev" \
"

# Must pass privileged flag so docker can find gpus without needing
# then explicitly defined

# Also mount Xdefaults for gtk scaling
DOCKER_ENV_VARS="
--env="NVIDIA_DRIVER_CAPABILITIES=all" \
--env="DISPLAY" \
--env="QT_X11_NO_MITSHM=1" \
--gpus all \
--privileged \
"

DOCKER_ARGS=${DOCKER_VOLUMES}" "${DOCKER_ENV_VARS}

# Run the command
docker run -it --net=host $DOCKER_ARGS $1 bash 



