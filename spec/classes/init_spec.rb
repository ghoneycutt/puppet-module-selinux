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

    it { should contain_file('selinux_config').with_content(/^\s*SELINUX=disabled$/) }
    it { should contain_file('selinux_config').with_content(/^\s*SELINUXTYPE=targeted$/) }
    it { should contain_file('selinux_config').without_content(/^\s*SETLOCALDEFS/) }
  end

  describe 'with mode parameter' do
    ['enforcing','permissive','disabled','INVALID',true].each do |value|
      context "set to #{value}" do
        let(:params) { { :mode => value } }

        if value == 'disabled' or value == 'permissive'

          it { should contain_class('selinux') }

          it { should contain_file('selinux_config').with_content(/^\s*SELINUX=#{value}$/) }

          it {
            should contain_exec('set_permissive_mode').with({
              'command' => 'setenforce Permissive',
              'unless'  => 'getenforce | grep -ie permissive -e disabled',
              'path'    => '/bin:/usr/bin:/sbin:/usr/sbin',
            })
          }
        elsif value == 'enforcing'
          it { should contain_class('selinux') }

          it { should contain_file('selinux_config').with_content(/^\s*SELINUX=#{value}$/) }

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
            }.to raise_error(Puppet::Error)
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
          }.to raise_error(Puppet::Error)
        }
      end
    end

    ['strict','targeted'].each do |value|
      context "set to #{value}" do
        let(:params) { { :type => value } }

        it { should contain_class('selinux') }

        it { should contain_file('selinux_config').with_content(/^\s*SELINUXTYPE=#{value}$/) }
      end
    end
  end

  describe 'with setlocaldefs parameter' do
    ['INVALID',true].each do |value|
      context "set to #{value}" do
        let(:params) { { :setlocaldefs => 'INVALID' } }

        it {
          expect {
            should contain_file('selinux_config')
          }.to raise_error(Puppet::Error)
        }
      end
    end

    ['0','1'].each do |value|
      context "set to #{value}" do
        let(:params) { { :setlocaldefs => value } }

        it { should contain_class('selinux') }

        it { should contain_file('selinux_config').with_content(/^\s*SETLOCALDEFS=#{value}$/) }
      end
    end
  end

  describe 'when setting both parameters to valid values' do
    let(:params) do
      { :mode => 'enforcing',
        :type => 'strict'
      }
    end

    it { should contain_class('selinux') }

    it { should contain_file('selinux_config').with_content(/^\s*SELINUX=enforcing$/) }
    it { should contain_file('selinux_config').with_content(/^\s*SELINUXTYPE=strict$/) }
  end

  describe 'with config_file specified' do
    context 'as a valid path' do
      let(:params) { { :config_file => '/etc/selinux.conf' } }

      it { should contain_class('selinux') }

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
        }.to raise_error(Puppet::Error)
      }
    end
  end
end
