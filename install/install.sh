systemctl stop postgresql-13
systemctl start postgresql-13

systemctl disable postgresql-13
systemctl enable postgresql-13 


systemctl status postgresql-13




############
hostnamectl set-hostname postgres001
hostnamectl set-hostname postgres002
hostnamectl set-hostname postgres003

############
sudo dnf install samba samba-common samba-client
sudo mkdir /mnt/smb/
systemctl disable postgresql-13
systemctl status postgresql-13
journalctl -u postgresql-13


############
## put following into /etc/rc.d/rc.local
## chmod +x /etc/rc.d/rc.local
############
sudo mount -t cifs -o gid=26,uid=26,username=meadlai,password=mblaiqinyi33,rw,hard //192.168.50.51/shared/ /mnt/smb/
systemctl start postgresql-13


###########
sudo mkdir /var/lib/pgsql/scripts
#cp scripts/* /var/lib/pgsql/scripts
chmod +x /var/lib/pgsql/scripts/*.sh
chown postgres /var/lib/pgsql/scripts
chown postgres /var/lib/pgsql/scripts/*
chgrp postgres /var/lib/pgsql/scripts
chgrp postgres /var/lib/pgsql/scripts/*




############
chmod +x /etc/rc.d/rc.local
systemctl enable rc-local
systemctl show rc-local
journalctl -u rc-local
vi /etc/ssh/sshd_config
# userDNS=no