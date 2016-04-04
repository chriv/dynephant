REM Set locations of Dynephant directory, AutoIt3 binary, AutoIt3Wrapper script,
REM the Windows 10 SDK signtool binary, and GnuWin32's sed utility binary below
SET DYNDIR=C:\dynephant
SET AI3="C:\Program Files (x86)\AutoIt3\AutoIt3.exe"
SET AI3W="C:\Program Files (x86)\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.au3"
SET SIGNTOOL=C:\SDK\Win\10\bin\x64\signtool.exe
SET SED=C:\GnuWin32\bin\sed.exe
SET MAKENSIS=C:\NSIS\makensis.exe
REM Set locations of Dynephant directory, AutoIt3 binary, AutoIt3Wrapper script,
REM the Windows 10 SDK signtool binary, and GnuWin32's sed utility binary above
SET TSURL=http://timestamp.digicert.com
SET INFILE=dynephant.au3
SET NEWINFILE="~buildme~tmp.au3"
SET X86_CLI=dynephant-x86-cli.exe
SET X86_GUI=dynephant-x86.exe
SET X64_CLI=dynephant-cli.exe
SET X64_GUI=dynephant.exe
SET NSI=dynephant.nsi
SET SETUP=dynephant-setup.exe
@REM Change to Dynephant script/build directory
IF NOT EXIST %DYNDIR% GOTO NODYNDIR
CD /D %DYNDIR%
IF EXIST %NEWINFILE% DEL %NEWINFILE%
IF NOT EXIST %AI3% GOTO NOAI3
IF NOT EXIST %AI3W% GOTO NOAI3W
IF NOT EXIST %SED% GOTO NOSED
@REM Use sed to update all version information in source file
%SED% -e "s/[0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}/%VERSION%/" -i %INFILE%
@REM Dump script to temp file, commenting out any post build processing specified in the original script file
@REM This is to prevent a possible infinitely spawning build loop
%SED% -e "s/^\(#AutoIt3Wrapper_Run_After=\)/;\1/i" %INFILE% > %NEWINFILE%
IF NOT EXIST %NEWINFILE% GOTO NONEWINFILE
@REM Run AutoIt3Wrapper script to build all 4 .exe files
%AI3% %AI3W% /in %NEWINFILE% /x86 /console /out %X86_CLI%
%AI3% %AI3W% /in %NEWINFILE% /x64 /console /out %X64_CLI%
%AI3% %AI3W% /in %NEWINFILE% /x86 /Gui /out %X86_GUI%
%AI3% %AI3W% /in %NEWINFILE% /x64 /Gui /out %X64_GUI%
IF NOT EXIST %NEWINFILE% GOTO NOSIGNTOOL
@REM Sign the .exe files and request a signed timestamp from an Internet timestamp server
@REM Requires Windows 10 SDK signtool
@REM (older versions of signtool don't support SHA256 and SHA1 is obsolete and not cryptographically valid anymore)
%SIGNTOOL% sign /a /v /fd sha256 /tr %TSURL% /td sha256 %X86_CLI% %X64_CLI% %X86_GUI% %X64_GUI%
:CONTINUENOSIGNTOOL
IF NOT EXIST %MAKENSIS% GOTO NOMAKENSIS
@REM Make setup
IF EXIST %NSI% %MAKENSIS% %NSI%
IF NOT EXIST %SETUP% GOTO END
IF NOT EXIST %SIGNTOOL% GOTO END
@REM Sign setup
%SIGNTOOL% sign /a /v /fd sha256 /tr %TSURL% /td sha256 %SETUP%
:CONTINUENOMAKENSIS
GOTO END
:NOSIGNTOOL
ECHO Warning: %SIGNTOOL% missing! Skipping signing .exe files...
GOTO CONTINUENOSIGNTOOL
:NOMAKENSIS
ECHO Warning: %MAKENSIS% missing! Skipping building installer...
GOTO CONTINUENOMAKENSIS
:NODYNDIR
ECHO Error: %DYNDIR% missing! Required location of dynephant.au3!
GOTO END
:NOAI3
ECHO Error: %AI3% missing! Required to run AutoIt3Wrapper.au3 script (to build .exe files)!
GOTO END
:NOAI3W
ECHO Error: %AI3W% missing! Required to build .exe files!
GOTO END
:NOSED
ECHO Error: %SED% missing! Required to prevent infinite build loop!
GOTO END
:NONEWINFILE
ECHO Error: %NEWINFILE% missing (failed to be created)! Nothing to do!
GOTO END
:END
@REM Delete temp file and clean up build environment
IF EXIST %NEWINFILE% DEL %NEWINFILE%
DEL sed??????
@SET DYNDIR=
@SET AI3=
@SET AI3W=
@SET SIGNTOOL=
@SET MAKENSIS=
@SET TSURL=
@SET INFILE=
@SET NEWINFILE=
@SET X86_CLI=
@SET X86_GUI=
@SET X64_CLI=
@SET X64_GUI=
@SET NSI=
@SET SETUP=
