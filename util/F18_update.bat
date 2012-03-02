@echo off

set I_VER=1.3.5
set I_DATE=02.03.2012


set F18_VER=%1
set VER=%1
set TYPE=%2


set START_DIR=%CD%

echo pozicioniram se na temp: %TMP% direktorij
cd "%TMP%"

rem ~~~~~~~~~~~~~~~~~ common ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

set ROOT_GCODE_URL_F18=http://knowhow-erp-f18.googlecode.com/files
set ROOT_GCODE_URL=http://knowhow-erp.googlecode.com/files

set QT_VER=4.7.4
set DELRB_VER=1.0
set PTXT_VER=1.55
set F18_VER=0.9.56
set F18_TEMPLATE_VER=1.0.0


set F_CUR_DIR=%CD%
set CUR_DIR=%F_CUR_DIR:~2%
set CUR_DRIVE=%F_CUR_DIR:~0,1%

set WGET_CMD_1=wget -nc
set TAR_CMD=tar -x -v -f
set BUNZIP2_CMD=bunzip2 -f

set MY_DOC_DIR=%USERPROFILE%\My Documents
set DOWNLOAD_DIR=%USERPROFILE%\My Documents\Downloads

rem ~~~~~~~~~~~~~~~~~ common ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




echo kreiram download dir ako treba ...
mkdir "%MY_DOC_DIR%"
mkdir "%DOWNLOAD_DIR%"




echo F18 windows update ver %I_VER%, %I_DATE%
echo ---------------------------------------------------------------

rem env vars
set PATH=%PATH%;C:\knowhowERP\bin;C:\knowhowERP\lib;C:\knowhowERP\util

if not exist c:\knowhowERP  goto :ERR

mkdir tmp
cd tmp

rem ima li interneta
PING -n 1 www.google.com|find "Reply from " >NUL
IF NOT ERRORLEVEL 1 goto :ONLINE
IF     ERRORLEVEL 1 goto :OFFLINE

echo internet ok ....

:ONLINE

rem t, T, template, templates osvjezi template
if x%TYPE%==xt         goto :TEMPLATES
if x%TYPE%==xT         goto :TEMPLATES
if x%TYPE%==xtemplate  goto :TEMPLATES
if x%TYPE%==xtemplates goto :TEMPLATES

del /Q F18_Windows_%VER%.gz*
del /Q F18.exe


cd "%DOWNLOAD_DIR%"
set WGET_FILE=F18_Windows_%VER%.gz
set WGET_URL=%ROOT_GCODE_URL_F18%/%WGET_FILE%
%WGET_CMD_1% %WGET_URL% 
if NOT %ERRORLEVEL% == 0 goto :err_wget_url
cd "%CUR_DIR%"
copy /y "%DOWNLOAD_DIR%\%WGET_FILE%" .


if not exist %WGET_FILE% goto :ERR2

goto :KILL

:OFFLINE 

echo Internet konekcija nije dostupna nastavljam sa offline instalacijom 
echo kreiran je tmp podfolder ubacite potrebne instalacijske arhive u njega

pause 


echo zatvaram aktivne F18 procese 
:KILL

bash -c "export F18_PID=`ps -e -W  | grep F18 | gawk '{print $1}'` ; kill.exe -f $F18_PID"

goto :EXTR

:EXTR

gzip -fdN F18_Windows_%VER%.gz
copy /Y  F18.exe c:\knowhowERP\bin

cd ..

echo.
echo.
echo F18.exe uspjesno instaliran
echo.
echo.

pause
goto :kraj

:TEMPLATES


mkdir c:\knowhowERP\template

echo.
echo ----------------------------------------
echo c:/knowhowERP/template
set TAR_F_NAME=F18_template_%VER%.tar
set BZ2_F_NAME=%TAR_F_NAME%.bz2

cd "%DOWNLOAD_DIR%"
set WGET_FILE=%BZ2_F_NAME%
set WGET_URL=%ROOT_GCODE_URL_F18%/%WGET_FILE%
%WGET_CMD_1% %WGET_URL% 
if NOT %ERRORLEVEL% == 0 goto :err_wget_url
cd "%CUR_DIR%"
copy /y "%DOWNLOAD_DIR%\%WGET_FILE%" .


echo bunzip2 %BZ2_F_NAME%
%BUNZIP2_CMD% %BZ2_F_NAME%
if not %ERRORLEVEL% == 0 goto :belaj

echo untar %TAR_F_NAME%
cd c:\knowhowERP
%TAR_CMD% "%CUR_DIR%\%TAR_F_NAME%"
if not %ERRORLEVEL% == 0 goto :belaj


cd "%CURDIR%"
echo rm tar %TAR_F_NAME%
del  /q "%CUR_DIR%\%TAR_F_NAME%

echo F18 template %VER% uspjesno instaliran
goto :kraj

rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:ERR

echo F18 updater trazi c:\knowhowERP direktorij

goto :belaj

rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:ERR2

echo F18 updater nije nasao %ROOT_GCODE_URL_F18%/F18_Windows_%VER%.gz  
goto :belaj

rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:err_wget_url

echo error %ERRORLEVEL% wget %WGET_URL% !
echo .
pause
goto :belaj

rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:belaj
echo.
echo F18_update neuspjesan !
echo.
goto :kraj

:kraj

cd "%START_DIR%"

echo.
echo end F18_update ...

pause

