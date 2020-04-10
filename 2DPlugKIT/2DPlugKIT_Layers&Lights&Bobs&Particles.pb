;
; ********************************************
; *                                          *
; * 2DPlugKIT Include File : TILES FUNCTIONS *
; *                                           
; ********************************************
; This include contain functions related to Layers&Lighting handling.
;**************************************************************************************************************
; P2DK_INTAttachLightToLayer( LightID.l, LayerID.l )
; P2DK_INTDetachLightFromLayer( LightID.l, LayerID.l )
; P2DK_DisplayLayerLights( LayerID.l, XS.l, YS.l, XE.l, YE.l )
;**************************************************************************************************************
DeclareCDLL P2DK_UpdateParticlesID( ParticleID.l, XSHIFT.l, YSHIFT.L )
;
Procedure P2DK_INTAttachLightToLayer( LightID.l, LayerID.l )
  InPOS.l = 0
  Repeat
    InPOS = InPOS + 1
   Until LayersLights( LayerID, InPOS ) = 0 Or InPOS = 256
  If LayersLights( LayerID, InPOS ) = 0
    LayersLights( LayerID, InPOS ) = LightID
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
Procedure P2DK_INTDetachLightFromLayer( LightID.l, LayerID.l )
  InPOS.l = 0
  Repeat
    InPOS = InPOS + 1
   Until LayersLights( LayerID, InPOS ) = LightID Or InPOS = 256
  If LayersLights( LayerID, InPOS ) = LightID
    Repeat
      LayersLights( LayerID, InPOS ) = LayersLights( LayerID, InPOS + 1 )
      InPOS = InPOS + 1
     Until InPOS = 256 Or LayersLights( LayerID, InPOS ) = 0
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
Procedure P2DK_DisplayLayerLights( LayerID.l, XS.l, YS.l, XE.l, YE.l, XDisplay.l, YDisplay.l )
  ; Lecture des dimensions de l'écran pour le calcul de la zone de tracé.
  DisplayWIDTH.l = XE - XS : DisplayHEIGHT.l = YE - YS
  ; Calcul des 4 extrémités pour l'affichage des lumières.
  DispLEFT.l = Layers( LayerID )\XDisplay
  DispTOP.l = Layers( LayerID )\YDisplay
  DispRIGHT.l = Layers( LayerID )\XDisplay + DisplayWIDTH
  DispBOTTOM.l = Layers( LayerID )\YDisplay + DisplayHEIGHT
  ; Maintenant, on lit les lumières présentes dans le layer et on les affiche si cela est nécessaire.
  InPOS.l = 0
  Repeat
    InPOS = InPOS + 1
    If LayersLights( LayerID, InPOS ) > 0
      DisplayLIGHT.l = LayersLights( LayerID, InPOS )
      ; On n'affiche la lumière que si elle est à la fois active et non cachée.
      If P2DLights( DisplayLIGHT )\Active = 1 And P2DLights( DisplayLIGHT )\Hide = 0
        LightRAY.l = P2DLights( DisplayLIGHT )\ImgWIDTH / 2.0
;        LightRAY.l = P2DLights( DisplayLIGHT )\ImgWIDTH ; Force larger area to display light on screen borders.
        XPos.l = -5000000 : YPos.l = -5000000
        LXPos.l = P2DLights( DisplayLIGHT )\XPos
        LYPos.l = P2DLights( DisplayLIGHT )\YPos
        If LXpos + LightRAY > DispLEFT And LXpos - LightRAY < DispRIGHT
          If LYPos + LightRAY > DispTOP And LYPos - LightRAY < DispBOTTOM
            XPos = ( LXPos - XDisplay ) + XS
            YPos = ( LYPos - YDisplay ) + YS
            Select Setup\UseM2E
              Case 0
                DBPasteImage1( P2DLights( DisplayLIGHT )\ImageLOADED, XPos-LightRAY, YPos-LightRAY, 1 )
              Case 1
                DXS_SetSpriteAlpha( P2DLights( DisplayLIGHT )\M2ESprite, P2DLights( DisplayLIGHT )\Intensite * 2.5 )
                DXS_BeginSpriteRender( P2DLights( DisplayLIGHT )\M2ESprite )
                DXS_DrawSpriteA( P2DLights( DisplayLIGHT )\M2ESprite, XPos-LightRAY, YPos-LightRAY )
                DXS_EndSpriteRender( P2DLights( DisplayLIGHT )\M2ESprite )
              Case 2
                DBSetSpriteAlpha( P2DLights( DisplayLIGHT )\DBSprite, P2DLights( DisplayLIGHT )\Intensite * 2.5  )
                DBPasteSprite( P2DLights( DisplayLIGHT )\DBSprite, XPos-LightRAY, YPos-LightRAY )
             EndSelect
            P2DLights( DisplayLIGHT )\XDisplayPOS = XPos
            P2DLights( DisplayLIGHT )\YDisplayPOS = YPos
           EndIf
         EndIf
       EndIf
     EndIf
   Until InPOS = 256 Or LayersLights( LayerID, InPOS ) = 0
 EndProcedure
