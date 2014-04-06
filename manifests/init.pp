# == Class: selinux
#
# This module manages the SELinux configuration file.
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
