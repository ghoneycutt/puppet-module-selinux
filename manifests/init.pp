# == Class: selinux
#
# This module manages the SELinux configuration file.
#
class selinux (
  $mode         = 'disabled',
  $type         = 'targeted',
  $setlocaldefs = undef,
  $config_file  = '/etc/selinux/config',
) {

  validate_re($type, '^targeted|strict$', "type is ${type} and must be either 'targeted' or 'strict'.")

  if $setlocaldefs != undef {
    validate_re($setlocaldefs, '^0|1$', "local defs is ${setlocaldefs} must be either 0 or 1.")
  }

  validate_absolute_path($config_file)

  # selinux allows you to set the system to permissive or enforcing while
  # disabling completely requires a reboot. We set to permissive here when the
  # desired level is disabled, since it has the similar effect of ignoring
  # selinux and we do not have to force a reboot.
  case $mode {
    'permissive','disabled': {
      exec { 'set_permissive_mode':
        command => 'setenforce Permissive',
        unless  => 'getenforce | grep -ie permissive -e disabled',
        path    => '/bin:/usr/bin:/sbin:/usr/sbin',
      }
    }
    'enforcing': {
      exec { 'set_enforcing_mode':
        command => 'setenforce Enforcing',
        unless  => 'getenforce | grep -i enforcing',
        path    => '/bin:/usr/bin:/sbin:/usr/sbin',
      }
    }
    default: {
      fail("mode is ${mode} and must be either 'enforcing', 'permissive' or 'disabled'.")
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
