#!/bin/bash
#
#

source /var/lib/pgsql/scripts/ahead_config.sh


cp ./config_master/postgresql.auto.conf ${PGDATA}/postgresql.auto.conf
rm -f ${PGDATA}/standby.signal
## to_do: update other slave nodes



/usr/bin/expect <<-EOF
	spawn su root -c "systemctl restart postgresql-13"
	expect "Password:"
	send "${os_user_root_password}\n"
expect eof
EOF


psql -c "CREATE USER replicator WITH REPLICATION ENCRYPTED PASSWORD '${db_user_replicator_password}'";
psql -c "ALTER SYSTEM SET listen_addresses TO '*'";