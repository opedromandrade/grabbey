@echo off
:: ==============================================================================
:: 🐧 grabbey - Desktopz Subsystem
:: Author: pedro andrade - https://github.com
:: Updated on: 07.2026
:: Description: High-performance hardware-accelerated desktop & audio capture.
:: Guidance: Press [q] inside this console terminal to halt recording safely.
:: ==============================================================================

:: Configure Terminal Interface Colors (Cyan Text on Black Background)
color 0B
cls

echo ==============================================================================
echo   🎥 GRABBEY : AUTOMATED HARDWARE-ACCELERATED DESKTOP RECORDER
echo ==============================================================================
echo.

:: ------------------------------------------------------------------------------
:: AUTOMATED GPU DETECTOR ENGINE
:: ------------------------------------------------------------------------------
echo [INFO] 🔍 Scanning system hardware profile for hardware graphics acceleration...
set "VCODEC=libx264"
set "PRESET=slow"

:: Query Windows Management Instrumentation for GPU Name
for /f "skip=1 delims=" %%i in ('wmic path win32_videocontroller get name') do (
    echo %%i | findstr /i "NVIDIA" >nul && (
        set "VCODEC=h264_nvenc"
        set "PRESET=p4"
        goto :GpuFound
    )
    echo %%i | findstr /i "AMD" >nul && (
        set "VCODEC=h264_amf"
        set "PRESET=speed"
        goto :GpuFound
    )
    echo %%i | findstr /i "Intel" >nul && (
        set "VCODEC=h264_qsv"
        set "PRESET=veryfast"
        goto :GpuFound
    )
)

:GpuFound
if "%VCODEC%"=="libx264" (
    echo [WARN] 💻 No dedicated GPU acceleration detected. Standardizing on CPU (libx264).
) else (
    echo [SUCCESS] 🚀 Hardware Graphics Acceleration Detected: Using %VCODEC% codec engine!
)
echo.

:: ------------------------------------------------------------------------------
:: CONFIGURABLE ENVIRONMENT VARIABLES
:: ------------------------------------------------------------------------------
set AUDIO_DEVICE=Default Audio Device
set FRAMERATE=30
set VIDEO_BITRATE=4M
set AUDIO_BITRATE=256k
set SAMPLERATE=44100
set OUTPUT_FILE=desktop_capture.mp4

echo [INFO] ⚙️ Checking target recording parameters...
echo        - Framerate   : %FRAMERATE% FPS
echo        - Codec Engine: %VCODEC% (Preset: %PRESET%)
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
-c:v %VCODEC% -preset %PRESET% -pix_fmt yuv420p -b:v %VIDEO_BITRATE% ^
-c:a aac -b:a %AUDIO_BITRATE% -ar %SAMPLERATE% -async 1 ^
-threads 4 "%OUTPUT_FILE%"

echo.
echo ==============================================================================
echo   🎉 SUCCESS: Recording sequence safely terminated.
echo   📦 Video Output Saved As: %OUTPUT_FILE%
echo   *** Safe and sound! ***
echo ==============================================================================
pause
