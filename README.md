Building and launching the docker environment
=============================================
1. packer build packer/ops-env.json
2. docker import packer/ops-env.tar ops-env
3. docker run -it -v ~/:/root -v `pwd`:/root/workspace:rw ops-env bash
