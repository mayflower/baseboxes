#!/bin/bash -eux

# set a fast, german mirror
sed -ie 's,[a-z.]*archive.ubuntu.com,ubuntu.mirror.lrz.de,g' /etc/apt/sources.list
sed -ie 's,security.ubuntu.com,ubuntu.mirror.lrz.de,g' /etc/apt/sources.list

apt-get update
apt-get -y upgrade
