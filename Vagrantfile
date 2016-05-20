# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
ENV['DEFAULT_VAGRANT_PROVIDER'] = "virtualbox"
chef_version = "12.6.0-1"
chefdk_version = "0.14.25-1"
clients = (1..3)
$bscript = <<BSCRIPT
apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get -y install curl vim git avahi-daemon build-essential
mkdir -p /chef/deb-cache/
cp -a /chef/deb-cache/* /var/cache/apt/archives/ ; exit 0
BSCRIPT

$escript = <<ESCRIPT
echo "Provisioning keys and saving deb-cache."
cat /chef/server/id_dsa.pub >> ~vagrant/.ssh/authorized_keys
cp /chef/server/id_dsa* ~vagrant/.ssh/
chown vagrant:vagrant ~vagrant/.ssh/*
cp /var/cache/apt/archives/*.deb /chef/deb-cache/ ; exit 0
ESCRIPT



Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.provision "shell", privileged: false, inline: "touch .hushlogin"
  config.vm.provision "shell", inline: $bscript
  config.vm.network :private_network, type: "dhcp"
  config.vm.box = "ubuntu/trusty64"
  config.vm.synced_folder "./chef/", "/chef/" #, type: "nfs"
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "256"]
    vb.customize ["modifyvm", :id, "--cpus", "1"]
  end

  config.vm.define :chefs do |server|
    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1792"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
    end
    server.vm.hostname = "chefs.local"
    server.vm.provision "shell", inline: "curl -L -s -C - -o /chef/server/chef-server-core_#{chef_version}_amd64.deb https://packages.chef.io/stable/ubuntu/14.04/chef-server-core_#{chef_version}_amd64.deb"
    server.vm.provision "shell", inline: "dpkg -i /chef/server/chef-server-core_#{chef_version}_amd64.deb"
    server.vm.provision "shell", inline: "chef-server-ctl reconfigure"
    server.vm.provision "shell", inline: "sleep 30"
    server.vm.provision "shell", inline: "chef-server-ctl user-create vagrant Vagrant User user@vagrant.com test123 -f /chef/dev/config/vagrant.pem"
    server.vm.provision "shell", inline: "chef-server-ctl org-create chefclass 'Chef Class' -a vagrant -f /chef/dev/config/chef-validator.pem"
    server.vm.provision "shell", inline: "ssh-keygen -t rsa -P '' -f ~/.ssh/id_dsa"
    server.vm.provision "shell", inline: "cp ~/.ssh/id_dsa* /chef/server/"
    server.vm.provision "shell", inline: $escript
  end

  config.vm.define :chefd do |dev|
    dev.vm.hostname = "chefd.local"
    dev.vm.provision "shell", inline: "curl -L -s -C - -o chefdk_#{chefdk_version}_amd64.deb  https://packages.chef.io/stable/ubuntu/12.04/chefdk_#{chefdk_version}_amd64.deb"
    dev.vm.provision "shell", inline: "dpkg -i chefdk_#{chefdk_version}_amd64.deb"
    dev.vm.provision "shell", inline: "cp -a /chef/deb-cache/* /var/cache/apt/archives/ ; exit 0"
    dev.vm.provision "shell", inline: "ln -s /chef/dev/config/ ~vagrant/.chef"
    dev.vm.provision "shell", inline: "ln -s /chef/dev/ ~vagrant/chef"
    dev.vm.provision "shell", privileged: false, inline: "knife ssl fetch"
    dev.vm.provision "shell", inline: $escript
#    dev.vm.provision "shell", privileged: false, inline: "knife environment create production -d"
#    dev.vm.provision "shell", privileged: false, inline: "knife bootstrap -x vagrant chefc1.local -N chefc1.local -E production --sudo"
#    dev.vm.provision "shell", privileged: false, inline: "knife bootstrap -x vagrant chefc2.local -N chefc2.local -E production --sudo"
#    dev.vm.provision "shell", privileged: false, inline: "knife bootstrap -x vagrant chefc3.local -N chefc3.local -E production --sudo"
  end

  clients.each do |client|
    config.vm.define "chefc#{client}" do |node|
      node.vm.hostname = "chefc#{client}.local"
      node.vm.provision "shell", inline: $escript
   end
  end

end
