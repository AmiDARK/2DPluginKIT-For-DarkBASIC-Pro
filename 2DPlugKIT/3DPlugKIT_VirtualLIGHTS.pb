;
; *****************************************************
; *                                                   *
; * 2DPlugKIT Include File : VIRTUAL LIGHTS FUNCTIONS *
; *                                                   *
; *****************************************************
; This include contain functions related to Virtual Lighting handling.
;**************************************************************************************************************
; Procedure P2DK_UpdateV2DLight( LightID.l )
; P2DK_AddVirtualLight( XPos.l, YPos.l, RGBColor.l, RRange.l, Intensite.l, Mode.l, LayerID.l )
; P2DK_AttachLightToLayer( LightID.l, LayerID.l )
; P2DK_DetachLightFromLayer( LightID.l )
; P2DK_HideLIGHT( LightID.l )
; P2DK_ShowLIGHT( LightID.l )
; P2DK_IsLightLayerAttached( LightID.l )
; P2DK_IsLightHIDDEN( LightID.l )
; P2DK_GetP2DKVLightExist( LightID.l )
; P2DK_DeleteP2DKVLight( LightID.l )
; P2DK_PositionP2DKVLight( LightID.l, XPos.l, YPos.l )
;**************************************************************************************************************
; Declaration to use LAYERS functions from LIGHT INCLUDE:
DeclareCDLL P2DK_AttachLightToLayer( LightID.l, LayerID.l )
;**************************************************************************************************************
ProcedureCDLL P2DK_UpdateV2DLight( LightID.l )
  If P2DLights( LightID )\ImageLOADED > 0
    P2DLights( LightID )\ImageLOADED = IMG_Delete( P2DLights( LightID )\ImageLOADED )
   EndIf
  XPos.l = P2DLights( LightID )\XPos
  YPos.l = P2DLights( LightID )\YPos
  Range.f = P2DLights( LightID )\Range
  ImageWIDTH.l = Range * 2
  LayerID.l = P2DLights( LightID )\LayerID
  Mode.l = P2DLights( LightID )\Mode
  Red.l = P2DLights( LightID )\Rouge
  Green.l = P2DLights( LightID )\Vert
  Blue.l = P2DLights( LightID )\Bleu
  Intensite.l = P2DLights( LightID )\Intensite
  ; 3. On crée un bloc mémoire dans lequel on va tracer l'image à utiliser pour la lumière.
  IMGMBC.l = MBC_MakeMemblockImage( ImageWIDTH, ImageWIDTH, 32 )
  ; 4. Si le bloc mémoire est crée, on crée l'image de la lumière dedans.
  If IMGMBC > 0 And PlugINITIALIZED = 1
    ; 4B. Si la lumière projète des ombres on crée le bloc (8 bits) de calcul et on le définit.
    If P2DLights( LightID )\CastSHADOWS = 1
      ShadowMAPMBC.l = MBC_MakeMemblockImage( ImageWIDTH, ImageWIDTH, 8 )
      ; Mise en place des données de normal mapping.
      For YLoop = 0 To ImageWIDTH - 1
        For XLoop = 0 To ImageWIDTH - 1
          PixelX.l = ( P2DLights( LightID )\XPos + XLoop ) - ( ImageWIDTH / 2 )
          PixelY.l = ( P2DLights( LightID )\YPos + YLoop ) - ( ImageWIDTH / 2 )
          ; Coordonnées de la tile survolée.
          TileX.l = PixelX / Layers( LayerID )\TileWIDTH
          TileY.l = PixelY / Layers( LayerID )\TileHEIGHT
          ; Coordonnées du pixel de la tile survolée.
          TileXPixel.l = PixelX - ( TileX * Layers( LayerID )\TileWIDTH )
          TileYPixel.l = PixelY - ( TileY * Layers( LayerID )\TileHEIGHT )
          ; On saisit le contenu du mask de collision de la tile si celui ci existe.
          TileID.l = P2DK_GetLayerTileID( LayerID, TileX, TileY )
          If TileID > 0
