#!/bin/bash

if [ x$PUPPET_VERSION != x'provisionerless' ]; then
  if [ x$PUPPET_VERSION == x'latest' ]; then
    # since we later concatenate the $PUPPEPVERSION variable to the package names
    # an empty string means no specified version -> let apt-get decice -> latest
    PUPPETVERSION=""
  else
    PUPPETVERSION="=$PUPPET_VERSION"
  fi
else
  echo "Building a box without Puppet"
  exit 0
fi

echo "Update locale environment settings"
echo "LC_ALL=en_US.UTF-8" >> /etc/environment
echo "LANG=en_US.UTF-8" >> /etc/environment
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
dpkg-reconfigure locales

# Get codename in order to fetch correct .deb from Puppetlabs
CODENAME=`lsb_release -s -c`
echo "CODENAME: ${CODENAME}"

# fetch .deb + pubkey
echo "Configuring Puppetlabs repository"
wget -O /tmp/puppetlabs-release-pc1-${CODENAME}.deb https://apt.puppetlabs.com/puppetlabs-release-pc1-${CODENAME}.deb
wget -O /tmp/puppetlabs-pubkey.gpg https://apt.puppetlabs.com/pubkey.gpg

# import puppetlabs pubkey
echo "Importing Puppetlabs key"
apt-key add /tmp/puppetlabs-pubkey.gpg
dpkg -i /tmp/puppetlabs-release-pc1-${CODENAME}.deb

# update package lists (including new sources from .deb) + install puppet
echo "Updating package lists"
apt-get update
echo "Installing Puppet (version: ${PUPPET_VERSION})"
apt-get install -y puppet-agent${PUPPETVERSION}
apt-get install -y libaugeas-ruby

# enable puppet agent
puppet agent --enable

# cleanup
rm /tmp/puppetlabs-release-pc1-${CODENAME}.deb
rm /tmp/puppetlabs-pubkey.gpg
