/**
 *  @Description Kettle - A simple pattern for Pine.
 *  @author Dully176
 *  @version 0.1.0
 *  @date 9/6/2025
 *  @Settings {"Name":"Pine Tree","Pattern":"Kettle","DriftCheck":0,"PatternInvertFB":0,"PatternInvertLR":0,"PatternReps":1,"PatternShift":1,"PatternSize":"M","ReturnType":"Walk","RotateDirection":"Right","RotateTimes":4,"SprinklerDist":7,"SprinklerLoc":"Upper Left","UntilMins":10,"UntilPack":95}
**/

; Drift comp settings.
crFDC := 0.3    ; Corner FDC.
dwAlign := 1.5  ; Diamond wall align.
dwDrift := 2    ; Diamond wall drift align.
hwAlign := 1.5  ; Honey wall align.
hwDrift := 2    ; Honey wall drift aling.

; Advanced settings.
digi := true    ; Digi stops.
loops := 2      ; Frequency of digi token on corner.
l := 6.25       ; Long walk.
s := l/4        ; Short walk.
h := l/2        ; Half of long walk. (do not change)

; DIGI STOP SETTING OVERWRITE.
; DO NOT CHANGE UNLESS YOU KNOW WHAT YOU'RE DOING.
if digi
    l:=6, s:=l/4, h:=l/2, crFDC:=0.3, dwAlign:=1.5, hwAlign:=1, dwDrift:=2, hwDrift := 4

nm_cameraRotation("up", 4), Sleep(35)
loop loops {  ; for later use (digi stop amount)

    ; shape one (straight)
    dy_Walk(h, LeftKey)
    dy_Walk(s, FwdKey)
    dy_Walk(l, RightKey)
    dy_Walk(s, FwdKey)
    dy_Walk(l, LeftKey)

    nm_cameraRotation("left", 1), Sleep(35)

    dy_Walk(l, BackKey, LeftKey)
    if dwAlign > 0 {
        dy_Walk(dwAlign+dwDrift, BackKey, LeftKey), dy_Walk(dwAlign, FwdKey, RightKey)
        if A_Index != loops
            ds(700)
    }
    dy_Walk(s, BackKey, RightKey)
    dy_Walk(l, FwdKey, RightKey)
    dy_Walk(s, BackKey, RightKey)
    dy_Walk(h, BackKey, LeftKey)

    nm_cameraRotation("right", 1), Sleep(35)

    dy_Walk(h, BackKey)
    dy_Walk(s, RightKey)
    dy_Walk(l, FwdKey)
    dy_Walk(s, RightKey)
    if hwAlign > 0 {
        dy_Walk(hwAlign+hwDrift, RightKey), dy_Walk(hwAlign, LeftKey)
        if A_Index = loops
            ds(600)
    }
    dy_Walk(l, BackKey)

    nm_cameraRotation("left", 2), Sleep(35)

    dy_Walk(l, FwdKey)
    dy_Walk(s, RightKey)
    dy_Walk(l, BackKey)
    dy_Walk(s, RightKey)
    dy_Walk(h, FwdKey)

    nm_cameraRotation("right", 2), Sleep(35)
    ; shape two (diagonal)
    dy_Walk(h, FwdKey, LeftKey)
    if A_Index != loops
        ds(850)
    dy_Walk(s, FwdKey, RightKey)
    dy_Walk(l, BackKey, RightKey)
    dy_Walk(s, FwdKey, RightKey)
    dy_Walk(l, FwdKey, LeftKey)

    nm_cameraRotation("left", 1), Sleep(35)

    dy_Walk(l, LeftKey)
    dy_Walk(s+crFDC, BackKey)
    dy_Walk(l, RightKey)
    dy_Walk(s+crFDC, BackKey)
    dy_Walk(h, LeftKey)

    nm_cameraRotation("right", 1), Sleep(35)

    dy_Walk(h, BackKey, LeftKey)
    dy_Walk(s, BackKey, RightKey)
    dy_Walk(l, FwdKey, RightKey)
    dy_Walk(s, BackKey, RightKey)
    dy_Walk(l, BackKey, LeftKey)

    nm_cameraRotation("left", 2), Sleep(35)

    dy_Walk(l, FwdKey, RightKey)
    dy_Walk(s, BackKey, RightKey)
    dy_Walk(l, BackKey, LeftKey)
    dy_Walk(s, BackKey, RightKey)
    if A_Index = loops
        ds(700)
    dy_Walk(h, FwdKey, RightKey)

    nm_cameraRotation("right", 2), Sleep(35)
}
nm_cameraRotation("down", 4), Sleep(35)
dy_Walk(t, d, s:=0) => (s?nm_Walk(t,d,s):nm_Walk(t,d),Sleep(20),0)
ds(ms) => (digi?(Send("{o 5}"),Sleep(ms)):0,0)
