;
; ****************************************************
; *                                                  *
; * 2DPlugKIT Include File : MISCELLANEOUS FUNCTIONS *
; *                                                  *
; ****************************************************
; This include contain miscellaneous functions that can't be categorized..
;**************************************************************************************************************
; CopyMemoryM(*Src, *Dst, bpCycle, rSkip, wSkip, cycles) 
; PKSyncFPS( FrameRate.l )
; P2DK_Read8BitsPixel( Bloc.l, XPos.l, YPos.l )
;**************************************************************************************************************
;
; *Src = source                 *Dst = destination            bpCycle = bytes to copy per cycle 
; rSkip = read skip value       wSkip = write skip value      cycles = number of cycles 
Procedure CopyMemoryM(*Src, *Dst, bpCycle, rSkip, wSkip, cycles) 
 ; push registers used 
 !push ecx 
 !push edx 
 !push esi 
 !push edi 
 !pushfd 
 ; retrieve some parameters 
 !mov ecx,[esp + 44] 
 !mov edx,[esp + 32] 
 !mov esi,[esp + 24] 
 !mov edi,[esp + 28] 
 ; exit if bpCycle or cycles are 0 
 !and ecx,ecx 
 !jz cmm_exit 
 !and edx,edx 
 !jz cmm_exit 
 ; main loop 
 !cmm_loop1: 
 !push edx 
 !cmm_loop2: 
 !mov al,[esi] 
 !mov [edi],al 
 !inc esi 
 !inc edi 
 !dec edx 
 !jnz cmm_loop2 
 !pop edx 
 !add esi,[esp + 36] 
 !add edi,[esp + 40] 
 !dec ecx 
 !jnz cmm_loop1 
 ; pop registers used and exit 
 !cmm_exit: 
 !popfd 
 !pop edi 
 !pop esi 
 !pop edx 
 !pop ecx 
