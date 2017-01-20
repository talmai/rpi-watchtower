# Pull base image
FROM resin/rpi-raspbian:jessie
MAINTAINER Talmai Oliveira <to@talm.ai>
LABEL "ai.talm.rpi-watchtower"="true"

RUN apt-get update && apt-get upgrade

COPY rpi-watchtower_ARM5 /
COPY rpi-watchtower_ARM6 /
COPY rpi-watchtower_ARM7 /

ENV DOCKER_API_VERSION 1.24
ENTRYPOINT ["/rpi-watchtower_ARM5"]