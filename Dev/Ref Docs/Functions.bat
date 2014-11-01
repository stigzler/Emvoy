"FUNCTIONS GUIDE"
:: -------------------------------------------------------------------------------------------------------------------------------------------------------
:IniCmd 
call IniCmd /m [mode] /f [inifile] /s [section] /k [key] /v [value] /t [output txt file] 
cscript //nologo "%~f0?.wsf" //job:IniCommand /cmd:WriteEntry /section:"%section%" /key:"%key%" /value:"%value%" /file:"%inifile%"
:: write (/s)/k/v/f - writes value to key
:: read- /s/k/v/f - returns value via IniCmd
 :: delsec - deletes a section - returns error code
 :: count - counts number of sections in a file - returns via [IniCmd]
 :: list - Arrays list of section into IniCmd. E.g. IniCmd[1]=apples, IniCmd[2]=pears. NB IniCmd[0] contains the count. 
 :: Call example: call :iniedit m/ write /s PSX /k "_EmuPath" /v "C:\Emulators and Frontends\Psxtra\Emulators" /f emulators.ini
 :: Use quotes around vars with spaces - no need to dequote
 :: -------------------------------------------------------------------------------------------------------------------------------------------------------
 
 :_FreeRecordNo [ini]
:: Returns the lowest available record number
 
 :LoadIni [section] [file]
 
 :CreateGameROMList [filepath] [GamePList name]
 
 :LoadTempIni [section] [file] [prefix]
 :: Prefix sets vars in ini:
:: eg. _tmpBoot_dpsDefEmu

 :DeQuote [variable name]
 variable de-quoted in environment
 
:WriteIni [template] [section name] [file]
:: Writes to ini specified in file with default vars spec in template section - using new [section name]

: GetNumberString [string] 
:: Pass any mixed string, numbers will be extracted and separated by a comma

:CreateSelectionList [Ini] [IniKey] [ListFile]
:: Creates a list file, contents depending on parameters
:: 1 - IniFile to use 
:: 2 - Key for additional info to section name
:: 3 - relative path and file of listfile to create

:WAEmSel [message] [bmp] [ListFile] [VarToSet]
:: 1 - message to display
:: 2 - relative path and file of bitmap to display 
:: 3 - relative path and file of listfile to use
:: 4 - the name of the variable to set

:DeleteRecord [ini] [section] [inilist] [trash] 
:: Required [ini] [section] - ini + section to be deleted
:: Optional: 	[inilist] - delete line from selection list based on section
:: 				[trash] - use a keyname within record set - creates trash file. 
:: e.g. call ::DeleteRecord Emulators\Emulators.ini 5 _emuName Emulators\EmulatorList.ini

:CopyRecord [ini] [section] [ckey] [cvaluetype] [cvalue]
:: Copies specified record to new record using lowest available section number as key
:: Able to modify one key/value pairing to reflect copy
:: [ini] - file
:: [section] section to copy
:: [ckey] key value to change in new copied record 
:: [cvaluetype] prefix,append or replace key value
:: [cvalue] value to use in change
 