;            MaskBUFFER.l = Tiles( TileID )\MaskBUFFER ; Memblock Image 8bits.
;            If MaskBUFFER > 0
;              Pixel.l = P2DK_Read8BitsPixel( MaskBUFFER, TileXPixel, TileYPixel )
              Pixel.l = GetTileMASKPixel( TileID.l, TileXPixel, TileYPixel )
              P2DK_Write8BitsPixel( ShadowMAPMBC, XLoop, YLoop, Pixel )
;             Else
;              P2DK_Write8BitsPixel( ShadowMAPMBC, XLoop, YLoop, 0 )
;             EndIf
           Else
            P2DK_Write8BitsPixel( ShadowMAPMBC, XLoop, YLoop, 0 )
           EndIf
         Next XLoop
       Next YLoop
     EndIf
   ; 4B. Si la lumière utilise le Normal Mapping, alors on récupère toutes ses informations dans un bloc mémoire.
    ClrMAPMBC.l = MBC_MakeMemblockImage( ImageWIDTH, ImageWIDTH, 32 )
    If P2DLights( LightID )\CastNMAP = 1
      ; Création du bloc mémoire 32 bits pour stoquer l'effet de lumière de la texture de fond.
      LightMAPMBC.l = MBC_MakeMemblockImage( ImageWIDTH, ImageWIDTH, 32 )
      ; Mise en place des données de normal mapping.
      For YLoop = 0 To ImageWIDTH - 1
        For XLoop = 0 To ImageWIDTH - 1
          PixelX.l = ( P2DLights( LightID )\XPos + XLoop ) - ( ImageWIDTH / 2 )
          PixelY.l = ( P2DLights( LightID )\YPos + YLoop ) - ( ImageWIDTH / 2 )
          ; Coordonnées de la tile survolée.
          TileX.l = PixelX / Layers( LayerID )\TileWIDTH
          TileY.l = PixelY / Layers( LayerID )\TileHEIGHT
          ; Coordonnées du pixel de la tile survolée.
          TileXPixel.l = PixelX - ( TileX * Layers( LayerID )\TileWIDTH )
          TileYPixel.l = PixelY - ( TileY * Layers( LayerID )\TileHEIGHT )
          ; On saisit le contenu du mask de collision de la tile si celui ci existe.
          TileID.l = P2DK_GetLayerTileID( LayerID, TileX, TileY )
          If TileID > 0
            If Tiles( TileID )\NMapIMAGE > 0
              Pixel.l = P2DK_GetImagePixel( Tiles( TileID )\NMapIMAGE, TileXPixel, TileYPixel )
              MBCIMPlot( LightMAPMBC, XLoop, YLoop, Pixel )
             EndIf
            Pixel2.l = P2DK_GetImagePixel( Tiles( TileID )\ImageLOADED, TileXPixel, TileYPixel )
            MBCIMPlot( ClrMAPMBC, XLoop, YLoop, Pixel2 )
           Else
            MBCIMPlot( LightMAPMBC, XLoop, YLoop, DBRGB( 127, 127, 255 ) )
           EndIf
         Next XLoop
       Next YLoop
     Else
      ; Mise en place des données de color mapping.
      For YLoop = 0 To ImageWIDTH - 1
        For XLoop = 0 To ImageWIDTH - 1
          PixelX.l = ( P2DLights( LightID )\XPos + XLoop ) - ( ImageWIDTH / 2 )
          PixelY.l = ( P2DLights( LightID )\YPos + YLoop ) - ( ImageWIDTH / 2 )
          ; Coordonnées de la tile survolée.
          TileX.l = PixelX / Layers( LayerID )\TileWIDTH
          TileY.l = PixelY / Layers( LayerID )\TileHEIGHT
          ; Coordonnées du pixel de la tile survolée.
          TileXPixel.l = PixelX - ( TileX * Layers( LayerID )\TileWIDTH )
          TileYPixel.l = PixelY - ( TileY * Layers( LayerID )\TileHEIGHT )
          ; On saisit le contenu du mask de collision de la tile si celui ci existe.
          TileID.l = P2DK_GetLayerTileID( LayerID, TileX, TileY )
          If TileID > 0
            Pixel2.l = P2DK_GetImagePixel( Tiles( TileID )\ImageLOADED, TileXPixel, TileYPixel )
            MBCIMPlot( ClrMAPMBC, XLoop, YLoop, Pixel2 )
           Else
            MBCIMPlot( ClrMAPMBC, XLoop, YLoop, DBRGB( 0, 0, 0 ) )
           EndIf
         Next XLoop
       Next YLoop
     EndIf
   ; 5. Tracé de la lumière dans le bloc mémoire.
    Percent.f = 100.0 / Range
    For YLoop = 0 To ImageWIDTH -1
      For XLoop = 0 To ImageWIDTH - 1
        Dist.f = GetDistance2D( XLoop, YLoop, ImageWIDTH / 2.0, ImageWIDTH / 2.0 )
        NewPCT.f = ( 100.0 - ( Dist * Percent ) ) / 100.0
        XDist.l = ( ImageWIDTH / 2.0 ) - XLoop : YDist.l = ( ImageWIDTH / 2.0 ) - YLoop
        XPCT.f = ( 100.0 - ( XDist * Percent ) ) / 100.0
        YPCT.f = ( 100.0 - ( YDist * Percent ) ) / 100.0
        NewPCTR.f = Deg2Rad( 90 * NewPCT )
        If NewPCT > 0
          NewRED.l = Red * NewPCT
          NewGREEN.l = Green * NewPCT
          NewBLUE.l = Blue * NewPCT
          Alfa.l = NewPCT * 2.55 * Intensite
          ; On crée l'effet d'ombre si la fonctionalité est activée.
          If P2DLights( LightID )\CastSHADOWS = 1
            Middle.f = ImageWIDTH / 2.0
            SHADOW.l = 0
            If Abs( XDist ) > Abs( YDist )
              YAdd.f = YDist / Abs( XDist )
              For ZLoop = 1 To Abs( XDist ) - 1
                XPosS = Middle - ( ZLoop * Sign( XDist ) ) : YPosS = Middle - ( Zloop * YAdd )
                MaskPIX.l = P2DK_Read8BitsPixel( ShadowMAPMBC, XPosS, YPosS )
                If MaskPIX <> 0 : SHADOW = 1 : EndIf
                If SHADOW = 1 : P2DK_Write8BitsPixel( ShadowMAPMBC, XPosS, YPosS, 255 ) : EndIf
               Next ZLoop
             Else
              XAdd.f = XDist / Abs( YDist )
              For ZLoop = 1 To Abs( YDist ) - 1 
                YPosS = Middle - ( ZLoop * Sign( YDist ) ) : XPosS = Middle - ( Zloop * XAdd )
                MaskPIX.l = P2DK_Read8BitsPixel( ShadowMAPMBC, XPosS, YPosS )
                If MaskPIX <> 0 : SHADOW = 1 : EndIf
                If SHADOW = 1 : P2DK_Write8BitsPixel( ShadowMAPMBC, XPosS, YPosS, 255 ) : EndIf
               Next ZLoop
             EndIf
            If SHADOW = 1
              NewRED = NewRED / 8
              NewGREEN = NewGREEN / 8
              NewBLUE = NewBLUE / 8
             EndIf
           EndIf
          ; On ajoute les valeurs des composantes Rouge, Vert et bleu en utilisant les données de NormalMAP.
          If P2DLights( LightID )\CastNMAP = 1 And SHADOW = 0
            CPixel.l = MBCIMGetPixel( ClrMAPMBC, XLoop, YLoop )
            NMapPIXEL.l = MBCIMGetPixel( LightMAPMBC, XLoop, YLoop )
            ZPosN.f = ( DBRGBB( NMapPIXEL ) / 255.0 )
            XPosN.f = ( 1.0 - ( DBRGBR( NMapPIXEL ) / 127.5 ) ) * ZPosN
            YPosN.f = ( 1.0 - ( DBRGBG( NMapPIXEL ) / 127.5 ) ) * ZPosN
