#NoTrayIcon
#SingleInstance Force

#Include "%A_ScriptDir%\..\lib"
#Include "Gdip_All.ahk"
#Include "Gdip_ImageSearch.ahk"
#Include "Roblox.ahk"
#Include "nm_OpenMenu.ahk"
#Include "nm_InventorySearch.ahk"

CoordMode "Mouse", "Screen"
OnExit(ExitFunc)
pToken := Gdip_Startup()

bitmaps := Map()
Shrine := Map()

#Include ..\nm_image_assets\general\bitmaps.ahk

bitmaps["giftedstar"] := Gdip_BitmapFromBase64("iVBORw0KGgoAAAANSUhEUgAAAAgAAAAIAgMAAAC5YVYYAAAACVBMVEX9rDT+rDTrDOj6H2ZAAAAFElEQVR42mNYtYoBgVYyrFoBYQMAf4AKnlh184sAAAAASUVORK5CYII=")

if (MsgBox("WELCOME TO THE BASIC BEE REPLACEMENT PROGRAM!!!!!``nMade by anniespony#8135``n``nMake sure BEE SLOT TO CHANGE is always visible``nDO NOT MOVE THE SCREEN ORRESIZE WINDOW FROM NOW ON.``nMAKE SURE AUTO-JELLY IS DISABLED!!", "Basic Bee Replacement Program", 0x40001) = "Cancel")
	ExitApp

if (MsgBox("After dismissing this message,``nleft click ONLY once on BEE SLOT", "Basic Bee Replacement Program", 0x40001) = "Cancel")
	ExitApp

hwnd := GetRobloxHWND()
ActivateRoblox()
GetRobloxClientPos()
offsetY := GetYOffset(hwnd, &offsetfail)
if (offsetfail = 1) {
	MsgBox "Unable to detect in-game GUI offset!``nStopping Feeder!``n``nThere are a few reasons why this can happen, including:``n - Incorrect graphics settings``n - Your `'Experience Language`' is not set to English``n - Something is covering the top of your Roblox window``n``nJoin our Discord server for support and our Knowledge Base post on this topic (Unable to detect in-game GUI offset)!", "WARNING!!", 0x40030
	ExitApp
}
StatusBar := Gui("-Caption +E0x80000 +AlwaysOnTop +ToolWindow -DPIScale")
StatusBar.Show("NA")
hbm := CreateDIBSection(windowWidth, windowHeight), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
G := Gdip_GraphicsFromHDC(hdc), Gdip_SetSmoothingMode(G, 2), Gdip_SetInterpolationMode(G, 2)
Gdip_FillRectangle(G, pBrush := Gdip_BrushCreateSolid(0x60000000), -1, -1, windowWidth+1, windowHeight+1), Gdip_DeleteBrush(pBrush)
UpdateLayeredWindow(StatusBar.Hwnd, hdc, windowX, windowY, windowWidth, windowHeight)

KeyWait "LButton", "D" ; Wait for the left mouse button to be pressed down.
MouseGetPos &beeX, &beeY
Gdip_GraphicsClear(G), Gdip_FillRectangle(G, pBrush := Gdip_BrushCreateSolid(0xd0000000), -1, -1, windowWidth+1, 38), Gdip_DeleteBrush(pBrush)
Gdip_TextToGraphics(G, "Hatching... Right Click or Shift to Stop!", "x0 y0 cffff5f1f Bold Center vCenter s24", "Tahoma", windowWidth, 38)
UpdateLayeredWindow(StatusBar.Hwnd, hdc, windowX, windowY, windowWidth, 38)
SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc), Gdip_DeleteGraphics(G)
Hotkey "Shift", ExitFunc, "On"
Hotkey "RButton", ExitFunc, "On"
Hotkey "F11", ExitFunc, "On"
Sleep 250

