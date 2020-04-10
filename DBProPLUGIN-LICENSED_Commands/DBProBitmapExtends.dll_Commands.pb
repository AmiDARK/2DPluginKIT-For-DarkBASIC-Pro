; DarkBasic Professional RC2PBIncludes Ver 1. File - COMMANDS WRAPPING
; By Frederic Cordier - 07.02.13
;
; *********************************************************************
Procedure.l BMP_Init()
  Retour.l = CallCFunctionFast( *DB_BitmapExtends\BMP_Init )
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure BMP_Clear()
  CallCFunctionFast( *DB_BitmapExtends\BMP_Clear )
 EndProcedure
;
; *********************************************************************
Procedure.l BMP_Count()
  Retour.l = CallCFunctionFast( *DB_BitmapExtends\BMP_Count )
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l BMP_Delete( BitmapNumber.l )
  If GetDLLInitialized( #BitmapExtends ) = 1
    Retour.l = CallCFunctionFast( *DB_BitmapExtends\BMP_Delete, BitmapNumber )
   Else
    Retour = 0
    DBDeleteBitmap( BitmapNumber )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l BMP_DynamicLoad( FileName.s )
  If GetDLLInitialized( #BitmapExtends ) = 1
    CallCFunctionFast( *GlobPtr\CreateDeleteString, @FileNamePTR.l, Len( FileName ) + 1 ) ; CreateString
    PokeS( FileNamePTR, FileName )
    Retour.l = CallCFunctionFast( *DB_BitmapExtends\BMP_DynamicLoad, FileNamePTR )
   Else
    Retour = DBE_GetFreeBitmep()
    DBLoadBitmapA( FileName, Retour )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l BMP_DynamicClone( SourceBitmap.l )
  If GetDLLInitialized( #BitmapExtends ) = 1
    Retour.l = CallCFunctionFast( *DB_BitmapExtends\BMP_DynamicClone, SourceBitmap )
   Else
    Retour = DBE_GetFreeBitmep()
    DBCreateBitmap( Retour, DBBitmapWidth( SourceBitmap ), DBBitmapHeight( SourceBitmap ) )
    DBCopyBitmap( SourceBitmap, Retour )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l BMP_DynamicMake( Width.l, Height.l )
  If GetDLLInitialized( #BitmapExtends ) = 1
    Retour.l = CallCFunctionFast( *DB_BitmapExtends\BMP_DynamicMake, Width, Height )
   Else
    Retour = DBE_GetFreeBitmep()
    DBCreateBitmap( Retour, Width, Height )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l BMP_MakeBitmapFromMemblock( MemblockNumber.l )
  If GetDLLInitialized( #BitmapExtends ) = 1
    Retour.l = CallCFunctionFast( *DB_BitmapExtends\BMP_MakeBitmapFromMemblock, MemblockNumber )
   Else
    Retour = DBE_GetFreeBitmep()
    DBCreateBitmapFromMemblock( Retour, MemblockNumber )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;

; IDE Options = PureBasic 4.10 Beta 2 (Windows - x86)
; CursorPosition = 51
; FirstLine = 36
; Folding = --