require 'spec_helper'

describe 'selinux' do

  it { should compile.with_all_deps }

  describe 'when using default values' do

    it { should contain_class('selinux') }

    it {
      should contain_file('selinux_config').with({
        'ensure' => 'file',
        'path'   => '/etc/selinux/config',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      })
    }

    it { should contain_file('selinux_config').with_content(/^SELINUX=enforcing$/) }
    it { should contain_file('selinux_config').with_content(/^SELINUXTYPE=targeted$/) }
    it { should contain_file('selinux_config').without_content(/^\s*SETLOCALDEFS/) }
  end

  describe 'with mode parameter' do
    ['enforcing','permissive','disabled','INVALID',true].each do |value|
      context "set to #{value}" do
        let(:params) { { :mode => value } }

        if value == 'disabled' or value == 'permissive'

          it { should contain_file('selinux_config').with_content(/^SELINUX=#{value}$/) }

          it {
            should contain_exec('set_permissive_mode').with({
              'command' => 'setenforce Permissive',
              'unless'  => 'getenforce | grep -ie permissive -e disabled',
              'path'    => '/bin:/usr/bin:/sbin:/usr/sbin',
            })
          }
        elsif value == 'enforcing'
          it { should contain_file('selinux_config').with_content(/^SELINUX=#{value}$/) }

          it {
            should contain_exec('set_enforcing_mode').with({
              'command' => 'setenforce Enforcing',
              'unless'  => 'getenforce | grep -i enforcing',
              'path'    => '/bin:/usr/bin:/sbin:/usr/sbin',
            })
          }
        else
          it 'should fail' do
            expect {
              should contain_class('selinux')
            }.to raise_error(Puppet::Error,/Error while evaluating a Resource Statement/)
          end
        end
      end
    end
  end

  describe 'with type parameter' do
    ['INVALID',true].each do |value|
      context "set to #{value}" do
        let(:params) { { :type => 'INVALID' } }

        it {
          expect {
            should contain_file('selinux_config')
          }.to raise_error(Puppet::Error,/Error while evaluating a Resource Statement/)
        }
      end
    end

    ['strict','targeted'].each do |value|
      context "set to #{value}" do
        let(:params) { { :type => value } }

        it { should contain_class('selinux') }

        it { should contain_file('selinux_config').with_content(/^SELINUXTYPE=#{value}$/) }
      end
    end
  end

  describe 'with setlocaldefs parameter' do
    ['INVALID', true].each do |value|
      context "set to #{value}" do
        let(:params) { { :setlocaldefs => value } }

        it {
          expect {
            should contain_file('selinux_config')
          }.to raise_error(Puppet::Error,/Error while evaluating a Resource Statement/)
        }
      end
    end

    [0,'0',1,'1'].each do |value|
      context "set to #{value} (class #{value.class})" do
        let(:params) { { :setlocaldefs => value } }

        it { should contain_file('selinux_config').with_content(/^SETLOCALDEFS=#{value}$/) }
      end
    end
  end

  describe 'when setting both parameters to valid values' do
    let(:params) do
      { :mode => 'enforcing',
        :type => 'strict'
      }
    end

    it { should contain_file('selinux_config').with_content(/^SELINUX=enforcing$/) }
    it { should contain_file('selinux_config').with_content(/^SELINUXTYPE=strict$/) }
  end

  describe 'with config_file specified' do
    context 'as a valid path' do
      let(:params) { { :config_file => '/etc/selinux.conf' } }

      it {
        should contain_file('selinux_config').with({
          'path' => '/etc/selinux.conf'
         })
      }
    end

    context 'as an invalid path' do
      let(:params) { { :config_file => 'invalid/path' } }

      it {
        expect {
          should contain_file('selinux_config')
        }.to raise_error(Puppet::Error,/Error while evaluating a Resource Statement/)
      }
    end
  end

  describe 'policytools class parameter' do
    context 'when false' do
      let(:params) { { :policytools => false } }
      it 'includes the selinux class' do
        expect(subject).to contain_class('selinux')
      end
      it 'does not manage package { "policycoreutils-python": }' do
        expect(subject).not_to contain_package('policycoreutils-python')
      end
    end
    context 'when true' do
      let(:params) { { :policytools => true } }
      it 'includes the selinux class' do
        expect(subject).to contain_class('selinux')
      end
      it 'manages package { "policycoreutils-python": }' do
        expect(subject).to contain_package('policycoreutils-python').with({
          'ensure' => 'installed',
        })
      end
    end
  end
end
