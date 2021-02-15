#!/bin/bash


x264enc='libx264 -tune zerolatency -profile:v baseline -preset ultrafast -bf 0 -refs 3 -sc_threshold 0'

ffmpeg/ffmpeg \
-f lavfi -i "testsrc2=size=1920x1080:rate=24" -f lavfi -i "sine=frequency=440:b=4" \
 -b:v 3000k \
   -pix_fmt yuv420p \
    -f flv  -c:v ${x264enc} \
    rtmp://localhost:1935/live


#    -hide_banner \
#    -loglevel error \
#    -re \
#    -f lavfi \
#    -i "testsrc2=size=1920x1080:rate=30" \
#    -f lavfi \
#    -i "sine=frequency=440:b=4" \
#    -pix_fmt yuv420p \
#    -map 0:v 1:a\
#    -c:v ${x264enc} \
#    -g 60 \
#    -keyint_min 60 \
#    -b:v 3000k \
#    -vf "fps=30,drawtext=fontfile=utils/OpenSans-Bold.ttf:box=1:fontcolor=black:boxcolor=white:fontsize=100':x=40:y=400:textfile=utils/text.txt" \

