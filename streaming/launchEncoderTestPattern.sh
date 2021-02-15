#!/bin/bash

if [ -z "$1" ]; then
    TARGETSERVER="127.0.0.1"
    echo "Target Server not specified, assuming ${TARGETSERVER}..."
else
    TARGETSERVER="$1"
fi

if [ -z "$2" ]; then
    STREAMID="1234"
    echo "Target Path not specified, assuming ${STREAMID}..."
else
    STREAMID="$2"
fi



if [ -z "$3" ]; then
    PORT="8080"
    echo "Target Port not specified, assuming ${PORT}..."
else
    PORT="$3"
fi

echo Oh 💩 here we go!
echo View your stream at http://${TARGETSERVER}:${PORT}/ldashplay/${STREAMID}/manifest.mpd

# Encoding settings for x264 (CPU based encoder)

x264enc='libx264 -tune zerolatency -profile:v baseline -preset ultrafast -bf 0 -refs 3 -sc_threshold 0'

ffmpeg/ffmpeg \
    -hide_banner \
    -loglevel error \
    -re \
    -f lavfi \
    -i "testsrc2=size=1920x1080:rate=30" \
    -f lavfi -i "sine=frequency=440:b=4" \
    -c:v ${x264enc} \
    -g 60 \
    -map 0:v \
    -keyint_min 60 \
    -b:v 3000k \
    -pix_fmt yuv420p \
    -vf "fps=30,drawtext=fontfile=OpenSans-Bold.ttf:box=1:fontcolor=black:boxcolor=white:fontsize=100':x=40:y=400:textfile=text.txt" \
    -method PUT \
    -seg_duration 2 \
    -streaming 1 \
    -http_persistent 1 \
    -utc_timing_url "https://time.akamai.com/?iso" \
    -index_correction 1 \
    -use_timeline 0 \
    -media_seg_name 'chunk-stream-$RepresentationID$-$Number%05d$.m4s' \
    -init_seg_name 'init-stream1-$RepresentationID$.m4s' \
    -window_size 2  \
    -extra_window_size 3 \
    -remove_at_exit 1 \
    -adaptation_sets "id=0,streams=v" \
    -f dash \
    http://${TARGETSERVER}:${PORT}/ldash/${STREAMID}/manifest.mpd
