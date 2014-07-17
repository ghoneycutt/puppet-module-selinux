require 'spec_helper'

describe 'selinux' do

  it { should compile.with_all_deps }

  describe 'has correct selinux_config file attributes' do

    it { should contain_class('selinux') }

    it {
      should contain_file('selinux_config').with({
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      })
    }
  end

  describe 'when using default values' do

    it { should contain_class('selinux') }

    it {
      should contain_file('selinux_config').with({
        'path' => '/etc/selinux/config',
      })
    }

    it { should contain_file('selinux_config').with_content(/^\s*SELINUX=disabled$/) }
    it { should contain_file('selinux_config').with_content(/^\s*SELINUXTYPE=targeted$/) }
    it { should contain_file('selinux_config').without_content(/^\s*SETLOCALDEFS/) }
  end

  describe 'with mode parameter' do
    ['INVALID',true].each do |value|
      context "set to #{value}" do
        let(:params) { { :mode => 'INVALID' } }

        it {
          expect {
            should contain_file('selinux_config')
          }.to raise_error(Puppet::Error)
        }
      end
    end

    ['enforcing','permissive','disabled'].each do |value|
      context "set to #{value}" do
        let(:params) { { :mode => value } }

        it { should contain_class('selinux') }

        it { should contain_file('selinux_config').with_content(/^\s*SELINUX=#{value}$/) }

        if value == 'disabled'
          it {
            should contain_exec('Change SELinux mode to Disabled').with({
              'command' => '/usr/sbin/setenforce 0',
              'onlyif'  => '/usr/sbin/selinuxenabled',
            })
          }
        else
          it { should_not contain_exec('Change SELinux mode to Disabled') }
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

  describe 'when setting the file path' do
    let(:params) { { :config_file => '/etc/selinux.conf' } }

    it { should contain_class('selinux') }

    it {
      should contain_file('selinux_config').with({
        'path' => '/etc/selinux.conf'
       })
    }
  end
end
