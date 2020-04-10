;
; ************************************************
; *                                              *
; * 2DPlugKIT Include File : 2D Particles System *
; *                                              *
; ************************************************
;
;**************************************************************************************************************
;
Procedure.l P2DKInt_CreateMemoryImage( Source.l, Leng.l )
  ; Si aucune image n'est utilisée pour la flamme, on utilise celle contenue dans la DLL.
  Img.l = 0
  Memb.l = MBC_DynamicMake( Leng )
  If Memb > 0
    MembPtr.l = DBGetMemblockPtr( Memb )
    If MembPtr <> 0
      CopyMemoryM( Source, MembPtr, Leng, 0, 0, 1) 
      Img = IMG_MakeImageFromMemblock( Memb )
     EndIf
    Memb = MBC_Delete( Memb )
   EndIf
  ProcedureReturn Img
 EndProcedure
;
;**************************************************************************************************************
;
Procedure P2DK_SetParticleImage( ParticleID, ImageID )
  ; Mode SPRITES DarkBASIC Professional par défaut.
  If Setup\UseM2E <> 1
    If DBGetImageExist( ImageID ) = 1
      ; On crée ou mets à jour le sprite avec la nouvelle image.
      If ParticleSystem( ParticleID )\DBPSprite = 0
        ParticleSystem( ParticleID )\DBPSprite = SPR_DynamicSprite( -512, -512, ImageID )
       Else
        DBSprite( ParticleSystem( ParticleID )\DBPSprite, -512, -512, ImageID )
       EndIf
      DBSizeSprite( ParticleSystem( ParticleID )\DBPSprite, ParticleSystem( ParticleID )\Size , ParticleSystem( ParticleID )\Size )
      DBSetSprite( ParticleSystem( ParticleID )\DBPSprite, 0, 1 )
      ; On supprime l'ancienne image si elle a été crée par le plugin.
      If ParticleSystem( ParticleID )\UseInternal = 1
        ParticleSystem( ParticleID )\LoadedImage = IMG_Delete( ParticleSystem( ParticleID )\LoadedImage )
       EndIf
      ; On mets à jour les données du sprite avec les informations de la nouvelle image.
      ParticleSystem( ParticleID )\LoadedImage = ImageID
      ParticleSystem( ParticleID )\UseInternal = 0
     EndIf
   Else
  ; Mode SPRITES M2E optionnel
    If DBGetImageExist( ImageID ) = 1
      ; On supprime l'ancien sprite.
      If ParticleSystem( ParticleID )\M2ESprite <> 0
        DXS_DeleteSprite( ParticleSystem( ParticleID )\M2ESprite )
        ParticleSystem( ParticleID )\M2ESprite = 0
       EndIf
      ; On crée le nouveau avec la nouvelle image.
      ParticleSystem( ParticleID )\M2ESprite = DXS_CreateSpriteFromImage( ImageID )
      Scale.f = 100.0 * ( ParticleSystem( ParticleID )\Size / DBGetImageWidth( ImageID ) )
      DXS_SetSpriteScale( ParticleSystem( ParticleID )\M2ESprite, Scale, Scale )
      DXS_UpdateSprite( ParticleSystem( ParticleID )\M2ESprite )
      ; On supprime l'ancienne image si elle a été crée par le plugin.
      If ParticleSystem( ParticleID )\UseInternal = 1
        ParticleSystem( ParticleID )\LoadedImage = IMG_Delete( ParticleSystem( ParticleID )\LoadedImage )
       EndIf
      ; On mets à jour les données du sprite avec les informations de la nouvelle image.
      ParticleSystem( ParticleID )\LoadedImage = ImageID
      ParticleSystem( ParticleID )\UseInternal = 0
     EndIf
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_AddParticles( ParticleCount.l , ParticleImage.l , ParticleSiz.f )
  ParticleSize.f = PeekF( @ParticleSiz ) : ParticleID.l = 0
  ParticleID = DLH_GetNextFreeItem( 3 )
  If ParticleID > 0 And ParticleID < 256 And ParticleCount > 8 And ParticleSize > 0.0 And PlugINITIALIZED = 1
    ; Si le groupement de particules n'existe pas, on le crée
    If ParticleSystem( ParticleID )\Exist = 0
      ParticleSystem( ParticleID )\Exist = 1
      ParticleSystem( ParticleID )\Type = 0
      ParticleSystem( ParticleID )\Count = ParticleCount
      ParticleSystem( ParticleID )\Size = Int( ParticleSize )
      If ParticleImage > 0
        If DBGetImageExist( ParticleImage ) <> 0
          ParticleSystem( ParticleID )\LoadedImage = ParticleImage
          P2DK_SetParticleImage( ParticleID, ParticleImage )
         Else
          ParticleSystem( ParticleID )\LoadedImage = 0
          ParticleImage = 0
         EndIf
       Else
        ParticleSystem( ParticleID )\LoadedImage = 0
        ParticleImage = 0
       EndIf
      For XLoop = 1 To ParticleCount
        ParticleObject( ParticleID , XLoop )\XPos = 0
        ParticleObject( ParticleID , XLoop )\YPos = 0
       Next XLoop
     EndIf
   EndIf
  ProcedureReturn ParticleID
 EndProcedure 
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_PositionParticles( ParticleID.l , XPos.l , YPos.l )
  If ParticleID > 0 And ParticleID < 256 And PlugINITIALIZED = 1
    If ParticleSystem( ParticleID )\Exist = 1
      ParticleSystem( ParticleID )\XEmitter = XPos
      ParticleSystem( ParticleID )\YEmitter = YPos
      If ParticleSystem( ParticleID )\XSize > 0 And ParticleSystem( ParticleID )\YSize > 0
        XSize.l = ParticleSystem( ParticleID )\XSize
        YSize.l = ParticleSystem( ParticleID )\YSize
        ParticleSystem( ParticleID )\XMin = ParticleSystem( ParticleID )\XEmitter - ( Xsize / 2 )
        ParticleSystem( ParticleID )\XMax = ParticleSystem( ParticleID )\XEmitter + ( Xsize / 2 )
        ParticleSystem( ParticleID )\YMin = ParticleSystem( ParticleID )\YEmitter - ( Ysize / 2 )
        ParticleSystem( ParticleID )\YMax = ParticleSystem( ParticleID )\YEmitter + ( Ysize / 2 )
       EndIf
     EndIf
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetEmitterRange( ParticleID.l, XSize.l, YSize.l )
  If ParticleID > 0 And ParticleID < 256 And PlugINITIALIZED = 1 
    If ParticleSystem( ParticleID )\Exist = 1
      ParticleSystem( ParticleID )\XSize = XSize
      ParticleSystem( ParticleID )\YSize = YSize
      ParticleSystem( ParticleID )\XMin = ParticleSystem( ParticleID )\XEmitter - ( Xsize / 2 )
      ParticleSystem( ParticleID )\XMax = ParticleSystem( ParticleID )\XEmitter + ( Xsize / 2 )
      ParticleSystem( ParticleID )\YMin = ParticleSystem( ParticleID )\YEmitter - ( Ysize / 2 )
      ParticleSystem( ParticleID )\YMax = ParticleSystem( ParticleID )\YEmitter + ( Ysize / 2 )
     EndIf
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetParticlePath( ParticleID.l , XMove.l , YMove.l  )
  If ParticleID > 0 And ParticleID < 256 And PlugINITIALIZED = 1
    If ParticleSystem( ParticleID )\Exist = 1
      Move1.f = PeekF( @XMove ) : ParticleSystem( ParticleID )\XMove = Move1
      Move1.f = PeekF( @YMove ) : ParticleSystem( ParticleID )\YMove = Move1
     EndIf
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetAsFlames( ParticleID.l )
  If ParticleID > 0 And ParticleID < 256 And PlugINITIALIZED = 1 
    If ParticleSystem( ParticleID )\Exist = 1
      ParticleSystem( ParticleID )\Type = 1
      ; We update the sprite with the created image and force it to be set as internal image for auto deletion.
      ImageID.l = P2DKInt_CreateMemoryImage( ?FLAMEPARTICLES, 16396 )
      P2DK_SetParticleImage( ParticleID, ImageID )
      ParticleSystem( ParticleID )\UseInternal = 1
      For XLoop = 1 To ParticleSystem( ParticleID )\Count
        FLAMESTEP.f = 200.0 / ParticleSystem( ParticleID )\Count
        ; We position the flames for default settings.
        ParticleObject( ParticleID , XLoop )\Duration = FLAMESTEP * XLoop
        XRand.l = Random( ParticleSystem( ParticleID )\XSize - ParticleSystem( ParticleID )\Size )
        ParticleObject( ParticleID , XLoop )\Xpos = ParticleSystem( ParticleID )\XMax - XRand - ( ParticleSystem( ParticleID )\Size / 2 )
        ParticleObject( ParticleID , XLoop )\Ypos = ParticleObject( ParticleID , XLoop )\Duration * 0.1
       Next XLoop        
      ParticleSystem( ParticleID )\XMove = 0.0
      ParticleSystem( ParticleID )\YMove = -0.25
      ParticleSystem( ParticleID )\Duration = ParticleSystem( ParticleID )\YSize
     EndIf
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetAsSmoke( ParticleID.l )
  If ParticleID > 0 And ParticleID < 256 And PlugINITIALIZED = 1 
    If ParticleSystem( ParticleID )\Exist = 1
      ParticleSystem( ParticleID )\Type = 2
      ImageID.l = P2DKInt_CreateMemoryImage( ?FLAMEPARTICLES, 16396 )
      P2DK_SetParticleImage( ParticleID, ImageID )
      ParticleSystem( ParticleID )\UseInternal = 1
      For XLoop = 1 To ParticleSystem( ParticleID )\Count
        SMOKESTEP.f = 200.0 / ParticleSystem( ParticleID )\Count
        ParticleObject( ParticleID , XLoop )\Duration = SMOKESTEP * XLoop
        XRand.l = Random( ParticleSystem( ParticleID )\XSize - ParticleSystem( ParticleID )\Size )
        ParticleObject( ParticleID , XLoop )\Xpos = ParticleSystem( ParticleID )\XMax - XRand - ( ParticleSystem( ParticleID )\Size / 2 )
        ParticleObject( ParticleID , XLoop )\Ypos = ParticleObject( ParticleID , XLoop )\Duration * 0.1
       Next XLoop
      ParticleSystem( ParticleID )\XMove = 0.0
      ParticleSystem( ParticleID )\YMove = -0.025
      ParticleSystem( ParticleID )\Duration = ParticleSystem( ParticleID )\YSize
     EndIf
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetAsSnow( ParticleID.l )
  If ParticleID > 0 And ParticleID < 256 And PlugINITIALIZED = 1 
    If ParticleSystem( ParticleID )\Exist = 1
      ParticleSystem( ParticleID )\Type = 4
      ImageID.l = P2DKInt_CreateMemoryImage( ?SNOWPARTICLES, 4108 )
      P2DK_SetParticleImage( ParticleID, ImageID )
      ParticleSystem( ParticleID )\UseInternal = 1
      For XLoop = 1 To ParticleSystem( ParticleID )\Count
        XRand.l = Random( ParticleSystem( ParticleID )\XSize - ParticleSystem( ParticleID )\Size )
        YRand.l = Random( ParticleSystem( ParticleID )\YSize - ParticleSystem( ParticleID )\Size )
        ParticleObject( ParticleID , XLoop )\XPos = ParticleSystem( ParticleID )\XMin + XRand
        ParticleObject( ParticleID , XLoop )\YPos = ParticleSystem( ParticleID )\YMin + YRand
       Next XLoop
      ParticleSystem( ParticleID )\XMove = 0.0
      ParticleSystem( ParticleID )\YMove = -0.0625
      ParticleSystem( ParticleID )\Duration = 0.0
     EndIf
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetAsRain( ParticleID.l )
  If ParticleID > 0 And ParticleID < 256 And PlugINITIALIZED = 1 
    If ParticleSystem( ParticleID )\Exist = 1
      ParticleSystem( ParticleID )\Type = 3
      ImageID.l = P2DKInt_CreateMemoryImage( ?RAINPARTICLES, 16396 )
      P2DK_SetParticleImage( ParticleID, ImageID )
      ParticleSystem( ParticleID )\UseInternal = 1
      For XLoop = 1 To ParticleSystem( ParticleID )\Count
        XRand.l = Random( ParticleSystem( ParticleID )\XSize - ParticleSystem( ParticleID )\Size )
        YRand.l = Random( ParticleSystem( ParticleID )\YSize - ParticleSystem( ParticleID )\Size )
        ParticleObject( ParticleID , XLoop )\XPos = ParticleSystem( ParticleID )\XMin + XRand
        ParticleObject( ParticleID , XLoop )\YPos = ParticleSystem( ParticleID )\YMin + YRand
       Next XLoop
      ParticleSystem( ParticleID )\XMove = 0.0
      ParticleSystem( ParticleID )\YMove = -0.5
      ParticleSystem( ParticleID )\Duration = 0.0
     EndIf
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetAsSparkle( ParticleID.l )
  If ParticleID > 0 And ParticleID < 256 And PlugINITIALIZED = 1 
    If ParticleSystem( ParticleID )\Exist = 1
      ParticleSystem( ParticleID )\Type = 5
      ImageID.l = P2DKInt_CreateMemoryImage( ?SPARKLEPARTICLES, 16396 )
      P2DK_SetParticleImage( ParticleID, ImageID )
      ParticleSystem( ParticleID )\UseInternal = 1
      For XLoop = 1 To ParticleSystem( ParticleID )\Count
        XRand.l = Random( ParticleSystem( ParticleID )\XSize - ParticleSystem( ParticleID )\Size )
        YRand.l = Random( ParticleSystem( ParticleID )\YSize - ParticleSystem( ParticleID )\Size )
        ParticleObject( ParticleID , XLoop )\XPos = ParticleSystem( ParticleID )\XMin + XRand
        ParticleObject( ParticleID , XLoop )\YPos = ParticleSystem( ParticleID )\YMin + YRand
        ParticleObject( ParticleID , XLoop )\Duration = Random( 200.0 ) + 50.0
       Next XLoop
      ParticleSystem( ParticleID )\XMove = 0.0
      ParticleSystem( ParticleID )\YMove = 0.0
      ParticleSystem( ParticleID )\Duration = 250.0
     EndIf
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
Procedure P2DK_UpdateFlames( ParticleID.l, XADD.l, YADD.l )
  If ParticleID > 0 And ParticleID < 256 And PlugINITIALIZED = 1 
    If ParticleSystem( ParticleID )\Exist = 1
      If Setup\UseM2E = 1 : DXS_BeginSpriteRender( ParticleSystem( ParticleID )\M2ESprite ) : EndIf 
      For XLoop = 1 To ParticleSystem( ParticleID )\Count
        If ParticleObject( ParticleID , XLoop )\Duration > 0
          ParticleObject( ParticleID , XLoop )\Duration = ParticleObject( ParticleID , XLoop )\Duration - ( 0.5 * TimeFactor )
          If ParticleObject( ParticleID , XLoop )\Duration < 0 : ParticleObject( ParticleID , XLoop )\Duration = 0 : EndIf
          Red.f = 255.0
          Green.f = ParticleObject( ParticleID , XLoop )\Duration * 1.28
          Blue.f = ParticleObject( ParticleID , XLoop )\Duration * 0.64
          If ParticleObject( ParticleID , XLoop )\Duration < 200
            Mult.f = 2 * ( ParticleObject( ParticleID , XLoop )\Duration / ParticleSystem( ParticleID )\YSize )
            If Mult < 0.0 : Mult = 0 : EndIf
            Red = Red * Mult : If Red > 255.0 : Red = 255.0 : EndIf
            Green = Green * Mult : If Green > 255.0 : Green = 255.0 : EndIf
            Blue = Blue * Mult : If Blue > 255.0 : Blue = 255.0 : EndIf
            Alfa.l = ( Red + Green + Blue ) / 3
