PGDATA=/var/lib/pgsql/13/data/
OOMScoreAdjust=-1000
PG_OOM_ADJUST_FILE=/proc/self/oom_score_adj
PG_OOM_ADJUST_VALUE=0
/usr/pgsql-13/bin/postgresql-13-check-db-dir ${PGDATA}
/usr/pgsql-13/bin/postmaster -D ${PGDATA}