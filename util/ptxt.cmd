@echo off

set FN=%1
if "%2"==""  goto :full

set FN=%FN% %2
if "%3"==""  goto :full
set FN=%FN% %3

if "%4"==""  goto :full
set FN=%FN% %4

:full

set FEXE=c:\knowhowERP\util\ptxt_exe.exe

c:\knowhowERP\util\start.exe %FEXE% %FN%


