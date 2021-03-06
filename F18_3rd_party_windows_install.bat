@echo off
echo ===========================================================================
echo   Ovaj batch file instalira F18 na lokaciju c:\knowhowERP
echo   Potrebna je internet konekcija i administratorske privilegije
echo.
echo. 
echo   Nakon instalacije je potrebno restartovati racunar zbog PTXT fontova  
echo.     
echo.      
echo. 

set I_VER=1.3.0
set I_DATE=07.03.2012


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

set WGET_CMD_1="%F_CUR_DIR%\wget" -nc
set TAR_CMD="%F_CUR_DIR%\tar" -x -v -f
set BUNZIP2_CMD="%F_CUR_DIR%\bunzip2"

set SEVENZ_CMD="%F_CUR_DIR%\7z" x

set MY_DOC_DIR=%USERPROFILE%\My Documents
set DOWNLOAD_DIR=%USERPROFILE%\My Documents\Downloads

rem ~~~~~~~~~~~~~~~~~ common ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


echo F18 windows third party install ver %I_VER%, %I_DATE%
echo.
echo.
echo Pritisni Ctrl+C za prekid ili bilo koju tipku za nastavak...
pause > nul

mkdir c:\knowhowERP
mkdir c:\knowhowERP\lib
mkdir c:\knowhowERP\util
mkdir c:\knowhowERP\bin
mkdir "%MY_DOC_DIR%"
mkdir "%DOWNLOAD_DIR%"

rem env vars
set PATH=%PATH%;C:\knowhowERP\bin;C:\knowhowERP\lib;C:\knowhowERP\util

rem provjeri i kreiraj install dir 
if not exist c:\knowhowERP  md c:\knowhowERP

rem install

xcopy  /Y /i /E lib c:\knowhowERP\lib
xcopy  /Y /i /E util c:\knowhowERP\util

echo F18.exe dependencies
copy /Y lib\libpq.dll c:\knowhowERP\bin\
copy /Y lib\ssleay32.dll c:\knowhowERP\bin\
copy /Y lib\libeay32.dll c:\knowhowERP\bin\
copy /Y lib\libintl-8.dll c:\knowhowERP\bin\
copy /Y lib\libiconv-2.dll c:\knowhowERP\bin\


echo kopiram fontove
cd  fonts\ptxt_fonts\

if exist "%WINDIR%\Fonts\sctah.ttf" echo "sctahoma postoji" 
if not exist "%WINDIR%\Fonts\sctah.ttf"  xcopy  sctah.ttf "%WINDIR%\Fonts"    
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "sctah (TrueType)" /t REG_SZ /d "sctah.ttf" /f

if exist "%WINDIR%\Fonts\sctahm.ttf" echo "sctahoma-m postoji" 
if not exist "%WINDIR%\Fonts\sctahm.ttf" xcopy  sctahm.ttf "%WINDIR%\Fonts"    
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "sctahm (TrueType)" /t REG_SZ /d "sctahm.ttf" /f

if exist "%WINDIR%\Fonts\sctahm2.ttf" echo "sctahoma-m2 postoji" 
if not exist "%WINDIR%\Fonts\sctahm2.ttf"   xcopy  sctahm2.ttf "%WINDIR%\Fonts"    
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "sctahm2 (TrueType)" /t REG_SZ /d "sctahm2.ttf" /f

cd ..\.. 


mkdir tmp
cd tmp

rem ima li interneta
PING -n 1 www.google.com|find "Reply from " >NUL
IF NOT ERRORLEVEL 1 goto :ONLINE
IF     ERRORLEVEL 1 goto :OFFLINE

:ONLINE


cd "%DOWNLOAD_DIR%"
set WGET_FILE=delphirb_%DELRB_VER%.gz
set WGET_URL=%ROOT_GCODE_URL_F18%/%WGET_FILE%
%WGET_CMD_1% %WGET_URL% 
if NOT %ERRORLEVEL% == 0 goto :err_wget_url
cd "%CUR_DIR%"
copy /y "%DOWNLOAD_DIR%\%WGET_FILE%" .

cd "%DOWNLOAD_DIR%"
set WGET_FILE=ptxt_%PTXT_VER%.gz
set WGET_URL=%ROOT_GCODE_URL_F18%/%WGET_FILE%
%WGET_CMD_1% %WGET_URL% 
if NOT %ERRORLEVEL% == 0 goto :err_wget_url
cd "%CUR_DIR%"
copy /y "%DOWNLOAD_DIR%\%WGET_FILE%" .

