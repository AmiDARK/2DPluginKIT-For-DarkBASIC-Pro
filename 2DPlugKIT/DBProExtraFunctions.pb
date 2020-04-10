;
;**************************************************************************************************************
; eXtra functions used by the plugin.
Structure ExtraF_Structure
  GetBitmapData.l        ; Pointeur vers la commande GetBitmapData dans la DLL DBproBitmapDebug.dll
  BitmapID.l
  BitmapWIDTH.l
  BitmapHEIGHT.l
  BitmapDEPTH.l
  BitmapPTR.l
  BitmapBLOCKSIZE.l
  GetImageData.l         ; Pointeur vers la commande GetImageData dans la DLL DBProImageDebug.dll
  ImageID.l
  ImageWIDTH.l
  ImageHEIGHT.l
  ImageDEPTH.l
  ImagePTR.l
  ImageBLOCKSIZE.l
 EndStructure
Global Extra.ExtraF_Structure
;
;**************************************************************************************************************
;
Procedure SETUP_ExtraFunctions()
  ; Functions to get BitmapDATA
  OpenLibrary( 1, "DBProBitmapDebug.dll" )
    Extra\GetBitmapData = GetFunction( 1, "?GetBitmapData@@YAXHPAK00PAPAD0_N@Z" )
   CloseLibrary( 1 )
  ; Functions to get Image DATA
  OpenLibrary( 1, "DBProImageDebug.dll" )
    Extra\GetImageData = GetFunction( 1, "?GetImageData@@YAXHPAK00PAPAD0_N@Z" )
   CloseLibrary( 1 )
 EndProcedure
;
;**************************************************************************************************************
;
Procedure DBE_GetBitmapData( BitmapID.l )
  If Extra\GetBitmapData <> 0
    CallCFunctionFast( Extra\GetBitmapData, BitmapID, @BitmapWIDTH.l, @BitmapHEIGHT.l, @BitmapDEPTH.l, @BitmapPTR, @BlockSIZE, 1 )
    Extra\BitmapID = BitmapID
    Extra\BitmapWIDTH = BitmapWIDTH
    Extra\BitmapHEIGHT = BitmapHEIGHT
    Extra\BitmapDEPTH = BitmapDEPTH
    Extra\BitmapPTR = BitmapPTR
    Extra\BitmapBLOCKSIZE = BlockSIZE
   Else
    MessageRequester( "2DPluginKIT Warning", "Cannot get bitmap data, DBProBitmapDEBUG.dll not found" )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
Procedure DBE_GetImageData( ImageID.l )
  If Extra\GetImageData <> 0
    CallCFunctionFast( Extra\GetImageData, ImageID, @ImageWIDTH.l, @ImageHEIGHT.l, @ImageDEPTH.l, @ImagePTR, @BlockSIZE, 1 )
    Extra\ImageID = ImageID
    Extra\ImageWIDTH = ImageWIDTH
    Extra\ImageHEIGHT = ImageHEIGHT
    Extra\ImageDEPTH = ImageDEPTH
    Extra\ImagePTR = ImagePTR
    Extra\ImageBLOCKSIZE = BlockSIZE
   Else
    MessageRequester( "2DPluginKIT Warning", "Cannot get Image data, DBProImageDEBUG.dll not found" )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l DBE_GetBitmapWIDTH()
  ProcedureReturn Extra\BitmapWIDTH
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l DBE_GetBitmapHEIGHT()
  ProcedureReturn Extra\BitmapHEIGHT
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l DBE_GetBitmapDEPTH()
  ProcedureReturn Extra\BitmapDEPTH
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l DBE_GetBitmapPtr()
  ProcedureReturn Extra\BitmapPTR
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l DBE_GetBitmapBlockSIZE()
  ProcedureReturn Extra\BitmapBLOCKSIZE
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l DBE_GetImageWIDTH()
  ProcedureReturn Extra\ImageWIDTH
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l DBE_GetImageHEIGHT()
  ProcedureReturn Extra\ImageHEIGHT
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l DBE_GetImageDEPTH()
  ProcedureReturn Extra\ImageDEPTH
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l DBE_GetImagePtr()
  ProcedureReturn Extra\ImagePTR
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l DBE_GetImageBlockSIZE()
  ProcedureReturn Extra\ImageBLOCKSIZE
 EndProcedure
;
;**************************************************************************************************************
;
; IDE Options = PureBasic 4.10 Beta 2 (Windows - x86)
; CursorPosition = 62
; FirstLine = 85
; Folding = ---