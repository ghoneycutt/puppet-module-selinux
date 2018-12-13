# Reference
<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

**Classes**

* [`selinux`](#selinux): Manage SELinux

## Classes

### selinux

This module manages the SELinux configuration file.

#### Examples

##### Declaring the class

```puppet

include ::selinux
```

##### To enable SSH key based login for an user account outside of the normal location:

```puppet

semanage fcontext -a -t ssh_home_t /var/lib/git/.ssh
semanage fcontext -a -t ssh_home_t /var/lib/git/.ssh/authorized_keys
restorecon -v /var/lib/git/.ssh/
restorecon -v /var/lib/git/.ssh/authorized_keys
```

#### Parameters

The following parameters are available in the `selinux` class.

##### `mode`

Data type: `Pattern[/^enforcing|permissive|disabled$/]`

Operation mode of SELinux, valid values are 'enforcing', 'permissive' and 'disabled'.

Default value: 'enforcing'

##### `type`

Data type: `Pattern[/^targeted|strict$/]`

The type of policies in use, valid values are 'targeted' and 'strict'.

Default value: 'targeted'

##### `setlocaldefs`

Data type: `Variant[Undef, Enum['0','1'], Integer[0,1]]`

String or Integer to pass to SETLOCALDEFS option. Valid values are '0' and '1'. If
left undef, then the SETLOCALDEFS option is not included in the
config_file.

Default value: `undef`

##### `config_file`

Data type: `Stdlib::Absolutepath`

The path to the selinux configuration path to manage.

Default value: '/etc/selinux/config'

##### `policytools`

Data type: `Boolean`

If true, manage the `policycoreutils-python` package.  The purpose of this
behavior is to provide the `semanage` command, e.g. to reconfigure the
selinux policy such that `restorecon` will restore a file to the desired
state.

Default value: `false`
