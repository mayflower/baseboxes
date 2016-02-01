#!/bin/bash

# ensure the correct kernel headers are installed
# and install some basic tools useful on nearly every dev vm
apt-get -y install linux-kernel-headers git patch vim-nox htop bash-completion wget curl gcc software-properties-common

reboot
