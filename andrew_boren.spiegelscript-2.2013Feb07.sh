#!/bin/bash
# Author: Andrew Boren (Andrew.Boren@gmail.com)
# 
# This script is designed to backup everything in the current users
# home directory, unless used with the -q </path/to/backup/> option
# and argument. it is very rough, and intended to be improved upon
# over this class's time frame. 

###### WARNING ###### Do not execute this if testing, you will
# backup your entier ${HOME} directory, which could be rather large.
# if testing is necessary, use the -h option to specify a smaller directory.

pgm="${0##*/}"
pgm_dir="${0%/*}"
conffile="${pgm_dir}/${pgm%.sh}.conf"
# if [ -r "${conffile}" ] ; then
	# source "${conffile}"
# fi

### Configuration
##
#

# Set default home directory to backup
# default to verbose (non-quiet) loggin
# set default tar name to home-backup.MM.DD.YY.tar.gz
homedir="${HOME}"
quiet=false
tarname="home-backup.$(date +"%m.%d.%Y").tar.gz"
##
###

# Parse our options ( h, q & t )
while getopts "h:t:q" opt ; do
	case "$opt" in
		'h' ) homedir="${OPTARG}"
		      echo "Alternate home dir specified: '${homedir}'" ;;
		'q' ) quiet=true ;;
		't' ) tarname=${OPTARG}
		      echo "Alternate tarname specified: '${tarname}'" ;;
		\?  ) echo "Unknown option." ;;
	esac
done
shift $((${OPTIND} - 1))

# Normally du seems to be tab delimeted when grepping the total with -ch options
# but when assigning it to a variable, it turns into a space. Either case
# [[:space:]] works for both
if [ "false" = "${quiet}" ] ; then
	dirsize=$(du -ch ${homedir} | grep "total")
	echo "Home directory size: '${dirsize%%[[:space:]]*}'"
fi

# if the -q option is not used, echo the dir
# and tar name we're using to backup.
if [ "false" = "${quiet}" ] ; then
	echo "Backing up '${homedir}' to '${tarname}'"
fi

# tar -- Using -p c to create and archive, -z to use gzip
# -p to preserve permission, -P so we can use an absolute path
tar -czpPf ${tarname} ${homedir}

# if tar returned okay and -q option was not used
# let the user know the backup was successful
if [ 0 -eq ${?} ] && [ "false" = "${quiet}" ] ; then
	echo "Backup executed as planned!"
fi
