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

set ROOT_GCODE_URL=http://knowhow-erp-f18.googlecode.com/files


echo Pritisni Ctrl+C za prekid ili bilo koju tipku za nastavak...
pause > nul

set I_VER="0.7.5"
set I_DATE="29.02.2012"


set DELRB_VER="1.0"
set PTXT_VER="1.55"
set F18_VER="0.9.59"

echo "F18 windows third party install ver %I_VER%, %I_DATE%"

rem env vars
set PATH=%PATH%;C:\knowhowERP\bin;C:\knowhowERP\lib;C:\knowhowERP\util

rem provjeri i kreiraj install dir 
if not exist c:\knowhowERP  md c:\knowhowERP

rem install


xcopy  /Y /i /E lib c:\knowhowERP\lib
xcopy  /Y /i /E util c:\knowhowERP\util

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

wget -N %ROOT_GCODE_URL%/delphirb_%DELRB_VER%.gz
wget -N %ROOT_GCODE_URL%/ptxt_%PTXT_VER%.gz
wget -N %ROOT_GCODE_URL%/F18_Windows_%F18_VER%.gz

goto :EXTRACT

:OFFLINE 

echo Internet konekcija nije dostupna nastavljam sa offline instalacijom 
echo kreiran je tmp podfolder ubacite potrebne pakete u isti


:EXTRACT

gzip -dNf ptxt_%PTXT_VER%.gz
gzip -dNf delphirb_%DELRB_VER%.gz
gzip -dNf F18_Windows_%F18_VER%.gz

xcopy  /Y /i ptxt.exe c:\knowhowERP\util\ptxt_exe.exe
xcopy  /Y /i delphirb.exe c:\knowhowERP\util
mkdir  c:\knowhowERP\bin
xcopy  /Y /i F18.exe c:\knowhowERP\bin
xcopy /Y /i  c:\knowhowERP\util\F18.lnk "%USERPROFILE%\Desktop"
xcopy /Y /i  c:\knowhowERP\util\_vimrc  "%USERPROFILE%"

cd ..


:TEMPLATES

echo.
echo ----------------------------------------
echo c:/knowhowERP/template
set TAR_F_NAME=F18_knowhowERP_template.tar
set BZ2_F_NAME=%TAR_F_NAME%.bz2

wget -N  %ROOT_GCODE_URL%/%BZ2_F_NAME%
echo bunzip2 %BZ2_F_NAME%
bunzip2 %BZ2_F_NAME%
echo untar %TAR_F_NAME%
tar xfv %TAR_F_NAME%
echo rm tar %TAR_F_NAME%
del %TAR_F_NAME%

xcopy  /Y /i template c:\knowhowERP\template


echo F18 3d_party set uspjesno instaliran
pause
exit
