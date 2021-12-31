#!/bin/bash

if [ -z "$1" ]; then
	echo "ERROR: Please specify input file as argument."
	exit 1
fi

SUFFIX="-lossless"
BASENAME="$1"
BASENAME=${BASENAME%".mp4"}
BASENAME=${BASENAME%".avi"}
BASENAME=${BASENAME%"$SUFFIX"}

rm -f ffmpeg2pass-0.log* || true
#OPTIONS="-c:v libvpx -b:v 2M -c:a libvorbis"
#ffmpeg -y -i "${BASENAME}-lossless.avi" ${OPTIONS} $2 -an -pass 1 -f webm /dev/null
#ffmpeg -y -i "${BASENAME}-lossless.avi" ${OPTIONS} $2 -pass 2 "${BASENAME}.webm"

OPTIONS="-c:v libvpx-vp9 -pix_fmt yuv420p -tile-columns 2 -row-mt 1 -tile-rows 1 -threads 8 -b:v 2000k -minrate 1800k -maxrate 2800k -quality good"
ffmpeg -y -i "$1" ${OPTIONS} -an  $2 -pass 1 -f webm /dev/null
ffmpeg -y -i "$1" ${OPTIONS} -speed 2 -c:a libopus $2 -pass 2 "${BASENAME}.webm"
