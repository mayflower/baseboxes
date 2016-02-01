#!/bin/bash -eux

# delete all linux headers
if [[ "$PACKER_BUILDER_TYPE" == "vmware-iso" ]]; then
  sed -i.bak 's/answer AUTO_KMODS_ENABLED_ANSWER no/answer AUTO_KMODS_ENABLED_ANSWER yes/g' /etc/vmware-tools/locations
  sed -i 's/answer AUTO_KMODS_ENABLED no/answer AUTO_KMODS_ENABLED yes/g' /etc/vmware-tools/locations
  dpkg --list | awk '{ print $2 }' | grep linux-headers | grep -v `uname -r` | xargs apt-get -y purge
else
  dpkg --list | awk '{ print $2 }' | grep linux-headers | xargs apt-get -y purge
fi

# this removes specific linux kernels, such as
# linux-image-3.11.0-15-generic but
# * keeps the current kernel
# * does not touch the virtual packages, e.g.'linux-image-generic', etc.
#
dpkg --list | awk '{ print $2 }' | grep 'linux-image-3.*-generic' | grep -v `uname -r` | xargs apt-get -y purge

# delete linux source
dpkg --list | awk '{ print $2 }' | grep linux-source | xargs apt-get -y purge

# delete development packages
dpkg --list | awk '{ print $2 }' | grep -- '-dev$' | xargs apt-get -y purge

# delete compilers and other development tools
if [[ "$PACKER_BUILDER_TYPE" != "vmware-iso" ]]; then
  apt-get -y purge cpp gcc g++
fi

# delete X11 libraries
apt-get -y purge libx11-data xauth libxmuu1 libxcb1 libx11-6 libxext6

# delete obsolete networking
apt-get -y purge ppp pppconfig pppoeconf

# delete oddities
apt-get -y purge popularity-contest

apt-get -y autoremove
apt-get -y clean
rm -rf VBoxGuestAdditions_*.iso VBoxGuestAdditions_*.iso.?
rm -f /tmp/chef*deb
