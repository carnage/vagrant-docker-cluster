# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  
  config.vm.define "host1" do |host1|
      host1.vm.provision "shell" do |s|
         s.path = "install.sh"
      end
      host1.vm.network :private_network, ip: "192.168.10.2"
  end
  
  config.vm.define "host2" do |host2|
     host2.vm.provision "shell" do |s|
        s.path = "install.sh"
        s.args = ['true']
     end
      host2.vm.network :private_network, ip: "192.168.10.3"
  end
  # config.vm.network :forwarded_port, guest: 80, host: 8080
end
