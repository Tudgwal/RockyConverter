@echo off
title Installing Chocolatey...

echo This script will install Chocolatey on your Windows system.

REM Check if running as administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Please run this script as Administrator!
    pause
    exit /b 1
)

REM Download and execute Chocolatey installation script
powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" > nul 2>&1

REM Check if Chocolatey was installed successfully
if exist "%ALLUSERSPROFILE%\chocolatey\bin\choco.exe" (
    echo Chocolatey has been installed successfully!
) else (
    echo Failed to install Chocolatey. Please try again.
    pause
    exit /b 1
)

REM Check if ImageMagick is already installed
for /d %%i in ("C:\Program Files\ImageMagick-*") do (
    if exist "%%i" (
        echo ImageMagick has been installed successfully!
    ) else (
        REM Install ImageMagick using Chocolatey
        echo Installing ImageMagick using Chocolatey...
        choco install ImageMagick -y --force
        REM Check if ImageMagick was installed successfully
        if exist "C:\Program Files\ImageMagick-7.1.0-Q16" (
            echo ImageMagick has been installed successfully!
        ) else (
            echo Failed to install ImageMagick. Please try again.
            pause
            exit /b 1
        )
    )
)

echo Installation completed successfully!
pause
