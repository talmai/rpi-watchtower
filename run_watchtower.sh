#!/bin/bash
echo Executing ./rpi-watchtower_ARM$1 "${@:2}"
./rpi-watchtower_ARM$1 "${@:2}"