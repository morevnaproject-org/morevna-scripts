#!/bin/bash

if [ -z "$1" ]; then
	echo "ERROR: Please specify input file as argument."
	exit 1
fi

SUFFIX="-lossless.avi"
BASENAME=${1%"$SUFFIX"}

rm -f ffmpeg2pass-0.log* || true
#OPTIONS="-c:v libvpx -crf 4 -b:v 8M"
#ffmpeg -y -i "${BASENAME}-lossless.avi" ${OPTIONS} -an  $2 -pass 1 -f webm /dev/null
#ffmpeg -y -i "${BASENAME}-lossless.avi" ${OPTIONS} -c:a libvorbis $2 -pass 2 "${BASENAME}-hq.webm"

OPTIONS="-c:v libvpx-vp9 -tile-columns 2 -row-mt 1 -tile-rows 1 -threads 8 -b:v 0 -crf 7  -quality good"
ffmpeg -y -i "${BASENAME}-lossless.avi" ${OPTIONS} -an  $2 -pass 1 -f webm /dev/null
ffmpeg -y -i "${BASENAME}-lossless.avi" ${OPTIONS} -speed 2 -c:a libopus $2 -pass 2 "${BASENAME}-hq.webm"
