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
#include <WinAPIFiles.au3>

AutoItSetOption ('MouseCoordMode', 0)
AutoItSetOption ('SendKeyDelay', 1)
AutoItSetOption('WinTitleMatchMode',2)
Opt("WinTitleMatchMode",2)

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



;********************************************** GUI ****************************************************
Global $Form1, $ManualSetup = -99, $AdapterManager, $CamSelection, $TeliU3vViewer, $ComPort, $UpdateV4, $RenameID
$sProgress = "VR20 Smart Installer Progress"
Global $progressfile = @DesktopDir & "\INCOMPLETE Installation & Setup.txt"
$Filehandle = FileOpen($progressfile, $FO_APPEND )
FileWrite($Filehandle, @CRLF &"- PC Restarted")

Global $Form1 = GUICreate("VR20 Smart Installer Part 2", 498, 321, -1, -1)
GUISetBkColor(0xD7E4F2)
Local $Label1 = GUICtrlCreateLabel("VR20 Smart Installer Pt. 2 ", 120, 40, 258, 29)
GUICtrlSetFont(-1, 15, 800, 0, "MS Sans Serif")
Local $Label2 = GUICtrlCreateLabel("Enter Machine ID:", 168, 128, 160, 29)
GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")
Local $Input = GUICtrlCreateInput("", 104, 176, 289, 33)
GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")
Local $StartButton = GUICtrlCreateButton("Start", 200, 248, 97, 41, $BS_DEFPUSHBUTTON)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
GUISetState(@SW_SHOW, $Form1)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg(1)
	Switch $nMsg[1]
		Case $Form1
			Switch $nMsg[0]
				Case $GUI_EVENT_CLOSE
					exit1()


				Case $StartButton

					Global $MachineID = GUICtrlRead($Input)
					SplashTextOn("Message", "Mouse will be moved automatically. Don't touch or move the mouse until further notice.", 400, 120, 500, 300, $DLG_TEXTLEFT, "", 16)
					   Sleep(500)
					   SplashOff()


;~ 					Install_Driver_Camera()
;~ 					;Update_V4()
;~ 					Create_InternalBuyOff_Folder()
;~ 					;Update_MachineID()
;~ 					PGAdmin()
;~ 					DeleteCamSelect64()
;~ 					Update_VCare()

					;****************************** Done *******************************************************

					ProgressSet(100, "100%", "Auto Setup Done")
					Sleep(2000)
					ProgressOff()

					SplashTextOn("Message", "Auto Installation is completed. Proceed to manual setup.", 400, 120, 500, 300, $DLG_TEXTLEFT, "", 16)
					Sleep(2500)
					SplashOff()


					;FileDelete(@DesktopDir &"\UpdateV4.txt")
					FileDelete(@DesktopDir &"\INCOMPLETE Installation & Setup.txt")

					;**************************** Manual Setup *************************************************
					GUISetState(@SW_DISABLE, $Form1)
					If $ManualSetup = -99 Then ManualSetup()
					GUISetState(@SW_SHOW, $ManualSetup)


			EndSwitch

		Case $ManualSetup
			Switch $nMsg[0]
				Case $GUI_EVENT_CLOSE
					GUISetState(@SW_ENABLE,$Form1)
					GUISetState(@SW_HIDE, $ManualSetup)


				Case $AdapterManager

					Run("D:\Vitrox\V4\Tools\AdapterManager.exe")


				Case $CamSelection

					ShellExecute("C:\Users\Administrator\Desktop\CamSelection.lnk")
					Sleep(1000)
					Send("v0514")
					Send('{ENTER}')


				Case $TeliU3vViewer

