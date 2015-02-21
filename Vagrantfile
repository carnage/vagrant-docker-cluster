# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = "ubuntu/trusty64"

    File.open("./hosts", "r") do |file_handle|
        count = file_handle.count
        file_handle.rewind
        file_handle.each_with_index do |server, index|
            config.vm.define server.split(' ').last do |host|
                host.vm.provision "shell" do |s|
                   s.path = "install.sh"
                   if (index + 1) == count
                      s.args = ['true']
                   end
                end
                host.vm.network :private_network, ip: server.split(' ').first
            end
        end
    end
end
