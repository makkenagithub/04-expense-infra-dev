#!/bin/bash

component=$1
env=$2
echo "Component: $component , Environment: $env"

dnf install ansible -y

ansible-pull -i localhost, -U <git clone backend ansible url> <yaml file(backend.yaml)> -e componet=$component env=$env 
