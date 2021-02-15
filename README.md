I am kicking off from Colleen Henry's low latency dash preview




# Streamline Low Latency DASH preview

This is a proof of concept system for generating a low latency live stream from encoder, to server, to player using entirely open source software end to end. It will render a page with a player in it. The player will display a video that has a test pattern generated by the encoder with an embedded timecode burned into the video. This is the "encoder time" timecode. On top of that there is a time code overlaid on the player. This is the wall clock or player timecode. The difference between these two clocks is your precise end to end latency. 

This player will load extra quickly and then play with time a bit to "walk in" the latency. This means it will play faster than real time until it catches up to the latency that you are requesting. Our default here is 2.2 seconds. 


![screenshot](https://s3-us-west-1.amazonaws.com/streamlinevideo/screenshot.png)



## Things to know

- The work in this repo on low latency will later form the basis of an update to the larger [streamline](https://github.com/streamlinevideo/streamline) project. It is a proof of concept / preview for a future version called streamline prime. If you are interested in the streamline prime project, check out [this discussion](https://github.com/streamlinevideo/streamline/issues/13).
- This demo assumes that you are using Ubuntu / Debian or MacOS
- This demo provides everything you need to run a low latency live stream for educational purposes
- This is a preview and proof of concept. It is not meant to be used in production. There has not been extensive testing yet. There are bugs. I promise you, there are bugs ;). Feel free to test, contribute fixes, etc, but don't dive right in and assume the pieces are production ready.

## TODO for preview project

- Maybe Windows directions and scripts
- Polish server performance and reliability
- Add ABR demo once dash.js fixes some bugs
- Roll everything into a streamline prime project 

## Building 

### Ubuntu  / Debian

Run...

    wget https://codeload.github.com/streamlinevideo/low-latency-preview/zip/master && unzip master && rm -r -f master/ && cd low-latency-preview-master/ && ./buildEncoderAndServerUbuntu.sh

You have now built everything. Continue to the run section.

### MacOS

First make sure you have [homebrew](https://brew.sh/) installed.

Run....

    curl -o master.zip https://codeload.github.com/streamlinevideo/low-latency-preview/zip/master && unzip master.zip && cd low-latency-preview-master/ && ./buildEncoderAndServerMacOS.sh
    
## Running the server

    ./launchServer.sh

## Running the test pattern generator and encoder 

    ./launchEncoderTestPattern.sh *insert destination hostname of server* *insert a stream name*

Example: 

    ./launchEncoderTestPattern.sh localhost 1234

## View your content

    Oh 💩 here we go!
    View your stream at http://localhost:8080/ldash/play/1324/manifest.mpd

Go to that URL and you should see your stream! 

To kill the streams...

    ./killAll.sh

## What do I do with this?

Be impressed by the speed! Be excited by the opportunities for scalability. Learn about the realities of low latency live streaming and how to implement it. You can learn form this and modify parts to build your own own live streaming system. This project itself doesn't have a huge use, the proof of concept of the architecture, the server that we have created, and the documented settings for FFmpeg and dash.js are what is of value to other projects.

## Join the streamline community

The streamline team hangs out in the [video-dev](http://video-dev.herokuapp.com/) slack in the [#streamline room](https://video-dev.slack.com/messages/CD03ZUF8F).  Feel free to join the fun, ask for features, give feedback, etc.

## Credits

If you have enabled Origin-Assisted Prefetch, you must ensure that your origin sends a response header that includes the absolute/relative path in the URLs for the manifest and segment files that must be prefetched.


- Credit to Lei Zhang [@codingtmd](https://github.com/codingtmd) for writing the server. 
- Thank you to Matt Szatmary [@szatmary](https://github.com/szatmary) for helping us debug. 
- Credit to Karthic Jeypal [@jkarthic-akamai](https://github.com/jkarthic-akamai) for his work on FFmpeg that makes this possible. 
- Credit to Will Law [@wilaw](https://github.com/wilaw) and the whole dash.js team for the player that enables this. We are using the dash.js player. Feel free to visit their [website](http://reference.dashif.org/dash.js/nightly/samples/dash-if-reference-player/index.html) for their nightly reference player or their [github](https://github.com/Dash-Industry-Forum/dash.js/wiki).
- ...and I guess me,  Colleen Kelly Henry [@colleenkhenry](https://github.com/colleenkhenry), for putting this all together.
