#!/bin/sh

echo
echo "Installing the epel repository ..."
EPEL_VERSION=epel-release-6-8.noarch.rpm
curl -L -k http://download.fedoraproject.org/pub/epel/6/x86_64/$EPEL_VERSION > /tmp/$EPEL_VERSION
rpm -ivh /tmp/$EPEL_VERSION
rm -f /tmp/$EPEL_VERSION

echo
echo "Upgrade OS ..."
yum -y upgrade

echo
echo "Install packages ..."
yum -y install sudo dkms nano wget perl gcc bzip2 make kernel-devel-`uname -r`

echo
echo "Create groups and users ..."
groupadd admin
useradd -G admin vagrant
echo vagrant | passwd vagrant --stdin
echo vagrant | passwd root --stdin

echo
echo "Configure sudoers ..."

TEMP_SUDOERS_SCRIPT=/tmp/visudoers-vagrant.sh
cat > $TEMP_SUDOERS_SCRIPT << "EOF"
#!/bin/sh
echo "Changing sudoers"
echo -e "# Created by the vagrant-init script. See https://github.com/septemx4/vagrant-init" > $1
echo -e "Defaults   !visiblepw" >> $1
echo -e "Defaults    always_set_home" >> $1
echo -e "\nDefaults    env_reset" >> $1
echo -e "Defaults    env_keep =  \"COLORS DISPLAY HOSTNAME HISTSIZE INPUTRC KDEDIR LS_COLORS\"" >> $1
echo -e "Defaults    env_keep += \"MAIL PS1 PS2 QTDIR USERNAME LANG LC_ADDRESS LC_CTYPE\"" >> $1
echo -e "Defaults    env_keep += \"LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES\"" >> $1
echo -e "Defaults    env_keep += \"LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE\"" >> $1
echo -e "Defaults    env_keep += \"LC_TIME LC_ALL LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY\"" >> $1
echo -e "Defaults    env_keep += \"SSH_AUTH_SOCK\"" >> $1
echo -e "\nDefaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin" >> $1
echo -e "\nroot	ALL=(ALL) 	ALL" >> $1
echo -e "%admin 	ALL=NOPASSWD: ALL" >> $1
EOF

chmod +x $TEMP_SUDOERS_SCRIPT

echo "Starting up visudo ..."
export EDITOR=$TEMP_SUDOERS_SCRIPT && sudo -E visudo

echo
echo "Install guest additions ..."
echo -e "\"Installing the Window System Drivers\" will fail. This can be ignored."
mkdir /media/cdrom
mount /dev/cdrom /media/cdrom
sh /media/cdrom/VBoxLinuxAdditions.run

echo
echo "Disable DNS lookups for SSH"
echo -e "\nUseDNS no" >> /etc/ssh/sshd_config

echo
echo "Configure SSH keys of user vagrant ..."
mkdir /home/vagrant/.ssh
curl -k https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub > /home/vagrant/.ssh/authorized_keys
chown -R vagrant: /home/vagrant/.ssh
chmod 0755 /home/vagrant/.ssh
chmod 0644 /home/vagrant/.ssh/authorized_keys

echo
echo "Cleanup ..."
yum -y clean all
