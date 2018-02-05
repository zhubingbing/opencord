#!/usr/bin/env bash

# cord-bootstrap.sh
# Bootstraps a dev system for CORD, downloads source

set -e -u -o pipefail

CORDDIR="${CORDDIR:-/test/cord}"

REPO_BRANCH="${REPO_BRANCH:-master}"

# Functions
function run_stage {
    echo "==> "$1": Starting"
    $1
    echo "==> "$1": Complete"
}


function bootstrap_ansible() {

  if [ ! -x "/usr/bin/ansible" ]
  then
    echo "Installing Ansible..."
    sudo apt-get update
    sudo apt-get -y install apt-transport-https build-essential curl git python-dev \
                            python-netaddr python-pip software-properties-common sshpass
    sudo apt-add-repository -y ppa:ansible/ansible  # latest supported version
    sudo apt-get update
    sudo apt-get install -y ansible
    sudo pip install gitpython graphviz
  fi
}


function bootstrap_repo() {
  if [ ! -x "/usr/local/bin/repo" ]
  then
    echo "Installing repo..."
    curl -o /tmp/repo 'https://gerrit.opencord.org/gitweb?p=repo.git;a=blob_plain;f=repo;hb=refs/heads/stable' 
    sudo mv /tmp/repo /usr/local/bin/repo
    sudo chmod a+x /usr/local/bin/repo    

  fi

  if [ ! -d "$CORDDIR/build" ]
  then
    echo "Downloading CORD/XOS, branch:'${REPO_BRANCH}'..."
    
    if [ ! -e "${HOME}/.gitconfig" ]
    then
      echo "No ${HOME}/.gitconfig, setting testing defaults"
      git config --global user.name 'Test User'
      git config --global user.email 'test@null.com'
      git config --global color.ui false
    fi
    
    mkdir -p $CORDDIR && cd $CORDDIR
    repo init -u https://gerrit.opencord.org/manifest -b $REPO_BRANCH
    repo sync
  fi
}

run_stage bootstrap_ansible
run_stage bootstrap_repo

