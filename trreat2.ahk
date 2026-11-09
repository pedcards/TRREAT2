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
	hwnd := WinActive("ahk_exe msedge.exe")
	browser := UIA.ElementFromHandle(hwnd)

	if !(group := isEvalPage(browser)) {
		return
	}

	try openHeading(group,"DEVICE STATUS")
	try openHeading(group,"PARAMETERS")
	
	grpEl := group.FindElements({})

	t1 := getHeading(grpEl,"DEVICE STATUS")
	t2 := getHeading(grpEL,"PARAMETERS")
	t3 := getHeading(grpEL,"Current Events")
	makeObs(&grpEl)

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
getHeading(obj,heading) {
	if !(key := findHeading(obj,heading)) {
		return
	}
	obj.key := key
	findSections(&obj)
	return obj.txt

}
findHeading(obj,heading) {
	loop obj.Length {
		key := A_Index
		val := obj[key]
		if (val.AriaRole="heading") {
			if (heading=matchHeading(val)) {
				return key
			}
		}
	}
}
matchHeading(obj) {
	headings := ["PATIENT INFO","DEVICE STATUS","PARAMETERS","Current Events","OBSERVATIONS"]
	for hName in headings {
		if InStr(obj.name,hName) {
			return hName
		}
	}
	return obj.name
}
findSections(&obj) {
	sections := ["Battery Voltage:","Estimated Longevity:","Last Charge Date:"
				,"Sensing:","Impedance:","Defibrillation Impedance:","Thresholds:"
				,"Mode:","Base Rate:","Upper Track:","Upper Sensor:","Mode Switch:"
				,"Paced AV:","Sensed AV:","Pacing %:"]
	obj.txt := ""
	loop obj.length {
		if (A_Index < obj.key) {
			continue
		}
		val := obj[A_Index]
		if ObjHasValue(sections,val.Name) {
			obj.key := A_Index
			readSection(&obj,val.Name)
			A_Index := obj.key
		}
	}
}
readSection(&obj,Name) {
	chambers := ["Atrial =","RV =","LV ="]
	txt := ""
	isSection := false
	loop obj.length {
		if (A_Index < obj.key) {
			continue
		}
		val := obj[A_Index]
		type := val.AriaRole
		if (type="textbox") {
			txt .= val.value " "
			continue
		}
		if (type="combobox") {
			txt .= val.value " "
			continue
		}
		if (SubStr(val.Name,-1)=":")&&(isSection=true) {
			obj.txt .= Trim(txt) "`n"
			obj.key := A_Index-1
			return
		}
		if (type="description") {
			if ObjHasValue(chambers,val.name) {
				txt := Trim(txt) "`n"
			}
			txt .= val.name " "
			isSection := true
			continue
		}
	}

}
makeObs(&obj) {
	if !(key := findHeading(obj,"OBSERVATIONS")) {
		return
	}
	obj.key := key
	obj.txt := ""
	isGroup := false
	loop obj.Length {
		if (A_Index<obj.key) {
			continue
		}
		key := A_Index
		val := obj[key]
		type := val.AriaRole
		if (type="group") {
			isGroup:=true
		}
		if (isGroup=false) {
			continue
		}
		if (type="description") {
			obj[key]:=key
		}
	}
}
ObjHasValue(aObj, aValue, rx:="") {
	for key, val in aObj
		if (rx="RX") {																	; argument 3 is "RX" 
			if (aValue="") {															; null aValue in "RX" is error
				return false
			}
			if (val ~= aValue) {														; val=text, aValue=RX
				return key
			}
			if (aValue ~= val) {														; aValue=text, val=RX
				return key
			}
		} else {
			if (val = aValue) {															; otherwise just string match
				return key
			}
		}
	return false																		; fails match, return err
}


; ###	Includes   #####################################################################
#Include "includes\"
#Include UIA.ahk
