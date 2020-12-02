#!/bin/bash

source /var/lib/pgsql/scripts/ahead_config.sh


echo '      *******************************************'
echo '      *'
echo '      * Warning:: This script will restore the data from a snapshot.'
echo '      * Warning:: The data in this VM would be DELETED!'
echo '      * Warning:: This script will make this VM as a *MASTER* node.'
echo '      * Warning:: Please *UPDATE* slave VMs to synchronize to this master node IP.'
echo '      * Warning:: This master IP is here: '`hostname -I`
echo '      * Warning:: Users are able to execute DML and DLL in this database.'
echo '      * Warning:: Keep READ-WRITE transactions in this VM.'
echo '      *    '
echo '      * Press Ctrl+C to quit.'
echo '      *'
echo '      *******************************************'


var_input=''
var_snapshot=''

echo '      Input the word "restore" to continue: '
read -p '      Please Input: ' var_input

##########################
	if [ "$var_input" = "restore" ]
	then
		echo "      Executing..."
	else
		echo "      Quit!"
		exit 0
	fi
##########################


# var_snapshot
echo '      Input full snapshot file path and name '
read -p '      Please input snapshot file: ' var_snapshot
if [ -z "$var_snapshot" ]
then
      echo "      Snapshot file path is NULL"
	  exit 0
else
      echo "      Snapshot file path is: "${var_snapshot}
fi


echo '      Stoping the database '
#


/usr/bin/expect <<-EOF
	spawn su root -c "systemctl stop postgresql-13"
	expect "Password:"
	send "${os_user_root_password}\n"
expect eof
EOF


#
echo '      Try to remove all files in: '${PGDATA}
rm -rf ${PGDATA}/*
echo '      execute result is: '$?
echo '      The data folder was deleted: '${PGDATA}

test -d ${PGDATA} && echo "data directory exist: "${PGDATA} || (echo "Creating the data directory: "${PGDATA} && mkdir ${PGDATA})


#
unzip ${var_snapshot} -d ${PGDATA}
echo '      execute result is: '$?

chmod -R 750 ${PGDATA}


##
cp –r ${var_unzip_dir}/* ${PGDATA}/
cp ./config_master/postgresql.auto.conf ${PGDATA}/postgresql.auto.conf
# make this writable.
rm -f ${PGDATA}/standby.signal
## 

psql -c "CREATE USER replicator WITH REPLICATION ENCRYPTED PASSWORD '${db_user_replicator_password}'";
psql -c "ALTER SYSTEM SET listen_addresses TO '*'";

/usr/bin/expect <<-EOF
	spawn su root -c "systemctl start postgresql-13"
	expect "Password:"
	send "${os_user_root_password}\n"
expect eof
EOF


echo '      Restarting postgresql-13'
echo '      Task completed!'
echo '      '
echo '      '