;            Alfa = 255
            Select Setup\UseM2E
              Case 0
                DBSetSpriteDiffuse( ParticleSystem( ParticleID )\DBPSprite, Red, Green, Blue )
                DBSetSpriteAlpha( ParticleSystem( ParticleID )\DBPSprite, Alfa )
              Case 1
                DXS_SetSpriteDiffuse( ParticleSystem( ParticleID )\M2ESprite, Red, Green, Blue )
                DXS_SetSpriteAlpha( ParticleSystem( ParticleID )\M2ESprite, Alfa )
              Case 2
                DBSetSpriteDiffuse( ParticleSystem( ParticleID )\DBPSprite, Red, Green, Blue )
                DBSetSpriteAlpha( ParticleSystem( ParticleID )\DBPSprite, Alfa )
             EndSelect
           Else
            Mult.f = Abs( 200 - ParticleObject( ParticleID , Xloop )\Duration )
            If Mult < 0.0 : Mult = 0 : EndIf
            If Mult > 1.0 : Mult = 1.0 : EndIf
            Select Setup\UseM2E
              Case 0
                DBSetSpriteDiffuse( ParticleSystem( ParticleID )\DBPSprite , 255 * Mult , 255 * Mult , 255 * Mult )
              Case 1
                DXS_SetSpriteDiffuse( ParticleSystem( ParticleID )\M2ESprite , 255 * Mult, 255 * Mult, 255 * Mult )
              Case 2
                DBSetSpriteDiffuse( ParticleSystem( ParticleID )\DBPSprite , 255 * Mult , 255 * Mult , 255 * Mult )
             EndSelect
           EndIf
          ParticleObject( ParticleID , XLoop )\Xpos = ParticleObject( ParticleID , XLoop )\Xpos + XWind + ( ParticleSystem( ParticleID )\XMove * TimeFactor )
          ParticleObject( ParticleID , XLoop )\YPos = ParticleObject( ParticleID , XLoop )\YPos + ( ParticleSystem( ParticleID )\YMove * TimeFactor )
