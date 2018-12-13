class { '::selinux':
  mode        => 'disabled',
  policytools => true,
}
