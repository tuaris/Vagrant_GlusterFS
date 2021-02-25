#! /bin/sh

sysrc glusterd_enable="YES"
sysrc -f /boot/loader.conf fuse_load="YES"
kldstat -qn fuse || kldload fuse

if ! mount | grep -q /dev/gpt/gluster; then 
	# If the volume isn't already partitioned and formated, do it
	gpart status -s ada1 >/dev/null 2>&1 || gpart create -s gpt ada1
	diskinfo -s ada1p1 >/dev/null 2>&1 || gpart add -t freebsd-ufs -l gluster ada1
	fstyp /dev/gpt/gluster >/dev/null 2>&1 || newfs /dev/gpt/gluster

	mntent="/dev/gpt/gluster\t/gluster\tufs\trw\t1\t1"; 
	if ! awk '$2 == "/gluster" { found=1 } END {if (found != 1) { exit 1 }}' /etc/fstab; then echo -e "${mntent}" >> /etc/fstab; fi
	
	mkdir -p /gluster
	mount /gluster
fi

mkdir -p /mnt/replicated
mkdir -p /gluster/replicated

# Install and setup gluster on each server
which -s glusterfs || pkg install -y glusterfs
service glusterd status >/dev/null 2>&1 || service glusterd start