;          If ParticleObject( ParticleID , XLoop )\Duration > 0
          Select Setup\UseM2E
            Case 0
              DBPasteSprite( ParticleSystem( ParticleID )\DBPSprite , ParticleObject( ParticleID , XLoop )\Xpos + XADD , ParticleObject( ParticleID , XLoop )\Ypos + YADD )
            Case 1
              DXS_DrawSpriteA( ParticleSystem( ParticleID )\M2ESprite , ParticleObject( ParticleID , XLoop )\Xpos + XADD , ParticleObject( ParticleID , XLoop )\Ypos + YADD )
            Case 2
              DBPasteSprite( ParticleSystem( ParticleID )\DBPSprite , ParticleObject( ParticleID , XLoop )\Xpos + XADD , ParticleObject( ParticleID , XLoop )\Ypos + YADD )
           EndSelect
;           EndIf
         Else
          ParticleObject( ParticleID , XLoop )\Duration = ParticleSystem( ParticleID )\Duration
          XRand.l = Random( ParticleSystem( ParticleID )\XSize - ParticleSystem( ParticleID )\Size )
          ParticleObject( ParticleID , XLoop )\Xpos = ParticleSystem( ParticleID )\XMax - XRand - ( ParticleSystem( ParticleID )\Size / 2 )
          ParticleObject( ParticleID , XLoop )\Ypos = ParticleSystem( ParticleID )\YMax - 8
         EndIf
       Next XLoop 
      If Setup\UseM2E = 1 : DXS_EndSpriteRender( ParticleSystem( ParticleID )\M2ESprite ) : EndIf 
     EndIf
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
Procedure P2DK_UpdateSmoke( ParticleID.l, XADD.l, YADD.l )
  If ParticleID > 0 And ParticleID < 256 And PlugINITIALIZED = 1 
    If ParticleSystem( ParticleID )\Exist = 1
      If Setup\UseM2E = 1 : DXS_BeginSpriteRender( ParticleSystem( ParticleID )\M2ESprite ) : EndIf 
      For XLoop = 1 To ParticleSystem( ParticleID )\Count
        If ParticleObject( ParticleID , XLoop )\Duration > 0
          ParticleObject( ParticleID , XLoop )\Duration = ParticleObject( ParticleID , XLoop )\Duration - ( 0.05 * TimeFactor )
          If ParticleObject( ParticleID , XLoop )\Duration < 0 : ParticleObject( ParticleID , Xloop )\Duration = 0 : EndIf
          If ParticleObject( ParticleID , XLoop )\Duration < 200
            Select Setup\UseM2E
              Case 0
                DBSetSpriteAlpha( ParticleSystem( ParticleID )\DBPSprite, Int( ParticleObject( ParticleID , XLoop )\Duration ) / 4 )
              Case 1
                DXS_SetSpriteAlpha( ParticleSystem( ParticleID )\M2ESprite, Int( ParticleObject( ParticleID , XLoop )\Duration ) / 4 )
              Case 2
                DBSetSpriteAlpha( ParticleSystem( ParticleID )\DBPSprite, Int( ParticleObject( ParticleID , XLoop )\Duration ) / 4 )
             EndSelect
           Else
            Value.l = Abs( 200 - ParticleObject( ParticleID , Xloop )\Duration )
            Value = ( 50 - Value ) ; * 2.0
            Select Setup\UseM2E
              Case 0
                DBSetSpriteAlpha( ParticleSystem( ParticleID )\DBPSprite, Value )
              Case 1
                DXS_SetSpriteAlpha( ParticleSystem( ParticleID )\M2ESprite, Value )
              Case 2
                DBSetSpriteAlpha( ParticleSystem( ParticleID )\DBPSprite, Value )
             EndSelect
           EndIf
          ParticleObject( ParticleID , XLoop )\YPos = ParticleObject( ParticleID , XLoop )\YPos + ( ParticleSystem( ParticleID )\YMove * TimeFactor )
          Select Setup\UseM2E
            Case 0
              DBPasteSprite( ParticleSystem( ParticleID )\DBPSprite , ParticleObject( ParticleID , XLoop )\Xpos + XADD , ParticleObject( ParticleID , XLoop )\Ypos + YADD )
            Case 1
              DXS_DrawSpriteA( ParticleSystem( ParticleID )\M2ESprite , ParticleObject( ParticleID , XLoop )\Xpos + XADD , ParticleObject( ParticleID , XLoop )\Ypos + YADD )
            Case 2
              DBPasteSprite( ParticleSystem( ParticleID )\DBPSprite , ParticleObject( ParticleID , XLoop )\Xpos + XADD , ParticleObject( ParticleID , XLoop )\Ypos + YADD )
           EndSelect
          If ParticleObject( ParticleID , XLoop )\Duration <= 0 
            ParticleObject( ParticleID , XLoop )\Duration = ParticleSystem( ParticleID )\Duration
            XRand.l = Random( ParticleSystem( ParticleID )\XSize - ParticleSystem( ParticleID )\Size )
            ParticleObject( ParticleID , XLoop )\Xpos = ParticleSystem( ParticleID )\XMax - XRand - ( ParticleSystem( ParticleID )\Size / 2 )
            ParticleObject( ParticleID , XLoop )\Ypos = ParticleSystem( ParticleID )\YMax - 8
           EndIf
         EndIf
       Next XLoop             
      If Setup\UseM2E = 1 : DXS_EndSpriteRender( ParticleSystem( ParticleID )\M2ESprite ) : EndIf 
     EndIf
   EndIf          
 EndProcedure
