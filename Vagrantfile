# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
ENV['DEFAULT_VAGRANT_PROVIDER'] = "virtualbox"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.provision "shell", inline: "apt-get update"
  config.vm.provision "shell", inline: "cp -a /chef/deb-cache/* /var/cache/apt/archives/ ; exit 0"
#  config.vm.provision "shell", inline: "DEBIAN_FRONTEND=noninteractive apt-get -y upgrade"
  config.vm.provision "shell", inline: "DEBIAN_FRONTEND=noninteractive apt-get -y install avahi-daemon curl vim"
  config.vm.network :private_network, type: "dhcp"
  config.vm.box = "hashicorp/precise64"
  config.vm.synced_folder "./chef/", "/chef/", type: "nfs"

  config.vm.define :chefs do |server|
    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "512"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
    end
    server.vm.hostname = "chefs.local"
    server.vm.provision "shell", inline: "echo 'Downloading chef server....';curl -s -C - -o /chef/server/chef-server_11.1.5-1_amd64.deb https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chef-server_11.1.5-1_amd64.deb;exit 0"
    server.vm.provision "shell", inline: "DEBIAN_FRONTEND=noninteractive dpkg -i /chef/server/chef-server_11.1.5-1_amd64.deb"
    server.vm.provision "shell", inline: "chef-server-ctl reconfigure"
    server.vm.provision "shell", inline: "cp /etc/chef-server/chef-validator.pem /chef/dev/config"
    server.vm.provision "shell", inline: "cp -a /var/cache/apt/archives/*.deb /chef/deb-cache/"
    server.vm.provision "shell", inline: "ssh-keygen -t rsa -P '' -f ~/.ssh/id_dsa"
    server.vm.provision "shell", inline: "cp ~/.ssh/id_dsa* /chef/server/"
    server.vm.provision "shell", inline: "cat /chef/server/id_dsa.pub >> ~vagrant/.ssh/authorized_keys"
    server.vm.provision "shell", inline: "cp /chef/server/id_dsa* ~vagrant/.ssh/"
    server.vm.provision "shell", inline: "chown vagrant:vagrant ~vagrant/.ssh/*"
  end

  config.vm.define :chefc1 do |client1|
    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "256"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
    end
    client1.vm.hostname = "chefc1.local"
    client1.vm.provision "shell", inline: "cat /chef/server/id_dsa.pub >> ~vagrant/.ssh/authorized_keys"
    client1.vm.provision "shell", inline: "cp /chef/server/id_dsa* ~vagrant/.ssh/"
    client1.vm.provision "shell", inline: "chown vagrant:vagrant ~vagrant/.ssh/*"
  end

  config.vm.define :chefc2 do |client2|
    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "256"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
    end
    client2.vm.hostname = "chefc2.local"
    client2.vm.provision "shell", inline: "cat /chef/server/id_dsa.pub >> ~vagrant/.ssh/authorized_keys"
    client2.vm.provision "shell", inline: "cp /chef/server/id_dsa* ~vagrant/.ssh/"
    client2.vm.provision "shell", inline: "chown vagrant:vagrant ~vagrant/.ssh/*"
  end

  config.vm.define :chefc3 do |client3|
    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "256"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
    end
    client3.vm.hostname = "chefc3.local"
    client3.vm.provision "shell", inline: "cat /chef/server/id_dsa.pub >> ~vagrant/.ssh/authorized_keys"
    client3.vm.provision "shell", inline: "cp /chef/server/id_dsa* ~vagrant/.ssh/"
    client3.vm.provision "shell", inline: "chown vagrant:vagrant ~vagrant/.ssh/*"
  end

  config.vm.define :chefd do |dev|
    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "256"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
    end
    dev.vm.hostname = "chefd.local"
    dev.vm.provision "shell", inline: "echo 'Downloading chef dk....';curl -s -C - -o /chef/dev/chefdk_0.3.0-1_amd64.deb http://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.3.0-1_amd64.deb;exit 0"
    dev.vm.provision "shell", inline: "DEBIAN_FRONTEND=noninteractive dpkg -i /chef/dev/chefdk_0.3.0-1_amd64.deb"
    dev.vm.provision "shell", inline: "ln -s /chef/dev/config/ ~vagrant/.chef"
    dev.vm.provision "shell", inline: "ln -s /chef/dev/ ~vagrant/chef"
    dev.vm.provision "shell", inline: "cat /chef/server/id_dsa.pub >> ~vagrant/.ssh/authorized_keys"
    dev.vm.provision "shell", inline: "cp /chef/server/id_dsa* ~vagrant/.ssh/"
    dev.vm.provision "shell", inline: "chown vagrant:vagrant ~vagrant/.ssh/*"
  end
end
