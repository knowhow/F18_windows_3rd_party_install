set KNOWHOW_PATH=c:\knowhowERP\util

set FN=%1

if "%2"==""  goto :full
set FN=%FN% %2

if "%3"==""  goto :full
set FN=%FN% %3


if "%4"==""  goto :full
set FN=%FN% %4

if "%5"==""  goto :full
set FN=%FN% %5

if "%6"==""  goto :full
set FN=%FN% %6

:full


del /Q  %FN%.conv.txt
type "%FN%" | %KNOWHOW_PATH%\sed -e ""s/#\S\+#//g"" | %KNOWHOW_PATH%\iconv -c -f IBM852 -t UTF-8 > "%FN%.conv.txt"

rem -c "nmap <C-P> :exe '!ptxt ' . substitute(@%%, '.conv.txt', '', 'y') . ' /p'<CR>" -c ":set wrap!" -c ":set guioptions+=b" -c ":set gfn=Lucida_Console:h9:w7:cDEFAULT"
 


start gvim  -c ":set encoding=utf-8" -c ":set nowrap" -c ":set noswapfile" -c ":set nobackup" -c "nmap <C-P> :exe '!start cmd /c ptxt.cmd \"' . substitute(@%%, '.conv.txt', '', 'y') . '\" /p'<CR>" "%FN%.conv.txt" 


