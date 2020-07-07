#!/bin/bash

mkdir /etc/exports.d
cp kubedata-nfs.exports /etc/exports.d/

mkdir /srv/nfs/kubedata -p
apt install nfs-server -y
service nfs-server start
exportfs -rav
