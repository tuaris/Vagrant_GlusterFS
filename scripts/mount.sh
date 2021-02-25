#! /bin/sh

if gluster volume status replicated >/dev/null 2>&1; then
	backup_server_paramater="backup-volfile-servers";

	# Add to /etc/fstab
	backup_server_list=$(for host in sun earth moon; do if [ "$host" != $(hostname -s) ]; then echo $host; fi; done | paste -s -d ":" -)
	mntopts="rw,_netdev,${backup_server_paramater}=${backup_server_list},mountprog=/usr/local/sbin/mount_glusterfs,late"
	mntent="$(hostname -s):replicated\t/mnt/replicated\tfusefs\t${mntopts}\t0\t0"; 
	if ! awk '$2 == "/mnt/replicated" { found=1 } END {if (found != 1) { exit 1 }}' /etc/fstab; then echo -e "${mntent}" >> /etc/fstab; fi
	
	mount /mnt/replicated
fi

