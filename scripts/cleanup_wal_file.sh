#!/bin/bash
#
#
keep_days=30
log_dir='/mnt/smb/'
wal_nas_dir='/mnt/smb/'
dir_postfix=`hostname`
wal_slave_archive_dir='/mnt/smb/wal_slave_archive_'$dir_postfix
wal_master_live_dir='/mnt/smb/wal_master_live'
log_echo_prefix=' #wal_cleanup_script# '`date "+%F %T"`' #'${dir_postfix}'#'

echo '      '
echo '      *'
echo '      * Cleanup the WAL files'
echo '      *'
echo '      '
find ${wal_master_live_dir}/* -mtime +${keep_days} -exec rm {} \;
echo '      '
find ${wal_slave_archive_dir}/* -mtime +${keep_days} -exec rm {} \;
echo '      '
echo '      Cleanup job done!'
echo '      '
echo '      '