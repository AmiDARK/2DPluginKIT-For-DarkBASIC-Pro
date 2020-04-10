
; ********************************************
; *                                          *
; * 2DPlugKIT Include File : TILES FUNCTIONS *
; *                                           
; ********************************************
; This include contain functions related to tiles handling.
;**************************************************************************************************************
; P2DK_SetTilesLocation( GetPATH.l )
; GetTilesCount()
;**************************************************************************************************************
; P2DK_ReserveTiles( TilesCOUNT.l, Width.l, Height.l )
; P2DK_PrepareTILES()
;******************************************************************************** TILES ***********************
; P2DK_CreateTile( TileID.l, ImageID.l, TransparencyFLAG.l )
; P2DK_CreateTileEx( TileID2.l, ImageID2.l )
; P2DK_LoadTileInternal( FileNAMESTR.s, TileID.l, TransparencyFLAG.l )
; P2DK_LoadTile( FileNAMEPTR.l, TileID.l, TransparencyFLAG.l )
; P2DK_LoadTileEx( FileNAMEPTR.l, TileID.l )
; P2DK_ChangeTileImage( TileID.l, NewImageID.l, TransparencyFLAG.l )
; P2DK_ChangeTileImageEx( TileID2.l, NewImageID2.l )
;******************************************************************************** MASKS ***********************
; SetTileMASKPixel( TileID.l, XPos.l, YPos.l, PixelRGB8.l )
; = GetTileMASKPixel( TileID.l, XPos.l, YPos.l )
; ClearTileMASKPixel( TileID.l )
; P2DK_SetTileMask( TileID.l, MaskIMAGE.l )
; P2DK_LoadTileMASKInternal( FileNAMESTR.s, TileID.l )
; P2DK_LoadTileMASK( FileNAMEPTR.l, TileID.l )
; P2DK_DeleteTileMask( TileID.l )
;***************************************************************************** NORMAL MAPS ********************
; = GetTileNMAPPixel( TileID.l, XPos.l, YPos.l )
; P2DK_SetTileNormalMAP( TileID.l, NMapIMAGE.l )
; P2DK_LoadTileNMAPInternal( FileNAMESTR.s, TileID.l )
; P2DK_LoadTileNMAP( FileNAMEPTR.l, TileID.l )
; P2DK_DeleteTileNMap( TileID.l )
;**************************************************************************************************************
; P2DK_DeleteTile( TileID.l )
;****************************************************************************** RENDERING *********************
; DBE_DrawSpriteTile( TileID.l, XPos.l, YPos.l )
; P2DK_StartTILESRendering()
; P2DK_StopTILESRendering()
; P2DK_PasteTile( TileID.l, XPos.l, YPos.l )
; P2DK_PasteTileEx( TileID.l, XPos.l, YPos.l, Transparency.l )
;******************************************************************************* FILE IO **********************
; P2DK_WriteTileToFile( ChannelID.l, TileID.l )
; P2DK_WriteTilesDefinitionToFile( Channel.l )
; P2DK_ReadTileFromFile( Channel.l )
; P2DK_ReadTilesDefinitionFromFile( Channel.l )
;**************************************************************************************************************
; P2DK_SetTileTransparency( TileID.l, TransparencyFLAG.l )
;**************************************************************************************************************
; = P2DK_GetTileExist( TileID.l )
; = P2DK_GetTileWidth( TileID.l )
; = P2DK_GetTileHeight( TileID.l )
; = P2DK_GetTileTransparency( TileID.l )
; = P2DK_GetTileImage( TileID.l )
; = P2DK_GetTileNMapExist( TileID.l )
; = P2DK_GetTileNMapIMAGE( TileID.l )
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetTilesLocation( GetPATH.l )
  If GetPATH <> 0
    GetPATHStr.s = PeekS( GetPATH )
    CallCFunctionFast( *GlobPtr\CreateDeleteString, GetPATH, 0 )
    TilesLOCATION = GetPATHStr
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l GetTilesCount()
  TotalCOUNT.l = 0
  For TileID = 1 To 16384
    TotalCOUNT = TotalCOUNT + Tiles( TileID )\Active
   Next TileID 
  ProcedureReturn TotalCOUNT
 EndProcedure
