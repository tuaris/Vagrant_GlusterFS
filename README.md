# Vagrantfile to Test GlusterFS on FreeBSD

This will spin up a 3 node GlusterFS cluster with a replicated volume on FreeBSD.
for a complete explanation of what's going on take a look at the article:

[Setup a Three Node Replicated GlusterFS Cluster on FreeBSD](http://www.unibia.com/unibianet/freebsd/setup-three-node-replicated-glusterfs-cluster-freebsd)

## Requirements

- Virtualbox
- Vagrant
- At least 16 GB of RAM and 32 GB of free space.

## Quick Start

Clone this repository and then run `vagrant up`.  Follow the on-screen instructions
to continue.

```
git clone https://github.com/tuaris/Vagrant_GlusterFS
cd Vagrant_GlusterFS
vagrant up
```

After all machines are spun up you'll be asked to run `vagrant provision` to complete
the setup.

```
vagrant provision
```

Optionally you can specify `--with-provision mounts` to also create the FUSE-FS
mount points on each server.

```
vagrant provision --with-provision mounts
```

Log into any one of the servers (sun, earth, or moon) to explore:

```
vagrant ssh sun
```

When you are done playing with Gluster, run `vagrant destroy -fg`

## Customizing

If for whatever reason the default values need to be changed, you can edit the
lines at the top of the `Vagrantfile` to suit your needs.


The domain component of the hostname for each virtual machines
```
DOMAIN = "gluster.internal.local"
```

GlusterFS cluster network.
```
NETWORK = "172.16.28"
```

The FreeBSD base image used to build the machine.
```
BSD_IMAGE = "freebsd/FreeBSD-12.2-RELEASE"
```

Size of the GlusterFS brick.
```
BRICK_SIZE_G = 2
```

Location you wish to store the VDI file for the GlusterFS brick.  The default
value below stores it in the same directory as the `Vagrantfile`.
```
BRICK_VDI_PATH = "."
```

## Advanced Options

If you need to pass flags to the Gluster daemons use the `sysrc` tool and restart
the service. For example, you want to enable extra debug information in the logs:

```
sysrc glusterd_flags="--log-level=DEBUG"
service glusterd restart
```

