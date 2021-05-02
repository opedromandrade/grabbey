# grabbey
Simple script for screen recording Windows desktop and WebCam using ffmpeg

## The idea
The idea was to create a simple, tool, hence a script, that not only recorded the desktop but also the webcam, on a Microsoft Win. It's perfect simple and opensource for anyone who, i.e. wants to make a tutorial. It basically just uses [ffmpeg](https://ffmpeg.org/) to call the hardware of your machine, and record the different streams.

## Usage
1. Download [ffmpeg](https://ffmpeg.org/) for windows [here](https://www.gyan.dev/ffmpeg/builds/ffmpeg-git-full.7z)
2. On the same folder you have [ffmpeg](https://ffmpeg.org/), type the following command to show all recording "devices"
 `> ffmpeg.exe -list_devices true -f dshow -i dummy`
3. Change the variables on the script and use it!