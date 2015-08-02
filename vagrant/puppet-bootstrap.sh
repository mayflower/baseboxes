#!/bin/sh

cd /vagrant/vagrant

sed -i 's#mirror://mirrors.ubuntu.com/mirrors.txt#http://de.archive.ubuntu.com/ubuntu#g;s#ubuntu.mirror.lrz.de#de.archive.ubuntu.com/ubuntu#g' /etc/apt/sources.list
#wget https://apt.puppetlabs.com/pubkey.gpg -q -O- | sudo apt-key add -
apt-get update -qq
[ -x /usr/bin/gem ] || apt-get install -y -q rubygems
gem list | grep deep_merge > /dev/null || gem install --no-rdoc --no-ri deep_merge
[ -x /usr/bin/git ] || apt-get install -y -q git
[ -x /usr/local/bin/r10k ] || gem install --no-rdoc --no-ri r10k

r10k -v info puppetfile install
touch modules/.r10k_stamp
