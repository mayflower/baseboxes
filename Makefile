default:

all: trusty64-puppet3 trusty64-puppet4 trusty64-ansible

only-lxc:
	@sudo echo -n ""
	packer build -only lxc templates/trusty64-puppet3.json
	packer build -only lxc templates/trusty64-puppet4.json
	packer build -only lxc -var-file=user_variables/ansible17.json templates/trusty64-ansible.json
	packer build -only lxc -var-file=user_variables/ansible19.json templates/trusty64-ansible.json
	packer build -only lxc -var-file=user_variables/ansible2.json templates/trusty64-ansible.json

trusty64-puppet3:
	@sudo echo -n ""
	packer build templates/trusty64-puppet3.json

trusty64-puppet3-without-lxc:
	packer build -except lxc templates/trusty64-puppet3.json

trusty64-puppet3-lxc:
	@sudo echo -n ""
	packer build -only lxc templates/trusty64-puppet3.json

trusty64-puppet4:
	@sudo echo -n ""
	packer build templates/trusty64-puppet4.json

trusty64-puppet4-without-lxc:
	packer build -except lxc templates/trusty64-puppet4.json

trusty64-puppet4-lxc:
	@sudo echo -n ""
	packer build -only lxc templates/trusty64-puppet4.json

trusty64-ansible: trusty64-ansible17 trusty64-ansible19 trusty64-ansible2

trusty64-ansible17:
	@sudo echo -n ""
	packer build -var-file=user_variables/ansible17.json templates/trusty64-ansible.json

trusty64-ansible17-without-lxc:
	packer build -except lxc -var-file=user_variables/ansible17.json templates/trusty64-ansible.json

trusty64-ansible17-lxc:
	@sudo echo -n ""
	packer build -only lxc -var-file=user_variables/ansible17.json templates/trusty64-ansible.json

trusty64-ansible19:
	@sudo echo -n ""
	packer build -var-file=user_variables/ansible19.json templates/trusty64-ansible.json

trusty64-ansible19-without-lxc:
	packer build -except lxc -var-file=user_variables/ansible19.json templates/trusty64-ansible.json

trusty64-ansible19-lxc:
	@sudo echo -n ""
	packer build -only lxc -var-file=user_variables/ansible19.json templates/trusty64-ansible.json

trusty64-ansible2:
	@sudo echo -n ""
	packer build -var-file=user_variables/ansible2.json templates/trusty64-ansible.json

trusty64-ansible2-without-lxc:
	packer build -except lxc -var-file=user_variables/ansible2.json templates/trusty64-ansible.json

trusty64-ansible2-lxc:
	@sudo echo -n ""
	packer build -only lxc -var-file=user_variables/ansible2.json templates/trusty64-ansible.json
