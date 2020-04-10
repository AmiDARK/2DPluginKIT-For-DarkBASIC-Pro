;
; *********************************************
; *                                           *
; * 2DPlugKIT Include File : SYSTEM FUNCTIONS *
; *                                            
; *********************************************
; This include contain system functions.
;
;**************************************************************************************************************
; Sign( Number.f )
; GetQuantity( STRI$, CHAR$ )
; STRExtractDrawer( Full.s )
; STRExtractFileName( Full.s )
;**************************************************************************************************************
;
;**************************************************************************************************************
;
Procedure.f Sign( Number.f )
  Retour.f = Number / Abs( Number )
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l GetQuantity( STRI$, CHAR$ )
  If Len( STRI$ ) = 0
    Retour.l = 0
   Else
    Retour = 0 : InPOS.l = 1
    Repeat
      If Mid( STRI$, InPOS, 1 ) = CHAR$ : Retour = Retour + 1 : EndIf
      InPOS = InPOS + 1
     Until InPOS > Len( STRI$ )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.s STRExtractDrawer( Full.s )
  If Len( Full ) > 0
    Pos.l = Len( Full )
    Repeat
      Pos = Pos - 1
     Until Mid( Full, Pos, 1 ) = "\" Or Pos = 0
    If Pos > 0
      Drawer.s = Left( Full, Pos )
     Else
      Drawer = ""
     EndIf
   Else
    Drawer = ""
   EndIf
  ProcedureReturn Drawer
 EndProcedure  
;
;**************************************************************************************************************
;
Procedure.s STRExtractFileName( Full.s )
  If Len( Full ) > 0
    Pos.l = Len( Full )
    Repeat
      Pos = Pos - 1
     Until Mid( Full, Pos, 1 ) = "\" Or Pos = 0
    FileName.s = Right( Full, ( Len( Full ) ) - Pos )
   Else
    FileName.s = ""
   EndIf
  ProcedureReturn FileName
 EndProcedure  
;
;**************************************************************************************************************
;
;
;**************************************************************************************************************
;
;
;**************************************************************************************************************
;
;
;**************************************************************************************************************
;
;
;**************************************************************************************************************
;


; IDE Options = PureBasic 4.10 Beta 2 (Windows - x86)
; CursorPosition = 14
; FirstLine = 6
; Folding = -