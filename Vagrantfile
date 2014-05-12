$script = <<SCRIPT
if ! egrep -q '^COMPOSER_HOME' /etc/environment; then
  echo 'COMPOSER_HOME="/home/vagrant"' >> /etc/environment
fi
SCRIPT

Vagrant.configure("2") do |config|

    config.vm.box = "base"
    config.vm.box_url = "http://files.vagrantup.com/precise64.box"

    config.vm.network :private_network, ip: "192.168.33.101"
    config.ssh.forward_agent = true

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--memory", 1024]
    v.customize ["modifyvm", :id, "--name", "txtcmdr-symfony"]
  end

    config.vm.synced_folder "./application/", "/vagrant", id: "vagrant-root", :nfs => false 

    config.vm.provision :puppet do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.manifest_file = "site.pp"
        puppet.module_path = "puppet/modules"
        puppet.options = ['--verbose']
    end

end