;
;**************************************************************************************************************
; Crée l'espace pour stoquer les tiles et les masques de collision.
ProcedureCDLL P2DK_ReserveTiles( TilesCOUNT.l, Width.l, Height.l )
  ; En premier, on supprime les tiles précédemment crées ou réservées.
  If GroupedTiles\BLOCK <> 0 : GroupedTiles\BLOCK = MBC_Delete( GroupedTiles\BLOCK ) : EndIf
  If GroupedTiles\ImageID <> 0 : GroupedTiles\ImageID = IMG_Delete( GroupedTiles\ImageID ) : EndIf
  ; On calcule la dimension de l'image nécessaire pour contenir toutes les tiles.
  TilesPerLines.l = 512 / Width
  YTilesLines.l = ( TilesCOUNT / TilesPerLines ) + 1
  ; On stoque les données nécessaires.
  GroupedTiles\TilesCOUNT = TilesCOUNT
  GroupedTiles\TilesWIDTH = Width
  GroupedTiles\TilesHEIGHT = Height
  GroupedTiles\TilesXCount = TilesPerLines
  GroupedTiles\TilesYCount = YTilesLines
  GroupedTiles\ImgWIDTH = 512
  GroupedTiles\ImgHEIGHT = YTilesLines * Height
  If Setup\UseM2E <> 0
    GroupedTiles\BLOCK = MBC_MakeMemblockImage( GroupedTiles\ImgWIDTH, GroupedTiles\ImgHEIGHT, 32 )
   EndIf
  ; On réserve un gros bloc mémoire qui contiendra tout les masques de collisions des tiles.
  MaskSIZE.l = Width * Height * TilesCOUNT
  GroupedTiles\MaskSIZE = MaskSIZE
  GroupedTiles\MaskMBC = MBC_DynamicMake( MaskSIZE )
  GroupedTiles\MaskPTR = DBGetMemblockPTR( GroupedTiles\MaskMBC )
 EndProcedure
;
;**************************************************************************************************************
; Création de l'image finale qui sera utilisée pour créer les tiles.
ProcedureCDLL P2DK_PrepareTILES()
  ; En premier, on supprime les tiles précédemment crées.
  If GroupedTiles\ImageID <> 0 : GroupedTiles\ImageID = IMG_Delete( GroupedTiles\ImageID ) : EndIf
  If GroupedTiles\BLOCK <> 0  And PlugINITIALIZED = 1
    Select Setup\UseM2E
      Case 1
        GroupedTiles\ImageID = IMG_MakeImageFromMemblock( GroupedTiles\BLOCK )
        GroupedTiles\M2ESprite = DXS_CreateSpriteFromImage( GroupedTiles\ImageID )
        DXS_SetSpriteTileSet( GroupedTiles\M2ESprite, GroupedTiles\TilesXCount, GroupedTiles\TilesYCount )
      Case 2
        GroupedTiles\ImageID = IMG_MakeImageFromMemblock( GroupedTiles\BLOCK )
        GroupedTiles\DBSprite = SPR_DynamicSprite( -1024, -1024, GroupedTiles\ImageID )
        DBSetSprite( GroupedTiles\DBSprite, 0, 1 )
     EndSelect
   Else
     If Setup\UseM2E <> 0
       MessageRequester( "2DPlugKIT Error", "You must RESERVE TILES before use PREPARE TILES" )
      EndIf
   EndIf
 EndProcedure
;
;**************************************************************************************************************
; Création d'une nouvelle tile à partir d'une image.
ProcedureCDLL P2DK_CreateTile( TileID.l, ImageID.l, TransparencyFLAG.l )
  If TileID > 0 And TileID < 16384 And PlugINITIALIZED = 1
    If ImageID > 0
      If DBGetImageExist( ImageID ) = 1
        If Tiles( TileID )\Active = 0
          Tiles( TileID )\Active = 1
          Tiles( TileID )\FileName = ""
          Tiles( TileID )\ImageLOADED = ImageID
          Tiles( TileID )\EXTImage = 0
          RESULT.l = DBGetImageWidth( ImageID )
          Tiles( TileID )\Width = RESULT
          RESULT = DBGetImageHeight( ImageID )
          Tiles( TileID )\Height = RESULT
          If GroupedTiles\BLOCK <> 0
            ImageMBC = MBC_DynamicMakeFromImage( ImageID )
            YTile.l = ( TileID - 1 ) / GroupedTiles\TilesXCount
            XTile.l = ( TileID - 1 ) - ( YTile * GroupedTiles\TilesXCount )
            XTarget.l = XTile * GroupedTiles\TilesWIDTH
            YTarget.l = YTile * GroupedTiles\TilesHEIGHT
            CopyMemblockImage( ImageMBC, 0, 0, Tiles( TileID )\Width, Tiles( TileID )\Height, GroupedTiles\BLOCK, XTarget, YTarget )
            ImageMBC = MBC_Delete( ImageMBC )
           EndIf
          Tiles( TileID )\Transparency = TransparencyFLAG
          Tiles( TileID )\AnimationID = 0
         Else
          MessageRequester( "2DPlugKIT Error", "Tile already exist." )
         EndIf
       Else
        MessageRequester( "2DPlugKIT Error", "Cannot create tile, image does not exist." )
       EndIf
     Else
      MessageRequester( "2DPlugKIT Error", "Cannot create tile, image number is invalid." )
     EndIf
   Else
    MessageRequester( "2DPlugKIT Error", "Tile number is invalid." )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_CreateTileEx( TileID2.l, ImageID2.l )
  P2DK_CreateTile( TileID2, ImageID2, Setup\DefaultTransparency )
 EndProcedure
