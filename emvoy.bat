<!-- : Begin Batch Script
:top
@echo off
setlocal enableextensions enabledelayedexpansion
:: -----------------------------------------------------------------------------------------------------------
:: Temp Echo on/off toggle
set _echo=off
set _subecho=
SET /P _echo="'Type 'o' for echo on> "
if %_echo% == [] do set _echo=off
echo input = %_echo%
if [%_echo%]==[o] (
	set _echo=on 
) else (
	set _echo=off)
echo echo = %_echo%
@echo %_echo%
echo ====================================================
echo.
cls

 :START_OF_FINAL


 
 
:: ===========================================================
:: SETUP VARIABLES
:: ============================================================
:: Pre-Var tests


::
:: ===========================================================
:GLOBAL_VARS
:: ============================================================
:: Paths to EMVOY files and folders:
:: ---------------------------------------------------------------------------
Echo Resetting Env Vars
Set _=""
Echo Setting Constants...
set EmvoyPath=%~dp0
set EmvoyPath=%EmvoyPath:~0,-1%
set _EmuDirPath=%EmvoyPath%\Emulators
set _GamesDirPath=%EmvoyPath%\Games 
set _LogsDirPath=%EmvoyPath%\Logs
set _SupportDirPath=%EmvoyPath%\Support
echo.


:: ---------------------------------------------------------------------------
:: Script/Other apps  globals- Do not change
:: ---------------------------------------------------------------------------
::  Wizzapp vars:
set waico=C:\GameEx\AHKS_BATS\Launchers\Emvoy\Emvoy\Assets\EmLogo.ico
set watitle=Emvoy System Menu
set wasig=Emvoy by stigzler
:: ---------------------------------------------------------------------------
:: ==========================================================
:: /END GLOBALS
:: ==========================================================

:: ----------------------------------------------------------
:: Start Logging
%EmvoyPath:~0,2%
cd %EmvoyPath%
break>Logs/emvoy.log
set _log1=^>^> Logs/emvoy.log 
echo Start of Emvoy Log %_log1%
echo Last run: %date% %time% %_log1%
echo. %_log1%

set watext=Cmd parameters and Boot Profile Loaded....~~Checking any parameters....
set wabmp=Assets\page\Splash.bmp
start /w wizapp PB OPEN 

:: Show Progress Bar
set watitle=EmVoy Startup
set watext=Starting Emvoy, please wait....~~Reading Command Line parameters....
::start /w wizapp PB OPEN

:: ----------------------------------------------------------
echo " ____  ____  _  _  ____  ____   __  "
echo "(  _ \/ ___)( \/ )(_  _)(  _ \ / _\ "
echo " ) __/\___ \ )  (   )(   )   //    \"
echo "(__)  (____/(_/\_) (__) (__\_)\_/\_/"
echo .
echo # Starting EmVoy...%_log1%
echo. %_log1%

:PRETESTS
%EmvoyPath:~0,2%
cd %EmvoyPath%
REM set _tempBootSel=1
REM set _tmpBoot_dpsProfName=Get out more
REM copy emvoy.ini "%EmvoyPath%\Boots\{%_tempBootSel%} %_tmpBoot_dpsProfName%.txt"
::goto :FunctionTests

::exit /b
 ::goto :skip
 
::call :IniCmd /m listtxt /f emvoy.ini /k _dpsProfName /t testlist.txt

::exit /b
REM SET "missing="
REM FOR /L %%a IN (0,1,99) DO IF NOT DEFINED missing (
 REM find "[%%a]" emvoy.ini>NUL
 REM IF ERRORLEVEL 1 SET /a "missing=%%a"
REM )
:: echo Lowest: %missing%
 
REM call :LoadTempIni 30 emvoy.ini _tmpBoot
REM set _tmpBoot

REM exit /b

::call :CopyRecord Emulators\emulators.ini 4 _emuName replace "{Copy} "

::call ::DeleteRecord Emulators\Emulators.ini 5 Emulators\EmulatorList.ini _emuName

::call :IniCmd /m listxk /f emvoy.ini /k _dpsProfName 

::exit /b



echo :: ==========================================================
:: exit /b 

 :skip 
 


:: ==========================================================
:CMD_VARS
:: ==========================================================
:: Acquire command line switches
:: ==========================================================
echo =============================================================================
echo # Processing parameters passed from Command Line--%_log1%
echo =============================================================================
:: ======================================================
:: PASSED VARIABLES + Derivations
:: Command Line Format:
:: Emvoy 	-d [gamefile dir] -f [filename with extension] -p [boot Profile] 
::				-e [boot emu for game] -g [alternative game name to auto generated one]
:: Above in any order. All optional. 
::
:: If you do not send -f, it will automatically set the Profile to 0 (default) if the 
:: default boot profile has SkipAdmin enabled. This is because you will have to select 
:: a game
::
:: -e 	overrides general default setting in Emvoy but individual game config overrides 
::			this. Thus emulator decided in this order (rightmost being final emulator used:
::			Emvoy default > Cmd line > Game setting. 
::			Best route is set up default emulator in the admin menu, but good for initial testing. 
::
:: -p	 	specifies the boot profile. This allows you different Emvoy setups. E.g. testing, 
:: 		setup and final run. You can set your own profiles in Emvoy. 
::
:: -g		You can pass a more user-friendly name if the file/folder name is ugly. If you're
::			using a Front-End, often the 'database' or friendly name can be put into your command line. 
::
::	e.g.1 - Ugly name
::		 	Emvoy.bat -d "I:\roms"" -f "Wipeout 3 [NTSC-U] [SLUS-00865].7z" -p 2 -e 1 -g "Wipeout 3"
::	e.g.2 - Launch Game with profile that skips admin menus and doesn't keep separate quicklaunch
::			Emvoy.bat -d "I:\roms"" -f "Wipeout XL.7z" -p 3 (Profile 3 skips admin menu and Qlaunch folder)
:: ==============================================================
:: Obtain values from switches

Echo # Parsing command line for switches and values:%_log1%
echo ---------------------------------------------------------------------------------------------------
:: Backup original cmd line and passed values
set _cmdorig=%*
set _cmdorig1=%1
set _cmdorig2=%2
set _cmdorig3=%3 
set _cmdorig4=%4 
set _cmdorig5=%5
 :PARSELOOP
IF [%1]==[] GOTO ENDPARSE
IF [%1]==[-d] SET _cmdRomDir=%2
IF [%1]==[-f] (
	SET _cmdFilename=%2
	Set _cmdGamename=%~n2
	)
IF [%1]==[-p] SET _cmdProfile=%2
IF [%1]==[-e] SET _cmdDefEmu=%2
IF [%1]==[-g] SET _cmdSpecGameName=%2
SHIFT
GOTO PARSELOOP
 :ENDPARSE

::echo Values from Command line:%_log1%
echo Original cmd line: [%_cmdorig%]%_log1%
echo Directory: [%_cmdRomDir%]%_log1%
echo File: [%_cmdFilename%]%_log1%
echo Profile: [%_cmdProfile%]%_log1%
echo Default Emulator: [%_cmdDefEmu%]%_log1%
echo Specified Gamename: [%_cmdSpecGameName%]%_log1%
echo Dequoted game name: [%_cmdGamename%]%_log1%
echo ---------------------------------------------------------------------------------------------------
:: END switch acquire
::pause
:: Load in relevant profile 
:ChooseLoadProfile
echo 					-------- oooooOOOOOooooooo --------
echo ---------------------------------------------------------------------------------------------------
echo # Loading correct Boot Profile depending on circumstances....%_log1%
echo ---------------------------------------------------------------------------------------------------
:: Retrieve Defualt Profile dets in boot seciton of ini
echo Reading Default Profile number from emvoy.ini:%_log1%
call :IniCmd /m read /s "X-boot" /k _dpsDefProfile /f emvoy.ini
set _tempBootProfile=%IniCmd%
set _tempGameFile=""
echo Default Boot Profile in EmVoy.ini is [%IniCmd%]
echo.
Echo Testing command line switches and load subsequent relevant boot profile:
If not [%_cmdProfile%] == [] (
		echo Profile is set in command line. Checking if a file passed too...%_log1%
		If "%_cmdGamename%" == "" (
				echo No gamefile is specified in command line. Checking whether profile has 'Skip admin' enabled....%_log1%
				echo.%_log1%
				call :IniCmd /m read /s %_cmdProfile% /k _dpsSkipAdmin /f emvoy.ini
				set perc=%IniCmd%
				set excl=!IniCmd!
				if [!IniCmd!] == [true] (
						echo Profile has 'Skip Admin' enabled. Thus, no game to boot nor menu to load. Setting to safe profile ^(0^) to enable menu.%_log1%
						set _tempBootProfile=X-Safeboot
						) else (					
						echo Profile has 'Skip admin' disabled. Using Profile from cmd line. %_log1%
						set _tempBootProfile=%_cmdProfile%
						)					
			) else (
				echo There is a gamefile specified.%_log1%
				set _tempBootProfile=%_cmdProfile%
				echo Setting profile to that passed from command line.%_log1%
			)
	) else (
		echo There is no boot profile specified in the command line.%_log1%
		echo Retriving details of default profile. %_log1%
		echo.
		call :IniCmd /m read /s X-boot /k _dpsDefProfile /f emvoy.ini	
		set _tempBootProfile=!IniCmd!
		echo Default profile: [!_tempBootProfile!]%_log1%
		REM echo Checking staus of Skip Admin in this profile...%_log1%
		REM echo.%_log1%
		REM call :IniCmd /m read /s !_tempBootProfile! /k _dpsSkipAdmin /f emvoy.ini
		REM echo Skip Admin in defualt profile: [!IniCmd!]%_log1%
		echo Checking if gamefile specified:%_log1%
		If "%_cmdGamename%" == "" (
				echo No gamefile is specified in command line. Checking whether the default profile has 'Skip admin' enabled....%_log1%
				echo.%_log1%
				call :IniCmd /m read /s !_tempBootProfile! /k _dpsSkipAdmin /f emvoy.ini 
				echo Skip Admin in defualt profile: [!IniCmd!]%_log1%
				if [!IniCmd!] == [true] (
						echo Profile has 'Skip Admin' enabled. Thus, no game to boot nor menu to load. Setting to safe profile ^(0^) to enable menu.%_log1%
						set _tempBootProfile=X-Safeboot
					) else (
						Echo Profile has Skip Admin disabled. Therefore, preserving Default Profile. %_log1%
					)
						
			) else (
				Echo There is a Game specified. Therefore safe to set to Default Profile whether Skip Admin enabled or not. %_log1%
				echo Profile maintained as default profile. %_log1%
					)
			)
			
set _dpsProfNo=%_tempBootProfile%
:: Load in all Profile variables
call :LoadIni %_dpsProfNo% emvoy.ini
echo Boot Profile Coice complete:
echo =====================================%_log1%
Echo Boot Profile being used is: [%_dpsProfNo%]%_log1%
Echo Boot Profile Name: [%_dpsProfName%]%_log1%
echo Boot Profile Description: %_dpsProfDesc%%_log1%
echo =====================================%_log1%
echo ---------------------------------------------------------------------------------------------------
echo.%_log1%
:: =================== /End Choose Profile
::pause
set watext=Cmd parameters and Boot Profile Loaded....~~Checking any parameters....
start /w wizapp PB UPDATE 20

echo                      ------------ oooooOOOOOOoooooo -------------
echo ---------------------------------------------------------------------------------------------------
echo File and Filepath operations if passed by command line:
echo ---------------------------------------------------------------------------------------------------
echo Check whether filename or path have been passed:
if [%_cmdFilename%] == [] (
		echo No filename passed in cmd. Setting Game Profile to 'none' and booting to admin menu. 
		set _admGameProfile=X-NoGame
		goto :Boot_admin_Menu
	)

if [%_cmdRomDir%] == [] (
		echo No filepath passed in cmd. Setting Game Profile to 'none' and booting to admin menu. 
		set _admGameProfile=X-NoGame
		goto :Boot_admin_Menu
	)
	
echo ** Game file and path passed, check they exist:
:Game_Filepath_Vars	
:: Checks if the gamefile directory exists - if not either log entry or user message depending on settings. 
:: At end of process, _cmdRomDir is dequoted. 
echo Set ROM and check directory%_log1%
Echo Raw recieved Directory param: %_cmdRomDir% %_log1%
call :dequote _cmdRomDir
:: Check Dir exists!
echo Checking if [%_cmdRomDir%] exists:%_log1%
if Not exist "%_cmdRomDir%" (
		echo Game Direcotry doesn't exist! %_log1%
		if [%_dpsUserUpdate%] == [true] (
				echo User prompt box - times out after 20s %_log1%
				call :MsgBoxMsg "You have passed an invalid Games Directory path. Please check your command line or file structure."  20 "Emvoy Startup Error" 48
			) else (
				echo User promtps set to false in emvoy.ini. %_log1%
			)
	set _admGameProfile=X-NoGame
	echo ****** goto start of admin menu *********
	goto :WAHome
	)
echo ** Game Directory exists **%_log1%
echo Game Direcotry finishes as: [%_cmdRomDir%]%_log1%
echo.%_log1%
:: ==================== / End Filepath AVrs

:Game_Filename_Vars
:: Process File Parameter from cmd 
:: Produces 	_dpsAutoGameName= Auto generated from filename and cleaned for illegal chars
:: 					_dpsSpecGameName= Taken from cmd line and Cleaned for illegal chars

echo # Check file exists to process. Also produces an AutoGameName from this. %_log1%
echo Also 'cleans' the AutoGameName and Specified game name (in cmd) of illegar characters. %_log1%
echo Also produces a 'clean' filename - Used in field _gameKey
echo.
echo Raw recived File param: [%_cmdFilename%%_log1%]
call :dequote _cmdFilename 
::echo Final Filename: [%_cmdFilename%]%_log1%
echo Checking [%_cmdFilename%] file exists:%_log1%
%_cmdRomDir:~0,2%
cd %_cmdRomDir%
if Not exist "%_cmdRomDir%/%_cmdFilename%" (
		echo Game File doesn't exist! %_log1%
		echo User prompt box - times out after 20s
		if [%_dpsUserUpdate%] == [true] (
				call :MsgBoxMsg "You have passed an invalid Game filename. Please check your command line or file structure."  20 "Emvoy Startup Error" 48
				Echo Presnting USer prompt - times out after 20s. %_log1%
			)
	set _admGameProfile=X-NoGame
	echo ****** goto start of admin menu *********
	goto :WAHome
	)
%EmvoyPath:~0,2%
cd %EmvoyPath%
echo ** Gamefile of that filename exists **%_log1%
::echo Producing 'clean' file name
call :CleanVar "%_cmdFilename%"
set _dpsCleanFilename=%CleanVar%
echo 'Clean' fielname: [%_dpsCleanFilename%]
echo.

echo # Producing Auto gamename from filename.%_log1%
set _dpsAutoGameName=%_cmdGamename%
::echo removing file extention: [%_dpsAutoGameName%]
::echo Sending RawAutoGameName. Removing invalid characters.%_log1%
call :CleanVar "%_dpsAutoGameName%"
::echo Setting GameName to cleaned string.%_log1%
set _dpsAutoGameName=%CleanVar%
Echo Resulting AutoGamename: [%_dpsAutoGameName%] %_log1%
echo.


echo # Producing Specified Gamnename from command line.%_log1%
call :dequote _cmdSpecGameName
::echo Dequoted: [%_cmdSpecGameName%]
::echo Cleaning variable. Removing invalid characters.%_log1%
call :CleanVar "%_cmdSpecGameName%"
::echo Setting specified game name to cleaned string.%_log1%
set _dpsSpecGameName=%CleanVar%
Echo Resulting Specified Gamename: [%_dpsSpecGameName%] %_log1%
echo.
echo ----------------------------------------------------------------------
echo SUMMARY:
echo Filename ^(cmdFilename^): [%_cmdFilename%]%_log1%
echo 'Clean' filename ^(dpsCleanFilename^): [%_dpsCleanFilename%]%_log1%
Echo AutoGamename ^(dpsAutoGameName^): [%_dpsAutoGameName%] %_log1%
Echo Specified Gamename ^(dpsSpecGameName^): [%_dpsSpecGameName%] %_log1%
echo ----------------------------------------------------------------------
::pause
echo.
set watext=Files checked, gamenames specified....~~Setting Emulator and Game Profile....
start /w wizapp PB UPDATE 40
echo -------------------END OF FILE OPERATIONS FROM CMD LINE----------------------------------
:: ================= /End Gamename Vars
echo. 

:TESTS
:: ===========================================================
:: TEST SCRIPTS
:: ============================================================

::cd Games
::call :IniCmd /m list /f emvoy.ini
:: echo %IniCmd%
:: exit /b


:: ===========================================================
:: /TEST SCRIPTS
:: ============================================================

:Set_adm_vars_to_cmds
:: Process Command and any existing Game Profile vars and setup for admin. 
echo =============================================================================
echo Pre-admin processing of any Cmd vars%_log1%
echo =============================================================================
echo.%_log1%
::echo Setting to home Emvoy directory.
%EmvoyPath:~0,2%
cd %EmvoyPath%
echo # Setting admin vars from boot:
::echo Dim all admin vars
set _adm=
:: stuff

echo ---------------------------------------------------------------------------------------------------
echo # Determine which emulator to use 
echo ---------------------------------------------------------------------------------------------------
echo Emulator passed from cmd line: [%_cmdDefEmu%]
:: if cmd emu not null - cycle through list of emus and check it corresponds to one
echo Searching emulator record set for matching emu:
if not [%_cmdDefEmu%] == [] (
		call :IniCmd /m list /f Emulators\emulators.ini
		echo Cycling through array to find a match...
		for /L %%S in (1,1,!IniCmd[0]!) do (
				echo !IniCmd[%%S]!
				if "!IniCmd[%%S]!" == "%_cmdDefEmu%" (
						set _admEmuNo=%_cmdDefEmu%
						echo There is an Emulator record matching the command switch. Set _admEmuNo to: [!_admEmuNo!]
						if [!_admEmuNo!] == [design] (
								echo You cannot use the 'design' record as an Emulator. Setting to Boot Profile default [%_dpsDefEmu%]
								set _admEmuNo=%_dpsDefEmu%
							)
					) else (
						echo The above Emultor key does not match the command line swith. 
					)
			)
		if [!_admEmuNo!] == [] (
					echo There are no emulators that match the command line switch. Using default emulator specified in the boot profile. 
					set _admEmuNo=!_dpsDefEmu!
				)
	) else (
		echo !_dpsDefEmu!
		set _admEmuNo=!_dpsDefEmu!
		echo There is no Emulator number passed by the command line. Using default emulator specified in the boot profile. 
		echo Setting _admEmuNo to: [!_admEmuNo!]
	)
echo * Final Emu used: [%_admEmuNo%]
echo.
echo ---------------------------------------------------------------------------------------------------
echo # Set files and file paths
echo ---------------------------------------------------------------------------------------------------
echo Transfer full filename to admin variable _admFilename:
set _admFilename=%_cmdFilename%
echo Full Filename used is: [%_admFilename%]

echo Transfer full filepath to admin variable _admRomDir:
set _admRomDir=%_cmdRomDir%
echo Full Filepath used is: [%_cmdRomDir%]

echo Transfer Cleaned filename to admin var _adm_CleanFilename - used as key in games settings
set _admCleanFilename=%_dpsCleanFilename%
echo Clean Fielname used is: [%_admCleanFilename%]

echo Constructing Key GameProfile name - Clean Filename + Emulator
call :IniCmd /m read /s %_admEmuNo% /k _emuName /f Emulators\emulators.ini 
set _admGameProfileKey=%_admCleanFilename% {%_admEmuNo%.%IniCmd%}
echo Final GameProfile Key: [%_admGameProfileKey%]
echo.


set watext=Set other profiles....~~Delaing with Game Name....
start /w wizapp PB UPDATE 60


echo ---------------------------------------------------------------------------------------------------
echo # Set Game name
echo ---------------------------------------------------------------------------------------------------
:: Retrieve Game Profile status

Echo Check to see if Game profile exists for Game Profile name
::call :IniCmd /m list /f Games\games.ini
call :IniCmd /m listxk /f Games\games.ini /k _gameKey 

set _tempGameProfExist=
for /L %%S in (1,1,%IniCmd[0]%) do (
		echo !IniCmd[%%S]!
		if "!IniCmd[%%S]!" == "%_admGameProfileKey%" (
				echo * Game Profile already exists for file passed by command line. 
				set _tempGameProfExist=true
				set _admGameProfile=!IniCmd[%%S,1]!
				echo GameProf = !_admGameProfile!
				goto :Boot_admin_Menu
			)
	)
if not [%_tempGameProfExist%] == [true] (
		echo * Game Profile does NOT exist for file passed by command line. 
		set _tempGameProfExist=false
	)
echo * Game Profile exists: [%_tempGameProfExist%]
echo.	



:: Next conditional on cmd line structure
echo Test whether user sent /g gamename and set the admin gamename accordingly:
if not "%_cmdFilename%" == "" if "%_dpsSpecGameName%" == "#null#"  if [%_tempGameProfExist%] == [false] (
		echo File passed form cmd, no Specified gamename and no profile exists. Setting _admGameName to AutoGameName
		set _admGameName=%_dpsAutoGameName%
	)

if not "%_cmdFilename%" == "" if not "%_dpsSpecGameName%" == "#null#"  if [%_tempGameProfExist%] == [false] (
		echo File passed from cmd, game name specified and no profile exists. Setting _admGameName to dpsSpecGameName
		set _admGameName=%_dpsSpecGameName%
	)
	
if not "%_cmdFilename%" == "" if not "%_dpsSpecGameName%" == "#null#" if [%_tempGameProfExist%] == [true] (
		echo File passed from cmd, game name specified and profile already exists for this file. 
		echo Ignoring Specified gamename as also specified in profile. User message if enabled in Default Profile. 
		if [%_dpsUserPrompt%] == [true] (
				if [%_dpsUserUpdate%] == [true] (
						call :MsgBoxMsg "Conflict: Game Profile already exists for this file and a Game Name is specified in the command line. Booting with the Game Name in the Game Profile. Ignoring command line switch."  10 "Emvoy Startup Message" 48
					)
			)
	)	
echo *Resulting Game Name passed to admin or launch:_admGameName: [%_admGameName%]
echo.
::Pause
echo =============================================================================
echo Summary of _adm vars so far:
echo =============================================================================
set _adm
set _cmd
echo =============================================================================
echo.

set watext=GameName processed....~~Making new Game Profile....
start /w wizapp PB UPDATE 80

::pause

:Load_relevant_profiles
echo ---------------------------------------------------------------------------------------------------
echo Loading Emulator Profile:
call :LoadIni %_admEmuNo% Emulators\emulators.ini
echo ---------------------------------------------------------------------------------------------------

echo ---------------------------------------------------------------------------------------------------
echo Test whether existing profile. If not, write one. 
echo tempgameprofexists: [%_tempGameProfExist%]
if [%_tempGameProfExist%] == [true] (
		echo Profile exists - go stright to admin menu. 
		echo _admGameProfile: [%_admGameProfile%]
		goto :Boot_admin_Menu
	)
echo Game profile does not exist. 
echo ---------------------------------------------------------------------------------------------------
echo Loading Emulator Profile:
call :LoadIni %_admEmuNo% Emulators\emulators.ini
:: If doesn't exist - make it 
echo Create Game Profile. 
:: have to set _admGameProfile to number generated

echo Finding lowest available record number...
call :_FreeRecordNo Games\games.ini
set _admGameProfile=%_FreeRecordNo%

pause
:: Remove dupes from Also Run concatenation
set _tmpstring=%_dpsAlsoLaunch%,%_emuAlsoLaunch%
echo Concat AlsoRun:%_tmpstring%:
SET "_admAlsoLaunch=,"
IF DEFINED _tmpstring FOR %%a IN (%_tmpstring%) DO (SET "_admAlsoLaunch=!_admAlsoLaunch:,%%a,=,!%%a,")
SET "_admAlsoLaunch=%_admAlsoLaunch:~1,-1%"
echo _admAlsoLaunch:%_admAlsoLaunch%:
pause

call :WriteIni X-write_frm_cmd_template "%_admGameProfile%" Games\games.ini
call :CreateSelectionList Games\games.ini _gameListName Games\GamePList.ini
echo.

:Boot_admin_Menu
echo Admin menu final boot loads
echo Loading Game Profile:
:: Load Inis
call :LoadIni %_admGameProfile% Games\games.ini
call :LoadIni %_gameEmu% Emulators\emulators.ini
call :CreateGPReportCmd 
REM echo ---------------------------------------------------------------------------------------------------
REM set _game
REM echo ---------------------------------------------------------------------------------------------------
REM echo.
goto :WAHome
exit /b




echo /b Quit before Main process
::EXIT /b


:: ======================================================
:MAIN_PROCEEDURE
:: ======================================================
:: ------------- Create / Use Quicklaunch Folder------------------
:: Use or setup Quicklaunch folder
:: --- Check whether Quicklaunch folder already exists + forward if does

:: ------ Also Launch 
:: Put routine in here to check for duplicates....




echo Checking whether quicklaunch folder already exists for this game....
If exist "%gamename%" (
	cd %gamename%
	if %adminmode% == admin (
	call :MsgBox "Quickstart folder exists..lauching game..." "vbOKonly" "Admin Message" )
	if %adminmode% == prompt (
	call :MsgBoxMsg "Quicklaunch Folder Exists." 1 "Progress Message" 0 )
	echo Quicklaunch exists.... going onto launch
	goto mountstart
)

:: Make Quicklaunch folder as one doesn't exist:
echo Folder doesn't exist. Making Quicklaunch folder....
mkdir "%gamename%"
cd "%gamename%"

:: Copy setup files to Quicklaunch folder
echo Moving operational files to folder and unzipping game rom to folder...
:: Create msg box vb in game folder
if %adminmode% == admin (
	call :MsgBox "No existing Quickstart folder, create one..." "vbOKonly" "Admin Message" )
if %adminmode% == prompt (
	call :MsgBoxMsg "No Quicklaunch Folder. Creating one..." 1 "Progress Message" 0 )
:: Copy over relevant operating files:
copy "%zipdir%\7zG.exe" 
copy "%PakkISOdir%\unecm.exe" 
copy "%PakkISOdir%\pakkiso.exe" 
copy "%PakkISOdir%\MAC.exe" 

:: Unzip Game Zip to Quicklaunch folder:
7zG e "%directory%\%file%"
echo Deleting any empty folders...
:: Delete empty folders:
for /f "usebackq delims=" %%d in (`"dir /ad/b/s | sort /R"`) do rd "%%d"
:: -----------------ECM, APE operations + tidy up---------------

:ecmproc
if %adminmode% == admin (
	call :MsgBox "Decompress ECM..." "vbOKonly" "Admin Message" )
if %adminmode% == prompt (
	call :MsgBoxMsg "Decompressing ECM Files..." 1 "Progress Message" 0 )
set ecmfile=nullecm
for /F "delims=" %%a in ('dir /b *.ecm') do set ecmfile=%%~na
echo Identified ECM file: "%ecmfile%"
if "%ecmfile%" == "nullecm" (
	echo No ECMs Found
	goto apeproc )
echo ECMs found. Decompress then delete ecm files
unecm.exe *.ecm
del "*.ecm"

:apeproc
if %adminmode% == admin (
	call :MsgBox "Decompress APE..." "vbOKonly" "Admin Message" )
if %adminmode% == prompt (
	call :MsgBoxMsg "Decompressing APE files.." 1 "Progress Message" 0 )
echo Uncompress APE files
for %%i in ("*.ape") do mac "%%i" "%%~ni.wav" -d && sox.exe "%%~ni.wav" -t raw -s -c 2 -w -r 44100 "%%~ni.bin" && del "*.wav"
:: Get rid of all processing exes:
echo Remove process exes
del "*.exe"

:: --------------- Game Launch ------------------------------------
:mountstart
:: ----- Determine which file to use for launch --------
:: set launchfile as iso, mds, cue or ccd in reverse priority
echo Determining launchfiles:
set launchfile=Undetermined
echo ISO:
for /F "delims=" %%a in ('dir /b *.iso') do set launchfile=%%~na.iso
echo Launchfile is now %launchfile%
echo MDS:
for /F "delims=" %%a in ('dir /b *.mds') do set launchfile=%%~na.mds
echo Launchfile is now %launchfile%
echo CUE:
for /F "delims=" %%a in ('dir /b *.cue') do set launchfile=%%~na.cue
echo Launchfile is now %launchfile%
echo CCD:
for /F "delims=" %%a in ('dir /b *.ccd') do set launchfile=%%~na.ccd
echo Final launchfile is: %launchfile%

if %adminmode% == admin (
	call :MsgBox "Mount Image and start emulation" "vbOKonly" "Admin Message" )
if %adminmode% == prompt (
	call :MsgBoxMsg "Launching Game..." 1 "Progress Message" 0 )
echo Launching game...
"%DTexe%/DTLite.exe" -mount scsi, 0, "%launchfile%"
C:
cd C:\Emulators\PLaystation\ePSXe190
start/wait epsxe.exe -nogui -loadmemc0 "memcards\%gamename%"
::ping -n 3 localhost  > nul
"%DTexe%" -unmount scsi, 0


:: ----------------------- Quicklaunch Folder administration ---------------
:: Rejoin Quickstart folder
%quicklaunchdir:~0,2%
cd %quicklaunchdir%

echo check for admin mode
Echo adminmode - %adminmode%
If %adminmode% == admin (
	echo Choose whether to keep Quickstart folder or not...
	call :MsgBox "Keep Quickstart folder?"  "VBYesNo+VBQuestion" "Admin Message"
    if errorlevel 7 (
        echo NO - don't keep folder
		rmdir /s /q "%gamename%"
		call :MsgBox "Deleting Quicklaunch Folder..." "vbOKonly" "Admin Message" )
		goto EndScript
    ) else if errorlevel 6 (
        echo YES - keep folder
		call :MsgBox "Keeping Quicklaunch Folder..." "vbOKonly" "Admin Message"
		goto Tidy
    )
) else (
	If %qlaunch% == delete (
		echo No admin mode. Default discard Quicklaunch game folder
		If %adminmode% == prompt (
			call :MsgBoxMsg "Using default - %qlaunch% Quicklaunch Folder" 1 "Progress Message" 0 )
		rmdir /s /q "%gamename%"
		goto EndScript
	) else (
		echo No admin mode. Default of keep Quicklaunch game folder used...
		If %adminmode% == prompt (
			call :MsgBoxMsg "Using default - %qlaunch% (keep) Quicklaunch Folder" 1 "Progress Message" 0 )
	)
)
	
	
:: ----------------- Tidy + End ---------------------------------	
:Tidy
cd "%gamename%"
echo Tidying Quicklaunch folder...

:EndMainProceedure
If %adminmode% == admin If %adminmode% == prompt (
call :MsgBoxMsg "Process Complete" 1 "Progress Message" 0 )
echo The End!
echo Phew....
exit /b

