#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1

; Init
if FileExist("config.ini") {
    goto ShowMenu
}
IniWrite, 0, config.ini, Enabled, WSC
IniWrite, 0, config.ini, Enabled, AC
IniWrite, "NotSet", config.ini, Keys, WSC
IniWrite, "NotSet", config.ini, Keys, AC

; Show Menu
ShowMenu:
; Check for reload
IniRead, wscChkBox, config.ini, Enabled, WSC
IniRead, acChkBox, config.ini, Enabled, AC
IniRead, wscKey, config.ini, Keys, WSC
IniRead, acKey, config.ini, Keys, AC

; Gui keyWSC: New,
Gui Font, s9, Segoe UI
Gui Add, CheckBox, vChkWsc gChkWsc x56 y120 w129 h24 Checked%wscChkBox%, WSC
Gui Add, CheckBox, vChkAC gChkAC x56 y72 w129 h24 Checked%acChkBox%, Animation Cancel
Gui Add, Text, x56 y24 w129 h23 +0x200 +Center, Technique
Gui Add, Hotkey, vkeyAC x208 y72 w120 h21 +Disabled, %acKey%
Gui Add, Hotkey, vkeyWSC x208 y120 w120 h21 +Disabled, %wscKey%
Gui Add, Text, x200 y24 w129 h23 +0x200 +Center, Key
Gui Add, Text, x50 y104 w281 h2 +0x10
Gui Add, Text, x50 y56 w281 h2 +0x10
Gui Add, Text, x50 y152 w281 h2 +0x10
Gui Add, Button, gapply x56 y164 w265 h27, &Save
Gui Add, Text, x48 y200 w280 h23 +Center, Contact Wireless#1518 for help
GuiControlGet, ChkAC
GuiControlGet, ChkWsc
if (ChkWsc = 1) {
    GuiControl, Enable, keyWSC
} else {
    GuiControl, Disable, keyWSC
}
if (ChkAC = 1) {
    GuiControl, Enable, keyAC
} else {
    GuiControl, Disable, keyAC
}
Gui Show, w370 h235, Window
Return


ChkWsc:
    GuiControlGet, ChkWsc
    if (ChkWsc = 1) {
	    GuiControl, Enable, keyWSC
    } else {
	    GuiControl, Disable, keyWSC
    }
    ; writeIni(ChkWsc, "check", "wsc")
Return

ChkAC:
    GuiControlGet, ChkAC
    if (ChkAC = 1) {
	    GuiControl, Enable, keyAC
    } else {
	    GuiControl, Disable, keyAC
    }
    ; writeIni(ChkAC, "check", "ac")
Return

apply:
    GuiControlGet, ChkAC
    GuiControlGet, ChkWsc
    GuiControlGet, keyAC
    GuiControlGet, keyWSC
    if (keyAC = keyWSC) {
        if (chkAC = 1) {
            if (chkWsc = 1) {
                Msgbox, AC and WSC cannot be both enabled and set to the same key
                return
            }
        }
    }
    if (ChkWsc = 1 and keyWSC = "") {
        Msgbox, Unable to save config. Either disable WSC or set a key.
        return
    }
    if (ChkAC = 1 and keyAC = "") {
        Msgbox, Unable to save config. Either disable Animation Cancel or set a key.
        return
    }
    writeIni(ChkWsc, "check", "wsc")
    writeIni(ChkAC, "check", "ac")
    if (keyWSC != "") {
        writeIni(keyWSC, "key", "wsc")
    }
    if (keyAC != "") {
        writeIni(keyAC, "key", "ac")
    }
    Msgbox, Settings saved
    ExitApp
return

writeIni(value, type, section) {
    if (type = "check") {
        ; Msgbox % section ; Bug-Testing
        if (section = "wsc") {
            IniWrite, %value%, config.ini, Enabled, WSC
        }
        if (section = "ac") {
            IniWrite, %value%, config.ini, Enabled, AC
        }
    }
    if (type = "key") {
        if (section = "wsc") {
            IniWrite, %value%, config.ini, Keys, WSC
        }
        if (section = "ac") {
            IniWrite, %value%, config.ini, Keys, AC
        }
        return
    }
    return
}

GuiClose:
ExitApp