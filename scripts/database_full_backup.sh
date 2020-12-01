#!/bin/bash
#
#

source /var/lib/pgsql/scripts/ahead_config.sh


set timeout 60

#
backup_nas_dir='/mnt/smb/'
#dir_postfix=`hostname --long`
dir_postfix=`hostname`

backup_full_database_dump_dir='/mnt/smb/full_database_dump_'$dir_postfix
backup_full_database_snapshot_dir='/mnt/smb/full_database_snapshot_'$dir_postfix
log_echo_prefix=' #database_baskup_script# '`date "+%F %T"`' @$dir_postfix #'

if [ -d "$backup_nas_dir" ]
then 
	echo "$log_echo_prefix: WAL NAS directory exist: $backup_nas_dir"
else
	echo "$log_echo_prefix: Unable to find NAS disk: $backup_nas_dir, this backup cmd will exit with success code, although failed."
	echo "$log_echo_prefix: Unable to find NAS disk: $backup_nas_dir">>$log_dir'error_backup_'$dir_postfix'.log'
	exit 0
fi

# create the folder if not exists
test -d "$backup_full_database_dump_dir" && echo "$log_echo_prefix: database dump directory exist: $backup_full_database_dump_dir" || (echo "$log_echo_prefix: Creating the database dump directory: $backup_full_database_dump_dir" && mkdir $backup_full_database_dump_dir)
#

# create the folder if not exists
test -d "$backup_full_database_snapshot_dir" && echo "$log_echo_prefix: database snapshot directory exist: $backup_full_database_snapshot_dir" || (echo "$log_echo_prefix: Creating the database snapshot directory: $backup_full_database_snapshot_dir" && mkdir $backup_full_database_snapshot_dir)
#

dump_file_name='FULL_DATABASE_DUMP_'`date "+%Y_%m_%d_T_%H_%M_%S"`'.dmp'
snapshot_folder_name='FULL_DATABASE_SNAPSHOT_'`date "+%Y_%m_%d_T_%H_%M_%S"`

# create the folder if not exists
test -d "$snapshot_folder_name" && echo "$log_echo_prefix: database snapshot directory exist: $snapshot_folder_name" || (echo "$log_echo_prefix: Creating the database snapshot directory: $snapshot_folder_name" && mkdir $backup_full_database_snapshot_dir'/'$snapshot_folder_name)

#pg_dumpall -h localhost -U postgres -p 5432 -f /mnt/smb/test_dumpall.dmp
/usr/bin/expect <<-EOF
	spawn pg_dumpall -h localhost -U postgres -p 5432 -f $backup_full_database_dump_dir/$dump_file_name
	while 1 {
		expect "Password:"
		send "${db_user_postgres_password}\n"
	}
expect eof
EOF

cd $backup_full_database_dump_dir
#
gzip $backup_full_database_dump_dir'/'$dump_file_name

#pg_basebackup -h localhost -U replicator -p 5432 -D /mnt/smb/test_backup -Fp -Xs -P -R
/usr/bin/expect <<-EOF
	spawn pg_basebackup -h localhost -U replicator -p 5432 -D $backup_full_database_snapshot_dir/$snapshot_folder_name -Fp -Xs -P -R
	expect "Password:"
	send "${db_user_replicator_password}\n"
expect eof
EOF

cd $backup_full_database_snapshot_dir
#
zip -r ./$snapshot_folder_name'.zip' ./$snapshot_folder_name
rm -rf $backup_full_database_snapshot_dir'/'$snapshot_folder_name
