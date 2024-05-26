#!/bin/bash
INSTALLHASH=$(md5sum install.sh)
git pull
AFTERHASH=$(md5sum install.sh)
if [[ $INSTALLHASH != $AFTERHASH ]]; then
    echo "install.sh has updated, running the new one"
    bash install.sh
else 
    echo "install.sh has is the same, continuing"
    sudo apt install ansible
    sudo apt upgrade ansible
    ansible-galaxy role install geerlingguy.docker
    ansible-playbook personal.yml -K
fi