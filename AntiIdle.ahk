#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance, force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

AntiSleepDelay := 5 * 60 * 1000	; First number in minutes, keep monitor awake
AntiIdleDelay := 2 * 1000		; First number in seconds, wiggle mouse every # seconds
AntiAFKDelay := 9 * 60 * 1000	; First number in minutes, press buttons every # minutes

+F3::
Gui, +Resize
Gui, Add, Checkbox, Checked y10 vAntiSleepVal, Keep monitor from going to sleep
Gui, Add, Checkbox, vAntiIdleVal, Wiggle mouse (appear as active in Discord for example)
Gui, Add, Checkbox, Checked vAntiAFKVal, Anti-AFK for FFXIV
Gui, Add, Edit, vStopDelayVal w30, 999
Gui, Add, Text, xp+35 yp+5, Stop Idle after `# minutes
Gui, Add, Button, x10 y+10 w50, Start
Gui, Add, Button, x+10 w50, Stop
Gui, Add, Text, x+10 yp+5 Hidden vStatus, Anti Idle ON
Gui, Show, w300 h130, Anti Idle
Return

ButtonStart:
    Gui, Submit, NoHide
	
	StopDelay := StopDelayVal * 60 * 1000		; First number in minutes, disable idle after # minutes

    if (AntiSleepVal)
        SetTimer, AntiSleep, %AntiSleepDelay%    
    if (AntiIdleVal)
        SetTimer, AntiIdle, %AntiIdleDelay%
    if (AntiAFKVal)
        SetTimer, AntiAFK, %AntiAFKDelay%
	if (StopDelayVal)
		SetTimer, ButtonStop, %StopDelay%
    
    if (AntiSleepVal or AntiIdleVal or AntiAFKVal)
        GuiControl, Show, Status
Return

ButtonStop:
    GuiControl, Hide, Status
	DllCall("SetThreadExecutionState", UInt, 0x80000000)	; Clear flags
    SetTimer, AntiIdle, off
    SetTimer, AntiSleep, off
    SetTimer, AntiAFK, off
Return

AntiSleep:
    DllCall("SetThreadExecutionState", UInt, 0x80000003)	; Forces Display on and system in Working state
Return

AntiIdle:
    MouseMove, 0, 1, 0, R
    Sleep AntiIdleDelay / 2
    MouseMove, 0, -1, 0, R
Return

AntiAFK:
    Sleep, 1000
    Send, /
    Sleep, 1000
    Send, bm
	Sleep, 1000
    Send, {enter}
    Sleep, 1000
    Send, /
    Sleep, 1000
    Send, bm
	Sleep, 1000
    Send, {enter}
Return

GuiClose:
	DllCall("SetThreadExecutionState", UInt, 0x80000000)	; Clear flags
    SetTimer, AntiIdle, off
    SetTimer, AntiSleep, off
    SetTimer, AntiAFK, off
	Gui, Destroy
Return

Esc::
    GuiControl, Hide, Status
	DllCall("SetThreadExecutionState", UInt, 0x80000000)	; Clear flags
    SetTimer, AntiIdle, off
    SetTimer, AntiSleep, off
    SetTimer, AntiAFK, off
ExitApp

