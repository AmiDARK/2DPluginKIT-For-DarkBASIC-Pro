;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetImageWIDTH( ImageID.l )
  If Extra\ImageID <> ImageID : DBE_GetImageData( ImageID ) : EndIf
  ProcedureReturn Extra\ImageWIDTH
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetImageHEIGHT( ImageID.l )
  If Extra\ImageID <> ImageID : DBE_GetImageData( ImageID ) : EndIf
  ProcedureReturn Extra\ImageHEIGHT
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetImageDEPTH( ImageID.l )
  If Extra\ImageID <> ImageID : DBE_GetImageData( ImageID ) : EndIf
  ProcedureReturn Extra\ImageDEPTH
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetImagePtr( ImageID.l )
  If Extra\ImageID <> ImageID : DBE_GetImageData( ImageID ) : EndIf
  ProcedureReturn Extra\ImagePTR
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetImageBlockSIZE( ImageID.l )
  If Extra\ImageID <> ImageID : DBE_GetImageData( ImageID ) : EndIf
  ProcedureReturn Extra\ImageBLOCKSIZE
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetImagePixel( ImageID.l, XPos.l, YPos.l )
  If PlugINITIALIZED = 1
    If Extra\ImageID <> ImageID : DBE_GetImageData( ImageID ) : EndIf
    MemorySHIFT.l = ( ( YPos * Extra\ImageWIDTH ) + Xpos ) * ( Extra\ImageDEPTH / 8 )
    If MemorySHIFT > 0 And MemorySHIFT < Extra\ImageBLOCKSIZE
      Pixel.l = PeekL( MemorySHIFT + Extra\ImagePTR )
     Else
      Pixel = 0
     EndIf
   EndIf
  ProcedureReturn Pixel
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetImagePixel( ImageID.l, XPos.l, YPos.l, RGBAPixel )
  If PlugINITIALIZED = 1
    If Extra\ImageID <> ImageID : DBE_GetImageData( ImageID ) : EndIf
    MemorySHIFT.l = ( ( YPos * Extra\ImageWIDTH ) + Xpos ) * ( Extra\ImageDEPTH / 8 )
    If MemorySHIFT > 0 And MemorySHIFT < Extra\ImageBLOCKSIZE
      PokeL( MemorySHIFT + Extra\ImagePTR, RGBAPixel )
     Else
      Pixel = 0
     EndIf
   EndIf
 EndProcedure

; IDE Options = PureBasic 4.10 Beta 2 (Windows - x86)
; CursorPosition = 45
; FirstLine = 22
; Folding = --