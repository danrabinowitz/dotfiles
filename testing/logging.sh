#!/bin/bash

echoerr() { echo "$@" 1>&2; }

my_path () {
    echoerr "blah: $0"
    _my_name=`basename \\$0`

    if [ "`echo $0 | cut -c1`" = "/" ]; then
	_my_path=`dirname $0`
    else
	_my_path1=`echo $0 | sed -e s/^\\\.\\\///`
	_my_path=`pwd`/`echo $_my_path1 | sed -e s/$_my_name//`
    fi
    echo "${_my_path}/${_my_name}"
}

log_with_bash_info () {
    local MSG=$1

    local LOGFILE="$HOME/.djr_config_logs"
    local PROCESS_INFO=`ps -lEww $$`
    local my_path2=$(my_path)

    echo "----------------------------------------" >> $LOGFILE
    date >> $LOGFILE
    echo "$my_path2 says $MSG" >> $LOGFILE
    echo "$PROCESS_INFO" >> $LOGFILE
    echo "SHLVL = $SHLVL" >> $LOGFILE
}