EXIT /b
:: ========================================================
:: END MAIN PROCEEDURE
:: ========================================================


:: ======================================================
:ADMIN_MENU
:: ======================================================
	
:: -----------------------------------------------------------
:: Main Menu
:: -----------------------------------------------------------
:: NOTES
:: in main menu, read values from boot to direct first run
:: e.g. firstrun=emultor needed , then profile needed
:: i.e. firstrun=trrue
:: then force walk through add emulator directly followed by add profile 
::
:: in edit profile, disable selecting profile 0 (safe prof) 
:: 
:: message on home page if safeboot detected
:: 



:: =========================================================================================
:WAHome
:: =========================================================================================
set watitle=EmVoy Admin Menu
start /w wizapp PB UPDATE 100
start /w wizapp PB CLOSE
:: Clear Vars

:: Check for run status (1st run limits options)
call :IniCmd /m read /f emvoy.ini /s X-boot /k _dpsSetupStatus
if [%IniCmd%] == [BootProfNeeded] (
		set WAErrorText=This is the first time you have run EmVoy. Directing to boot settings to set your boot defaults. 
		set WAErrorRet=WAPxtrDefaults1
		call :WAError
		Echo place direction here
		)
if [%IniCmd%] == [EmuNeeded] (
		set WAErrorText=This is the first time you have run EmVoy. Directing to boot settings to set your boot defaults. 
		set WAErrorRet=WAPxtrDefaults1
		call :WAError
		echo place goto here
		)
call :WAClearVarsPage

set watext=Boot:	%_dpsProfNo%. %_dpsProfName% ~^
Game:	%_admGameProfile%. ^%_gameListName%~^
(Updtd^):	%_gameUpdate:~0,-13%~^
File:	%_gameFile%~^
Emu:	%_emuName%~^
(Updtd^):	%_emuUpdate:~0,-13%~^
~What would you like to do now?
set wabmp=Assets\page\home.bmp
:: Construct Menu options depending on boot status:
set wainput= Change Default Settings; Select Different Game Profile
set waoutnum=0

if not "%_admGameProfile%" == "X-NoGame" (
		set wainput=%wainput%; Edit Game Profiles; List Functions; Boot Game Profile
	)
set wanum=0
set wabat=%TEMP%\wabat.bat
set wasig=Home
start /w wizapp NOBACK RB
if errorlevel 2 (
		echo BOOTING GAME!!!!!
		exit /b
	)
if errorlevel 1 exit /b
call %wabat%
if %waoutnum%==0 goto :WAEmDefaultsHome
if %waoutnum%==1 goto :WAGamePSel
if %waoutnum%==2 goto :WAEmGamePSettsHome
if %waoutnum%==3 goto :WAEmRomList
if %waoutnum%==4 goto :eof
goto :WAHome
goto :WAHome		


:: ====================================================================
::															GAME PROFILE SELECT
:: ====================================================================

:WAGamePSel
call :WAClearVarsPage
set wabmp=Assets\page\GameEdit.bmp
call :WAEmSel "Which Game Profile would you like to use?~~" Assets\page\Games.bmp Games\GamePList.ini _admGameProfile :WAHome :WAHome
echo New Game Profile Selected: %_admGameProfile%
call :LoadIni %_admGameProfile% Games\games.ini
call :LoadIni %_gameEmu% Emulators\emulators.ini
echo Loaded Game Profile and corresponding Emulator. 
goto :WAHome

:: ====================================================================
::															LISTS HOME
:: ====================================================================

:WAEmListsHome
call :WAClearVarsPage
set wabmp=Assets\page\Setts.bmp
set watext=What?
Set wainput= Refresh ROM List for this Boot Profile; Emulator Settings; Support App Settings
set waoutnum=0 
set wabat=%TEMP%\wabat.bat
set wasig=Home^>Settings
start /w wizapp RB
if errorlevel 2 goto :WAHome
if errorlevel 1 goto :WAHome
call %wabat%
  if "%waoutnum%"=="0" (
		echo Refreshing ROMList for boot profile. 
		goto :WAEmRomList
	)
  if "%waoutnum%"=="1" (
		echo Going to Emulator Settings Menu
		goto :WAEmEmuSettsHome
	)
  if "%waoutnum%"=="2" (
		echo Going to Support App Settings
		goto :WAEmSuppSettsHome
	)
goto :WAEmListsHome

:WAEmRomList
call :WAClearVarsPage
echo on
call :CreateGameROMList "%_dpsRomDir%" "%_dpsProfName%.ini"
goto :WAEmListsHome




:: ====================================================================
::															SETTINGS HOME
:: ====================================================================
:WAEmDefaultsHome

:: Wizapp Set Emvoy Defaults process
:: Set temp default values:

:: Show Summary Boot, Emu and Support Dets
call :WAClearVarsPage
set wabmp=Assets\page\Setts.bmp
set watext=What settings would you like to change?
Set wainput= Boot Settings; Emulator Settings; Support App Settings
set waoutnum=0 
set wabat=%TEMP%\wabat.bat
set wasig=Home^>Settings
start /w wizapp RB
if errorlevel 2 goto :WAHome
if errorlevel 1 goto :WAHome
call %wabat%
  if "%waoutnum%"=="0" (
		echo Going to Boot Settings Menu
		goto :WAEmBootSettsHome
	)
  if "%waoutnum%"=="1" (
		echo Going to Emulator Settings Menu
		goto :WAEmEmuSettsHome
	)
  if "%waoutnum%"=="2" (
		echo Going to Support App Settings
		goto :WAEmSuppSettsHome
	)
goto :WAEmDefaultsHome





:: ====================================================================
::  																SETTINGS : BOOT
:: ====================================================================
:WAEmBootSettsHome
:: ====================================================================
call :WAClearVarsPage
set wafile=
set wabmp=Assets\page\BootSetts.bmp

set watext=Summary of current Default Boot Profile:~
set watext=%watext%Current Boot:	%_dpsProfName% ^(%_dpsProfNo%^)~
set watext=%watext%Quicklaunch:	%_dpsQLaunch%~
call :IniCmd /m read /f Emulators\emulators.ini /s %_dpsDefEmu% /k _emuName
set watext=%watext%Defualt Emu:	%IniCmd%~
set watext=%watext%Skip Menu:	%_dpsSkipAdmin%~
set watext=%watext%User Update:	%_dpsUserUpdate%~
set watext=%watext%^(Edit the profile to review its full settings^)~~
Set wainput= Create a new Boot Profile; Edit an exisitng Boot Pofile; Copy a Boot Profile; Delete a Boot Profile; Set the default Boot Profile 
set waoutnum=1
set wabat=%TEMP%\wabat.bat
set wasig=Home^>Settings^>Boot
start /w wizapp RB
if errorlevel 2 goto :WAHome
if errorlevel 1 goto :WAEmDefaultsHome
call %wabat%
  if "%waoutnum%"=="0" (
		echo Going to New Boot Profile Wizard
		goto :WAEmBootNew
	)
  if "%waoutnum%"=="1" (
		echo Going to Edit Boot Profile wizard
		goto :WAEmBootEditSetup
	)
  if "%waoutnum%"=="2" (
		echo Going to Copy Boot Profile wizard. 
		goto :WAEmBootCopy
	)
  if "%waoutnum%"=="3" (
		echo Going to Delete Boot Profile wizard. 
		goto :WAEmBootDel
	)
if "%waoutnum%"=="4" (
		echo Going to Change default Boot Profile.
		goto :WAEmBootDefSel
	)
goto :WAEmBootSettsHome

 :WAEmBootDefSel
:: ------------- SELECT DEFAULT PROFILE ---------------------------
call :WAClearVarsPage
echo Select Default Boot Profile 

call :WAEmSel "Which Boot Pro file would you like to set as the Default Boot Profile?~~N.B. This will require you to manually re-boot EmVoy" Assets\page\BootEdit.bmp Boots\BootProfiles.ini _tempBootSel :WAEmBootSettsHome :WAEmBootSettsHome
 
call :IniCmd /m read /f emvoy.ini /s %_tempBootSel% /k _dpsProfName 
set _tmpBoot_ProfFilename={%_tempBootSel%} %IniCmd%.txt

set wasig=Home^>Settings^>Boot^>Default Boot
set wafile=Boots\%_tmpBoot_ProfFilename%
set watext=~Are you sure you want to set Boot Profile %_tempBootSel% as the Default boot profile?~~^
(Clicking 'Yes' will close Emvoy requiring you to manually restart)~~^
Profile %_tempBootSel% details:~
set wabat=%TEMP%\wabat.bat
set walabels=No;Yes
start /w wizapp NOCANCEL FT
if errorlevel 1 goto :WAEmBootSettsHome
call :IniCmd /m write /f emvoy.ini /s "X-boot" /k _dpsDefProfile /v %_tempBootSel% 
set watitle=EmVoy Message
set watext=You have changed the Default Boot Profile. EmVoy will now close, requiring a ^
manual restart. Thanks for flying EmVoy! 
start /w wizapp MB EXCLAMATION
exit /b 

:: ----------------------- NEW PROFILE ----------------------------
 :WAEmBootNew
call :_FreeRecordNo emvoy.ini
set _tmpBoot_NewRec=%_FreeRecordNo%
call :WAClearVarsPage
set wasig=Home^>Settings^>Boot^>Create New
set wafile=
set watext=~~~Create a new Boot Profile?~~New Profile will be listed as Profile number: %_FreeRecordNo% 
set wabat=%TEMP%\wabat.bat
set walabels=No;Yes
start /w wizapp NOCANCEL TB 
if errorlevel 1 goto :WAEmBootSettsHome
call %wabat%
call :CopyRecord emvoy.ini 0 _dpsProfName replace "New Profile {%_tmpBoot_NewRec%}"
call :CreateSelectionList emvoy.ini _dpsProfName Boots\BootProfiles.ini 
:: [Ini] [IniKey] [ListFile]
set _tempBootSel=%_FreeRecordNo%
goto :WAEmBootEditSetup2

:: ----------------------- COPY PROFILE ----------------------------
 :WAEmBootCopy
echo Copy Boot record
call :WAClearVarsPage
call :WAEmSel "Which Boot profile would you like to copy from?" Assets\page\BootEdit.bmp Boots\BootProfiles.ini _tempBootSel :WAEmBootSettsHome :WAEmBootSettsHome
call :_FreeRecordNo emvoy.ini
set _tmpBoot_NewRec=%_FreeRecordNo%
call :IniCmd /m read /f emvoy.ini /s %_tempBootSel% /k _dpsProfName 
set _tmpBoot_CopyName=%IniCmd%
set _tmpBoot_ProfFilename={%_tempBootSel%} %IniCmd%.txt
echo %_tmpBoot_ProfFilename%
set wasig=Home^>Settings^>Boot^>Copy Prof
set wafile=Boots\%_tmpBoot_ProfFilename%
set watext=~~~Copy Profile %_tempBootSel% to a new Boot Profile numbered %_tmpBoot_NewRec%?~~^
Profile %_tempBootSel% details:~

set wabat=%TEMP%\wabat.bat
set walabels=No;Yes
start /w wizapp NOCANCEL FT
if errorlevel 1 goto :WAEmBootSettsHome
call %wabat%
call :CopyRecord emvoy.ini %_tempBootSel% _dpsProfName prefix "Copy of "
call :CreateSelectionList emvoy.ini _dpsProfName Boots\BootProfiles.ini 
::pause
echo on
copy "%EmvoyPath%\Boots\{%_tempBootSel%} %_tmpBoot_CopyName%.txt" "%EmvoyPath%\Boots\{%_tmpBoot_NewRec%} Copy of %_tmpBoot_CopyName%.txt"
:: [Ini] [IniKey] [ListFile]
set _tempBootSel=%_FreeRecordNo%
:: Write new romlist
copy "%EmvoyPath%\Games\ROMLIsts\%_tmpBoot_CopyName%.ini" "%EmvoyPath%\Games\ROMLIsts\Copy of %_tmpBoot_CopyName%.txt"


goto :WAEmBootEditSetup2

:: ----------------------- DELETE PROFILE ----------------------------
 :WAEmBootDel
:: delete record 
:: delete boots file 
:: Update BootProfiles.ini 
echo Delete Boot record
call :WAClearVarsPage
call :WAEmSel "Which Boot profile would you like to delete?" Assets\page\BootDel.bmp Boots\BootProfiles.ini _tempBootSel :WAEmBootSettsHome :WAEmBootSettsHome
call :IniCmd /m read /f emvoy.ini /s %_tempBootSel% /k _dpsProfName 
set _tmpBoot_ProfFilename={%_tempBootSel%} %IniCmd%.txt
:: TODO: check not deleting the default boot profile. If so re-direct to change boot profile?
set wabmp=Assets\page\BootDel.bmp
set wasig=Home^>Settings^>Boot^>Delete Prof
set wafile=Boots\%_tmpBoot_ProfFilename%

set watext=Delete Profile. Are you sure you want to delete the Boot Profile below?~~^
Boot Profile: %_tmpBoot_ProfFilename%~~^
(N.B. If this is a copy of another profile which wasn't subsequently edited, the ^
profile name below will be that of the original profile).



set wabat=%TEMP%\wabat.bat
set walabels=No;Yes
start /w wizapp NOCANCEL FT
if errorlevel 1 goto :WAEmBootSettsHome
call %wabat%
call :DeleteRecord emvoy.ini "%_tempBootSel%" Boots\BootProfiles.ini _dpsProfName
:: cscript //nologo "%~f0?.wsf" //job:IniCommand /cmd:DeleteSection /section:"%_tempBootSel%" /file:"emvoy.ini"
del "%EmvoyPath%\Boots\%_tmpBoot_ProfFilename%"
::call :CreateSelectionList emvoy.ini _dpsProfName Boots\BootProfiles.ini 
goto :WAEmBootSettsHome 

:: -----------------------------------------------------------------------------------
:: ----------------------- EDIT PROFILE ------------------------------------------
:: -----------------------------------------------------------------------------------
 :WAEmBootEditSetup
:: Setup
call :WAClearVarsPage
echo ---------------- Starting Edit Boot Profile  -------------------------
call :WAEmSel "Which profile would you like to Edit?" Assets\page\BootEdit.bmp Boots\BootProfiles.ini _tempBootSel :WAEmBootSettsHome :WAEmBootSettsHome
echo * Boot Profile Selected: %_tempBootSel%
 :WAEmBootEditSetup2
:: Line up temp variables:
set _tmpBoot=
call :LoadTempIni %_tempBootSel% emvoy.ini _tmpBoot
set wabmp=Assets\page\BootEdit.bmp

set _tmpBoot_OrigProfName=%_tmpBoot_dpsProfName%
set _tmpBoot_OrigDefEmu=%_tmpBoot_dpsDefEmu%
call :IniCmd /m read /f Emulators\emulators.ini /s %_tmpBoot_OrigDefEmu% /k _emuName
set _tmpBoot_OrigEmuName=%IniCmd%
set _tmpBoot_OrigAlsoLaunch=%_tmpBoot_dpsAlsoLaunch%
echo ---------------- Origs set  -------------------------
echo orig prof name: %_tmpBoot_OrigProfName%
echo orig emu number: %_tmpBoot_OrigDefEmu%
echo orig emu name: %_tmpBoot_OrigEmuName%

 :WAEmBootEdit1
 :: Profile Name
call :WAClearVarsPage
set watext=Editing Profile: [%_tempBootSel%] %_tmpBoot_OrigProfName% ~~Choose a name for this profile:
set wabat=%TEMP%\wabat.bat
set waoutput=%_tmpBoot_dpsProfName%
set wasig=Home^>Settings^>Boot^>Edit
start /w wizapp EB PLAIN
if errorlevel 2 goto :WAEmBootSettsEnd
if errorlevel 1 goto :WAEmBootEditSetup
call %wabat%
set waoutput=%waoutput:"=%
call :CleanVar "%waoutput%" 
echo User Input: [%waoutput%]
echo Cleaned version: [%CleanVar%]
if not "%CleanVar%" == "%waoutput%" (
		echo Input string and 'clean' version do not match 
		set WAErrorText=The text entered contains invalid charaters.~Your entry has been changed, removing these.~Please review and ammend as neccessary. 
		call :WAError
		set _tmpBoot_dpsProfName=!CleanVar!
		echo Error sent and cleaned input placed back in input box. 
		goto :WAEmBootEdit1
	)
:: remove any trailing spaces:
for /l %%a in (1,1,10) do if "!waoutput:~-1!"==" " set waoutput=!waoutput:~0,-1!
set _tmpBoot_dpsProfName=%waoutput%
echo * Temp name set: [%_tmpBoot_dpsProfName%]

 :WAEmBootEdit2
:: Profile Description
call :WAClearVarsPage
set wafile=
set watext=Editing Profile: [%_tempBootSel%] %_tmpBoot_OrigProfName% ~Start of description at present:~%_tmpBoot_dpsProfDesc:~0,200%.......~~ Please enter a description for this profile:
set wabat=%TEMP%\wabat.bat
set waoutput=%_tmpBoot_dpsProfDesc%
start /w wizapp EB
if errorlevel 2 goto :WAEmBootSettsEnd
if errorlevel 1 goto :WAEmBootEdit1
call %wabat%
set waoutput=%waoutput:"=%
set _tmpBoot_dpsProfDesc=%waoutput%
set watext=Your description appears below. If you are happy with it, press next to continue. Otherwise press back to edit.~~%waoutput%
start /w wizapp TB
if errorlevel 2 goto :WAEmBootSettsEnd
if errorlevel 1 goto :WAEmBootEdit2
echo Boot Profile Description updated..

 :WAEmBootEdit3
:: 7zip path
call :WAClearVarsPage
set watext=Editing Profile: [%_tempBootSel%] %_tmpBoot_OrigProfName%~~Choose path to 7Zip Folder:
set wabat=%TEMP%\wabat.bat
set waoutput=%_tmpBoot_dpsZipDir%
start /w wizapp FB DIR
if errorlevel 2 goto :WAEmBootSettsEnd
if errorlevel 1 goto :WAEmBootEdit2
call %wabat%
[tests]
set _tmpBoot_dpsZipDir=%waoutput%
if not exist "%_tmpBoot_dpsZipDir%" (
		set WAErrorText=That is an invalid file path!~Folder does not exist.~Please re-select or re-enter. 
		call :WAError
		goto :WAEmBootEdit3
		)
echo 7Zip Filepath good! Set to [%_tmpBoot_dpsZipDir%]

 :WAEmBootEdit4
:: PakkISO dir
call :WAClearVarsPage
set watext=Editing Profile: [%_tempBootSel%] %_tmpBoot_OrigProfName%~~Choose path to PakkISO Folder:
set wabat=%TEMP%\wabat.bat
set waoutput=%_tmpBoot_dpsPakkISOdir%
start /w wizapp FB DIR
if errorlevel 2 goto :WAEmBootSettsEnd
if errorlevel 1 goto :WAEmBootEdit3
call %wabat%
set _tmpBoot_dpsPakkISOdir=%waoutput%
if not exist "%_tmpBoot_dpsPakkISOdir%" (
		set WAErrorText=That is an invalid file path!~Folder does not exist.~Please re-select or re-enter.  
		call :WAError
		goto :WAEmBootEdit4
		)
echo PakkISO Filepath good! [%_tmpBoot_dpsPakkISOdir%]

 :WAEmBootEdit5
:: Quicklaunch Folder
call :WAClearVarsPage
set watext=Editing Profile: [%_tempBootSel%] %_tmpBoot_OrigProfName%~~Choose path to the Quicklaunch Folder~(This is where your unzipped game files will go):
set wabat=%TEMP%\wabat.bat
set waoutput=%_tmpBoot_dpsQLaunchDir%
start /w wizapp FB DIR
if errorlevel 2 goto :WAEmBootSettsEnd
if errorlevel 1 goto :WAEmBootEdit4
call %wabat%
set tempQuicklaunchdir=%waoutput%
if not exist "%_tmpBoot_dpsQLaunchDir%" (
		set WAErrorText=That is an invalid file path!~Folder does not exist.~Please re-select or re-enter.  
		call :WAError
		goto :WAEmBootEdit5
		)
echo Quicklaunch Filepath good!	[%_tmpBoot_dpsQLaunchDir%]

 :WAEmBootEdit6
:: Daemon Tools Folder
call :WAClearVarsPage
set watext=Editing Profile: [%_tempBootSel%] %_tmpBoot_OrigProfName%~~Choose path to Daemon Tools .exe:
set wabat=%TEMP%\wabat.bat
set waoutput=%_tmpBoot_dpsDTexe%
set wainput=Exe files (*.exe);*.exe;All files (*.*);*.*
start /w wizapp FB FILE
if errorlevel 2 goto :WAEmBootSettsEnd
if errorlevel 1 goto :WAEmBootEdit5
call %wabat%
set _tmpBoot_dpsDTexe=%waoutput%
if not exist "%_tmpBoot_dpsDTexe%" (
		set WAErrorText=That is an invalid file path or name!~Folder or file does not exist.~Please re-select or re-enter.  
		call :WAError
		goto :WAEmBootEdit6
		)
echo Daemon Tools Filepath and file good! [%_tmpBoot_dpsDTexe%]

 :WAEmBootEdit7
:: Game ROMs
call :WAClearVarsPage
set watext=Editing Profile: [%_tempBootSel%] %_tmpBoot_OrigProfName%~~Choose path to your Game Files:~~(This is the folder where your full set of files reside - not the processed ones. For example, where your set of zipped game files sit). 
set wabat=%TEMP%\wabat.bat
set waoutput=%_tmpBoot_dpsRomDir%
start /w wizapp FB DIR
if errorlevel 2 goto :WAEmBootSettsEnd
if errorlevel 1 goto :WAEmBootEdit6
call %wabat%
set _tmpBoot_dpsRomDir=%waoutput%
if not exist "%_tmpBoot_dpsRomDir%" (
		set WAErrorText=That is an invalid file path!~Folder does not exist.~Please re-select or re-enter.  
		call :WAError
		goto :WAEmBootEdit7
		)
echo ROMs Filepath good! [%_tmpBoot_dpsRomDir%]

 :WAEmBootEdit8
:: Quicklaunch setting
call :WAClearVarsPage
set watext=Editing Profile: [%_tempBootSel%] %_tmpBoot_OrigProfName%~~What to do with the Quicklaunch folder once game/emulator is exited:~(Useful for when run Emvoy from another FrontEnd with no Admin Functions)
set wabat=%TEMP%\wabat.bat
if defined _tmpBoot_dpsQlaunchWaoutput (
		set waoutnum=%_tmpBoot_dpsQlaunchWaoutput%
	) else (
		set waoutnum=0
	)
set wainput=Keep; Ask; Delete
start /w wizapp RB
if errorlevel 2 goto :WAEmBootSettsEnd
if errorlevel 1 goto :WAEmBootEdit7
call %wabat%
if "%waoutnum%" == "0" set _tmpBoot_dpsQLaunch=keep
if "%waoutnum%" == "1" set _tmpBoot_dpsQLaunch=ask
if "%waoutnum%" == "2" set _tmpBoot_dpsQLaunch=delete
set _tmpBoot_dpsQlaunchWaoutput=%waoutnum%
Echo Quicklaunch folder setting: [%_tmpBoot_dpsQLaunch%]

 :WAEmBootEdit9
:: Emulator
call :WAClearVarsPage
set _tempConcatEmuName=%_tmpBoot_OrigDefEmu%: %_tmpBoot_OrigEmuName%
echo temp concatd emu name: [%_tempConcatEmuName%]

set watext=Editing Profile: [%_tempBootSel%] %_tmpBoot_OrigProfName%~~^
Present Default Emulator for this Boot Profile is: %_tmpBoot_OrigDefEmu%~~^
Without change, on save settings, will change to: %_tmpBoot_dpsDefEmu%~~^
Please set the default emulator to use with this profile:

set wabat=%TEMP%\wabat.bat
set wafile=Emulators\EmulatorList.ini
if defined _tmpBoot_dpsEmuWaoutput (
		set waoutnum=%_tmpBoot_dpsEmuWaoutput%
	) else (
		set waoutnum=0
	)
start /w wizapp LB SINGLE
if errorlevel 2 goto :WAEmBootSettsEnd
if errorlevel 1 (
		set wafile=
		goto :WAEmBootEdit8
	)
call %wabat%
echo * User Selected: %waoutput%
for /f "tokens=1 delims=:" %%A in ("%waoutput%") do set _tempSel=%%A
set _tmpBoot_dpsDefEmu=%_tempSel: =%
set _tmpBoot_dpsEmuWaoutput=%waoutnum%
set _tmpBoot_dpsEmuWaoutputReport=%waoutput%
echo * Temp Emu Select: [%_tmpBoot_dpsDefEmu%]


 :WAEmBootEdit10
:: Support Apps
call :WAClearVarsPage
set watext=Editing Profile: [%_tempBootSel%] %_tmpBoot_OrigProfName%~~^
Existing Support App settings: %_tmpBoot_OrigAlsoLaunch%~^
Without change below, on save: %_tmpBoot_dpsAlsoLaunch%~^
Please select the support Apps you wish to run alongside your emulator when the game boots.^
These defaults can be further modified by individual Emulator and Games Profiles. CTRL+CLICK = Multi-Select

set wabat=%TEMP%\wabat.bat
set wafile=Support\SupportAppsList.ini
if defined _tmpBoot_dpsAppWaoutput (
		set waoutnum=%_tmpBoot_dpsAppWaoutput%
	) else (
		set waoutnum=0
	)

start /w wizapp LB MULTIPLE
if errorlevel 2 goto :WAEmBootSettsEnd
if errorlevel 1 (
		set wafile=
		goto :WAEmBootEdit9
	)
call %wabat%
if "%waoutnum%" == "" (
		echo No support apps selected
		set _tmpBoot_dpsAlsoLaunch=
		set _tmpBoot_dpsAppWaoutputReport=
		goto :WAEmBootEdit11
	)
echo * User Selected: %waoutput%
set _tmpBoot_dpsAppWaoutput=%waoutnum%
call :GetNumberString "%waoutput%"
echo Returned value: %GetNumberString%
set _tmpBoot_dpsAlsoLaunch=%GetNumberString%
set _tmpBoot_dpsAppWaoutputReport=%waoutput%

 :WAEmBootEdit11
::Booleans
call :WAClearVarsPage
set watext=Editing Profile: [%_tempBootSel%] %_tmpBoot_OrigProfName%~~^
* Denotes Excercise caution with these settings - see documentation.~~^
Tick the boxes of the settings you wish to apply:
set wabat=%TEMP%\wabat.bat
set waoutnum=%_tmpBoot_dpsBooleansWaOutput%
set wainput=^
Quit EmVoy when the Game or Emluator closes;^
Skip this admin menu - controls via command line;^
Show update messages to user (no click required);^
Prompt admin/user input for various functions;^
Show command line window;^
Create Log;^
Create Log History;^
Skip the UnZip part of the Emvoy process. *;^
Skip the UnECM part of the Emvoy process. *;^
Skip making Quicklaunch Folder. *
start /w wizapp CL
if errorlevel 2 goto :WAEmBootSettsEnd
if errorlevel 1 goto :WAEmBootEdit10
call %wabat%
set _tmpBoot_dpsBooleansWaOutput=%waoutnum%
for %%c in (0 1 2 3 4 5 6 7 8 9) do set _tmpBoot_chk[%%c]=false
for %%c in (%waoutnum%) do set _tmpBoot_chk[%%c]=true
set _tmpBoot_dpsQAppOnGameQ=%_tmpBoot_chk[0]%
set _tmpBoot_dpsSkipAdmin=%_tmpBoot_chk[1]%
set _tmpBoot_dpsShowCmd=%_tmpBoot_chk[4]%
set _tmpBoot_dpsLog=%_tmpBoot_chk[5]%
set _tmpBoot_dpsLogHistory=%_tmpBoot_chk[6]%
set _tmpBoot_dpsSkipZip=%_tmpBoot_chk[7]%
set _tmpBoot_dpsSkipECM=%_tmpBoot_chk[8]%
set _tmpBoot_dpsSkipQLaunch=%_tmpBoot_chk[9]%
set _tmpBoot_dpsUserUpdate=%_tmpBoot_chk[2]%
set _tmpBoot_dpsUserPrompt=%_tmpBoot_chk[3]%

:: Make report for final signoff
call :WAEmBootCompileReport
:: -------------------------------

 :WAEmBootEdit12
:: Review settings
set watext=Editing Profile: [%_tempBootSel%] %_tmpBoot_OrigProfName%~~^
Review proposed changes. Select 'Back' to make further changes, ^
or 'Save' to save settings and return to the Boot settings Menu.~~^
Copy and paste if textbox not big enough. 
set walabels=;Save
set wabat=%TEMP%\wabat.bat
set wafile=%temp%\EmTempSettRep.txt
start /w wizapp FT
set walabels=
if errorlevel 2 goto :WAEmBootSettsEnd
if errorlevel 1 goto :WAEmBootEdit11
call %wabat%

 :WAEmBootEditEnd
echo Finishing Edit process 
:: Move temp list to perm
copy %temp%\EmTempSettRep.txt "%EmvoyPath%\Boots\{%_tempBootSel%} %_tmpBoot_dpsProfName%.txt"
del %temp%\EmTempSettRep.txt
:: If profile name changed - delete old list 
if not "%_tmpBoot_dpsProfName%" == "%_tmpBoot_OrigProfName%" (
		del "%EmvoyPath%\Boots\{%_tempBootSel%} %_tmpBoot_OrigProfName%.txt"
	)
:: unset two variables used in report only:
set _tmpBoot_dpsEmuWaoutputReport=
set _tmpBoot_dpsAppWaoutputReport=

echo Writing new settings to ini file.
::Set date+time of update:
set _tmpBoot_dpsUpdateDate=%date% %time%
::Backup emvoy.ini - safety first!
copy /y emvoy.ini Backups\emvoy.ini
:: Write relevant value to ini
set _tmpBoot_dps
:: Wipe Section:
cscript //nologo "%~f0?.wsf" //job:IniCommand /cmd:DeleteSection /section:"%_tempBootSel%" /file:"emvoy.ini"
:: Re-write section with new vars:
for /f "delims=" %%a in ('set _tmpBoot_dps') do (
		set _tmpBoot_IniWrite=%%a
		set _tmpBoot_IniWrite=!_tmpBoot_IniWrite:~8!
		echo Splitting: [!_tmpBoot_IniWrite!]
		for /f "tokens=1,2 delims==" %%b in ("!_tmpBoot_IniWrite!") do (
				set _tmpBoot_key=%%b
				set _tmpBoot_value=%%c
			)
		echo key: [!_tmpBoot_key!]
		echo value: [!_tmpBoot_value!]
		cscript //nologo "%~f0?.wsf" //job:IniCommand /cmd:WriteEntry /section:"!_tempBootSel!" /key:"!_tmpBoot_key!" /value:"!_tmpBoot_value!" /file:"emvoy.ini"
	)