;~ 					ShellExecute("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\TOSHIBA TELI\TeliCamSDK\Viewer\TeliU3vViewer64.lnk")
;~ 					Sleep(1000)
;~ 					BlockInput($BI_DISABLE)
;~ 					MouseClick("primary", 48, 46)
;~ 					Sleep(300)
;~ 					MouseClick("primary", 46, 65)
;~ 					BlockInput($BI_ENABLE)

					TeliU3ViewerJX()

				Case $ComPort
					BlockInput($BI_DISABLE)
					Send("#r")
					WinWait("Run")
					WinActivate("Run")
					Send("{BACKSPACE}")
					Send("devmgmt.msc")
					ControlClick("Run", "OK", 1)
					Sleep(300)
					WinWait("Device Manager")
					WinActivate("Device Manager")
					Send('{TAB} {DOWN 13} {RIGHT}')
					BlockInput($BI_ENABLE)

				Case $UpdateV4
					ShellExecute("D:\Vitrox")
					ShellExecute("C:\Users\Administrator\Desktop\Ignitus VR20 Installer")
					SplashTextOn("Message", "Replace the old V4 with new V4 folder.", 400, 120, 500, 300, $DLG_TEXTLEFT, "", 16)
					Sleep(3000)
					SplashOff()

				Case $RenameID
					ProgressOn($sProgress, "Changing Machine ID automatically ...", "0%",8,8, BitOR($DLG_NOTONTOP, $DLG_MOVEABLE))
					BlockInput($BI_DISABLE)
					IniWrite("D:\Vitrox\V4\V4.ini", "Lot Info", "MachineID", $MachineID)
					IniWrite("D:\Vitrox\V4\VsCT.ini", "Settings", "MachineID", $MachineID)
					IniWrite("D:\Vitrox\V4\VsMLP.ini", "Settings", "MachineID", $MachineID)
					IniWrite("D:\Vitrox\V4\VsMP.ini", "Settings", "MachineID", $MachineID)
					IniWrite("D:\Vitrox\V4\VsTS.ini", "Settings", "MachineID", $MachineID)

					ProgressSet(50, "50%", "Changing Machine ID automatically ...")

					; Assumption: machine ID is VRXXXXX in the original default.fmt, if number of character diff will have problems
					$default = "D:\Vitrox\V4\default.fmt"
					Run( "notepad.exe " & $default)
					WinWait("default.fmt - Notepad")
					WinActivate("default.fmt - Notepad")
					Send('{DOWN 50}')
					Send('{RIGHT 14}')
					Send('{DELETE 7}')
					Send($MachineID)
					Send('^s')
					WinClose("default - Notepad")

					BlockInput($BI_ENABLE)

					ProgressSet(100, "100%", "Changing Machine ID automatically ...")
					Sleep(1000)
					ProgressOff()
					Sleep(300)

   ; Change value for ReportFormat.xml
   $sFile = "D:\Vitrox\V4\ReportFormat.xml"
   If FileExists($sFile) Then

   Else
	  MsgBox($MB_ICONINFORMATION,"Message","ReportFormat.xml file is not found!")
   EndIf

   $sPath = "/LotReportFormat/ContentNode/MachineID"
   $sAttrib = "value"

   $oXML = _XMLFileOpen($sFile)
   _XMLSetAttrib($sPath,$sAttrib,$MachineID)
   $oXML = 0





			EndSwitch

	EndSwitch

WEnd







; ********************************************* Functions ***************************************************************



; 7. Install Driver Camera
Func Install_Driver_Camera()
   FileWrite($Filehandle, @CRLF &"- Installing Driver Camera")
   ProgressOn($sProgress, "Installing Driver Camera ...", "50%",8,8, BitOR($DLG_NOTONTOP, $DLG_MOVEABLE))
   ProgressSet(50, "50%", "Installing Driver Camera ...")
   Sleep(300)
   ShellExecute("C:\Program Files\TOSHIBA TELI\TeliCamSDK\TeliCamDriver\U3v\x64")
   WinWait('x64')
   WinActivate('x64')
   Sleep(100)
   Send('{DOWN 3}')
   Sleep(100)
   Send('{ENTER}')
   Sleep(100)
   WinWait("[CLASS:#32770]")
   WinActivate("[CLASS:#32770]")
   Sleep(1000)
   ;WinWait('TeliU3vDriver Installer - x64')
   ;WinActivate('TeliU3vDriver Installer - x64')
   Send('{TAB 2}')
   Sleep(100)
   Send('{SPACE}')
   WinWait('TeliU3vDrvInst64')
   WinActivate('TeliU3vDrvInst64')
   Sleep(100)
   Send('{SPACE}')
   WinClose("TeliU3vDriver Installer - x64")
   WinClose("[CLASS:#32770]")
   Sleep(100)
   WinClose("[CLASS:CabinetWClass]")
   FileWrite($Filehandle, @CRLF &"- Installing Driver Camera (DONE)")
EndFunc

; 8. Update V4 File
Func Update_V4()
	FileWrite($Filehandle, @CRLF &"- Copying files from VR20 Patch Folder to V4 ")
	ProgressSet(55, "55%", "Replacing V4 file......")
	SplashTextOn("Message", " Installer unresponsive is normal. Do not touch anything. The process takes about 10 to 30 seconds.", 400, 120, 500, 300, $DLG_TEXTLEFT, "", 16)


	Sleep(300)
	$destination1 = "D:\ViTrox\V4"
	$local1 = @ScriptDir & "\V4"
	$test = DirCopy($local1, $destination1, $FC_OVERWRITE)
	Sleep(300)
	SplashOff()
	FileWrite($Filehandle, @CRLF &"- Copy V4 (DONE) ")

EndFunc


