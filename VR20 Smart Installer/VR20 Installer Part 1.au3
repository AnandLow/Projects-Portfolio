#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\Users\hong-ren.anand-low\Downloads\Icon for installer.ico
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <file.au3>
#include <MsgBoxConstants.au3>
#include <FileConstants.au3>
#include <file.au3>
#include <MsgBoxConstants.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ScreenCapture.au3>
#include <StringConstants.au3>
#include <Misc.au3>
#include <_XMLDomWrapper.au3>
#include <Date.au3>

AutoItSetOption ('MouseCoordMode', 0)
AutoItSetOption ('SendKeyDelay', 1)
AutoItSetOption('WinTitleMatchMode',2)
Opt("WinTitleMatchMode",2)

;************************************************* Variables *************************************************************************************
$sProgress = "VR20 Smart Installer Progress"
$sFileName = @ScriptDir &"\UpdatePortal.txt"
Global $sVTHAL = FileReadLine($sFileName,1)
Global $sSoftLight = FileReadLine($sFileName,2)
Global $sAutoShutDown = FileReadLine($sFileName,3)
Global $sVGuardian = FileReadLine($sFileName,4)
Global $sVR20_V4 = FileReadLine($sFileName,5)
Global $sVVS_V4 = FileReadLine($sFileName,6)
Global $intVision = Int(0)
Global $interror = Int(0)
Global $intVsTS = Int(1)
Global $intVsCT = Int(1)
Global $intVsMP = Int(1)
Global $intVsMLP = Int(1)

; ********************************************* Pause and Exit ************************************************************
Global $Paused
HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{ESC}", "Terminate")

Func TogglePause()
	$Paused = NOT $Paused
	While $Paused
		Sleep(100)
		ToolTip("Installer is paused.",0,0)
	WEnd
	ToolTip("")
EndFunc

Func Terminate()
	Exit 0
EndFunc


;************************************************ GUI *****************************************************************************************
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=c:\users\hong-ren.anand-low\downloads\koda_1.7.3.0\forms\anand vr20 smart installer part 1.kxf
$Form1_1 = GUICreate("VR20 Smart Installer Part 1", 479, 294, -1, -1)
GUISetFont(14, 800, 0, "MS Sans Serif")
GUISetBkColor(0xD7E4F2)
$Label1 = GUICtrlCreateLabel("", 152, 48, 4, 4)
Global $Label2 = GUICtrlCreateLabel("Enter Machine ID:", 168, 128, 160, 29)
GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")
Global $Input = GUICtrlCreateInput("", 104, 176, 289, 33)
GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")
$Button1 = GUICtrlCreateButton("Start ", 144, 232, 185, 33, $BS_DEFPUSHBUTTON)
$Label3 = GUICtrlCreateLabel("VR20 Smart Installer Pt. 1", 120, 32, 238, 28)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###



;Create a text file to record the process
Global $progressfile = @DesktopDir & "\INCOMPLETE Installation & Setup.txt"
If FileExists($progressfile) Then
   FileDelete(@DesktopDir &"\Smart Installer Progress.txt")