;
;**************************************************************************************************************
;
Procedure P2DK_UpdateSnow( ParticleID.l, XADD.l, YADD.l )
  If ParticleID > 0 And ParticleID < 256 And PlugINITIALIZED = 1 
    If ParticleSystem( ParticleID )\Exist = 1
      If Setup\UseM2E = 1 : DXS_BeginSpriteRender( ParticleSystem( ParticleID )\M2ESprite ) : EndIf 
      For XLoop = 1 To ParticleSystem( ParticleID )\Count
        XShift.f = TimeFactor * ( ( Random ( 10 ) - 5.0 ) / 100.0 )
        ParticleObject( ParticleID , XLoop )\Xpos = ParticleObject( ParticleID , XLoop )\Xpos + XShift
        ParticleObject( ParticleID , XLoop )\YPos = ParticleObject( ParticleID , XLoop )\YPos - ( ParticleSystem( ParticleID )\YMove * TimeFactor )
        If ParticleObject( ParticleID , XLoop )\Xpos < ParticleSystem( ParticleID )\XMin
          ParticleObject( ParticleID , Xloop )\Xpos = ParticleSystem( ParticleID )\XMax - 4
         Else
          If ParticleObject( ParticleId , Xloop )\Xpos > ParticleSystem( ParticleId )\XMax
            ParticleObject( ParticleId , Xloop )\Xpos = ParticleSystem( ParticleID )\Xmin + 4
           EndIf
         EndIf
        If ParticleObject( ParticleID , XLoop )\YPos > ParticleSystem( ParticleID )\YMax
          ParticleObject( ParticleID , XLoop )\YPos = ParticleSystem( ParticleID )\YMin
          XRand.l = Random( ParticleSystem( ParticleID )\XSize - ParticleSystem( ParticleID )\Size )
          ParticleObject( ParticleID , XLoop )\XPos = ParticleSystem( ParticleID )\XMin + Xrand
         Else
          If ParticleObject( ParticleID , XLoop )\YPos > ParticleSystem( ParticleID )\YMax
            ParticleObject( ParticleID , XLoop )\YPos = ParticleSystem( ParticleID )\YMax
            XRand.l = Random( ParticleSystem( ParticleID )\XSize - ParticleSystem( ParticleID )\Size )
            ParticleObject( ParticleID , XLoop )\XPos = ParticleSystem( ParticleID )\XMin + Xrand
           EndIf
         EndIf
        Select Setup\UseM2E
          Case 0
            DBPasteSprite( ParticleSystem( ParticleID )\DBPSprite , ParticleObject( ParticleID , XLoop )\Xpos + XADD , ParticleObject( ParticleID , XLoop )\Ypos + YADD )
          Case 1
            DXS_DrawSpriteA( ParticleSystem( ParticleID )\M2ESprite , ParticleObject( ParticleID , XLoop )\Xpos + XADD , ParticleObject( ParticleID , XLoop )\Ypos + YADD )
          Case 2
            DBPasteSprite( ParticleSystem( ParticleID )\DBPSprite , ParticleObject( ParticleID , XLoop )\Xpos + XADD , ParticleObject( ParticleID , XLoop )\Ypos + YADD )
         EndSelect
       Next XLoop
      If Setup\UseM2E = 1 : DXS_EndSpriteRender( ParticleSystem( ParticleID )\M2ESprite ) : EndIf 
     EndIf
   EndIf          
 EndProcedure