;
;**************************************************************************************************************
;
Procedure P2DK_DisplayLayerBOBS( LayerID.l, XS.l, YS.l, XE.l, YE.l, XDisplay.l, YDisplay.l )
  ; Lecture des dimensions de l'écran pour le calcul de la zone de tracé.
  DisplayWIDTH.l = XE - XS : DisplayHEIGHT.l = YE - YS
  ; Calcul des 4 extrémités pour l'affichage des lumières.
  DispLEFT.l = Layers( LayerID )\XDisplay
  DispTOP.l = Layers( LayerID )\YDisplay
  DispRIGHT.l = Layers( LayerID )\XDisplay + DisplayWIDTH
  DispBOTTOM.l = Layers( LayerID )\YDisplay + DisplayHEIGHT
  InPOS.l = 0
  Repeat
    InPOS = InPOS + 1
    If LayersBOBS( LayerID, InPOS ) > 0
      DisplayBOB.l = LayersBOBS( LayerID, InPOS )
      ; On n'affiche le BOB que si il est à la fois actif et non caché.
      If Bobs( DisplayBOB )\Active = 1 And Bobs( DisplayBOB )\Hide = 0
        XBob.l = Bobs( DisplayBOB )\XPos - XDisplay
        YBob.l = Bobs( DisplayBOB )\YPos - YDisplay
        If XBob > 0 - Bobs( DisplayBOB )\Width And XBob < ( XE - XS ) + Bobs( DisplayBOB )\Width
          If YBob > 0 - Bobs( DisplayBOB )\Height And YBob < ( YE - YS ) + Bobs( DisplayBOB )\Height
            P2DK_PasteBOB( DisplayBOB, XBob + XS , YBob + YS )
           EndIf
         EndIf
       EndIf
     EndIf
   Until InPOS = 16384 Or LayersBOBS( LayerID, InPOS ) = 0
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_UpdateLightEffects()
  OldTIMER.l = Setup\NewTIMER : Setup\NewTIMER = DBTimerL()
  Delay.f = ( ( Setup\NewTIMER - Setup\StartTIMER ) / 30.0 )
  If Delay > 100.0
    Count = Int( Delay / 100.0 ) : Delay = Delay - ( Count * 100 )
   EndIf
  Setup\LightEFFECTPercent = Delay
  For XLoop = 1 To 256
    If P2DLights( XLoop )\Active = 1
      ; 0 = Statique, 1 = Torche, 2 = Pulse, 3 = Défectueuse
      Select P2DLights( XLoop )\PlayMODE
        Case 1
          Intensity.l = ( Delay / 2 ) + 75
          If Intensity > 100 : Intensity = 200 - Intensity : EndIf
          P2DLights( XLoop )\Intensite = Intensity
        Case 2
          Intensity = Delay * 2
          If Intensity > 100 : Intensity = 200 - Intensity : EndIf
          P2DLights( XLoop )\Intensite = Intensity        
        Case 3
          Intensity = Random( 100 )
          P2DLights( XLoop )\Intensite = Intensity
          P2DLights( XLoop )\CyclePOS = Random( 2 )
       EndSelect
     EndIf
   Next XLoop
 EndProcedure
;
;**************************************************************************************************************
;
Procedure P2DK_INTAttachParticleToLayer( ParticleID.l, LayerID.l )
  InPOS.l = 0
  Repeat
    InPOS = InPOS + 1
   Until LayersParticle( LayerID, InPOS ) = 0 Or InPOS = 256
  If LayersParticle( LayerID, InPOS ) = 0
    LayersParticle( LayerID, InPOS ) = ParticleID
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
Procedure P2DK_INTDetachParticleFromLayer( ParticleID.l, LayerID.l )
  InPOS.l = 0
  Repeat
    InPOS = InPOS + 1
   Until LayersParticle( LayerID, InPOS ) = Particle Or InPOS = 256
  If LayersParticle( LayerID, InPOS ) = Particle
    Repeat
      LayersParticle( LayerID, InPOS ) = LayersParticle( LayerID, InPOS + 1 )
      InPOS = InPOS + 1
     Until InPOS = 256 Or LayersParticle( LayerID, InPOS ) = 0
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
;
;**************************************************************************************************************
;
Procedure P2DK_DisplayLayerPARTICLEs( LayerID.l, XS.l, YS.l, XE.l, YE.l, XDisplay.l, YDisplay.l )
  ; Lecture des dimensions de l'écran pour le calcul de la zone de tracé.
  DisplayWIDTH.l = XE - XS : DisplayHEIGHT.l = YE - YS
  ; Calcul des 4 extrémités pour l'affichage des lumières.
  InPOS.l = 0
  Repeat
    InPOS = InPOS + 1
    If LayersParticle( LayerID, InPOS ) > 0
      DisplayParticle.l = LayersParticle( LayerID, InPOS )
      ; On n'affiche le BOB que si il est à la fois actif et non caché.
      If ParticleSystem( DisplayParticle )\Exist = 1
        If ParticleSystem( DisplayParticle )\XMax > XDisplay And ParticleSystem( DisplayParticle )\XMin < XDisplay + DisplayWIDTH
          If ParticleSystem( DisplayParticle )\YMax > YDisplay And ParticleSystem( DisplayParticle )\YMin < YDisplay + DisplayHEIGHT
            XSHIFT.l = XS - XDisplay : YSHIFT.l = YS - YDisplay
            P2DK_UpdateParticlesID( DisplayParticle, XSHIFT, YSHIFT )
           EndIf         
         EndIf
       EndIf
     EndIf
   Until InPOS = 65 Or LayersParticle( LayerID, InPOS ) = 0
 EndProcedure
;
;**************************************************************************************************************
;
;
;**************************************************************************************************************
;
;
;**************************************************************************************************************
;
;
;**************************************************************************************************************
;
;
;**************************************************************************************************************
;
;
;**************************************************************************************************************
;
;
;**************************************************************************************************************
;
;
;**************************************************************************************************************
;

; IDE Options = PureBasic 4.10 Beta 2 (Windows - x86)
; CursorPosition = 72
; FirstLine = 70
; Folding = --