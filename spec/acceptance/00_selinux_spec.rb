require 'spec_helper_acceptance'

describe 'selinux' do
  context 'default' do
    it 'should work without errors' do
      # The `mode` parameter *must* be `'disabled'` because you cannot enable
      # SELinux inside of a container. The `policytools` parameter must be
      # `true` as the docker image does not contain it and the package is
      # necessary to run `getenforce`.
      pp = <<-EOS
      class { '::selinux':
        policytools => true,
        mode        => 'disabled',
      }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    selinux_config_content = <<-END.gsub(/^\s+\|/, '')
      |# This file is being maintained by Puppet.
      |# DO NOT EDIT
      |
      |# This file controls the state of SELinux on the system.
      |# SELINUX= can take one of these three values:
      |# enforcing - SELinux security policy is enforced.
      |# permissive - SELinux prints warnings instead of enforcing.
      |# disabled - SELinux is fully disabled.
      |SELINUX=disabled
      |# SELINUXTYPE= type of policy in use. Possible values are:
      |# targeted - Only targeted network daemons are protected.
      |# strict - Full SELinux protection.
      |SELINUXTYPE=targeted
    END

    describe file('/etc/selinux/config') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 644 }
      its(:content) { should eq selinux_config_content }
    end

    describe command('getenforce | grep -ie permissive -e disabled') do
      its(:exit_status) { should eq 0 }
    end

    describe package('policycoreutils-python') do
      it { should be_installed }
    end
  end
end

