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

:: -------------------------------------------@echo off
:: ==============================================================================
:: 🐧 grabbey - Desktopz Subsystem
:: Author: pedro andrade - https://github.com
:: Updated on: 07.2026
:: Description: High-performance hardware-accelerated desktop & audio capture.
:: Guidance: Press [q] inside this console terminal to halt recording safely.
:: ==============================================================================
color 0B
cls
echo ==============================================================================
echo   🎥 GRABBEY : AUTOMATED HARDWARE-ACCELERATED DESKTOP RECORDER
echo ==============================================================================
echo.

:: 🔍 Discover Display Dimensions Automatically
for /f "skip=1 tokens=1,2" %%A in ('wmic path win32_videocontroller get currenthorizontalresolution^,currentverticalresolution') do (
    if not "%%B"=="" (
        set "SCREEN_WIDTH=%%A"
        set "SCREEN_HEIGHT=%%B"
        goto :ResolutionFound
    )
)
:ResolutionFound
:: Strip trailing space characters safely
set "SCREEN_WIDTH=%SCREEN_WIDTH: =%"
set "SCREEN_HEIGHT=%SCREEN_HEIGHT: =%"
if "%SCREEN_WIDTH%"=="" (set "SCREEN_WIDTH=1920" & set "SCREEN_HEIGHT=1080")

echo [INFO] 🖥️ Monitor Resolution Detected: %SCREEN_WIDTH%x%SCREEN_HEIGHT%

:: 🔍 Scanning system hardware profile for hardware graphics acceleration...
set "VCODEC=libx264"
set "PRESET=fast"
for /f "skip=1 delims=" %%i in ('wmic path win32_videocontroller get name') do (
    echo %%i | findstr /i "NVIDIA" >nul && (set "VCODEC=h264_nvenc" & set "PRESET=p2" & goto :GpuFound)
    echo %%i | findstr /i "AMD" >nul && (set "VCODEC=h264_amf" & set "PRESET=speed" & goto :GpuFound)
    echo %%i | findstr /i "Intel" >nul && (set "VCODEC=h264_qsv" & set "PRESET=veryfast" & goto :GpuFound)
)
:GpuFound
if "%VCODEC%"=="libx264" (echo [WARN] 💻 No dedicated GPU acceleration detected. Standardizing on CPU.) else (echo [SUCCESS] 🚀 GPU Detected: Using %VCODEC%!)
echo.
set AUDIO_DEVICE=Default Audio Device
set FRAMERATE=30
set VIDEO_BITRATE=4M
set AUDIO_BITRATE=256k
set SAMPLERATE=44100
set OUTPUT_FILE=desktop_capture.mp4
echo 🔴 [RECORDING STARTED] - Press [q] to stop.
ffmpeg -y -rtbufsize 1900M -thread_queue_size 1024 -f gdigrab -framerate %FRAMERATE% -video_size %SCREEN_WIDTH%x%SCREEN_HEIGHT% -i desktop -f dshow -thread_queue_size 1024 -i audio="%AUDIO_DEVICE%" -c:v %VCODEC% -preset %PRESET% -pix_fmt yuv420p -b:v %VIDEO_BITRATE% -c:a aac -b:a %AUDIO_BITRATE% -ar %SAMPLERATE% -async 1 -threads 4 "%OUTPUT_FILE%"
echo *** Safe and sound! ***
pause