pBMC := Gdip_CreateBitmap(2,2), G := Gdip_GraphicsFromImage(pBMC), Gdip_GraphicsClear(G,0xffae792f), Gdip_DeleteGraphics(G) ; Common
pBMM := Gdip_CreateBitmap(2,2), G := Gdip_GraphicsFromImage(pBMM), Gdip_GraphicsClear(G,0xffbda4ff), Gdip_DeleteGraphics(G) ; Mythic

rj := 0
Loop
{
	if ((pos := (A_Index = 1) ? nm_InventorySearch("basicegg", "up", , , , 70) : (rj = 1) ? nm_InventorySearch("royaljelly", "up", , , 0, 7) : nm_InventorySearch("basicegg", "up", , , 0, 7)) = 0)
	{
		MsgBox "You ran out of " ((rj = 1) ? "Royal Jellies!" : "Basic Eggs!"), "Basic Bee Replacement Program", 0x40010
		break
	}
	GetRobloxClientPos(hwnd)
	SendEvent "{Click " windowX+pos[1] " " windowY+pos[2] " 0}"
	Send "{Click Down}"
	Sleep 100
	SendEvent "{Click " beeX " " beeY " 0}"
	Sleep 100
	Send "{Click Up}"
	Loop 10
	{
		Sleep 100
        TextInRegion := findTextInRegion("Yes",, windowX + windowWidth // 4, windowY + windowHeight//2, windowWidth // 4, windowHeight//2, true)
		if TextInRegion.Has("Word") {
			word := TextInRegion["Word"]
			SendEvent "{Click " windowX + word.BoundingRect.x " " windowY + word.BoundingRect.y
			break
		}
        
		pBMScreen := Gdip_BitmapFromScreen(windowX+windowWidth//2-250 "|" windowY+offsetY+windowHeight//2-52 "|500|150")
		if (Gdip_ImageSearch(pBMScreen, bitmaps["yes"], &pos, , , , , 2, , 2) = 1)
		{
			Gdip_DisposeImage(pBMScreen)
			SendEvent "{Click " windowX+windowWidth//2-250+SubStr(pos, 1, InStr(pos, ",")-1) " " windowY+offsetY+windowHeight//2-52+SubStr(pos, InStr(pos, ",")+1) "}"
			break
		}
		Gdip_DisposeImage(pBMScreen)
		if (A_Index = 10)
		{
			rj := 1
			continue 2
		}
	}
	Sleep 750

	pBMScreen := Gdip_BitmapFromScreen(windowX+windowWidth//2-155 "|" windowY+offsetY+((4*windowHeight)//10 - 135) "|310|205"), rj := 0
	if (Gdip_ImageSearch(pBMScreen, pBMM, , 50, 165, 260, 205, 2, , , 5) = 5) { ; Mythic Hatched
		if (MsgBox("MYTHIC!!!!``nKeep this?", "Basic Bee Replacement Program", 0x40024) = "Yes")
		{
			Gdip_DisposeImage(pBMScreen)
			break
		}
	}
	else if (Gdip_ImageSearch(pBMScreen, pBMC, , 50, 165, 260, 205, 2, , , 5) = 5) {
		rj := 1
		if (Gdip_ImageSearch(pBMScreen, bitmaps["giftedstar"], , 0, 20, 130, 50, 5) = 1) { ; If gifted is hatched, stop
			MsgBox "SUCCESS!!!!", "Basic Bee Replacement Program", 0x40020
			Gdip_DisposeImage(pBMScreen)
			break
		}
	}
	else if (Gdip_ImageSearch(pBMScreen, bitmaps["giftedstar"], , 0, 20, 130, 50, 5) = 1) { ; Non-Basic Gifted Hatched
		if (MsgBox("GIFTED!!!!``nKeep this?", "Basic Bee Replacement Program", 0x40024) = "Yes")
		{
			Gdip_DisposeImage(pBMScreen)
			break
		}
	}
	Gdip_DisposeImage(pBMScreen)
}
ExitApp

ExitFunc(*)
{
	try Gdip_DisposeImage(pBMC), Gdip_DisposeImage(pBMM)
	try StatusBar.Destroy()
	try Gdip_Shutdown(pToken)
	ExitApp
}