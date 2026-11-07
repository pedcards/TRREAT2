/*	TRREAT v2

*/

#Requires AutoHotkey v2
#SingleInstance Force
#Include "includes\"
SendMode("Input")
SetWorkingDir A_ScriptDir
SetTitleMatchMode("2")

#Esc::getPageDom()

; ######################################################################################
getPageDom() {
	hwnd := WinActive("ahk_exe msedge.exe")
	browserEl := UIA.ElementFromHandle(hwnd)
	frame := browserEl.FindElement({Type:"document",Name:"PaceMate LIVE"})
	group := frame.FindElement({Type:"group"})

	try {
		devStat := browserEl.FindElement({AriaRole:"heading",Name:"DEVICE STATUS",MatchMode:"StartsWith"})

		devStatBtn := devStat.FindElement({type:"link"})

		if InStr(devStat.Name,"+") {
			devStatBtn.Click()
		}
		dev := browserEl.FindElements({})
		grpEl := group.FindElements({})
	}
	for key,val in grpEl {
		; a := dev.GetPropertyValue("AutomationId")
		x := val.GetPropertyValue("name")
		y := val.Name
		; y := dev.GetPropertyValue("value")
		; z := val.GetAllPropertyValues()
		; OutputDebug(a ": " x ": " y "`n")
		; val.Dump()
		if InStr(x,"DEVICE STATUS") {
			; el3 := val.WalkTree("+1")
		}
	}
}


; ###	Includes   #####################################################################
#Include UIA.ahk
