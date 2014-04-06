# == Class: selinux
#
# This module manages the SELinux configuration file.
#
class selinux (
  $mode        = 'disabled',
  $type        = 'targeted',
  $config_file = '/etc/selinux/config',
) {

  validate_re($mode, '^enforcing|permissive|disabled$', "mode is ${mode} and must be either 'enforcing', 'permissive' or 'disabled'.")
  validate_re($type, '^targeted|strict$', "type is ${type} and must be either 'targeted' or 'strict'.")

  file { 'selinux_config':
    ensure  => 'file',
    path    => $config_file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('selinux/config.erb'),
  }
}