EndIf
$Filehandle = FileOpen($progressfile, $FO_OVERWRITE) ; open a new one and write again
FileWrite($Filehandle, "Smart Installer Progress:")
FileWrite($Filehandle, @CRLF &"---------------------------------")

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $Button1
			ErrorCheck()
			If $interror = Int(0) Then
			   WinMinimizeAll()
			   WinClose("VR20 Smart Installer Part 1")
			   GUISetState(@SW_MINIMIZE)
			   Global $MachineID = GUICtrlRead($Input)
			   $intVsTS = Int(1)
			   $intVsCT = Int(1)
			   $intVsMP = Int(1)
			   $intVsMLP = Int(1)
               SplashTextOn("Message", "Mouse will be moved automatically. Don't touch or move the mouse until further notice.", 400, 120, 500, 300, $DLG_TEXTLEFT, "", 16)
               Sleep(2500)
               SplashOff()





               ; Batch 1
			   VTHAL() ;1) SCF05140rev043 VTHAL 5p0.0.0
			   SoftLight() ;2) SCF04079rev028 SoftLight 1.6.1.5
			   AutoShutDown() ;3) SCF05141rev003 AutoShutDown 1.3.3.1
			   VGuardian() ;4) SCF06005rev006 VGuardian 1.2.3.2
				VR20_V4() ;5) SCF18002rev000 VR20_V4-4.7.1.28
			  VVS_V4() ;6) SCF15001rev014 VVS-V4 4.7.0.69.exe
			   Change_PC_Name()

			   ProgressSet(50, "50%", "Part 1 Installation Complete!")
			   Sleep(1000)
			   ProgressOff()

				SplashTextOn("Message", "Part 1 Installation is completed. PC will restart now. After restart please run VR20 Smart Installer Part 2.", 400, 120, 500, 300, $DLG_TEXTLEFT, "", 16)
				Sleep(2500)
				SplashOff()



			   Shutdown(6)
			EndIf

	EndSwitch
WEnd









;*********************************************** Functions****************************************************************************************
; Verify COM Port
Func VerifyCOMPort()
   ShellExecute("devmgmt.msc")
   WinWait("Device Manager")
   WinActivate("Device Manager")
   Sleep(500)
   ShellExecute(@ScriptDir & "\VerifyComPort.png")
   Sleep(1000)
   MsgBox($MB_ICONINFORMATION,"Message","Please verify the blue COM ports in Device Manager before proceeding to installation.")
   Sleep(2000)
   WinClose("VerifyComPort.png")
   FileWrite($Filehandle, @CRLF &"- Verify Com Port (DONE)")
EndFunc

; Check whether installation files available
Func ErrorCheck()
	$interror = Int (0)
	$sArray = _FileListToArray(@ScriptDir, "*",1)
	$sSearch1 = _ArraySearch($sArray, $sVTHAL)
	If @error Then
		MsgBox($MB_SYSTEMMODAL, "Warning", $sVTHAL & " not found, please check again")
		$interror = Int(1)
	EndIf
	$sSearch2 = _ArraySearch($sArray, $sSoftLight)
	If @error Then
		MsgBox($MB_ICONINFORMATION,"Warning",$sSoftLight & " not found, please check again!")
		$interror = Int(1)
	EndIf

	$sSearch3 = _ArraySearch($sArray, $sAutoShutDown)
	If @error Then
		MsgBox($MB_ICONINFORMATION, "Warning",$sAutoShutDown & " not found, please check again!")
		$interror = Int(1)
	EndIf

	$sSearch4 = _ArraySearch($sArray, $sVGuardian)
	If @error Then
		MsgBox($MB_ICONINFORMATION, "Warning",$sVGuardian & " not found, please check again!")
		$interror = Int(1)
	EndIf

	$sSearch5 = _ArraySearch($sArray, $sVR20_V4)
	If @error Then
		MsgBox($MB_ICONINFORMATION, "Warning",$sVR20_V4 & " not found, please check again!")
		$interror = Int(1)
	EndIf

	$sSearch6 = _ArraySearch($sArray, $sVVS_V4)
	If @error Then
		MsgBox($MB_ICONINFORMATION, "Warning",$sVVS_V4 & " not found, please check again!")
		$interror = Int(1)
	EndIf
EndFunc


