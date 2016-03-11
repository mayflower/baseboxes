#!/bin/bash
set -e

export NO_COLOR='\033[0m'
export OK_COLOR='\033[32;01m'
export ERROR_COLOR='\033[31;01m'
export WARN_COLOR='\033[33;01m'

log() {
  echo "    ${1}" >&2
}

warn() {
  echo -e "${WARN_COLOR}==> ${1}${NO_COLOR}"
}

info() {
  echo -e "${OK_COLOR}==> ${1}${NO_COLOR}"
}

debug() {
  [ ! $DEBUG ] || echo "    [DEBUG] ${1}" >&2
}

# DIRTY HACK to prevent duplicate entry in /etc/resolv.conf
sed -ie '5,$d' /etc/resolv.conf

export VAGRANT_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key"

info "Preparing vagrant user..."

# Create vagrant user
if $(grep -q 'vagrant' /etc/shadow); then
  log 'Skipping vagrant user creation'
elif $(grep -q 'ubuntu' /etc/shadow); then
  debug 'vagrant user does not exist, renaming ubuntu user...'
  mv /home/{ubuntu,vagrant}
  usermod -l vagrant -d /home/vagrant ubuntu
  groupmod -n vagrant ubuntu
  echo -n 'vagrant:vagrant' | chpasswd
  log 'Renamed ubuntu user to vagrant and changed password.'
elif [ ${DISTRIBUTION} = 'centos' ]; then
  debug 'Creating vagrant user...'
  useradd --create-home -s /bin/bash -u 1000 vagrant
  echo -n 'vagrant:vagrant' | chpasswd
  sed -i 's/^Defaults\s\+requiretty/# Defaults requiretty/' /etc/sudoers
else
  debug 'Creating vagrant user...'
  useradd --create-home -s /bin/bash vagrant
  adduser vagrant sudo
  echo -n 'vagrant:vagrant' | chpasswd
fi

# Configure SSH access
if [ -d /home/vagrant/.ssh ]; then
  log 'Skipping vagrant SSH credentials configuration'
else
  debug 'SSH key has not been set'
  mkdir -p /home/vagrant/.ssh
  echo $VAGRANT_KEY > /home/vagrant/.ssh/authorized_keys
  chown -R vagrant: /home/vagrant/.ssh
  log 'SSH credentials configured for the vagrant user.'
fi

# Enable passwordless sudo for the vagrant user
if [ -f /etc/sudoers.d/vagrant ]; then
  log 'Skipping sudoers file creation.'
else
  debug 'Sudoers file was not found'
  echo "vagrant ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vagrant
  chmod 0440 /etc/sudoers.d/vagrant
  log 'Sudoers file created.'
fi
