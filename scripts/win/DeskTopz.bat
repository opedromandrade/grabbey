@echo off
:: ==============================================================================
:: 🐧 grabbey - Desktopz Subsystem
:: Author: pedro andrade - https://github.com
:: Updated on: 07.2026
:: Description: High-performance desktop screen and default audio capture engine.
:: Guidance: Press [q] inside this console terminal to halt recording safely.
:: ==============================================================================

:: Configure Terminal Interface Colors (Cyan Text on Black Background)
color 0B
cls

echo ==============================================================================
echo   🎥 GRABBEY : DESKTOP AUDIO-VIDEO CAPTURE FRAMEWORK
echo ==============================================================================
echo.

:: ------------------------------------------------------------------------------
:: CONFIGURABLE ENVIRONMENT VARIABLES
:: ------------------------------------------------------------------------------
:: Target the system's global default audio node automatically
set AUDIO_DEVICE=Default Audio Device
set FRAMERATE=30
set VIDEO_BITRATE=2M
set AUDIO_BITRATE=256k
set SAMPLERATE=44100
set CRF_QUALITY=16
set OUTPUT_FILE=desktop_capture.mp4

echo [INFO] ⚙️ Checking target recording parameters...
echo        - Framerate   : %FRAMERATE% FPS
echo        - CRF Quality : %CRF_QUALITY% (Lower equals higher quality)
echo        - Audio Node  : %AUDIO_DEVICE%
echo        - Output Path : %OUTPUT_FILE%
echo.
echo 🔴 [RECORDING STARTED] 
echo ⚠️  CRITICAL: Click inside this window and press [q] to stop and save video.
echo ------------------------------------------------------------------------------
echo.

:: ------------------------------------------------------------------------------
:: RUN FFMPEG GRABBER ENGINE
:: ------------------------------------------------------------------------------
ffmpeg -y -rtbufsize 1900M -thread_queue_size 1024 ^
-f gdigrab -framerate %FRAMERATE% -i desktop ^
-f dshow -thread_queue_size 1024 -i audio="%AUDIO_DEVICE%" ^
-c:v libx264 -crf %CRF_QUALITY% -preset slow -pix_fmt yuv420p -b:v %VIDEO_BITRATE% ^
-c:a aac -b:a %AUDIO_BITRATE% -ar %SAMPLERATE% -async 1 ^
-threads 4 "%OUTPUT_FILE%"

echo.
echo ==============================================================================
echo   🎉 SUCCESS: Recording sequence safely terminated.
echo   📦 Video Output Saved As: %OUTPUT_FILE%
echo   *** Safe and sound! ***
echo ==============================================================================
pause
