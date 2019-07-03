# Docker Ubiquiti UniFi Controller

Builds a Docker image for running the Ubiquiti UniFi Controller inside of Docker.

## Ports Exposed

- 8080
- 8443

## About

The base image is from the official Docker library ubuntu:16.04. The default command is to start the UniFi Controller, which was derived from looking at the /etc/init.d/unifi script that the unifi software from Ubiquiti installs in it's Linux package. Added to the cmd line is the '-nodetach' flag so that it runs in forground mode and is the 1st process in the Docker container.

Pull requests welcome!
