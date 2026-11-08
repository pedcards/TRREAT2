/*	TRREAT v2

*/

#Requires AutoHotkey v2
#SingleInstance Force
SendMode("Input")
SetWorkingDir A_ScriptDir
SetTitleMatchMode("2")

#Esc::getPageDom()

; ######################################################################################
getPageDom() {
	sections := ["Battery Voltage:","Estimated Longevity:","Last Charge Date:"
				,"Sensing:","Impedance:","Defibrillation Impedance:","Thresholds:"]
	chambers := ["Atrial =","RV =","LV ="]
	setHeading := false
	setSection := false
	setChamber := false

	hwnd := WinActive("ahk_exe msedge.exe")
	browser := UIA.ElementFromHandle(hwnd)

	if !(group := isEvalPage(browser)) {
		return
	}

	try openHeading(group,"DEVICE STATUS")
	try openHeading(group,"PARAMETERS")
	
	grpEl := group.FindElements({})
	for key,val in grpEl {
		if (val.AriaRole="heading") {
			heading := matchHeading(val)
			continue
		}
		if (val.AriaRole="description") {
			for sName in sections {
				if InStr(val.name,sName) {
					section := sName
					setSection := true
					setHeading := false
					break
				}
			}
			continue
		}
	}
}
isEvalPage(obj) {
	try {
		group := obj.FindElement({Name:"Save & Approve"}).WalkTree("p2")
		return group
	}
}
openHeading(group,heading) {
	header := group.FindElement({AriaRole:"heading",Name:heading,MatchMode:"StartsWith"})
	headerBtn := header.FindElement({type:"link"})
	if InStr(header.Name,"+") {
		headerBtn.Click()
	}
}
matchHeading(obj) {
	headings := ["PATIENT INFO","DEVICE STATUS","PARAMETERS","OBSERVATIONS"]
	for hName in headings {
		if InStr(obj.name,hName) {
			return hName
		}
	}
	return obj.name
}


; ###	Includes   #####################################################################
#Include "includes\"
#Include UIA.ahk
