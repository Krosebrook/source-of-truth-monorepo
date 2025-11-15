#!/bin/bash

# Define variables
CONTAINER_NAME="persistent_app"
IMAGE_NAME="my_image"
VOLUME_NAME="my_volume"
MOUNT_PATH="/data"

# Create the volume if it doesn't exist
if ! docker volume ls | grep -q $VOLUME_NAME; then
  echo "Creating volume: $VOLUME_NAME"
  docker volume create $VOLUME_NAME
else
  echo "Volume $VOLUME_NAME already exists."
fi

# Check if the container is already running
if docker ps | grep -q $CONTAINER_NAME; then
  echo "Container $CONTAINER_NAME is already running."
else
  # Remove any existing container with the same name
  if docker ps -a | grep -q $CONTAINER_NAME; then
    echo "Removing existing container: $CONTAINER_NAME"
    docker rm -f $CONTAINER_NAME
  fi

  # Run the container with the persistent volume
  echo "Starting container: $CONTAINER_NAME"
  docker run -d --name $CONTAINER_NAME -v $VOLUME_NAME:$MOUNT_PATH $IMAGE_NAME
fi

echo "Setup complete. Container $CONTAINER_NAME is running with persistent volume $VOLUME_NAME."

