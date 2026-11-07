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
	frame := UIA.ElementFromHandle(hwnd)

	; elems := frame.FindElements({name:"evaluationForm.leadSummary.ra.intrAmpl.key"})
	elems := frame.FindElement({name:"evaluationForm.leadSummary.rv.paceThresholdAsString"})
	
}


; ###	Includes   #####################################################################
#Include UIA.ahk
