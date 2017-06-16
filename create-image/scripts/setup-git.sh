#!/bin/bash

iscorrect=

while [ "$iscorrect" != "y" ]; do

    echo -n "First name: "
    read firstname

    echo -n "Last name: "
    read lastname

    echo -n "Email: "
    read email

    echo "Is '\"$lastname, $firstname\" <$email>' correct? (y/n) "
    read iscorrect

done

echo "Configuring git global variables..."

set -x

git config --global http.sslCAInfo "/opt/emc/git-certs/EMC_CA.pem"
git config --global user.name "$lastname, $firstname"
git config --global user.email "$email"
git config --global core.autocrlf input
git config --global fetch.prune true


