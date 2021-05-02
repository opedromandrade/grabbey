@echo off
# Change the variables accordingly
ffmpeg -y -rtbufsize 1900M -f gdigrab -framerate 30 -i desktop -f dshow 
-i video="WEBCAM_HERE":audio="AUDIO_INPUT_HERE" \
-filter_complex "[0:v] scale=DESKTOPxRES [desktop]; [1:v] scale=WebxCAm_Res [webcam]; [desktop][webcam] overlay=x=W-w-50:y=H-h-50" \
-b:v 2M -b:a 256k -ar 44100 -threads 4 -vcodec libx264 -crf 22 -preset slow -pix_fmt yuv420p \
output.mp4