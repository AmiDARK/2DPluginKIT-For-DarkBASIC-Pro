;
; *******************************************************
; *                                                     *
; * 2DPlugKIT Include File : COLLISION SYSTEM FUNCTIONS *
; *                                                     *
; *******************************************************
; This include contain all functions for the 2D collision system
;
;**************************************************************************************************************
; P2DK_INTAttachBobToLayer( BobID.l, LayerID.l )
; P2DK_INTDetachBOBFromLayer( BobID.l, LayerID.l )
; P2DK_AddBlitterObject( ImageID.l )
; P2DK_DetachBobFromLayer( BobID.l )
; P2DK_AttachBobToLayer( BlitterID.l, LayerID.l )
;**************************************************************************************************************
;
Procedure DBE_DrawBOBTile( BlitterID.l, XPos.l, YPos.l )
  TileID = Bobs( BlitterID )\CurrentFrame - 1 ; To force Tiles IDs to start at index 0.
  YTile.l = TileID / Bobs( BlitterID )\XTiles
  XTile.l = TileID - ( YTile * Bobs( BlitterID )\YTiles )
  DBSizeSprite( Bobs( BlitterID )\DBSprite, Bobs( BlitterID )\TilesWIDTH, Bobs( BlitterID )\TilesHEIGHT )
  XMin.f = ( XTile * Bobs( BlitterID )\TilesWIDTH ) / Bobs( BlitterID )\Width
  YMin.f = ( YTile * Bobs( BlitterID )\TilesHEIGHT ) / Bobs( BlitterID )\Height
  XMax.f = ( ( XTile + 1 ) * Bobs( BlitterID )\TilesWIDTH ) / Bobs( BlitterID )\Width
  YMax.f = ( ( YTile + 1 ) * Bobs( BlitterID )\TilesHEIGHT ) / Bobs( BlitterID )\Height
  DBSetTextureCoordinates( Bobs( BlitterID )\DBSprite, 0, XMin, YMin )
  DBSetTextureCoordinates( Bobs( BlitterID )\DBSprite, 1, XMax, YMin )
  DBSetTextureCoordinates( Bobs( BlitterID )\DBSprite, 2, XMin, YMax )
  DBSetTextureCoordinates( Bobs( BlitterID )\DBSprite, 3, XMax, YMax )
  DBPasteSprite( Bobs( BlitterID )\DBSprite, XPos, YPos )
 EndProcedure
