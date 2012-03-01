@echo off

set I_VER=1.0.0
set I_DATE=01.03.2012

set F18_VER="%1"
set URL="http://knowhow-erp-f18.googlecode.com/files"

set VER=%1
set TYPE=%2

set F_CUR_DIR=%CD%
set CUR_DIR=%F_CUR_DIR:~2%
set CUR_DRIVE=%F_CUR_DIR:~0,1%

set TAR_CMD="%F_CUR_DIR%\tar" -x -v -f


echo "F18 windows update  ver %I_VER%, %I_DATE%"

rem env vars
set PATH=%PATH%;C:\knowhowERP\bin;C:\knowhowERP\lib;C:\knowhowERP\util

if not exist c:\knowhowERP  goto :ERR

mkdir tmp
cd tmp

rem ima li interneta
PING -n 1 www.google.com|find "Reply from " >NUL
IF NOT ERRORLEVEL 1 goto :ONLINE
IF     ERRORLEVEL 1 goto :OFFLINE

:ONLINE

rem t, T, template, templates osvjezi template
if %TYPE%=t goto :TEMPLATES
if %TYPE%=T goto :TEMPLATES
if %TYPE%=template goto :TEMLPATES
if %TYPE%=templates goto :TEMLPATES

del /Q F18_Windows_%VER%.gz*
del /Q F18.exe

wget %URL%/F18_Windows_%VER%.gz

if not exist F18_Windows_%VER%.gz  goto :ERR2

goto :KILL

:OFFLINE 

echo Internet konekcija nije dostupna nastavljam sa offline instalacijom 
echo kreiran je tmp podfolder ubacite potrebne pakete u isti

pause 


echo zatvaram aktivne F18 procese 
:KILL

bash -c "export F18_PID=`ps -e -W  | grep F18 | gawk '{print $1}'` ; kill.exe -f $F18_PID"

goto :EXTR

:EXTR

gzip -fdN F18_Windows_%VER%.gz
xcopy /Y /i F18.exe c:\knowhowERP\bin

cd ..

echo ""
echo ""
echo F18 3d_party set uspjesno instaliran
echo ""
echo "" 

pause
exit

:TEMPLATES


mkdir c:\knowhowERP\template

echo.
echo ----------------------------------------
echo c:/knowhowERP/template
set TAR_F_NAME=F18_template_%VER%.tar
set BZ2_F_NAME=%TAR_F_NAME%.bz2

cd "%CURDIR%"

wget -N  %URL%/%BZ2_F_NAME%
echo bunzip2 %BZ2_F_NAME%
bunzip2 %BZ2_F_NAME%
echo untar %TAR_F_NAME%

cd c:\knowhowERP\template
%TAR_CMD% "%CUR_DIR%\%TAR_F_NAME%"


cd "%CURDIR%"
echo rm tar %TAR_F_NAME%
del %TAR_F_NAME%

:ERR

echo F18 updater trazi c:\knowhowERP direktorij

exit

:ERR2

echo F18 updater nije nasao %URL%/F18_Windows_%VER%.gz  
pause
exit
