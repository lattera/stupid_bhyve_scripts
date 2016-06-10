#!/usr/local/bin/zsh

. /usr/home/shawn/bhyve/bhyve.zsh

name="hbsd-scratch"
zvol="rpool/bhyve/hbsd-scratch/disk-01"
port="5900"
tap="tap1"
#iso="/ISO/HardenedBSD/disc1.iso"
vncwait=1
#tablet=1

do_the_thing
exit ${?}
