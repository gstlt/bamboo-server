# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|

  # Ensure we use our vagrant private key
  config.ssh.insert_key = false
  config.ssh.private_key_path = '~/.vagrant.d/insecure_private_key'

  config.vm.define 'bamboo' do |machine|
    machine.vm.box = "bento/ubuntu-16.04"

    machine.vm.network :private_network, ip: '192.168.55.55'
    machine.vm.hostname = 'bamboo.local'
    machine.vm.provision 'ansible' do |ansible|
      ansible.playbook = 'playbook-vagrant.yaml'
      ansible.sudo = true
      ansible.inventory_path = 'inventory'
      ansible.host_key_checking = false
    end

  end

end
