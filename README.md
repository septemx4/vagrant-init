vagrant-init
============

Init script for building a vagrant base box from a CentOS 6.3 minimal Virtualbox VM.

How to use
---------

 - Create a Virtualbox VM. See http://docs.vagrantup.com/v1/docs/base_boxes.html for instructions.
  Set memory to 1024Mb to be able to run the CentOS installer.
 - Install CentOS 6.3 minimal. Make sure networking is enabled.
 - Start the Virtualbox VM, select "Install guest additions ..." from Virtualbox.
 - Run the following as root:
  ```bash
  curl -k https://raw.github.com/septemx4/vagrant-init/master/vagrant-init.sh > /tmp/vagrant-init.sh; chmod +x /tmp/vagrant.init.sh; /tmp/vagrant-init.sh
  ```
 - Edit the VM and set the memory used to 360Mb. Enable SSD ...
 - Package the VM as a base box: 
  ```bash
  vagrant package --base name_of_my_vm --vagrantfile Vagrantfile
  ```