; 
;**************************************************************************************************************
;
Procedure P2DK_INTAttachBobToLayer( BobID.l, LayerID.l )
  InPOS.l = 0
  Repeat
    InPOS = InPOS + 1
   Until LayersBOBS( LayerID, InPOS ) = 0 Or InPOS = 16384
  If LayersBOBS( LayerID, InPOS ) = 0
    LayersBOBS( LayerID, InPOS ) = BobID
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
Procedure P2DK_INTDetachBOBFromLayer( BobID.l, LayerID.l )
  InPOS.l = 0
  Repeat
    InPOS = InPOS + 1
   Until LayersBOBS( LayerID, InPOS ) = BobID Or InPOS = 16384
  If LayersBOBS( LayerID, InPOS ) = BobID
    Repeat
      LayersBOBS( LayerID, InPOS ) = LayersBOBS( LayerID, InPOS + 1 )
      InPOS = InPOS + 1
     Until InPOS = 16384 Or LayersBOBS( LayerID, InPOS ) = 0
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_AddBlitterObject( ImageID.l, TilesXCount.l, TilesYCount.l )
  If IsImageOk( ImageID ) = 1 And PlugINITIALIZED = 1
    BlitterID.l = DLH_GetNextFreeItem( 2 )
    Bobs( BlitterID )\Active = 1
    Bobs( BlitterID )\ImageID = ImageID
    Bobs( BlitterID )\EXTLoaded = 0
    Bobs( BlitterID )\AnimationID = 0
    Bobs( BlitterID )\LayerID = 0
    Bobs( BlitterID )\XPos = 0
    Bobs( BlitterID )\YPos = 0
    Bobs( BlitterID )\Hide = 0
    Bobs( BlitterID )\Transparency = Setup\DefaultTransparency
    Bobs( BlitterID )\Width = DBGetImageWidth( ImageID )
    Bobs( BlitterID )\Height = DBGetImageHeight( ImageID )
    Bobs( BlitterID )\XTiles = TilesXCount
    Bobs( BlitterID )\Ytiles = TilesYCount
    Bobs( BlitterID )\TilesWIDTH = Bobs( BlitterID )\Width / TilesXCount
    Bobs( BlitterID )\TilesHEIGHT = Bobs( BlitterID )\Height / TilesYCount
    Bobs( BlitterID )\FramesCOUNT = TilesXCount * TilesYCount
    Select Setup\UseM2E
      Case 0
        Bobs( BlitterID )\CurrentFRAME = ImageID
      Case 1
        Bobs( BlitterID )\M2ESprite = DXS_CreateSpriteFromImage( ImageID )
        DXS_SetSpriteTileSet( Bobs( BlitterID )\M2ESprite, TilesXCount, TilesYCount )
        Bobs( BlitterID )\CurrentFRAME = 1
      Case 2
        Bobs( BlitterID )\DBSprite = SPR_DynamicSprite( -1024, -1024, ImageID )
        Bobs( BlitterID )\CurrentFRAME = 1
     EndSelect
   Else
    BlitterID = 0
   EndIf
  ProcedureReturn BlitterID
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_InstanceBlitterObject( SourceID.l, XPos.l, YPos.l )
  If IsBlitterOk( SourceID ) = 1 And PlugINITIALIZED = 1
    BlitterID.l = DLH_GetNextFreeItem( 2 )
    Bobs( BlitterID )\Active = 1
    Bobs( BlitterID )\InstanceID = SourceID
    Bobs( BlitterID )\XPos = XPos
    Bobs( BlitterID )\YPos = YPos
    Bobs( BlitterID )\Width = Bobs( SourceID )\Width
    Bobs( BlitterID )\Height = Bobs( SourceID )\Height
   Else
    BlitterID = 0
    MessageRequester( "2DPlugKIT Error", "Source Bob does not exist or is invalid" )
   EndIf
  ProcedureReturn BlitterID
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_InstanceBlitterObjectEx( SourceID.l )
  If IsBlitterOk( SourceID ) = 1 And PlugINITIALIZED = 1
    BlitterID = P2DK_InstanceBlitterObject( SourceID, Bobs( SourceID )\XPos, Bobs( SourceID )\YPos )
   Else
    BlitterId = 0
   EndIf
  ProcedureReturn BlitterID
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_AddBlitterObjectEx( ImageID.l )
  BlitterID.l = P2DK_AddBlitterObject( ImageID.l, 1, 1 )
  ProcedureReturn BlitterID
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_LoadBlitterObject( FileNAMEPTR.l, TilesXCount.l, TilesYCount.l, TransparencyFLAG.l )
  If FileNAMEPTR <> 0 And PlugINITIALIZED = 1
    FileNAMESTR.s = PeekS( FileNAMEPTR )
    CallCFunctionFast( *GlobPtr\CreateDeleteString, FileNAMEPTR, 0 )
    IMAGEID.l = IMG_DynamicLoad( FileNAMESTR )
    BlitterID.l = P2DK_AddBlitterObject( IMAGEID, TilesXCount, TilesYCount )
    Bobs( BlitterID )\Transparency = TransparencyFLAG
    Bobs( BlitterID )\EXTLoaded = 2
   EndIf
  ProcedureReturn BlitterID
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_LoadBlitterObjectEx( Fichier.l, TilesXCount.l, TilesYCount.l )
  BlitterID.l = P2DK_LoadBlitterObject( Fichier.l, TilesXCount.l, TilesYCount.l, Setup\DefaultTransparency )
  ProcedureReturn BlitterID
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_LoadBlitterObjectEx2( Fichier.l, TransparencyFLAG.l )
  BlitterID.l = P2DK_LoadBlitterObject( Fichier.l, 1, 1, TransparencyFLAG )
  ProcedureReturn BlitterID
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_LoadBlitterObjectEx3( Fichier.l )
  BlitterID.l = P2DK_LoadBlitterObject( Fichier.l, 1, 1, Setup\DefaultTransparency )
  ProcedureReturn BlitterID
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_DetachBobFromLayer( BobID.l )
  If IsBlitterOk( BobID ) = 1 And PlugINITIALIZED = 1
    If Bobs( BobID )\LayerID > 0
      P2DK_INTDetachBOBFromLayer( BobID, Bobs( BobID )\LayerID )
      Bobs( BobID )\LayerID = 0
     EndIf
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_AttachBobToLayer( BlitterID.l, LayerID.l )
  If IsLayerOk( LayerID ) = 1 And IsBlitterOk( BlitterID ) = 1 And PlugINITIALIZED = 1
    If Bobs( BlitterID )\LayerID > 0 : P2DK_DetachBobFromLayer( BlitterID ) : EndIf
    Bobs( BlitterID )\LayerID = LayerID
    P2DK_INTAttachBobToLayer( BlitterID, LayerID )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_PositionBOB( BlitterID.l, XPos.l, YPos.l )
  If IsBlitterOk( BlitterID ) = 1 And PlugINITIALIZED = 1
    Bobs( BlitterID )\XPos = XPos
    Bobs( BlitterID )\YPos = YPos
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_HideBOB( BlitterID.l )
  If IsBlitterOk( BlitterID ) = 1
    Bobs( BlitterID )\Hide = 1
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_ShowBOB( BlitterID.l )
  If IsBlitterOk( BlitterID ) = 1
    Bobs( BlitterID )\Hide = 0
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetBobImage( BlitterID.l, ImageID.l )
  If IsBlitterOk( BlitterID ) = 1 And IsImageOk( ImageID ) = 1 And PlugINITIALIZED = 1
    If Bobs( BlitterID )\M2ESprite = 0
      Bobs( BlitterID )\CurrentFRAME = CurrentFRAME
     EndIf
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetBobFrame( BlitterID.l, FrameID.l )
  If IsBlitterOk( BlitterID ) = 1 And PlugINITIALIZED = 1
    If Bobs( BlitterID )\M2ESprite <> 0 And FrameID <= Bobs( BlitterID )\FramesCOUNT
      Bobs( BlitterID )\CurrentFRAME = FrameID
     EndIf
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_BeginBOBRender( BlitterID )
  If IsblitterOk( BlitterID ) = 1 And PlugINITIALIZED = 1
    DXS_BeginSpriteRender( Bobs( BlitterID )\M2ESprite )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_EndBOBRender( BlitterID )
  If IsblitterOk( BlitterID ) = 1 And PlugINITIALIZED = 1
    DXS_EndSpriteRender( Bobs( BlitterID )\M2ESprite )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_PasteBOB1( BlitterID.l, XPos.l, YPos.l, TranspFLAG.l )
  If IsblitterOk( BlitterID ) = 1 And PlugINITIALIZED = 1
    If Bobs( BlitterID )\InstanceID <> 0
      NBlitterID.l = Bobs( BlitterID )\InstanceID
     Else
      NBlitterID = BlitterID
     EndIf
    Select Setup\UseM2E
      Case 0
        DBPasteImage1( Bobs( NBlitterID )\CurrentFRAME, XPos, YPos, TranspFLAG )
      Case 1
        P2DK_BeginBOBRender( NBlitterID )
        DXS_DrawSpriteTileA( Bobs( NBlitterID )\M2ESprite, Bobs( NBlitterID )\CurrentFRAME, XPos, YPos )
        P2DK_EndBOBRender( NBlitterID )
      Case 2
        DBE_DrawBOBTile( NBlitterID, XPos, YPos )
     EndSelect
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_PasteBOB( BlitterID.l, XPos.l, YPos.l )
  P2DK_PasteBOB1( BlitterID, XPos, YPos, Bobs( BlitterID )\Transparency )
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_PasteBOBEx( BlitterID.l )
  P2DK_PasteBOB1( BlitterID, Bobs( BlitterID )\XPos, Bobs( BlitterID )\YPos, Bobs( BlitterID )\Transparency )
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetBobPosX( BlitterID )
  If Bobs( BlitterID )\Active = 1
    Retour.l = Bobs( BlitterID )\XPos
   Else
    Retour = 0
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetBobPosY( BlitterID )
  If Bobs( BlitterID )\Active = 1
    Retour.l = Bobs( BlitterID )\YPos
   Else
    Retour = 0
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetBobExist( BlitterID )
  Retour.l = Bobs( BlitterID )\Active
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetBobFrame( BlitterID )
  If Bobs( BlitterID )\Active = 1
    Retour.l = Bobs( BlitterID )\CurrentFRAME
   Else
    Retour = 0
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetBobTransparent( BlitterID )
  If Bobs( BlitterID )\Active = 1
    Retour.l = Bobs( BlitterID )\Transparency
   Else
    Retour = 0
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
;
;**************************************************************************************************************
;

; IDE Options = PureBasic 4.10 Beta 2 (Windows - x86)
; CursorPosition = 264
; FirstLine = 262
; Folding = -----