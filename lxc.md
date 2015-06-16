# HOWTO Pack LXC vagrant box

## Prerequired

1. Compile the packer-builder-lxc from https://github.com/mayflower/packer-builder-lxc.git
 * Install go (use own GOPATH) and clone the repository under src/github.com/ustream/packer-builder-lxc to compile it with the gox tool.
1. Compile the branch ```add_lxc_to_post-processor_vagrant``` from https://github.com/mayflower/packer.git with ```make dev``` and copy the files from bin directory to your bin dir.
2. Move the compiled packer-bulder-lxc file to execute path

## Packer lxc box

Current only tested under Ubuntu trusty.
```
sudo echo
packer build -only lxc templates/trusty64-puppet3.json
```
