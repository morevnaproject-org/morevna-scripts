#!/bin/bash

if [ -z "$1" ]; then
	echo "ERROR: Please specify input file as argument."
	exit 1
fi

SUFFIX="-lossless.avi"
BASENAME=${1%"$SUFFIX"}

rm -f ffmpeg2pass-0.log* || true
OPTIONS="-c:v libx264 -preset slow -b:v 6M -x264-params keyint=5 -c:a aac -b:a 224k"
ffmpeg -y -i "${BASENAME}-lossless.avi" ${OPTIONS} $2 -an -pass 1 -f mp4 /dev/null
ffmpeg -y -i "${BASENAME}-lossless.avi" ${OPTIONS} $2 -pass 2 "${BASENAME}-hq.mp4"
