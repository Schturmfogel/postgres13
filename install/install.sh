sudo dnf install samba samba-common samba-client cifs-utils
sudo dnf install cifs-utils -y




smb://192.168.50.51/shared
sudo umount /mnt/smb


mkdir /mnt/smb
sudo mount -t cifs -o gid=1000,uid=1000,username=meadlai,vers=1.0,rw,hard //192.168.50.51/shared/ /mnt/smb/

sudo mount -t cifs -o gid=26,uid=26,username=meadlai,rw,hard //192.168.50.51/shared/ /mnt/smb/


#find / -name initdb
/usr/pgsql-13/bin/initdb -D /mnt/smb/data
/usr/pgsql-13/bin/postgres -D /mnt/smb/data -p 5533  >logfile 2>&1 &

#install
# Install the repository RPM:
sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
# Disable the built-in PostgreSQL module:
sudo dnf -qy module disable postgresql
# Install PostgreSQL:
sudo dnf install -y postgresql13-server
# Optionally initialize the database and enable automatic start:
sudo /usr/pgsql-13/bin/postgresql-13-setup initdb
sudo systemctl enable postgresql-13
sudo systemctl start postgresql-13

#check status
ps -ef | grep post
service postgresql-13  status


#set password
sudo  passwd -d postgres
sudo -u postgres psql
ALTER USER postgres WITH PASSWORD 'my_password';
\q
