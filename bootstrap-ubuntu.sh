#! /bin/bash

################################################
# Update package manager
################################################

sudo apt update -y
sudo apt upgrade -y

#################################################
# install python and ansible
#################################################

sudo apt install python python-pip -y
if [ ! -f /usr/local/bin/ansible ]; then pip install ansible; fi
