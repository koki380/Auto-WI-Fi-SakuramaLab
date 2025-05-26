@echo off
REM Create the Wi-Fi profile XML file
echo ^<?xml version="1.0"?^> > Wi-Fi-aaa.xml
echo ^<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1"^> >> Wi-Fi-aaa.xml
echo ^<name^>aaa^</name^> >> Wi-Fi-aaa.xml
echo ^<SSIDConfig^> >> Wi-Fi-aaa.xml
echo  ^<SSID^> >> Wi-Fi-aaa.xml
echo   ^<hex^>53616B7572616D612D6C6162^</hex^> >> Wi-Fi-aaa.xml
echo   ^<name^>aaa^</name^> >> Wi-Fi-aaa.xml
echo  ^</SSID^> >> Wi-Fi-aaa.xml
echo ^</SSIDConfig^> >> Wi-Fi-aaa.xml
echo ^<connectionType^>ESS^</connectionType^> >> Wi-Fi-aaa.xml
echo ^<connectionMode^>auto^</connectionMode^> >> Wi-Fi-aaa.xml
echo ^<MSM^> >> Wi-Fi-aaa.xml
echo  ^<security^> >> Wi-Fi-aaa.xml
echo   ^<authEncryption^> >> Wi-Fi-aaa.xml
echo    ^<authentication^>WPA3SAE^</authentication^> >> Wi-Fi-aaa.xml
echo    ^<encryption^>AES^</encryption^> >> Wi-Fi-aaa.xml
echo    ^<useOneX^>false^</useOneX^> >> Wi-Fi-aaa.xml
echo    ^<transitionMode xmlns="http://www.microsoft.com/networking/WLAN/profile/v4"^>true^</transitionMode^> >> Wi-Fi-aaa.xml
echo   ^</authEncryption^> >> Wi-Fi-aaa.xml
echo   ^<sharedKey^> >> Wi-Fi-aaa.xml
echo    ^<keyType^>passPhrase^</keyType^> >> Wi-Fi-aaa.xml
echo    ^<protected^>false^</protected^> >> Wi-Fi-aaa.xml
echo    ^<keyMaterial^>BBB^</keyMaterial^> >> Wi-Fi-aaa.xml
echo   ^</sharedKey^> >> Wi-Fi-aaa.xml
echo  ^</security^> >> Wi-Fi-aaa.xml
echo ^</MSM^> >> Wi-Fi-aaa.xml
echo ^<MacRandomization xmlns="http://www.microsoft.com/networking/WLAN/profile/v3"^> >> Wi-Fi-aaa.xml
echo  ^<enableRandomization^>true^</enableRandomization^> >> Wi-Fi-aaa.xml
echo  ^<randomizationSeed^>2697468204^</randomizationSeed^> >> Wi-Fi-aaa.xml
echo ^</MacRandomization^> >> Wi-Fi-aaa.xml
echo ^</WLANProfile^> >> Wi-Fi-aaa.xml

REM Add the Wi-Fi profile using the created XML file
netsh wlan add profile filename="Wi-Fi-aaa.xml"
if %errorlevel%==0 (
    echo Wi-Fi profile "aaa" added successfully.
) else (
    echo Failed to add the Wi-Fi profile.
)

REM Clean up by removing the temporary XML file
del Wi-Fi-aaa.xml

pause
