#!/bin/bash
#
#

source /var/lib/pgsql/scripts/ahead_config.sh


echo 'The data folder is: '${PGDATA}
echo 'The master node is: '${master_node}


/usr/bin/expect <<-EOF
	spawn su root -c "systemctl stop postgresql-13"
	expect "Password:"
	send "${os_user_root_password}\n"
expect eof
EOF


/usr/bin/expect <<-EOF
	spawn su root -c "systemctl stop postgresql-13"
	expect "Password:"
	send "${os_user_root_password}\n"
expect eof
EOF

rm -rf ${PGDATA}/
echo 'The data folder was deleted: '${PGDATA}

/usr/bin/expect <<-EOF
	spawn pg_basebackup -h ${master_node} -U replicator -p 5432 -D ${PGDATA} -Fp -Xs -P -R
	expect "Password:"
	send "${db_user_replicator_password}\n"
expect eof
EOF
echo 'Data pulled from master node: '${master_node}

cp ./config_slave/postgresql.auto.conf ${PGDATA}/postgresql.auto.conf
sed -i 's/{maste_node}/'${master_node}'/' ${PGDATA}/postgresql.auto.conf

/usr/bin/expect <<-EOF
	spawn su root -c "systemctl start postgresql-13"
	expect "Password:"
	send "${os_user_root_password}\n"
expect eof
EOF



echo 'Restarting postgresql-13'