;
;**************************************************************************************************************
;
Procedure P2DK_UpdateRain( ParticleID.l, XADD.l, YADD.l )
  If ParticleID > 0 And ParticleID < 256 And PlugINITIALIZED = 1 
    If ParticleSystem( ParticleID )\Exist = 1
      If Setup\UseM2E = 1 : DXS_BeginSpriteRender( ParticleSystem( ParticleID )\M2ESprite ) : EndIf 
      For XLoop = 1 To ParticleSystem( ParticleID )\Count
        ParticleObject( ParticleID , XLoop )\YPos = ParticleObject( ParticleID , XLoop )\YPos - ( ParticleSystem( ParticleID )\YMove * TimeFactor )
        If ParticleObject( ParticleID , XLoop )\Xpos < ParticleSystem( ParticleID )\XMin
          ParticleObject( ParticleID , Xloop )\Xpos = ParticleSystem( ParticleID )\XMax - 4
         Else
          If ParticleObject( ParticleId , Xloop )\Xpos > ParticleSystem( ParticleId )\XMax
            ParticleObject( ParticleId , Xloop )\Xpos = ParticleSystem( ParticleID )\Xmin + 4
           EndIf
         EndIf
        If ParticleObject( ParticleID , XLoop )\YPos > ParticleSystem( ParticleID )\YMax
          ParticleObject( ParticleID , XLoop )\YPos = ParticleSystem( ParticleID )\YMin
          XRand.l = Random( ParticleSystem( ParticleID )\XSize - ParticleSystem( ParticleID )\Size )
          ParticleObject( ParticleID , XLoop )\XPos = ParticleSystem( ParticleID )\XMin + Xrand
         EndIf
          Select Setup\UseM2E
            Case 0
              DBPasteSprite( ParticleSystem( ParticleID )\DBPSprite , ParticleObject( ParticleID , XLoop )\Xpos + XADD , ParticleObject( ParticleID , XLoop )\Ypos + YADD )
            Case 1
              DXS_DrawSpriteA( ParticleSystem( ParticleID )\M2ESprite , ParticleObject( ParticleID , XLoop )\Xpos + XADD , ParticleObject( ParticleID , XLoop )\Ypos + YADD )
            Case 2
              DBPasteSprite( ParticleSystem( ParticleID )\DBPSprite , ParticleObject( ParticleID , XLoop )\Xpos + XADD , ParticleObject( ParticleID , XLoop )\Ypos + YADD )
           EndSelect
       Next XLoop
      If Setup\UseM2E = 1 : DXS_EndSpriteRender( ParticleSystem( ParticleID )\M2ESprite ) : EndIf 
     EndIf
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
Procedure P2DK_UpdateSparkles( ParticleID.l, XADD.l, YADD.l )
  If ParticleID > 0 And ParticleID < 256 And PlugINITIALIZED = 1 
    If ParticleSystem( ParticleID )\Exist = 1
      If Setup\UseM2E = 1 : DXS_BeginSpriteRender( ParticleSystem( ParticleID )\M2ESprite ) : EndIf 
      For XLoop = 1 To ParticleSystem( ParticleID )\Count
        ParticleObject( ParticleID, XLoop )\Duration = ParticleObject( ParticleID, XLoop )\Duration - TimeFactor
        If ParticleObject( ParticleID, XLoop )\Duration < 0
          ; On recrée la particule dans l'espace prévu pour.
          ParticleObject( ParticleID, XLoop )\Duration = ParticleSystem( ParticleID )\Duration
          XRand.l = Random( ParticleSystem( ParticleID )\XSize - ParticleSystem( ParticleID )\Size )
          YRand.l = Random( ParticleSystem( ParticleID )\YSize - ParticleSystem( ParticleID )\Size )
          ParticleObject( ParticleID , XLoop )\XPos = ParticleSystem( ParticleID )\XMin + XRand
          ParticleObject( ParticleID , XLoop )\YPos = ParticleSystem( ParticleID )\YMin + YRand
         Else
          ; On met à jour les Sparkles ...
          ParticlePhase.f = ( ParticleObject( ParticleID, XLoop )\Duration / ParticleSystem( ParticleID )\Duration ) * 100.0
          If ParticlePhase < 75.0
            ; Phase 2 - Descendante
            Percent.f = ( ParticlePhase * 4.0 ) / 3.0
           Else
            ; Phase 1 - Ascendante
            Percent.f = ( 25.0 - Abs( 75 - ParticlePhase ) ) * 4.0
           EndIf
          Select Setup\UseM2E
            Case 0
              DBSetSpriteAlpha( ParticleSystem( ParticleID )\DBPSprite, Percent * 2.5 )
              DBPasteSprite( ParticleSystem( ParticleID )\DBPSprite , ParticleObject( ParticleID , XLoop )\Xpos + XADD , ParticleObject( ParticleID , XLoop )\Ypos + YADD )
            Case 1
              DXS_SetSpriteAlpha( ParticleSystem( ParticleID )\M2ESprite, Percent * 2.5 )
              DXS_DrawSpriteA( ParticleSystem( ParticleID )\M2ESprite , ParticleObject( ParticleID , XLoop )\Xpos + XADD , ParticleObject( ParticleID , XLoop )\Ypos + YADD )
            Case 2
              DBSetSpriteAlpha( ParticleSystem( ParticleID )\DBPSprite, Percent * 2.5 )
              DBPasteSprite( ParticleSystem( ParticleID )\DBPSprite , ParticleObject( ParticleID , XLoop )\Xpos + XADD , ParticleObject( ParticleID , XLoop )\Ypos + YADD )
           EndSelect
         EndIf
       Next XLoop
      If Setup\UseM2E = 1 : DXS_EndSpriteRender( ParticleSystem( ParticleID )\M2ESprite ) : EndIf 
     EndIf
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_UpdateParticles()
  ActualTime = DBTimerL() : TimeChange.f = ActualTime - OldTime
  If TimeChange > 60 : TimeChange = 60 : EndIf
  TimeFactor = TimeChange / 2.0 : OldTime = ActualTime
  For ParticleID = 1 To 256 
    If ParticleSystem( ParticleID )\Exist = 1 And ParticleSystem( ParticleID )\Hide = 0 And ParticleSystem( ParticleID )\LayerID = 0 And PlugINITIALIZED = 1
      Select ParticleSystem( ParticleID )\Type