;            If DBRGBR( NMapPIXEL ) <> 127 And DBRGBG( NMapPIXEL ) <> 127
            If CPixel <> 0 And NMapPixel <> 0 And NMapPixel <> $7F7FFF
              ; On Calcule l'angle du point projeté de la lumière.
              If ( -XLoop ) < 0 : U0 = 0 : Else : U0 = 1 : EndIf
              AlfaL.f = Rad2Deg( 2 * ATan( YLoop / XLoop ) + ( 3.14 * U0 * ( YLoop / Abs( YLoop ) ) ) )
              ; On calcule l'angle du point de la texture de normal mapping avec le rouge et vert.
              If ( -XPosN ) < 0 : U0 = 0 : Else : U0 = 1 : EndIf
              AlfaN.f = Rad2Deg( 2 * ATan( YPosN / XPosN ) + ( 3.14 * U0 * ( YPosN / Abs( YPosN ) ) ) )
;              AlfaN = DBWrapValue( AlfaN + 180.0 )
              ; On calcule la différence d'angle en conservant le signe (pour l'orientation).
              DiffANGLE.f = AlfaL - AlfaN
              If DiffANGLE < -180.0 : DiffANGLE = DiffANGLE + 360.0 : EndIf
              If DiffANGLE > 180.0 : DiffANGLE = DiffANGLE - 360.0 : EndIf
              DiffANGLE = Abs( DiffANGLE )
              MultiPlier.f = 2.0 - ( DiffANGLE / 90.0 )
              NewRED = NewRED + ( DBRGBR( CPixel ) * Multiplier )
              If NewRED > 255 : NewRED = 255 : EndIf
              NewGREEN = NewGREEN + ( DBRGBG( CPixel ) * Multiplier )
              If NewGREEN > 255 : NewGREEN = 255 : EndIf
              NewBLUE = NewBLUE + ( DBRGBB( CPixel ) * Multiplier )
              If NewBLUE > 255 : NewBLUE = 255 : EndIf
              Alfa = Alfa * Multiplier
              If Alfa > 255 : Alfa = 255 : EndIf
             Else
                ; Si on utilise pas le Normal MAPPING alors on ajoute au moins les composantes de couleur originale.
              CPixel.l = MBCIMGetPixel( ClrMAPMBC, XLoop, YLoop )
              NewRED = NewRED + DBRGBR( CPixel )
              If NewRED > 255 : NewRED = 255 : EndIf
              NewGREEN = NewGREEN + DBRGBG( CPixel )
              If NewGREEN > 255 : NewGREEN = 255 : EndIf
              NewBLUE = NewBLUE + DBRGBB( CPixel )
              If NewBLUE > 255 : NewBLUE = 255 : EndIf
             EndIf
