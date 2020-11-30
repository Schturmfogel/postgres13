sudo systemctl stop postgresql-13
systemctl status postgresql-13

# backup data
su - postgres
zip -r  /var/lib/pgsql/13.zip /var/lib/pgsql/13 
rm -rf $PGDATA/
pg_basebackup -h 192.168.3.137 -U replicator -p 5432 -D $PGDATA -Fp -Xs -P -R

systemctl start postgresql-13
systemctl status postgresql-13
systemctl stop postgresql-13
systemctl restart postgresql-13


echo "archive_mode = always" >> $PGDATA/postgresql.auto.conf
dir_postfix=`hostname --long`
wal_slave_archive_dir='/mnt/smb/wal_slave_archive_'$dir_postfix
test -d "$wal_slave_archive_dir" && echo " WAL slave archive directory exist!" || (echo "Creating slave WAL directory: $wal_slave_archive_dir" && mkdir $wal_slave_archive_dir)



# Slave Setting
# Archive setting
archive_mode = 'always'
archive_command = '/var/lib/pgsql/scripts/wal_slave_archive_command.sh %p %f'
restore_command = '/var/lib/pgsql/scripts/wal_slave_restore_command.sh %p %f'
listen_addresses = '*'


