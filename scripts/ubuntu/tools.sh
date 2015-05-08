#!/bin/bash

apt-get update

# install some basic tools useful on nearly every dev vm
apt-get install -y git patch vim-nox htop bash-completion wget curl
