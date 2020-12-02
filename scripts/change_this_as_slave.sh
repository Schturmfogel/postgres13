#!/bin/bash

source /var/lib/pgsql/scripts/ahead_config.sh


echo '      *******************************************'
echo '      *'
echo '      * Warning:: This script will make this VM as a slave node.'
echo '      * Warning:: The data in this VM would be DELETED!'
echo '      * Warning:: Pull the data from master_node: '${master_node}
echo '      * Warning:: Users can NOT execute DML and DLL in this database.'
echo '      * Warning:: Keep READ ONLY transactions in this VM.'
echo '      *    '
echo '      * Press Ctrl+C to quit.'
echo '      *'
echo '      *******************************************'
var_input=''

echo '      Input the word "slave" to continue: '
read -p '      Please Input: ' var_input

##########################
	if [ "$var_input" = "slave" ]
	then
		echo "      Executing..."
	else
		echo "      Quit!"
		exit 0
	fi
##########################

echo '      The data folder is: '${PGDATA}
echo '      The master node is: '${master_node}


/usr/bin/expect <<-EOF
	spawn su root -c "systemctl stop postgresql-13"
	expect "Password:"
	send "${os_user_root_password}\n"
expect eof
EOF


echo '      Try to remove all files in: '${PGDATA}

rm -rf ${PGDATA}

echo '      execute result is: '$?

echo '      The data folder was deleted: '${PGDATA}

/usr/bin/expect <<-EOF
	spawn pg_basebackup -h ${master_node} -U replicator -p 5432 -D ${PGDATA} -Fp -Xs -P -R
	expect "Password:"
	send "${db_user_replicator_password}\n"
expect eof
EOF
echo '      Data pulled from master node: '${master_node}

cp ./config_slave/postgresql.auto.conf ${PGDATA}/postgresql.auto.conf
sed -i 's/{maste_node}/'${master_node}'/' ${PGDATA}/postgresql.auto.conf

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


