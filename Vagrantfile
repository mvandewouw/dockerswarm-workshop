Vagrant.configure("2") do |config|
  config.vm.define "manager1" do |manager|
    manager.vm.box = "ubuntu/bionic64"
    manager.vm.hostname = "manager1"
    manager.vm.network "private_network", ip: '192.168.56.111'
  end

  config.vm.define "worker1" do |worker|
    worker.vm.box = "ubuntu/bionic64"
    worker.vm.hostname = "worker1"
    worker.vm.network "private_network", ip: '192.168.56.112'
  end

  config.vm.define "worker2" do |worker|
    worker.vm.box = "ubuntu/bionic64"
    worker.vm.hostname = "worker2"
    worker.vm.network "private_network", ip: '192.168.56.113'
  end

  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 4
  end

  $script = <<-SCRIPT
  echo "192.168.56.111 manager1" >> /etc/hosts
  echo "192.168.56.112 worker1" >> /etc/hosts
  echo "192.168.56.113 worker2" >> /etc/hosts
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get upgrade -y
  curl -fsSL https://get.docker.com/  | awk 'NR==3{print "export DEBIAN_FRONTEND=noninteractive"}1' | sh
  usermod -aG docker vagrant
  systemctl restart docker
  SCRIPT

  config.vm.provision "shell", inline: $script, privileged: true

end
