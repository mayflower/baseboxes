# HOWTO Pack LXC vagrant box

## Prerequired

1. Install go and config your go environment.
  * Create a directory for the go development.
  * Set environment GOPATH to this directory.
  * Install package for git and Bazaar.
2. go get ustream/packer-builder-lxc
3. ```(cd $GOPATH/src/github.com/ustream/packer-builder-lxc && gox -os=linux -arch=amd64 -output=pkg/{{.OS}}_{{.Arch}}/packer-builder-lxc)```
4. Compile the packer-builder-lxc from https://github.com/mayflower/packer-builder-lxc.git
 * ```(mkdir -p $GOPATH/src/github.com/mitchellh && cd $GOPATH/src/github.com/mitchellh && git clone https://github.com/mayflower/packer.git && cd packer && git checkout add_lxc_to_post-processor_vagrant)```
 * ```(cd $GOPATH/src/github.com/mitchellh/packer && make updatedeps && eval `go env` && mkdir -p pkg/${GOARCH}_${GOOS} && XC_OS="$GOOS" XC_ARCH="$GOARCH" make bin)```
5. Move the compiled packer binary files to a directory in execute path (```$EXEC_TARGET_PATH```)
 * ```(eval `go env` &&  cp $GOPATH/src/github.com/mitchellh/packer/pkg/${GOARCH}_${GOOS}/* $EXEC_TARGET_PATH && cp $GOPATH/src/github.com/ustream/packer-builder-lxc/pkg/${GOARCH}_${GOOS}/* $EXEC_TARGET_PATH)```

## Packer lxc box

Current only tested under Ubuntu trusty.
```
sudo echo
packer build -only lxc templates/trusty64-puppet3.json
```