;           Else
           EndIf
            ; Si on utilise pas le Normal MAPPING alors on ajoute au moins les composantes de couleur originale.
            CPixel = MBCIMGetPixel( ClrMAPMBC, XLoop, YLoop )
            If P2DLights( LightID )\CastBRIGHT And SHADOW = 0
;              NewRED = NewRED + ( DBRGBR( CPixel ) *2 )
;              NewGREEN = NewGREEN + ( DBRGBG( CPixel ) *2 )
;              NewBLUE = NewBLUE + ( DBRGBB( CPixel ) *2 )
              NewRED = DBRGBR( CPixel ) * ( NewRED / 5.0 )
              NewGREEN = DBRGBG( CPixel ) * ( NewGREEN / 5.0 )
              NewBLUE = DBRGBB( CPixel ) * ( NewBLUE / 5.0 )
             Else
              NewRED = NewRED + DBRGBR( CPixel )
              NewGREEN = NewGREEN + DBRGBG( CPixel )
              NewBLUE = NewBLUE + DBRGBB( CPixel )
             EndIf
            If NewRED > 255 : NewRED = 255 : EndIf
            If NewGREEN > 255 : NewGREEN = 255 : EndIf
            If NewBLUE > 255 : NewBLUE = 255 : EndIf
            If NewRED + NewGREEN + NewBLUE = 0 : Alfa = 0 : EndIf
