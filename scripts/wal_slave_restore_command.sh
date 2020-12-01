#!/bin/bash
log_dir='/mnt/smb/'
wal_nas_dir='/mnt/smb/'
dir_postfix=`hostname`
wal_master_live_dir='/mnt/smb/wal_master_live'
log_echo_prefix=' #wal_slave_restore_script# '`date "+%F %T"`' #'${dir_postfix}'#'

#  %p
p_archive_path=$1
#  %f
p_archive_filename=$2

# always return the exit code 0 to avoid the WAL log blocked.
# this incident should be report to DBA

if [ -z "$p_archive_path" ]
then
      echo "$log_echo_prefix: p_archive_path is NULL"
	  exit 0
else
      echo "$log_echo_prefix: p_archive_path=$p_archive_path"
fi

if [ -z "$p_archive_filename" ]
then
      echo "$log_echo_prefix: p_archive_filename is NULL"
	  exit 0
else
      echo "$log_echo_prefix: p_archive_filename=$p_archive_filename"
fi


if [ -d "$wal_master_live_dir" ]
then 
	echo "$log_echo_prefix: WAL source directory exist: $wal_master_live_dir"
else
	echo "$log_echo_prefix: Unable to find WAL source directory: $wal_master_live_dir, this restore cmd will exit with success code, although failed."
	echo "$log_echo_prefix: Unable to find WAL source directory: $wal_master_live_dir">>$log_dir'error_slave_restore_'$dir_postfix'.log'
	exit 0
fi

#
gunzip < $wal_master_live_dir/$p_archive_filename.gz > $p_archive_path 2>>$log_dir'error_slave_restore_'$dir_postfix'.log' || :
#
exit 0