# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
ENV['DEFAULT_VAGRANT_PROVIDER'] = "virtualbox"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.provision "shell", inline: "apt-get update"
  config.vm.provision "shell", inline: "mkdir -p /chef/deb-cache/"
  config.vm.provision "shell", inline: "cp -a /chef/deb-cache/* /var/cache/apt/archives/ ; exit 0"
  config.vm.provision "shell", inline: "DEBIAN_FRONTEND=noninteractive apt-get -y install avahi-daemon curl vim git"
  config.vm.network :private_network, type: "dhcp"
  config.vm.box = "hashicorp/precise64"
  config.vm.synced_folder "./chef/", "/chef/" #, type: "nfs"
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "256"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
  end

  config.vm.define :chefs do |server|
    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "512"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
    end
    server.vm.hostname = "chefs.local"
    server.vm.provision "shell", inline: "echo 'Downloading chef server....';curl -L -s -C - -o /chef/server/chef-server-core_12.0.4-1_amd64.deb https://web-dl.packagecloud.io/chef/stable/packages/ubuntu/precise/chef-server-core_12.0.4-1_amd64.deb;exit 0"
    server.vm.provision "shell", inline: "DEBIAN_FRONTEND=noninteractive dpkg -i /chef/server/chef-server-core_12.0.4-1_amd64.deb"
    server.vm.provision "shell", inline: "chef-server-ctl reconfigure"
    server.vm.provision "shell", inline: "sleep 30"
    server.vm.provision "shell", inline: "chef-server-ctl user-create vagrant Vagrant User user@vagrant.com test123 -f /chef/dev/config/vagrant.pem"
    server.vm.provision "shell", inline: "chef-server-ctl org-create zenlab 'Zen Lab' -a vagrant -f /chef/dev/config/chef-validator.pem"
    server.vm.provision "shell", inline: "cp -a /var/cache/apt/archives/*.deb /chef/deb-cache/"
    server.vm.provision "shell", inline: "ssh-keygen -t rsa -P '' -f ~/.ssh/id_dsa"
    server.vm.provision "shell", inline: "cp ~/.ssh/id_dsa* /chef/server/"
    server.vm.provision "shell", inline: "cat /chef/server/id_dsa.pub >> ~vagrant/.ssh/authorized_keys"
    server.vm.provision "shell", inline: "cp /chef/server/id_dsa* ~vagrant/.ssh/"
    server.vm.provision "shell", inline: "chown vagrant:vagrant ~vagrant/.ssh/*"
  end

  config.vm.define :chefc1 do |client1|
    client1.vm.hostname = "chefc1.local"
    client1.vm.provision "shell", inline: "cat /chef/server/id_dsa.pub >> ~vagrant/.ssh/authorized_keys"
    client1.vm.provision "shell", inline: "cp /chef/server/id_dsa* ~vagrant/.ssh/"
    client1.vm.provision "shell", inline: "chown vagrant:vagrant ~vagrant/.ssh/*"

  end

  config.vm.define :chefc2 do |client2|
    client2.vm.hostname = "chefc2.local"
    client2.vm.provision "shell", inline: "cat /chef/server/id_dsa.pub >> ~vagrant/.ssh/authorized_keys"
    client2.vm.provision "shell", inline: "cp /chef/server/id_dsa* ~vagrant/.ssh/"
    client2.vm.provision "shell", inline: "chown vagrant:vagrant ~vagrant/.ssh/*"

  end

  config.vm.define :chefc3 do |client3|
    client3.vm.hostname = "chefc3.local"
    client3.vm.provision "shell", inline: "cat /chef/server/id_dsa.pub >> ~vagrant/.ssh/authorized_keys"
    client3.vm.provision "shell", inline: "cp /chef/server/id_dsa* ~vagrant/.ssh/"
    client3.vm.provision "shell", inline: "chown vagrant:vagrant ~vagrant/.ssh/*"
   end

  config.vm.define :chefd do |dev|
    dev.vm.hostname = "chefd.local"
    dev.vm.provision "shell", inline: "echo 'Downloading chef dk....';curl -s -L -C - -o /chef/dev/chefdk_0.4.0-1_amd64.deb https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.4.0-1_amd64.deb;exit 0"
    dev.vm.provision "shell", inline: "DEBIAN_FRONTEND=noninteractive dpkg -i /chef/dev/chefdk_0.4.0-1_amd64.deb"
    dev.vm.provision "shell", inline: "ln -s /chef/dev/config/ ~vagrant/.chef"
    dev.vm.provision "shell", inline: "ln -s /chef/dev/ ~vagrant/chef"
    dev.vm.provision "shell", inline: "cat /chef/server/id_dsa.pub >> ~vagrant/.ssh/authorized_keys"
    dev.vm.provision "shell", inline: "cp /chef/server/id_dsa* ~vagrant/.ssh/"
    dev.vm.provision "shell", inline: "chown vagrant:vagrant ~vagrant/.ssh/*"
    dev.vm.provision "shell", privileged: false, inline: "knife ssl fetch"
#    dev.vm.provision "shell", privileged: false, inline: "knife environment create production -d"
#    dev.vm.provision "shell", privileged: false, inline: "knife bootstrap -x vagrant chefc1.local -N chefc1.local -E production --sudo"
#    dev.vm.provision "shell", privileged: false, inline: "knife bootstrap -x vagrant chefc2.local -N chefc2.local -E production --sudo"
#    dev.vm.provision "shell", privileged: false, inline: "knife bootstrap -x vagrant chefc3.local -N chefc3.local -E production --sudo"
  end

end
