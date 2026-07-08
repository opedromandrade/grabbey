@echo off
:: ==============================================================================
:: 🐧 grabbey - WebCamz Subsystem
:: Author: pedro andrade - https://github.com
:: Updated on: 07.2026
:: Description: Hardware-accelerated Desktop with WebCam Picture-In-Picture.
:: Guidance: Press [q] inside this console terminal to halt recording safely.
:: ==============================================================================

:: Configure Terminal Interface Colors (Green Text on Black Background)
color 0A
cls

echo ==============================================================================
echo   📸 GRABBEY : AUTOMATED HARDWARE-ACCELERATED PIP WEBCAM RECORDER
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
        goto :GpuFoundWeb
    )
    echo %%i | findstr /i "AMD" >nul && (
        set "VCODEC=h264_amf"
        set "PRESET=speed"
        goto :GpuFoundWeb
    )
    echo %%i | findstr /i "Intel" >nul && (
        set "VCODEC=h264_qsv"
        set "PRESET=veryfast"
        goto :GpuFoundWeb
    )
)

:GpuFoundWeb
if "%VCODEC%"=="libx264" (
    echo [WARN] 💻 No dedicated GPU acceleration detected. Standardizing on CPU (libx264).
) else (
    echo [SUCCESS] 🚀 Hardware Graphics Acceleration Detected: Using %VCODEC% codec engine!
)
echo.

:: ------------------------------------------------------------------------------
:: CONFIGURABLE ENVIRONMENT VARIABLES
:: ------------------------------------------------------------------------------
:: Change the camera name here if your hardware tracker uses a custom identifier
set WEBCAM_NAME=USB 2.0 Camera
set AUDIO_DEVICE=Default Audio Device

:: Resolution scaling arrays
set DESKTOP_RES=1920x1080
set WEBCAM_RES=384x216

:: Video metrics settings
set FRAMERATE=30
set VIDEO_BITRATE=4M
set AUDIO_BITRATE=256k
set SAMPLERATE=44100
set OUTPUT_FILE=webcam_overlay_capture.mp4

echo [INFO] ⚙️ Initializing video compositing canvas layers...
echo        - Base Desktop Resolution : %DESKTOP_RES%
echo        - Overlay WebCam Scale    : %WEBCAM_RES%
echo        - Capture Device Module   : %WEBCAM_NAME%
echo        - Audio Capture Node      : %AUDIO_DEVICE%
echo        - Destination File        : %OUTPUT_FILE%
echo.
echo 🔴 [RECORDING STARTED] 
echo ⚠️  CRITICAL: Click inside this window and press [q] to stop and save video.
echo ------------------------------------------------------------------------------
echo.

:: ------------------------------------------------------------------------------
:: RUN FFMPEG PIP COMPOSITING ENGINE
:: ------------------------------------------------------------------------------
ffmpeg -y -rtbufsize 1900M -thread_queue_size 1024 ^
-f gdigrab -framerate %FRAMERATE% -i desktop ^
-f dshow -thread_queue_size 1024 -i video="%WEBCAM_NAME%":audio="%AUDIO_DEVICE%" ^
-filter_complex "[0:v]scale=%DESKTOP_RES%[desktop]; [1:v]scale=%WEBCAM_RES%[webcam]; [desktop][webcam]overlay=x=W-w-50:y=H-h-50" ^
-c:v %VCODEC% -preset %PRESET% -pix_fmt yuv420p -b:v %VIDEO_BITRATE% ^
-c:a aac -b:a %AUDIO_BITRATE% -ar %SAMPLERATE% -async 1 ^
-threads 4 "%OUTPUT_FILE%"

echo.
echo ==============================================================================
echo   🎉 SUCCESS: Recording compositing pipeline cleanly detached.
echo   📦 Video Output Saved As: %OUTPUT_FILE%
echo   *** Safe and sound! ***
echo ==============================================================================
pause
