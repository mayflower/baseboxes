class component::packer {
  package { 'bzr': }
  package { 'mercurial': }
  package { 'make': }
  package { 'python-software-properties': } ->
  package { 'software-properties-common': } ->
  apt::ppa { 'ppa:ubuntu-desktop/ubuntu-make': } ->
  package { 'ubuntu-make': } ->
  exec { 'add-new-golang':
    command => '/usr/bin/umake go /home/vagrant/tools/go/go-lang',
    unless  => '/usr/bin/test -d /home/vagrant/tools/go/go-lang',
    user    => 'vagrant',
  }
  file { '/home/vagrant/gocode':
    ensure => directory,
    owner  => vagrant,
    group  => vagrant,
  }
  file { '/home/vagrant/gocode/bin':
    ensure  => directory,
    owner   => vagrant,
    group   => vagrant,
    require => [File['/home/vagrant/gocode']],
  }
  file { '/home/vagrant/bin':
    ensure => directory,
    owner  => vagrant,
    group  => vagrant,
  }
  augeas { 'gopath':
    context => '/files/etc/environment',
    changes => [
      'set GOPATH /home/vagrant/gocode',
      'set PATH /home/vagrant/tools/go/go-lang/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/vagrant/gocode/bin',
    ],
  }
  exec { 'build-packer':
    environment => [
      'GOPATH=/home/vagrant/gocode',
      'GOROOT=/home/vagrant/tools/go/go-lang',
      'PATH=/home/vagrant/tools/go/go-lang/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/vagrant/gocode/bin',
    ],
    command     => '/vagrant/lxc-packer-build.sh /home/vagrant/gocode/bin',
    user        => 'vagrant',
    unless      => [
      '/usr/bin/test -f /home/vagrant/gocode/bin/packer',
      '/usr/bin/test -f /home/vagrant/gocode/bin/packer-builder-lxc'
    ],
    require     => [File['/home/vagrant/gocode/bin'], Exec['add-new-golang'], Augeas['gopath'], Package['make']]
  }
}
