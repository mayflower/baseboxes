#!/bin/bash
apt-get -y install language-pack-en-base language-pack-en
update-locale LANG=en_US.UTF-8 LANGUAGE="en_US:en" LC_CTYPE=en_US.UTF-8
source /etc/default/locale
apt-get -y install man-db manpages