;1. Vitrox Hardware Abstraction Layer
Func VTHAL()
	FileWrite($Filehandle, @CRLF &"- Installing VTHAL")
	ProgressOn($sProgress, "Installing VTHAL ...", "8%",8 ,8, BitOR($DLG_NOTONTOP, $DLG_MOVEABLE))
	ProgressSet(8, "8%", "Installing VTHAL.....")
	Sleep(300)
	ShellExecute(@ScriptDir & '\' & $sVTHAL)
	WinWait('ViTrox Hardware Abstraction Layer','Welcome to the ViTrox Hardware Abstraction Layer Setup Wizard')
	WinActivate('ViTrox Hardware Abstraction Layer')
	Sleep(100)
	ControlClick('ViTrox Hardware Abstraction Layer','','Button1')
	WinWait('ViTrox Hardware Abstraction Layer','VITROX TECHNOLOGIES')
	WinActivate('ViTrox Hardware Abstraction Layer')
	Sleep(100)
	ControlCommand('ViTrox Hardware Abstraction Layer','','Button3','Check')
	WinWait('ViTrox Hardware Abstraction Layer','VITROX TECHNOLOGIES')
	WinActivate('ViTrox Hardware Abstraction Layer')
	Sleep(100)
	ControlClick('ViTrox Hardware Abstraction Layer','','Button6')
	WinWait('ViTrox Hardware Abstraction Layer','VTHAL version')
	WinActivate('ViTrox Hardware Abstraction Layer')
	Sleep(100)
	ControlClick('ViTrox Hardware Abstraction Layer','','Button1')
	WinWait('ViTrox Hardware Abstraction Layer','MsiRadioButtonGroup')
	WinActivate('ViTrox Hardware Abstraction Layer')
	Sleep(100)
	ControlCommand('ViTrox Hardware Abstraction Layer','','Button4','Check')
	Sleep(100)
	ControlClick('ViTrox Hardware Abstraction Layer','','Button1')
	WinWait('ViTrox Hardware Abstraction Layer','The installer is ready to install ViTrox Hardware Abstraction Layer on your computer.')
	WinActivate('ViTrox Hardware Abstraction Layer')
	Sleep(100)
	ControlClick('ViTrox Hardware Abstraction Layer','','Button1')
	WinWait('ViTrox Hardware Abstraction Layer','Installation Complete')
	WinActivate('ViTrox Hardware Abstraction Layer')
	Sleep(100)
	ControlClick('ViTrox Hardware Abstraction Layer','','Button1')
	Sleep(100)
	FileWrite($Filehandle, @CRLF &"- Installing VTHAL (DONE)")
EndFunc

;2. Softlight
Func SoftLight()
    FileWrite($Filehandle, @CRLF &"- Installing Softlight")
	ProgressSet(16, "16%", "Installing Softlight ..." )
	Sleep(300)
	Run(@ScriptDir & '\' & $sSoftLight)
	WinWait('ViTrox SoftLight ','VITROX TECHNOLOGIES')
	WinActivate('ViTrox SoftLight')
	Sleep(100)
	ControlClick('ViTrox SoftLight','','Button2')
	WinWait('ViTrox SoftLight','This will install ViTrox SoftLight on your computer. Choose a directory')
	WinActivate('ViTrox SoftLight')
	Sleep(100)
	ControlClick('ViTrox SoftLight','','Button2')
	WinWait('ViTrox SoftLight','Completed')
	WinActivate('ViTrox SoftLight')
	Sleep(100)
	ControlClick('ViTrox SoftLight','','Button2')
	Sleep(100)
	FileWrite($Filehandle, @CRLF &"- Installing Softlight (DONE)")
EndFunc

;3. Auto Shut Down
Func AutoShutDown()
    FileWrite($Filehandle, @CRLF &"- Installing AutoShutDown")
	ProgressSet(25, "25%", "Installing AutoShutDown ...")
	Sleep(300)
	Run(@ScriptDir & '\' & $sAutoShutDown)
	WinWait('Setup - AutoShutDown','Welcome to the AutoShutDown Setup Wizard')
	WinActivate('Setup - AutoShutDown')
	Sleep(100)
	Send ('{HOME}{SPACE}')
	WinWait('Setup - AutoShutDown','Please select platform to be used.')
	WinActivate('Setup - AutoShutDown')
	Sleep(100)
	Send ('{HOME}{DOWN}{SPACE}')
	Sleep(300)
	Send ('{TAB}{TAB}{SPACE}')
	WinWait('Setup - AutoShutDown','Select Destination Location')
	WinActivate('Setup - AutoShutDown')
	Sleep(100)
	Send ('{HOME}{TAB}')
	Sleep(300)
	Send ('{TAB}{TAB}')
	Sleep(300)
	Send ('{SPACE}')
	Sleep(300)
	WinWait('Setup - AutoShutDown','Ready to Install')
	WinActivate('Setup - AutoShutDown')
	Sleep(100)
	Send ('{SPACE}')
	Sleep(300)
	WinWait('Setup - AutoShutDown','Completing the AutoShutDown Setup Wizard')
	WinActivate('Setup - AutoShutDown')
	Sleep(100)
	ControlCommand('Setup - AutoShutDown','','Button1','Check')
	Send ('{DOWN}{TAB}')
	Sleep(300)
	Send ('{SPACE}')
	Sleep(100)
	FileWrite($Filehandle, @CRLF &"- Installing AutoShutDown (DONE)")
EndFunc

;4. VGuardian
Func VGuardian()
    FileWrite($Filehandle, @CRLF &"- Installing VGuardian")
	ProgressSet(33, "33%", "Installing VGuardian ...")
	Sleep(300)
	Run(@ScriptDir & '\' & $sVGuardian)
	WinWait('Welcome','Welcome to the VGuardian Setup program.')
	WinActivate('Welcome')
	Sleep(100)
	ControlClick('Welcome','','Button1')
	WinWait('Choose Destination Location','Setup will install VGuardian in the following folder.')
	WinActivate('Choose Destination Location')
	Sleep(100)
	ControlClick('Choose Destination Location','','Button1')
	WinWait('Setup Complete','Setup has finished copying files to your computer.')
	WinActivate('Setup Complete')
	Sleep(100)
	Send ('{DOWN}')
	Sleep(300)
	Send ('{TAB}{SPACE}')
	Sleep(100)
	FileWrite($Filehandle, @CRLF &"- Installing VGuardian (DONE)")
EndFunc

;5. VR20_V4 Post Seal Vision Handler
Func VR20_V4()
	FileWrite($Filehandle, @CRLF &"- Installing VR20 V4 software")
	ProgressSet(40, "40%", "Installing VR20 V4 software ...")
	Sleep(300)
	Run(@ScriptDir & '\' & $sVR20_V4)
	WinWait('Setup - V4','Welcome to the V4 Setup Wizard')
	WinActivate('Setup - V4')
	Sleep(100)
	Send ('{HOME}{SPACE}')
	Sleep(300)
	WinWait('Setup - V4','Information')
	WinActivate('Setup - V4')
	Send ('{TAB}{TAB}')
	Sleep(300)
	Send ('{SPACE}')
	Sleep(300)
	WinWait('Setup - V4','Select Destination Location')
	WinActivate('Setup - V4')
	Send ('{TAB}{TAB}{TAB}')
	Sleep(300)
	Send ('{SPACE}')
	Sleep(300)
	WinWait('Setup - V4','Select Components')
	WinActivate('Setup - V4')
	Send ('{TAB}{TAB}')
	Sleep(300)
	Send ('{SPACE}')
	Sleep(300)
	WinWait('Setup - V4','Select Start Menu Folder')
	WinActivate('Setup - V4')
	Send ('{TAB}')
	Sleep(100)
	Send ('{TAB}')
	Sleep(100)
	Send ('{TAB}')
	Sleep(100)
	Send ('{SPACE}')
	Sleep(300)
	WinWait('Setup - V4','Select Additional Tasks')
	WinActivate('Setup - V4')
	Send ('{TAB}{TAB}')
	Sleep(300)
	Send ('{SPACE}')
	Sleep(300)
	WinWait('Setup - V4','Ready to Install')
	WinActivate('Setup - V4')
	Send ('{SPACE}')
	Sleep(300)
	WinWait('Setup - V4','Completing the V4 Setup Wizard')
	WinActivate('Setup - V4')
	Send ('{TAB}{TAB}')
	Send ('{TAB}')
	Sleep(300)
	Send ('{SPACE}')
	Sleep(100)
	WinClose("[CLASS:Notepad]")
	FileWrite($Filehandle, @CRLF &"- Installing VR20 V4 software (DONE)")
EndFunc

;6. VVS
Func VVS_V4()
	FileWrite($Filehandle, @CRLF &"- Installing VVS V4 ")
	ProgressSet(45, "45%", "Installing VVS V4 visions ...")
	Sleep(300)
	Run(@ScriptDir & '\' & $sVVS_V4)
	WinWait('Setup - VVS-V4','Please select software to be installed.')
	WinActivate('Setup - VVS-V4')

	$intVision += Int(1)
	Send('{Home}') ; VsCT
	Sleep(100)

	For $count = 1 To 13
		Send('{DOWN}{DOWN}')
		Sleep(100)

	Next
	Send('{SPACE}')
	Sleep(100)



	$intVision += Int(1)
	Send('{Home}') ; VsMP
	Sleep(100)

	For $count = 1 To 4
		Send('{DOWN}{DOWN}')
		Sleep(100)
	Next
	Send('{SPACE}')
	Sleep(100)



	$intVision += Int(1)
	Send('{Home}') ; VsML
	Sleep(100)
	For $count = 1 To 9
		Send('{DOWN}')
		Sleep(100)
	Next
	Send('{SPACE}')
	Sleep(100)


	$intVision += Int(1)
	Send('{Home}') ; VsTS
	Sleep(100)
	For $count = 1 To 12
		Send('{DOWN}{DOWN}')
		Sleep(100)
	Next
	Send('{SPACE}')
	Sleep(100)

	Sleep(300)
	Send ('{TAB}{SPACE}')
	WinWait('Setup - VVS-V4','Multiple Vision')
	WinActivate('Setup - VVS-V4')
	Send ('{TAB}')
	Sleep(100)
	Send ('{TAB}')
	Sleep(100)
	Send ('{SPACE}')
	WinWait('Setup - VVS-V4','Select Destination Location')
	WinActivate('Setup - VVS-V4')
	Send ('{TAB}')
	Sleep(100)
	Send ('{TAB}')
	Sleep(100)
	Send ('{TAB}')
	Sleep(100)
	Send ('{SPACE}')
	WinWait('Folder Exists','The folder:')
	WinActivate('Folder Exists')
	Sleep(100)
	Send ('{SPACE}')
	WinWait('Setup - VVS-V4','Ready to Install')
	WinActivate('Setup - VVS-V4')
	Sleep(100)
	Send ('{SPACE}')
	WinWait('Setup - VVS-V4','Completing the VVS-V4 Setup')
	WinActivate('Setup - VVS-V4')
	Sleep(100)
	Send ('{SPACE}')
	WinMinimizeAll()
	WinClose("[CLASS:Notepad]")
	FileWrite($Filehandle, @CRLF &"- Installing VVS V4 (DONE) ")
EndFunc

;7 Change PC Name
Func Change_PC_Name()
	FileWrite($Filehandle, @CRLF &"- Changing PC Name")
   ProgressSet(47, "47%", "Change PC Name ")
    Sleep(300)
    Run("control sysdm.cpl")
    WinWait("System Properties")
   WinActivate("System Properties")
   Sleep(300)
    Send('{BACKSPACE}')
    Send($MachineID)
    Sleep(300)
    ControlClick("System Properties", "&Apply", 12321)
    ControlClick("System Properties", "OK", 1)


   Sleep(300)
   Send("#r")
	WinWait("Run")
	WinActivate("Run")
	Send("{BACKSPACE}")
	Send("ms-settings:about")
	ControlClick("Run", "OK", 1)
	Sleep(300)
	WinWait("Settings")
	WinActivate("Settings")
	BlockInput($BI_DISABLE)
	Send('{TAB 4} {ENTER}')
   Sleep(300)
   BlockInput($BI_ENABLE)
   Send($MachineID)
   Send('{ENTER}')
   Sleep(300)
   Send('{TAB}')
   Send('{ENTER}')

   FileWrite($Filehandle, @CRLF &"- Changing PC Name (DONE)")
   FileClose($Filehandle)

EndFunc

















