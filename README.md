# puppet-module-selinux

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
1. [Setup - The basics of getting started with selinux](#setup)
   * [What selinux affects](#what-selinux-affects)
   * [Setup requirements](#setup-requirements)
   * [Beginning with selinux](#beginning-with-selinux)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Module description

This module manages SELinux and by default will enable it.

## Setup

### What selinux affects

Manages SELinux and its configuration. It manages the file
`/etc/selinux/config` and optionally manages the
`policycoreutils-python` package.

### Setup requirements
This module requires `stdlib`.

### Beginning with selinux

#### Examples

##### Enable SELinux

```puppet
include ::selinux
```

##### Disable SELinux

```puppet
class { '::selinux':
  mode => 'disabled',
}
```

## Usage

Minimal and normal usage.

```puppet
include ::selinux
```

## Limitations

This module has been tested to work on the following systems with Puppet
versions 5 and 6 with the Ruby version associated with those releases.
Please see `.travis.yml` for a full matrix of supported versions. This
module aims to support the current and previous major Puppet versions.

 * EL 5
 * EL 6
 * EL 7

## Development

See `CONTRIBUTING.md` for information related to the development of this
module.
