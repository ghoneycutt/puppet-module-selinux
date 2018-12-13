# @summary Manage SELinux
#
# This module manages the SELinux configuration file.
#
# @example Declaring the class
#
#   include ::selinux
#
# @param mode
#   Operation mode of SELinux, valid values are 'enforcing', 'permissive' and 'disabled'.
#
# @param type
#   The type of policies in use, valid values are 'targeted' and 'strict'.
#
# @param setlocaldefs
#   String or Integer to pass to SETLOCALDEFS option. Valid values are '0' and '1'. If
#   left undef, then the SETLOCALDEFS option is not included in the
#   config_file.
#
# @param config_file
#   The path to the selinux configuration path to manage.
#
# @param policytools
#   If true, manage the `policycoreutils-python` package.  The purpose of this
#   behavior is to provide the `semanage` command, e.g. to reconfigure the
#   selinux policy such that `restorecon` will restore a file to the desired
#   state.
#
# @example To enable SSH key based login for an user account outside of the normal location:
#
#   semanage fcontext -a -t ssh_home_t /var/lib/git/.ssh
#   semanage fcontext -a -t ssh_home_t /var/lib/git/.ssh/authorized_keys
#   restorecon -v /var/lib/git/.ssh/
#   restorecon -v /var/lib/git/.ssh/authorized_keys
#
class selinux (
  Pattern[/^enforcing|permissive|disabled$/]  $mode         = 'enforcing',
  Pattern[/^targeted|strict$/]                $type         = 'targeted',
  Variant[Undef, Enum['0','1'], Integer[0,1]] $setlocaldefs = undef,
  Stdlib::Absolutepath                        $config_file  = '/etc/selinux/config',
  Boolean                                     $policytools  = false,
) {

  # selinux allows you to set the system to permissive or enforcing while
  # disabling completely requires a reboot. We set to permissive here when the
  # desired level is disabled, since it has the similar effect of ignoring
  # selinux and we do not have to force a reboot.
  if $mode == 'permissive' or $mode == 'disabled' {
    exec { 'set_permissive_mode':
      command => 'setenforce Permissive',
      unless  => 'getenforce | grep -ie permissive -e disabled',
      path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    }

    if $policytools == true {
      Package['policycoreutils-python'] {
        before +> Exec['set_permissive_mode'],
      }
    }
  }

  if $mode == 'enforcing' {
    exec { 'set_enforcing_mode':
      command => 'setenforce Enforcing',
      unless  => 'getenforce | grep -i enforcing',
      path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    }

    if $policytools == true {
      Package['policycoreutils-python'] {
        before +> Exec['set_enforcing_mode'],
      }
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

  # Provide the semanage command to allow permanent configuration of the selinux
  # policy.  This allows the restorecon command to restore policy to a specified
  # default.
  if $policytools == true {
    package { 'policycoreutils-python':
      ensure => installed,
    }
  }
}