; 9. Copy Internal Buyoff
Func Create_InternalBuyOff_Folder()
   ProgressSet(60, "60%", "Creating Internal Buy-off folder ...")
   Sleep(300)
   Global $file = @DesktopDir & "\" & $MachineID & " Golden Internal BuyOff"
   If FileExists($file) Then
	  ; do nothing
   Else
	  DirCreate($file)
   EndIf
   DirCopy(@ScriptDir & "\Golden internal buyoff", $file, $FC_OVERWRITE)
   FileWrite($Filehandle, @CRLF &"- Create InternalBuyOff Folder (DONE)")
EndFunc


; 10. Update Machine ID
Func Update_MachineID()
	FileWrite($Filehandle, @CRLF &"- Changing Machine ID in V4, VsCT, VsTS, VsMP, VsMLP .ini files, default.fmt and ReportFormat.xml file")
   ProgressSet(70, "70%", "Updating Machine ID ..." )
   Sleep(300)

	 IniWrite("D:\Vitrox\V4\V4.ini", "Lot Info", "MachineID", $MachineID)
	 IniWrite("D:\Vitrox\V4\VsCT.ini", "Settings", "MachineID", $MachineID)
	 IniWrite("D:\Vitrox\V4\VsMLP.ini", "Settings", "MachineID", $MachineID)
	 IniWrite("D:\Vitrox\V4\VsMP.ini", "Settings", "MachineID", $MachineID)
	 IniWrite("D:\Vitrox\V4\VsTS.ini", "Settings", "MachineID", $MachineID)

	; Assumption: machine ID is VR14166 in the original default.fmt
	$default = "D:\Vitrox\V4\default.fmt"
	Run( "notepad.exe " & $default)
	WinWait("default.fmt - Notepad")
	WinActivate("default.fmt - Notepad")
	Send('{DOWN 50}')
	Send('{RIGHT 14}')
	Send('{DELETE 7}')
	Send($MachineID)
	Send('^s')
	WinClose("default - Notepad")
   Sleep(300)

   ; Change value for ReportFormat.xml
   $sFile = "D:\Vitrox\V4\ReportFormat.xml"
   If FileExists($sFile) Then

   Else
	  MsgBox($MB_ICONINFORMATION,"Message","ReportFormat.xml file is not found!")
   EndIf

   $sPath = "/LotReportFormat/ContentNode/MachineID"
   $sAttrib = "value"

   $oXML = _XMLFileOpen($sFile)
   _XMLSetAttrib($sPath,$sAttrib,$MachineID)
   $oXML = 0
   ;ProgressSet(90, "90%", "Done changing!" )
   FileWrite($Filehandle, @CRLF &"- Changing Machine ID for V4, VsCT, VsMP, VsMLP, VsTS .ini files, default.fmt and ReprtFormat.xml (DONE)")

EndFunc

;11. PGAdminIII
Func PGAdmin()
	FileWrite($Filehandle, @CRLF &"- Enter password to PGAdmin")
   BlockInput($BI_DISABLE)
   ProgressSet(80, "80%", "Entering password to PGAdmin III" )
	Sleep(300)
	ShellExecute("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PostgreSQL 9.3 (x86)\pgAdmin III.lnk")
	WinWait("pgAdmin III")
	WinActivate("pgAdmin III")
	MouseClick($MOUSE_CLICK_PRIMARY, 174, 152, 2)
	Sleep(500)
	WinWait("Connect to Server")
	WinActivate("Connect to Server")
	Send("password")
	Sleep(500)
	ControlCommand("Connect to Server", "Store password", 320, "Check")
	ControlClick("Connect to Server", "&OK", 5100)
	Sleep(500)
	WinClose("pgAdmin III")


	 BlockInput($BI_ENABLE)
   FileWrite($Filehandle, @CRLF &"- Enter PGAdmin III passwrd (DONE)")



EndFunc

;12. Delete CamSelect64
Func DeleteCamSelect64()
	FileWrite($Filehandle, @CRLF &"- Delete CamSelect64 from Desktop")
   ProgressSet(88, "88%", "Deleting CamSelect64" )
	_WinAPI_DeleteFile("C:\Users\Administrator\Desktop\CamSelection64.lnk")
   FileWrite($Filehandle, @CRLF &"- Delete CamSelect64 from Desktop (DONE)")
EndFunc

;13. Replace VCare with New Iteration
Func Update_VCare()
	FileWrite($Filehandle, @CRLF &"- Update VCare")


	ProgressSet(95, "95%", "Replacing VCare file......")
	Sleep(300)
	$destination1 = "D:\ViTrox\VCare"
	$local1 = @ScriptDir & "\VCare"
	$test = DirCopy($local1, $destination1, $FC_OVERWRITE)
	Sleep(300)
	FileWrite($Filehandle, @CRLF &"- Update VCare (DONE)")

EndFunc


