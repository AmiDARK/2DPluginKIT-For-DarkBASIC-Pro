; DarkBasic Professional RC2PBIncludes Ver 1. File - COMMANDS WRAPPING
; By Frederic Cordier - 07.02.13
;
; *********************************************************************
Procedure.l Effects_Init()
  Retour.l = CallCFunctionFast( *DB_Effects3DExtends\Effects_Init )
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l E3D_DynamicLoad( FileName.s, TextureFlag.l )
  If GetDLLInitialized( #Effects3DExtends ) = 1
    CallCFunctionFast( *GlobPtr\CreateDeleteString, @FileNamePTR.l, Len( FileName ) + 1 ) ; CreateString
    PokeS( FileNamePTR, FileName )
    Retour.l = CallCFunctionFast( *DB_Effects3DExtends\E3D_DynamicLoadEx, FileNamePTR, TextureFlag )
   Else
    Retour = DBE_GetFreeEffect()
    DBLoadEffect1( FileName, Retour, TextureFlag )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l E3D_Delete( EffectNumber.l )
  If GetDLLInitialized( #Effects3DExtends ) = 1
    Retour.l = CallCFunctionFast( *DB_Effects3DExtends\E3D_Delete, EffectNumber )
   Else
    Retour = 0
    DBDeleteEffect( EffectNumber )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure E3D_Clear()
  CallCFunctionFast( *DB_Effects3DExtends\E3D_Clear )
 EndProcedure
;
; *********************************************************************
Procedure.l E3D_Count()
  Retour.l = CallCFunctionFast( *DB_Effects3DExtends\E3D_Count )
  ProcedureReturn Retour
 EndProcedure
;

; IDE Options = PureBasic 4.10 Beta 2 (Windows - x86)
; CursorPosition = 28
; Folding = -