;
;**************************************************************************************************************
;
Procedure P2DK_LoadTileInternal( FileNAMESTR.s, TileID.l, TransparencyFLAG.l )
  If TileID > 0 And TileID < 16384 And PlugINITIALIZED = 1
    FILE$ = FileNAMESTR
    If DBGetFileExist( TilesLOCATION + FileNAMESTR ) = 1 : FILE$ = TilesLOCATION + FileNAMESTR : EndIf
    If DBGetFileExist( TilesLOCATION + "\" + FileNAMESTR ) = 1 : FILE$ = TilesLOCATION + "\" + FileNAMESTR : EndIf
    If DBGetFileExist( DBGetDir() + TilesLOCATION + FileNAMESTR ) = 1 : FILE$ = DBGetDir() + TilesLOCATION + FileNAMESTR : EndIf
    If Len( File$ ) > 0
      ImageID.l = IMG_DynamicLoad( FILE$ )
      P2DK_CreateTile( TileID, ImageID, TransparencyFLAG )
      Tiles( TileID )\EXTImage = 2 ; Force le flag à 2 pour signaler que l'image a été chargée par le plugin.
      Tiles( TileID )\FileNAME = STRExtractFileName( FILE$ )
     Else
      MessageRequester( "2DPlugKIT Error", "Cannot find the tile file on disk" )
     EndIf
   Else
    MessageRequester( "2DPlugKIT Error", "Tile ID Is invalid, can't load it" )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_LoadTile( FileNAMEPTR.l, TileID.l, TransparencyFLAG.l )
  If FileNAMEPTR <> 0
    FileNAMESTR.s = PeekS( FileNAMEPTR )
    CallCFunctionFast( *GlobPtr\CreateDeleteString, FileNAMEPTR, 0 )
    P2DK_LoadTileInternal( FileNAMESTR, TileID, TransparencyFLAG )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_LoadTileEx( FileNAMEPTR.l, TileID.l )
  If FileNAMEPTR <> 0
    FileNAMESTR.s = PeekS( FileNAMEPTR )
    CallCFunctionFast( *GlobPtr\CreateDeleteString, FileNAMEPTR, 0 )
    P2DK_LoadTileInternal( FileNAMESTR, TileID, Setup\DefaultTransparency )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_ChangeTileImage( TileID.l, NewImageID.l, TransparencyFLAG.l )
  If TileID > 0 And TileID < 16384 And PlugINITIALIZED = 1
    If Tiles( TileID )\Active = 1
      If DBGetImageExist( NewImageID ) = 1
        ; Si une image existe déjà, on la supprime si nécessaire
        If Tiles( TileID )\EXTImage = 2
          Tiles( TileID )\ImageLOADED = IMG_Delete( Tiles( TileID )\ImageLOADED )
         EndIf
        ; On assigne la nouvelle en image chargée externe.
        Tiles( TileID )\FileName = ""
        Tiles( TileID )\ImageLOADED = NewImageID
        Tiles( TileID )\EXTImage = 0
        Tiles( TileID )\Width = DBGetImageWidth( NewImageID )
        Tiles( TileID )\Height = DBGetImageHeight( NewImageID )
        Tiles( TileID )\Transparency = TransparencyFLAG
        ; On copie l'image dans le bloc de préparation des tiles.
        YTile.l = ( TileID - 1 ) / GroupedTiles\TilesXCount
        XTile.l = ( TileID - 1 ) - ( YTile * GroupedTiles\TilesXCount )
        XTarget.l = XTile * GroupedTiles\TilesWIDTH
        YTarget.l = YTile * GroupedTiles\TilesHEIGHT
        ImageMBC = MBC_DynamicMakeFromImage( NewImageID )
        CopyMemblockImage( ImageMBC, 0, 0, Tiles( TileID )\Width, Tiles( TileID )\Height, GroupedTiles\BLOCK, XTarget, YTarget )
        ImageMBC = MBC_Delete( ImageMBC ) 
       Else
        MessageRequester( "2DPlugKIT Error", "Cannot create tile, image does not exist" )
       EndIf
     Else
      MessageRequester( "2DPlugKIT Error", "Tile does not exist" )
     EndIf
   Else
    MessageRequester( "2DPlugKIT Error", "Tile number is invalid" )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_ChangeTileImageEx( TileID2.l, NewImageID2.l )
  If TileID > 0 And TileID < 16384 And PlugINITIALIZED = 1
    P2DK_ChangeTileImage( TileID2, NewImageID2, Tiles( TileID2 )\Transparency )
   Else
    MessageRequester( "2DPlugKIT Error", "Tile number is invalid" )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
Procedure SetTileMASKPixel( TileID.l, XPos.l, YPos.l, PixelRGB8.l )
  TileADR.l = GroupedTiles\MaskPTR + ( ( GroupedTiles\TilesWIDTH * GroupedTiles\TilesHEIGHT ) * ( TileID - 1 ) )
  PixelADR.l = TileADR + ( GroupedTiles\TilesWIDTH  * YPos ) + XPos
  PokeB( PixelADR, PixelRGB8 )
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l GetTileMASKPixel( TileID.l, XPos.l, YPos.l )
  TileADR.l = GroupedTiles\MaskPTR + ( ( GroupedTiles\TilesWIDTH * GroupedTiles\TilesHEIGHT ) * ( TileID - 1 ) )
  PixelADR.l = TileADR + ( GroupedTiles\TilesWIDTH  * YPos ) + XPos
  PixelRGB8.l = PeekB( PixelADR )
  ProcedureReturn PixelRGB8
 EndProcedure
;
;**************************************************************************************************************
;
Procedure ClearTileMASKPixel( TileID.l )
  TileADR.l = GroupedTiles\MaskPTR + ( ( GroupedTiles\TilesWIDTH * GroupedTiles\TilesHEIGHT ) * ( TileID - 1 ) )
  For CLoop = 0 To ( GroupedTiles\TilesWIDTH * GroupedTiles\TilesHEIGHT ) - 1
    PokeB( TileADR + CLoop, 0 )
   Next CLoop
 EndProcedure

;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetTileMask( TileID.l, MaskIMAGE.l )
  If TileID > 0 And TileID < 16384 And PlugINITIALIZED = 1
    If Tiles( TileID )\Active = 1
      If MaskIMAGE > 0
        If DBGetImageExist( MaskIMAGE ) = 1
          ; Création du bloc mémoire qui stockera l'image de masque 8 bits finale.
          Width.l = DBGetImageWidth( MaskIMAGE ) : Height.l = DBGetImageHeight( MaskIMAGE )
          ; Création du bloc mémoire temporaire pour stocker l'image initiale du masque.
          MaskMBC.l = MBC_DynamicMakeFromImage( MaskIMAGE )
          ; Création du masque 8 bits.
          For YLoop = 0 To Height -1
            For XLoop = 0 To Width -1
              PixelR.l = MBCIMGetPixel( MaskMBC, XLoop, YLoop )
              Pixel = DBRgbR( PixelR ) | DBRgbG( PixelR ) | DBRgbB( PixelR )
              SetTileMASKPixel( TileID, XLoop, YLoop, Pixel ) ; Now use unique memblock for all.
             Next XLoop
           Next YLoop
          Tiles( TileID )\MASKFileName = ""
          ; Suppression de l'image du masque temporaire et sauvegarde du masque final.
          MaskMBC = MBC_Delete( MaskMBC )
         Else
          MessageRequester( "2DPlugKIT Error", "Cannot create tile mask, image does not exist." )
         EndIf
       Else
        MessageRequester(  "2DPlugKIT Error", "Cannot create tile mask, image number is invalid." )
       EndIf
     Else
      MessageRequester( "2DPlugKIT Error", "Tile does not exist." )
     EndIf
   Else
    MessageRequester( "2DPlugKIT Error", "Tile number is invalid." )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
Procedure P2DK_LoadTileMASKInternal( FileNAMESTR.s, TileID.l )
  If TileID > 0 And TileID < 16384 And PlugINITIALIZED = 1
    If Tiles( TileID )\Active = 1
      If DBGetFileExist( FileNAMESTR ) = 1 : FILE$ = FileNAMESTR : EndIf
      If DBGetFileExist( TilesLOCATION + FileNAMESTR ) = 1 : FILE$ = TilesLOCATION + FileNAMESTR : EndIf
      If DBGetFileExist( TilesLOCATION + "\" + FileNAMESTR ) = 1 : FILE$ = TilesLOCATION + "\" + FileNAMESTR : EndIf
      If DBGetFileExist( DBGetDir() + TilesLOCATION + FileNAMESTR ) = 1 : FILE$ = DBGetDir() + TilesLOCATION + FileNAMESTR : EndIf
      If Len( FILE$ ) > 0
        ImageID.l = IMG_DynamicLoad( FILE$ )      
        ; On crée le bloc mémoire de la tile
        P2DK_SetTileMask( TileID, ImageID )
        Tiles( TileID )\MASKFileNAME = STRExtractFileName( FILE$ )
        ImageID = IMG_Delete( ImageID )
       EndIf
     EndIf
   EndIf
 EndProcedure;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_LoadTileMASK( FileNAMEPTR.l, TileID.l )
  If FileNAMEPTR <> 0
    FileNAMESTR.s = PeekS( FileNAMEPTR )
    CallCFunctionFast( *GlobPtr\CreateDeleteString, FileNAMEPTR, 0 )
    P2DK_LoadTileMASKInternal( FileNAMESTR, TileID )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_DeleteTileMask( TileID.l )
  If TileID > 0 And TileID < 16384 And PlugINITIALIZED = 1
    If Tiles( TileID )\Active = 1
      Tiles( TileID )\MASKFileName = ""
      ClearTileMASKPixel( TileID )
     Else
      MessageRequester( "2DPlugKIT Error", "Tile does not exist" )
     EndIf
   Else
    MessageRequester( "2DPlugKIT Error", "Tile number is invalid" )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l GetTileNMAPPixel( TileID.l, XPos.l, YPos.l )
  PixelRGB32.l = P2DK_GetImagePixel( Tiles( TileID )\NMapIMAGE, XPos, YPos )
  ProcedureReturn PixelRGB32
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetTileNormalMAP( TileID.l, NMapIMAGE.l )
  If TileID > 0 And TileID < 16384 And PlugINITIALIZED = 1
    If Tiles( TileID )\Active = 1
      If NMapIMAGE > 0
        If DBGetImageExist( NMapIMAGE ) = 1
          Tiles( TileID )\NMapIMAGE = NMapIMAGE
          Tiles( TileID )\EXTNMap = 0
          Tiles( TileID )\NMapFileNAME = ""
         Else
          MessageRequester( "2DPlugKIT Error", "Cannot create tile, image does not exist" )
         EndIf
       Else
        MessageRequester(  "2DPlugKIT Error", "Cannot create tile, image number is invalid" )
       EndIf
     Else
      MessageRequester( "2DPlugKIT Error", "Tile does not exist" )
     EndIf
   Else
    MessageRequester( "2DPlugKIT Error", "Tile number is invalid" )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
Procedure P2DK_LoadTileNMAPInternal( FileNAMESTR.s, TileID.l )
  If TileID > 0 And TileID < 16384 And PlugINITIALIZED = 1
    If Tiles( TileID )\Active = 1
      If DBGetFileExist( FileNAMESTR ) = 1 : FILE$ = FileNAMESTR : EndIf
      If DBGetFileExist( TilesLOCATION + FileNAMESTR ) = 1 : FILE$ = TilesLOCATION + FileNAMESTR : EndIf
      If DBGetFileExist( TilesLOCATION + "\" + FileNAMESTR ) = 1 : FILE$ = TilesLOCATION + "\" + FileNAMESTR : EndIf
      If DBGetFileExist( DBGetDir() + TilesLOCATION + FileNAMESTR ) = 1 : FILE$ = DBGetDir() + TilesLOCATION + FileNAMESTR : EndIf
      If Len( FILE$ ) > 0
        ImageID.l = IMG_DynamicLoad( FILE$ )      
        ; On crée le bloc mémoire de la tile
        P2DK_SetTileNormalMAP( TileID.l, ImageID )
        Tiles( TileID )\EXTNMap = 2 ; Force l'image comme chargée par le plugin.
        Tiles( TileID )\NMapFileNAME = STRExtractFileName( FILE$ )
        ImageID = IMG_Delete( ImageID )
       EndIf
     EndIf
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_LoadTileNMAP( FileNAMEPTR.l, TileID.l )
  If FileNAMEPTR <> 0
    FileNAMESTR.s = PeekS( FileNAMEPTR )
    CallCFunctionFast( *GlobPtr\CreateDeleteString, FileNAMEPTR, 0 )
    P2DK_LoadTileNMAPInternal( FileNAMESTR, TileID )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_DeleteTileNMap( TileID.l )
  If TileID > 0 And TileID < 16384 And PlugINITIALIZED = 1
    If Tiles( TileID )\Active = 1
      If Tiles( TileID )\EXTNMap = 2
        Tiles( TileID )\NMapIMAGE = IMG_Delete( Tiles( TileID )\NMapIMAGE )
       EndIf
      Tiles( TileID )\EXTNMap = 0
      Tiles( TileID )\NMAPFileName = ""
     Else
      MessageRequester( "2DPlugKIT Error", "Tile does not exist." )
     EndIf
   Else
    MessageRequester( "2DPlugKIT Error", "Tile number is invalid." )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_DeleteTile( TileID.l )
  If TileID > 0 And TileID < 16384 And PlugINITIALIZED = 1
    If Tiles( TileID )\Active = 1
      P2DK_DeleteTileMask( TileID )
      P2DK_DeleteTileNMap( TileID )
      If Tiles( TileID )\EXTImage = 2
        Tiles( TileID )\ImageLOADED = IMG_Delete( Tiles( TileID )\ImageLOADED )
       Else
        Tiles( TileID )\ImageLOADED = 0
       EndIf
      Tiles( TileID )\EXTImage = 0
      Tiles( TileID )\Active = 0
      Tiles( TileID )\FileName = ""
      Tiles( TileID )\Width = 0
      Tiles( TileID )\Height = 0
      Tiles( TileID )\Transparency = 0
      Tiles( TileID )\AnimationID = 0
     Else
      MessageRequester( "2DPlugKIT Error", "Tile does not exist." )
     EndIf
   Else
    MessageRequester( "2DPlugKIT Error", "Tile number is invalid." )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
Procedure DBE_DrawSpriteTile( TileID.l, XPos.l, YPos.l )
  TileID = TileID - 1 ; To force Tiles IDs to start at index 0.
  YTile.l = TileID / GroupedTiles\TilesXCount
  XTile.l = TileID - ( YTile * GroupedTiles\TilesXCount )
  DBSizeSprite( GroupedTiles\DBSprite, GroupedTiles\TilesWIDTH, GroupedTiles\TilesHEIGHT )
  XMin.f = ( XTile * GroupedTiles\TilesWIDTH ) / 512.0
  YMin.f = ( YTile * GroupedTiles\TilesHEIGHT ) / GroupedTiles\ImgHEIGHT
  XMax.f = ( ( XTile + 1 ) * GroupedTiles\TilesWIDTH ) / 512.0
  YMax.f = ( ( YTile + 1 ) * GroupedTiles\TilesHEIGHT ) / GroupedTiles\ImgHEIGHT
  DBSetTextureCoordinates( GroupedTiles\DBSprite, 0, XMin, YMin )
  DBSetTextureCoordinates( GroupedTiles\DBSprite, 1, XMax, YMin )
  DBSetTextureCoordinates( GroupedTiles\DBSprite, 2, XMin, YMax )
  DBSetTextureCoordinates( GroupedTiles\DBSprite, 3, XMax, YMax )
  DBPasteSprite( GroupedTiles\DBSprite, XPos, YPos )
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_StartTILESRendering()
  If GroupedTiles\M2ESprite <> 0 And PlugINITIALIZED = 1
    DXS_BeginSpriteRender( GroupedTiles\M2ESprite )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_StopTILESRendering()
  If GroupedTiles\M2ESprite <> 0 And PlugINITIALIZED = 1
    DXS_EndSpriteRender( GroupedTiles\M2ESprite )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_PasteTile( TileID.l, XPos.l, YPos.l )
  If TileID > 0 And TileID < 16384 And PlugINITIALIZED = 1
    If Tiles( TileID )\Active = 1
      If Tiles( TileID )\AnimationID > 0
        TileID = Tiles( TileID )\TileANIMFrame
       EndIf
      Select Setup\UseM2E
        Case 0
          DBPasteImage1( Tiles( TileID )\ImageLOADED, XPos, YPos, Tiles( TileID )\Transparency )
        Case 1
          DXS_DrawSpriteTileA( GroupedTiles\M2ESprite, TileID, XPos, YPos )
        Case 2
          DBE_DrawSpriteTile( TileID, XPos, YPos )
       EndSelect
     EndIf
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_PasteTileEx( TileID.l, XPos.l, YPos.l, Transparency.l )
  If TileID > 0 And TileID < 16384 And PlugINITIALIZED = 1
    If Tiles( TileID )\Active = 1
      If Tiles( TileID )\AnimationID > 0
        TileID = Tiles( TileID )\TileANIMFrame
       EndIf
      Select Setup\UseM2E
        Case 0
          DBPasteImage1( Tiles( TileID )\ImageLOADED, XPos, YPos, Transparency )
        Case 1
          DXS_DrawSpriteTileA( GroupedTiles\M2ESprite, TileID, XPos, YPos )
        Case 2
          DBE_DrawSpriteTile( TileID, XPos, YPos )
       EndSelect
     EndIf
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_WriteTileToFile( ChannelID.l, TileID.l )
  If Tiles( TileID )\Active = 1 And PlugINITIALIZED = 1
    DBWriteString( ChannelID, "[2DPKNewTile]" )
    DBWriteLong( ChannelID, TileID ) ; Write TileID
    If Tiles( TileID )\FileNAME = ""
      Tiles( TileID )\FileNAME = "null"
      MessageRequester( "2DPlugKIT Warning", "Tile#" + Str( TileID ) + " does not have any filename to use" )
     EndIf
    DBWriteString( ChannelID, Tiles( TileID )\FileNAME )
    DBWriteLong( ChannelID, Tiles( TileID )\Width )
    DBWriteLong( ChannelID, Tiles( TileID )\Height )
    DBWriteLong( ChannelID, Tiles( TileID )\Transparency )
    If Tiles( TileID )\MASKFileName = "" : Tiles( TileID )\MASKFileName = "null" : EndIf
    DBWriteString( ChannelID, Tiles( TileID )\MASKFileName )
    If Tiles( TileID )\NMAPFileName = "" : Tiles( TileID )\NMAPFileName = "null" : EndIf
    DBWriteString( ChannelID, Tiles( TileID )\NMAPFileName )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_ReadTileFromFile( Channel.l )
  _HEADER$ = DBReadString( Channel )
  If _HEADER$ = "[2DPKNewTile]" And PlugINITIALIZED = 1
    ; Lecture des informations pour la création des tiles.
    TileID.l = DBReadLong( Channel )
    FileNAME.s = DBReadString( Channel )
    TWidth.l = DBReadLong( Channel ) ; These two values are in fact useless because they will be redefined
    THeight.l = DBReadLong( Channel ) ; when the image will be loaded to create the tile back.
    TranspREADEN.l = DBReadLong( Channel )
    MASKFileName.s = DBReadString( Channel )
    NMAPFileName.s = DBReadString( Channel )
    P2DK_LoadTileInternal( FileNAME, TileID, TranspREADEN )
    If MASKFileName = "" Or MASKFileName = "null"
      MASKFileName = Left( FileNAME, Len( FileNAME ) - 4 ) + "[mask]" + Right( FileName, 4 )
     EndIf
    If NMAPFileName = "" Or NMAPFileName = "null"
      NMAPFileName = Left( FileNAME, Len( FileNAME ) - 4 ) + "[nmap]" + Right( FileName, 4 )
     EndIf
    If Len( MASKFileName ) > 0 : P2DK_LoadTileMASKInternal( MASKFileName, TileID ) : EndIf
    If Len( NMAPFileName ) > 0 : P2DK_LoadTileNMAPInternal( NMAPFileName, TileID ) : EndIf
   Else
;    If _HEADER$ <> "[2DPKTilesDefinitionEND]"
;      MessageRequester( "2DPlugKIT Error", "File HEADER unknown : " + _HEADER$ )
;     EndIf
    TileID = 0
   EndIf
  ProcedureReturn TileID
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_WriteTilesDefinitionToFile( Channel.l )
  DBWriteString( Channel, "[2DPKTilesDefinition]" )
  DBWriteLong( Channel, TilesINFORMATIONSVersion )
  DBWriteString( Channel, TilesLOCATION )
  DBWriteLong( Channel, GetTilesCount() )
  DBWriteLong( Channel, Setup\DefaultWIDTH )
  DBWriteLong( Channel, Setup\DefaultHEIGHT )
  For TLoop = 1 To 16384
    P2DK_WriteTileToFile( Channel, TLoop )
   Next TLoop
  DBWriteString( Channel, "[2DPKTilesDefinitionEND]" )
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_ReadTilesDefinitionFromFile( Channel.l )
  TilesCOUNT2.l = 0
  _HEADER$ = DBReadString( Channel )
  If _HEADER$ = "[2DPKTilesDefinition]" And PlugINITIALIZED = 1
    TilesINFORMATIONS.l = DBReadLong( Channel )
    TilesLOCATION2.s = DBReadString( Channel )
    TilesCOUNT.l = DBReadLong( Channel )
    Setup\DefaultWIDTH = DBReadLong( Channel )
    Setup\DefaultHEIGHT = DBReadLong( Channel )
    If TilesCOUNT > 0
      P2DK_ReserveTILES( TilesCOUNT, Setup\DefaultWIDTH, Setup\DefaultHEIGHT )
      Repeat
        TileID.l = P2DK_ReadTileFromFile( Channel.l )
        If TileID <> 0 : TilesCOUNT2 = TilesCOUNT2 + 1 : EndIf
       Until TileID = 0
      P2DK_PrepareTILES()
     EndIf
   Else
    MessageRequester( "2DPlugKIT Warning", "This file does not contain tiles definition" )
   EndIf
  ProcedureReturn TilesCOUNT2
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetTileTransparency( TileID.l, TransparencyFLAG.l )
  If TileID > 0 And TileID < 16384
    If Tiles( TileID )\Active = 1
      If TransparencyFLAG = 0 Or TransparencyFLAG = 1
        Tiles( TileID )\Transparency = TransparencyFLAG
       Else
        MessageRequester(  "2DPlugKIT Error", "Transparency flag contain incorrect value" )
       EndIf
     Else
      MessageRequester( "2DPlugKIT Error", "Tile does not exist" )
     EndIf
   Else
    MessageRequester( "2DPlugKIT Error", "Tile number is invalid" )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetTileExist( TileID.l )
  If TileID > 0 And TileID < 16384
    Retour.l = Tiles( TileID )\Active
   Else
    Retour = 0
    MessageRequester( "2DPlugKIT Error", "Tile number is invalid" )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetTileWidth( TileID.l )
  If TileID > 0 And TileID < 16384
    If Tiles( TileID )\Active = 1
      Retour.l = Tiles( TileID )\Width
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
ProcedureCDLL.l P2DK_GetTileHeight( TileID.l )
  If TileID > 0 And TileID < 16384
    If Tiles( TileID )\Active = 1
      Retour.l = Tiles( TileID )\Height
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
ProcedureCDLL.l P2DK_GetTileTransparency( TileID.l )
  If TileID > 0 And TileID < 16384
    If Tiles( TileID )\Active = 1
      Retour.l = Tiles( TileID )\Transparency
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
ProcedureCDLL.l P2DK_GetTileImage( TileID.l )
  If TileID > 0 And TileID < 16384
    If Tiles( TileID )\Active = 1
      Retour.l = Tiles( TileID )\ImageLOADED
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
ProcedureCDLL.l P2DK_GetTileNMapExist( TileID.l )
  If TileID > 0 And TileID < 16384
    If Tiles( TileID )\NMapIMAGE <> 0 
      IsExist.l = 1
     Else
      IsExist = 0
     EndIf
   Else
    IsExist = 0
    MessageRequester( "2DPlugKIT Error", "Tile number is invalid" )
   EndIf
  ProcedureReturn IsExist
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetTileNMapIMAGE( TileID.l )
  If TileID > 0 And TileID < 16384
    If Tiles( TileID )\Active = 1
      Retour.l = Tiles( TileID )\NMapIMAGE
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
ProcedureCDLL.l P2DK_GetTilesSprite()
  SPRID.l = GroupedTiles\ImageID
  ProcedureReturn SPRID
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetSpriteRESIZEMode( Mode.l )
  Setup\SpriteMODE = Mode
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_ClearTiles()
  ; On supprime d'abord toutes les tiles existantes.
  For XLoop = 1 To 16384
    If Tiles( XLoop )\Active = 1 : P2DK_DeleteTile( XLoop ) : EndIf
   Next
  ; On supprime les sprites crées si ils existent
  Select Setup\UseM2E
    Case 1
      DXS_DeleteSprite( GroupedTiles\M2ESprite )
      GroupedTiles\M2ESprite = 0
    Case 2
      GroupedTiles\DBSprite = SPR_Delete( GroupedTiles\DBSprite )
   EndSelect
  ; Si l'on a déjà crée les tiles, on supprime le block mémoire et l'image générée.
  If GroupedTiles\BLOCK <> 0 : GroupedTiles\BLOCK = MBC_Delete( GroupedTiles\BLOCK ) : EndIf
  If GroupedTiles\ImageID <> 0 : GroupedTiles\ImageID = IMG_Delete( GroupedTiles\ImageID ) : EndIf
  If GroupedTiles\MaskMBC <> 0
    GroupedTiles\MaskMBC = MBC_Delete( GroupedTiles\MaskMBC )
    GroupedTiles\MaskSIZE = 0
    GroupedTiles\MaskPTR = 0
   EndIf
  GroupedTiles\TilesCOUNT = 0
  GroupedTiles\TilesWIDTH = 0
  GroupedTiles\TilesHEIGHT = 0
  GroupedTiles\TilesXCount = 0
  GroupedTiles\TilesYCount = 0
  GroupedTiles\ImgWIDTH = 0
  GroupedTiles\ImgHEIGHT = 0
 EndProcedure
;
;**************************************************************************************************************
;
;
;**************************************************************************************************************
;

; IDE Options = PureBasic 4.10 Beta 2 (Windows - x86)
; CursorPosition = 541
; FirstLine = 546
; Folding = --------