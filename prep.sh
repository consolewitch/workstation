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
\t--email-address joe@smith.com\n \
\t--full-name JOE SMITH\n \
\t--host-os [win-ubuntu|osx|ubuntu]\n \
\t--skip-host-config\n \
\t--docker\n"

while [ "$1" != "" ]; do
    case "$1" in
        "--")
          shift 1
          break
          ;;
        "--full-name")
          FULL_NAME=$2
          shift 2
          ;;
        "--email-address")
          EMAIL_ADDRESS=$2
          shift 2
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
if [ -z "${HOST_OS}" ] || \
[ -z "${FULL_NAME}" ] || \
[ -z "${EMAIL_ADDRESS}"]
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
export ANSIBLE_HOST_KEY_CHECKING=false
ansible-playbook -i ./ansible/inventory -l provisioner ./ansible/site.yaml \
--extra-vars=" \
full_name=\"${FULL_NAME}\" \n
email_address=\"${EMAIL_ADDRESS}\" \n
" \
$@
# -t ${TAGS} \
