#SingleInstance Force
#NoEnv
#Include lib/AppFactory.ahk
FileInstall, lib/AppFactory.ahk, %A_ScriptDir%/lib/AppFactory.ahk
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
Global factory := new AppFactory()
Global init = 0

;Init GUI
Gui Font, s9, Segoe UI
Gui Add, Text, x56 y24 w129 h23 +0x200 +Center, Technique
Gui Add, Text, x200 y24 w129 h23 +0x200 +Center, Key
Gui Add, Text, x50 y104 w281 h2 +0x10
Gui Add, Text, x50 y56 w281 h2 +0x10
Gui Add, Text, x50 y152 w281 h2 +0x10
Gui Add, Text, x48 y200 w280 h23 +Center, Contact Wireless#1518 for help

;Init Factories
wscChkObj := factory.AddControl("wscChk", "CheckBox", "x56 y120 w129 h24", "WSC", Func("enableWSCInput"))
acChkObj := factory.AddControl("acChk", "CheckBox", "x56 y72 w129 h24", "Animation Cancel", Func("enableACInput"))
acKeyObj := factory.AddInputButton("keyAC", "x208 y72 w120 h21", Func("setAC"))
wscKeyObj := factory.AddInputButton("keyWSC", "x208 y120 w120 h21", Func("setWsc"))
factory.AddControl("applyButton", "Button", "x56 y164 w265 h27", "&Save", Func("saveSettings"))

;Show GUI
Gui Show, w370 h235, SDV Rebind
;Tell program to disable init mode
init++
initCheckKeys()
Return

initCheckKeys() {
    IniRead, wscKeyIni, config.ini, Key, WSC
    IniRead, acKeyIni, config.ini, Key, AC
    acKeyCodeChk := factory.IOControls.keyAC.BindObject.Binding[1]
    wscKeyCodeChk := factory.IOControls.keyWSC.BindObject.Binding[1]
    acKeyChk := BuildKeyName(acKeyCodeChk)
    wscKeyChk := BuildKeyName(wscKeyCodeChk)
    if (acKeyChk != acKeyIni) {
        IniWrite, %acKeyChk%, config.ini, Key, AC
    }
    if (wscKeyChk != wscKeyIni) {
        IniWrite, %wscKeyChk%, config.ini, Key, WSC
    }

    return
}

; Checkbox Input Checker
enableWSCInput(state) {
    if (init = 0) {
        return
    }
    wscChkStatus := factory.GuiControls.wscChk._Value
}

enableACInput(state) {
    if (init = 0) {
        return
    }
    acChkStatus := factory.GuiControls.acChk._Value
}

saveSettings() {
    errorExit = 0
    if (init = 0) {
        return
    }

    ; Get Checkboxes
    acChkStatus := factory.GuiControls.acChk._Value
    wscChkStatus := factory.GuiControls.wscChk._Value

    ; Get Hotkeys
    acKeyCode := factory.IOControls.keyAC.BindObject.Binding[1]
    wscKeyCode := factory.IOControls.keyWSC.BindObject.Binding[1]
    acKey := BuildKeyName(acKeyCode)
    wscKey := BuildKeyName(wscKeyCode)

    ; Error Checking
    if (wscChkStatus = 1 and wscKey = "") {
        Msgbox, Unable to save config. Either disable WSC or set a key.
        errorExit = 1
        return
    }
    if (acChkStatus = 1 and acKey = "") {
        Msgbox, Unable to save config. Either disable Animation Cancel or set a key.
        errorExit = 1
        return
    }
    if (wscChkStatus = 1 and acChkStatus = 1) {
        if (wscKey = acKey) {
            Msgbox, Unable to save config. Can't have the same key for WSC and Animation Cancel with both enabled.
            errorExit = 1
            return
        }
    }

    ; Save to ini if no errors
    if (errorExit = 0) {
        IniWrite, %acChkStatus%, config.ini, Enabled, AC
        IniWrite, %wscChkStatus%, config.ini, Enabled, WSC
        IniWrite, %wscKey%, config.ini, Key, WSC
        IniWrite, %acKey%, config.ini, Key, AC
        Msgbox, Settings saved.
    }
    
    Return
}

;Builds readable key name from keycode since AppFactory returns the 2 digit keyCode instead of a human readable key name
BuildKeyName(code){
    if (init = 0) {
        return
    }
	static replacements := {33: "PgUp", 34: "PgDn", 35: "End", 36: "Home", 37: "Left", 38: "Up", 39: "Right", 40: "Down", 45: "Insert", 46: "Delete"}
	static additions := {14: "NumpadEnter"}
	if (ObjHasKey(replacements, code)){
		return replacements[code]
	} else if (ObjHasKey(additions, code)){
		return additions[code]
	} else {
		return GetKeyName("vk" Format("{:x}", code))
	}
}

GuiClose:
ExitApp