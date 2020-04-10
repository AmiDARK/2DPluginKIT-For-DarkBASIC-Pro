;
; *********************************************
; *                                           *
; * 2DPlugKIT Include File : SYSTEM FUNCTIONS *
; *                                           *
; *********************************************
; This include contain system functions.
;
;**************************************************************************************************************
; P2DK_SetDefaultTileWidth( DefaultWIDTH.l )
; P2DK_SetDefaultTileHeight( DefaultHEIGHT.l )
; P2DK_SetDefaultTileTransparency( DefaultTRANSPARENCY.l )
; P2DK_GetDefaultTileWidth()
; P2DK_GetDefaultTileHeight()
; P2DK_GetDefaultTileTransparency()
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetDefaultTileWidth( DefaultWIDTH.l )
  If DefaultWIDTH > 0 And DefaultWIDTH < 1024
    Setup\DefaultWIDTH = DefaultWIDTH
   Else
    MessageRequester( "2DPlugKIT Error", "Choosen default tile width is incorrect" )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetDefaultTileHeight( DefaultHEIGHT.l )
  If DefaultHEIGHT > 0 And DefaultWIDTH < 1024
    Setup\DefaultHEIGHT = DefaultHEIGHT
   Else
    MessageRequester( "2DPlugKIT Error", "Choosen default tile height is incorrect" )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetDefaultTileTransparency( DefaultTRANSPARENCY.l )
  If DefaultTRANSPARENCY = 0 Or DefaultTRANSPARENCY = 1
    Setup\DefaultTransparency = DefaultTRANSPARENCY
   Else
    MessageRequester( "2DPlugKIT Error", "Choosen default tile transparency is incorrect" )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetDefaultTileWidth()
  Retour.l = Setup\DefaultWIDTH
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetDefaultTileHeight()
  Retour.l = Setup\DefaultHEIGHT
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetDefaultTileTransparency()
  Retour.l = Setup\DefaultTransparency
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetDebugMODE( ModeL.l )
  Setup\DebugMODE = ModeL
 EndProcedure
;
;**************************************************************************************************************
;
;
;**************************************************************************************************************
;

; IDE Options = PureBasic v4.02 (Windows - x86)
; CursorPosition = 4
; Folding = --