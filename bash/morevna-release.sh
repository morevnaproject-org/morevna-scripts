#!/bin/bash

if [ -z "$1" ]; then
	echo "ERROR: Please specify input file as argument."
	exit 1
fi

# https://stackoverflow.com/questions/59895/how-to-get-the-source-directory-of-a-bash-script-from-within-the-script-itself
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

$DIR/morevna-release-webm.sh "$1" "$2"
$DIR/morevna-release-webm-hq.sh "$1" "$2"
$DIR/morevna-release-mp4.sh "$1" "$2"
$DIR/morevna-release-mp4-hq.sh "$1" "$2"