;        Case 0 : P2DK_UpdateDefault( ParticleID, 0, 0 )
        Case 1 : P2DK_UpdateFlames( ParticleID, 0, 0 )
        Case 2 : P2DK_UpdateSmoke( ParticleID, 0, 0 )
        Case 3 : P2DK_UpdateRain( ParticleID, 0, 0 )
        Case 4 : P2DK_UpdateSnow( ParticleID, 0, 0 )
        Case 5 : P2DK_UpdateSparkles( ParticleID, 0, 0 )
       EndSelect
     EndIf
   Next ParticleID
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_DetachParticleFromLayer( ParticleID.l )
  If IsParticleOk( ParticleID ) = 1 And PlugINITIALIZED = 1
    ; Si la lumière est déjà attachée à un layer, on la détache de ce layer.
    If ParticleSystem( ParticleID )\LayerID > 0
      P2DK_INTDetachParticleFromLayer( ParticleID, ParticleSystem( ParticleID )\LayerID )
     EndIf
    ParticleSystem( ParticleID )\LayerID = 0
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_AttachParticleToLayer( ParticleID.l, LayerID.l )
  If IsParticleOk( ParticleID ) = 1 And IsLayerOk( LayerID ) = 1 And PlugINITIALIZED = 1
    ; Si la lumière est déjà attachée à un layer, on la détache de ce layer.
    If ParticleSystem( ParticleID )\LayerID > 0
      P2DK_INTDetachParticleFromLayer( ParticleID, ParticleSystem( ParticleID )\LayerID )
     EndIf
    ; Puis, on attache ParticleLightToLayer( ParticleID, LayerID )
    P2DK_INTAttachParticleToLayer( ParticleID, LayerID )
    ParticleSystem( ParticleID )\LayerID = LayerID
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_UpdateParticlesID( ParticleID.l, XSHIFT.l, YSHIFT.L )
  ActualTime = DBTimerL() : TimeChange.f = ActualTime - OldTime
  If TimeChange > 60 : TimeChange = 60 : EndIf
  TimeFactor = TimeChange / 2.0 : ; OldTime = ActualTime
  If ParticleSystem( ParticleID )\Exist = 1 And ParticleSystem( ParticleID )\Hide = 0 And ParticleSystem( ParticleID )\LayerID > 0 And PlugINITIALIZED = 1
    Select ParticleSystem( ParticleID )\Type
;      Case 0 : P2DK_UpdateDefault( ParticleID, XSHIFT, YSHIFT )
      Case 1 : P2DK_UpdateFlames( ParticleID, XSHIFT, YSHIFT )
      Case 2 : P2DK_UpdateSmoke( ParticleID, XSHIFT, YSHIFT )
      Case 3 : P2DK_UpdateRain( ParticleID, XSHIFT, YSHIFT )
      Case 4 : P2DK_UpdateSnow( ParticleID, XSHIFT, YSHIFT )
      Case 5 : P2DK_UpdateSparkles( ParticleID, XSHIFT, YSHIFT )
     EndSelect
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
;
;**************************************************************************************************************
;

; IDE Options = PureBasic 4.10 Beta 2 (Windows - x86)
; CursorPosition = 492
; FirstLine = 458
; Folding = ----