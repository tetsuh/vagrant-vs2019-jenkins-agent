# vagrant-vs2019-jenkins-agent
This repository is intended to create latest VS2019 build environmen for Jenkins build agent.

This repository is based on https://github.com/Baune8D/vagrant-vs2017-devbox   
I borrowed many files and settings from the original repo. Thank you.

## Setup

### Requirements
**Vagrant** - [Link](https://www.vagrantup.com/downloads.html)  
**Vagrant-Reload** Plugin: ```vagrant plugin install vagrant-reload```  
**Vagrant-ProxyConf** Plugin: ```vagrant plugin install vagrant-proxyconf```

### Getting Started
Only **VirtualBox** provider can be used.

To use the default settings, execute from repo root: ```vagrant up```  
Now sit back while Vagrant provisions your new development machine.  
Provisioning can take many hours, be patient.

## Information
This is built for use with a Packer Windows 10 base image.  
Packer setup repository: [GitHub link](https://github.com/Baune8D/packer-win10-basebox)  
A pre-built default box will be downloaded on first run.  
Of course, you can also create your own basebox.  
For example, I'm using the Win10 IoT Enterprise LTSC 2019 basebox in the company.

Default hypervisor settings are: 4 CPU's and 8 GB memory.  
This can be changed in ```Vagrantfile```.

