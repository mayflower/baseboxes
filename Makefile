default:

all: trusty64-puppet3

trusty64-puppet3:
	@sudo echo -n ""
	packer build templates/trusty64-puppet3.json

trusty64-puppet3-without-lxc:
	packer build -only virtualbox-iso,vmware-iso templates/trusty64-puppet3.json

trusty64-puppet3-lxc:
	@sudo echo -n ""
	packer build -only lxc templates/trusty64-puppet3.json