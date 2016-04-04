; This script builds the installer for Dynephant.
;--------------------------------
!ifndef VERSION
  !define VERSION $%VERSION%
!endif

; The name of the installer
Name "Dynephant"
Caption "Dynephant ${VERSION} Setup"
Icon Martin-Berube-Square-Animal-Elephant.ico

; The file to write
!ifdef OUTFILE
  OutFile "${OUTFILE}"
!else
  ;OutFile dynephant-${VERSION}-setup.exe
  OutFile dynephant-setup.exe
!endif

SetCompressor /SOLID lzma

InstType "Full"
InstType "No Source Files"

; The default installation directory
; NOT using $PROGRAMFILES to keep EXE portable and log files writable
; with just user privileges (without admin or power user)
InstallDir C:\dynephant

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
; Not using to keep EXE portable
;InstallDirRegKey HKLM "Software\Chuck_Renner\Dynephant" "Install_Dir"

; Request application privileges (admin needed to write registry HKLM)
RequestExecutionLevel user
; Set license page info
LicenseText License
LicenseData LICENSE
;--------------------------------
; Pages
Page license
Page components
Page directory
Page instfiles
UninstPage uninstConfirm
UninstPage instfiles
;--------------------------------
; The stuff to install
Section "Dynephant Common (Required)"
  SectionIn RO
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  ; Put license, readme, and example files there
  File LICENSE
  File README.md
  File update_foobar.dynv6.net.bat
  ; Write the installation path into the registry
  ; NOT using to keep EXE portable and installer working
  ; with just user privileges (without admin or power user)
  ;WriteRegStr HKLM SOFTWARE\Chuck_Renner\Dynephant "Install_Dir" "$INSTDIR"
  ; Write the uninstall keys for Windows
  ; NOT using to keep EXE portable and installer working
  ; with just user privileges (without admin or power user)
  ;WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Dynephant" "DisplayName" "NSIS Example2"
  ;WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Dynephant" "UninstallString" '"$INSTDIR\uninstall.exe"'
  ;WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Dynephant" "NoModify" 1
  ;WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Dynephant" "NoRepair" 1
  WriteUninstaller uninstall.exe
SectionEnd
; Optional sections (can be disabled by the user)
Section "Dynephant 64-bit (GUI and CLI)"
  SectionIn 1 2
  SetOutPath $INSTDIR
  File dynephant.exe
  File dynephant-cli.exe
  CreateShortCut "Update foobar.dynv6.net (64-bit).lnk" "$INSTDIR\dynephant.exe" "-6 -daemon=600 -host=foobar -token=randomtextforfoobarhere" "$INSTDIR\dynephant.exe" 0
SectionEnd
Section "Dynephant 32-bit (GUI and CLI)"
  SectionIn 1 2
  SetOutPath $INSTDIR
  File dynephant-x86.exe
  File dynephant-x86-cli.exe
  CreateShortCut "Update foobar.dynv6.net (32-bit).lnk" "$INSTDIR\dynephant-x86.exe" "-6 -daemon=600 -host=foobar -token=randomtextforfoobarhere" "$INSTDIR\dynephant-x86.exe" 0
SectionEnd
Section "Dynephant Source"
  SectionIn 1
  SetOutPath $INSTDIR
  File _build_all.bat
  File build_all.bat
  File dynephant.au3
  File dynephant.nsi
  File Martin-Berube-Square-Animal-Elephant.ico
SectionEnd
;Section "Start Menu Shortcuts"
;
;  CreateDirectory "$SMPROGRAMS\Dynephant"
;  CreateShortCut "$SMPROGRAMS\Dynephant\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
;  
;SectionEnd
;--------------------------------
; Uninstaller
Section "Uninstall"
  ; Remove registry keys
  ; NOT using to keep EXE portable and installer working
  ; with just user privileges (without admin or power user)
  ;DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Dynephant"
  ;DeleteRegKey HKLM SOFTWARE\Chuck_Renner\Dynephant

  ; Remove files and uninstaller
  Delete $INSTDIR\_build_all.bat
  Delete $INSTDIR\build_all.bat
  Delete $INSTDIR\dynephant.au3
  Delete $INSTDIR\dynephant.exe
  Delete $INSTDIR\dynephant.nsi
  Delete $INSTDIR\dynephant-cli.exe
  Delete $INSTDIR\dynephant-x86.exe
  Delete $INSTDIR\dynephant-x86-cli.exe
  Delete $INSTDIR\LICENSE
  Delete $INSTDIR\README.md
  Delete $INSTDIR\update_foobar.dynv6.net.bat
  Delete $INSTDIR\Martin-Berube-Square-Animal-Elephant.ico
  Delete $INSTDIR\uninstall.exe

  ; Remove shortcuts, if any
  Delete "$INSTDIR\*.lnk"
  ; NOT using to keep EXE portable and installer working
  ; with just user privileges (without admin or power user)
  ;Delete "$SMPROGRAMS\Dynephant\*.*"

  ; Remove directories used
  ;RMDir "$SMPROGRAMS\Dynephant"
  RMDir "$INSTDIR"
SectionEnd
