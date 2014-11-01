:WAEmBootEdit12
:: Review settings
set watext=Editing Profile: [%_tempBootSel%] %_tmpBoot_OrigProfName%~~^
Review proposed changes. Select 'Back' to make further changes, or 'Next' to save settings and return to the Boot settings Menu. 
set wabat=%TEMP%\wabat.bat
set wafile=Boots\{%_tempBootSel%} %_tmpBoot_dpsProfName%.txt
start /w wizapp FT
if errorlevel 2 goto :WAEmBootSettsEnd
if errorlevel 1 goto :WAEmBootEdit11
call %wabat%