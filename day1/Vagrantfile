Vagrant.configure("2") do |config|
	config.vm.box = "sbeliakou/centos"

	N = 1
	(1..N).each do |machine_id|
  		config.vm.define "machine#{2+machine_id}" do |machine|
    		machine.vm.hostname = "machine#{2+machine_id}"
    		machine.vm.network "private_network", ip: "192.168.77.#{30+machine_id}"
    	end
    end
end
