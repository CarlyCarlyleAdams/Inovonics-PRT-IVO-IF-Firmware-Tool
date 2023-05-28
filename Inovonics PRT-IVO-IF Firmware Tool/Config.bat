@echo off
setlocal
set PORT=49152-65535
set RULE_NAME="***Open UDP on Port %PORT% for PRT-IVO-IF***"
pushd "%~dp0"
title Updating Inovonics receiver!
echo.
echo Firmware Update Tool for PRT-IVO-IF
echo.
echo ******************************************************************************
echo If you need to update this tool for a different Inovonics firmware version.
echo Then make a copy of the firmware file and rename it to the following... 
echo from e.g. 
echo PRT_IVO_IF_App_hw_208_5150_000_ver_1_00_bd_026_r_J057.bin
echo to
echo PRT_IVO_IF.bin
echo This PRT_IVO_IF.bin file must be in the same folder as the RUN THIS.bat file.
echo ******************************************************************************
echo.
echo NOW TO START UPDATING THE FIRMWARE!
echo.
echo Plug directly into the Inovonics modules ethernet port and Web browse to it.
echo The default settings 
echo IP Address - 192.168.1.3
echo Username - admin
echo Password - admin
echo.
echo First, note the Firmware/App Version 
echo  so you can see if it got updated at the end when logging back in.
echo If the update worked but the version did not change
echo  then the unit may already be on the same version as this tool.
echo.
echo Then, put it into boot mode.
echo This is done from the device tab at the at the bottom (Click "here" to enter boot mode)
echo Do that now!
pause
echo.
test&cls
echo.
echo This will make changes to the Windows firewall rules needed for the firmware update.
echo.
echo Those changes will be removed at the end of this script.
echo If you close this due to and error or before it ends, 
echo you will need to remove the firewall rule yourself!!!
echo.
echo Yes to agree to the above and continue or [No] to Exit.
echo.
:PROMPT
SET /P AREYOUSURE=Are you sure (Y/[N])?
IF /I "%AREYOUSURE%" NEQ "Y" GOTO FEND
echo.

netsh advfirewall firewall show rule name=%RULE_NAME% >nul
if not ERRORLEVEL 1 (
    echo Rule %RULE_NAME% already exists.
	netsh advfirewall firewall set rule name=%RULE_NAME% new enable=yes
    echo Changes to Windows Firewall!!!
	echo Hey, you already got an Inbound Rule named %RULE_NAME%, it is enabeld!
	pause
) else (
    echo Rule %RULE_NAME% does not exist. Creating...
    netsh advfirewall firewall add rule name=%RULE_NAME% dir=in action=allow protocol=UDP localport=%PORT%
	echo Changes to your Windows Firewall!!!
	echo A new Inbound Rule named %RULE_NAME%, has been created and it is enabled!
	pause
)
test&cls

goto :next1

:next1
echo.
set /p input="Enter IP address of the Inovonics Module:
echo.
echo You entered [%input%]
echo.
pause

goto script2

:script2
echo.
echo If all is correct it will be very fast about 5 seconds after the count down.
echo.
echo If it is not working you will see the below as it retries over and over.
echo.
echo Packet will be sent. len=102, opcode=2
echo Packet will be sent. len=102, opcode=2
echo Packet will be sent. len=102, opcode=2
echo.
echo above will continue every 15 seconds......
echo Wait for it to finish.
echo.
echo This means it is not connecting and may not be in boot mode.
echo Try rebooting the module or check your cable and connection network adapters.
echo To terminate and try again press [control + c]
echo.

pause
cd .\
:UpdateFirmware2
echo.
Timeout 10

tftp -v -i %input% PUT PRT_IVO_IF.bin
echo ********************************************************************
echo.
echo OK!!! Read the below now.
echo.
echo Read both result options below before checking above.
echo.
echo Result 1. If you see this in the last few lines above the ***** Line.
echo. 
echo "Error occurred during the file transfer (Error code = 0):"
echo Server Timeout
echo.
echo Try running it again! by pressing N with the next question.
echo.
echo Or...
echo.
echo Result 2. If you see this in the last few lines above the ***** Line.
echo.
echo "File PRT_IVO_IF.bin was transferred successfully" (above).
echo.
echo Try accessing the webpage now!
echo.
echo If you are still having problems continue anyway to close correctly.
echo If so you may need to contact support.
echo.
echo Yes to continue AND also close correctly or [No] to it try again.
:PROMPT
echo.
SET /P AREYOUSURE=Can you access the webpage(Y/[N])?
IF /I "%AREYOUSURE%" NEQ "Y" GOTO UpdateFirmware2
echo.
test&cls
echo.
echo If eventhig look good then great stuff all done now. 
echo.
echo CONFIGURATION COMPLETED !!!!
echo.
goto end

:END
echo.
netsh advfirewall firewall show rule name=%RULE_NAME% >nul
if not ERRORLEVEL 1 (
    echo Rule %RULE_NAME% found.
	netsh advfirewall firewall delete rule name=%RULE_NAME%
    echo Windows firewall rule %RULE_NAME% has now been removed.
) else (
    echo Windows firewall rule %RULE_NAME% was not found so can not be removed.
)

:FEND
echo.
echo Exiting Now...
pause
endlocal