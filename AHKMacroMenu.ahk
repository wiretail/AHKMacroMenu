; Note, requires AHK v1.x.

;===================================================================
; SETTINGS
;===================================================================

; Set to 0 to paste window active at time of invoking
; Set to 1 and options enable always forcing the paste into a specific window
SelectClient := 0

; Set to window to select
; See WindowSpy and https://www.autohotkey.com/docs/misc/WinTitle.htm for options
ClientIDType := "ahk_exe"
ClientID := "notepad.exe"

; Path and name for you config file, defaults to same folder as this script
ConfigFile := A_ScriptDir . "\" . "AHKMacroMenu.ini"

; Enable to the show self editing/reload options in the menu
ShowSelfEditOptions := 1 

; Set your editor
; (Skips the annoying registry setting by AHK)
EditorPath := "C:\Windows\System32\notepad.exe"
; EditorPath := "C:\Program Files\Sublime Text\sublime_text.exe"

; Prefixes all sent commands
CommandPrefix := ""
; CommandPrefix := "some prefix " 

; Postfixes all sent commands
; For example, to always press enter after a string is sent
CommandPostfix := ""
; CommandPostfix := "{Enter}"

; Menu Header String
ShowMenuHeader := 1
MenuHeader := "== SELECT MACRO =="

; See the example ini file for menu setup

; Itnernal Settings
SetFormat, float, 0.0
SetBatchLines, 10ms 
SetTitleMatchMode, 2
#SingleInstance
SendString := ""

Gosub, BuildMenu
Exit


;===================================================================
; HOTKEY SETUP
;===================================================================

; Setup the hotkey here.  Currently set to Ctrl-backslash
; See https://www.autohotkey.com/docs/Hotkeys.htm for details

^\:: ;Ctrl-\
Menu, MushMenu, Show
Return

; Uncomment and set this to write a text dump of your config file for debug/sharing
;^+![:: ; Ctrl-Alt-Shift-[
;Gosub IniReadDump
;Return


;===================================================================
; MAIN CODE 
;===================================================================

IniReadDump:
	OutputVarSectionNames := ""
	OutputVarSection := ""

	SendInput, Reading %ConfigFile%...{Enter}

	IniRead, OutputVarSectionNames, %ConfigFile%

	Loop, Parse, OutputVarSectionNames, `n
		{
		ManuLabel := A_LoopField
		SendInput, Section: [%A_LoopField%]{Enter}

		IniRead, OutputVarSection, %ConfigFile%, %A_LoopField%

		Loop, Parse, OutputVarSection, `n
			{
			CommandLabel := ""
			CommandAlias := ""

			Loop, Parse, A_LoopField, =
				{
				if(A_Index = 1)
					{
					CommandLabel := A_LoopField
					}

				if(A_Index = 2)
					{
					CommandAlias := A_LoopField
					}
				}

			SendInput, -- Items: Menu [%ManuLabel%] -> Label [%CommandLabel%] => Command [%CommandAlias%]{Enter}
			}
		}
	Return


MenuHandler:
	Loop, Parse, A_ThisMenu, #
		{
		if(A_Index = 2)
			{
			SectionHeader := A_LoopField
			}
		}

	ConvertedMenuItem := SectionHeader . "#" . StrReplace(A_ThisMenuItem, A_Space, "_")
	SendString := %ConvertedMenuItem%

	if(StrLen(SendString) = 0)
		{
		MsgBox, Macro text not found for [%SectionHeader%] %A_ThisMenuItem%=
		Exit
		}

	Gosub SendSetCommand
	Return


SendSetCommand:
	Gosub, PreSendSelect

	SendInput, %CommandPrefix%
	SendInput, % SendString
	SendInput, %CommandPostfix%
	Return


PreSendSelect:
	if(SelectClient)
		{
		if WinExist(ClientIDType ClientID)
			{
		    WinActivate ; Use the window found by WinExist.

		    WinWaitActive,,,2
			if ErrorLevel
				{
			    MsgBox, Could not activate window: [%ClientIDType% -> %ClientID%]
			    Exit
				}
			}
		else
			{
		    MsgBox, Could not find window: [%ClientIDType% -> %ClientID%]
		    Exit
		    }
	    }
	Return


BuildMenu:
	OutputVarSectionNames := ""
	OutputVarSection := ""

	;creates the menu header
	if(ShowMenuHeader)
		{	
		Menu, MushMenu, Add, %MenuHeader%, MenuHandler
		Menu, MushMenu, Disable, %MenuHeader%
		Menu, MushMenu, Add  ; Add a separator line.
		}

	IniRead, OutputVarSectionNames, %ConfigFile%

	;iterate top menu
	Loop, Parse, OutputVarSectionNames, `n
		{
		ManuLabel := A_LoopField

		subCount := 0

		SubIndex = %A_Index%
		SubMenuName := "Sub" . SubIndex . "#" . ManuLabel
		DisplayLabelM := StrReplace(ManuLabel, "_", A_Space)

		if(DisplayLabelM = "SEP")
			{
			Menu, MushMenu, Add  ; Add a separator line.
			}
		else
			{
			;iterate submenu
			IniRead, OutputVarSection, %ConfigFile%, %A_LoopField%

			Loop, Parse, OutputVarSection, `n
				{
				CommandLabel := ""
				CommandAlias := ""

				Loop, Parse, A_LoopField, =
					{
					if(A_Index = 1)
						{
						CommandLabel := A_LoopField
						}

					if(A_Index = 2)
						{
						CommandAlias := A_LoopField
						}
					}

				DisplayLabelS := StrReplace(CommandLabel, "_", A_Space)

				if(DisplayLabelS = "SEP")
					{
					Menu, %SubMenuName%, Add, ; Add a separator line.
					}
				else
					{
					subCount := subCount + 1 		
					Menu, %SubMenuName%, Add, %DisplayLabelS%, MenuHandler

					%ManuLabel%#%CommandLabel% := CommandAlias
					}
				}

			;actual submenu assignment comes after creating the elements
			if(subCount)
				{
				Menu, MushMenu, Add, %DisplayLabelM%, :%SubMenuName%
				}
			else
				{
				MsgBox, Warning, no commands found in section: [%A_LoopField%]
				}
			}
		}

	if(ShowSelfEditOptions)
		{
		Menu, MushMenu, Add  ; Add a separator line.
		Menu, MushMenu, Add, Edit Menu, EditMenuCommand
		Menu, MushMenu, Add, Edit Script, EditScriptCommand
		Menu, MushMenu, Add, Reload, ReloadCommand
		}
	Return


EditMenuCommand:
	Run, % EditorPath . " " . ConfigFile
	Return


EditScriptCommand:
	Run, % EditorPath . " " . A_ScriptFullPath
	Return


ReloadCommand:
	Reload
	Return
