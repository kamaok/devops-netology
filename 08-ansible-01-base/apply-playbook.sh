#!/usr/bin/env bash

echo "Starting containers..."
docker run --rm --name centos7 -d -it pycontribs/centos:7 bash
docker run --rm --name ubuntu -d -it pycontribs/ubuntu:latest bash
docker run --rm --name fedorahost -d -it pycontribs/fedora bash

ansible-playbook -i inventory/prod.yml site.yml --ask-vault-password

echo "Deleting containers..."
for name in centos7 ubuntu fedorahost; do echo "Stopping and deleting $name container"; docker stop $name; done
