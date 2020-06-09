#!/bin/bash
#

if [ -z "$1" ]; then
echo "ERROR: Please specify directory with WAV files."
exit 1
fi

cd "$1"
for i in `ls -1 "$1"`; do
	BASENAME=`basename "${i}" .wav`
	echo "${BASENAME}.flac"
	flac --best -f  -o "${BASENAME}.flac" "${i}"
done

