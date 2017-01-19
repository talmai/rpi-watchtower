# Pull base image
FROM resin/rpi-raspbian:jessie
MAINTAINER Talmai Oliveira <to@talm.ai>
LABEL "ai.talm.rpi-watchtower"="true"

RUN apt-get update && apt-get upgrade

VOLUME ["/var/run/docker.sock"]

COPY rpi-watchtower_ARM5 /
COPY rpi-watchtower_ARM6 /
COPY rpi-watchtower_ARM7 /

ENTRYPOINT ["/rpi-watchtower_ARM5"]