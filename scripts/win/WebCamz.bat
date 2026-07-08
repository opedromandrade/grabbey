@echo off
:: ==============================================================================
:: 🐧 grabbey - WebCamz Subsystem
:: Author: pedro andrade - https://github.com
:: Updated on: 07.2026
:: Description: Captures Windows Desktop with an overlaid Picture-In-Picture WebCam stream.
:: Guidance: Press [q] inside this console terminal to halt recording safely.
:: ==============================================================================

:: Configure Terminal Interface Colors (Green Text on Black Background)
color 0A
cls

echo ==============================================================================
echo   📸 GRABBEY : PICTURE-IN-PICTURE WEBCAM CAPTURE ENGINE
echo ==============================================================================
echo.

:: ------------------------------------------------------------------------------
:: CONFIGURABLE ENVIRONMENT VARIABLES
:: ------------------------------------------------------------------------------
:: Modify these names to match your device outputs exactly from '-list_devices true'
set WEBCAM_NAME=USB 2.0 Camera
set AUDIO_NAME=@device_cm_{33D9A762-90C8-11D0-BD43-00A0C911CE86}\wave_{50951FA9-10CD-44D4-8F67-4C0471E917F3}

:: Resolution scaling arrays
set DESKTOP_RES=1920x1080
set WEBCAM_RES=384x216

:: Video metrics settings
set FRAMERATE=30
set CRF_QUALITY=22
set VIDEO_BITRATE=2M
set AUDIO_BITRATE=256k
set SAMPLERATE=44100
set OUTPUT_FILE=webcam_overlay_capture.mp4

echo [INFO] ⚙️ Initializing video compositing canvas layers...
echo        - Base Desktop Resolution : %DESKTOP_RES%
echo        - Overlay WebCam Scale    : %WEBCAM_RES%
echo        - Capture Device Module   : %WEBCAM_NAME%
echo        - Destination File        : %OUTPUT_FILE%
echo.
echo 🔴 [RECORDING STARTED] 
echo ⚠️  CRITICAL: Click inside this window and press [q] to stop and save video.
echo ------------------------------------------------------------------------------
echo.

:: ------------------------------------------------------------------------------
:: RUN FFMPEG PIP COMPOSITING ENGINE
:: ------------------------------------------------------------------------------
:: Windows Batch lines are broken cleanly using the circumflex accent character (^)
ffmpeg -y -rtbufsize 1900M -thread_queue_size 1024 ^
-f gdigrab -framerate %FRAMERATE% -i desktop ^
-f dshow -thread_queue_size 1024 -i video="%WEBCAM_NAME%":audio="%AUDIO_NAME%" ^
-filter_complex "[0:v]scale=%DESKTOP_RES%[desktop]; [1:v]scale=%WEBCAM_RES%[webcam]; [desktop][webcam]overlay=x=W-w-50:y=H-h-50" ^
-c:v libx264 -crf %CRF_QUALITY% -preset slow -pix_fmt yuv420p -b:v %VIDEO_BITRATE% ^
-c:a aac -b:a %AUDIO_BITRATE% -ar %SAMPLERATE% -async 1 ^
-threads 4 "%OUTPUT_FILE%"

echo.
echo ==============================================================================
echo   🎉 SUCCESS: Recording compositing pipeline cleanly detached.
echo   📦 Video Output Saved As: %OUTPUT_FILE%
echo   *** Safe and sound! ***
echo ==============================================================================
pause
