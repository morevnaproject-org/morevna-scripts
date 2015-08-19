#!/bin/bash
#
# This is a script for automatically generates zip files from directory tree.
#
# = How it works =
# The script starts scanning from the current directory recursively. 
# Every child directory that have file called "zip.conf" is packed into
# zip. The zip file is placed in "../zips/path/to/dir/" relatively to current 
# location.
#
# I.e. if scrip is started from the "/home/user/projects/" dir and there is
# a "/home/user/projects/a/project-1/zip.conf" file, then it will create 
# "/home/user/zips/projects/a/project-1.zip" archive. 
#
# If archive is already exists, then it is updated in a smart way
# (no full repack takes place).


#PREFIX=$(cd `dirname "$0"`; pwd)
PREFIX=`pwd`
SYNCDIR="${PREFIX}/../zips/`basename ${PREFIX}`"
cd ${PREFIX}

update_zips()
{
    pushd "$1" > /dev/null
    if [ -e "$1/zip.conf" ]; then
	
	# get target archive name
	BASEPATH=`echo "$1" | sed -e "s|^${PREFIX}||"`
	ZIPFILE="${SYNCDIR}/${BASEPATH}.zip"
	ZIPDIR=`dirname "${ZIPFILE}"`
	[ -d "${ZIPDIR}" ] || mkdir -p "${ZIPDIR}"
	echo "Updating ${ZIPFILE}..."
	
	# update zip
	zip -FSr -9 ${ZIPFILE} * -x@${PREFIX}/exclude-zip.lst
	
	# md5sum
	CHECKSUMFILE="${SYNCDIR}/${BASEPATH}-md5sum.txt"
	NEED_CHECKSUM=1
	if [ -e "$CHECKSUMFILE" ]; then
	    if [ "$CHECKSUMFILE" -nt "$ZIPFILE" ]; then
		NEED_CHECKSUM=0
	    fi
	fi
	if [[ $NEED_CHECKSUM == 1 ]]; then
	    echo "Writing md5sum..."
	    pushd `dirname "$CHECKSUMFILE"` >/dev/null
	    md5sum `basename "$ZIPFILE"` > "$CHECKSUMFILE"
	    popd >/dev/null
	fi
	
    else
	for F in `ls -1`; do
	    if [ -d "$1/${F}" ]; then
		update_zips "$1/${F}"
	    fi
	done
    fi
    popd > /dev/null
}

update_zips "${PREFIX}"

