#!/bin/bash
#
#

source /var/lib/pgsql/scripts/ahead_config.sh


echo '      *******************************************'
echo '      *'
echo '      * Warning:: This script will make this VM as a master node.'
echo '      * Warning:: Please *UPDATE* slave VMs to synchronize to this master node.'
echo '      * Warning:: This master_node IP is: '`hostname -I`
echo '      * '`ip address`
echo '      * Warning:: Users are able to execute DML and DLL in this database.'
echo '      * Warning:: Keep READ-WRITE transactions in this VM.'
echo '      *    '
echo '      * Press Ctrl+C to quit.'
echo '      *'
echo '      *******************************************'
var_input=''

echo '      Input the word "master" to continue: '
read -p '      Please Input: ' var_input

##########################
	if [ "$var_input" = "master" ]
	then
		echo "      Executing..."
	else
		echo "      Quit!"
		exit 0
	fi
##########################

echo '      The data folder is: '${PGDATA}
echo '      The '



cp ./config_master/postgresql.auto.conf ${PGDATA}/postgresql.auto.conf
# make this writable.
rm -f ${PGDATA}/standby.signal
## 



/usr/bin/expect <<-EOF
	spawn su root -c "systemctl restart postgresql-13"
	expect "Password:"
	send "${os_user_root_password}\n"
expect eof
EOF


psql -c "CREATE USER replicator WITH REPLICATION ENCRYPTED PASSWORD '${db_user_replicator_password}'";
psql -c "ALTER SYSTEM SET listen_addresses TO '*'";



echo '      Restarting postgresql-13'
echo '      Task completed!'
echo '      '
echo '      '