Structure P2DLights_Type
  XPos.l         ; Coordonn�e X du point d'ancrage de la lumi�re 2D.
  YPos.l         ; Coordonn�e Y du point d'ancrage de la lumi�re 2D.
  Mode.l         ; Type de lumi�re : 0 = Concentrique, 1 = Spot.
  Rouge.l        ; Valeur RGB Rouge de la lumi�re.
  Vert.l         ; Valeur RGB Vert de la lumi�re.
  Bleu.l         ; Valeur RGB Bleu de la lumi�re.
  Range.l        ; Dimension du c�ne d'action de la lumi�re.
  LightQUALITY.l ; Qualit� du trac� 2D de la lumi�re.
  Intensity.l    ; Intensit� de la lumi�re.
  Active.l       ; La lumi�re est � ajouter dans le rendu 2D et existe
  Hide.l         ; La lumi�re est visible ou cach�e.
  ImageLOADED.l  ; Num�ro de l'image utilis�e pour repr�senter la lumi�re
  SpriteUSED.l   ; Num�ro du sprite utilis� pour rendre la lumi�re dans la 2D.
 EndStructure
Global Dim P2DLights.P2DLights_Type( 256 )
;
; Cr�er une lumi�re 2D pour utiliser dans des d�cors 2D.
; XPos, YPos = Coordonn�es 2D du point d'ancrage de la lumi�re 2D
; RGBColor = Valeur en ROUGE, VERT, BLEUE de la couleur
; Range = Dimension de la lumi�re
; LightQUALITY = Qualit� du rendu de la lumi�re
ProcedureCDLL.l P2D_AddVirtualLight( XPos.l, YPos.l, RGBColor.l, RRange.l, LightQUALITY.l )
  LightID.l = 0
  ; 1. Checking des valeurs importantes.
  If LightQUALITY < 1 : LightQUALITY = 1 : EndIf
  Range.f = PeekF( @RRange )
  If Range < 8 : Range = 8 : EndIf
  ; 1. On cr�e un bloc m�moire dans lequel on va tracer l'image � utiliser pour la lumi�re.
  ImageWIDTH.l = ( Range * 2 ) / LightQUALITY
  IMGMBC.l = MBC_MakeMemblocksImage( ImageWIDTH, ImageWIDTH, 32 )
  ; 2. Si le bloc m�moire est cr�e, on cr�e l'image de la lumi�re dedans.
  If IMGMBC > 0
    CALCRange.l = ( Range * 2 ) - 1
    Red.f = DBRGBR( RGBColor )
    Green.f = DBRGBG( RGBColor )
    Blue.f = DBRGBB( RGBColor )
    ScaleCOLOR.f = 100.0 / Range
    ; 3. Trac� de la lumi�re dans le bloc m�moire.
    Repeat
      Percent.f = CalcRANGE * ScaleCOLOR
      NRED.l = Red - ( ScaleCOLOR * Percent )
      NGREEN.l = Green - ( ScaleCOLOR * Percent )
      NBLUE.l = Blue - ( ScaleCOLOR * Percent )
      If NRED < 0 : NRED = 0 : EndIf
      If NGREEN < 0 : NGREEN = 0 : EndIf
      If NBLUE < 0 : NBLUE = 0 : EndIf
      Transparency.l = ( ( NRED + NGREEN + NBLUE ) / 3 ) + 1
      If Transparency < 0 : Transparency = 0 : EndIf
      NewRGBColor = DBRGB( NRED, NGREEN, NBLUE ) + ( Transparency * 16777216 )
      IMCircle( IMGMBC, ImageWIDTH / 2, ImageWIDTH / 2, CalcRANGE , NewRGBColor, 1 )
      CalcRANGE = CalcRANGE - 2
     Until CALCRange < 1 
    Transparency.l = ( ( RED + GREEN + BLUE ) / 3 )
    NewRGBColor = DBRGB( RED, GREEN, BLUE ) + ( Transparency * 16777216 )
    IMPlot( IMGMBC, ImageWIDTH/2, ImageWIDTH/2, NewRGBColor )
    ; 4. On cr�e l'image d�finitive qui repr�sentera la lumi�re virtuelle.
    NewLIGHTImage.l = IMG_MakeImageFromMemblock( IMGMBC )
    IMGMBC = MBC_Delete( IMGMBC )
    ; 5. Si l'image a �t� correctement cr�e, on cr�e la lumi�re finale 2D.
    If NewLIGHTImage > 0
      LightID = DLH_GetNextFreeItem()
      P2DLights( LightID )\XPos = XPos
      P2DLights( LightID )\YPos = YPos
      P2DLights( LightID )\Rouge = Red
      P2DLights( LightID )\Vert = Green
      P2DLights( LightID )\Bleu = Blue
      P2DLights( LightID )\Mode = 0
      P2DLights( LightID )\Range = Range
      P2DLights( LightID )\LightQUALITY = LightQUALITY
      P2DLights( LightID )\Intensity = 200
      P2DLights( LightID )\Active = 1
      P2DLights( LightID )\ImageLOADED = NewLIGHTImage
      XShift.l = ImageWIDTH / 2
      P2DLights( LightID )\SpriteUSED = SPR_DynamicSprite( XPos - XShift, YPos - XShift, NewLIGHTImage )
      DBSetSprite( P2DLights( LightID )\SpriteUSED, 1, 0 )
      DBSetSpriteAlpha( P2DLights( LightID )\SpriteUSED, 200 )
     EndIf
   EndIf
  ProcedureReturn LightID
 EndProcedure

ProcedureCDLL P2D_SetLightIntensity( LightID.l, Intensity.l )
  If LightID > 0 And LightID < 256
    If P2DLights( LightID )\Active = 1
      If Intensity < 0 : Intensity = 0 : EndIf
      If Intensity > 255 : Intensity = 255 : EndIf
      P2DLights( LightID )\Intensity = Intensity
      DBSetSpriteAlpha( P2DLights( LightID )\SpriteUSED, Intensity )
     EndIf
   EndIf
 EndProcedure

ProcedureCDLL P2D_PositionLight( LightID.l, XPos.l, YPos.l )
  If LightID > 0 And LightID < 256
    If P2DLights( LightID )\Active = 1
      P2DLights( LightID )\XPos = XPos
      P2DLights( LightID )\YPos = YPos
      DBSprite( P2DLights( LightID )\SpriteUSED, XPos, YPos, P2DLights( LightID )\ImageLOADED )
     EndIf
   EndIf
 EndProcedure

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -