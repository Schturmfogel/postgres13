#!/bin/bash
#
#
keep_days=1
log_dir='/mnt/smb/'
wal_nas_dir='/mnt/smb/'
dir_postfix=`hostname`
backup_full_database_dump_dir='/mnt/smb/full_database_dump_'$dir_postfix
backup_full_database_snapshot_dir='/mnt/smb/full_database_snapshot_'$dir_postfix
log_echo_prefix=' #backup_cleanup_script# '`date "+%F %T"`' #'${dir_postfix}'#'

echo '      '
echo '      *'
echo '      * Cleanup the backup files'
echo '      *'
echo '      '
find ${backup_full_database_dump_dir}/* -mtime +${keep_days} -exec rm {} \;
echo '      '
find ${backup_full_database_snapshot_dir}/* -mtime +${keep_days} -exec rm {} \;
echo '      '
echo '      Cleanup job done!'
echo '      '
echo '      '