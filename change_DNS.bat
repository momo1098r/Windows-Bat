@echo off
:: ============================================================
:: Script per abilitare/disabilitare DNS pubblici
:: su scheda di rete Wi-Fi e LAN (Windows)
:: Provider: Cloudflare / Google / Quad9
:: ============================================================

setlocal

:: Controllo permessi amministratore
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo [ERRORE] Questo script richiede i privilegi di Amministratore.
    echo Fai clic destro sul file e scegli "Esegui come amministratore".
    echo.
    pause
    exit /b 1
)

:: Nomi delle interfacce (modifica qui se i tuoi nomi sono diversi)
set "IF_WIFI=Wi-Fi"
set "IF_LAN=Ethernet"

:: DNS primario/secondario per provider
set "DNS1_CLOUDFLARE=1.1.1.1"
set "DNS2_CLOUDFLARE=1.0.0.1"
set "DNS1_GOOGLE=8.8.8.8"
set "DNS2_GOOGLE=8.8.4.4"
set "DNS1_QUAD9=9.9.9.9"
set "DNS2_QUAD9=149.112.112.112"

:: Provider selezionato di default
set "PROVIDER=CLOUDFLARE"

:MENU
cls
echo ================================================
echo   Gestione DNS - Wi-Fi e LAN
echo ================================================
echo.
echo Interfacce configurate:
echo   - Wi-Fi: %IF_WIFI%
echo   - LAN  : %IF_LAN%
echo.
echo Provider DNS attuale: %PROVIDER%
echo.
echo 1) Abilita DNS su Wi-Fi
echo 2) Abilita DNS su LAN
echo 3) Abilita DNS su entrambe
echo 4) Disabilita (ripristina DNS automatico) su Wi-Fi
echo 5) Disabilita (ripristina DNS automatico) su LAN
echo 6) Disabilita (ripristina DNS automatico) su entrambe
echo 9) Cambia provider DNS (attuale: %PROVIDER%)
echo 0) Esci
echo.
set /p scelta="Seleziona un'opzione: "

if "%scelta%"=="1" goto SET_WIFI
if "%scelta%"=="2" goto SET_LAN
if "%scelta%"=="3" goto SET_BOTH
if "%scelta%"=="4" goto UNSET_WIFI
if "%scelta%"=="5" goto UNSET_LAN
if "%scelta%"=="6" goto UNSET_BOTH
if "%scelta%"=="9" goto CHOOSE_PROVIDER
if "%scelta%"=="0" exit /b 0
goto MENU

:CHOOSE_PROVIDER
cls
echo ================================================
echo   Seleziona provider DNS
echo ================================================
echo.
echo 1) Cloudflare (1.1.1.1 / 1.0.0.1)
echo 2) Google     (8.8.8.8 / 8.8.4.4)
echo 3) Quad9      (9.9.9.9 / 149.112.112.112)
echo.
set /p provscelta="Seleziona un provider: "
if "%provscelta%"=="1" set "PROVIDER=CLOUDFLARE"
if "%provscelta%"=="2" set "PROVIDER=GOOGLE"
if "%provscelta%"=="3" set "PROVIDER=QUAD9"
goto MENU

:SET_WIFI
call :SET_WIFI_SILENT
call :RESTART_IF "%IF_WIFI%"
echo.
echo DNS %PROVIDER% abilitati su "%IF_WIFI%" (scheda riavviata).
pause
goto MENU

:SET_LAN
call :SET_LAN_SILENT
call :RESTART_IF "%IF_LAN%"
echo.
echo DNS %PROVIDER% abilitati su "%IF_LAN%" (scheda riavviata).
pause
goto MENU

:SET_BOTH
call :SET_WIFI_SILENT
call :SET_LAN_SILENT
call :RESTART_IF "%IF_WIFI%"
call :RESTART_IF "%IF_LAN%"
echo.
echo DNS %PROVIDER% abilitati su Wi-Fi e LAN (schede riavviate).
pause
goto MENU

:SET_WIFI_SILENT
if "%PROVIDER%"=="CLOUDFLARE" (
    netsh interface ip set dns name="%IF_WIFI%" static %DNS1_CLOUDFLARE%
    netsh interface ip add dns name="%IF_WIFI%" %DNS2_CLOUDFLARE% index=2
)
if "%PROVIDER%"=="GOOGLE" (
    netsh interface ip set dns name="%IF_WIFI%" static %DNS1_GOOGLE%
    netsh interface ip add dns name="%IF_WIFI%" %DNS2_GOOGLE% index=2
)
if "%PROVIDER%"=="QUAD9" (
    netsh interface ip set dns name="%IF_WIFI%" static %DNS1_QUAD9%
    netsh interface ip add dns name="%IF_WIFI%" %DNS2_QUAD9% index=2
)
exit /b 0

:SET_LAN_SILENT
if "%PROVIDER%"=="CLOUDFLARE" (
    netsh interface ip set dns name="%IF_LAN%" static %DNS1_CLOUDFLARE%
    netsh interface ip add dns name="%IF_LAN%" %DNS2_CLOUDFLARE% index=2
)
if "%PROVIDER%"=="GOOGLE" (
    netsh interface ip set dns name="%IF_LAN%" static %DNS1_GOOGLE%
    netsh interface ip add dns name="%IF_LAN%" %DNS2_GOOGLE% index=2
)
if "%PROVIDER%"=="QUAD9" (
    netsh interface ip set dns name="%IF_LAN%" static %DNS1_QUAD9%
    netsh interface ip add dns name="%IF_LAN%" %DNS2_QUAD9% index=2
)
exit /b 0

:UNSET_WIFI
netsh interface ip set dns name="%IF_WIFI%" dhcp
call :RESTART_IF "%IF_WIFI%"
echo.
echo DNS automatico (DHCP) ripristinato su "%IF_WIFI%" (scheda riavviata).
pause
goto MENU

:UNSET_LAN
netsh interface ip set dns name="%IF_LAN%" dhcp
call :RESTART_IF "%IF_LAN%"
echo.
echo DNS automatico (DHCP) ripristinato su "%IF_LAN%" (scheda riavviata).
pause
goto MENU

:UNSET_BOTH
netsh interface ip set dns name="%IF_WIFI%" dhcp
netsh interface ip set dns name="%IF_LAN%" dhcp
call :RESTART_IF "%IF_WIFI%"
call :RESTART_IF "%IF_LAN%"
echo.
echo DNS automatico (DHCP) ripristinato su Wi-Fi e LAN (schede riavviate).
pause
goto MENU

:RESTART_IF
echo Riavvio interfaccia %~1 ...
netsh interface set interface name=%1 admin=disable >nul 2>&1
timeout /t 2 /nobreak >nul
netsh interface set interface name=%1 admin=enable >nul 2>&1
timeout /t 3 /nobreak >nul
exit /b 0

endlocal
