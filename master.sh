su root
sudo su - postgres
# check the PGDATA
# echo $PGDATA
# cat .bash_profile
# /usr/lib/systemd/system/postgresql-13.service
# Environment=PGDATA=/var/lib/pgsql/13/data/

echo "export PATH=/usr/pgsql-13/bin:$PATH PAGER=less" >> ~/.pgsql_profile
echo "export PGDATA=/var/lib/pgsql/13/data" >> ~/.pgsql_profile
#
source ~/.pgsql_profile

#
psql -c "ALTER SYSTEM SET listen_addresses TO '*'";
sudo systemctl restart postgresql-13
psql -c "CREATE USER replicator WITH REPLICATION ENCRYPTED PASSWORD 'linux'";

# Add slave IPs into master config
echo "host replication replicator 192.168.3.138/32 scram-sha-256" >> $PGDATA/pg_hba.conf
echo "host replication replicator 192.168.3.139/32 scram-sha-256" >> $PGDATA/pg_hba.conf
echo "host all         all        0.0.0.0/0        scram-sha-256" >> $PGDATA/pg_hba.conf
echo "host all         all        ::0/0            scram-sha-256" >> $PGDATA/pg_hba.conf



# Reload the 
psql -c "select pg_reload_conf()"

# Firewall check
systemctl status firewalld.service
systemctl status iptables.service 
systemctl status ip6tables.service

systemctl stop firewalld.service
systemctl disable firewalld.service 


# Eable archive
sudo mount -t cifs -o gid=26,uid=26,username=meadlai,rw,hard //192.168.50.51/shared/ /mnt/smb/
wal_master_live_dir='/mnt/smb/wal_master_live'
test -d "$wal_master_live_dir" && echo " WAL live directory exist!" || (echo "Creating the WAL live directory: $wal_master_live_dir" && mkdir $wal_master_live_dir)
echo "max_wal_size = 2GB" >> $PGDATA/postgresql.auto.conf


# Master Setting
# Not block the transaction with WAL
synchronous_commit = 'off'
archive_mode = 'ON'
archive_command = '/var/lib/pgsql/scripts/wal_master_archive_command.sh %p %f'
listen_addresses = '*'

