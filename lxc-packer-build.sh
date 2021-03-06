#!/bin/bash

if [ "x${1}" == "x" ]; then
  echo "Please add as first Parameter the path"
  echo "where the executible should be copied"
  exit
fi

EXEC_TARGET_PATH=$1

if [ ! -d $EXEC_TARGET_PATH ] || [ ! -w $EXEC_TARGET_PATH ]; then
  echo "Target Directory $EXEC_TARGET_PATH "
  echo "don't exists and/or is not writeable!"
  exit
fi

echo "--------------------------------------------------------------------------------"
echo "Get packer source code"
if [ ! -d $GOPATH/src/github.com/mitchellh/packer ]; then
  (mkdir -p $GOPATH/src/github.com/mitchellh && \
   cd $GOPATH/src/github.com/mitchellh && \
   git clone https://github.com/mayflower/packer.git && \
   cd packer && git checkout add_lxc_to_post-processor_vagrant)
fi
echo "--------------------------------------------------------------------------------"
echo "Compile packer source code"
(cd $GOPATH/src/github.com/mitchellh/packer && \
 make updatedeps && \
 make updatedeps && \
 eval `go env` && \
 mkdir -p pkg/${GOARCH}_${GOOS} && \
 XC_OS="$GOOS" XC_ARCH="$GOARCH" make bin)
echo "--------------------------------------------------------------------------------"
echo "Get packer-builder-lxc software"
if [ ! -d $GOPATH/src/github.com/ustream/packer-builder-lxc ]; then
  (mkdir -p $GOPATH/src/github.com/ustream && \
   cd $GOPATH/src/github.com/ustream && \
   git clone https://github.com/ustream/packer-builder-lxc.git)
fi
echo "--------------------------------------------------------------------------------"
echo "Compile packer-builder-lxc"
(cd $GOPATH/src/github.com/ustream/packer-builder-lxc && \
 gox -os=linux -arch=amd64 -output=pkg/{{.OS}}_{{.Arch}}/packer-builder-lxc)
echo "--------------------------------------------------------------------------------"
echo "Copy Binaries to the executable path"
(eval `go env` && \
 cp $GOPATH/src/github.com/mitchellh/packer/pkg/${GOOS}_${GOARCH}/* $EXEC_TARGET_PATH && \
 cp $GOPATH/src/github.com/ustream/packer-builder-lxc/pkg/${GOOS}_${GOARCH}/* $EXEC_TARGET_PATH)
