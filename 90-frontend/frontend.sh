#!/bin/bash

component=$1
env=$2
echo "Component: $component , Environment: $env"

dnf install ansible -y

ansible-pull -i localhost, -U <git clone frontend ansible url> <yaml file(frontend.yaml)> -e component=$component env=$env 
