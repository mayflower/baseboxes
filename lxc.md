# HOWTO Pack LXC vagrant box

## Prerequired

1. Install go in version >= 1.4 and config your go environment.
  * Create a directory for the go development.
  * Set environment GOPATH to this directory.
  * Install package for git, Bazaar and Mercurial.
2. Prepare or select a writeable directory in your PATH to install the binaries
3. Add the bin directory in your GOPATH to your PATH environment.
3. Call the shell script lxc-packer-build.sh with the target path as first parameter.

## Packer lxc box

Current only tested under Ubuntu trusty.
```
sudo echo
packer build -only lxc templates/trusty64-puppet3.json
```
