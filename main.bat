@echo off
title PC Locker
rem -- header for variables and all --
if exist "%APPDATA%\pando\data\lock" (
    goto rights_check
) else (
    md %APPDATA%\pando\
    md %APPDATA%\pando\data\
    md %APPDATA%\pando\data\lock
    cls
    :change-pwd
    echo Enter a secure password (case sensitive)
    set /p pwd="Input : "
    echo %pwd% > %APPDATA%/pando/data/lock/pwd.txt
    goto rights_check
)

:rights_check
net session >nul 2>&1
    if %errorLevel% == 0 (
        cls
        echo Success: Administrative permissions confirmed.
        goto main_menu
    ) else (
        cls
        echo Please restart this program as an admin !
        pause
        exit
    )

exit

rem main menu
:main_menu
cls
echo Welcome to PC Locker 
echo [1] to lock the computer
echo [2] to change the password
echo [3] to exit
choice /c 123 /n
if %errorlevel% equ 1 goto lock
if %errorlevel% equ 2 goto change-pwd
if %errorlevel% equ 3 exit


exit

:lock
taskkill /f /im explorer.exe
cls
:unlock-pwd
echo.
set "pwd_url=%APPDATA%/pando/data/lock/pwd.txt"
set /p password_check=<%pwd_url%
echo Enter the password (case sensitive), type [options] for additionnal options
set /p pwd-input="Password : "
if "%pwd-input%"=="options" goto options
if "%pwd-input%"=="%password_check%" (
    goto unlock
) else (
    echo Incorect password
    timeout /nobreak 2 > %temp%/null
    goto unlock-pwd
)

exit

:options
cls
echo [1] to go back
echo [2] to hibernate the computer 
echo [3] to shut down
echo [4] to restart
echo [5] to restart in UEFI Firmware mode
choice /c 1234 /n
if %errorlevel% equ 1 goto unlock-pwd
if %errorlevel% equ 2 shutdown /h
if %errorlevel% equ 3 shutdown /s /t 0
if %errorlevel% equ 4 shutdown /r /t 0
if %errorlevel% equ 5 shutdown /r /fw /t 0

exit

:unlock
explorer.exe
exit
