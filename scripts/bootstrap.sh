#! /bin/sh

GLUSTERFS_PACKAGE_NAME=glusterfs
GLUSTERFS_LOCAL_PACKAGE=/vagrant/${GLUSTERFS_PACKAGE_NAME}*.txz

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
if ! which -s glusterfs; then
	# Check if there is a local package and use that instead
	[ -f ${GLUSTERFS_LOCAL_PACKAGE} ] && GLUSTERFS_PACKAGE_NAME=${GLUSTERFS_LOCAL_PACKAGE}
	pkg install -y ${GLUSTERFS_PACKAGE_NAME}
fi

service glusterd status >/dev/null 2>&1 || service glusterd start


