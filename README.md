# AHKMacroMenu

Popup menu-macros for Autohotkey.  

Hit a hotkey, select an item with keyboard (or mouse), and run the text/command macro -- similar to part of [KeyText](https://www.keytext.com), but with a mini-menu to avoid needing to remember the macros.

## Features

* Menu format for easier to forget lists of macros
* Simple ini file data storage
* Self-editing commands built-in
* AHK's ability to force input to a specific target window, regardless of focus
* Use any editor, without registry edits

![Example Menu](https://i.imgur.com/DsXkww4.png)

## Installation

1. Edit the `SETTINGS` and `HOTKEY SETUP` section of the AHKMacroMenu.ahk file

2. Edit AHKMacroMenu.ini

3. Run AHKMacroMenu.ahk

4. Press the hotkey (Ctrl-\ default), and select an item.

NOTE: If the target window is selected, but no text appears, AHK may be blocked by systems protections.  Running as administrator is one way to fix/test this.

## Macro Config .ini Example

```ini
[My_Info]
My_Email=ahkmacomenu@example.com
My_Phone=555-867-5309

[SEP]

[Search_Sites]
Google=https://google.com{Enter}
Bing=https://bing.com{Enter}
DuckDuckGo=https://duckduckgo.com{Enter}

[Email]
Mom=mom@example.com
Dad=dad@example.com
SEP=SEP
Tina=tina@example.com
Steve=steve@example.com
Lina=lina@example.com

[SEP]

[Fun]
Konomi={Up}{Up}{Down}{Down}{Left}{Right}{Left}{Right}ba{Enter}
```

NOTE: Most common script error is a space in a section or item label.  Replace it with an underscore and reload.

## Config Options

```ahk
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
CommandPostfix := "{Enter}"

; Menu Header String
ShowMenuHeader := 1
MenuHeader := "== SELECT MACRO =="
```

## Known Issues

* Mix of AHK v1.0 and 2.0 styles
* Limitations in label naming to support simplest file format
* I am not an AHK expert

## License
[MIT](https://choosealicense.com/licenses/mit/)
