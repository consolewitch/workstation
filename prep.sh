#! /bin/bash

### Add script's home directory to working dir stack
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
pushd="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

### parse arguments
USAGE="usage: prep.bash --option value [--option value...]\n \
\nOptions:
\t--host-os [win-ubuntu|osx|ubuntu]\n \
\t--skip-host-config\n \
\t--docker\n"

while [ "$1" != "" ]; do
    case "$1" in
        "--")
          shift 1
          break
          ;;
        "--host-os")
          HOST_OS=$2
          shift 2
          ;;
        "--skip-host-config")
          SKIP_HOST_CONFIG=True
          shift 1
          ;;
        "--docker")
          BUILD_IN_DOCKER=True
          shift 1
          ;;
        "--help")
          printf "${USAGE}"
          shift 1
          exit 1
          ;;
        *)
          echo "unrecognized argument"
          printf "${USAGE}"
          exit 1
          ;;
    esac
done

### check for required command line arguments.
if [ -z "${HOST_OS}" ]
then
    echo "REQUIRED ARGUMENTS ARE MISSING"
    printf "${USAGE}"
    exit 1
fi

case "$HOST_OS" in
    "ubuntu")
      ./bootstrap-ubuntu.sh
      ;;
    "osx")
      printf "====\nThis requires that you run  the stupid xcode-select --install gui crapplet\n====\n"
      sleep 2
      ./bootstrap-osx.sh
      ;;
    "win-ubuntu")
      printf "====\nNot yet implemented\n====\n"
      exit 1
      ./bootstrap-win-ubuntu.sh
      ;;
esac


### call ansible
export ANSIBLE_HOST_KEY_CHECKING=false #prevent ansible from hanging on yes/no prompt to accept a new host's fingerprint
ansible-playbook -i "127.0.0.1," ../ansible/site.yaml -t ${TAGS} \
--extra-vars=" \
jenkins_api_token=${JENKINS_API_TOKEN} \
jenkins_api_user=${JENKINS_API_USER} \
jenkins_node_name=${JENKINS_NODE_NAME} \
vcenter_password=${VCENTER_PASSWORD} \
vcenter_username=${VCENTER_USERNAME} \
jenkins_executors_count=${JENKINS_EXECUTORS_COUNT} \
jenkins_master_fqdn=${JENKINS_MASTER_FQDN} \
jenkins_master_ip=${JENKINS_MASTER_IP} \
jenkins_master_url=${JENKINS_MASTER_URL} \
jenkins_node_credentials_id=${JENKINS_NODE_CREDENTIALS_ID} \
jenkins_node_labels=\"${JENKINS_NODE_LABELS}\" \
jenkins_node_username=${JENKINS_NODE_USERNAME} \
vcenter_server=${VCENTER_SERVER} \
cpu_count=${CPU_COUNT} \
datacenter_name=${DATACENTER_NAME} \
datastore_name=${DATASTORE_NAME} \
vm_disk_gb=${VM_DISK_GB} \
guest_hostname=${GUEST_HOSTNAME} \
vm_guest_private_key=${VM_GUEST_PRIVATE_KEY}
vm_guest_username=${VM_GUEST_USERNAME} \
vm_ram_mb=${VM_RAM_MB} \
vm_template_name=${VM_TEMPLATE_NAME} \
" $@
