#!/bin/bash -eux

# set a fast, german mirror
sed -ie 's,http://us.archive.ubuntu.com/ubuntu/,http://ubuntu.mirror.lrz.de/ubuntu/,g' /etc/apt/sources.list
sed -ie 's,http://security.ubuntu.com/ubuntu,http://ubuntu.mirror.lrz.de/ubuntu/,g' /etc/apt/sources.list

apt-get update
apt-get -y upgrade

# ensure the correct kernel headers are installed
apt-get -y install linux-headers-$(uname -r)

# update package index on boot
cat <<EOF > /etc/init/refresh-apt.conf
description "update package index"
start on networking
task
exec /usr/bin/apt-get update
EOF
