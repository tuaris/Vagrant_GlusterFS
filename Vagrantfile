# -*- mode: ruby -*-
# vi: set ft=ruby :

DOMAIN = "gluster.internal.local"
NETWORK = "172.16.28"
BSD_IMAGE = "freebsd/FreeBSD-12.2-RELEASE"
BRICK_SIZE_G = 2
BRICK_VDI_PATH = "."

SERVERS = [
  { :name => "sun", :host =>  "10" },
  { :name => "earth", :host=>  "11" },
  { :name => "moon", :host =>  "12" }
]

Vagrant.configure("2") do |config|

  config.vagrant.plugins = ["vagrant-hosts"]
  
  SERVERS.each do |server|
  	config.vm.define server[:name] do |conf|
  		conf.vm.box = BSD_IMAGE
  		conf.vm.network "private_network", ip: "#{NETWORK}.#{server[:host]}"
  		conf.vm.hostname = "#{server[:name]}.#{DOMAIN}"
  		
  		gluster_disk_image = "#{BRICK_VDI_PATH}/#{server[:name]}_gluster.vdi"
  		conf.vm.provider "virtualbox" do |vb|
	  	  unless File.exist?(gluster_disk_image)
	  	  	vb.customize ['createhd', '--filename', gluster_disk_image, '--size', BRICK_SIZE_G * 1024]
	  	  end
	  	  vb.customize ['storageattach', :id, '--storagectl', 'IDE Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', gluster_disk_image]
		end

  	end  	
  end

  config.vm.provision :hosts do |provisioner|
	provisioner.autoconfigure = true
	provisioner.sync_hosts = true
	provisioner.add_localhost_hostnames	= false
  end
  
  config.trigger.after :up  do |trigger|
	trigger.only_on = "moon"
  	trigger.info = "Run `vagrant provision`to finish setting up GlusterFS"
  end
  
  config.trigger.after :provision  do |trigger|
	trigger.only_on = "moon"
	trigger.info = "Setting up GlusterFS peers and volume"
	trigger.run_remote = {path: "scripts/glusterfs.sh"}
  end
  
  config.vm.provision "bootstrap", type: "shell", path: "scripts/bootstrap.sh"
  config.vm.provision "mounts", type: "shell", path: "scripts/mount.sh", run: "never"
end
