; DarkBasic Professional RC2PBIncludes Ver 1. File - COMMANDS WRAPPING
; By Frederic Cordier - 07.02.13
;
; *********************************************************************
Procedure.l MTX_Init()
  Retour.l = CallCFunctionFast( *DB_MatrixExtends\MTX_Init )
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure MTX_Clear()
  CallCFunctionFast( *DB_MatrixExtends\MTX_Clear )
 EndProcedure
;
; *********************************************************************
Procedure.l MTX_Count()
  Retour.l = CallCFunctionFast( *DB_MatrixExtends\MTX_Count )
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l MTX_Delete( MatrixID.l )
  If GetDLLInitialized( #MatrixExtends ) = 1
    Retour.l = CallCFunctionFast( *DB_MatrixExtends\MTX_Delete, MatrixID )
   Else
    Retour = 0
    DBDeleteMatrix( MatrixID )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l MTX_DynamicMake( Width.f, Height.f, XTiles.l, ZTiles.l )
  If GetDLLInitialized( #MatrixExtends ) = 1
    Retour.l = CallCFunctionFast( *DB_MatrixExtends\MTX_DynamicMake, Width, Height, XTiles, ZTiles )
   Else
    Retour = DBE_GetFreeMatrix()
    DBMakeMatrix( Retour, Width, Height, XTiles, ZTiles )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;

; IDE Options = PureBasic 4.10 Beta 2 (Windows - x86)
; CursorPosition = 37
; Folding = -