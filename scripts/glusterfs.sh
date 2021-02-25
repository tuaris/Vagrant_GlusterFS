#! /bin/sh

if [ $(hostname -s) == "moon" ]; then
	# On moon probe for sun, which should already be up, but only if not already probbed
	if ping -c 1 -Qqo sun >/dev/null 2>&1; then
		gluster peer probe sun
	fi 

	# On moon probe for earth
	if ping -c 1 -Qqo earth >/dev/null 2>&1; then
		gluster peer probe earth
	fi

	# Bootstrap new volume using moon
	if ! gluster volume list | grep -q replicated; then
		gluster volume create replicated replica 3 sun:/gluster/replicated earth:/gluster/replicated moon:/gluster/replicated
		gluster volume start replicated
	fi
fi


