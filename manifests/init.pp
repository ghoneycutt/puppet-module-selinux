# ## selinux module #
#
# This module manages the SELinux configuration file.
#
# ### Parameters ###
#
# See man page selinux(8) for more information regarding the configuration settings.
#
# mode
# ----
# Operation mode of SELinux, valid values are 'enforcing', 'permissive' and 'disabled'.
#
# - *Default*: 'disabled'
#
# type
# ----
# The type of policies in use, valid values are 'targeted' and 'strict'.
#
# - *Default*: 'targeted'
#
# config_file
# -----------
# The path to the selinux configuration path to manage.
#
# - *Default*: '/etc/selinux/config'
#

class selinux (
  $mode        = 'disabled',
  $type        = 'targeted',
  $config_file = '/etc/selinux/config',
) {

  $is_mode_a_string = is_string($mode)
  if $is_mode_a_string == false {
    fail('selinux::mode is not a string')
  }

  $is_type_a_string = is_string($type)
  if $is_type_a_string == false {
    fail('selinux::type is not a string')
  }

  case $mode {
    'enforcing','permissive','disabled': {
      # noop
    }
    default: {
      fail("mode is ${mode} and must be either 'enforcing', 'permissive' or 'disabled'.")
    }
  }

  case $type {
    'targeted','strict': {
      # noop
    }
    default: {
      fail("type is ${type} and must be either 'targeted' or 'strict'.")
    }
  }

  file { 'selinux_config':
    ensure  => 'file',
    path    => $config_file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('selinux/config.erb'),
  }
}