EndProcedure 
;
;**************************************************************************************************************
;
ProcedureCDLL PKSyncFPS( FrameRate.l )
  If PlugINITIALIZED = 1
    OldTIMER = ActualTIMER - 1
    Repeat
      ActualTIMER = DBTimerL()
     Until 1000/( ActualTIMER - OldTIMER ) < FrameRate
    DBSync()
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_Read8BitsPixel( Bloc.l, XPos.l, YPos.l )
  If PlugINITIALIZED = 1
    Width.l = DBReadMemblockDWord( Bloc, 0 )
    If XPos >=0 And YPos >= 0
      If XPos < DBreadMemblockDWord( Bloc, 0 ) And YPos < DBReadMemblockDWord( Bloc, 4 )
        Adress.l = ( Width * Ypos ) + Xpos + 12
        Pixel.l = DBReadMemblockByte( Bloc, Adress ) & 255
       Else
        MessageRequester( "Invalid Memblock Image coordinates to READ", Str( XPos ) + " / " + Str( YPos ) )
        Pixel = 0
       EndIf
     Else
      MessageRequester( "Invalid Memblock Image coordinates to READ", Str( XPos ) + " / " + Str( YPos ) )
      Pixel = 0
     EndIf
   EndIf
  ProcedureReturn Pixel
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_Write8BitsPixel( Bloc.l, XPos.l, YPos.l, Pixel.l )
  If PlugINITIALIZED = 1
    Width.l = DBReadMemblockDWord( Bloc, 0 )
    If XPos >=0 And YPos >= 0
      If XPos < DBreadMemblockDWord( Bloc, 0 ) And YPos < DBReadMemblockDWord( Bloc, 4 )
        Adress.l = ( Width * Ypos ) + Xpos + 12
        DBWriteMemblockByte( Bloc, Adress, Pixel )
       Else
        MessageRequester( "Invalid Memblock Image coordinates to WRITE", Str( XPos ) + " / " + Str( YPos ) )
       EndIf
     Else
      MessageRequester( "Invalid Memblock Image coordinates to WRITE", Str( XPos ) + " / " + Str( YPos ) )
     EndIf
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l Make8BITSMemblockImage( MemblockID.l, MWidth.l, MHeight.l )
  If PlugINITIALIZED = 1
    FSize.l = 12 + ( MWidth * MHeight ) ; Must Add 256 * 4 for palette definition.
    If MemblockID = 0
      MemblockID = MBC_DynamicMake( FSize )
     Else
      DBMakeMemblock( MemblockID, FSize )
     EndIf
    DBWriteMemblockDWord( MemblockID, 0, MWidth )
    DBWriteMemblockDWord( MemblockID, 4, MHeight )
    DBWriteMemblockDWord( MemblockID, 8, 8 )
   EndIf
  ProcedureReturn MemblockID
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l ARGB( ALPHA.l, RED.l, GREEN.L, BLUE.l )
  If PlugINITIALIZED = 1
    Retour.l = ( Blue & 255 ) + ( ( Green & 255 ) * 256 ) + ( ( Red & 255 ) * 65536 ) + ( ( ALPHA & 255 ) * 16777216 )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l RGBA( RGBColor.l )
  If PlugINITIALIZED = 1
    Retour.l = RGBColor / 16777216
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l IsLayerOk( LayerNumber.l )
  If LayerNumber > 0 And LayerNumber <=16
    If Layers( LayerNumber )\Active = 1
      Retour.l = 1
     Else
      Retour = 0
      MessageRequester( "2DPlugKIT Error", "Layer does not exist" )
     EndIf
   Else
    Retour = 0
    MessageRequester( "2DPlugKIT Error", "Layer number is invalid" )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l IsLayerAvailable( LayerNumber.l )
  If LayerNumber > 0 And LayerNumber <=16
    If Layers( LayerNumber )\Active = 0
      Retour.l = 1
     Else
      Retour = 0
     EndIf
   Else
    Retour = 0
    MessageRequester( "2DPlugKIT Error", "Layer number is invalid" )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l IsVLightOk( LightID.l )
  If LightID > 0 And LightID <=64
    If P2DLights( LightID )\Active = 1
      Retour.l = 1
     Else
      Retour = 0
      MessageRequester( "2DPlugKIT Error", "V2D Light does not exist" )
     EndIf
   Else
    Retour = 0
    MessageRequester( "2DPlugKIT Error", "V2D Light number is invalid" )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l IsParticleOk( ParticleID.l )
  If ParticleID > 0 And ParticleID <=256
    If ParticleSystem( ParticleID )\Exist = 1
      Retour.l = 1
     Else
      Retour = 0
      MessageRequester( "2DPlugKIT Error", "Particle2D does not exist" )
     EndIf
   Else
    Retour = 0
    MessageRequester( "2DPlugKIT Error", "Particle2D number is invalid" )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l IsVLightAvailable( LightID.l )
  If LightID > 0 And LightID <=64
    If P2DLights( LightID )\Active = 0
      Retour.l = 1
     Else
      Retour = 0
     EndIf
   Else
    Retour = 0
    MessageRequester( "2DPlugKIT Error", "V2D Light number is invalid" )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l IsImageOk( ImageNumber.l )
  If ImageNumber > 0 
    If DBGetImageExist( ImageNumber) = 1
      Retour.l = 1
     Else
      Retour = 0
      MessageRequester( "2DPlugKIT Error", "The Image does not exist" )
     EndIf
   Else
    Retour = 0
    MessageRequester( "2DPlugKIT Error", "Image number is invalid" )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l IsBlitterOk( BobID.l )
  If BobID > 0
    If Bobs( BobID )\Active = 1
      Retour.l = 1
     Else
      Retour = 0
      MessageRequester( "2DPlugKIT Error", "The Blitter Object does not exist" )
     EndIf
   Else
    Retour = 0
    MessageRequester( "2DPlugKIT Error", "Blitter Object number is invalid" )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l IsTileOk( TileID.l )
  If TileID > 0
    If Tiles( TileID )\Active = 1
      Retour.l = 1
     Else
      Retour = 0
      MessageRequester( "2DPlugKIT Error", "Tile does not exist" )
     EndIf
   Else
    Retour = 0
    MessageRequester( "2DPlugKIT Error", "Tile number is invalid" )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
