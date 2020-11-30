#!/bin/bash
log_dir='/mnt/smb/'
wal_nas_dir='/mnt/smb/'
dir_postfix=`hostname --long`
wal_master_live_dir='/mnt/smb/wal_master_live'
log_echo_prefix=' #wal_master_archive_script# '`date "+%F %T"`' @$dir_postfix #'

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


if [ -d "$wal_nas_dir" ]
then 
	echo "$log_echo_prefix: WAL NAS directory exist: $wal_nas_dir"
else
	echo "$log_echo_prefix: Unable to find NAS disk: $wal_nas_dir, this archive cmd will exit with success code, although failed."
	echo "$log_echo_prefix: Unable to find NAS disk: $wal_nas_dir">>$log_dir'error_master_archive.log'
	exit 0
fi

# create the folder if not exists
test -d "$wal_master_live_dir" && echo "$log_echo_prefix: WAL live directory exist: $wal_master_live_dir" || (echo "$log_echo_prefix: Creating the WAL live directory: $wal_master_live_dir" && mkdir $wal_master_live_dir)
#
gzip < $p_archive_path > $wal_master_live_dir/$p_archive_filename.gz 2>>$log_dir'error_master_archive.log' || :
echo $p_archive_filename >> $wal_master_live_dir/archive.list
#
exit 0