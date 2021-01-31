#!/usr/bin/env bash

# Utility to convert video files to GIFs using ffmpeg
#
# Usage: convert-to-gif.sh <video-file-path>
# To skip frames: convert-to-gif.sh <video-file-path> <time-in-seconds>
# Example:
# convert-to-gif.sh video.mp4 28


if [[ -z "$1" ]]; then
    echo "No video file specified"
    exit 1
fi

# get everything after last /
video=${1##*/}
# remove everything after .
filename=${video%.*}

echo -e "$(tput bold) Getting video dimensions $(tput sgr0)"
# Get video dimensions
dimensions=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$1")

echo -e "$(tput bold) Generating Palette $(tput sgr0)"
# Generate palette
ffmpeg -i "$1" -vf "fps=22,scale=${dimensions%x*}:-1:flags=lanczos,palettegen" "$filename".png

echo -e "$(tput bold) Converting Video to GIF $(tput sgr0)"

if [[ "$2" ]]; then
    ffmpeg -t "$2" -i "$1" -i "$filename".png -filter_complex "fps=22,scale=${dimensions%x*}:-1:flags=lanczos[x];[x][1:v]paletteuse" "$filename".gif
else
    ffmpeg -i "$1" -i "$filename".png -filter_complex "fps=22,scale=${dimensions%x*}:-1:flags=lanczos[x];[x][1:v]paletteuse" "$filename".gif
fi

echo -e "Removing palette"
rm "$filename".png
