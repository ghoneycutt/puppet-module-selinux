# selinux module
===

[![Build Status](https://api.travis-ci.org/ghoneycutt/puppet-module-selinux.png)](https://travis-ci.org/ghoneycutt/puppet-module-selinux)

This module manages the SELinux configuration file.

===

# Compability

This module has been tested to work on the following systems with Puppet v3 and Ruby versions 1.8.7, 1.9.3 and 2.0.0.

 * EL 5
 * EL 6

===

# Parameters

See man page selinux(8) for more information regarding the configuration settings.


mode
----
Operation mode of SELinux, valid values are 'enforcing', 'permissive' and 'disabled'.

- *Default*: 'disabled'

type
----
The type of policies in use, valid values are 'targeted' and 'strict'.

- *Default*: 'targeted'

config_file
-----------
The path to the selinux configuration path to manage.

- *Default*: '/etc/selinux/config'