:: Delete 
:: Write Profile List to Boot @ end	
call :CreateSelectionList emvoy.ini _dpsProfName Boots\BootProfiles.ini
call :CleanIni emvoy.ini
call :CleanIni Boots\BootProfiles.ini
:: ---------------

 :WAEmBootSettsEnd
echo End Boot Profile Edit. 
set _tmpBoot=
set wafile=
set waoutput=
set waoutno=
goto :WAEmBootSettsHome
:: -----------------------------------------------------
:: END WAEmBootEdit
:: -------------------------------------------------------
:: -----------------------------------------------------
:: Boot Settings Functions
:: -------------------------------------------------------
 :WAEmBootCompileReport
echo on
:: Saves Summary of proposed settings to text file
set _tmprep=^>^>%temp%\EmTempSettRep.txt
::set _log1=^>^> Logs/emvoy.log
break>%temp%\EmTempSettRep.txt
echo Boot Profile Settings %_tmprep%
echo.%_tmprep%
echo Profile: {%_tempBootSel%} %_tmpBoot_dpsProfName% %_tmprep%
echo Description:	%_tmprep%
echo %_tmpBoot_dpsProfDesc% %_tmprep%
echo.%_tmprep%
echo Directories:%_tmprep%
echo Qlaunch:	%_tmpBoot_dpsQLaunchDir% %_tmprep%
echo PakkIso:	%_tmpBoot_dpsPakkISOdir% %_tmprep%
echo DTools:	%_tmpBoot_dpsDTexe% %_tmprep%
echo 7Zip:	%_tmpBoot_dpsZipDir% %_tmprep%
echo Games:	%_tmpBoot_dpsRomDir% %_tmprep%
echo.%_tmprep%
echo Selections:%_tmprep%
echo Emulator:		%_tmpBoot_dpsEmuWaoutputReport% %_tmprep%
echo Quicklaunch:	%_tmpBoot_dpsQLaunch% %_tmprep%
echo Support Apps:	%_tmpBoot_dpsAppWaoutputReport% %_tmprep%
echo. %_tmprep%
echo Switches:%_tmprep%
echo [%_tmpBoot_chk[0]%]: Quit EmVoy when the Game or Emluator closes%_tmprep%
echo [%_tmpBoot_chk[1]%]: Skip this admin menu - controls via command line%_tmprep%
echo [%_tmpBoot_chk[2]%]: Show update messages to user (no click required)%_tmprep%
echo [%_tmpBoot_chk[3]%]: Prompt admin/user input for various functions%_tmprep%
echo [%_tmpBoot_chk[4]%]: Show command line window%_tmprep%
echo [%_tmpBoot_chk[5]%]: Create Log%_tmprep%
echo [%_tmpBoot_chk[6]%]: Create Log History%_tmprep%
echo [%_tmpBoot_chk[7]%]: Skip the UnZip part of the Emvoy process%_tmprep%
echo [%_tmpBoot_chk[8]%]: Skip the UnECM part of the Emvoy process%_tmprep%
echo [%_tmpBoot_chk[9]%]: Skip making Quicklaunch Folder%_tmprep%
echo.%_tmprep%
echo Profile Updated: %date% %time% %_tmprep%
goto :eof 

:: ====================================================================
:: END of WABootSettings
:: ====================================================================

:: ====================================================================
::  														SETTINGS : EMULATORS
:: ====================================================================
:WAEmEmuSettsHome
:: ====================================================================
call :WAClearVarsPage
set wafile=
set wabmp=Assets\page\EmuSetts.bmp

set watext=Summary of current Default Emulator Profile:~

Set wainput= Create a new Emulator Profile; Edit an exisitng Emulator Pofile; Copy an Emulator Profile; Delete an Emulator Profile
set waoutnum=1
set wabat=%TEMP%\wabat.bat
set wasig=Home^>Settings^>Emu
start /w wizapp RB
if errorlevel 2 goto :WAHome
if errorlevel 1 goto :WAEmDefaultsHome
call %wabat%
  if "%waoutnum%"=="0" (
		echo Going to New Emulator Profile Wizard
		goto :WAEmEmuNew
	)
  if "%waoutnum%"=="1" (
		echo Going to Edit Emulator Profile wizard
		goto :WAEmEmuEditSetup
	)
  if "%waoutnum%"=="2" (
		echo Going to Copy Emulator Profile wizard. 
		goto :WAEmEmuCopy
	)
  if "%waoutnum%"=="3" (
		echo Going to Delete Emulator Profile wizard. 
		goto :WAEmEmuDel
	)

goto :WAEmEmuSettsHome

:: ----------------------- NEW PROFILE ----------------------------
 :WAEmEmuNew
 echo Creating new Emulator profile
call :_FreeRecordNo Emulators\emulators.ini
set _tmpEmu_NewRec=%_FreeRecordNo%
call :WAClearVarsPage
set wasig=Home^>Settings^>Emu^>Create New
set wafile=
set watext=~~~Create a new Emulator Profile?~~New Profile will be listed as Profile number: %_FreeRecordNo% 
set wabat=%TEMP%\wabat.bat
set walabels=No;Yes
start /w wizapp NOCANCEL TB 
if errorlevel 1 goto :WAEmEmuSettsHome
call %wabat%
call :CopyRecord Emulators\emulators.ini 0 _emuName replace "New Profile {%_tmpEmu_NewRec%}"
call :CreateSelectionList Emulators\emulators.ini _emuName Emulators\EmulatorList.ini
set _tempEmuSel=%_FreeRecordNo%
goto :WAEmEmuEditSetup2

:: ----------------------- COPY PROFILE ----------------------------
 :WAEmEmuCopy
echo Copy Emulator Profile
call :WAClearVarsPage
call :WAEmSel "Which Emulator profile would you like to copy from?" Assets\page\EmuEdit.bmp Emulators\EmulatorList.ini _tempEmuSel :WAEmEmuSettsHome :WAEmEmuSettsHome
call :_FreeRecordNo Emulators\emulators.ini
set _tmpEmu_NewRec=%_FreeRecordNo%
call :IniCmd /m read /f Emulators\emulators.ini /s %_tempEmuSel% /k _emuName
set _tmpEmu_CopyName=%IniCmd%
set _tmpEmu_ProfFilename={%_tempEmuSel%} %IniCmd%.txt
echo %_tmpEmu_ProfFilename%
set wasig=Home^>Settings^>Emu^>Copy Prof
set wafile=Emulators\%_tmpEmu_ProfFilename%
set watext=~~~Copy Profile %_tempEmuSel% to a new Emulator Profile numbered %_tmpEmu_NewRec%?~~^
Profile %_tempEmuSel% details:~

set wabat=%TEMP%\wabat.bat
set walabels=No;Yes
start /w wizapp NOCANCEL FT
if errorlevel 1 goto :WAEmEmuSettsHome
call %wabat%
call :CopyRecord Emulators\emulators.ini  %_tempEmuSel% _emuName prefix "Copy of "
call :CreateSelectionList Emulators\emulators.ini  _emuName Emulators\EmulatorList.ini
::pause
echo on
copy "%EmvoyPath%\Emulators\{%_tempEmuSel%} %_tmpEmu_CopyName%.txt" "%EmvoyPath%\Emulators\{%_tmpEmu_NewRec%} Copy of %_tmpEmu_CopyName%.txt"
:: [Ini] [IniKey] [ListFile]
set _tempEmuSel=%_FreeRecordNo%
goto :WAEmEmuEditSetup2

:: ----------------------- DELETE PROFILE ----------------------------
 :WAEmEmuDel
:: delete record 
:: delete boots file 
:: Update BootProfiles.ini 
echo Delete Boot record
call :WAClearVarsPage
call :WAEmSel "Which Emulator profile would you like to delete?" Assets\page\EmuDel.bmp Emulators\EmulatorList.ini _tempEmuSel :WAEmEmuSettsHome :WAEmEmuSettsHome
call :IniCmd /m read /f Emulators\emulators.ini /s %_tempEmuSel% /k _emuName 
set _tmpEmu_ProfFilename={%_tempEmuSel%} %IniCmd%.txt

set wabmp=Assets\page\EmuDel.bmp
set wasig=Home^>Settings^>Emu^>Delete Prof
set wafile=Emulators\%_tmpEmu_ProfFilename%

set watext=Delete Profile. Are you sure you want to delete the Emulator Profile below?~~^
Emulator Profile: %_tmpEmu_ProfFilename%~~^
(N.B. If this is a copy of another profile which wasn't subsequently edited, the ^
profile name below will be that of the original profile).

set wabat=%TEMP%\wabat.bat
set walabels=No;Yes
start /w wizapp NOCANCEL FT
if errorlevel 1 goto :WAEmEmuSettsHome
call %wabat%
call :DeleteRecord Emulators\emulators.ini "%_tempEmuSel%" Emulators\EmulatorList.ini _emuName
:: cscript //nologo "%~f0?.wsf" //job:IniCommand /cmd:DeleteSection /section:"%_tempBootSel%" /file:"emvoy.ini"
del "%EmvoyPath%\Emulators\%_tmpEmu_ProfFilename%"
::call :CreateSelectionList emvoy.ini _dpsProfName Boots\BootProfiles.ini 
goto :WAEmEmuSettsHome 

:: -----------------------------------------------------------------------------------
:: ----------------------- EDIT PROFILE ------------------------------------------
:: -----------------------------------------------------------------------------------
 :WAEmEmuEditSetup
:: Setup
call :WAClearVarsPage
echo ---------------- Starting Edit Emu Profile  -------------------------
call :WAEmSel "Which profile would you like to Edit?" Assets\page\EmuEdit.bmp Emulators\EmulatorList.ini _tempEmuSel :WAEmEmuSettsHome :WAEmEmuSettsHome
echo * Emu Profile Selected: %_tempEmuSel%
 :WAEmEmuEditSetup2
:: Line up temp variables:
set _tmpEmu=
call :LoadTempIni %_tempEmuSel% Emulators\emulators.ini _tmpEmu
set wabmp=Assets\page\EmuEdit.bmp
set _tmpEmu_OrigProfName=%_tmpEmu_emuName%

 :WAEmEmuEdit1
 :: Profile Name
call :WAClearVarsPage
set watext=Editing Profile: [%_tempEmuSel%] %_tmpEmu_OrigProfName% ~~Choose a name for this profile:
set wabat=%TEMP%\wabat.bat
set waoutput=%_tmpEmu_emuName%
set wasig=Home^>Settings^>Emu^>Edit
start /w wizapp EB PLAIN
if errorlevel 2 goto :WAEmEmuSettsEnd
if errorlevel 1 goto :WAEmEmuEditSetup
call %wabat%
set waoutput=%waoutput:"=%
call :CleanVar "%waoutput%" 
echo User Input: [%waoutput%]
echo Cleaned version: [%CleanVar%]
if not "%CleanVar%" == "%waoutput%" (
		echo Input string and 'clean' version do not match 
		set WAErrorText=The text entered contains invalid charaters.~Your entry has been changed, removing these.~Please review and ammend as neccessary. 
		call :WAError
		set _tmpEmu_emuName=!CleanVar!
		echo Error sent and cleaned input placed back in input box. 
		goto :WAEmEmuEdit1
	)
:: remove any trailing spaces:
for /l %%a in (1,1,10) do if "!waoutput:~-1!"==" " set waoutput=!waoutput:~0,-1!
set _tmpEmu_emuName=%waoutput%
echo * Temp name set: [%_tmpEmu_emuName%]

 :WAEmEmuEdit2
 :: Emu Version
call :WAClearVarsPage
set watext=Editing Profile: [%_tempEmuSel%] %_tmpEmu_OrigProfName% ~~Version number of this Emu:
set wabat=%TEMP%\wabat.bat
set waoutput=%_tmpEmu_emuVers%
start /w wizapp EB PLAIN
if errorlevel 2 goto :WAEmEmuSettsEnd
if errorlevel 1 goto :WAEmEmuEdit1
call %wabat%
set waoutput=%waoutput:"=%
call :CleanVar "%waoutput%" 
echo User Input: [%waoutput%]
echo Cleaned version: [%CleanVar%]
if not "%CleanVar%" == "%waoutput%" (
		echo Input string and 'clean' version do not match 
		set WAErrorText=The text entered contains invalid charaters.~Your entry has been changed, removing these.~Please review and ammend as neccessary. 
		call :WAError
		set _tmpEmu_emuVers=!CleanVar!
		echo Error sent and cleaned input placed back in input box. 
		goto :WAEmEmuEdit2
	)
:: remove any trailing spaces:
for /l %%a in (1,1,10) do if "!waoutput:~-1!"==" " set waoutput=!waoutput:~0,-1!
set _tmpEmu_emuVers=%waoutput%
echo * Temp name set: [%_tmpEmu_emuName%]

 :WAEmEmuEdit3
:: Profile Description (Notes)
call :WAClearVarsPage
set wafile=
set watext=Editing Profile: [%_tempEmuSel%] %_tmpEmu_OrigProfName% ~Emulator notes at present:~%_tmpEmu_emuNotes:~0,200%.......~~ Please enter any notes for this Emulator:
set wabat=%TEMP%\wabat.bat
set waoutput=%_tmpEmu_emuNotes%
start /w wizapp EB

if errorlevel 2 goto :WAEmEmuSettsEnd
if errorlevel 1 goto :WAEmEmuEdit2
call %wabat%
set waoutput=%waoutput:"=%
set _tmpEmu_emuNotes=%waoutput%
set watext=Your description appears below. If you are happy with it, press next to continue. Otherwise press back to edit.~~%waoutput%
start /w wizapp TB
if errorlevel 2 goto :WAEmEmuSettsEnd
if errorlevel 1 goto :WAEmEmuEdit3
echo Emulator Notes updated..


 :WAEmEmuEdit4
:: Emulator Exe
call :WAClearVarsPage
set watext=Editing Profile: [%_tempEmuSel%] %_tmpEmu_OrigProfName%~~Choose the Emulator .exe:
set wabat=%TEMP%\wabat.bat
set waoutput=%_tmpEmu_emuExe%
set wainput=Exe files (*.exe);*.exe;All files (*.*);*.*
start /w wizapp FB FILE
if errorlevel 2 goto :WAEmEmuSettsEnd
if errorlevel 1 goto :WAEmEmuEdit3
call %wabat%
set _tmpEmu_emuExe=%waoutput%
if not exist "%_tmpEmu_emuExe%" (
		set WAErrorText=That is an invalid file path or name!~Folder or file does not exist.~Please re-select or re-enter.  
		call :WAError
		goto :WAEmEmuEdit4
		)
echo Emulator Filepath and exe good! [%_tmpEmu_emuExe%]



 :WAEmEmuEdit5
