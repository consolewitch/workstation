#! /bin/bash

################################################
# Update package manager
################################################

sudo apt update
sudo apt upgrade

#################################################
# install python and ansible
#################################################

sudo apt install python python-pip
pip install --upgrade pip
if [ ! -f /usr/local/bin/ansible ]; then pip install ansible; fi 
