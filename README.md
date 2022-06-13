# Docker Ubiquiti UniFi Controller

Builds a Docker image for running the Ubiquiti UniFi Controller inside of Docker.

## Ports Exposed

- 8080
- 8443

## Howto build

`docker build . -t ubiquiti-controller`

## Howto run

In order for it to work well, it requires:
- to have access to the host's network namespace
- to have a specific place (volume) to store its data (optional)

```
docker run -d \
    --net host \
    --restart unless-stopped \
    --name ubiquiti \
    -v "$(pwd)"/volume-data:/var/lib/unifi \
    ubiquiti-controller
```

## About

The base image is from the official Docker library ubuntu:18.04. The default command is to start the UniFi Controller, which was derived from looking at the /etc/init.d/unifi script that the unifi software from Ubiquiti installs in it's Linux package. Added to the cmd line is the '-nodetach' flag so that it runs in forground mode and is the 1st process in the Docker container.

Pull requests welcome!

https://hub.docker.com/r/jbronson29/ubiquiti-controller
