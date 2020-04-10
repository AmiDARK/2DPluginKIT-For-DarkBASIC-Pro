;
; *******************************************************
; *                                                     *
; * 2DPlugKIT Include File : COLLISION SYSTEM FUNCTIONS *
; *                                                     *
; *******************************************************
; This include contain all functions for the 2D collision system
;
;**************************************************************************************************************
; P2DK_GetARGBLayerPixel( LayerID.l, XPos.l, YPos.l )
; P2DK_GetLayerMaskPixel( LayerID.l, XPos.l, YPos.l )
; P2DK_GetNMAPLayerPixel( LayerID.l, XPos.l, YPos.l )
; P2DK_SetCollisionMODE( CollisionMODE.l )
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetARGBLayerPixel( LayerID.l, XPos.l, YPos.l )
  RGBPixel.l = 0
  If IsLayerOk( LayerID ) = 1 And PlugINITIALIZED = 1
    If XPos > 0 : XTile.l = XPos / Layers( LayerID )\TileWIDTH : Else : XTile = 0 : EndIf
    If YPos > 0 : YTile.l = YPos / Layers( LayerID )\TileHEIGHT : Else : YTile = 0 : EndIf
    TileID = P2DK_GetLayerTileID( LayerID, XTile, YTile )
    If TileID > 0
      XPosIn.l = XPos - ( XTile * Layers( LayerID )\TileWIDTH )
      YPosIn.l = YPos - ( YTile * Layers( LayerID )\TileHEIGHT )
      MemoryPTR.l = 12 + ( ( ( Tiles( TileID )\Width * YPosIn ) + XPosIn ) * 4 )
; Removed to avoid MEMBLOCK USAGE
;      ImageMBCPtr.l = DBGetMemblockPtr( Tiles( TileID )\ImageMBC )
;      RGBPixel = PeekL( ImageMBCPtr + MemoryPTR )
; Now directly use GETIMAGEDATA for direct reading.
      RGBPixel = P2DK_GetImagePixel( Tiles( TileID )\ImageLOADED, XPosIn, YPosIn )
     EndIf
   EndIf
  ProcedureReturn RGBPixel
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetLayerMaskPixel( LayerID.l, XPos.l, YPos.l )
  MASKPixel.l = 0
  If IsLayerOk( LayerID ) = 1 And PlugINITIALIZED = 1
    If XPos > 0 : XTile.l = XPos / Layers( LayerID )\TileWIDTH : Else : XTile = 0 : EndIf
    If YPos > 0 : YTile.l = YPos / Layers( LayerID )\TileHEIGHT : Else : YTile = 0 : EndIf
    TileID = P2DK_GetLayerTileID( LayerID, XTile, YTile )
    If TileID > 0
      XPosIn.l = XPos - ( XTile * Layers( LayerID )\TileWIDTH )
      YPosIn.l = YPos - ( YTile * Layers( LayerID )\TileHEIGHT )
      MASKPixel = GetTileMASKPixel( TileID, XPosIn, YPosIn )
     EndIf
   EndIf
  ProcedureReturn MASKPixel
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetNMAPLayerPixel( LayerID.l, XPos.l, YPos.l )
  RGBPixel.l = 0
  If IsLayerOk( LayerID ) = 1 And PlugINITIALIZED = 1
    If XPos > 0 : XTile.l = XPos / Layers( LayerID )\TileWIDTH : Else : XTile = 0 : EndIf
    If YPos > 0 : YTile.l = YPos / Layers( LayerID )\TileHEIGHT : Else : YTile = 0 : EndIf
    TileID = P2DK_GetLayerTileID( LayerID, XTile, YTile )
    If TileID > 0
      XPosIn.l = XPos - ( XTile * Layers( LayerID )\TileWIDTH )
      YPosIn.l = YPos - ( YTile * Layers( LayerID )\TileHEIGHT )
      MemoryPTR.l = 12 + ( ( ( Tiles( TileID )\Width * YPosIn ) + XPosIn ) * 4 )
      If Tiles( TileID )\NMapIMAGE > 0
; Removed to avoid MEMBLOCK USAGE
;        ImageMBCPtr.l = DBGetMemblockPtr( Tiles( TileID )\NMapIMAGE )
;        RGBPixel = PeekL( ImageMBCPtr + MemoryPTR )
; Now directly use GETIMAGEDATA for direct reading.
      RGBPixel = P2DK_GetImagePixel( Tiles( TileID )\NMapIMAGE, XPosIn, YPosIn )
       EndIf
     EndIf
   EndIf
  ProcedureReturn RGBPixel
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetCollisionMODE( CollisionMODE.l )
  Setup\CollisionMODE = CollisionMODE
 EndProcedure
;
;**************************************************************************************************************
;

; IDE Options = PureBasic v4.02 (Windows - x86)
; CursorPosition = 17
; Folding = -