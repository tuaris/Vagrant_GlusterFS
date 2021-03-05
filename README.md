# Vagrantfile to Test GlusterFS on FreeBSD

This will spin up a 3 node GlusterFS cluster with a replicated volume on FreeBSD.
for a complete explanation of what's going on take a look at the article:

[Setup a Three Node Replicated GlusterFS Cluster on FreeBSD](http://www.unibia.com/unibianet/freebsd/setup-three-node-replicated-glusterfs-cluster-freebsd)

## Requirements

- Virtualbox
- Vagrant
- At least 16 GB of RAM and 32 GB of free space.

## Quick Start

Clone this repository if not already done.

```
git clone https://github.com/tuaris/Vagrant_GlusterFS
```

Change into the repository root directory and run `vagrant up`.  Follow any
on-screen instructions to continue.

```
cd Vagrant_GlusterFS
vagrant up
```

After all machines are spun up you'll be asked to run `vagrant provision` to complete
the setup.

```
vagrant provision
```

Afterwards you can optionally re-run `vagrant provision` with the `--with-provision mounts` 
flag to create the FUSE-FS mount points on each server.

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

## GlusterFS Package

You can use your own GlusterFS package (like one you can build from my [Gluster Ports](https://github.com/tuaris/freebsd-glusterfs)) 
instead of what's currently available at the official pkg repos.  To do this place 
your custom built package in the root directory of this repository.  The package 
must follow the following naming scheme in order to be picked up:

```
glusterfs*.txz
```

Make sure you only have one package, otherwise pkg will attempt to install anything
that matches the above wildcard.

## Advanced Options

If you need to pass flags to the Gluster daemons use the `sysrc` tool and restart
the service. For example, you want to enable extra debug information in the logs:

```
sysrc glusterd_flags="--log-level=DEBUG"
service glusterd restart
```

