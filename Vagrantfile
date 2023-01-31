$syslog = <<-SCRIPT
/vagrant/provision/syslog-ng.sh
SCRIPT

$go = <<-SCRIPT
/vagrant/provision/go.sh
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "boxomatic/ubuntu-20.04"
  config.vm.box_version = "20211024.0.1"

  config.vm.define "demo" do |node|
    node.vm.provision "docker"
    node.vm.provision "shell", inline: $syslog, privileged: true
    node.vm.provision "shell", inline: $go, privileged: false
    node.vm.hostname = "demo"
    node.vm.network "private_network", ip: "192.168.1.10", hostname: true, netmask: '255.255.255.0'
  end

end
