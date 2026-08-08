@echo off
title DocuToolsHub - Portable App Launcher
echo ========================================================
echo        DocuToolsHub - Portable Application
echo ========================================================
echo.
echo Launching local server...
echo.

:: Check if Node.js is installed
where node >nul 2>nul
if %errorlevel% equ 0 (
    echo Starting local web server using Node.js...
    start "" http://localhost:3000/
    npx -y preview --port 3000
    goto :EOF
)

:: Fallback to Python HTTP server if installed
where python >nul 2>nul
if %errorlevel% equ 0 (
    echo Starting local web server using Python...
    start "" http://localhost:3000/
    cd dist
    python -m http.server 3000
    goto :EOF
)

:: Fallback using PowerShell built-in HTTP listener
echo Starting lightweight web server using PowerShell...
start "" http://localhost:3000/
powershell -Command "$listener = New-Object System.Net.HttpListener; $listener.Prefixes.Add('http://localhost:3000/'); $listener.Start(); Write-Host 'DocuToolsHub running at http://localhost:3000/'; while ($listener.IsListening) { $context = $listener.GetContext(); $req = $context.Request; $res = $context.Response; $path = Join-Path (Get-Location) 'dist' ($req.Url.LocalPath -replace '^/',''); if (Test-Path -PathType Container $path) { $path = Join-Path $path 'index.html' }; if (-not (Test-Path $path)) { $path = Join-Path (Get-Location) 'dist/index.html' }; $content = [System.IO.File]::ReadAllBytes($path); $res.ContentLength64 = $content.Length; $res.OutputStream.Write($content, 0, $content.Length); $res.Close() }"

pause
