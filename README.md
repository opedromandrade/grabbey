# 🐧 grabbey

Simple, high-performance batch scripts for screen recording on Windows using `ffmpeg` alone.

## 💡 The Idea

The original goal was to create a simple framework that records the desktop along with a picture-in-picture webcam overlay on a Microsoft Windows machine. It has evolved into a suite of optimized scripts tailored for different use cases, making it a perfect open-source alternative for content creators and educators making tutorials. 

Instead of heavy software layer solutions, **grabbey** calls your native system hardware resources via FFmpeg to process and bind real-time capture streams.

> 📺 *Part of the WebCamz script architecture was inspired by [this video guide](https://youtu.be/O4VqX_Fszx0)*

## 🎬 Windows Modes & Tools

* **`WebCamz.bat`**: Video capture of your full Desktop with a modular Picture-In-Picture WebCam stream overlay in the bottom right corner, synced to your default Windows audio.
* **`Desktopz.bat`**: Video capture of your full Desktop workspace paired cleanly with your default Windows system or microphone audio feed.
* **`Desktopaz.bat`**: Video capture of your full Desktop workspace with audio capture layers completely disabled.

## 🚀 Advanced Engine Enhancements

The scripts feature built-in smart automations to handle tedious configurations out of the box:
* **🤖 Automated GPU Core Handshakes**: The scripts scan your Windows hardware profile on launch (`wmic`). It detects if you have an **NVIDIA**, **AMD**, or **Intel** graphics card and automatically enables native GPU encoding features (`h264_nvenc`, `h264_amf`, or `h264_qsv`) to eliminate CPU performance lag.
* **🎵 Language-Agnostic Audio Routing**: Bypasses traditional hardcoded Windows language naming errors (e.g., `Microphone` vs `Microfone`) by safely calling the Windows default audio interface dynamically.
* **🛡️ Drift & Desync Defenses**: Implements advanced stream thread queues (`-thread_queue_size 1024`) and desync alignment handlers (`-async 1`) to guarantee audio and video stay perfectly synchronized during long recordings.
* **📐 Real-time Resolution Scaling**: Queries your hardware display monitor on initialization to automatically target and capture your exact screen resolution natively.

---

## 🛠️ Prerequisites & One-Time Setup

1. **Download FFmpeg**: Fetch the official, static Windows distribution binaries from [ffmpeg.org](https://ffmpeg.org).
2. **Environment Variable Configuration (Recommended)**: Extract the downloaded archive and add your FFmpeg `bin` system folder path (e.g., `C:\ffmpeg\bin`) to your Windows User/System PATH Environment variables.
   * *Alternative (Quick Setup)*: If you do not want to change system parameters, simply move your `grabbey` `.bat` scripts straight into the **exact folder** holding your `ffmpeg.exe` binary executable.

---

## 📖 How To Use

### 1. Configure your WebCam Name (For `WebCamz.bat` Only)
* Open a command prompt (`cmd`) and type: `ffmpeg -list_devices true -f dshow -i dummy`
* Look under the video devices section for your webcam's exact name string (e.g., `"USB 2.0 Camera"`).
* Right-click `WebCamz.bat`, select **Edit**, change `set WEBCAM_NAME=USB 2.0 Camera` to match your device, then save.

### 2. Start and Stop Recording
* Set your preferred input microphone as the **Default Device** inside your Windows Sound Settings.
* **Double-click** your chosen `.bat` script file to start recording immediately.
* To stop recording safely without breaking the video container stream, focus on the open terminal window and press the **`q`** key on your keyboard. Your output file will save next to the script!
