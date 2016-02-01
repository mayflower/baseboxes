#!/bin/bash

if [ x$ANSIBLE_VERSION != x'provisionerless' ]; then
  if [ x$ANSIBLE_VERSION == x'latest' ]; then
    # since we later concatenate the $ANSIBLEVERSION variable to the package names
    # an empty string means no specified version -> let apt-get decice -> latest
    ANSIBLEVERSION=""
  else
    ANSIBLEVERSION="=$ANSIBLE_VERSION"
  fi
else
  echo "Building a box without Ansible"
  exit 0
fi

echo "Configuring Ansible repository"
add-apt-repository -y ppa:rquillo/ansible
echo "Updating package lists"
apt-get update
echo "Installing Ansible (version: ${ANSIBLE_VERSION})"
apt-get install -y ansible${ANSIBLEVERSION}
