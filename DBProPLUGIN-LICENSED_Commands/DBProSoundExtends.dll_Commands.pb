; DarkBasic Professional RC2PBIncludes Ver 1. File - COMMANDS WRAPPING
; By Frederic Cordier - 07.02.13
;
; *********************************************************************
Procedure.l SND_Init()
  Retour.l = CallCFunctionFast( *DB_SoundExtends\SND_Init )
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure SND_Clear()
  CallCFunctionFast( *DB_SoundExtends\SND_Clear )
 EndProcedure
;
; *********************************************************************
Procedure.l SND_Count()
  Retour.l = CallCFunctionFast( *DB_SoundExtends\SND_Count )
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l SND_Delete( SoundNumber.l )
  If GetDLLInitialized( #SoundExtends ) = 1
    Retour.l = CallCFunctionFast( *DB_SoundExtends\SND_Delete, SoundNumber )
   Else
    Retour = 0
    DBDeleteSound( Retour )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l SND_DynamicLoad( Filename.s )
  If GetDLLInitialized( #SoundExtends ) = 1
    CallCFunctionFast( *GlobPtr\CreateDeleteString, @FilenamePTR.l, Len( Filename ) + 1 ) ; CreateString
    PokeS( FilenamePTR, Filename )
    Retour.l = CallCFunctionFast( *DB_SoundExtends\SND_DynamicLoad, FilenamePTR )
   Else
    Retour = DBE_GetFreeSound()
    DBLoadSound( FileName, Retour )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l SND_MakeSoundFromMemblock( MemblockNumber.l )
  If GetDLLInitialized( #SoundExtends ) = 1
    Retour.l = CallCFunctionFast( *DB_SoundExtends\SND_MakeSoundFromMemblock, MemblockNumber )
   Else
    Retour = DBE_GetFreeSound()
    DBCreateSoundFromMemblock( Retour, MemblockNumber )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l SND_DynamicLoad3D( Filename.s )
  If GetDLLInitialized( #SoundExtends ) = 1
    CallCFunctionFast( *GlobPtr\CreateDeleteString, @FilenamePTR.l, Len( Filename ) + 1 ) ; CreateString
    PokeS( FilenamePTR, Filename )
    Retour.l = CallCFunctionFast( *DB_SoundExtends\SND_DynamicLoad3D, FilenamePTR )
   Else
    Retour = DBE_GetFreeSound()
    DBLoad3DSound( FileName, Retour )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;

; IDE Options = PureBasic 4.10 Beta 2 (Windows - x86)
; CursorPosition = 50
; FirstLine = 21
; Folding = --