Building a workstation vm
=========================
* Bring up a ubuntu 16.04 virtual machine in a vm host of [your choice](www.virtualbox.com)
* Clone this repo into your user directory
* run the `prep.sh` script with the appropriate arguments


Building and launching the docker environment
=============================================
1. packer build packer/ops-env.json
2. docker import packer/ops-env.tar ops-env
3. docker run -it -v ~/:/root -v `pwd`:/root/workspace:rw ops-env bash
