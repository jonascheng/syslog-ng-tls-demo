#!/bin/bash

wget -qO - https://ose-repo.syslog-ng.com/apt/syslog-ng-ose-pub.asc | sudo apt-key add -

echo "deb https://ose-repo.syslog-ng.com/apt/ stable ubuntu-focal" | sudo tee -a /etc/apt/sources.list.d/syslog-ng-ose.list

apt-get update -y
apt-get install -y syslog-ng-core 
#apt-get install -y syslog-ng-scl