:: Emu command line switches
call :WAClearVarsPage
set watext=Editing Profile: [%_tempEmuSel%] %_tmpEmu_OrigProfName% ~^
Please enter any additional command line switches to use when launching Emulator:~~^
(N.B. If cmd line switches set in an individual game profile, these ones are ignored)~^
(Also, please be careful around which characters you use, as this text isn't checked for special characters)

set wabat=%TEMP%\wabat.bat
set waoutput=%_tmpEmu_emuCmd%
start /w wizapp EB PLAIN
if errorlevel 2 goto :WAEmEmuSettsEnd
if errorlevel 1 goto :WAEmEmuEdit4
call %wabat%
set waoutput=%waoutput:"=%
:: remove any trailing spaces:
for /l %%a in (1,1,10) do if "!waoutput:~-1!"==" " set waoutput=!waoutput:~0,-1!
set _tmpEmu_emuCmd=%waoutput%
echo * Temp emuCmd set: [%_tmpEmu_emuCmd%]

 :WAEmEmuEdit6
:: Use DT?
call :WAClearVarsPage
set watext=Editing Profile: [%_tempEmuSel%] %_tmpEmu_OrigProfName%~~^
Use Daemon Tools to mount image?
set wabat=%TEMP%\wabat.bat
if "%_tmpEmu_emuDTuse%" == "true" (
		set waoutnum=0
	) else (
		set waoutnum=1
	)
set wainput=Yes;No
start /w wizapp RB
if errorlevel 2 goto :WAEmEmuSettsEnd
if errorlevel 1 goto :WAEmEmuEdit5
call %wabat%
if "%waoutnum%" == "0" set _tmpEmu_emuDTuse=true
if "%waoutnum%" == "1" set _tmpEmu_emuDTuse=false
Echo Use DTools with Emulator: [%_tmpEmu_emuDTuse%]


 :WAEmEmuEdit7
:: Choose Virtual Drive
call :WAClearVarsPage
set watext=Editing Profile: [%_tempEmuSel%] %_tmpEmu_OrigProfName%~~^
Choose the Virtual Drive to use with Daemon Tools~^
(Have DT up and running, mount an image in the virtual drive, then choose drive):
set wabat=%TEMP%\wabat.bat
set waoutput=%_tmpEmu_emuVdrive%
start /w wizapp FB DIR
if errorlevel 2 goto :WAEmEmuSettsEnd
if errorlevel 1 goto :WAEmEmuEdit6
call %wabat%
set _tmpEmu_emuVdrive=%waoutput%
if not exist "%_tmpEmu_emuVdrive%" (
		set WAErrorText=That is an invalid file path!~Drive does not exist.~Please re-select or re-enter.  
		call :WAError
		goto :WAEmEmuEdit7
		)
echo DT Drive good!	"%_tmpEmu_emuVdrive%"

 :WAEmEmuEdit8
:: Extensions to mount
call :WAClearVarsPage
set watext=Editing Profile: [%_tempEmuSel%] %_tmpEmu_OrigProfName% ~~^
Choose the priority in which to mount images in DaemonTools. Higher priority to the right.^
 See documentation for further info. Please be careful entering the extentions - should be in the format ext,ext,ext. ^
 E.g. ^"mdf,ccd,cue^"
set wabat=%TEMP%\wabat.bat
set waoutput=%_tmpEmu_emuExts%
start /w wizapp EB PLAIN
if errorlevel 2 goto :WAEmEmuSettsEnd
if errorlevel 1 goto  :WAEmEmuEdit7
call %wabat%
set waoutput=%waoutput:"=%
REM call :CleanVar "%waoutput%" 
set waoutput=%waoutput: =%
echo User Input: [%waoutput%]
echo Cleaned version: [%CleanVar%]
REM if not "%CleanVar%" == "%waoutput%" (
		REM echo Input string and 'clean' version do not match 
		REM set WAErrorText=The text entered contains invalid charaters.~Your entry has been changed, removing these.~Please review and ammend as neccessary. 
		REM call :WAError
		REM set _tmpEmu_emuName=!CleanVar!
		REM echo Error sent and cleaned input placed back in input box. 
		REM goto :WAEmEmuEdit8
	REM )
:: TODO: RegEx Validate
:: remove any trailing spaces:
for /l %%a in (1,1,10) do if "!waoutput:~-1!"==" " set waoutput=!waoutput:~0,-1!
set _tmpEmu_emuExts=%waoutput%
echo * Extention mounting order: [%_tmpEmu_emuExts%]

 :WAEmEmuEdit9
:: Use Settings Script?
call :WAClearVarsPage
set watext=Editing Profile: [%_tempEmuSel%] %_tmpEmu_OrigProfName%~~^
Use a Settings Script to save Emulator settings on a per-game basis?
set wabat=%TEMP%\wabat.bat
if "%_tmpEmu_emuUseSettsScirpt%" == "true" (
		set waoutnum=0
	) else (
		set waoutnum=1
	)
set wainput=Yes;No
start /w wizapp RB
if errorlevel 2 goto :WAEmEmuSettsEnd
if errorlevel 1 goto :WAEmEmuEdit8
call %wabat%
if "%waoutnum%" == "0" set _tmpEmu_emuUseSettsScirpt=true
if "%waoutnum%" == "1" set _tmpEmu_emuUseSettsScirpt=false
Echo Use Settings Script: [%_tmpEmu_emuUseSettsScirpt%]


 :WAEmEmuEdit10
:: Settings Script Location
call :WAClearVarsPage
set watext=Editing Profile: [%_tempEmuSel%] %_tmpEmu_OrigProfName%~~Choose the Settings Script executable:
set wabat=%TEMP%\wabat.bat
set waoutput=%_tmpEmu_emuSettsScirptExe%
set wainput=Exe files (*.exe);*.exe;All files (*.*);*.*
start /w wizapp FB FILE
if errorlevel 2 goto :WAEmEmuSettsEnd
if errorlevel 1 goto :WAEmEmuEdit9
call %wabat%
set _tmpEmu_emuSettsScirptExe=%waoutput%
if not exist "%_tmpEmu_emuSettsScirptExe%" (
		set WAErrorText=That is an invalid file path or name!~Folder or file does not exist.~Please re-select or re-enter.  
		call :WAError
		goto :WAEmEmuEdit10
		)
echo Emulator Filepath and exe good! [%_tmpEmu_emuSettsScirptExe%]


 :WAEmEmuEdit11
:: Support Apps
call :WAClearVarsPage
set watext=Editing Profile: [%_tempEmuSel%] %_tmpEmu_OrigProfName%~~^
Without change below, on save: %_tmpEmu_emuAlsoLaunch%~^
Please select the support Apps you wish to run alongside your emulator when the game boots.^
These defaults can be further modified by individual Games Profiles. CTRL+CLICK = Multi-Select

set wabat=%TEMP%\wabat.bat
set wafile=Support\SupportAppsList.ini
if defined _tmpEmu_emuAppWaoutput (
		set waoutnum=%_tmpEmu_emuAppWaoutput%
	) else (
		set waoutnum=0
	)

start /w wizapp LB MULTIPLE
if errorlevel 2 goto :WAEmEmuSettsEnd
if errorlevel 1 (
		set wafile=
		goto :WAEmEmuEdit10
	)
call %wabat%
if "%waoutnum%" == "" (
		echo No support apps selected
		set _tmpEmu_emuAlsoLaunch=
		set _tmpEmu_emuAppWaoutputReport=
		set _tmpEmu_emuAppWaoutput=
		goto :WAEmEmuStartSave
	)
echo * User Selected: %waoutput%
echo * User Selected^(op numbers^) : %waoutnum%
set _tmpEmu_emuAppWaoutput=%waoutnum%
call :GetNumberString "%waoutput%"
echo Returned value: %GetNumberString%
set _tmpEmu_emuAlsoLaunch=%GetNumberString%
set _tmpEmu_emuAppWaoutputReport=%waoutput%
echo set temp _emuAlsoLaunch to: [%_tmpEmu_emuAlsoLaunch%]

 :WAEmEmuStartSave
:: Make report for final signoff
call :WAEmEmuCompileReport
:: -------------------------------

 :WAEmEmuEdit12
:: Review settings
set watext=Editing Profile: [%_tempEmuSel%] %_tmpEmu_OrigProfName%~~^
Review proposed changes. Select 'Back' to make further changes, ^
or 'Save' to save settings and return to the Boot settings Menu.~~^
Copy and paste if textbox not big enough. 
set walabels=;Save
set wabat=%TEMP%\wabat.bat
set wafile=%temp%\EmTempSettRep.txt
start /w wizapp FT
set walabels=
if errorlevel 2 goto :WAEmEmuSettsEnd
if errorlevel 1 goto :WAEmEmuEdit11
call %wabat%
echo duff var: %_tmpEmu_emuAlsoLaunch%
set _tmpEmu_emu

 :WAEmEmuEditEnd
echo Finishing Edit process 
:: Move temp list to perm
copy %temp%\EmTempSettRep.txt "%EmvoyPath%\Emulators\{%_tempEmuSel%} %_tmpEmu_emuName%.txt"
del %temp%\EmTempSettRep.txt

:: If profile name changed - delete old list 
if not "%_tmpEmu_emuName%" == "%_tmpEmu_OrigProfName%" (
		del "%EmvoyPath%\Emulators\{%_tempEmuSel%} %_tmpEmu_OrigProfName%.txt"
	)

:: unset two variables used in report only:
set _tmpEmu_emuAppWaoutputReport=

echo Writing new settings to ini file.
::Set date+time of update:
set _tmpEmu_emuUpdate=%date% %time%
::Backup emvoy.ini - safety first!
copy /y Emulators\emulators.ini Backups\emulators.ini
:: Write relevant value to ini
set _tmpEmu_emu
:: Wipe Section:
cscript //nologo "%~f0?.wsf" //job:IniCommand /cmd:DeleteSection /section:"%_tempEmuSel%" /file:"Emulators\emulators.ini"
:: Re-write section with new vars:
for /f "delims=" %%a in ('set _tmpEmu_emu') do (
		set _tmpEmu_IniWrite=%%a
		set _tmpEmu_IniWrite=!_tmpEmu_IniWrite:~7!
		echo Splitting: [!_tmpEmu_IniWrite!]
		for /f "tokens=1,2 delims==" %%b in ("!_tmpEmu_IniWrite!") do (
				set _tmpEmu_key=%%b
				set _tmpEmu_value=%%c
			)
		echo key: [!_tmpEmu_key!]
		echo value: [!_tmpEmu_value!]
		cscript //nologo "%~f0?.wsf" //job:IniCommand /cmd:WriteEntry /section:"!_tempEmuSel!" /key:"!_tmpEmu_key!" /value:"!_tmpEmu_value!" /file:"Emulators\emulators.ini"
	)
:: Delete 
:: Write Profile List to Boot @ end	

call :CreateSelectionList Emulators\emulators.ini _emuName Emulators\EmulatorList.ini

call :CleanIni Emulators\emulators.ini

call :CleanIni Emulators\EmulatorList.ini
:: ---------------

 :WAEmEmuSettsEnd
echo End Emulator Settings Edit. 

if %_tempEmuSel% == %_gameEmu% call :LoadIni %_tempEmuSel% Emulators\emulators.ini
set _tmpEmu=
set wafile=
set waoutput=
set waoutno=
goto :WAEmEmuSettsHome


:: -----------------------------------------------------
:: END WAEmEmuEdit
:: -------------------------------------------------------
:: -----------------------------------------------------
:: Emu Settings Functions
:: -------------------------------------------------------
 :WAEmEmuCompileReport
echo on
:: Saves Summary of proposed settings to text file
set _tmprep=^>^>%temp%\EmTempSettRep.txt
::set _log1=^>^> Logs/emvoy.log
break>%temp%\EmTempSettRep.txt
echo Emulator Profile Settings %_tmprep%
echo.%_tmprep%
echo Profile: {%_tempEmuSel%} %_tmpEmu_emuName% %_tmprep%
echo Notes:	%_tmprep%
echo %_tmpEmu_emuNotes% %_tmprep%
echo.%_tmprep%
echo Emulator:%_tmprep%
echo Exe used:	%_tmpEmu_emuExe% %_tmprep%
echo Cmd add:	%_tmpEmu_emuCmd% %_tmprep%
echo.%_tmprep%
echo DaemonTools: %_tmprep%
echo Use?	%_tmpEmu_emuDTuse% %_tmprep%
echo Drive:	%_tmpEmu_emuVdrive% %_tmprep%
echo Ext Order: %_tmpEmu_emuExts% %_tmprep%
echo.%_tmprep%
echo Settings Script: %_tmprep%
echo Use?	%_tmpEmu_emuUseSettsScirpt% %_tmprep%
echo Script:	%_tmpEmu_emuSettsScirptExe% %_tmprep%
echo.%_tmprep%
echo Support Apps: %_tmpEmu_emuAppWaoutputReport% %_tmprep%
echo.%_tmprep%
echo Profile Updated: %date% %time% %_tmprep%
goto :eof 

:: ====================================================================
:: END of WAEmuSettings
:: ====================================================================



:: ====================================================================
::  														SETTINGS : SUPPORT APPS
:: ====================================================================
:WAEmSuppSettsHome
:: ====================================================================
call :WAClearVarsPage
set wafile=
set wabmp=Assets\page\SuppSetts.bmp

set watext=Summary of current Support App Profiles:~

Set wainput= Create a new Support App Profile; Edit an exisitng Support App Pofile; Copy a Support App Profile; Delete a Support App Profile
set waoutnum=1
set wabat=%TEMP%\wabat.bat
set wasig=Home^>Settings^>Apps
start /w wizapp RB
if errorlevel 2 goto :WAHome
if errorlevel 1 goto :WAEmDefaultsHome
call %wabat%
  if "%waoutnum%"=="0" (
		echo Going to New Support App Profile Wizard
		goto :WAEmSuppNew
	)
  if "%waoutnum%"=="1" (
		echo Going to Edit Support App Profile wizard
		goto :WAEmSuppEditSetup
	)
  if "%waoutnum%"=="2" (
		echo Going to Copy Support App Profile wizard. 
		goto :WAEmSuppCopy
	)
  if "%waoutnum%"=="3" (
		echo Going to Delete Support App Profile wizard. 
		goto :WAEmSuppDel
	)

goto :WAEmSuppSettsHome 

:: ----------------------- NEW PROFILE ----------------------------
 :WAEmSuppNew
 echo Creating new Support App profile
call :_FreeRecordNo Support\support.ini
set _tmpSupp_NewRec=%_FreeRecordNo%
call :WAClearVarsPage
set wasig=Home^>Settings^>Apps^>Create New
set wafile=
set watext=~~~Create a new Support App Profile?~~New Profile will be listed as Profile number: %_FreeRecordNo% 
set wabat=%TEMP%\wabat.bat
set walabels=No;Yes
start /w wizapp NOCANCEL TB 
if errorlevel 1 goto :WAEmSuppSettsHome
call %wabat%
call :CopyRecord Support\support.ini 0 _supName replace "New Profile {%_tmpSupp_NewRec%}"
call :CreateSelectionList Support\support.ini _supName Support\SupportAppsList.ini
set _tempSuppSel=%_FreeRecordNo%
goto :WAEmSuppEditSetup2

:: ----------------------- COPY PROFILE ----------------------------
 :WAEmSuppCopy
echo Copy Support App Profile
call :WAClearVarsPage
call :WAEmSel "Which Support App profile would you like to copy from?" Assets\page\SuppEdit.bmp Support\SupportAppsList.ini _tempSuppSel :WAEmSuppSettsHome :WAEmSuppSettsHome
call :_FreeRecordNo Support\support.ini
set _tmpSupp_NewRec=%_FreeRecordNo%
call :IniCmd /m read /f Support\support.ini /s %_tempSuppSel% /k _supName
set _tmpSupp_CopyName=%IniCmd%
set _tmpSupp_ProfFilename={%_tempSuppSel%} %IniCmd%.txt
echo %_tmpSupp_ProfFilename%
set wasig=Home^>Settings^>Apps^>Copy Prof
set wafile=Support\%_tmpSupp_ProfFilename%
set watext=~~~Copy Profile %_tempSuppSel% to a new Support App Profile numbered %_tmpSupp_NewRec%?~~^
Profile %_tempSuppSel% details:~

set wabat=%TEMP%\wabat.bat
set walabels=No;Yes
start /w wizapp NOCANCEL FT
if errorlevel 1 goto :WAEmSuppSettsHome
call %wabat%
call :CopyRecord Support\support.ini  %_tempSuppSel% _supName prefix "Copy of "
call :CreateSelectionList Support\support.ini  _supName Support\SupportAppsList.ini
::pause
echo on
copy "%EmvoyPath%\Support\{%_tempSuppSel%} %_tmpSupp_CopyName%.txt" "%EmvoyPath%\Support\{%_tmpSupp_NewRec%} Copy of %_tmpSupp_CopyName%.txt"
:: [Ini] [IniKey] [ListFile]
set _tempSuppSel=%_FreeRecordNo%
goto :WAEmSuppEditSetup2

:: ----------------------- DELETE PROFILE ----------------------------
 :WAEmSuppDel
:: delete record 
:: delete boots file 
:: Update BootProfiles.ini 
echo Delete Support App record
call :WAClearVarsPage
call :WAEmSel "Which Support App profile would you like to delete?" Assets\page\SuppDel.bmp Support\SupportAppsList.ini _tempSuppSel :WAEmSuppSettsHome :WAEmSuppSettsHome
call :IniCmd /m read /f Support\support.ini /s %_tempSuppSel% /k _supName 
set _tmpSupp_ProfFilename={%_tempSuppSel%} %IniCmd%.txt

set wabmp=Assets\page\SuppDel.bmp
set wasig=Home^>Settings^>Apps^>Delete Prof
set wafile=Support\%_tmpSupp_ProfFilename%

set watext=Delete Profile. Are you sure you want to delete the Support App Profile below?~~^
Emulator Profile: %_tmpSupp_ProfFilename%~~^
(N.B. If this is a copy of another profile which wasn't subsequently edited, the ^
profile name below may be that of the original profile).

set wabat=%TEMP%\wabat.bat
set walabels=No;Yes
start /w wizapp NOCANCEL FT
if errorlevel 1 goto :WAEmSuppSettsHome
call %wabat%
call :DeleteRecord Support\support.ini "%_tempSuppSel%" Support\SupportAppsList.ini _supName
del "%EmvoyPath%\Support\%_tmpSupp_ProfFilename%"
goto :WAEmSuppSettsHome 

:: -----------------------------------------------------------------------------------
:: ----------------------- EDIT PROFILE ------------------------------------------
:: -----------------------------------------------------------------------------------
 :WAEmSuppEditSetup
:: Setup
call :WAClearVarsPage
echo ---------------- Starting Edit Supp Apps Profile  -------------------------
call :WAEmSel "Which profile would you like to Edit?" Assets\page\SuppEdit.bmp Support\SupportAppsList.ini _tempSuppSel :WAEmSuppSettsHome :WAEmSuppSettsHome
echo * Emu Profile Selected: %_tempSuppSel%
 :WAEmSuppEditSetup2
:: Line up temp variables:
set _tmpSupp=
call :LoadTempIni %_tempSuppSel% Support\support.ini _tmpSupp
set wabmp=Assets\page\SuppEdit.bmp
set _tmpSupp_OrigProfName=%_tmpSupp_supName%

 :WAEmSuppEdit1
 :: Profile Name
call :WAClearVarsPage
set watext=Editing Profile: [%_tempSuppSel%] %_tmpSupp_OrigProfName% ~~Choose a name for this profile:
set wabat=%TEMP%\wabat.bat
set waoutput=%_tmpSupp_supName%
set wasig=Home^>Settings^>Apps^>Edit
start /w wizapp EB PLAIN
if errorlevel 2 goto :WAEmSuppSettsEnd
if errorlevel 1 goto :WAEmSuppEditSetup
call %wabat%
set waoutput=%waoutput:"=%
call :CleanVar "%waoutput%" 
echo User Input: [%waoutput%]
echo Cleaned version: [%CleanVar%]
if not "%CleanVar%" == "%waoutput%" (
		echo Input string and 'clean' version do not match 
		set WAErrorText=The text entered contains invalid charaters.~Your entry has been changed, removing these.~Please review and ammend as neccessary. 
		call :WAError
		set _tmpSupp_supName=!CleanVar!
		echo Error sent and cleaned input placed back in input box. 
		goto :WAEmSuppEdit1
	)
:: remove any trailing spaces:
for /l %%a in (1,1,10) do if "!waoutput:~-1!"==" " set waoutput=!waoutput:~0,-1!
set _tmpSupp_supName=%waoutput%
echo * Temp name set: [%_tmpSupp_supName%]

 :WAEmSuppEdit2
 :: Supp App Version
call :WAClearVarsPage
set watext=Editing Profile: [%_tempSuppSel%] %_tmpSupp_OrigProfName% ~~Version number of this Support App:
set wabat=%TEMP%\wabat.bat
set waoutput=%_tmpSupp_supVers%
start /w wizapp EB PLAIN
if errorlevel 2 goto :WAEmSuppSettsEnd
if errorlevel 1 goto :WAEmSuppEdit1
call %wabat%
set waoutput=%waoutput:"=%
call :CleanVar "%waoutput%" 
echo User Input: [%waoutput%]
echo Cleaned version: [%CleanVar%]
if not "%CleanVar%" == "%waoutput%" (
		echo Input string and 'clean' version do not match 
		set WAErrorText=The text entered contains invalid charaters.~Your entry has been changed, removing these.~Please review and ammend as neccessary. 
		call :WAError
		set _tmpSupp_supVers=!CleanVar!
		echo Error sent and cleaned input placed back in input box. 
		goto :WAEmSuppEdit2
	)
:: remove any trailing spaces:
for /l %%a in (1,1,10) do if "!waoutput:~-1!"==" " set waoutput=!waoutput:~0,-1!
set _tmpSupp_supVers=%waoutput%
echo * Temp Vers set: [%_tmpSupp_supVers%]

 :WAEmSuppEdit3
:: Profile Description (Notes)
call :WAClearVarsPage
set wafile=
set watext=Editing Profile: [%_tempSuppSel%] %_tmpSupp_OrigProfName% ~Support App notes at present:~%_tmpSupp_supDesc:~0,200%.......~~ Please enter any notes for this Support App:
set wabat=%TEMP%\wabat.bat
set waoutput=%_tmpSupp_supDesc%
start /w wizapp EB

if errorlevel 2 goto :WAEmSuppSettsEnd
if errorlevel 1 goto :WAEmSuppEdit2
call %wabat%
set waoutput=%waoutput:"=%
set _tmpSupp_supDesc=%waoutput%
set watext=Your description appears below. If you are happy with it, press next to continue. Otherwise press back to edit.~~%waoutput%
start /w wizapp TB
if errorlevel 2 goto :WAEmSuppSettsEnd
if errorlevel 1 goto :WAEmSuppEdit3
echo Support App Notes updated..

 :WAEmSuppEdit4
:: Support App Exe
call :WAClearVarsPage
set watext=Editing Profile: [%_tempSuppSel%] %_tmpSupp_OrigProfName%~~Choose the Support App .exe:
set wabat=%TEMP%\wabat.bat
set waoutput=%_tmpSupp_supExe%
set wainput=Exe files (*.exe);*.exe;All files (*.*);*.*
start /w wizapp FB FILE
if errorlevel 2 goto :WAEmSuppSettsEnd
if errorlevel 1 goto :WAEmSuppEdit3
call %wabat%
set _tmpSupp_supExe=%waoutput%
if not exist "%_tmpSupp_supExe%" (
		set WAErrorText=That is an invalid file path or name!~Folder or file does not exist.~Please re-select or re-enter.  
		call :WAError
		goto :WAEmSuppEdit4
		)
echo Support App Filepath and exe good! [%_tmpSupp_emuExe%]



 :WAEmSuppEdit5
:: Emu command line switches
call :WAClearVarsPage
set watext=Editing Profile: [%_tempSuppSel%] %_tmpSupp_OrigProfName% ~^
Please enter any additional command line switches to use when launching Support App:~~^
(N.B. Please be careful around which characters you use, as this text isn't checked for special characters)

set wabat=%TEMP%\wabat.bat
set waoutput=%_tmpSupp_supCmd%
start /w wizapp EB PLAIN
if errorlevel 2 goto :WAEmSuppSettsEnd
if errorlevel 1 goto :WAEmSuppEdit4
call %wabat%
set waoutput=%waoutput:"=^"%
:: remove any trailing spaces:
for /l %%a in (1,1,10) do if "!waoutput:~-1!"==" " set waoutput=!waoutput:~0,-1!
set _tmpSupp_supCmd=%waoutput%
echo * Temp emuCmd set: [%_tmpSupp_supCmd%]

 :WAEmSuppEdit6
:: Quit Support App with Game?
call :WAClearVarsPage
set watext=Editing Profile: [%_tempSuppSel%] %_tmpSupp_OrigProfName%~~^
Quit the Support App when Game/Emulator is quit?
set wabat=%TEMP%\wabat.bat
if "%_tmpSupp_supQwithGame%" == "true" (
		set waoutnum=0
	) else (
		set waoutnum=1
	)
set wainput=Yes;No
start /w wizapp RB
if errorlevel 2 goto :WAEmSuppSettsEnd
if errorlevel 1 goto :WAEmSuppEdit5
call %wabat%
if "%waoutnum%" == "0" set _tmpSupp_supQwithGame=true
if "%waoutnum%" == "1" set _tmpSupp_supQwithGame=false
Echo Quit App with Game: [%_tmpSupp_supQwithGame%]

:: Make report for final signoff
call :WAEmSuppCompileReport
:: -------------------------------

 :WAEmSuppEdit12
:: Review settings
set watext=Editing Profile: [%_tempSuppSel%] %_tmpSupp_OrigProfName%~~^
Review proposed changes. Select 'Back' to make further changes, ^
or 'Save' to save settings and return to the Boot settings Menu.~~^
Copy and paste if textbox not big enough. 
set walabels=;Save
set wabat=%TEMP%\wabat.bat
set wafile=%temp%\EmTempSettRep.txt
start /w wizapp FT
set walabels=
if errorlevel 2 goto :WAEmSuppSettsEnd
if errorlevel 1 goto :WAEmSuppEdit6
call %wabat%
set _tmpSupp_sup

 :WAEmSuppEditEnd
echo Finishing Edit process 
:: Move temp list to perm
copy %temp%\EmTempSettRep.txt "%EmvoyPath%\Support\{%_tempSuppSel%} %_tmpSupp_supName%.txt"
del %temp%\EmTempSettRep.txt

:: If profile name changed - delete old list 
if not "%_tmpSupp_supName%" == "%_tmpSupp_OrigProfName%" (
		del "%EmvoyPath%\Support\{%_tempSuppSel%} %_tmpSupp_OrigProfName%.txt"
	)

echo Writing new settings to ini file.
::Set date+time of update:
set _tmpSupp_supUpdate=%date% %time%
::Backup emvoy.ini - safety first!
copy /y Support\support.ini Backups\support.ini
:: Write relevant value to ini
set _tmpSupp_sup
:: Wipe Section:
cscript //nologo "%~f0?.wsf" //job:IniCommand /cmd:DeleteSection /section:"%_tempSuppSel%" /file:"Support\support.ini"
:: Re-write section with new vars:
for /f "delims=" %%a in ('set _tmpSupp_sup') do (
		set _tmpSupp_IniWrite=%%a
		set _tmpSupp_IniWrite=!_tmpSupp_IniWrite:~8!
		echo Splitting: [!_tmpSupp_IniWrite!]
		for /f "tokens=1,2 delims==" %%b in ("!_tmpSupp_IniWrite!") do (
				set _tmpSupp_key=%%b
				set _tmpSupp_value=%%c
			)
		echo key: [!_tmpSupp_key!]
		echo value: [!_tmpSupp_value!]
		cscript //nologo "%~f0?.wsf" //job:IniCommand /cmd:WriteEntry /section:"!_tempSuppSel!" /key:"!_tmpSupp_key!" /value:"!_tmpSupp_value!" /file:"Support\support.ini"
	)
:: Delete 
:: Write Profile List to Boot @ end	

call :CreateSelectionList Support\support.ini _supName Support\SupportAppsList.ini
call :CleanIni Support\support.ini
call :CleanIni Support\SupportAppsList.ini
:: ---------------

 :WAEmSuppSettsEnd
echo End Emulator Settings Edit. 
set _tmpSupp=
set wafile=
set waoutput=
set waoutno=
goto :WAEmSuppSettsHome
:: -----------------------------------------------------
:: END WAEmEmuEdit
:: -------------------------------------------------------
:: -----------------------------------------------------
:: Emu Settings Functions
:: -------------------------------------------------------
 :WAEmSuppCompileReport
echo on
:: Saves Summary of proposed settings to text file
set _tmprep=^>^>%temp%\EmTempSettRep.txt
::set _log1=^>^> Logs/emvoy.log
break>%temp%\EmTempSettRep.txt
echo Support App Profile Settings %_tmprep%
echo.%_tmprep%
echo Profile: {%_tempSuppSel%} %_tmpSupp_supName% %_tmprep%
echo Vers: 	%_tmpSupp_supVers% 
echo Notes:	%_tmprep%
echo %_tmpSupp_supDesc% %_tmprep%
echo.%_tmprep%
echo Support App:%_tmprep%
echo Exe used:	%_tmpSupp_supExe% %_tmprep%
echo Cmd add:	%_tmpSupp_supCmd% %_tmprep%
echo.%_tmprep%
echo Quit with Game?	%_tmpSupp_supQwithGame% %_tmprep%
echo.%_tmprep%
echo Profile Updated: %date% %time% %_tmprep%
goto :eof 

:: ====================================================================
:: END of WASupport Settings
:: ====================================================================


:: ====================================================================
::  														SETTINGS : GAME PROFILES
:: ====================================================================
:WAEmGamePSettsHome
:: ====================================================================
call :WAClearVarsPage
set _tmpGameP=
set wafile=
set wabmp=Assets\page\Games.bmp

set watext=Summary of current Game Profile:~^
Name:	%_gameName%~^
Key:	%_gameKey%~^
Emu:	%_gameEmu%.%_emuName%~^
Cmd:	%_gameEmuCmd%~^
[QLaunch: %_gameQlaunch%] [Use DT? - %_gameDTuse%]~^
Apps:	%_gameAlsoLaunch%
Set wainput= Change Current Game Profile; Edit Current Game Profile; Make a New Game Profile; Delete a Game Profile
set waoutnum=0
set wabat=%TEMP%\wabat.bat
set wasig=Home^>Game Profiles
start /w wizapp RB
if errorlevel 2 goto :WAHome
if errorlevel 1 goto :WAHome
call %wabat%
  if "%waoutnum%"=="0" (
		echo Going to Change Current Game Profile wizard
		set _tempSuppSel=%_admGameProfile%
		goto :WAGamePSelG
	)
  if "%waoutnum%"=="1" (
		echo Going to Edit Current Game Profile wizard
		goto  :WAEmGamePEditSetup
	)
  if "%waoutnum%"=="2" (
		echo Going to Copy Support App Profile wizard. 
		goto :WAEmSuppCopy
	)
  if "%waoutnum%"=="3" (
		echo Going to Delete Support App Profile wizard. 
		goto :WAEmSuppDel
	)
  if "%waoutnum%"=="4" (
		echo Going to Delete Support App Profile wizard. 
		goto :WAEmSuppDel
	)

goto :WAHome


:: ====================================================================
::  																GAME PROFILE SELECT
:: ====================================================================
:WAGamePSelG 
call :WAClearVarsPage
set wabmp=Assets\page\GameEdit.bmp
call :WAEmSel "Which Game Profile would you like to use?~~" Assets\page\Games.bmp Games\GamePList.ini _admGameProfile :WAEmGamePSettsHome :WAEmGamePSettsHome
echo New Game Profile Selected: %_admGameProfile%
call :LoadIni %_admGameProfile% Games\games.ini
call :LoadIni %_gameEmu% Emulators\emulators.ini
echo Loaded Game Profile and corresponding Emulator. 
goto :WAEmGamePSettsHome
:: ------- DO NOT EDIT 


:: -----------------------------------------------------------------------------------
:: ----------------------- EDIT GAME PROFILE -------------------------------------
:: -----------------------------------------------------------------------------------
 :WAEmGamePEditSetup
:: Setup
set wabmp=Assets\page\GameEdit.bmp
call :WAClearVarsPage
set wasig=Home^>Game Profiles>Edit
::call :WAEmSel "Which Game Profile would you like to Edit?~~" Assets\page\Games.bmp Games\GamePList.ini _tempSuppSel :WAEmGamePSettsHome :WAEmGamePSettsHome
call :LoadIni %_tempSuppSel% Games\games.ini
call :LoadIni %_gameEmu% Emulators\emulators.ini
::echo * Game Profile Selected: %_tempSuppSel%
  
 :WAEmGamePEditSetup2
:: Line up temp variables:
set wasig=Home^>Game Profiles>Edit
call :LoadTempIni %_tempSuppSel% Games\games.ini _tmpGameP
set wabmp=Assets\page\GameEdit.bmp
set _tmpGameP_OrigProfName=%_tmpGameP_gameKey%
set _tmpGameP_OrigProfEmu=%_tmpGameP_gameEmu%
set _tmpGameP_OrigProfAlsoLaunch=%_tmpGameP_gameAlsoLaunch%


 :WAEmGamePEdit1
 :: Profile Name
call :WAClearVarsPage
set watext=Editing Profile: [%_tempSuppSel%] %_tmpGameP_OrigProfName% ~~Choose a name for this Game Profile:
set wabat=%TEMP%\wabat.bat
set waoutput=%_tmpGameP_gameName%
set wasig=Home^>Game Profiles>Edit
start /w wizapp EB PLAIN
if errorlevel 2 goto :WAEmGamePSettsEnd
if errorlevel 1 goto :WAEmGamePSettsHome
call %wabat%
set waoutput=%waoutput:"=%
call :CleanVar "%waoutput%" 
echo User Input: [%waoutput%]
echo Cleaned version: [%CleanVar%]
if not "%CleanVar%" == "%waoutput%" (
		echo Input string and 'clean' version do not match 
		set WAErrorText=The text entered contains invalid charaters.~Your entry has been changed, removing these.~Please review and ammend as neccessary. 
		call :WAError
		set _tmpGameP_gameName=!CleanVar!
		echo Error sent and cleaned input placed back in input box. 
		goto :WAEmGamePEdit1
	)
:: remove any trailing spaces:
for /l %%a in (1,1,10) do if "!waoutput:~-1!"==" " set waoutput=!waoutput:~0,-1!
set _tmpGameP_gameName=%waoutput%
echo * Temp name set: [%_tmpGameP_gameName%]


 :WAEmGamePEdit2
:: Emulator
call :WAClearVarsPage
set watext=Editing Profile: [%_tempSuppSel%] %_tmpGameP_OrigProfName%~~^
Emulator used by this Profile presently: %_tmpGameP_OrigProfEmu%~~^
 ~~Choose which Emulator to use with this File:
set wabat=%TEMP%\wabat.bat
set wafile=Emulators\EmulatorList.ini
set waoutnum=%_emuwaoutnum%
start /w wizapp LB SINGLE
if errorlevel 2 goto :WAEmGamePSettsEnd
if errorlevel 1 (
		set wafile=
		goto  :WAEmGamePEdit1
	)
call %wabat%
echo * User Selected: %waoutput%
set _emuwaoutnum=%waoutnum%
for /f "tokens=1 delims=:" %%A in ("%waoutput%") do set _tempSel=%%A
set _tmpGameP_gameEmu=%_tempSel: =%
echo * Temp Emu set: [%_tmpGameP_gameEmu%]


 :WAEmGamePEdit3
:: Emulator CMD
call :WAClearVarsPage
set watext=Editing Profile: [%_tempSuppSel%] %_tmpGameP_OrigProfName%~^
Please enter any additional command line switches to use when launching Emulator:~~^
(N.B. If set, over-rides those set in Emulator Profile)~^
(Also, please be careful around which characters you use, as this text isn't checked for special characters)

set wabat=%TEMP%\wabat.bat
set waoutput=%_tmpGameP_gameEmuCmd%
start /w wizapp EB PLAIN
if errorlevel 2 goto :WAEmGamePSettsEnd
if errorlevel 1 goto :WAEmGamePEdit2
call %wabat%
set waoutput=%waoutput:"=%
:: remove any trailing spaces:
for /l %%a in (1,1,10) do if "!waoutput:~-1!"==" " set waoutput=!waoutput:~0,-1!
set _tmpGameP_gameEmuCmd=%waoutput%
echo * Temp emuCmd set: [%_tmpGameP_gameEmuCmd%]


 :WAEmGamePEdit4
:: Use DT?
call :WAClearVarsPage
set watext=Editing Profile: [%_tempSuppSel%] %_tmpGameP_OrigProfName% ~~^
Use Daemon Tools to mount image?
set wabat=%TEMP%\wabat.bat
if "%_tmpGameP_gameDTuse%" == "true" (
		set waoutnum=0
	) else (
		set waoutnum=1
	)
set wainput=Yes;No
start /w wizapp RB
if errorlevel 2 goto :WAEmGamePSettsEnd
if errorlevel 1 goto  :WAEmGamePEdit3
call %wabat%
if "%waoutnum%" == "0" set _tmpGameP_gameDTuse=true
if "%waoutnum%" == "1" set _tmpGameP_gameDTuse=false
Echo Use DTools with this Game Profile: [%_tmpGameP_gameDTuse%]

 :WAEmGamePEdit5
:: Quicklaunch setting
call :WAClearVarsPage
set watext=Editing Profile: [%_tempSuppSel%] %_tmpGameP_OrigProfName% ~~^
Quicklaunch folder setting for this game?
set wabat=%TEMP%\wabat.bat
if "%_tmpGameP_gameQLaunch%" == "keep" (
		set waoutnum=0
	) 
if "%_tmpGameP_gameQLaunch%" == "ask" (
		set waoutnum=1
	) 
if "%_tmpGameP_gameQLaunch%" == "delete" (
		set waoutnum=2
	) 
set wainput=Keep; Ask; Delete
start /w wizapp RB
if errorlevel 2 goto :WAEmGamePSettsEnd
if errorlevel 1 goto :WAEmGamePEdit4
call %wabat%
if "%waoutnum%" == "0" set _tmpGameP_gameQLaunch=keep
if "%waoutnum%" == "1" set _tmpGameP_gameQLaunch=ask
if "%waoutnum%" == "2" set _tmpGameP_gameQLaunch=delete
set _tmpBoot_dpsQlaunchWaoutput=%waoutnum%
Echo Quicklaunch folder setting: [%_tmpGameP_gameQLaunch%]

 :WAEmGamePEdit6
:: Support Apps
call :WAClearVarsPage
call :IniCmd /m read /f Emulators\emulators.ini /s "%_tmpGameP_gameEmu%" /k _emuAlsoLaunch
set watext=Editing Profile: [%_tempSuppSel%] %_tmpGameP_OrigProfName% ~~^
Select support Apps. CTRL+CLICK = Multi-Select~^
Default Apps of chosen emulator [%_tmpGameP_gameEmu%]: %IniCmd%~^
Game Profile as stands: %_tmpGameP_OrigProfAlsoLaunch%~^
Apps chosen below will superceed and replace those in the Emulator and Boot Profile. If none chosen will boot with Emulator and Boot defaults.
set wabat=%TEMP%\wabat.bat
set wafile=Support\SupportAppsList.ini
set waoutnum=%_tmpGameP_gamesAppWaoutnum% (
start /w wizapp LB MULTIPLE
if errorlevel 2 goto :WAEmGamePSettsEnd
if errorlevel 1 (
		set wafile=
		goto :WAEmGamePEdit5
	)
call %wabat%
if "%waoutnum%" == "" (
		echo No support apps selected
		set _tmpGameP_gameAlsoLaunch=
		set _tmpGameP_gamesAppWaoutnum=
		goto :WAEmGamesPEdit7
	)
echo * User Selected: %waoutput%
echo * User Selected^(op numbers^) : %waoutnum%
call :GetNumberString "%waoutput%"
echo Returned value: %GetNumberString%
set _tmpGameP_gameAlsoLaunch=%GetNumberString%
set _tmpGameP_gamesAppWaoutnum=%waoutnum%
echo Supports Apps to run: [%_tmpGameP_gameAlsoLaunch%]


 :WAEmGamesPEdit7
:: Verify change of settings
:: Set other relevant variables
call :IniCmd /m read /f Emulators\emulators.ini /s %_tmpGameP_gameEmu% /k _emuName
call :CleanVar "%_tmpGameP_gameFile%"
set _tmpGameP_gameKey=%CleanVar% {%_tmpGameP_gameEmu%-%IniCmd%}
set _tmpGameP_gameListName=%_tmpGameP_gameName% {%_tmpGameP_gameEmu%-%IniCmd%}
set _tmpGameP_gameUpdate=%date% %time%
:: Make report for final signoff
call :WAEmGamePCompileReport
:: -------------------------------

 :WAEmGamePEdit8
:: Review settings
set watext=Editing Profile: [%_tempSuppSel%] %_tmpGameP_OrigProfName%~~^
Review proposed changes. Select 'Back' to make further changes, ^
or 'Save' to save settings and return to the Game Profiles Menu.~~^
Copy and paste if textbox not big enough. 
set walabels=;Save
set wabat=%TEMP%\wabat.bat
set wafile=%temp%\EmTempSettRep.txt
start /w wizapp FT
set walabels=
if errorlevel 2 goto :WAEmGamePSettsEnd
if errorlevel 1 goto :WAEmGamePEdit6
call %wabat%


 :WAEmGamePEditEnd
echo Finishing Edit process 
:: Move temp list to perm
copy %temp%\EmTempSettRep.txt "%EmvoyPath%\Games\{%_tempSuppSel%} %_tmpGameP_gameKey%.txt"
del %temp%\EmTempSettRep.txt
:: unset any irrelevant vars
set _tmpGameP_gamesAppWaoutnum=
set _tmpGameP_OrigProfAlsoLaunch=
set _tmpGameP_OrigProfEmu=
set _tmpGameP_OrigProfName=


echo Writing new settings to ini file.
::Set date+time of update:
::Backup emvoy.ini - safety first!
copy /y Games\games.ini Backups\games.ini
:: Write relevant value to ini
:: Wipe Section:
cscript //nologo "%~f0?.wsf" //job:IniCommand /cmd:DeleteSection /section:"%_tempSuppSel%" /file:"Games\games.ini"
:: Re-write section with new vars:
for /f "delims=" %%a in ('set _tmpGameP_') do (
		set _tmpGameP_IniWrite=%%a
		set _tmpGameP_IniWrite=!_tmpGameP_IniWrite:~9!
		echo Splitting: [!_tmpGameP_IniWrite!]
		for /f "tokens=1,2 delims==" %%b in ("!_tmpGameP_IniWrite!") do (
				set _tmpGameP_key=%%b
				set _tmpGameP_value=%%c
			)
		echo key: [!_tmpGameP_key!]
		echo value: [!_tmpGameP_value!]
		cscript //nologo "%~f0?.wsf" //job:IniCommand /cmd:WriteEntry /section:"!_tempSuppSel!" /key:"!_tmpGameP_key!" /value:"!_tmpGameP_value!" /file:"Games\games.ini"
	)
:: Delete 
:: Write Profile List to Boot @ end	

call :CreateSelectionList Games\games.ini _gameListName Games\GamePList.ini
call :CleanIni Games\games.ini
call :CleanIni Games\GamePList.ini
:: ---------------

 :WAEmGamePSettsEnd
echo End Emulator Settings Edit. 
if "%_tempSuppSel%" == "%_admGameProfile%" (
		call :LoadIni %_tempSuppSel% Games\games.ini
		call :LoadIni %_gameEmu% Emulators\emulators.ini
	)
set _tmpGameP=
set wafile=
set waoutput=
set waoutno=
goto :WAEmGamePSettsHome









:: -----------------------------------------------------
:: END WAEmEmuEdit
:: -------------------------------------------------------





:: ----------------------- NEW PROFILE ----------------------------
 :WAEmSuppNew
 echo Creating new Support App profile
call :_FreeRecordNo Games\games.ini
set _tmpGameP_NewRec=%_FreeRecordNo%
call :WAClearVarsPage
set wasig=Home^>Settings^>Apps^>Create New
set wafile=
set watext=~~~Create a new Support App Profile?~~New Profile will be listed as Profile number: %_FreeRecordNo% 
set wabat=%TEMP%\wabat.bat
set walabels=No;Yes
start /w wizapp NOCANCEL TB 
if errorlevel 1 goto :WAEmSuppSettsHome
call %wabat%
call :CopyRecord Games\games.ini 0 _supName replace "New Profile {%_tmpGameP_NewRec%}"
call :CreateSelectionList Games\games.ini _supName Support\SupportAppsList.ini
set _tempSuppSel=%_FreeRecordNo%
goto :WAEmSuppEditSetup2

:: ----------------------- COPY PROFILE ----------------------------
 :WAEmSuppCopy
echo Copy Support App Profile
call :WAClearVarsPage
call :WAEmSel "Which Support App profile would you like to copy from?" Assets\page\SuppEdit.bmp Support\SupportAppsList.ini _tempSuppSel :WAEmSuppSettsHome :WAEmSuppSettsHome
call :_FreeRecordNo Games\games.ini
set _tmpGameP_NewRec=%_FreeRecordNo%
call :IniCmd /m read /f Games\games.ini /s %_tempSuppSel% /k _supName
set _tmpGameP_CopyName=%IniCmd%
set _tmpGameP_ProfFilename={%_tempSuppSel%} %IniCmd%.txt
echo %_tmpGameP_ProfFilename%
set wasig=Home^>Settings^>Apps^>Copy Prof
set wafile=Support\%_tmpGameP_ProfFilename%
set watext=~~~Copy Profile %_tempSuppSel% to a new Support App Profile numbered %_tmpGameP_NewRec%?~~^
Profile %_tempSuppSel% details:~

set wabat=%TEMP%\wabat.bat
set walabels=No;Yes
start /w wizapp NOCANCEL FT
if errorlevel 1 goto :WAEmSuppSettsHome
call %wabat%
call :CopyRecord Games\games.ini  %_tempSuppSel% _supName prefix "Copy of "
call :CreateSelectionList Games\games.ini  _supName Support\SupportAppsList.ini
::pause
echo on
copy "%EmvoyPath%\Support\{%_tempSuppSel%} %_tmpGameP_CopyName%.txt" "%EmvoyPath%\Support\{%_tmpGameP_NewRec%} Copy of %_tmpGameP_CopyName%.txt"
:: [Ini] [IniKey] [ListFile]
set _tempSuppSel=%_FreeRecordNo%
goto :WAEmSuppEditSetup2

:: ----------------------- DELETE PROFILE ----------------------------
 :WAEmSuppDel
:: delete record 
:: delete boots file 
:: Update BootProfiles.ini 
echo Delete Support App record
call :WAClearVarsPage
call :WAEmSel "Which Support App profile would you like to delete?" Assets\page\SuppDel.bmp Support\SupportAppsList.ini _tempSuppSel :WAEmSuppSettsHome :WAEmSuppSettsHome
call :IniCmd /m read /f Games\games.ini /s %_tempSuppSel% /k _supName 
set _tmpGameP_ProfFilename={%_tempSuppSel%} %IniCmd%.txt

set wabmp=Assets\page\SuppDel.bmp
set wasig=Home^>Settings^>Apps^>Delete Prof
set wafile=Support\%_tmpGameP_ProfFilename%

set watext=Delete Profile. Are you sure you want to delete the Support App Profile below?~~^
Emulator Profile: %_tmpGameP_ProfFilename%~~^
(N.B. If this is a copy of another profile which wasn't subsequently edited, the ^
profile name below may be that of the original profile).

set wabat=%TEMP%\wabat.bat
set walabels=No;Yes
start /w wizapp NOCANCEL FT
if errorlevel 1 goto :WAEmSuppSettsHome
call %wabat%
call :DeleteRecord Games\games.ini "%_tempSuppSel%" Support\SupportAppsList.ini _supName
del "%EmvoyPath%\Support\%_tmpGameP_ProfFilename%"
goto :WAEmSuppSettsHome 


:: -----------------------------------------------------
:: Game Profile Functions
:: -------------------------------------------------------
:WAEmGamePCompileReport
echo on
:: Saves Summary of new Game Profile (used when made at startup from cmd)
set _tmprep=^>^>%temp%\EmTempSettRep.txt
::set _log1=^>^> Logs/emvoy.log
break>%temp%\EmTempSettRep.txt
echo Game Profile Settings %_tmprep%
echo.%_tmprep%
echo Profile No: {%_tempSuppSel%} %_tmprep%
echo Key Name: %_tmpGameP_gameKey% %_tmprep%
echo List Name: %_tmpGameP_gameListName% %_tmprep%
echo Short Name: %_tmpGameP_gameName% %_tmprep%
echo.%_tmprep%
echo File: %_tmprep%
echo Filename:%_tmpGameP_gameFile% %_tmprep%
echo Path:	%_tmpGameP_gamePath% %_tmprep%
echo.%_tmprep%
echo Emulator: %_tmprep%
echo Emu No:	%_tmpGameP_gameEmu% %_tmprep%
echo Name:	%IniCmd% %_tmprep%
echo Cmd: %_tmpGameP_gameEmuCmd% %_tmprep%
echo.%_tmprep%
echo Daemon Tools: %_tmprep%
echo Use?	%_tmpGameP_gameDTuse% %_tmprep%
echo.%_tmprep%
echo QLaunch:	%_tmpGameP_gameQlaunch% %_tmprep%
echo Mem cards:	%_tmpGameP_gameMemCards% %_tmprep%
echo.%_tmprep%
echo Support Apps: %_tmpGameP_gameAlsoLaunch% %_tmprep%
echo.%_tmprep%
echo Profile Updated: %_tmpGameP_gameUpdate% %_tmprep%
:: copy %temp%\EmTempSettRep.txt "%EmvoyPath%\Games\{%_admGameProfile%} %_gameKey%.txt"
::del %temp%\EmTempSettRep.txt
goto :eof
:: ====================================================================
:: END of WA Game Profiles
:: ====================================================================



:: --------------------------------------------------------------------------------
:: GAME LAUNCH MENU
:: --------------------------------------------------------------------------------
:WALaunchGame
%EmvoyPath:~0,2%
cd %EmvoyPath%









:: --------------------------------------------------------------------------------
:: EMULATOR SETUP MENU MENU CALL SCRIPTS
:: --------------------------------------------------------------------------------

REM :WABootNewProfile
REM :: Just sets section variable to last profile number + 1 
REM :: Populates temp variables from Default Profile
REM :: Then goes to Edit Boot Profile 
REM call :IniCmd /m countx /f Emulators\emulators 

:: ======================================================
:WAMenuFunctions
:: ======================================================

 :WAError 
Echo Wizapp error box called
set watext=%WAErrorText%~~Returning...
start /w wizapp MB EXCLAMATION
::goto %WAErrorRet%
echo OK Pressed!
goto :eof

:: ====================================================================
 :WAEmSel [message] [bmp] [ListFile] [VarToSet] [OnBack] [OnCancel]
:: 1 - message to display
:: 2 - relative path and file of bitmap to display 
:: 3 - relative path and file of listfile to use
:: 4 - the name of the variable to set
:: eg. 
:: call :WAEmSel "Which profile would you like to Edit?" Assets\page\BootEdit.bmp Docs\Lists\BootProfiles.txt emvoy.ini _dpsProfName _tempBSel
:: ====================================================================
set _onback=%~5
set _oncancel=%~6
if not defined _onback set _onback=:eof
if not defined _oncancel set _oncancel=:eof
set wabmp=%~2
set watext=%~1
Set wafile=%~3
set waoutput=
set wabat=%TEMP%\wabat.bat
start /w wizapp LB SINGLE
if errorlevel 2 goto %_oncancel%
if errorlevel 1 goto %_onback%
call %wabat%
echo * User Selected: %waoutput%
call :GetNumberString "%waoutput%"
set %~4=%GetNumberString%
echo * Return Select: [%_tempSel%]
::goto :WAEmSuppEditSel
goto :eof
:: ====================================================================



:: ======================================================
:: /END OF ADMIN_MENU
:: ======================================================




:: =============================================================
:SCRIPT_FUNCTIONS
:: =============================================================
:BATCHSUBS

:CreateGPReportCmd 
echo on
:: Saves Summary of new Game Profile (used when made at startup from cmd)
set _tmprep=^>^>%temp%\EmTempSettRep.txt
::set _log1=^>^> Logs/emvoy.log
break>%temp%\EmTempSettRep.txt
echo Game Profile Settings %_tmprep%
echo.%_tmprep%
echo Profile No: {%_admGameProfile%} %_tmpEmu_emuName% %_tmprep%
echo Key Name: %_gameKey% %_tmprep%
echo List Name: %_gameListName% %_tmprep%
echo Short Name: %_gameName% %_tmprep%
echo.%_tmprep%
echo File: %_tmprep%
echo Filename:%_gameFile% %_tmprep%
echo Path:	%_gamePath% %_tmprep%
echo.%_tmprep%
echo Emulator: %_tmprep%
echo Emu No:	%_gameEmu% %_tmprep%
echo Name:	%_emuName% %_tmprep%
echo Cmd: %_gameEmuCmd% %_tmprep%
echo.%_tmprep%
echo Daemon Tools: %_tmprep%
echo Use?	%_gameDTuse% %_tmprep%
echo.%_tmprep%
echo QLaunch:	%_gameQlaunch% %_tmprep%
echo Mem cards:	%_gameMemCards% %_tmprep%
echo.%_tmprep%
echo Support Apps: %_gameAlsoLaunch% %_tmprep%
echo.%_tmprep%
echo Profile Updated: %_gameUpdate% %_tmprep%
copy %temp%\EmTempSettRep.txt "%EmvoyPath%\Games\{%_admGameProfile%} %_gameKey%.txt"
del %temp%\EmTempSettRep.txt
goto :eof 


:DeleteRecord [ini] [section] [inilist] [trash] 
:: Required [ini] [section] - ini + section to be deleted
:: Optional: 	[inilist] - delete line from selection list based on section
:: 				[trash] - use a keyname within record set - creates trash file. 
:: e.g. call ::DeleteRecord Emulators\Emulators.ini 5 _emuName Emulators\EmulatorList.ini

echo 	{SUB: Delete Record}
if defined %~4 do (
		call :IniCmd /m read /s %~2 /k %~4 /f %~1 
		SET /A _random=%RANDOM% * 100 / 32768 + 1
		set _trashFile=%EmvoyPath%\Trash\{%~2-%IniCmd%}{%~n1}{!_random!}.ini
		echo Log of deleted record ^(deleted %date% %time%^): >!_trashFile!
		echo 	{		Trash File Selected: !_trashFile!
		echo 	{		Writing Values
		for /f "delims=" %%a in ('cscript //nologo "%~f0?.wsf" //job:IniCommand /cmd:ReadKeyValueLines /section:"%~2" /file:"%~1"') do (
			
				for /f "tokens=1,2 delims==" %%b in ("%%a") do (
						cscript //nologo "%~f0?.wsf" //job:IniCommand /cmd:WriteEntry /section:"%~2" /key:"%%b" /value:"%%c" /file:"%_trashFile%"
				)
		)
echo 	{		Done writing values.
)

echo 	{		Deleting record 
cscript //nologo "%~f0?.wsf" //job:IniCommand /cmd:DeleteSection /section:"%~2" /file:"%~1"
echo 	{		Deleted

set _inilist=%~3
if defined _inilist (
		echo 	{	Selection list passed. 
	) else (
		echo 	{	Selection list not passed. Setting to null.txt
		set _inilist=Null.txt
	)
if [%_inilist%] == [Null.txt] (
		echo 	{	Seleciton list not processed because none passed. 
	) else (
		echo {		IniList passed. Delete Record from selection list.
		type  %_inilist% | findstr /v "^%~2.*" > %_inilist%
		call :CleanIni %~3
	) 
goto :eof


:CopyRecord [ini] [section] [ckey] [cvaluetype] [cvalue]
:: Copies specified record to new record using lowest available section number as key
:: Able to modify one key/value pairing to reflect copy
:: [ini] - file
:: [section] section to copy
:: [ckey] key value to change in new copied record 
:: [cvaluetype] prefix,append or replace key value
:: [cvalue] value to use in change
echo 	{ SUB: Copy Record}
echo	{		Vars Passed: [%~1] [%~2] [%~3] [%~4] [%~5] 
:: Get lowest record index number
call :_FreeRecordNo %~1
:: Write new record
for /f "delims=" %%a in ('cscript //nologo "%~f0?.wsf" //job:IniCommand /cmd:ReadKeyValueLines /section:"%~2" /file:"%~1"') do (
		for /f "tokens=1,2 delims==" %%b in ("%%a") do (
				echo key: [%%b]
				echo value: [%%c]
				cscript //nologo "%~f0?.wsf" //job:IniCommand /cmd:WriteEntry /section:"!_FreeRecordNo!" /key:"%%b" /value:"%%c" /file:"%~1"
		)
)
:: Tidy up Ini file
call :CleanIni %~1
:: Modify specified key filed in new record 
call :IniCmd /m read /s %~2 /k %~3 /f %~1 
echo key value:%IniCmd%
set _newvalue=
if "%~4" == "prefix" set _newvalue=%~5%IniCmd%
if "%~4" == "append" set _newvalue=%IniCmd%%~5
if "%~4" == "replace" set _newvalue=%~5
if not defined _newvalue set _newvalue=Copied Record - no value change method specified. 
echo newvalue: %_newvalue%
::Write new value
cscript //nologo "%~f0?.wsf" //job:IniCommand /cmd:WriteEntry /section:"!_FreeRecordNo!" /key:"%~3" /value:"%_newvalue%" /file:"%~1"
echo 	{		Copied to new record number %_FreeRecordNo%
echo	{ END SUB: Copy Record}

goto :eof


:SetGroup
:: Pass [(partial)varname] [desired value]
:: e.g. SetGroup _emu default will set all vars beginning with "_emu" to "defualt"
for /f "tokens=1 delims== " %%A in ('set %1') do (
		echo 	{SUB SetGroup: Set all vars begining with xxx to value}
		echo 	{	returned variable set: %%A to [%2]
		set %%A="%2"
		echo		{END SUB}
	)
goto :eof

:CreateSelectionList [Ini] [IniKey] [ListFile]
:: Creates a list file, contents depending on parameters
:: 1 - IniFile to use 
:: 2 - Key for additional info to section name
:: 3 - relative path and file of listfile to create
call :IniCmd /m listtxt /f %~1 /k %~2 /t %~3
call :CleanIni %~3
goto :eof

:CreateGameROMList [filepath] [GamePList name]
cd Games\ROMLists
break>"%~2"
pause
set /a _count=0
for %%x in ("%~1\*") do (
		set /a _count+=1
		echo !_count!: %%~nxx>>"%~2"
	)
cd %EmvoyPath%

pause
goto :eof

:WAClearVarsPage
for /L %%G IN (2,1,12) do set "watext%%G="
set wafile=
set waoutnum=
set waoutput=
set wafile=
set wainput=
set walabels=Back;Next;Finish
goto :eof 

:CleanIni [file]
:: Removes:
::  - Blank lines and trailing spaces:
echo 	{SUB: Clean Ini}
echo		{Removing Blank lines
set "_tempFile=%temp%\%~nx0.%random%%random%%random%EmVoy_temp.txt"
For /F "tokens=* delims=" %%A in (%~1) Do (
		set _tmpLine=%%A 
		for /l %%b in (1,1,10) do (
				if "!_tmpLine:~-1!"==" " set _tmpLine=!_tmpLine:~0,-1!
			)
		Echo !_tmpLine!>>%_tempfile%
	)
:: Removes last carriage return:
set "firstLineReady="
(
    for /F "eol=$ delims=" %%a in (%_tempfile%) DO (
        if defined firstLineReady (echo()
        set "firstLineReady=1"
        <nul set /p "=%%a"
    )
) > %EmvoyPath%\%~1
::copy /y %_tempfile% %EmvoyPath%\%~1
::
del "%_tempFile%" >nul 2>nul
echo 	{ ** Blank lines removed from .ini **
echo 	{END SUB: Clean Ini}
goto :eof


:_FreeRecordNo [ini]
:: Returns the lowest available record number
:: Find Highest Section number, using 'list' function in inicmd (returns array + number of sections)
echo 	{SUB: Lowest record number}
set /a _highest=0
call :IniCmd /m list /f %~1>NUL
for /l %%a in (1,1,%IniCmd[0]%) do (
		REM echo.
		REM echo iteration: %%a
		REM echo Present highest: !_highest!
		REM echo inicmd[%%a]: !IniCmd[%%a]!
		set /a _inicmdno=!IniCmd[%%a]!
		REM echo inicmdno: !_inicmdno!
		if !_inicmdno! gtr !_highest! (
				set _highest=!_inicmdno!
			)
	)
Echo 	{Highest record: [%_highest%]
:: Check from 1 upwards in ini file with _highest iterations, snaffling first available number
set _FreeRecordNo=
echo Should be null: [%_FreeRecordNo%]
FOR /L %%b IN (1,1,%_highest%) DO (
		IF NOT DEFINED _FreeRecordNo (
				find "[%%b]" %~1>NUL
				IF ERRORLEVEL 1 (
						SET /a "_FreeRecordNo=%%b"
					)
			)
	)
echo Freerecno after record serach: [%_FreeRecordNo%]
:: if completes null, means no gaps in number sequence. Set to highest+1
if not defined _FreeRecordNo (
		set /a _FreeRecordNo=%_highest%+1
		echo Lowest is end of recordset plus one. 
	)
	
echo 	{**Lowest record number: [%_FreeRecordNo%]
echo	{END SUB: Lowest record number}
 goto :eof
	
:LoadIni [section] [file]
echo 	{SUB: Load Ini Section Vars}%_log1%
echo 	{	Loading Vars from Section: [%~1] %_log1%
set _tempDeQuoteStr=%~1
call :DeQuote _tempDeQuoteStr
for /f "delims=" %%A in ('cscript //nologo "%~f0?.wsf" //job:IniCommand /cmd:ReadKeyValueLines /section:"%_tempDeQuoteStr%" /file:"%~2"') do (
:: echo 	{	Setting: [%%A]
		set %%A
	)
::echo Variables set.%_log1%
echo 	{END SUB Load Ini Section Vars}%_log1%
echo.%_log1%
goto :eof

:LoadTempIni [section] [file] [prefix]
echo 	{SUB: Populate temp Vars from ini + specified section}%_log1%
echo 	{	Populating prefixed [%~3] temp vars from Section: [%~1] in file: [%~2]  %_log1%
set _tempDeQuoteStr=%~1
call :DeQuote _tempDeQuoteStr
for /f "delims=" %%A in ('cscript //nologo "%~f0?.wsf" //job:IniCommand /cmd:ReadKeyValueLines /section:"%_tempDeQuoteStr%" /file:"%~2"') do (
:: echo 	{	Setting: [%%A]
		echo %~3%%A
		set %~3%%A
	)
::echo Variables set.%_log1%
echo 	{END SUB Load Ini Section Vars}%_log1%
echo.%_log1%
goto :eof
	

	
:WriteIni [template] [section name] [file]
:: Writes to ini specified in file with default vars spec in template section - using new [section name]
echo 	{SUB: WriteIni
echo		{		Writing Profile using template [%~1] from [%~3] into new section [%~2] %_log1%
echo		{		Loading write template:
for /f "delims=" %%A in ('cscript //nologo "%~f0?.wsf" //job:IniCommand /cmd:ReadKeyValueLines /section:"%~1" /file:"%~3"') do (
		echo.
		echo 	{		Breaking down: [%%A]
		set _tempVarSetLine="%%A"
		echo 	{		tempVarSet: [!_tempVarSetLine!]
		for /f "tokens=1 delims==" %%B in (!_tempVarSetLine!) do (
				echo 	{		First part:[%%B]
				set _tempkey=%%B
			)
		for /f "tokens=2 delims==" %%C in (!_tempVarSetLine!) do (
				echo 	{		Second Part:[%%C]
				set _tempVarName=%%C
			)
		echo 	{		Writing Key
		echo 	{		TempKey:[!_tempkey!]
		echo 	{		TempVarName:[!_tempVarName!]
		call :IniCmd /m write /f %~3 /s "%~2" /k "!_tempkey!" /v "!_tempVarName!"				
	)
echo 	{		Variables written to ini.%_log1%
echo		{		Cleaning blank lines...
call :CleanIni Games\games.ini
echo 	{END SUB: WriteIni%_log1%}
echo.%_log1%
echo Pause
goto :eof		

:GetNumberString [string] 
:: Pass any mixed string, numbers will be extracted and separated by a comma
:: eg: "1: Fraps;99: Notepad"
:: produces: "1,99"
:: Ignores zero.
:: Returns string via GetNumberSting var
echo 	{SUB: GetNumberString}
set strline=%1
set GetNumberString=
call :parse %strline%
set GetNumberString=%GetNumberString:~0,-1%
echo 	{	Result: [%GetNumberString%]
echo 	{END SUB: GetNumberString}
goto :eof
:Parse
for /f "tokens=1* delims=;:" %%i in ("%~1") do (
    echo 	{	Token: [%%i]
	set /a _word=%%i
	echo 	{	Result from re-dim to number: !_word!
	if !_word! EQU 0 (
			echo 	{	This is not a number. Ignoring.
		)
	if not !_word! EQU 0 (
			echo 	{	This is a number. Added to final return string.
			set GetNumberString=!GetNumberString!!_word!,
		)
    call :Parse "%%j"
)

goto :eof

:DeQuote
echo 	{SUB DeQuote}
 SET DeQuote.Variable=%1
 CALL Set DeQuote.Contents=%%%DeQuote.Variable%%%
 Echo.%DeQuote.Contents%|FindStr/brv ""^">NUL:&&Goto :EOF
 Echo.%DeQuote.Contents%|FindStr/erv ""^">NUL:&&Goto :EOF
  Set DeQuote.Contents=####%DeQuote.Contents%####
 Set DeQuote.Contents=%DeQuote.Contents:####"=%
 Set DeQuote.Contents=%DeQuote.Contents:"####=%
 Set %DeQuote.Variable%=%DeQuote.Contents%
  Set DeQuote.Variable=
 Set DeQuote.Contents=
 echo 	{ENDSUB Dequote}
 Goto :EOF
 

:CleanVar
:: Uses WSF/VBS Script strClean
:: Ensure any passed string is in quotes. Just reference %CleanVar% from calling line. 
echo 	{SUB: CleanVar
echo 	{		Recivied variable = [%1]
set vars=#null#
set fullscript=cscript //nologo "%~f0?.wsf" //job:CleanString
set fullscript=%fullscript% %1
for /F "delims=" %%a in ('%fullscript%') do set vars=%%a
set CleanVar=%vars%
echo 	{		Cleaned variable is [%CleanVar%] - var called CleanVar
echo		{END SUB: CLeanVar}
goto :eof

 :: ---------------- Ini Functions ---------------------------------
 
:IniCmd mode item value section
 
 :: Pass m/ [mode] /s [section] /k [key] /v [value] /f [inifile] /t [output txt file] 
 :: [mode] MUST be passed
 :: Output = IniCmd (ImdCmd[x] for Arrays)
 :: modes: 
 :: write (/s)/k/v/f - writes value to key
 :: read- /s/k/v/f - returns value via IniCmd
 :: delsec - deletes a section - returns error code
 :: count - counts number of sections in a file - returns via [IniCmd]
 :: list - Arrays list of section into IniCmd. E.g. IniCmd[1]=apples, IniCmd[2]=pears. NB IniCmd[0] contains the count. 
 :: Call example: call :iniedit m/ write /s PSX /k "_EmuPath" /v "C:\Emulators and Frontends\Emvoy\Emulators" /f emulators.ini
 :: Use quotes around vars with spaces - no need to dequote
echo 	{SUB: IniCmd: Various ini file functions}%_log1%
Echo 	{		Parameters recieved: %* %_log1%
::echo off
set IniCmd=
set mode=
set value=
set section=
set inifile=
set key=
set txtout=
if "%~1" == "" echo 	{		*** No Vars passed! ***
for %%I in (key value section mode inifile) do set %%I=

for %%I in (%*) do (
    if defined next (
        if !next!==/k (
				set "key=%%~I"
				echo 	{		Key set:[!key!]
			)
        if !next!==/v (
				set "value=%%~I"
				echo 	{		Value set:[!value!]
			)
        if !next!==/m (
				set "mode=%%~I"
				echo 	{		Mode set:[!mode!]
			)
        if !next!==/s (
				set "section=%%~I"
				echo 	{		Section set:[!section!]
			)
		if !next!==/f (
				set "inifile=%%~I"
				echo 	{		File set:[!inifile!]
			)
		if !next!==/t (
				set "txtout=%%~I"
				echo 	{		Output Text File set:[!inifile!]
			)
        set next=
    ) else (
        for %%x in (/m /k /v /s /f /c /t) do if "%%~I"=="%%x" set "next=%%~I"
        if not defined next (
            set "arg=%%~I"
            if "!arg:~0,1!"=="/" (
                1>&2 echo 	{		*** Error: Unrecognized option: "%%~I" ***
                exit /b 1
            ) else set "inifile=%%~I"
        )
    )
)
if "%mode%" == "write" (
		echo 	{		Writing [%value%] to [%key%] in [%section%] in [%inifile%]
		cscript //nologo "%~f0?.wsf" //job:IniCommand /cmd:WriteEntry /section:"%section%" /key:"%key%" /value:"%value%" /file:"%inifile%"
		Echo 	{		Write value process finished.
		goto :EndIniCmd
	)

if "%mode%" == "read" (
		Echo 	{		Reading Value from Key in Section 
		set fullscript=cscript //nologo "%~f0?.wsf" //job:IniCommand
		set fullscript=!fullscript! /cmd:ReadValue /section:"%section%" /key:"%key%" /file:"%inifile%"
		for /F "delims=" %%a in ('!fullscript!') do set vars=%%a
		set IniCmd=!vars!
		echo 	{		Value read and placed into IniCmd for return: [!IniCmd!]
		goto :EndIniCmd
	)	
	
if "%mode%" == "count" (
		Echo 	{		Counting how many Sections in the ini file.
		set fullscript=cscript //nologo "%~f0?.wsf" //job:IniCommand
		set fullscript=!fullscript! /cmd:ReadSectionNames /section:"%section%"  /file:"%inifile%"
		set /A count=0
		for /F "delims=" %%a in ('!fullscript!') do (
				set /A count+=1
				echo 	{		Count:!count!
			)
		IF ERRORLEVEL 1 Echo Error in executing script. Emulators not counted. Check passed variables. 
		set IniCmd=!count!
		echo 	{		Count returned via IniCmd Var: [!count!]
		goto :EndIniCmd
	)

:: countx - Number of sections minus those beginning with X
if "%mode%" == "countx" (
		Echo 	{		Counting how many Sections in the ini file which don't start with 'X'
		set fullscript=cscript //nologo "%~f0?.wsf" //job:IniCommand
		set fullscript=!fullscript! /cmd:ReadSectionNames /section:"%section%"  /file:"%inifile%"
		set /A count=0
		for /F "delims=" %%a in ('!fullscript!') do (
				set _tmpstrng=%%a 
				echo temp string: [%_tmpstrng%]
				if not "!_tmpstrng:~0,1!" == "X" (
						set /A count+=1 )
				echo 	{		Count:!count!
			)
		IF ERRORLEVEL 1 Echo Error in executing script. Emulators not counted. Check passed variables. 
		set IniCmd=!count!
		echo 	{		Count returned via IniCmd Var: [!count!]
		goto :EndIniCmd
	)	

::		set fullscript=!fullscript! /cmd:ReadSectionNames /section:"%section%" /file:"%inifile%"	
if "%mode%" == "list" (
		Echo 	{		Producing List of Sections
		set fullscript=cscript //nologo "%~f0?.wsf" //job:IniCommand
		set fullscript=!fullscript! /cmd:ReadSectionNames /section:"%section%" /file:"%inifile%"
	
		set /A count=0
		for /F "delims=" %%a in ('!fullscript!') do (	
				set /A count+=1%
				::echo ppa: %%a
				set IniCmd[!count!]=%%a
			)
		set IniCmd[0]=!count!
		IF ERRORLEVEL 1 Echo Error in executing script. List not populated. Check passed variables.  
		echo 	{		Count placed in IniCmd[0]: !IniCmd[0]!
		echo 	{		Array:
		for /l %%n in (1,1,!count!) do (
				echo 	{		IniCmd[%%n]: !IniCmd[%%n]!
			)	
		goto :EndIniCmd
	)

::		Same as list but excludes Sections beginning with 'X'	
if "%mode%" == "listx" (
		Echo 	{		Producing List of Sections
		set fullscript=cscript //nologo "%~f0?.wsf" //job:IniCommand
		set fullscript=!fullscript! /cmd:ReadSectionNames /section:"%section%" /file:"%inifile%"
		set /A count=0
		for /F "delims=" %%a in ('!fullscript!') do (	
				set _tmpstrng=%%a
				echo temp string: [!_tmpstrng!]
				echo count: !count!
				if not "!_tmpstrng:~0,1!" == "X" (
						set /A count+=1 
					)
				set IniCmd[!count!]=%%a
			)
		set IniCmd[0]=!count!
		echo 	{		Count placed in IniCmd[0]: !IniCmd[0]!
		echo 	{		Array:
		for /l %%n in (1,1,!count!) do (
				echo 	{		IniCmd[%%n]: !IniCmd[%%n]!
			)	
		goto :EndIniCmd
	)	
	
::	Same as xlist but places value of specified key in array rather than section name
:: Also places section name in 1 of 2nd dimention of array
:: e.g. IniCmd[1] = Wipeout IniCmd[1,1] = 3
if "%mode%" == "listxk" (
		Echo 	{		Producing Array of Key Values in Sections
		set fullscript=cscript //nologo "%~f0?.wsf" //job:IniCommand
		set fullscript=!fullscript! /cmd:ReadSectionNames /file:"%inifile%"
		set /A count=0
		for /F "delims=" %%a in ('!fullscript!') do (
				REM echo.
				REM echo Start of Section Round
				set _tmpstrng=%%a
				REM echo temp string {section name} : [!_tmpstrng!]
				REM echo count: !count!
				if not "!_tmpstrng:~0,1!" == "X" (
						set /A count+=1 
						REM echo Count skipped due to X section
					)
				REM Echo 	{		Reading Value from Key in Section 
				REM echo First straight cs script 
				cscript //nologo "%~f0?.wsf" //job:IniCommand /cmd:ReadValue /section:"!_tmpstrng!" /key:"%key%"  /file:"%inifile%"
				REM echo now for approach...
				for /F "delims=" %%x in ('cscript //nologo "%~f0?.wsf" //job:IniCommand /cmd:ReadValue /section:"!_tmpstrng!" /key:"%key%"  /file:"%inifile%"') do set _keyvalue=%%x
				REM echo x: %%x
				REM echo key value: !_keyvalue!
				set IniCmd[!count!]=!_keyvalue!
				set IniCmd[!count!,1]=!_tmpstrng!
				REM echo Updating array: !IniCmd[!count!]!
			)
		set IniCmd[0]=!count!
		echo 	{		Count placed in IniCmd[0]: !IniCmd[0]!
		echo 	{		Array:
		for /l %%n in (1,1,!count!) do (
				echo 	{		IniCmd[%%n]: !IniCmd[%%n]!
			)	
		goto :EndIniCmd
	)	
	
::		Pulls list of non-X or zero records and prints specified key to specified file. Lines sorted low to high	
if "%mode%" == "listtxt" (
		Echo 	{		Producing txt file with [section] [key value]
		break>%TEMP%\templist.txt
		set fullscript=cscript //nologo "%~f0?.wsf" //job:IniCommand
		set fullscript=!fullscript! /cmd:ReadSectionNames /file:"%inifile%"
		set /A count=1
		for /F "delims=" %%a in ('!fullscript!') do (	
				set _tmpstrng=%%a
				REM echo temp string: [!_tmpstrng!]
				REM echo count: !count!
				if not "!_tmpstrng:~0,1!" == "X" (
						if not "!_tmpstrng:~0,1!" == "0" (
								set /A count+=1 
								set fullscript2=cscript //nologo "%~f0?.wsf" //job:IniCommand
								set fullscript2=!fullscript2! /cmd:ReadValue /section:"!_tmpstrng!" /key:"%key%" /file:"%inifile%"
								for /F "delims=" %%a in ('!fullscript2!') do set svalue=%%a
								echo !_tmpstrng!: !svalue!>> %TEMP%\templist.txt
							)
					)
					
				set IniCmd[!count!]=%%a
			)
		sort %TEMP%\templist.txt > %txtout%
		
		set IniCmd[0]=!count!
		echo 	{		Count placed in IniCmd[0]: !IniCmd[0]!
		echo 	{		Array:
		for /l %%n in (1,1,!count!) do (
				echo 	{		IniCmd[%%n]: !IniCmd[%%n]!
			)	

		goto :EndIniCmd
	)	
		
	
if "%mode%"== "delsec" (
		Echo 	{		Deleting Entire Section:
		cscript //nologo "%~f0?.wsf" //job:IniCommand /cmd:DeleteSection /section:"%section%" /file:"%inifile%"
		IF ERRORLEVEL 1 Echo Error in executing script. Section not deleted. Check passed variables. 
		set IniCmd=!errorlevel!
		echo 	{		Process completed. Errorlevel stored in IniCmd for return: [!IniCmd!]
		goto :EndIniCmd
	)	

 :EndIniCmd	
:: Clear up 10 20 trailing spaces:
::echo Return Variable: [%IniCmd%]
::echo Remove any trainling spaces....
for /l %%a in (1,1,5) do if "!IniCmd:~-1!"==" " set str=!IniCmd:~0,-1!
echo %_echo%
echo 	{		Final return variable:  [%IniCmd%] %_log1%
echo 	{ENDSUB IniCmd}%_log1%
goto :eof
:: ----------------------------- IniCmd END ---------------------------------------------------------------------



 
 
::============================================================================
:BATCH_VBS_SCRIPTS

:: TESTS =========================================================================

:FunctionTests

call :DeleteRecord Emulators\emulators.ini 99 _emuName Emulators\EmulatorList.ini
pause
pause
exit /b 





:: ==============================================================================

:MsgBox prompt type title
	echo --- SUB: MsgBox ---- %_log1%
	echo Passed params: %* %_log1%
    setlocal enableextensions
    set "tempFile=%temp%\%~nx0.%random%%random%%random%vbs.tmp"
    >"%tempFile%" echo(WScript.Quit msgBox("%~1",%~2,"%~3") & cscript //nologo //e:vbscript "%tempFile%"
    set "exitCode=%errorlevel%" & del "%tempFile%" >nul 2>nul
    endlocal & exit /b %exitCode%
	echo ---- END SUB ----%_log1%
	echo.%_log1%
goto :eof

:MsgBoxMsg Prompt Time Title Type
echo --- SUB: MsgBox ---- %_log1%
echo Passed params: %* %_log1%
setlocal enableextensions
echo set WshShell = WScript.CreateObject("WScript.Shell") > %tmp%\tmp.vbs
echo WScript.Quit (WshShell.Popup( "%~1" ,%~2 ,"%~3", %~4)) >> %tmp%\tmp.vbs
cscript //nologo %tmp%\tmp.vbs
if %errorlevel%==1 (
  echo You Clicked OK%_log1%
) else (
  echo The Message timed out.%_log1%
)
del %tmp%\tmp.vbs
echo ---- END SUB ----%_log1%
echo.%_log1%
goto :eof

:: ------------------------ WSF Script (JS and VB)--------------------------------
:WSF_SCRIPTS
:: Call scripts apu e.g. 
:: cscript //nologo "%~f0?.wsf" //job:CleanString "jkh:jkl@lkj&"


============================================================================
:: END OF BATCH FORMAT
WSF script ----------->
' BE CAREFUL FROM HERE - ONLY VB or JS Format!!!

<package>

' ------------------------------------------------------------------------------------------------------------------------------------
' CLEANSTRING - send param in quotes to avoid parsing errors due to symbols. Prints output to console. 
' ------------------------------------------------------------------------------------------------------------------------------------	
	<job id="CleanString">
		<script language="VBScript">
		
'Functions --------------------------
Function strClean (strtoclean)
Dim objRegExp, outputStr
Set objRegExp = New Regexp

objRegExp.IgnoreCase = True
objRegExp.Global = True
objRegExp.Pattern = "[(?)*,\\""<>&#~%{}+_.@:\/\[\]!;]+"
outputStr = objRegExp.Replace(strtoclean, " ")

objRegExp.Pattern = "\-+"
outputStr = objRegExp.Replace(outputStr, "-")

strClean = outputStr
End Function
' --------------------------------------

' Get passed vars
dim ArgObj, inpstring
Set fso = CreateObject("Scripting.FileSystemObject")
Set ArgObj = WScript.Arguments
inpstring = ArgObj(0)

' Process received string
dim outstring
outstring = strclean (inpstring)
wscript.echo outstring

		</script>
	</job>
' / CLEANSTRING
' ------------------------------------------------------------------------------------------------------------------------------------
'
<job id="IniCommand">
		<script language="VBScript">
' From: http://blogs.technet.com/b/deploymentguys/archive/2010/07/15/reading-and-modifying-ini-files-with-scripts.aspx
'********************************************************************
'* Declare Variables
'********************************************************************

'Option Explicit
On Error Resume Next

Dim arrArguments()
Dim arrFinalArgumants
Dim arrKeyNames
Dim arrSectionNames
Dim arrValueAll
Dim arrKeyValueLines
Dim arrKeyValuePairs
Dim arrInfLines
Dim arrComments

Dim CHAR_DOUBLE_QUOTE

Dim i
Dim intOpMode

Dim objArgumentsDict

Dim strOptionsMessage
Dim strDimStatement
Dim strAssignmentStatement

'***** Global variables
Dim g_objWshShell
Dim g_objFSO
Dim g_strScriptFolder


'***** Define constants
Const CONST_ERROR               = 0
Const CONST_WSCRIPT             = 1
Const CONST_CSCRIPT             = 2
Const CONST_SHOW_USAGE          = 3
Const CONST_PROCEED             = 4
Const CONST_STRING_NOT_FOUND    = -1
Const CONST_FOR_READING         = 1
Const CONST_FOR_WRITING         = 2
Const CONST_FOR_APPENDING       = 8
Const CONST_Success             = 0
Const CONST_Failure             = 1

Const DICTIONARY_COMPAREMODE_BINARY = 0
Const DICTIONARY_COMPAREMODE_TEXT = 1
Const DICTIONARY_COMPAREMODE_DATABASE = 2

CHAR_DOUBLE_QUOTE = Chr(34)


'***** Initialize variables
blnRunNow = False
g_intFileCount = 0


'********************************************************************
'* Create Objects
'********************************************************************

Set g_objWshShell = CreateObject("Wscript.Shell")
set g_objFSO = CreateObject("Scripting.FileSystemObject")
Set objINI = New IniDocument


'********************************************************************
'* Check script host exe and parse command line
'********************************************************************

'Get the command line arguments
For i = 0 to Wscript.arguments.count - 1
    ReDim Preserve arrArguments(i)
    arrArguments(i) = Wscript.arguments.item(i)
Next

'Check whether the script is run using CScript
Select Case intChkProgram()
    Case CONST_CSCRIPT
        'Do Nothing
    Case CONST_WSCRIPT
        WScript.Echo "Please run this script using CScript." & vbCRLF & _
            "This can be achieved by" & vbCRLF & _
            "1. Using ""CScript MODIFYUSERS.vbs arguments"" for Windows 95/98 or" & vbCRLF & _
            "2. Changing the default Windows Scripting Host setting to CScript" & vbCRLF & _
            "    using ""CScript //H:CScript //S"" and running the script using" & vbCRLF & _
            "    ""MODIFYUSERS.vbs arguments"" for Windows NT."
        WScript.Quit
    Case Else
        WScript.Quit
End Select

Set objArgumentsDict = CreateObject("Scripting.Dictionary")

'Parse the command line
Err.Clear()
intOpMode = intParseCmdLine(arrArguments, objArgumentsDict)

If Err.Number Then
    Wscript.Echo "Error 0X" & CStr(Hex(Err.Number)) & " occurred in parsing the command line."
    If Err.Description <> "" Then
        Wscript.Echo "Error description: " & Err.Description & "."
    End If
    'WScript.quit
End If

arrFinalArgumants = objArgumentsDict.Keys

For i = 0 To objArgumentsDict.Count - 1
    strDimStatement = "Dim " & arrFinalArgumants(i)
    If TypeName(objArgumentsDict.Item(arrFinalArgumants(i))) = "String" Then
        'WScript.Echo i & " " & arrFinalArgumants(i) & " = " & CHAR_DOUBLE_QUOTE & objArgumentsDict.Item(arrFinalArgumants(i)) & CHAR_DOUBLE_QUOTE
        strAssignmentStatement = arrFinalArgumants(i) & " = " & CHAR_DOUBLE_QUOTE & objArgumentsDict.Item(arrFinalArgumants(i)) & CHAR_DOUBLE_QUOTE
    Else
        'WScript.Echo i & " " & arrFinalArgumants(i) & " = " & objArgumentsDict.Item(arrFinalArgumants(i))
        strAssignmentStatement = arrFinalArgumants(i) & " = " & objArgumentsDict.Item(arrFinalArgumants(i))
    End If
    Execute strDimStatement
    Execute strAssignmentStatement
Next

If blnShowOptions Then WScript.Echo strOptionsMessage

Select Case intOpMode
    Case CONST_SHOW_USAGE
        Call ShowUsage()
        WScript.quit
    Case CONST_PROCEED
        'Do nothing.
    Case CONST_ERROR
        WScript.Quit
    Case Else
        WScript.Echo "Error occurred in passing parameters."
End Select


'********************************************************************
'* Main Script
'********************************************************************

'***** Get script folder
g_strScriptFolder = Left(WScript.ScriptFullName, Len(WScript.ScriptFullName) - (Len(WScript.ScriptName) + 1))


'***** Set Properties
If blnQuoteKey Then objINI.QuoteKeys = True
If blnQuoteValue Then objINI.QuoteValues = True
If blnQuoteValue Then objINI.QuoteTextLines = True
If blnSpaceEqualsSign Then objINI.SpaceEqualsSign = True

If strIndentChar <> "" Then
    Select Case LCase(strIndentChar)
       Case "none"
          strLeadingCharacter = ""
       Case "space"
          strLeadingCharacter = " "
       Case "tab"
          strLeadingCharacter = vbTab
       Case Else
          WScript.Echo "Indent character must be space or tab."
          WScript.Quit
    End Select
    objINI.LeadingCharacter = strLeadingCharacter
    objINI.QtyLeadingCharacter = intIndentQty
End If 

'***** Load the INI file
Err.Clear
objINI.Load strIniFile
If Err.Number Then
    Wscript.Echo "Error 0x" & CStr(Hex(Err.Number)) & " occurred loading the file."
    If Err.Description <> "" Then
        Wscript.Echo "Error description: " & Err.Description & "."
    End If
    WScript.quit Err.Number
End If


'***** Exceute command
Err.Clear
Select Case LCase(strCommand)

    '***** Reading info
    Case LCase("ReadValue")
         WScript.Echo objINI.ReadValue(strSection, strKey)
    Case LCase("ReadValueAll")
        arrValueAll = objINI.ReadValueAll(strSection, strKey)
        If IsArray(arrValueAll) Then
            For i = 0 to UBound(arrValueAll)
               WScript.Echo arrValueAll(i)
            Next
        End If
    Case LCase("ReadKeyNames")
        arrKeyNames = objINI.ReadKeyNames(strSection)
        If IsArray(arrKeyNames) Then
            For i = 0 to UBound(arrKeyNames)
               WScript.Echo arrKeyNames(i)
            Next
        End If
    Case LCase("ReadKeyValueLines")
        arrKeyValueLines = objINI.ReadKeyValueLines(strSection)
        If IsArray(arrKeyValueLines) Then
            For i = 0 To UBound(arrKeyValueLines)
               WScript.Echo arrKeyValueLines(i)
            Next
        End If
    Case LCase("ReadKeyValuePairs")
        arrKeyValuePairs = objINI.ReadKeyValuePairs(strSection)
        If IsArray(arrKeyValuePairs) Then
            For i = 0 To UBound(arrKeyValuePairs,2)
               WScript.Echo arrKeyValuePairs(0,i) & " = " & arrKeyValuePairs(1,i)
            Next
        End If
    Case LCase("ReadInfLines")
        arrInfLines = objINI.ReadInfLines(strSection)
        If IsArray(arrInfLines) Then
            For i = 0 To UBound(arrInfLines)
               WScript.Echo arrInfLines(i)
            Next
        End If
    Case LCase("ReadComments")
        arrComments = objINI.ReadComments(strSection)
        If IsArray(arrComments) Then
            For i = 0 To UBound(arrComments)
               WScript.Echo arrComments(i)
            Next
        End If
    Case LCase("ReadSectionNames")
        arrSectionNames = objINI.ReadSectionNames
        If IsArray(arrSectionNames) Then
            For i = 0 to UBound(arrSectionNames)
               WScript.Echo arrSectionNames(i)
            Next
        End If

    '***** Writing info
    Case LCase("WriteEntry")
        objINI.WriteEntry strSection, strKey, strValue
        objINI.Save
    Case LCase("AddEntry")
        objINI.AddEntry strSection, strKey, strValue
        objINI.Save
    Case LCase("AddTextLine")
        objINI.AddTextLine strSection, strValue
        objINI.Save

    '***** Deleting info
    Case LCase("DeleteKey")
        objINI.DeleteKey strSection, strKey
        objINI.Save
    Case LCase("DeleteKeyAll")
        objINI.DeleteKeyAll strSection, strKey
        objINI.Save
    Case LCase("DeleteSection")
        objINI.DeleteSection strSection
        objINI.Save

End Select

If Err.Number Then
    Wscript.Echo "Error 0x" & CStr(Hex(Err.Number)) & " executing the command."
    If Err.Description <> "" Then
        Wscript.Echo "Error description: " & Err.Description & "."
    End If
    WScript.quit Err.Number
End If



'********************************************************************
'*
'* Function intChkProgram()
'*
'* Purpose:  Determines which program is used to run this script.
'*
'* Input:    None
'*
'* Returns:  intChkProgram is set to one of CONST_ERROR, CONST_WSCRIPT,
'*           and CONST_CSCRIPT.
'*
'********************************************************************
Private Function intChkProgram()

    ON ERROR RESUME NEXT

    Dim i
    Dim j
    Dim strFullName
    Dim strCommand

    'strFullName should be something like C:\WINDOWS\COMMAND\CSCRIPT.EXE
    strFullName = WScript.FullName
    If Err.Number then
        Wscript.Echo "Error 0x" & CStr(Hex(Err.Number)) & " occurred."
        If Err.Description <> "" Then
            Wscript.Echo "Error description: " & Err.Description & "."
        End If
        intChkProgram =  CONST_ERROR
        Exit Function
    End If

    i = InStr(1, strFullName, ".exe", 1)
    If i = 0 Then
        intChkProgram =  CONST_ERROR
        Exit Function
    Else
        j = InStrRev(strFullName, "\", i, 1)
        If j = 0 Then
            intChkProgram =  CONST_ERROR
            Exit Function
        Else
            strCommand = Mid(strFullName, j+1, i-j-1)
            Select Case LCase(strCommand)
                Case "cscript"
                    intChkProgram = CONST_CSCRIPT
                Case "wscript"
                    intChkProgram = CONST_WSCRIPT
                Case Else       'should never happen
                    Wscript.Echo "An unexpected program is used to run this script."
                    Wscript.Echo "Only CScript.Exe or WScript.Exe can be used to run this script."
                    intChkProgram = CONST_ERROR
            End Select
        End If
    End If

End Function


'********************************************************************
'*
'* Function intParseCmdLine()
'*
'* Purpose:  Parses the command line.
'*
'* Input:    arrArguments       An array containing input from the command line
'*           objArgDict         Dictionary containing the processed arguments
'*                                as variable name/value pairs
'*
'* Returns:  intParseCmdLine is set to one of CONST_ERROR, CONST_SHOW_USAGE,
'*           and CONST_PROCEED.
'*
'********************************************************************
Private Function intParseCmdLine(arrArguments, ByRef objArgDict)

    ON ERROR RESUME Next

    Dim blnQuoteKey
    Dim blnQuoteValue
    Dim blnSpaceEqualsSign
    Dim blnShowOptions

    Dim CHAR_DOUBLE_QUOTE

    Dim i
    Dim intRetryDelay

    Dim strOptionsMessageLineEnd
    Dim strFlag
    Dim strSwitchValue
    Dim strCommand
    Dim strIniFile
    Dim strSection
    Dim strKey
    Dim strValue
    Dim strIndentChar
    Dim intIndentQty
    Dim strOptionsMessage
    Dim strSwitchError
    
    CHAR_DOUBLE_QUOTE = Chr(34)
    strOptionsMessageLineEnd =  CHAR_DOUBLE_QUOTE & " & vbCrLf & _" & VbCrLf
       
    strFlag = arrArguments(0)
    Err.Clear()

    'Help is needed
    If (strFlag = "") OR (strFlag="help") OR (strFlag="/h") OR (strFlag="\h") OR (strFlag="-h") _
        OR (strFlag = "\?") OR (strFlag = "/?") OR (strFlag = "?") OR (strFlag="h") Then
        intParseCmdLine = CONST_SHOW_USAGE
        Exit Function
    End If

    strOptionsMessage = strOptionsMessage & "IniFileCommand.vbs" & strOptionsMessageLineEnd
    strOptionsMessage = strOptionsMessage & CHAR_DOUBLE_QUOTE & " " & strOptionsMessageLineEnd
    strOptionsMessage = strOptionsMessage & CHAR_DOUBLE_QUOTE & "Command Line Options:" & strOptionsMessageLineEnd
    strOptionsMessage = strOptionsMessage & CHAR_DOUBLE_QUOTE & "---------------------------------------" & strOptionsMessageLineEnd

    For i = 0 to UBound(arrArguments)
        strFlag = Left(arrArguments(i), InStr(1, arrArguments(i), ":")-1)
        If Err.Number Then            'An error occurs if there is no : in the string
            Err.Clear
            Select Case LCase(arrArguments(i))
                Case "/quotekey"
                    blnQuoteKey = True
                    objArgDict.Add "blnQuoteKey", True
                    strOptionsMessage = strOptionsMessage & CHAR_DOUBLE_QUOTE & "Place double quotes around Key (e.g. """"UnattendedInstall""""=Yes): " & "True" & strOptionsMessageLineEnd
                Case "/quotevalue"
                    blnQuoteValue = True
                    objArgDict.Add "blnQuoteValue", True
                    strOptionsMessage = strOptionsMessage & CHAR_DOUBLE_QUOTE & "Place double quotes around Value (e.g. UnattendedInstall=""""Yes""""): " & "True" & strOptionsMessageLineEnd
                Case "/spaceequals"
                    blnSpaceEqualsSign = True
                    objArgDict.Add "blnSpaceEqualsSign", True
                    strOptionsMessage = strOptionsMessage & CHAR_DOUBLE_QUOTE & "Place space around equals sign (e.g. UnattendedInstall = Yes): " & "True" & strOptionsMessageLineEnd
                Case "/showoptions"
                    blnShowOptions = True
                    objArgDict.Add "blnShowOptions", True
                    strOptionsMessage = strOptionsMessage & CHAR_DOUBLE_QUOTE & "Display command line options: " & "True" & strOptionsMessageLineEnd
                Case Else
                    Wscript.Echo arrArguments(i) & " is not recognized as a valid input."
                    intParseCmdLine = CONST_ERROR
                    Exit Function
            End Select
        Else
            strSwitchValue = Right(arrArguments(i), Len(arrArguments(i))-(Len(strFlag)+1))
            Select Case LCase(strFlag)
                Case "/cmd"
                    strCommand = strSwitchValue
                    objArgDict.Add "strCommand", strSwitchValue
                    strOptionsMessage = strOptionsMessage & CHAR_DOUBLE_QUOTE & "Command function: " & strSwitchValue & strOptionsMessageLineEnd
                Case "/file"
                    strIniFile = strSwitchValue
                    objArgDict.Add "strIniFile", strSwitchValue
                    strOptionsMessage = strOptionsMessage & CHAR_DOUBLE_QUOTE & "INI File: " & strSwitchValue & strOptionsMessageLineEnd
                Case "/section"
                    strSection = strSwitchValue
                    objArgDict.Add "strSection", strSwitchValue
                    strOptionsMessage = strOptionsMessage & CHAR_DOUBLE_QUOTE & "Section name: " & strSwitchValue & strOptionsMessageLineEnd
                Case "/key"
                    strKey = strSwitchValue
                    objArgDict.Add "strKey", strSwitchValue
                    strOptionsMessage = strOptionsMessage & CHAR_DOUBLE_QUOTE & "Key name: " & strSwitchValue & strOptionsMessageLineEnd
                Case "/value"
                    strValue = strSwitchValue
                    objArgDict.Add "strValue", strSwitchValue
                    strOptionsMessage = strOptionsMessage & CHAR_DOUBLE_QUOTE & "Key value: " & strSwitchValue & strOptionsMessageLineEnd
                Case "/indentchar"
                    strIndentChar = strSwitchValue
                    objArgDict.Add "strIndentChar", strSwitchValue
                    strOptionsMessage = strOptionsMessage & CHAR_DOUBLE_QUOTE & "Indent character: " & strSwitchValue & strOptionsMessageLineEnd
                Case "/indentqty"
                    intIndentQty = strSwitchValue
                    intIndentQty = CInt(strSwitchValue)
                    objArgDict.Add "intIndentQty", intIndentQty
                    strOptionsMessage = strOptionsMessage & CHAR_DOUBLE_QUOTE & "Quantity of indent characters: " & strSwitchValue & strOptionsMessageLineEnd
                Case Else
                    Wscript.Echo "Invalid flag " & strFlag & "."
                    Wscript.Echo "Please check the input and try again."
                    intParseCmdLine = CONST_ERROR
                    Exit Function
            End Select
        End If
    Next

    strOptionsMessage = strOptionsMessage & CHAR_DOUBLE_QUOTE & " "
    objArgDict.Add "strOptionsMessage", strOptionsMessage
    
    '***** Check required switches

    strSwitchError = ""
    
    If not objArgDict.Exists("strCommand") Then strSwitchError = strSwitchError & "The /cmd switch is required." & vbCrLf

    If not objArgDict.Exists("strIniFile") Then strSwitchError = strSwitchError & "The /file switch is required." & vbCrLf

    Select Case LCase(strCommand)
        '***** Reading info
        Case LCase("ReadValue")
             If not objArgDict.Exists("strSection") Then strSwitchError = strSwitchError & "The /section switch is required for the ReadValue command." & vbCrLf
             If not objArgDict.Exists("strKey") Then strSwitchError = strSwitchError & "The /key switch is required for the ReadValue command." & vbCrLf
        Case LCase("ReadValueAll")
             If not objArgDict.Exists("strSection") Then strSwitchError = strSwitchError & "The /section switch is required for the ReadValueAll command." & vbCrLf
             If not objArgDict.Exists("strKey") Then strSwitchError = strSwitchError & "The /key switch is required for the ReadValueAll command." & vbCrLf
        Case LCase("ReadKeyNames")
             If not objArgDict.Exists("strSection") Then strSwitchError = strSwitchError & "The /section switch is required for the ReadKeyNames command." & vbCrLf
        Case LCase("ReadKeyValueLines")
             If not objArgDict.Exists("strSection") Then strSwitchError = strSwitchError & "The /section switch is required for the ReadKeyValueLines command." & vbCrLf
        Case LCase("ReadKeyValuePairs")
             If not objArgDict.Exists("strSection") Then strSwitchError = strSwitchError & "The /section switch is required for the ReadKeyValuePairs command." & vbCrLf
        Case LCase("ReadInfLines")
             If not objArgDict.Exists("strSection") Then strSwitchError = strSwitchError & "The /section switch is required for the ReadInfLines command." & vbCrLf
        Case LCase("ReadComments")
             If not objArgDict.Exists("strSection") Then strSwitchError = strSwitchError & "The /section switch is required for the ReadComments command." & vbCrLf
        Case LCase("ReadSectionNames")
    
        '***** Writing info
        Case LCase("WriteEntry")
             If not objArgDict.Exists("strSection") Then strSwitchError = strSwitchError & "The /section switch is required for the WriteEntry command." & vbCrLf
             If not objArgDict.Exists("strKey") Then strSwitchError = strSwitchError & "The /key switch is required for the WriteEntry command." & vbCrLf
             If not objArgDict.Exists("strValue") Then strSwitchError = strSwitchError & "The /value switch is required for the WriteEntry command." & vbCrLf
        Case LCase("AddEntry")
             If not objArgDict.Exists("strSection") Then strSwitchError = strSwitchError & "The /section switch is required for the AddEntry command." & vbCrLf
             If not objArgDict.Exists("strKey") Then strSwitchError = strSwitchError & "The /key switch is required for the AddEntry command." & vbCrLf
             If not objArgDict.Exists("strValue") Then strSwitchError = strSwitchError & "The /value switch is required for the AddEntry command." & vbCrLf
        Case LCase("AddTextLine")
             If not objArgDict.Exists("strSection") Then strSwitchError = strSwitchError & "The /section switch is required for the AddTextLine command." & vbCrLf
             If not objArgDict.Exists("strValue") Then strSwitchError = strSwitchError & "The /value switch is required for the AddTextLine command." & vbCrLf
    
        '***** Deleting info
        Case LCase("DeleteKey")
             If not objArgDict.Exists("strSection") Then strSwitchError = strSwitchError & "The /section switch is required for the DeleteKey command." & vbCrLf
             If not objArgDict.Exists("strKey") Then strSwitchError = strSwitchError & "The /key switch is required for the DeleteKey command." & vbCrLf
        Case LCase("DeleteKeyAll")
             If not objArgDict.Exists("strSection") Then strSwitchError = strSwitchError & "The /section switch is required for the DeleteKeyAll command." & vbCrLf
             If not objArgDict.Exists("strKey") Then strSwitchError = strSwitchError & "The /key switch is required for the DeleteKeyAll command." & vbCrLf
        Case LCase("DeleteSection")
             If not objArgDict.Exists("strSection") Then strSwitchError = strSwitchError & "The /section switch is required for the DeleteSection command." & vbCrLf
    End Select

    If strSwitchError <> "" Then
        WScript.Echo ""
        WScript.Echo strSwitchError
        Wscript.Echo "Please check the input and try again."
        WScript.Echo ""
        intParseCmdLine = CONST_ERROR
        Exit Function
    End If

    intParseCmdLine = CONST_PROCEED

End Function


'********************************************************************
'* Class IniDocument
'*
'* Version:   1.0.4
'* Date:      08/29/2008
'*
'* Purpose: Class to handle INI and INF File tasks.  For details on
'*             the use of each Method, see the comments on the method.
'*             Class Properties are documented in the Declare Class 
'*             Properties section.
'*          INI file must be loaded into memory with the Load method
'*             before using other methods.  Changes are not saved to
'*             disk until the Save method is used.
'*          The Additional Methods may be deleted from the Class if
'*             they are not needed or the script file size is to large.
'*             However, the Private Procedures should not be deleted.
'*
'* Basic Methods: 
'*
'*          Load               Load the INI file into memory.
'*
'*          Save               Save the INI file back to disk.
'*
'*          SaveAs             Save the INI file back to disk using 
'*                                another file name.
'*
'*          ReadValue          Read the Value for the first occurance 
'*                                of a Key in an INI file section
'*
'*          ReadKeyNames       Read all Key names in INI file Section
'*
'*          ReadSectionNames   Read all Section Names in an INI file
'*
'*          WriteEntry         Write a Key & Value entry to an INI 
'*                               file section.
'*
'* Additional Methods:
'*
'*          ReadValueAll       Read all Values for a given Key name 
'*                                in an INI file (i.e. if there are 
'*                                duplicate Keys in a section)
'*
'*          ReadKeyValueLines  Read all raw Key=Value lines in INI 
'*                                file Section
'*
'*          ReadKeyValuePairs  Read all Key/Value pairs in INI file
'*                                Section into a 2D Array
'*
'*          ReadInfLines       Read all INF-type lines (not Key=Value)
'*                                in INI/INF file Section
'*
'*          ReadComments       Read all comment lines and trailing 
'*                                comments in INI/INF file Section
'*
'*          ReadAllLines       Read all raw lines in INI/INF file Section
'*
'*          AddEntry           Add a Key & Value entry to an INI
'*                                section (does not validate if Key
'*                                exists and will not change existing
'*                                values with the same Key name)
'*
'*          AddTextLine        Write a text line to the INI/INF file 
'*                                section
'* 
'*          DeleteKey          Delete the Key for the first occurance 
'*                                of a Key in an INI file section
'*
'*          DeleteKeyAll       Delete all occurances of a Key in an 
'*                                INI file section (i.e. if there are 
'*                                duplicate Keys in a section)
'*
'*          DeleteSection      Delete an INI file section
'*
'*          ExpandINFStringVariables
'*                             Expands String variables (entries found 
'*                                in the [Strings] section of an INF file)
'*
'* History:
'* 1.0.0   10/11/2006  Created initial version.
'* 1.0.1   03/20/2007  Added Unicode support.
'* 1.0.2   09/26/2007  Added the ability to designate the comment line
'*                     string (i.e. specify something other than ;)
'* 1.0.3   04/07/2008  Added code to detect whether INI file is Unicode
'*                     or ANSI and load accordingly
'* 1.0.4   08/29/2008  Fixed small bug.  Added FileSaved = False to
'*                     end of If blnSectionExists = False loop in
'*                     WriteEntry method.
'*
'********************************************************************
Class IniDocument

   '********************************************************************
   '* Declare Class variables and objects
   '******************************************************************** 
   Private m_DOUBLE_QUOTE
   Private m_REGEX_INI_SECTION_HEADER
   Private m_REGEX_INI_KEY_VALUE_LINE
   Private m_REGEX_INI_COMMENT_LINE
   Private m_REGEX_TRAILING_COMMENT
   Private m_REGEX_INF_LINE
   Private m_REGEX_BLANK_LINE
   Private m_REGEX_WHITE_SPACE_PADDED_STRING
   Private m_REGEX_m_DOUBLE_QUOTED_STRING
   Private m_REGEX_POSITIVE_INTEGER
   
   Private m_blnFileLoaded
   Private m_blnFileSaved
   Private m_strFilePath
   Private m_blnIsUnicode
   Private m_blnSpacesAroundEquals
   Private m_blnKeyDoubleQuotes
   Private m_blnValueDoubleQuotes
   Private m_blnTextDoubleQuotes
   Private m_strLeadingWhitespaceChar
   Private m_intQtyLeadingWhitespaceChar
   Private m_strStringsSection
   Private m_strCommentString

   Private m_arrLines
   Private m_objFSO
   Private m_regEx


   '********************************************************************
   '* Declare Class Properties
   '******************************************************************** 

   '******************************************************************** 
   '* Output formatting properties for WriteEntry, AddEntry, and AddTextLine:
   '*
   '* FileLoaded - True if an INI file has been loaded into memory with
   '*              the Load method (read only)
   '*
   '* FileSaved - False if changes need to be save to disk (read only)
   '*
   '* FilePath - Path to INI file (read only)
   '*
   '* IsUnicode - Load method will set this based on the encoding of the file.
   '*             May be changed so that Save and SaveAs will use the new 
   '*             encoding when saving.
   '*
   '* SpaceEqualsSign - Place spaces on either side of the equals sign, e.g.:
   '*        Key = Value
   '*
   '* QuoteKeys - Place double quotes around the Key name, e.g.:
   '*       "Key"=Value
   '*
   '* QuoteValues - Place double quotes around the Value name, e.g.:
   '*        Key="Value"
   '*
   '* QuoteTextLines - Place double quotes around text (INF) lines, e.g.:
   '*        "c:\sysprep\sysprep.exe -factory -reboot -quiet"
   '*
   '* LeadingCharacter - Place leading characters (spaces, tabs, or blanks) 
   '*                    in front of the Key or text line (i.e. "indent" the line)
   '*
   '* QtyLeadingCharacter - Number of leading characters (spaces, tabs,
   '*                       or blanks) in front of the Key or text line
   '*
   '* StringsSection - Name of localized "Strings" section in an INF file
   '*
   '* CommentString - Character or string of charaters that go at the 
   '*                 beginning of a string or line to designate a comment
   '*
   '* Properties may be combined to get the desired line format.
   '* Default is no double quotes, no spaces around the equals sign, and  
   '* no leading characters.
   '*
   '********************************************************************
   Private Property Let FileLoaded(blnInput)
      If blnInput Or Not blnInput Then
         m_blnFileLoaded = blnInput
      Else
         Err.Raise 50000, "", "Value must be Boolean"
      End If
   End Property
   
   Public Property Get FileLoaded
      FileLoaded = m_blnFileLoaded
   End Property


   Private Property Let FileSaved(blnInput)
      If blnInput Or Not blnInput Then
         m_blnFileSaved = blnInput
      Else
         Err.Raise 50000, "", "Value must be Boolean"
      End If
   End Property
   
   Public Property Get FileSaved
      FileLoaded = m_blnFileSaved
   End Property


   Private Property Let FilePath(blnInput)
      m_strFilePath = blnInput
   End Property
   
   Private Property Get FilePath
      FilePath = m_strFilePath
   End Property


   'Public Property Let IsUnicode(blnInput)
   '   If blnInput Or Not blnInput Then
   '      m_blnIsUnicode = blnInput
   '   Else
   '      Err.Raise 50000, "", "Value must be Boolean"
   '   End If
   'End Property
   
   Public Property Get IsUnicode
      IsUnicode = m_blnIsUnicode
   End Property


   Public Property Let SpaceEqualsSign(blnInput)
      If blnInput Or Not blnInput Then
         m_blnSpacesAroundEquals = blnInput
      Else
         Err.Raise 50000, "", "Value must be Boolean"
      End If
   End Property
   
   Public Property Get SpaceEqualsSign
      SpaceEqualsSign = m_blnSpacesAroundEquals
   End Property


   Public Property Let QuoteKeys(blnInput)
      If blnInput Or Not blnInput Then
         m_blnKeyDoubleQuotes = blnInput
      Else
         Err.Raise 50000, , "Value must be Boolean"
      End If
   End Property

   Public Property Get QuoteKeys
      QuoteKeys = m_blnKeyDoubleQuotes
   End Property


   Public Property Let QuoteValues(blnInput)
      If blnInput Or Not blnInput Then
         m_blnValueDoubleQuotes = blnInput
      Else
         Err.Raise 50000, , "Value must be Boolean"
      End If
   End Property

   Public Property Get QuoteValues
      QuoteValues = m_blnValueDoubleQuotes
   End Property


   Public Property Let QuoteTextLines(blnInput)
      If blnInput Or Not blnInput Then
         m_blnTextDoubleQuotes = blnInput
      Else
         Err.Raise 50000, , "Value must be Boolean"
      End If
   End Property


   Public Property Get QuoteTextLines
      QuoteTextLines = m_blnTextDoubleQuotes
   End Property


   Public Property Let LeadingCharacter(strInput)
      If strInput = " " Or strInput = vbTab Or strInput = "" Then
         m_strLeadingWhitespaceChar = strInput
      Else
         Err.Raise 50000, , "Value must be a single space (" & m_DOUBLE_QUOTE & " " & m_DOUBLE_QUOTE & _
                             "), tab (vbTab), or blank (" & m_DOUBLE_QUOTE & m_DOUBLE_QUOTE & ")"
      End If
   End Property

   Public Property Get LeadingCharacter
      LeadingCharacter = m_strLeadingWhitespaceChar
   End Property


   Public Property Let QtyLeadingCharacter(intInput)
      If RegExTest(intInput, m_REGEX_POSITIVE_INTEGER) Then
         m_intQtyLeadingWhitespaceChar = intInput
      Else
         Err.Raise 50000, , "Value must be zero or a positive integer"
      End If
   End Property

   Public Property Get QtyLeadingCharacter
      QtyLeadingCharacter = m_intQtyLeadingWhitespaceChar
   End Property


   Public Property Let StringsSection(blnInput)
      m_strStringsSection = blnInput
   End Property
   
   Public Property Get StringsSection
      StringsSection = m_strStringsSection
   End Property


   Public Property Let CommentString(strInput)
      m_strCommentString = RegExEscapeMetaCharacters(strInput)
      m_REGEX_INI_SECTION_HEADER = "^\s*(?!" & m_strCommentString & ")\s*\[\s*(.*[^\s*])\s*]\s*$"
      m_REGEX_INI_KEY_VALUE_LINE = "^\s*(?!" & m_strCommentString & ")\s*" & "([^=]*)" & "\s*=\s*" & "(.*)" & "\s*$"
      m_REGEX_INI_COMMENT_LINE = "^(\s*" & m_strCommentString & ".*\s*)$"
      m_REGEX_TRAILING_COMMENT = "^\s*([^" & m_strCommentString & "]+[^\s*])(\s+" & m_strCommentString & ".*)$"
      m_REGEX_INF_LINE = "^\s*(?!" & m_strCommentString & ")\s*" & "([^=]*)" & "\s*$"
   End Property

   Public Property Get CommentString
      CommentString = m_strCommentString
   End Property


   '********************************************************************
   '* Initialize Class variables and objects
   '******************************************************************** 
   Private Sub Class_Initialize()
      m_blnFileLoaded = False
      m_blnIsUnicode = False
      m_blnSpacesAroundEquals = False
      m_blnKeyDoubleQuotes = False
      m_blnValueDoubleQuotes = False
      m_blnTextDoubleQuotes = False
      m_strLeadingWhitespaceChar = ""
      m_intQtyLeadingWhitespaceChar = 0
      m_strStringsSection = "Strings"
      m_strCommentString = ";"

      m_DOUBLE_QUOTE = chr(34)
      m_REGEX_INI_SECTION_HEADER = "^\s*(?!" & m_strCommentString & ")\s*\[\s*(.*[^\s*])\s*]\s*$"
      m_REGEX_INI_KEY_VALUE_LINE = "^\s*(?!" & m_strCommentString & ")\s*" & "([^=]*)" & "\s*=\s*" & "(.*)" & "\s*$"
      m_REGEX_INI_COMMENT_LINE = "^(\s*" & m_strCommentString & ".*\s*)$"
      m_REGEX_TRAILING_COMMENT = "^\s*([^" & m_strCommentString & "]+[^\s*])(\s+" & m_strCommentString & ".*)$"
      m_REGEX_INF_LINE = "^\s*(?!" & m_strCommentString & ")\s*" & "([^=]*)" & "\s*$"
      m_REGEX_BLANK_LINE = "^\s*$"
      m_REGEX_WHITE_SPACE_PADDED_STRING = "^\s*(.*[^\s*])\s*$"
      m_REGEX_m_DOUBLE_QUOTED_STRING = "^" & m_DOUBLE_QUOTE & ".*" & m_DOUBLE_QUOTE & "$"
      m_REGEX_POSITIVE_INTEGER = "^\d+$"

      Set m_objFSO = CreateObject("Scripting.FileSystemObject")
      Set m_regEx = New RegExp
      m_regEx.IgnoreCase = True
      m_regEx.Global = False
   End Sub
   
   
   'Private Sub Class_Terminate()
     'statements
   'End Sub


   '********************************************************************
   '* Basic Methods
   '******************************************************************** 

   '********************************************************************
   '* Functions Load()
   '*
   '* Purpose:  Load INI File into an array in memory
   '*
   '* Input:    strFileName       Path and name of INI file
   '*
   '* Returns:  Value assigned to Key
   '*
   '********************************************************************
   Sub Load(strFileName)
      Dim objINIFile
      Dim strFileContents
   
      If m_objFSO.FileExists(strFileName) Then
         DetectIfUnicodeTextFile strFileName
         Set objINIFile = m_objFSO.OpenTextFile(strFileName, 1, False, m_blnIsUnicode)
         strFileContents = objINIFile.ReadAll
         m_arrLines = Split(strFileContents, vbCrLf)
         FileLoaded = True
         FileSaved = True
         FilePath = strFileName
         objINIFile.Close
      Else
         Err.Raise 5001, , "Error Loading File"
      End IF
   End Sub


   '********************************************************************
   '* Functions Save()
   '*
   '* Purpose:  Save INI array in memory to disk
   '*
   '********************************************************************
   Sub Save()
      Dim i
      Dim objINIFile
   
      If (FileLoaded) and (Not m_blnFileSaved) Then
         Set objINIFile = m_objFSO.OpenTextFile(m_strFilePath, 2, False, m_blnIsUnicode)
         For i = 0 to Ubound(m_arrLines)
            objINIFile.WriteLine m_arrLines(i)
         Next
         objINIFile.Close
         FileSaved = True
      ElseIf (FileLoaded) and m_blnFileSaved Then
         'No changes made.  No need to save.
      Else
         Err.Raise 5002, , "No File Loaded"
      End IF
   End Sub


   '********************************************************************
   '* Functions SaveAs()
   '*
   '* Purpose:  Save INI array in memory to a defferent file
   '*
   '* Input:    strFileName       Path and name of INI file
   '*
   '********************************************************************
   Sub SaveAs(strFileName)
      Dim i
      Dim objINIFile
   
      If (FileLoaded) Then
         Set objINIFile = m_objFSO.OpenTextFile(strFileName, 2, True, m_blnIsUnicode)
         For i = 0 to Ubound(m_arrLines)
            objINIFile.WriteLine m_arrLines(i)
         Next
         objINIFile.Close
      Else
         Err.Raise 5002, , "No File Loaded"
      End IF
   End Sub


   '********************************************************************
   '* Functions ReadValue()
   '*
   '* Purpose:  Read a Key's Value in an INI file
   '*
   '* Input:    strSectionName    Section name
   '*           strKeyName        Key name
   '*
   '* Returns:  Value assigned to Key
   '*
   '********************************************************************
   Function ReadValue(strSectionName, strKeyName)
      Dim blnInSection
      Dim i
      Dim strLine
      Dim strSectionNameEscaped
      Dim strKeyNameEscaped
      Dim strRegexSection
      Dim strRegexKey

      strSectionNameEscaped = RegExEscapeMetaCharacters(strSectionName)
      strKeyNameEscaped = RegExEscapeMetaCharacters(strKeyName)
      
      strRegexSection = "^\s*\[\s*" & strSectionNameEscaped & "\s*]"
      strRegexKey = "^\s*" & m_DOUBLE_QUOTE & "?" & strKeyNameEscaped & m_DOUBLE_QUOTE & "?" & "\s*=\s*"
   
      ReadValue = ""
      If FileLoaded Then
          For i = 0 to Ubound(m_arrLines)
            strLine = m_arrLines(i)
            If RegExTest(strLine, strRegexSection) Then
               blnInSection = True
            ElseIf blnInSection Then
               If RegExTest(strLine, m_REGEX_INI_SECTION_HEADER) Then
                  Exit For
               Else
                  If RegExTest(strLine, strRegexKey) Then
                     ReadValue = GetValue(strLine)
                     Exit For
                  End If
               End If
            End If
         Next
      Else
         Err.Raise 5002, , "No File Loaded"
      End IF
   End Function
   
   
   '********************************************************************
   '* Functions ReadKeyNames()
   '*
   '* Purpose:  Read all Key names in INI file Section
   '*
   '* Input:    strSectionName    Section name
   '*
   '* Returns:  Array of all Key name under a section
   '*
   '********************************************************************
   Function ReadKeyNames(strSectionName)
      Dim blnInSection
      Dim i
      Dim objINIFile
      Dim strLine
      Dim strSectionNameEscaped
      Dim strRegexSection
      Dim strKeyList
      
      strSectionNameEscaped = RegExEscapeMetaCharacters(strSectionName)

      strRegexSection = "^\s*\[\s*" & strSectionNameEscaped & "\s*]"
   
      ReadKeyNames = ""
      strKeyList = ""
      If FileLoaded Then
         For i = 0 to Ubound(m_arrLines)
            strLine = m_arrLines(i)
            If RegExTest(strLine, strRegexSection) Then
               blnInSection = True
            ElseIf blnInSection Then
               If RegExTest(strLine, m_REGEX_INI_SECTION_HEADER) Then
                  Exit For
               Else
                  If RegExTest(strLine, m_REGEX_INI_KEY_VALUE_LINE) Then
                     strKeyList=strKeyList & GetKey(strLine) & VbCrLf
                  End If
               End If
            End If
         Next
         If strKeyList <> "" Then
            strKeyList = Left(strKeyList,(Len(strKeyList) - 2)) ' Remove last vbCrLf
            ReadKeyNames = split(strKeyList,vbCrLf)
         End If
      Else
         Err.Raise 5002, , "No File Loaded"
      End IF
   End Function


   '********************************************************************
   '* Functions ReadSectionNames()
   '*
   '* Purpose:  Read all Section Names in an INI file
   '*
   '* Returns:  Array of Section names in the file
   '*
   '********************************************************************
   Function ReadSectionNames()
      Dim i
      Dim objINIFile
      Dim strLine
      Dim strSectionList
   
      ReadSectionNames = ""
      strSectionList = ""
      If FileLoaded Then
         For i = 0 to Ubound(m_arrLines)
            strLine = m_arrLines(i)
            If RegExTest(strLine, m_REGEX_INI_SECTION_HEADER) Then
               strSectionList = strSectionList & RegExReplace(strLine, m_REGEX_INI_SECTION_HEADER, "$1") & VbCrLf
            End If
         Next
         If strSectionList <> "" Then
            strSectionList = Left(strSectionList, Len(strSectionList) - 2)  ' Remove last vbCrLf
            ReadSectionNames = split(strSectionList,vbCrLf)
         End If
      Else
         Err.Raise 5002, , "No File Loaded"
      End IF
   End Function


   '********************************************************************
   '* Sub WriteEntry()
   '*
   '* Purpose:  Write a Key & Value entry to an INI file.  If the Key
   '*           exists, the existing Value will be overwritten for the
   '*           first occurance of the Key. This method will preserve 
   '*           trailing comments on an existing Key.
   '*
   '* Input:    strSectionName   Section name
   '*           strKeyName       Key name
   '*           strValue         Value to assign to the item
   '*
   '* Output:   Key & Value entry written to the file
   '*
   '********************************************************************
   Sub WriteEntry(strSectionName, strKeyName, strValue)
      Dim arrTempLines
      Dim blnInSection
      Dim blnSectionExists
      Dim blnKeyExists
      Dim blnEntryWritten
      Dim i
      Dim objTempFile
      Dim strPath
      Dim strLine
      Dim strSectionNameEscaped
      Dim strKeyNameEscaped
      Dim strRegexSection
      Dim strRegexKey
      Dim strTempLines
      Dim strTrailingComment

      blnInSection = False
      blnSectionExists = False
      blnKeyExists = (ReadValue(strSectionName, strKeyName) <> "")
      blnEntryWritten = False
   
      strSectionNameEscaped = RegExEscapeMetaCharacters(strSectionName)
      strKeyNameEscaped = RegExEscapeMetaCharacters(strKeyName)
         
      strRegexSection = "^\s*\[\s*" & strSectionNameEscaped & "\s*]"
      strRegexKey = "^\s*" & m_DOUBLE_QUOTE & "?" & strKeyNameEscaped & m_DOUBLE_QUOTE & "?" & "\s*=\s*"
   
      strTempLines = ""
      If FileLoaded Then
         For i = 0 to Ubound(m_arrLines)
            strLine = m_arrLines(i)

            If blnEntryWritten = False Then
               If RegExTest(strLine, strRegexSection) Then
                  blnSectionExists = True
                  blnInSection = True
               Elseif RegExTest(strLine, m_REGEX_INI_SECTION_HEADER) Then
                  blnInSection = False
               End If
            End If
      
            If blnInSection Then
               If blnKeyExists = False Then
                  strTempLines = AppendLineToString(strTempLines, strLine)
                  strTempLines = AppendLineToString(strTempLines, CreateKeyValueLine(strKeyName, strValue, ""))
                  blnEntryWritten = True
                  blnInSection = False
                  FileSaved = False
               Elseif RegExTest(strLine, strRegexKey) Then
                  strTrailingComment = ""
                  If RegExTest(strLine, m_REGEX_TRAILING_COMMENT) Then strTrailingComment = GetTrailingComment(strLine)
                  strTempLines = AppendLineToString(strTempLines, CreateKeyValueLine(strKeyName, strValue, strTrailingComment))
                  blnEntryWritten = True
                  blnInSection = False
                  FileSaved = False
               Else
                  strTempLines = AppendLineToString(strTempLines, strLine)
               End If
            Else
               strTempLines = AppendLineToString(strTempLines, strLine)
            End If
         Next

      Else
         Err.Raise 5002, , "No File Loaded"
      End IF

      If blnSectionExists = False Then
         strSectionName = Trim(strSectionName)
         strKeyName = Trim(strKeyName)
         strTempLines = strTempLines & vbCrLf
         strTempLines = AppendLineToString(strTempLines, "[" & strSectionName & "]")
         strTempLines = AppendLineToString(strTempLines, CreateKeyValueLine(strKeyName, strValue, ""))
         FileSaved = False
      End If
   
      arrTempLines = Split(strTempLines, vbCrLf)
      m_arrLines = arrTempLines
   End Sub


   '********************************************************************
   '* Additional Methods
   '******************************************************************** 

   '********************************************************************
   '* Functions ReadValueAll()
   '*
   '* Purpose:  Read all Values for a given Key name in an INI file 
   '*           (i.e. if there are duplicate Keys in a section)
   '*
   '* Input:    strFileName       Path and name of ini file
   '*           strSectionName    Section name
   '*           strKeyName        Key name
   '*
   '* Returns:  Array of all Values for the Key name under a section
   '*
   '********************************************************************
      Function ReadValueAll(strSectionName, strKeyName)
      Dim blnInSection
      Dim i
      Dim strLine
      Dim strSectionNameEscaped
      Dim strKeyNameEscaped
      Dim strRegexSection
      Dim strRegexKey
      Dim strValueList

      strSectionNameEscaped = RegExEscapeMetaCharacters(strSectionName)
      strKeyNameEscaped = RegExEscapeMetaCharacters(strKeyName)
      
      strRegexSection = "^\s*\[\s*" & strSectionNameEscaped & "\s*]"
      strRegexKey = "^\s*" & m_DOUBLE_QUOTE & "?" & strKeyNameEscaped & m_DOUBLE_QUOTE & "?" & "\s*=\s*"

      ReadValueAll = ""
      strValueList = ""
      If FileLoaded Then
         For i = 0 to Ubound(m_arrLines)
            strLine = m_arrLines(i)
            If RegExTest(strLine, strRegexSection) Then
               blnInSection = True
            ElseIf blnInSection Then
               If RegExTest(strLine, m_REGEX_INI_SECTION_HEADER) Then
                  Exit For
               Else
                  If RegExTest(strLine, strRegexKey) Then
                     strValueList = strValueList & GetValue(strLine) & VbCrLf
                  End If
               End If
            End If
         Next
         If strValueList <> "" Then
            strValueList = Left(strValueList,(Len(strValueList) - 2)) ' Remove last vbCrLf
            ReadValueAll = split(strValueList,vbCrLf)
         End If
      Else
         Err.Raise 5002, , "No File Loaded"
      End IF
   End Function


   '********************************************************************
   '* Functions ReadKeyValueLines()
   '*
   '* Purpose:  Read all raw Key=Value lines in INI file Section
   '*
   '* Input:    strSectionName    Section name
   '*
   '* Returns:  Array of all Key=Value lines under a section
   '*
   '********************************************************************
   Function ReadKeyValueLines(strSectionName)
      Dim blnInSection
      Dim i
      Dim strLine
      Dim strSectionNameEscaped
      Dim strRegexSection
      Dim strLineList
      
      strSectionNameEscaped = RegExEscapeMetaCharacters(strSectionName)
      strRegexSection = "^\s*\[\s*" & strSectionNameEscaped & "\s*]"

      ReadKeyValueLines = ""
      strLineList = ""
      If FileLoaded Then
         For i = 0 to Ubound(m_arrLines)
            strLine = m_arrLines(i)
            If RegExTest(strLine, strRegexSection) Then
               blnInSection = True
            ElseIf blnInSection Then
               If RegExTest(strLine, m_REGEX_INI_SECTION_HEADER) Then
                  Exit For
               Else
                  If RegExTest(strLine, m_REGEX_INI_KEY_VALUE_LINE) Then
                     strLineList = strLineList & strLine & VbCrLf
                  End If
               End If
            End If
         Next
         If strLineList <> "" Then
            strLineList = Left(strLineList,(Len(strLineList) - 2)) ' Remove last vbCrLf
            ReadKeyValueLines = split(strLineList,vbCrLf)
         End If
      Else
         Err.Raise 5002, , "No File Loaded"
      End IF
   End Function


   '********************************************************************
   '* Functions ReadKeyValuePairs()
   '*
   '* Purpose:  Read all Key/Value pairs in INI file Section into a 2D Array
   '*
   '* Input:    strSectionName    Section name
   '*
   '* Returns:  2D Array of all Key name under a section
   '*
   '********************************************************************
   Function ReadKeyValuePairs(strSectionName)
      Dim arrKeyValuePairs()
      Dim blnInSection
      Dim i
      Dim intLineCount
      Dim strLine
      Dim strSectionNameEscaped
      Dim strRegexSection
      Dim strKeyList
      
      strSectionNameEscaped = RegExEscapeMetaCharacters(strSectionName)
      strRegexSection = "^\s*\[\s*" & strSectionNameEscaped & "\s*]"
   
      ReadKeyValuePairs = ""
      If FileLoaded Then
         For i = 0 to Ubound(m_arrLines)
            strLine = m_arrLines(i)
            If RegExTest(strLine, strRegexSection) Then
               blnInSection = True
               intLineCount = 0
            ElseIf blnInSection Then
               If RegExTest(strLine, m_REGEX_INI_SECTION_HEADER) Then
                  Exit For
               Else
                  If RegExTest(strLine, m_REGEX_INI_KEY_VALUE_LINE) Then
                     ReDim Preserve arrKeyValuePairs(1,intLineCount)
                     arrKeyValuePairs(0,intLineCount) = GetKey(strLine)
                     arrKeyValuePairs(1,intLineCount) = GetValue(strLine)
                     intLineCount = intLineCount + 1
                  End If
               End If
            End If
         Next
         ReadKeyValuePairs = arrKeyValuePairs
      Else
         Err.Raise 5002, , "No File Loaded"
      End IF
   End Function


   '********************************************************************
   '* Functions ReadInfLines()
   '*
   '* Purpose:  Read all INF-type lines (not Key=Value) in INI/INF file Section
   '*
   '* Input:    strSectionName    Section name
   '*
   '* Returns:  Array of all INF-type lines in INI/INF file Section
   '*
   '********************************************************************
   Function ReadInfLines(strSectionName)
      Dim blnInSection
      Dim i
      Dim strLine
      Dim strSectionNameEscaped
      Dim strRegexSection
      Dim strLineList
      
      strSectionNameEscaped = RegExEscapeMetaCharacters(strSectionName)
      strRegexSection = "^\s*\[\s*" & strSectionNameEscaped & "\s*]"
   
      ReadInfLines = ""
      strLineList = ""
      If FileLoaded Then
         For i = 0 to Ubound(m_arrLines)
            strLine = m_arrLines(i)
            If RegExTest(strLine, strRegexSection) Then
               blnInSection = True
            ElseIf blnInSection Then
               If RegExTest(strLine, m_REGEX_INI_SECTION_HEADER) Then
                  Exit For
               Else
                  If RegExTest(strLine, m_REGEX_INF_LINE) And (RegExTest(strLine, m_REGEX_BLANK_LINE) = False) Then
                     strLineList = strLineList & GetInfLine(strLine) & VbCrLf
                  End If
               End If
            End If
         Next
         If strLineList <> "" Then
            strLineList = Left(strLineList,(Len(strLineList) - 2)) ' Remove last vbCrLf
            ReadInfLines = split(strLineList,vbCrLf)
         End If
      Else
         Err.Raise 5002, , "No File Loaded"
      End IF
   End Function


   '********************************************************************
   '* Functions ReadComments()
   '*
   '* Purpose:  Read all comment lines and trailing comments in INI/INF 
   '*           file Section
   '*
   '* Input:    strSectionName    Section name
   '*
   '* Returns:  Array of all comments in INI/INF file Section
   '*
   '********************************************************************
   Function ReadComments(strSectionName)
      Dim blnInSection
      Dim i
      Dim strLine
      Dim strSectionNameEscaped
      Dim strRegexSection
      Dim strLineList
      
      strSectionNameEscaped = RegExEscapeMetaCharacters(strSectionName)
      strRegexSection = "^\s*\[\s*" & strSectionNameEscaped & "\s*]"
   
      ReadComments = ""
      strLineList = ""
      If FileLoaded Then
         For i = 0 to Ubound(m_arrLines)
            strLine = m_arrLines(i)
            If RegExTest(strLine, strRegexSection) Then
               blnInSection = True
            ElseIf blnInSection Then
               If RegExTest(strLine, m_REGEX_INI_SECTION_HEADER) Then
                  Exit For
               Else
                  If RegExTest(strLine, m_REGEX_INI_COMMENT_LINE) And (RegExTest(strLine, m_REGEX_BLANK_LINE) = False) Then
                     strLineList = strLineList & GetCommentLine(strLine) & VbCrLf
                  Elseif RegExTest(strLine, m_REGEX_TRAILING_COMMENT) And (RegExTest(strLine, m_REGEX_BLANK_LINE) = False) Then
                     strLineList = strLineList & GetTrailingComment(strLine) & vbCrLf
                  End If
               End If
            End If
         Next
         If strLineList <> "" Then
            strLineList = Left(strLineList,(Len(strLineList) - 2)) ' Remove last vbCrLf
            ReadComments = split(strLineList,vbCrLf)
         End If
      Else
         Err.Raise 5002, , "No File Loaded"
      End IF
   End Function


   '********************************************************************
   '* Functions ReadAllLines()
   '*
   '* Purpose:  Read all raw lines in INI/INF file Section
   '*
   '* Input:    strSectionName    Section name
   '*
   '* Returns:  Array of all lines in INI/INF file Section
   '*
   '********************************************************************
   Function ReadAllLines(strSectionName)
      Dim blnInSection
      Dim i
      Dim strLine
      Dim strSectionNameEscaped
      Dim strRegexSection
      Dim strLineList
      
      strSectionNameEscaped = RegExEscapeMetaCharacters(strSectionName)
      strRegexSection = "^\s*\[\s*" & strSectionNameEscaped & "\s*]"
   
      ReadAllLines = ""
      strLineList = ""
      If FileLoaded Then
         For i = 0 to Ubound(m_arrLines)
            strLine = m_arrLines(i)
            If RegExTest(strLine, strRegexSection) Then
               blnInSection = True
            ElseIf blnInSection Then
               If RegExTest(strLine, m_REGEX_INI_SECTION_HEADER) Then
                  Exit For
               Else
                  strLineList = strLineList & strLine & VbCrLf
               End If
            End If
         Next
         If strLineList <> "" Then
            strLineList = Left(strLineList,(Len(strLineList) - 2)) ' Remove last vbCrLf
            ReadAllLines = split(strLineList,vbCrLf)
         End If
      Else
         Err.Raise 5002, , "No File Loaded"
      End IF
   End Function


   '********************************************************************
   '* Sub AddEntry()
   '*
   '* Purpose:  Write a Key & Value entry to an INI file.  This method 
   '*              does not validate if Key exists and will not change 
   '*              existing values with the same Key.
   '*
   '* Input:    strSectionName   Section name
   '*           strKeyName       Key name
   '*           strValue         Value to assign to the item
   '*
   '* Output:   Key & Value entry written to the file
   '*
   '********************************************************************
   Sub AddEntry(strSectionName, strKeyName, strValue)
      Dim arrTempLines
      Dim blnInSection
      Dim blnSectionExists
      Dim blnKeyExists
      Dim blnEntryWritten
      Dim i
      Dim strLine
      Dim strSectionNameEscaped
      Dim strKeyNameEscaped
      Dim strRegexSection
      Dim strRegexKey
      Dim strTempLines
      Dim strTrailingComment

      blnInSection = False
      blnSectionExists = False
      blnKeyExists = (ReadValue(strSectionName, strKeyName) <> "")
      blnEntryWritten = False
   
      strSectionNameEscaped = RegExEscapeMetaCharacters(strSectionName)
      strKeyNameEscaped = RegExEscapeMetaCharacters(strKeyName)
         
      strRegexSection = "^\s*\[\s*" & strSectionNameEscaped & "\s*]"
      strRegexKey = "^\s*" & m_DOUBLE_QUOTE & "?" & strKeyNameEscaped & m_DOUBLE_QUOTE & "?" & "\s*=\s*"
   
      strTempLines = ""
      If FileLoaded Then
         For i = 0 to Ubound(m_arrLines)
            strLine = m_arrLines(i)

            If blnEntryWritten = False Then
               If RegExTest(strLine, strRegexSection) Then
                  blnSectionExists = True
                  blnInSection = True
               Elseif RegExTest(strLine, m_REGEX_INI_SECTION_HEADER) Then
                  blnInSection = False
               End If
            End If
      
            If blnInSection Then
               strTempLines = AppendLineToString(strTempLines, strLine)
               strTempLines = AppendLineToString(strTempLines, CreateKeyValueLine(strKeyName, strValue, ""))
               blnEntryWritten = True
               blnInSection = False
               m_blnFileSaved = False
            Else
               strTempLines = AppendLineToString(strTempLines, strLine)
            End If
         Next

      Else
         Err.Raise 5002, , "No File Loaded"
      End IF

      If blnSectionExists = False Then
         strSectionName = Trim(strSectionName)
         strKeyName = Trim(strKeyName)
         strTempLines = strTempLines & vbCrLf
         strTempLines = AppendLineToString(strTempLines, "[" & strSectionName & "]")
         strTempLines = AppendLineToString(strTempLines, CreateKeyValueLine(strKeyName, strValue, ""))
      End If
   
      arrTempLines = Split(strTempLines, vbCrLf)
      m_arrLines = arrTempLines
      FileSaved = False
   End Sub

   
   '********************************************************************
   '* Sub AddTextLine()
   '*
   '* Purpose:  Writes a line of text to the beginning of an INI/INF file 
   '*           section.  No validation is done to see if this is
   '*           a duplicate of an existing line.
   '*
   '* Input:    strSectionName   Section name
   '*           strTextLine      Text to write
   '*
   '* Output:   Text line written to the file section
   '*
   '********************************************************************
   Sub AddTextLine(strSectionName, strTextLine)
      Dim arrTempLines
      Dim blnInSection
      Dim blnSectionExists
      Dim blnEntryWritten
      Dim i
      Dim strLine
      Dim strSectionNameEscaped
      Dim strRegexSection
      Dim strTempLines
   
      blnInSection = False
      blnSectionExists = False
      blnEntryWritten = False
   
      strSectionNameEscaped = RegExEscapeMetaCharacters(strSectionName)
      strRegexSection = "^\s*\[\s*" & strSectionNameEscaped & "\s*]"
      
      strTempLines = ""
      If FileLoaded Then
         For i = 0 to Ubound(m_arrLines)
            strLine = m_arrLines(i)

            If blnEntryWritten = False Then
               If RegExTest(strLine, strRegexSection) Then
                  blnSectionExists = True
                  blnInSection = True
               Elseif RegExTest(strLine, m_REGEX_INI_SECTION_HEADER) Then
                  blnInSection = False
               End If
            End If
      
            If blnInSection Then
               strTempLines = AppendLineToString(strTempLines, strLine)
               strTempLines = AppendLineToString(strTempLines, CreateTextLine(strTextLine))
               blnEntryWritten = True
               blnInSection = False
               m_blnFileSaved = False
            Else
               strTempLines = AppendLineToString(strTempLines, strLine)
            End If
         Next

      Else
         Err.Raise 5002, , "No File Loaded"
      End IF

      If blnSectionExists = False Then
         strSectionName = Trim(strSectionName)
         strTextLine = Trim(strTextLine)
         strTempLines = strTempLines & vbCrLf
         strTempLines = AppendLineToString(strTempLines, "[" & strSectionName & "]")
         strTempLines = AppendLineToString(strTempLines, CreateTextLine(strTextLine))
      End If
   
      arrTempLines = Split(strTempLines, vbCrLf)
      m_arrLines = arrTempLines
      FileSaved = False
   End Sub


   '********************************************************************
   '* Sub DeleteKey()
   '*
   '* Purpose:  Delete the first occurance of a Key in a section
   '*
   '* Input:    strSectionName   Section name
   '*           strKeyName       Key name
   '*
   '* Output:   Key deleted
   '*
   '********************************************************************
   Sub DeleteKey(strSectionName, strKeyName)
      Dim arrTempLines
      Dim blnInSection
      Dim blnSectionExists
      Dim blnKeyExists
      Dim blnEntryDeleted
      Dim i
      Dim strLine
      Dim strSectionNameEscaped
      Dim strKeyNameEscaped
      Dim strRegexSection
      Dim strRegexKey
      Dim strTempLines
   
      blnInSection = False
      blnSectionExists = False
      blnKeyExists = (ReadValue(strSectionName, strKeyName) <> "")
      blnEntryDeleted = False

      If blnKeyExists = False Then Exit Sub
   
      strSectionNameEscaped = RegExEscapeMetaCharacters(strSectionName)
      strKeyNameEscaped = RegExEscapeMetaCharacters(strKeyName)
      
      strRegexSection = "^\s*\[\s*" & strSectionNameEscaped & "\s*]"
      strRegexKey = "^\s*" & m_DOUBLE_QUOTE & "?" & strKeyNameEscaped & m_DOUBLE_QUOTE & "?" & "\s*=\s*"
   
      strTempLines = ""
      If FileLoaded Then
         For i = 0 to Ubound(m_arrLines)
            strLine = m_arrLines(i)

            If blnEntryDeleted = False Then
               If RegExTest(strLine, strRegexSection) Then
                  blnSectionExists = True
                  blnInSection = True
               Elseif RegExTest(strLine, m_REGEX_INI_SECTION_HEADER) Then
                  blnInSection = False
               End If
            End If
      
            If blnInSection Then
               If RegExTest(strLine, strRegexKey) Then
                  'write Nothing
                  blnEntryDeleted = True
                  blnInSection = False
               Else
                  strTempLines = AppendLineToString(strTempLines, strLine)
               End If
            Else
               strTempLines = AppendLineToString(strTempLines, strLine)
            End If
         Next
      Else
         Err.Raise 5002, , "No File Loaded"
      End IF
   
      arrTempLines = Split(strTempLines, vbCrLf)
      m_arrLines = arrTempLines
      FileSaved = False
   End Sub


   '********************************************************************
   '* Sub DeleteKeyAll()
   '*
   '* Purpose:  Delete all occurancea of a Key in a section
   '*
   '* Input:    strSectionName   Section name
   '*           strKeyName       Key name
   '*
   '* Output:   Keys deleted
   '*
   '********************************************************************
   Sub DeleteKeyAll(strSectionName, strKeyName)
      Dim arrTempLines
      Dim blnInSection
      Dim blnSectionExists
      Dim blnKeyExists
      Dim i
      Dim strLine
      Dim strSectionNameEscaped
      Dim strKeyNameEscaped
      Dim strRegexSection
      Dim strRegexKey
      Dim strTempLines
   
      blnInSection = False
      blnSectionExists = False
      blnKeyExists = (ReadValue(strSectionName, strKeyName) <> "")

      If blnKeyExists = False Then Exit Sub
   
      strSectionNameEscaped = RegExEscapeMetaCharacters(strSectionName)
      strKeyNameEscaped = RegExEscapeMetaCharacters(strKeyName)
      
      strRegexSection = "^\s*\[\s*" & strSectionNameEscaped & "\s*]"
      strRegexKey = "^\s*" & m_DOUBLE_QUOTE & "?" & strKeyNameEscaped & m_DOUBLE_QUOTE & "?" & "\s*=\s*"
   
      strTempLines = ""
      If FileLoaded Then
         For i = 0 to Ubound(m_arrLines)
            strLine = m_arrLines(i)

            If RegExTest(strLine, strRegexSection) Then
               blnSectionExists = True
               blnInSection = True
            Elseif RegExTest(strLine, m_REGEX_INI_SECTION_HEADER) Then
               blnInSection = False
            End If
      
            If blnInSection Then
               If RegExTest(strLine, strRegexKey) Then
                  'write Nothing
               Else
                  strTempLines = AppendLineToString(strTempLines, strLine)
               End If
            Else
               strTempLines = AppendLineToString(strTempLines, strLine)
            End If
         Next
      Else
         Err.Raise 5002, , "No File Loaded"
      End IF
   
      arrTempLines = Split(strTempLines, vbCrLf)
      m_arrLines = arrTempLines
      FileSaved = False
   End Sub


   '********************************************************************
   '* Sub DeleteSection()
   '*
   '* Purpose:  Deletes section of an INI file
   '*
   '* Input:    strSectionName   Section name
   '*
   '* Output:   Section deleted
   '*
   '********************************************************************
   Sub DeleteSection(strSectionName)
      Dim arrTempLines
      Dim blnInSection
      Dim blnSectionExists
      Dim i
      Dim strLine
      Dim strSectionNameEscaped
      Dim strRegexSection
      Dim strTempLines
   
      blnInSection = False
      blnSectionExists = False
   
      strSectionNameEscaped = RegExEscapeMetaCharacters(strSectionName)
      strRegexSection = "^\s*\[\s*" & strSectionNameEscaped & "\s*]"
   
      strTempLines = ""
      If FileLoaded Then
         For i = 0 to Ubound(m_arrLines)
            strLine = m_arrLines(i)

            If RegExTest(strLine, strRegexSection) Then
               blnSectionExists = True
               blnInSection = True
            Elseif RegExTest(strLine, m_REGEX_INI_SECTION_HEADER) Then
               blnInSection = False
            End If
      
            If blnInSection Then
               'write Nothing
            Else
               strTempLines = AppendLineToString(strTempLines, strLine)
            End If
         Next
      Else
         Err.Raise 5002, , "No File Loaded"
      End IF

      If blnSectionExists Then
         arrTempLines = Split(strTempLines, vbCrLf)
         m_arrLines = arrTempLines
         FileSaved = False
      End If
   End Sub


   '********************************************************************
   '*
   '* Function ExpandINFStringVariables()
   '*
   '* Purpose:  Expands String variables (entries found in the [Strings]
   '*           section of an INF file) in the input string
   '*
   '* Input:         strText             The input string
   '*
   '* Returns:       the expanded string
   '*
   '********************************************************************
   Function ExpandINFStringVariables(strText)
       Dim colMatches
       Dim objMatch
       Dim strExpandedString
       Dim strStringName
       Dim strEscapedMatch
       Dim strStringValue
      
       On Error Goto 0
       strExpandedString = strText
       If RegExTest(strText, "%.+?%") Then
          Set colMatches = RegExMatch(strText, "%.+?%")
          For Each objMatch in colMatches
             strStringName = RegExReplace(objMatch.Value, "%(.+?)%", "$1")
             strEscapedMatch = RegExEscapeMetaCharacters(objMatch.Value)
             strStringValue = ReadValue(m_strStringsSection, strStringName)
             strExpandedString = RegExReplace(strExpandedString, strEscapedMatch, strStringValue)
          Next
          ExpandINFStringVariables = strExpandedString
       Else
          ExpandINFStringVariables = strText
       End If
   End Function


   '********************************************************************
   '* Private Procedures
   '******************************************************************** 

   '********************************************************************
   '* Function RegExTest()
   '*
   '* Purpose:  Uses Regular Expressions to test for matching text in a String
   '*
   '* Inputs:   strInputString         Input String
   '*           strPattern             Regular Expression pattern
   '*
   '* Returns:  True if pattern exists in the input string, else False
   '*
   '********************************************************************
   Private Function RegExTest(strInputString, strPattern)
      m_regEx.Pattern = strPattern
      RegExTest = m_regEx.Test(strInputString)
   End Function


   '********************************************************************
   '* Function RegExReplace()
   '*
   '* Purpose:  Uses Regular Expressions to globally replace text in a 
   '*           String
   '*
   '* Input:    strInputString         Original String
   '*           strPattern             Regular Expression pattern
   '*           strReplacementString   Replacement text for the matched substrings
   '*
   '* Returns:  The modified String
   '*
   '********************************************************************
   Private Function RegExReplace(strInputString, strPattern, strReplacementString)
      m_regEx.Pattern = strPattern
      RegExReplace = m_regEx.Replace(strInputString, strReplacementString)
   End Function


   '********************************************************************
   '*
   '* Function RegExMatch()
   '*
   '* Purpose: Uses Regular Expressions to find matching text in a String
   '*
   '* Input:   strInputString         Original String
   '*          strPattern             Regular Expression pattern
   '*
   '* Returns: The Matches collection
   '*
   '* Note:    Since this method returns an object, it must be called
   '*          with a Set statement.  E.g.:
   '*
   '*          Set colMatches = RegExMatch("Test string", "Test")
   '*
   '********************************************************************
   Private Function RegExMatch(strInputString, strPattern)
      m_regEx.Pattern = strPattern
      Set RegExMatch = m_regEx.Execute(strInputString)
   End Function


   '********************************************************************
   '* Function RegExEscapeMetaCharacters()
   '*
   '* Purpose:  Uses Regular Expressions to escape metacharacters 
   '*           in a String
   '*
   '* Input:    strInputString         Original String
   '*
   '* Returns:  The escaped String
   '*
   '********************************************************************
   Private Function RegExEscapeMetaCharacters(strInputString)
      m_regEx.Global = True
      m_regEx.Pattern = "([\$\(\)\*\+\.\[\?\\\^\{\|])"
      RegExEscapeMetaCharacters = m_regEx.Replace(strInputString, "\$1")
      m_regEx.Global = False
   End Function


   '********************************************************************
   '* Function GetValue()
   '*
   '* Purpose: Gets the Value off the input line, trimming leading and 
   '*          trailing white space and double quotes
   '*
   '* Input:   strInputString         Original String
   '*
   '* Returns: the Value of a Key
   '*
   '********************************************************************
   Private Function GetValue(strInputString)
      GetValue = GetRegExSubMatch(strInputString, m_REGEX_INI_KEY_VALUE_LINE, "$2")
   End Function


   '********************************************************************
   '* Function GetKey()
   '*
   '* Purpose: Gets the Key off the input line, trimming leading and 
   '*          trailing white space and double quotes
   '*
   '* Input:   strInputString         Original String
   '*
   '* Returns: the Key name
   '*
   '********************************************************************
   Private Function GetKey(strInputString)
      GetKey = GetRegExSubMatch(strInputString, m_REGEX_INI_KEY_VALUE_LINE, "$1")
   End Function


   '********************************************************************
   '* Function GetInfLine()
   '* Purpose: Gets the INF-type text line, trimming leading and 
   '*          trailing white space and double quotes
   '*
   '* Input:   strInputString         Original String
   '*
   '* Returns: the text line
   '*
   '********************************************************************
   Private Function GetInfLine(strInputString)
      GetInfLine = GetRegExSubMatch(strInputString, m_REGEX_INF_LINE, "$1")
   End Function


   '********************************************************************
   '* Function GetCommentLine()
   '*
   '* Purpose: Gets the comment line, trimming leading and 
   '*          trailing white space and double quotes
   '*
   '* Input:   strInputString         Original String
   '*
   '* Returns: the comment line
   '*
   '********************************************************************
   Private Function GetCommentLine(strInputString)
      GetCommentLine = RegExReplace(strInputString, m_REGEX_INI_COMMENT_LINE, "$1")
   End Function


   '********************************************************************
   '*
   '* Function GetTrailingComment()
   '* Purpose: Gets the comment line, trimming leading and 
   '*          trailing white space and double quotes
   '*
   '* Input:   strInputString         Original String
   '*
   '* Returns: the comment line
   '*
   '********************************************************************
   Private Function GetTrailingComment(strInputString)
      GetTrailingComment = RegExReplace(strInputString, m_REGEX_TRAILING_COMMENT, "$2")
   End Function


   '********************************************************************
   '* Function GetRegExSubMatch()
   '*
   '* Purpose: Gets the submatch text, trimming leading and 
   '*          trailing white space and double quotes
   '*
   '* Input:   strInputString     Original String
   '*          strPattern         Regular Expressions pattern that contains
   '*                               a captured sub pattern(s)
   '*          strPattern         captured sub pattern index
   '*
   '* Returns: the text line
   '*
   '********************************************************************
   Private Function GetRegExSubMatch(strInputString, strPattern, strSubMatchIndex)
      Dim strSubMatch
      Dim strNoTrailingComment
      Dim strTrimmedLine
      Dim strTrimDoubleQuote
      strSubMatch = RegExReplace(strInputString, strPattern, strSubMatchIndex)
      strNoTrailingComment = RegExReplace(strSubMatch, m_REGEX_TRAILING_COMMENT, "$1")
      strTrimmedLine = RegExReplace(strNoTrailingComment, m_REGEX_WHITE_SPACE_PADDED_STRING, "$1")
      If RegExTest(strTrimmedLine, m_REGEX_m_DOUBLE_QUOTED_STRING) Then
         strTrimDoubleQuote = Mid(strTrimmedLine, 2, Len(strTrimmedLine) - 2)
         GetRegExSubMatch = strTrimDoubleQuote
      Else
         GetRegExSubMatch = strTrimmedLine
      End If
   End Function


   '********************************************************************
   '* Function CreateKeyValueLine()
   '*
   '* Purpose: Creates the Key/Value line string with the correct formating
   '*
   '* Input:   strKeyName          Key name
   '*          strValue            Value name
   '*          strTrailingComment  Trailing comment text
   '*
   '* Dependencies: Class properties SpaceEqualsSign, QuoteKeys, QuoteValues,
   '*               LeadingCharacter, and QtyLeadingCharacter 
   '*               (controls line formatting)
   '* 
   '* Returns: the formated string
   '*
   '* Subroutine write format bit flag constants:
   '*
   '*      INI_WRITE_FLAGS_SPACES_AROUND_EQUALS - Place spaces on either
   '*         side of the equals sign, e.g.:
   '*             Key = Value
   '*
   '*      INI_WRITE_FLAGS_KEY_QUOTES - Place double quotes around the
   '*         Key name, e.g.:
   '*             "Key"=Value
   '*
   '*      INI_WRITE_FLAGS_VALUE_QUOTES - Place double quotes around the
   '*         Value name, e.g.:
   '*             Key="Value"
   '*
   '*      Write format bit flags may be combined to get the desired
   '*      line format.  Default is no quotes or spaces around the 
   '*      equals sign when flags are not specified.
   '*
   '********************************************************************
   Private Function CreateKeyValueLine(strKeyName, strValue, strTrailingComment)
      Dim hexWriteFlags
      Dim i
      Dim strLeader
      Const INI_WRITE_FLAGS_SPACES_AROUND_EQUALS = &H1
      Const INI_WRITE_FLAGS_KEY_QUOTES = &H2
      Const INI_WRITE_FLAGS_VALUE_QUOTES = &H8
      
      hexWriteFlags = &H0
      If m_blnSpacesAroundEquals Then hexWriteFlags = hexWriteFlags + INI_WRITE_FLAGS_SPACES_AROUND_EQUALS
      If m_blnKeyDoubleQuotes Then hexWriteFlags = hexWriteFlags + INI_WRITE_FLAGS_KEY_QUOTES
      If m_blnValueDoubleQuotes Then hexWriteFlags = hexWriteFlags + INI_WRITE_FLAGS_VALUE_QUOTES
      
      strLeader = ""
      If m_strLeadingWhitespaceChar = "" Or m_intQtyLeadingWhitespaceChar = 0 Then
         'no leader
      Else
         For i = 1 To m_intQtyLeadingWhitespaceChar
            strLeader = strLeader & m_strLeadingWhitespaceChar
         Next
      End If
      
      Select Case hexWriteFlags
         Case &H0
            CreateKeyValueLine = strLeader & strKeyName & "=" & strValue & strTrailingComment
         Case INI_WRITE_FLAGS_SPACES_AROUND_EQUALS
            CreateKeyValueLine = strLeader & strKeyName & " = " & strValue & strTrailingComment
         Case INI_WRITE_FLAGS_KEY_QUOTES
            CreateKeyValueLine = strLeader & m_DOUBLE_QUOTE & strKeyName & m_DOUBLE_QUOTE & "=" & strValue & strTrailingComment
         Case INI_WRITE_FLAGS_VALUE_QUOTES
            CreateKeyValueLine = strLeader & strKeyName & "=" & m_DOUBLE_QUOTE & strValue & m_DOUBLE_QUOTE & strTrailingComment
         Case INI_WRITE_FLAGS_SPACES_AROUND_EQUALS + INI_WRITE_FLAGS_KEY_QUOTES
            CreateKeyValueLine = strLeader & m_DOUBLE_QUOTE & strKeyName & m_DOUBLE_QUOTE & " = " & strValue & strTrailingComment
         Case INI_WRITE_FLAGS_SPACES_AROUND_EQUALS + INI_WRITE_FLAGS_VALUE_QUOTES
            CreateKeyValueLine = strLeader & strKeyName & " = " & m_DOUBLE_QUOTE & strValue & m_DOUBLE_QUOTE & strTrailingComment
         Case INI_WRITE_FLAGS_SPACES_AROUND_EQUALS + INI_WRITE_FLAGS_KEY_QUOTES + INI_WRITE_FLAGS_VALUE_QUOTES
            CreateKeyValueLine = strLeader & m_DOUBLE_QUOTE & strKeyName & m_DOUBLE_QUOTE & " = " & m_DOUBLE_QUOTE & strValue & m_DOUBLE_QUOTE & strTrailingComment
         Case Else
            CreateKeyValueLine = strLeader & strKeyName & "=" & strValue & strTrailingComment
      End Select
   End Function


   '********************************************************************
   '* Function CreateTextLine()
   '*
   '* Purpose: Creates the text line stringe with the correct formating
   '*
   '* Input:   strLine         Line of text
   '*
   '* Dependencies: Class properties QuoteTextLines, LeadingCharacter,
   '*               and QtyLeadingCharacter (controls line formatting)
   '* 
   '* Returns: the formated string
   '*
   '********************************************************************
   Private Function CreateTextLine(strLine)
      Dim i
      Dim strLeader
      
      strLeader = ""
      If m_strLeadingWhitespaceChar = "" Or m_intQtyLeadingWhitespaceChar = 0 Then
         'no leader
      Else
         For i = 1 To m_intQtyLeadingWhitespaceChar
            strLeader = strLeader & m_strLeadingWhitespaceChar
         Next
      End If
      
      If m_blnTextDoubleQuotes Then
         CreateTextLine = strLeader & m_DOUBLE_QUOTE & strLine & m_DOUBLE_QUOTE
      Else
         CreateTextLine = strLeader & strLine
      End If
   End Function


   '********************************************************************
   '* Function AppendLineToString()
   '*
   '* Purpose: Appends a line to an existing string
   '*
   '* Input:   strInput        String to append to
   '*          strLine         Line of text to append to end of string
   '*
   '* Returns: the appended string
   '*
   '********************************************************************
   Private Function AppendLineToString(strInput, strLine)

      If strInput <> "" Then
         AppendLineToString = strInput & vbCrLf & strLine
      Else
         AppendLineToString = strLine
      End If
      
   End Function


    '********************************************************************
    '* Function DetectIfUnicodeTextFile()
    '*
    '* Purpose: Determine if a file is Unicode (UTF-16 Little Endian)
    '*
    '* Input:   sFile
    '*
    '* Returns: True if Unicode, False otherwise
    '*
    '* Dependencies: DetectTextEncoding Function
    '                m_objFSO - File System Object
    '********************************************************************
    Private Function DetectIfUnicodeTextFile(sFile)

        DetectIfUnicodeTextFile = False
        
        If not m_objFSO.FileExists(sFile) Then
            WScript.Echo "File path """ & sFile & """ not found."
            Exit Function
        End If

        If DetectTextEncoding(sFile) = 3 Then 
            DetectIfUnicodeTextFile = True
            m_blnIsUnicode = True
        End If

    End Function


    '********************************************************************
    '* Function DetectTextEncoding()
    '*
    '* Purpose: Detect the text encoding type of a file
    '*
    '* Input:   sFilePath
    '*
    '* Returns: Integer representing the encoding (zero if error)
    '*
    '* Dependencies: ConvertByteArrayToHexString Function
    '                m_objFSO - File System Object
    '********************************************************************
    Private Function DetectTextEncoding(sFilePath)

        Dim oStream
        Dim aWorkingBuffer
        Dim sHexString
        
        Const adTypeBinary = 1  'Indicates binary data.
        Const adTypeText = 2    'Default. Indicates text data, which is in the character set specified by Charset.

        Const Encoding_ASCII = 1
        Const Encoding_UTF8 = 2
        Const Encoding_UTF16_LittleEndian = 3
        Const Encoding_UTF16_BigEndian = 4
        Const Encoding_UTF32_LittleEndian = 5
        Const Encoding_UTF32_BigEndian = 6


        ' The Unicode byte order mark (BOM) is serialized as follows (in hexadecimal)
        Const BOM_UTF8 = "EFBBBF"
        Const BOM_UTF16_BigEndian = "FEFF"
        Const BOM_UTF16_LittleEndian = "FFFE"
        Const BOM_UTF32_BigEndian = "0000FEFF"
        Const BOM_UTF32_LittleEndian = "FFFE0000"

        DetectTextEncoding = 0

        If not m_objFSO.FileExists(sFilePath) Then
            WScript.Echo "File path """ & sFilePath & """ not found."
            Exit Function
        End If


        set oStream = CreateObject("ADODB.Stream")
        'oStr.CharSet = "windows-1252" ' code page of the inf files
        oStream.Open
        oStream.Type = adTypeBinary
        oStream.LoadFromFile sFilePath

        'Read first four bytes from the file
        aWorkingBuffer = oStream.Read(4)

        sHexString = ConvertByteArrayToHexString(aWorkingBuffer)

        If sHexString = BOM_UTF32_LittleEndian Then
            DetectTextEncoding = Encoding_UTF32_LittleEndian

        ElseIf sHexString = BOM_UTF32_BigEndian Then
            DetectTextEncoding = Encoding_UTF32_BigEndian

        ElseIf Left(sHexString, 4) = BOM_UTF16_LittleEndian Then
            DetectTextEncoding = Encoding_UTF16_LittleEndian

        ElseIf Left(sHexString, 4) = BOM_UTF16_BigEndian Then
            DetectTextEncoding = Encoding_UTF16_BigEndian

        ElseIf Left(sHexString, 6) = BOM_UTF8 Then
            DetectTextEncoding = Encoding_UTF8

        Else
            DetectTextEncoding = Encoding_ASCII

        End If

    End Function


    '********************************************************************
    '* ByteArray manipulator functions
    '*
    '* Purpose: Convert Byte Arrays to other forms
    '*
    '* Functions: ByteArrayToIntArray
    '*            ByteArrayToString
    '*            ByteArrayToHexString
    '*          
    '********************************************************************
    Private Function ByteArrayToIntArray(byteArray)
        dim aryReturn : aryReturn = array()
        dim iTemp
        
        if not isArray(byteArray) Then
            Exit Function
        end If
        
        for iTemp = 1 to ubound(byteArray) + 1
            redim preserve aryReturn(ubound(aryReturn) + 1)
            aryReturn(ubound(aryReturn)) = AscB(MidB(byteArray,iTemp,1))
        Next
        
        ByteArrayToIntArray = aryReturn    
    end Function

    Private function ByteArrayToString(byteArray)
        dim strReturnString : strReturnString = ""
        dim iTemp
        
        for iTemp = 1 to ubound(byteArray) + 1
            strReturnString = strReturnString & "\" & AscB(MidB(byteArray,iTemp,1))
        Next
        ByteArrayToString = strReturnString
    end Function

    Private function ByteArrayToHexString(byteArray)
        dim strReturnString : strReturnString = ""
        dim iTemp
        
        for iTemp = 1 to ubound(byteArray) + 1
            strReturnString = strReturnString & Hex(AscB(MidB(byteArray,iTemp,1)))
        Next
        ByteArrayToHexString = strReturnString
    end Function


    '********************************************************************
    '* Function ConvertByteArrayToString()
    '*
    '* Purpose: Convert byte array from AD to String
    '*
    '* Input:   byteArray
    '*
    '* Returns: String representation
    '*
    '* Dependencies: ByteArrayManipulator Class
    '********************************************************************
    Private Function ConvertByteArrayToString(byteArray)
        ConvertByteArrayToString = ByteArrayToString(byteArray)
    End Function


    '********************************************************************
    '* Function ConvertByteArrayToHexString()
    '*
    '* Purpose: Convert byte array from AD to Hex String
    '*
    '* Input:   byteArray
    '*
    '* Returns: Hex String representation
    '*
    '* Dependencies: ByteArrayManipulator Class
    '********************************************************************
    Private Function ConvertByteArrayToHexString(byteArray)
        ConvertByteArrayToHexString = ByteArrayToHexString(byteArray)
    End Function

End Class


'********************************************************************
'*
'* Sub ShowUsage()
'*
'* Purpose:   Shows the correct usage to the user.
'*
'* Input:     None
'*
'* Output:    Help messages are displayed on screen.
'*
'********************************************************************
Sub ShowUsage()
    WScript.Echo "VBScript to read and write information from INI files."
    WScript.Echo ""
    WScript.Echo ""
    WScript.Echo "Usage: cscript IniCommand.vbs [options]"
    WScript.Echo ""
    WScript.Echo "Options:"
    WScript.Echo ""
    WScript.Echo " /cmd:<command name>      Action to perform on the INI file.  The"
    WScript.Echo "                          supported commands listed below."
    WScript.Echo ""
    WScript.Echo " /file:""<INI file path>"""
    WScript.Echo "                          Path to the INI file."
    WScript.Echo ""
    WScript.Echo " /section:""<section name>"""
    WScript.Echo "                          INI file section name.  (Required for the all"
    WScript.Echo "                          commands except ReadSectionNames.)"
    WScript.Echo ""
    WScript.Echo " /key:""<key name>""      INI section key name.  (Required for the ReadValue"
    WScript.Echo "                          ReadValueAll, WriteEntry, AddEntry, DeleteKey,"
    WScript.Echo "                          DeleteKeyAll commands.)"
    WScript.Echo ""
    WScript.Echo " /value:""<value data>""  INI key value data.  (Required for the WriteEntry,"
    WScript.Echo "                          AddEntry, and AddTextLine commands.)"
    WScript.Echo ""
    WScript.Echo " /quotekey                (Optional) Place double quotes around the Key name,"
    WScript.Echo "                          e.g.: ""Key""=Value"
    WScript.Echo ""
    WScript.Echo " /quotevalue              (Optional) Place double quotes around the Value data,"
    WScript.Echo "                          e.g.: Key=""Value"""
    WScript.Echo "                          For AddTextLine it double quotes the entire line."
    WScript.Echo ""
    WScript.Echo " /spaceequals             (Optional) Place spaces on either side of the equals"
    WScript.Echo "                          sign, e.g.: Key = Value"
    WScript.Echo ""
    WScript.Echo " /indentchar:<space or tab>"
    WScript.Echo "                          (Optional) Place leading characters (space or tab)"
    WScript.Echo "                          in front of the Key or text line (i.e. ""indent"""
    WScript.Echo "                          the line)"
    WScript.Echo ""
    WScript.Echo " /indentqty:<integer>     (Optional) Number of leading characters (space or tab)"
    WScript.Echo "                          in front of the Key or text line (i.e. ""indent"""
    WScript.Echo "                          the line)"
    WScript.Echo ""
    WScript.Echo " /showoptions             (Optional) Display the command line switch values"
    WScript.Echo ""
    WScript.Echo " /?                       (Optional) Displays this help text."
    WScript.Echo ""
    WScript.Echo ""
    WScript.Echo "Basic Commands:"
    WScript.Echo ""
    WScript.Echo " ReadValue          Read the Value for the first occurance "
    WScript.Echo "                       of a Key in an INI file section"
    WScript.Echo ""
    WScript.Echo " ReadKeyNames       Read all Key names in INI file Section"
    WScript.Echo ""
    WScript.Echo " ReadSectionNames   Read all Section Names in an INI file"
    WScript.Echo ""
    WScript.Echo " WriteEntry         Write a Key & Value entry to an INI "
    WScript.Echo "                      file section."
    WScript.Echo ""
    WScript.Echo "Additional Commands:"
    WScript.Echo ""
    WScript.Echo " ReadValueAll       Read all Values for a given Key name "
    WScript.Echo "                       in an INI file (i.e. if there are "
    WScript.Echo "                       duplicate Keys in a section)"
    WScript.Echo ""
    WScript.Echo " ReadKeyValueLines  Read all raw Key=Value lines in INI "
    WScript.Echo "                       file Section"
    WScript.Echo ""
    WScript.Echo " ReadKeyValuePairs  Read all Key/Value pairs in INI file"
    WScript.Echo "                       Section"
    WScript.Echo ""
    WScript.Echo " ReadInfLines       Read all INF-type lines (not Key=Value)"
    WScript.Echo "                       in INI/INF file Section"
    WScript.Echo ""
    WScript.Echo " ReadComments       Read all comment lines and trailing "
    WScript.Echo "                       comments in INI/INF file Section"
    WScript.Echo ""
    WScript.Echo " AddEntry           Add a Key & Value entry to an INI"
    WScript.Echo "                       section (does not validate if Key"
    WScript.Echo "                       exists and will not change existing"
    WScript.Echo "                       values with the same Key name)"
    WScript.Echo ""
    WScript.Echo " AddTextLine        Write a text line to the INI/INF file "
    WScript.Echo "                       section"
    WScript.Echo " "
    WScript.Echo " DeleteKey          Delete the Key for the first occurance "
    WScript.Echo "                       of a Key in an INI file section"
    WScript.Echo ""
    WScript.Echo " DeleteKeyAll       Delete all occurances of a Key in an "
    WScript.Echo "                       INI file section (i.e. if there are "
    WScript.Echo "                       duplicate Keys in a section)"
    WScript.Echo ""
    WScript.Echo " DeleteSection      Delete an INI file section"
    WScript.Echo ""
End Sub



		</script>
	</job>	
</package>

' DON'T PUT ANYTHING AFTER HERE ASSIDE FROM VB/HS Comments





