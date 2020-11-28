# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "baunegaard/win10pro-en"
    config.vm.hostname = "win10vs2019"

    config.winrm.username = "vagrant"
    config.winrm.password = "vagrant"

    if Vagrant.has_plugin?("vagrant-proxyconf") && ENV['http_proxy']
        puts 'Apply proxy settings to Vagrant (note: no_proxy must include 127.0.0.1)'
        puts "  http_proxy=#{ENV['http_proxy']}"
        puts "  no_proxy=#{ENV['no_proxy']}"
        config.proxy.http     = ENV['http_proxy']
        config.proxy.https    = ENV['http_proxy']
        config.proxy.no_proxy = ENV['no_proxy']
    end

    config.vm.provider :virtualbox do |v, override|
        v.name = "Win10_VS2019"
        v.customize ["modifyvm", :id, "--cpus", 4]
        v.customize ["modifyvm", :id, "--memory", 8192]
    end

    config.vm.provision "shell", path: "configure/pre-windowssettings.ps1"
    config.vm.provision :reload
    config.vm.provision "shell", path: "configure/set-proxy-settings.ps1"
    config.vm.provision "shell", path: "software/install-scoop.ps1"
    config.vm.provision "shell", path: "software/install-scoop-dev-tools.ps1"
    config.vm.provision "shell", path: "software/install-jenkins-swarm-client.ps1",
        env: {"JENKINS_URL" => ENV['JENKINS_URL'],
              "JENKINS_USER" => ENV['JENKINS_USER'],
              "JENKINS_TOKEN" => ENV['JENKINS_TOKEN']}
    config.vm.provision "shell", path: "software/install-vs-buildtools.ps1"
    config.vm.provision "shell", path: "configure/post-windowssettings.ps1"
    config.vm.provision :reload
    # config.vm.provision "shell", path: "configure/install-windowsupdates.ps1"
end
