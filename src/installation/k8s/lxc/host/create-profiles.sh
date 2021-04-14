#!/bin/bash

lxc profile create k8s
cat k8s-profile.yaml | lxc profile edit k8s
lxc profile create macvlan
cat net-macvlan-profile.yaml | lxc profile edit macvlan
lxc profile create homekube
cat homekube-profile.yaml | lxc profile edit homekube
