#!/bin/bash
#

BLENDFILE="$1"
OUTPUT="${BLENDFILE}-tracks"

CHANNELS=""

set -e

if [ -z $2 ]; then
	echo "Please specify at least one track!"
	exit 1
else
	CHANNELS="$2"
	OUTPUT="${OUTPUT}-$2"
fi

if [ ! -z $3 ]; then
	CHANNELS="${CHANNELS},$3"
	OUTPUT="${OUTPUT}-$3"
fi

if [ ! -z $4 ]; then
	CHANNELS="${CHANNELS},$4"
	OUTPUT="${OUTPUT}-$4"
fi

if [ ! -z $5 ]; then
	CHANNELS="${CHANNELS},$5"
	OUTPUT="${OUTPUT}-$5"
fi

if [ ! -z $6 ]; then
	CHANNELS="${CHANNELS},$6"
	OUTPUT="${OUTPUT}-$6"
fi

if [ ! -z $7 ]; then
	CHANNELS="${CHANNELS},$7"
	OUTPUT="${OUTPUT}-$7"
fi

if [ ! -z $8 ]; then
	CHANNELS="${CHANNELS},$8"
	OUTPUT="${OUTPUT}-$8"
fi

if [ ! -z $9 ]; then
	CHANNELS="${CHANNELS},$9"
	OUTPUT="${OUTPUT}-$9"
fi

if [ ! -z ${10} ]; then
	CHANNELS="${CHANNELS},${10}"
	OUTPUT="${OUTPUT}-${10}"
fi

if [ ! -z ${11} ]; then
	CHANNELS="${CHANNELS},${11}"
	OUTPUT="${OUTPUT}-${11}"
fi

if [ ! -z ${12} ]; then
	CHANNELS="${CHANNELS},${12}"
	OUTPUT="${OUTPUT}-${12}"
fi

USER=`whoami`
TMPNAME="/tmp/BlenderExportAudio-$USER-$RANDOM"
SCRIPTFILE="${TMPNAME}.py"
WAVFILE="${OUTPUT}.wav"
FLACFILE="${OUTPUT}.flac"


cat > ${SCRIPTFILE} <<EOF

channels=[${CHANNELS}]
output="${WAVFILE}"

import bpy

seq=bpy.context.scene.sequence_editor.sequences_all
for i in seq:
	if not i.channel in channels:
		i.mute=True

bpy.ops.sound.mixdown(filepath=output, container='WAV', codec='PCM', format='F32', accuracy=512)
EOF

blender -b "$BLENDFILE" -P "$SCRIPTFILE"

# flac encoding
sox "${WAVFILE}" -b24 "${TMPNAME}.wav"
flac --best -f  -o "${FLACFILE}" "${TMPNAME}.wav" 

rm -rf "${TMPNAME}.wav"
rm -rf "${SCRIPTFILE}"

