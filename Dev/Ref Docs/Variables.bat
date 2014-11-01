:: PSXtra Variables:
:: ---------------------------------------------------------------------------
:CONSTANTS
:WizApp_Globals
watitle=PSXtra Admin Menu
wasig=PSXtra by stigzler
_waMenuMsg=Message to appear on Main Menu

:Other Globals
EmvoyPath - Path to main bat/exe
_log= append to any echo to write line to txt log. 
_EmuDirPath=%PSXtraPath%\Emulators
_GamesDirPath=%PSXtraPath%\Games 
_LogsDirPath=%PSXtraPath%\Logs
_SupportDirPath=%PSXtraPath%\Support
:: ---------------------------------------------------------------------------

:: ---------------------------------------------------------------------------
:From Command Line:
_cmdRomDir=Path sent by command line
_cmdFilename=Filename sent by command line - later dequoted
_cmdProfile=Profile sent by command line (superceeds defaults) > later dequted
_cmdDefEmu=Defualt Emulator sent by command line (superceeds defaults)
_cmdSpecGameName=Specified name to use for the game/Quicklaunch folder


:Provided to Admin Menu of Direct boot
_dpsProfNo=Boot Profile used
_dpsAutoGameName= Auto generated from filename and cleaned for illegal chars
_dpsSpecGameName= Taken from cmd line and Cleaned for illegal chars
_dpsCleanFilename=Cleaned filename used as Game Profile section headers (i.e. Key Field)

:: ---------------------------------------------------------------------------
:PROCESS_VARS

_cmdRawGameName=Raw Game name Derived from filename

:: ---------------------------------------------------------------------------
:ADMIN_VARIABLES 
_admRomDir= get from cmdDir or dpsRomDir (if no cmd) - DO NOT CHNAGE
_admFilename= get from _dpsCleanFilename
_admCleanFilename = from _dpsCleanFilename - used as key/section var in Games Profiles
>>>>>>>>>>><<<<<<<<<<<<
_admGameProfile = GameProfile index (section numbers)
>>>>>>>>>>><<<<<<<<<<<<
_admGameProfileKey = matches _gameKey
_admGameName:
::Initial - from boot - if cmdSpecG not _null use this, if null - use cmdAuto
:: Then from GameProf
_admEmuNo = psxtra, gameprof (number) then cmd
_admAlsoLaunch = inhereted from admin, modified in game
_admCmd=  inhereted from emu, mofified in game
_admDTuse= inhereted from emu, modified in game
_admFilename = full filename without quotes
_admEmuNo = Selected Emu number
_admHomeMsg= Msg to be displayed on home. 

:MENU_VARIABLES
:Settings
_tempb = global boot settings
_tempBootSel = selected boot profile during editing
_tmpBoot_OrigProfName - retains origninal name of profile whilst editing.
_tmpBoot_OrigEmuName - retains orig emu name
_tmpBoot_OrigDefEmu - retains orig emu number
_tmpBoot_OrigAlsoLaunch
_tmpBootB_dpsQAppOnGameQ (AND OTHERS) - boolean values
_tmpBoot_dpsQlaunchWaoutput
_tmpBoot_dpsEmuWaoutput
_tmpBoot_dpsAppWaoutput
_tmpBoot_dpsBooleansWaOutput

:INI_VARIABLES

:Emvoy.ini
_dpsProfName=Name of Profile
_dpsProfDesc=Description of the Profile. 
_dpsQLaunchDir=Path to the location of the 'Quicklaunch' files -that is unzipped and un-ecm'd.
_dpsPakkISOdir=Path to the PakkiISO folder. 
_dpsDTdir=Path to Daemon tools. 
_dpsDTexe=Name of the Daemon tools executable. 
_dpsZipDir=Path to the 7z.exe folder. 
_dpsRomDir=Path to your set of files - unprocessed - e.g. zipped or ecm'd
_dpsQLaunch=Default behaviour following game exiting regarding what to do with the Quicklaunch folder. Options: delete,ask,keep.
_dpsDefEmu=Default Emulator to use for booting games (Games.ini superceeds this) 
_dpsAlsoLaunch=Defines which other applications to load before processing game files or booting game.
_dpsQAppOnGameQ=Quit EmVoy when game quits? True/false. For example, if booting PSXtra from another front end, set to false so control is returned to the FE. 
_dpsSkipAdmin=Skip showing the admin menu. For e.g. select false for launching straight into game with default emulator and settings. 
_dpsShowCmd=Shows command window? True/false. 
_dpsLog=Create log file? True/false. 
_dpsLogHistory=Keep log file history? True/false
_dpsSkipZip=Skip the unzipping of files in the Rom Directory? true/false
_dpsSkipECM=Skip the process of 'un-ecming' the source files. 
_dpsSkipQLaunch=Cuts out making quicklaunch folder - for romsets already unzipped and processed. Note: When booting zipped roms - PSXtra checks to see if quicklaunch already exists and automatically boots from there if does. Don't use this option to set up using Q'launch folder. 
_dpsUserUpdate=Choose whether to display update messages to the user when processing source files. All time-out info boxes - no user interaction required. 

:Emulator.ini
_emuNo=0
_emuName=PCSX-R
_emuVers=1.9.93
_emuPath=C:\Emulators\pcsxr-1.9.93-win32\pcsxr
_emuExe=pcsxr.exe
_emuCmd=-nogui -runcd
_emuDTuse=yes
_emuVdrive=J:
_emuExts=img iso mdf ccd cue (array)
_emuUseSettsScirpt=yes
_emuSettsScirptPath=
_emuSettsScirptExe=
_emuUpdate=(date time)
_emuNotes=
_emuAlsoLaunch= array (e.g. Fraps, screencap)

:GameProf.ini
Primary Key = _admCleanFilename
_gamelFile=Wipeout XL [NTSC-U] [SCUS-94351].zip (use as key)
_gamePath= Futre Dev
_gameName=Wipeout XL (this used as key field)
_gameCmd=     (specific command line function)
_gameDTuse=True/False (game to use deamon tools?) def = emudef
_gameEmu=[number] Emu number from psxtra then cmd (cmd superceeds)
_gameAlsoLaunch=[array] inherited from psxtra and defemu, but modified. 
_gameMemCards=Future Dev
_gameUpdate=timestamp for update
:: ---------------------------------------------------------------------------

