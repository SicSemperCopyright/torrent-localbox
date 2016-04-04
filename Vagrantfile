Vagrant.configure(2) do |config|
  #config.vm.box = "gbarbieru/xenial"

  # With the official cloud image, you must first run: vagrant plugin install vagrant-vbguest
  config.vm.box = "https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-vagrant.box"

  config.vm.network "forwarded_port", guest: 5901, host: 5901, host_ip: "127.0.0.1", auto_correct: true
  config.vm.network "forwarded_port", guest: 9091, host: 9091, host_ip: "127.0.0.1", auto_correct: true

  config.vm.synced_folder ".", "/vagrant"

  # Change E:\\Torrents to point to the folder on your host PC where you want torrent downloads to go
  config.vm.synced_folder "E:\\Torrents", "/home/ubuntu/Downloads"

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2

    # Uncomment the following line to enable the VM GUI
    #v.gui = true
  end

  config.vm.provision "shell", privileged: false, path: "provision.sh"
end