cd "%DOWNLOAD_DIR%"
set WGET_FILE=F18_Windows_%F18_VER%.gz
set WGET_URL=%ROOT_GCODE_URL_F18%/%WGET_FILE%
%WGET_CMD_1% %WGET_URL% 
if NOT %ERRORLEVEL% == 0 goto :err_wget_url
cd "%CUR_DIR%"
copy /y "%DOWNLOAD_DIR%\%WGET_FILE%" .

goto :EXTRACT

:OFFLINE 

echo Internet konekcija nije dostupna nastavljam sa offline instalacijom 
echo kreiran je tmp podfolder ubacite potrebne pakete u isti


:EXTRACT

gzip -dNf ptxt_%PTXT_VER%.gz
gzip -dNf delphirb_%DELRB_VER%.gz
gzip -dNf F18_Windows_%F18_VER%.gz

copy  /Y  ptxt.exe c:\knowhowERP\util\ptxt_exe.exe
copy  /Y delphirb.exe c:\knowhowERP\util
mkdir  c:\knowhowERP\bin
copy  /Y  F18.exe c:\knowhowERP\bin
copy /Y  c:\knowhowERP\util\F18.lnk "%USERPROFILE%\Desktop"
copy /Y  c:\knowhowERP\util\_vimrc  "%USERPROFILE%"

cd ..


:qt_dlls

echo 3.b) Qt libs %QT_VER% = c:/knowhowERP/lib


cd "%CUR_DIR%"

set SEVENZ_F_NAME=Qt_windows_dlls_%QT_VER%.7z

cd "%DOWNLOAD_DIR%"
set WGET_FILE=%SEVENZ_F_NAME%
set WGET_URL=%ROOT_GCODE_URL%/%WGET_FILE%
%WGET_CMD_1% %WGET_URL% 
if NOT %ERRORLEVEL% == 0 goto :err_wget_url
cd "%CUR_DIR%"
copy /y "%DOWNLOAD_DIR%\%WGET_FILE%" .

echo 7zip extract %SEVENZ_F_NAME%

cd c:\knowhowERP
echo %SEVENZ_CMD% "%F_CUR_DIR%\%SEVENZ_F_NAME%"
%SEVENZ_CMD% "%F_CUR_DIR%\%SEVENZ_F_NAME%"

cd "%CUR_DIR%"
echo rm 7z %SEVENZ_F_NAME%
del %SEVENZ_F_NAME%


:TEMPLATES

mkdir c:\knowhowERP\template

echo.
echo ----------------------------------------
echo c:/knowhowERP/template
set TAR_F_NAME=F18_template_%F18_TEMPLATE_VER%.tar
set BZ2_F_NAME=%TAR_F_NAME%.bz2

del /Q %TAR_F_NAME%
del /Q %BZ2_F_NAME%


cd "%DOWNLOAD_DIR%"
set WGET_FILE=%BZ2_F_NAME%
set WGET_URL=%ROOT_GCODE_URL_F18%/%WGET_FILE%
%WGET_CMD_1% %WGET_URL% 
if NOT %ERRORLEVEL% == 0 goto :err_wget_url
cd "%CUR_DIR%"
copy /y "%DOWNLOAD_DIR%\%WGET_FILE%" .

echo bunzip2 %BZ2_F_NAME%
%BUNZIP2_CMD% %BZ2_F_NAME%


cd c:\knowhowERP

echo untar %TAR_F_NAME%
%TAR_CMD% "%CUR_DIR%\%TAR_F_NAME%"

cd "%CUR_DIR%"

echo rm tar %TAR_F_NAME%
del %TAR_F_NAME%

rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:kraj
echo F18 3d_party set uspjesno instaliran
pause
exit

rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:err_wget_url

echo error %ERRORLEVEL% wget %WGET_URL% !
echo .
pause
goto :belaj


rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:err_wget

echo error wget %ROOT_GCODE_URL%/%SEVENZ_F_NAME% !
echo .
pause
goto :belaj

rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:err_wget_f18

echo error wget %ROOT_GCODE_URL_F18%/%SEVENZ_F_NAME% !
echo .
pause
goto :belaj


rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:err_wget_f18_bz2

echo error wget %ROOT_GCODE_URL_F18%/%Bz2_F_NAME% !
echo .
pause
goto :belaj


rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:belaj

echo instalacija nije izvrsena. bye bye ...
pause


