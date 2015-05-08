#!/bin/bash

# ensure the correct kernel headers are installed
# and install some basic tools useful on nearly every dev vm
apt-get -y install linux-headers-$(uname -r) git patch vim-nox htop bash-completion wget curl
