@ECHO off
cls
:start
::--------------PAS DIT AAN---------------------
set NetwerkKaart="Ethernet 5" 
::----------------------------------------------
ECHO.
ECHO ---------------------------------------------------------
ECHO Before you run the script make sure you run as admin and
ECHO Change "Ethernet 5" To the name of your network card.
ECHO ---------------------------------------------------------
ECHO 
ECHO What IP would you like set for interface %NetwerkKaart%? 
set /p ipaddr=
ECHO 1. Change ip to %ipaddr%
ECHO 2. Change to DHCP
ECHO 3. Exit


ECHO Select your option
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto static
if '%choice%'=='2' goto dhcp
if '%choice%'=='3' goto end
ECHO "%choice%" is not valid, try again
ECHO.
goto start
:static
ECHO SET IP
netsh interface ip set address %NetwerkKaart% static %ipaddr% 255.255.255.0
ECHO IP SET %ipaddr%
@pause
goto end

:dhcp
ECHO obtaining auto IP
netsh interface ip set address %NetwerkKaart% dhcp
ECHO DHCP set
@pause
goto end

:end 

