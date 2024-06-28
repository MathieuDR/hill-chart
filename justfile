# Define the default recipe to list available commands
default:
    @just --list

# Variables
IMAGE_NAME := "ghcr.io/mathieudr/hill-chart"
TAG := "latest"
DOCKERFILE := "Dockerfile"

# Recipe to build docker
build:
    @echo "Building Docker image..."
    docker build -t {{IMAGE_NAME}}:{{TAG}} -f {{DOCKERFILE}} .

push:
    @echo "Logging in to GitHub Container Registry..."
    echo $GITHUB_PAT | docker login ghcr.io -u $GITHUB_USERNAME --password-stdin

    @echo "Pushing Docker image to GitHub Container Registry..."
    docker push {{IMAGE_NAME}}:{{TAG}}

