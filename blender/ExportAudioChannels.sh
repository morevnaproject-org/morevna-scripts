#!/bin/bash
#

BLENDFILE="$1"
OUTPUT="${BLENDFILE}-tracks"

CHANNELS=""

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

OUTPUT="${OUTPUT}.flac"
USER=`whoami`
TMPNAME="/tmp/BlenderExportAudio-$USER-$RANDOM"
SCRIPTFILE="${TMPNAME}.py"
WAVFILE="${TMPNAME}.wav"


cat > ${SCRIPTFILE} <<EOF

channels=[${CHANNELS}]
output="${WAVFILE}"

import bpy

seq=bpy.data.scenes[0].sequence_editor.sequences_all
for i in seq:
	if not i.channel in channels:
		i.mute=True

bpy.ops.sound.mixdown(filepath=output, container='WAV', codec='PCM')
EOF

blender -b "$BLENDFILE" -P "$SCRIPTFILE"
flac --best -f  -o "${OUTPUT}" "${WAVFILE}" 

rm -rf "${WAVFILE}"
rm -rf "${SCRIPTFILE}"