Func ManualSetup()
	$ManualSetup = GUICreate("VR20 Settings Menu", 615, 600, -1, -1)
	GUISetBkColor(0xD7E4F2)
	$Label1 = GUICtrlCreateLabel("VR20 Settings Menu", 184, 32, 236, 36, $SS_SUNKEN)
	GUICtrlSetFont(-1, 18, 800, 0, "Nirmala UI")
	 $AdapterManager = GUICtrlCreateButton("Adapter Manager", 136, 104, 329, 49)
	GUICtrlSetFont(-1, 16, 400, 0, "Nirmala UI")
	$CamSelection = GUICtrlCreateButton("CamSelection", 136, 184, 329, 49)
	GUICtrlSetFont(-1, 16, 400, 0, "Nirmala UI")
	$TeliU3vViewer = GUICtrlCreateButton("TeliU3vViewer", 136, 264, 329, 49)
	GUICtrlSetFont(-1, 16, 400, 0, "Nirmala UI")
	$ComPort = GUICtrlCreateButton("COM PORT", 136, 336, 329, 49)
	GUICtrlSetFont(-1, 16, 400, 0, "Nirmala UI")
	$UpdateV4 = GUICtrlCreateButton("UPDATE V4", 136, 416, 329, 49)
	GUICtrlSetFont(-1, 16, 400, 0, "Nirmala UI")
	$RenameID = GUICtrlCreateButton("Auto Machine ID", 136, 496, 329, 49)
	GUICtrlSetFont(-1, 16, 400, 0, "Nirmala UI")
	GUISetState(@SW_HIDE, $ManualSetup)
EndFunc

Func TeliU3ViewerJX()
   BlockInput($BI_DISABLE)
   ProgressOn($sProgress, "Changing VsTS setting ...", "70%",8,8, BitOR($DLG_NOTONTOP, $DLG_MOVEABLE))
   Sleep(300)
   ProgressOff()

   ShellExecute("C:\Program Files\TOSHIBA TELI\TeliCamSDK\TeliViewer\U3v\x64\TeliU3vViewer64")
   WinWait("TeliU3vViewer")
   WinActivate("TeliU3vViewer")
   WinSetState("[ACTIVE]","",@SW_MAXIMIZE)
   Sleep(100)
   MouseClick("left", 493, 72, 1, 0)
   Sleep(100)
   MouseClick("left", 44, 44, 1, 0)
   Sleep(100)
   Send('{DOWN}{ENTER}')

   BlockInput($BI_ENABLE)
   $message = "Change the following VsTS setting:" & @CR & "--------------------------------------------------" & @CR & "Click  B, E, G" & @CR & "1. TriggerSource -> Line0" & @CR & "2. TriggerActivation -> FallingEdge" & @CR & "3. LineSource -> Timer0Active" & @CR & "4. TimerDuration -> 1000" & @CR & "5. UserSetSelector -> UserSet1" & @CR & "Click -> " & "Execute" & @CR & @CR & "After changed, close TeliU3vViewer"
   SplashTextOn("Message", $message, 360, 290, 8, @DeskTopHeight - 370, $DLG_TEXTLEFT, "", 14)
   MsgBox($MB_ICONINFORMATION,"Message","Auto setup is paused. Mannual setup is required. Please open the VsTS camera manually!")
   WinWaitClose("TeliU3vViewer")
   SplashOff()
   BlockInput($BI_DISABLE)
   ProgressOff()
   ShellExecute("C:\Program Files\TOSHIBA TELI\TeliCamSDK\TeliViewer\U3v\x64\TeliU3vViewer64")
   WinWait("TeliU3vViewer")
   WinActivate("TeliU3vViewer")
   WinSetState("[ACTIVE]","",@SW_MAXIMIZE)
   Sleep(100)
   Send('{DOWN}{ENTER}')
   MouseClick("left", 493, 72, 1, 0)
   Sleep(100)
   MouseClick("left", 44, 44, 1, 0)
   Sleep(100)
   Send('{DOWN}{ENTER}')
   Sleep(100)
   BlockInput($BI_ENABLE)
   $message = "Double Check the following VsTS setting:" & @CR & "--------------------------------------------------" & @CR & "Click  B, E, G" & @CR & "1. TriggerSource -> Line0" & @CR & "2. TriggerActivation -> FallingEdge" & @CR & "3. LineSource -> Timer0Active" & @CR & "4. TimerDuration -> 1000" & @CR & "5. UserSetSelector -> UserSet1" & @CR & "Go to UserSetSave" & @CR & "Click -> " & "Execute" & @CR & @CR & "After changed, close TeliU3vViewer"
   SplashTextOn("Message", $message, 360, 290, 8, @DeskTopHeight - 370, $DLG_TEXTLEFT, "", 14)
   MsgBox($MB_ICONINFORMATION,"Message","Please click Execute on UserSetSave")
   WinWaitClose("TeliU3vViewer")
   SplashOff()
EndFunc

Func exit1()
	GUIDelete($ManualSetup)
	GUIDelete($Form1)
	Exit
EndFunc
