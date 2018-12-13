# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Environment variables may be used to control the behavior of the Vagrant VM's
# defined in this file.  This is intended as a special-purpose affordance and
# should not be necessary in normal situations.  In particular, sensu-server,
# sensu-server-enterprise, and sensu-server-puppet5 use the same IP address by
# default, creating a potential IP conflict.  If there is a need to run multiple
# server instances simultaneously, avoid the IP conflict by setting the
# ALTERNATE_IP environment variable:
#
#     ALTERNATE_IP=192.168.56.9 vagrant up sensu-server-enterprise
#
# NOTE: The client VM instances assume the server VM is accessible on the
# default IP address, therefore using an ALTERNATE_IP is not expected to behave
# well with client instances.
#
# When bringing up sensu-server-enterprise, the FACTER_SE_USER and
# FACTER_SE_PASS environment variables are required.  See the README for more
# information on how to configure sensu enterprise credentials.
if not Vagrant.has_plugin?('vagrant-vbguest')
  abort <<-EOM

vagrant plugin vagrant-vbguest is required.
https://github.com/dotless-de/vagrant-vbguest
To install the plugin, please run, 'vagrant plugin install vagrant-vbguest'.

  EOM
end

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "512"]
    vb.default_nic_type = "virtio"
  end

  config.vm.define 'selinux-centos-7', primary: true, autostart: true do |sys|
    sys.vm.box = 'centos/7'
    sys.vm.hostname = 'selinux-centos-7'
    sys.vm.network :private_network, ip: ENV['ALTERNATE_IP'] || '192.168.41.10'
    sys.vm.provision :shell, :path => "vagrant/provision_basic_el.sh"
    sys.vm.provision :shell, :inline => "echo -e \"\n\nSystem starts with selinux enabled and this will disable it and install the 'policycoreutils-python' package.\n\n\""
    sys.vm.provision :shell, :inline => "puppet apply /vagrant/vagrant/disable.pp"
    sys.vm.provision :shell, :inline => "echo -e \"\n\nRun again to show that no changes occur\n\n\""
    sys.vm.provision :shell, :inline => "puppet apply /vagrant/vagrant/disable.pp"
    sys.vm.provision :shell, :inline => "echo 'Next output should read Permissive'; getenforce"
    sys.vm.provision :shell, :inline => "echo -e \"\n\nSet selinux to enforcing\n\n\""
    sys.vm.provision :shell, :inline => "puppet apply /vagrant/vagrant/enable.pp"
    sys.vm.provision :shell, :inline => "echo -e \"\n\nRun again to show that no changes occur\n\n\""
    sys.vm.provision :shell, :inline => "puppet apply /vagrant/vagrant/enable.pp"
    sys.vm.provision :shell, :inline => "echo 'Next output should read Enforcing'; getenforce"
  end

  config.vm.define 'selinux-centos-6', autostart: false do |sys|
    sys.vm.box = 'centos/6'
    sys.vm.hostname = 'selinux-centos-6'
    sys.vm.network :private_network, ip: ENV['ALTERNATE_IP'] || '192.168.41.11'
    sys.vm.provision :shell, :path => "vagrant/provision_basic_el.sh"
    sys.vm.provision :shell, :inline => "echo -e \"\n\nSystem starts with selinux enabled and this will disable it and install the 'policycoreutils-python' package.\n\n\""
    sys.vm.provision :shell, :inline => "puppet apply /vagrant/vagrant/disable.pp"
    sys.vm.provision :shell, :inline => "echo -e \"\n\nRun again to show that no changes occur\n\n\""
    sys.vm.provision :shell, :inline => "puppet apply /vagrant/vagrant/disable.pp"
    sys.vm.provision :shell, :inline => "echo 'Next output should read Permissive'; getenforce"
    sys.vm.provision :shell, :inline => "echo -e \"\n\nSet selinux to enforcing\n\n\""
    sys.vm.provision :shell, :inline => "puppet apply /vagrant/vagrant/enable.pp"
    sys.vm.provision :shell, :inline => "echo -e \"\n\nRun again to show that no changes occur\n\n\""
    sys.vm.provision :shell, :inline => "puppet apply /vagrant/vagrant/enable.pp"
    sys.vm.provision :shell, :inline => "echo 'Next output should read Enforcing'; getenforce"
  end
end
