#!/usr/bin/env ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'.freeze

Vagrant.require_version '>= 1.5.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.hostname = 'verdaccio-vagrant'

  # Set the version of chef to install using the vagrant-omnibus plugin
  # NOTE: You will need to install the vagrant-omnibus plugin:
  #   $ vagrant plugin install vagrant-omnibus
  if Vagrant.has_plugin?('vagrant-omnibus')
    config.omnibus.chef_version = 'latest'
  end

  # The url from where the 'config.vm.box' box will be fetched if it is not a
  # Vagrant Cloud box and if it doesn't already exist on the user's system.
  config.vm.box_url = 'https://atlas.hashicorp.com/bento/boxes/ubuntu-14.04'
  config.vm.box = 'bento/ubuntu-14.04'

  config.vm.network :forwarded_port, guest: 4873, host: 4873, auto_correct: true

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', '512']
  end

  # Enabling the Berkshelf plugin. To enable this globally, add this configuration
  # option to your ~/.vagrant.d/Vagrantfile file
  config.berkshelf.enabled = true

  config.vm.provision :chef_zero do |chef|
    chef.json = {
      'verdaccio' => {
        'listen' => ':4873'
      }
    }

    chef.run_list = [
      'recipe[verdaccio::default]'
    ]
  end
end
