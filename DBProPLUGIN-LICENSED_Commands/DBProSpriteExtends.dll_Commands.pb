; DarkBasic Professional RC2PBIncludes Ver 1. File - COMMANDS WRAPPING
; By Frederic Cordier - 07.02.13
;
; *********************************************************************
Procedure.l SPR_Init()
  Retour.l = CallCFunctionFast( *DB_SpriteExtends\SPR_Init )
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure SPR_Clear()
  CallCFunctionFast( *DB_SpriteExtends\SPR_Clear )
 EndProcedure
;
; *********************************************************************
Procedure.l SPR_Count()
  Retour.l = CallCFunctionFast( *DB_SpriteExtends\SPR_Count )
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l SPR_Delete( SpriteNumber.l )
  If GetDLLInitialized( #SpriteExtends ) = 1
    Retour.l = CallCFunctionFast( *DB_SpriteExtends\SPR_Delete, ImageNumber )
   Else
    Retour = 0
    DBDeleteSprite( SpriteNumber )
   Endif
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l SPR_DynamicSprite( Xpos.l, YPos.l, ImageNumber.l )
  If GetDLLInitialized( #SpriteExtends ) = 1
    Retour.l = CallCFunctionFast( *DB_SpriteExtends\SPR_DynamicSprite, Xpos, YPos, ImageNumber )
   Else
    Retour = DBE_GetFreeSprite()
    DBSprite( Retour, XPos, YPos, ImageNumber )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l SPR_DynamicAnimatedSprite( FileName.s, Across.l, Down.l, ImageNumber.l )
  If GetDLLInitialized( #SpriteExtends ) = 1
    CallCFunctionFast( *GlobPtr\CreateDeleteString, @FileNamePTR.l, Len( FileName ) + 1 ) ; CreateString
    PokeS( FileNamePTR, FileName )
    Retour.l = CallCFunctionFast( *DB_SpriteExtends\SPR_DynamicAnimatedSprite, FileNamePTR, Across, Down, ImageNumber )
   Else
    Retour = DBE_GetFreeSprite()
    DBCreateAnimatedSprite( Retour, FileName, Across, Down, ImageNumber )   
   Endif
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure PrepareSpriteForCollision( SpriteNumber.l )
  CallCFunctionFast( *DB_SpriteExtends\PrepareSpriteForCollision, SpriteNumber )
 EndProcedure
;
; *********************************************************************
Procedure.l GetSpriteCollision( Sprite1.l, Sprite2.l, Mode.l )
  Retour.l = CallCFunctionFast( *DB_SpriteExtends\GetSpriteCollision, Sprite1, Sprite2, Mode )
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure FreeSpriteFromCollision( SpriteNumber.l )
  CallCFunctionFast( *DB_SpriteExtends\FreeSpriteFromCollision, SpriteNumber )
 EndProcedure
;
; *********************************************************************
Procedure.l GetSpritesDistance( Sprite1.l, Sprite2.l )
  Retour.l = CallCFunctionFast( *DB_SpriteExtends\GetSpritesDistance, Sprite1, Sprite2 )
  ProcedureReturn Retour
 EndProcedure
;

; IDE Options = PureBasic 4.10 Beta 2 (Windows - x86)
; CursorPosition = 51
; FirstLine = 34
; Folding = --