;           EndIf
          MBCIMPlot( IMGMBC, XLoop, YLoop, ARGB( Alfa, NewRED, NewGREEN, NewBLUE ) )
         EndIf
       Next XLoop
     Next YLoop
    ; 4. On crée l'image définitive qui représentera la lumière virtuelle.
    NewLIGHTImage.l = IMG_MakeImageFromMemblock( IMGMBC )
    If Setup\DebugMODE = 1
      DBSaveImage( "VLightMAPPING" + Str( LightID ) + ".png", NewLIGHTImage )
     EndIf
    P2DLights( LightID )\ImageLOADED = NewLIGHTImage
    ; 5. Suppression des données devenues inutiles.
    IMGMBC = MBC_Delete( IMGMBC )
    If LightMAPMBC > 0
      If Setup\DebugMODE = 1
        LightMAPIMG = IMG_MakeImageFromMemblock( LightMAPMBC )
        DBSaveImage( "VLightMAPPING_CALC" + Str( LightID ) + ".png", LightMAPIMG )
        LightMAPIMG = IMG_Delete( LightMAPIMG )
       EndIf
      LightMAPMBC = MBC_Delete( LightMAPMBC ) ; Suppression du bloc mémoire image NormalMAP si utilisé.
      If Setup\DebugMODE = 1
        ColorMAPIMG = IMG_MakeImageFromMemblock( ClrMAPMBC )
        DBSaveImage( "VLightMAPPING_CMAP" + Str( LightID ) + ".png", ColorMAPIMG )
        LightMAPIMG = IMG_Delete( LightMAPIMG )
       EndIf
      ClrMAPMBC = MBC_Delete( ClrMAPMBC )
     EndIf
    If ShadowMAPMBC > 0
      ShadowMAPMBC32 = MBC_MakeMemblockImage( ImageWIDTH, ImageWIDTH, 32 )
      For Xloop = 0 To ImageWIDTH - 1
        For YLoop = 0 To ImageWIDTH - 1
          Component.l = P2DK_Read8BitsPixel( ShadowMAPMBC, Xloop, YLoop )
          RGBColor = DBRgb( Component, Component, Component )
          MBCIMPlot( ShadowMAPMBC32, Xloop, YLoop, RGBColor )
         Next YLoop
       Next XLoop
      ShadowMAPMBC = MBC_Delete( ShadowMAPMBC )
      If Setup\DebugMODE = 1
        ShadowMAPPING = IMG_MakeImageFromMemblock( ShadowMAPMBC32 )
        DBSaveImage( "VLightSHADOWCASTING" + Str( LightID ) + ".png", ShadowMAPPING )
        ShadowMAPPING = IMG_Delete( ShadowMAPPING )
       EndIf
      ShadowMAPMBC32 = MBC_Delete( ShadowMAPMBC32 )
     EndIf
    ; 6. Si on utilise le plugin M2E D3D.DLL, on update pour créer le sprite.
    If Setup\UseM2E = 1
      If P2DLights( LightID )\M2ESprite <> 0 : DXS_DeleteSprite( P2DLights( LightID )\M2ESprite  ) : EndIf
      P2DLights( LightID )\M2ESprite = DXS_CreateSpriteFromImage( NewLIGHTImage )
     Else
      If P2DLights( LightID )\DBSprite <> 0 : P2DLights( LightID )\DBSprite = SPR_Delete( P2DLights( LightID )\DBSprite ) : EndIf
      P2DLights( LightID )\DBSprite = SPR_DynamicSprite( -1024, -1024, NewLIGHTImage )
     EndIf
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;Normal Map definition: Red maps from (0-255) To X (-1.0 - 1.0) ; Green maps from (0-255) To Y (-1.0 - 1.0) ; Blue maps from (0-255) To Z (0.0 - 1.0) 
ProcedureCDLL.l P2DK_AddVirtualLight( XPos.l, YPos.l, RGBColor.l, RRange.l, Intensite.l, Mode.l, LayerID.l )
  ; 1. Checking des valeurs importantes.
  Range.f = PeekF( @RRange )
  If Range < 8 : Range = 8 : EndIf
  ImageWIDTH.l = Range * 2
  Red.l = DBRGBR( RGBColor ) : Green.l = DBRGBG( RGBColor ) : Blue.l = DBRGBB( RGBColor )
  ; 2. Mise en place des valeurs dans les registres de la lumière crée.
  NLightID.l = DLH_GetNextFreeItem( 1 )
  P2DLights( NLightID )\XPos = XPos
  P2DLights( NLightID )\YPos = YPos
  P2DLights( NLightID )\Rouge = Red
  P2DLights( NLightID )\Vert = Green
  P2DLights( NLightID )\Bleu = Blue
  P2DLights( NLightID )\Range = Range
  P2DLights( NLightID )\Intensite = Intensite
  P2DLights( NLightID )\Active = 1
  P2DLights( NLightID )\Mode = Mode
  P2DLights( NLightID )\PlayMODE = 0
  P2DLights( NLightID )\ImgWIDTH = ImageWIDTH
  P2DLights( NLightID )\LayerID = LayerID
  P2DLights( NLightID )\CastSHADOWS = ( Mode & 2 ) / 2
  P2DLights( NLightID )\CastNMAP = Mode & 1
  P2DLights( NLightID )\CastBRIGHT = Mode & 4
  P2DK_AttachLightToLayer( NLightID, LayerID )
  P2DK_UpdateV2DLight( NLightID )
  ProcedureReturn NLightID
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_AttachLightToLayer( LightID.l, LayerID.l )
  If IsVLightOk( LightID ) = 1 And IsLayerOk( LayerID ) = 1 And PlugINITIALIZED = 1
    ; Si la lumière est déjà attachée à un layer, on la détache de ce layer.
    If P2DLights( LightID )\LayerID > 0
      P2DK_INTDetachLightFromLayer( LightID, P2DLights( LightID )\LayerID )
     EndIf
    ; Puis, on attache l'image au layer choisi si il existe.
    P2DK_INTAttachLightToLayer( LightID, LayerID )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_DetachLightFromLayer( LightID.l )
  If IsVLightOk( LightID ) = 1 And PlugINITIALIZED = 1
    ; Si la lumière est déjà attachée à un layer, on la détache de ce layer.
    If P2DLights( LightID )\LayerID > 0
      P2DK_INTDetachLightFromLayer( LightID, P2DLights( LightID )\LayerID )
     EndIf
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_HideLIGHT( LightID.l )
  If IsVLightOk( LightID ) = 1
    P2DLights( LightID )\Hide = 1
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_ShowLIGHT( LightID.l )
  If IsVLightOk( LightID ) = 1
    P2DLights( LightID )\Hide = 0
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_IsLightLayerAttached( LightID.l )
  If IsVLightOk( LightID ) = 1
    Retour = P2DLights( LightID )\LayerID
   Else
    Retour = 0
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_IsLightHIDDEN( LightID.l )
  If IsVLightOk( LightID ) = 1
    Retour = P2DLights( LightID )\Hide
   Else
    Retour = 0
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetP2DKVLightExist( LightID.l )
  If LightID > 0 And LightID < 65
    Retour.l = P2DLights( LightID )\Active
   Else
    Retour = 0
   EndIf
 ProcedureReturn Retour
EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetP2DKVLightRGBR( LightID.l )
  If LightID > 0 And LightID < 65
    Retour.l = P2DLights( LightID )\Rouge
   Else
    Retour = 0
   EndIf
 ProcedureReturn Retour
EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetP2DKVLightRGBG( LightID.l )
  If LightID > 0 And LightID < 65
    Retour.l = P2DLights( LightID )\Vert
   Else
    Retour = 0
   EndIf
 ProcedureReturn Retour
EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetP2DKVLightRGBB( LightID.l )
  If LightID > 0 And LightID < 65
    Retour.l = P2DLights( LightID )\Bleu
   Else
    Retour = 0
   EndIf
 ProcedureReturn Retour
EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetP2DKVLightPositionX( LightID.l )
  If LightID > 0 And LightID < 65
    Retour.l = P2DLights( LightID )\XPos
   Else
    Retour = 0
   EndIf
 ProcedureReturn Retour
EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetP2DKVLightPositionY( LightID.l )
  If LightID > 0 And LightID < 65
    Retour.l = P2DLights( LightID )\YPos
   Else
    Retour = 0
   EndIf
 ProcedureReturn Retour
EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_DeleteP2DKVLight( LightID.l )
  If IsVLightOk( LightID ) = 1 And PlugINITIALIZED = 1
    P2DK_DetachLightFromLayer( LightID ) ; On détache la lumière d'un éventuel layer au cas ou ...
    P2DLights( LightID )\Active =0
    If P2DLights( LightID )\ImageLOADED > 0
      P2DLights( LightID )\ImageLOADED = IMG_Delete( P2DLights( LightID )\ImageLOADED )
     EndIf
    P2DLights( LightID )\XPos = 0
    P2DLights( LightID )\YPos = 0
    P2DLights( LightID )\Rouge = 0
    P2DLights( LightID )\Vert = 0
    P2DLights( LightID )\Bleu = 0
    P2DLights( LightID )\Range = 0
    P2DLights( LightID )\Intensite = 0
    P2DLights( LightID )\Mode = 0
    P2DLights( LightID )\ImgWIDTH = 0
    P2DLights( LightID )\LayerID =0
    P2DLights( LightID )\CastSHADOWS = 0
    P2DLights( LightID )\CastNMAP = 0
    If P2DLights( LightID )\M2ESprite <> 0 : DXS_DeleteSprite( P2DLights( LightID )\M2ESprite  ) : EndIf
   EndIf
  LightID = 0
  ProcedureReturn LightID
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_PositionP2DKVLight( LightID.l, XPos.l, YPos.l )
  If IsVLightOk( LightID ) = 1 And PlugINITIALIZED = 1
    P2DLights( LightID )\XPos = XPos
    P2DLights( LightID )\YPos = YPos
    If P2DLights( LightID )\CastSHADOWS = 1 Or P2DLights( LightID )\CastNMAP = 1
      P2DK_UpdateV2DLight( LightID )
     EndIf
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetP2DKVLightColor( LightID.l, Red.l, Green.l, Blue.l )
  If IsVLightOk( LightID ) = 1 And PlugINITIALIZED = 1
    P2DLights( LightID )\Rouge = Red
    P2DLights( LightID )\Vert = Green
    P2DLights( LightID )\Bleu = Blue
    If P2DLights( LightID )\CastSHADOWS = 1 Or P2DLights( LightID )\CastNMAP = 1
      P2DK_UpdateV2DLight( LightID )
     EndIf
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetP2DKVLightRange( LightID.l, Range.l )
  If IsVLightOk( LightID ) = 1 And PlugINITIALIZED = 1
    P2DLights( LightID )\Range = Range
    P2DK_UpdateV2DLight( LightID )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetP2DKVLightIntensity( LightID.l, Intensite.l )
  If IsVLightOk( LightID ) = 1 And PlugINITIALIZED = 1
    P2DLights( LightID )\Intensite = Intensite
    P2DK_UpdateV2DLight( LightID )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetLightSTATIC( LightID.l )
  If IsVLightOk( LightID ) = 1 And PlugINITIALIZED = 1
    P2DLights( LightID )\PlayMODE = 0
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetLightFLAME( LightID.l )
  If IsVLightOk( LightID ) = 1 And PlugINITIALIZED = 1
    P2DLights( LightID )\PlayMODE = 1
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetLightPULSE( LightID.l )
  If IsVLightOk( LightID ) = 1 And PlugINITIALIZED = 1
    P2DLights( LightID )\PlayMODE = 2
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetLightFLASH( LightID.l )
  If IsVLightOk( LightID ) = 1 And PlugINITIALIZED = 1
    P2DLights( LightID )\PlayMODE = 3
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
; 0 = Statique, 1 = Torche, 2 = Pulse, 3 = Défectueuse
; IDE Options = PureBasic 4.10 Beta 2 (Windows - x86)
; CursorPosition = 38
; FirstLine = 35
; Folding = ----