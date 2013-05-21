# selinux module #

This module manages the SELinux configuration file.

# Compability #

This module has been tested to work on the following systems.

 * EL 5
 * EL 6

# Parameters #
Se man page selinux(8) for more information regarding the configuration settings.

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
