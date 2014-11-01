echo off
setlocal enableextensions enabledelayedexpansion
echo ====================================================================================================
:: ======================================================
:: Passed variables - DO NOT CHANGE
set gamename=%1
set impexp=%2
set history=%3

::Passed variables validation
echo Validating passed variables:
echo Gamename=%gamename%
set gamename=%gamename:"=%
echo Ammended Gamename=%gamename%
echo Import or Export = %impexp%
set res=False
if %impexp% == imp set res=true
if %impexp% == exp set res=true
if %res% == true (
	echo Import Export switch valid
	) else (
		echo Import/Export switch Invalid! Stopping Script.
		exit )
		
echo Preserve History = %history%
set res=False
if %history% == y set res=true
if %history% == n set res=true
if %res% == true (
	echo HIstory switch valid
	) else (
		echo History switch Invalid! Stopping Script.
		exit )
		
		
:: ========================================================
:: Global Variables
set timestamp=%DATE:/=-%@%TIME::=-%
set timestamp=%timestamp: =%
set filenamegb=Default
set filenamepb=Default

setlocal enabledelayedexpansion
(set check="œ" "^" "&" "$" "%%" "(" ")" "_" "-" "+" "^~" "|" "\" "<" ">" "." ";" "@" "'" "#" "{" "}" "[" "]")
:: =====================================================
:: User Variables - SET HERE!

:: Path pcsxr game settings folder:
set settpath=C:\GameEx\AHKS_BATS\Launchers\psx\PSXtra\Emu Settings\pcsxr

:: ========================================================

:: ========================================================
:: Code ----------------------------------------------
echo ====================================================================================================
Echo ** Choosing Export or Import:
If %impexp% == imp (
	echo ** Start Import Process
	call :ImportSettings
	echo ** Settings Imported!	)



	
Exit
	
:: ======================================================
:: Subroutines

:ImportSettings
:: Create/set folders for game
%settpath:~0,2%
cd %settpath%
echo *** Lining up Game folder...
if exist "%gamename%" (
	echo *** Game folder already exists - selecting directory
	cd "%gamename%"
	) else (
	echo *** Creating new game folder and selecting directory
	mkdir "%gamename%"
	cd "%gamename%")
:: Set up filenames for general and plugin settings:
echo *** Constructing filenames....
set filenameg="%gamename%_general.reg"
set filenamep="%gamename%_plugins.reg"
echo *** General Settings Filename: %filenameg%
echo *** Plugin Settings Filename: %filenamep%

:: if history required:
echo *** User History request- history flag is "%history%"

:: Start of long if.---------------------------------------------------------
if "%history%" == "y" (
	:: setup folders + backup files
	echo **** User requiring backups - setup folders...
	if exist backup (
		echo **** Game settings backup folder already exists
	) else (
		echo **** Game settings backup folder does not exist - creating new backup folder
		mkdir backup )
	set filenamegb="%gamename%_general_%timestamp%.reg"
	set filenamepb="%gamename%_plugins_%timestamp%.reg"
	echo **** Setting backup filenames:
	echo **** new General Settings Backup Filename: !filenamegb!
	echo **** new Plugin Settings Backup Filename: !filenamepb!
	:: test if any file to back up and do it
	if exist %filenameg% (
		echo **** Files exist to be backed up
		echo **** backing up files:
		copy /y %filenameg% backup\!filenamegb!
		copy /y %filenamep% backup\!filenamepb!
	) else (
		echo **** No existing files to backup )

) else (
	:: No history required
	echo **** User not requiring History )
:: End IF ----------------------------------------------------------

:: Read reg values and save to files
echo *** Creating new Settings files...
echo *** Registry settings being grabbed:
regedit /E "%filenameg:"=%" "HKEY_CURRENT_USER\Software\Pcsxr"
regedit /E "%filenamep:"=%" "HKEY_CURRENT_USER\Software\Vision Thing"
echo *** Reg settings grabbed and files written.


echo *** Ending Import Settings Routine
GOTO :EOF

:ExportSettings

GOTO :EOF
:: ========================================================

