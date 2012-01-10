@echo off

set I_VER="0.6.0"
set I_DATE="10.01.2012"

set F18_VER="%1"
set URL="http://knowhow-erp-f18.googlecode.com/files"

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



del /Q F18_Windows_%1.gz*
del /Q F18.exe

wget %URL%/F18_Windows_%1.gz

if not exist F18_Windows_%1.gz  goto :ERR2

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

gzip -fdN F18_Windows_%1.gz
xcopy /Y /i F18.exe c:\knowhowERP\bin

cd ..

echo ""
echo ""
echo F18 3d_party set uspjesno instaliran
echo ""
echo "" 

pause
exit

:ERR

echo F18 updater trazi c:\knowhowERP direktorij

exit

:ERR2

echo F18 updater nije nasao %URL%/F18_Windows_%1.gz  
pause
exit
