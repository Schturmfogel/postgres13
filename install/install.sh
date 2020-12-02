systemctl stop postgresql-13
systemctl start postgresql-13
systemctl disable postgresql-13
systemctl enable postgresql-13 
systemctl status postgresql-13
journalctl -u postgresql-13
journalctl -xe


############
# Install the repository RPM:
sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
# Disable the built-in PostgreSQL module:
sudo dnf -qy module disable postgresql
# Install PostgreSQL:
sudo dnf install -y postgresql13-server
# Optionally initialize the database and enable automatic start:
sudo /usr/pgsql-13/bin/postgresql-13-setup initdb sudo
systemctl disable postgresql-13



############
# Change host name in each VM
hostnamectl set-hostname postgres001
hostnamectl set-hostname postgres002
hostnamectl set-hostname postgres003


############
systemctl disable postgresql-13
sudo dnf install samba samba-common samba-client
sudo mkdir /mnt/smb/


############
## put following into /etc/rc.d/rc.local
## chmod +x /etc/rc.d/rc.local
############
sudo mount -t cifs -o gid=26,uid=26,username=meadlai,password=mblaiqinyi33,rw,hard //192.168.50.51/shared/ /mnt/smb/
sudo systemctl start postgresql-13


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