Procedure CopyMemblockImage( SourceMBC.l, X.l, Y.l, Width.l, Height.l, TargetMBC.l, X2.l, Y2.l )
  If SourceMBC > 0 And TargetMBC > 0
    If DBMemblockExist( SourceMBC ) = 1 And DBMemblockExist( TargetMBC ) = 1
      XSize1.l = DBReadMemblockDWord( SourceMBC, 0 ) : YSize1.l = DBReadMemblockDWord( SourceMBC, 4 )
      Depth1.l = DBReadMemblockDWord( SourceMBC, 8 )
      XSize2.l = DBReadMemblockDWord( TargetMBC, 0 ) : YSize2.l = DBReadMemblockDWord( TargetMBC, 4 )
      Depth2.l = DBReadMemblockDWord( TargetMBC, 8 )
      If Width <= XSize1 And Width <= XSize2
        If Height <= YSize1 And Height <= YSize2
          ; On checke si la zone à copier déborde du cadre ... Si c'est le cas, on réduit.
          If X < 0 : Width = Width + X : X = 0 : EndIf ; Si X < 0 On réduit la 
          If Y < 0 : Height = Height + Y : Y = 0 : EndIf
          If X + Width > XSize1
            Reduce.l = ( X + Width ) - XSize1
            Width = Width - Reduce
           EndIf
          If Y + Height > YSize1
            Reduce.l = ( Y + Height ) - YSize1
            Height = Height - Reduce
           EndIf
          ; On checke si la zone copiée sortira du cadre cible ... Si c'est le cas, on réduit.
          If X2 < 0 : X = X + X2 : Width = Width + X2 : X2 = 0 : EndIf
          If Y2 < 0 : Y = Y + Y2 : Height = Height + Y2 : Y2 = 0 : EndIf
          If X2 + Width > XSize2
            Reduce.l = ( X2 + Width ) - XSize2
            Width = Width - Reduce
           EndIf
          If Y2 + Height > YSize2
            Reduce.l = ( Y2 + Height ) - YSize2
            Height = Height - Reduce
           EndIf
          ; On vérifie qu'après tout les checking, il reste un morceau de bloc à copier...
          If Width > 0 And Height > 0
            ; On défini les variables nécessaires à la copie du bloc final nécessaire.
            BytesPerCycle.l = Width * 4              ; Nombre d'octets à copier par lignes.
            ReadSkip.l = ( XSize1 - Width ) * 4      ; Nombre d'octets à skipper par lignes.
            WriteSkip.l = ( XSize2 - Width ) * 4   ; Nombre d'octets à skipper par lignes.
            SourcePTR.l = DBGetMemblockPtr( SourceMBC ) + ( X * 4 ) + ( Y * XSize1 * 4 ) + 12
            TargetPTR.l = DBGetMemblockPtr( TargetMBC ) + ( X2 * 4 ) + ( Y2 * XSize2 * 4 ) + 12
            CopyMemoryM( SourcePTR, TargetPTR, BytesPerCycle, ReadSkip, WriteSkip, Height) 
           EndIf
         EndIf
       EndIf
     EndIf
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL MBCIMPlot( Memblok.l, XPos.l, YPos.l, RGBColor.l )
  If Memblok > 0
    If DBMemblockExist( Memblok ) = 1
      XSize.l = DBReadMemblockDWord( Memblok, 0 )
      YSize.l = DBReadMemblockDWord( Memblok, 4 )
      Depth.l = DBReadMemblockDWord( Memblok, 8 ) / 8
      If XPos < XSize And YPos < YSize
        If XPos > -1 And YPos > -1
          Adr.l = 12 + ( XPos * Depth ) + ( YPos * Xsize * Depth )
          Select Depth
            Case 1 : DBWriteMemblockByte( Memblok, Adr, RGBColor )
            Case 2 : DBWriteMemblockWord( Memblok, Adr, RGBColor )
            Case 4 : DBWriteMemblockDWord( Memblok, Adr, RGBColor )
           EndSelect
         EndIf
       EndIf
     EndIf
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l MBCIMGetPixel( Memblok.l, XPos.l, YPos.l )
  RGBColor.l = 0
  If Memblok > 0
    If DBMemblockExist( Memblok ) = 1
      XSize.l = DBReadMemblockDWord( Memblok, 0 )
      YSize.l = DBReadMemblockDWord( Memblok, 4 )
      Depth.l = DBReadMemblockDWord( Memblok, 8 ) / 8
      If XPos < XSize And YPos < YSize
        If XPos > -1 And YPos > -1
          Adr.l = 12 + ( XPos * Depth ) + ( YPos * Xsize * Depth )
          Select Depth
            Case 1 : RGBColor = DBReadMemblockByte( Memblok, Adr )
            Case 2 : RGBColor = DBReadMemblockWordLLL( Memblok, Adr )
            Case 4 : RGBColor = DBReadMemblockDWord( Memblok, Adr )
           EndSelect
         EndIf
       EndIf
     EndIf
   EndIf
  ProcedureReturn RGBColor
 EndProcedure

; IDE Options = PureBasic 4.10 Beta 2 (Windows - x86)
; CursorPosition = 327
; FirstLine = 320
; Folding = ----