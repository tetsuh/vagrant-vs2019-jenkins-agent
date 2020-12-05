# -*- mode: ruby -*-
# vi: set ft=ruby :
BOX_IMAGE = ENV['VAGRANT_WIN10_BASE_BOX'] || "baunegaard/win10pro-en"
NODE_COUNT = (ENV['VAGRANT_WIN10_NUM_NODE'] || 1).to_i

Vagrant.configure("2") do |config|
  (1..NODE_COUNT).each do |i|

    config.winrm.username = "vagrant"
    config.winrm.password = "vagrant"

    if Vagrant.has_plugin?("vagrant-timezone")
      config.timezone.value = :host
    end
    if Vagrant.has_plugin?("vagrant-proxyconf") && ENV['http_proxy']
      puts 'Apply proxy settings to Vagrant (note: no_proxy must include 127.0.0.1)'
      puts "  http_proxy=#{ENV['http_proxy']}"
      puts "  no_proxy=#{ENV['no_proxy']}"
      config.proxy.http     = ENV['http_proxy']
      config.proxy.https    = ENV['http_proxy']
      config.proxy.no_proxy = ENV['no_proxy']
    end

    config.vm.define "win10vs2019-node#{i}" do |machine|
      machine.vm.box = BOX_IMAGE
      machine.vm.hostname = "win10vs2019"
      machine.vm.provider :virtualbox do |v, override|
        v.gui = false
        v.customize ["modifyvm", :id, "--cpus", 4]
        v.customize ["modifyvm", :id, "--memory", 8192]
      end
      machine.vm.provision "shell", path: "configure/pre-windowssettings.ps1"
      machine.vm.provision :reload
      machine.vm.provision "shell", path: "configure/set-proxy-settings.ps1"
      machine.vm.provision "shell", path: "software/install-scoop.ps1"
      machine.vm.provision "shell", path: "software/install-scoop-dev-tools.ps1"
      machine.vm.provision "shell", path: "software/install-jenkins-swarm-client.ps1",
        env: {"JENKINS_URL" => ENV['JENKINS_URL'],
              "JENKINS_USER" => ENV['JENKINS_USER'],
              "JENKINS_TOKEN" => ENV['JENKINS_TOKEN'],
              "JENKINS_AGENT_NAME" => ENV['JENKINS_AGENT_NAME'],
              "JENKINS_AGENT_LABELS" => ENV['JENKINS_AGENT_LABELS'],
              "VAGRANT_NODE_NUM" => "#{i}" }
      machine.vm.provision "shell", path: "software/install-vs-buildtools.ps1"
      machine.vm.provision "shell", path: "configure/post-windowssettings.ps1"
      machine.vm.provision :reload
      # machine.vm.provision "shell", path: "configure/install-windowsupdates.ps1"
      machine.vm.post_up_message = "Complete provision for node#{i}"
    end
  end
end
