# selinux module
===

# Compability

This module has been tested to work on the following systems with Puppet
versions 4 and 5. For an exact matrix of Puppet and Ruby versions, please
consult `.travis.yml`.

 * EL 5
 * EL 6
 * EL 7

## Documented with Puppet Strings

[Puppet Strings documentation](http://ghoneycutt.github.io/puppet-module-selinux/)

# Class Descriptions
## Class `selinux`

### Description

The selinux class manages SELinux for enterprise linux systems. By default, it enables SELinux. To use, simply
`include ::selinux`.


### Parameters

See man page selinux(8) for more information regarding the configuration settings.

---
####  mode (type: String)
Operation mode of SELinux, valid values are 'enforcing', 'permissive' and 'disabled'.

- *Default*: 'disabled'

---
#### type (type: String)
The type of policies in use, valid values are 'targeted' and 'strict'.

- *Default*: 'targeted'

---
#### setlocaldefs (type: String, Integer or Undef)
String or Integer to pass to SETLOCALDEFS option. Valid values are `0`
and `1`. If left undef, then the SETLOCALDEFS section is not included in
the `config_file`.

- *Default*: undef

---
#### config_file (type: Stdlib::Absolutepath)
The path to the selinux configuration path to manage.

- *Default*: '/etc/selinux/config'

---
#### policytools
If true, manage the `policycoreutils-python` package.  The purpose of this
behavior is to provide the `semanage` command, e.g. to reconfigure the selinux
policy such that `restorecon` will restore a file to the desired state.  For
example, to enable SSH key based login for an user account outside of the normal
location:

    semanage fcontext -a -t ssh_home_t /var/lib/git/.ssh
    semanage fcontext -a -t ssh_home_t /var/lib/git/.ssh/authorized_keys
    restorecon -v /var/lib/git/.ssh/
    restorecon -v /var/lib/git/.ssh/authorized_keys

- *Default*: false

=======

### Examples

To enable SELinux

```puppet
include ::selinux
```

To disable SELinux

```puppet
class { '::selinux':
  mode => 'disabled',
}
```
