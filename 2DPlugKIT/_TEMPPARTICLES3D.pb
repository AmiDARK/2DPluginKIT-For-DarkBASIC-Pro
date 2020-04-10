;
; ************************************************************************************
; *                                                                                  *
; *                                PARTICLES COMMANDS                                *
; *                                                                                  *
; ************************************************************************************
;
; **************************************************************
Declare P3D_UpdateDefault( ParticleID )
Declare P3D_UpdateFlames( ParticleID )
Declare P3D_UpdateSmoke( ParticleID )
Declare P3D_UpdateRain( ParticleID )
Declare P3D_UpdateSnow( ParticleID )
Declare P3D_UpdateSparkles( ParticleID.l )
; ***************************************************************************************
ProcedureCDLL P3D_HideParticle( ParticleID.l )
  If P3DInitialized = 1
    If ParticleSystem( ParticleID )\Hide = 0
      ParticleSystem( ParticleID )\Hide = 1
      For XLoop = 0 To ParticleSystem( ParticleID )\Count
        DBExcludeObjectOn( ParticleObject( ParticleID , XLoop )\Number )
       Next XLoop
     EndIf
   EndIf
 EndProcedure
; ***************************************************************************************
ProcedureCDLL P3D_ShowParticle( ParticleID.l )
  If P3DInitialized = 1
    If ParticleSystem( ParticleID )\Hide = 1
      ParticleSystem( ParticleID )\Hide = 0
      For XLoop = 0 To ParticleSystem( ParticleID )\Count
        DBExcludeObjectOff( ParticleObject( ParticleID , XLoop )\Number )
       Next XLoop
     EndIf
   EndIf
 EndProcedure
; ***************************************************************************************
ProcedureCDLL.l P3D_GetParticleExist( ParticleID.l )
  If P3DInitialized = 1
    Retour.l = ParticleSystem( ParticleID )\Exist
   Else
    Retour = 0
   EndIf
  ProcedureReturn Retour
 EndProcedure
; ***************************************************************************************
ProcedureCDLL.l P3D_DeleteParticle( ParticleID.l )
  If P3DInitialized = 1
    If ParticleSystem( ParticleID )\Exist = 1
      If ParticleSystem( ParticleID )\Hide = 1
        P3D_ShowParticle( ParticleID )
       EndIf
      ParticleSystem( ParticleID )\Exist = 0
      ParticleSystem( ParticleID )\Type = 0
      ParticleSystem( ParticleID )\Count = 0
      ParticleSystem( ParticleID )\Size = 0
      ; Update to handle internal graphics for custom presets.
      If ParticleSystem( ParticleID )\UseInternal = 1
        ParticleSystem( ParticleID )\LoadedImage = IMG_Delete( ParticleSystem( ParticleID )\LoadedImage )
       EndIf
      ParticleSystem( ParticleID )\UseInternal = 0
      ParticleID = DLH_FreeItem( ParticleID )
     Else
      ParticleID = 0
     EndIf
   Else
    ParticleID = 0
   EndIf
  ProcedureReturn ParticleID
 EndProcedure
; ***************************************************************************************
ProcedureCDLL P3D_Clear()
  If P3DInitialized = 1
    ; On supprime tout les objets qui ne l'auraient pas été...
    If DLH_GetItemCounter() > 0
      For XLoop = DLH_GetItemCounter() To 1 Step -1
        If P3D_GetParticleExist( XLoop ) = 1
         Null.l = P3D_DeleteParticle( XLoop )
         EndIf
       Next XLoop
      ObjectCount = 0
     EndIf
    ; On efface la pile des objets.
    DLH_ClearList()
   EndIf
 EndProcedure
; **************************************************************
; **************************************************************
; **************************************************************
; **************************************************************
ProcedureCDLL.l P3D_GetParticleXPath( ParticleID.l )
  PokeF( @Retour.l, ParticleSystem( ParticleId )\XMove )
  ProcedureReturn Retour
 EndProcedure
; **************************************************************
ProcedureCDLL.l P3D_GetParticleYPath( ParticleID.l )
  PokeF( @Retour.l, ParticleSystem( ParticleId )\YMove )
  ProcedureReturn Retour
 EndProcedure
; **************************************************************
ProcedureCDLL.l P3D_GetParticleZPath( ParticleID.l )
  PokeF( @Retour.l, ParticleSystem( ParticleId )\ZMove )
  ProcedureReturn Retour
 EndProcedure
; **************************************************************
ProcedureCDLL P3D_SetAsPrimitive( ParticleID.l )
  If P3DInitialized = 1
    If ParticleID > 0 And ParticleID < 256 
      If ParticleSystem( ParticleID )\Exist = 1
        ParticleSystem( ParticleID )\Type = 0
       EndIf
     EndIf
   EndIf
 EndProcedure
;
;
; **************************************************************
; **************************************************************
; **************************************************************
ProcedureCDLL P3D_SetAsRain( ParticleID.l )
  If P3DInitialized = 1
    If ParticleID > 0 And ParticleID < 256 
      If ParticleSystem( ParticleID )\Exist = 1
        ParticleSystem( ParticleID )\Type = 3
        ;
        P3DInt_CreateParticleImage( ParticleID, ?RAINPARTICLES, 16396 )
        ;
        For XLoop = 1 To ParticleSystem( ParticleID )\Count
          DBGhostObjectOn( ParticleObject( ParticleID , XLoop )\Number )
          DBDisableObjectZWrite( ParticleObject( ParticleID , XLoop )\Number )
          DBSetLight( ParticleObject( ParticleID , XLoop )\Number , 0 )
          DBSetObjectAmbient( ParticleObject( ParticleID , XLoop )\Number , 0 )
          B3D_DisableYRot( ParticleObject( ParticleID , XLoop )\Number )
          XRand.l = Random( ParticleSystem( ParticleID )\XSize - ParticleSystem( ParticleID )\Size )
          YRand.l = Random( ParticleSystem( ParticleID )\YSize - ParticleSystem( ParticleID )\Size )
          ZRand.l = Random( ParticleSystem( ParticleID )\ZSize - ParticleSystem( ParticleID )\Size )
          ParticleObject( ParticleID , XLoop )\XPos = ParticleSystem( ParticleID )\XMin + XRand
          ParticleObject( ParticleID , XLoop )\YPos = ParticleSystem( ParticleID )\YMin + YRand
          ParticleObject( ParticleID , XLoop )\ZPos = ParticleSystem( ParticleID )\ZMin + ZRand
         Next XLoop
        ParticleSystem( ParticleID )\XMove = 0.0
        ParticleSystem( ParticleID )\YMove = 0.5
        ParticleSystem( ParticleID )\ZMove = 0.0
        ParticleSystem( ParticleID )\Duration = 0.0
       EndIf
     EndIf
   EndIf
 EndProcedure
; **************************************************************
ProcedureCDLL P3D_SetAsSnow( ParticleID.l )
  If P3DInitialized = 1
    If ParticleID > 0 And ParticleID < 256 
      If ParticleSystem( ParticleID )\Exist = 1
        ParticleSystem( ParticleID )\Type = 4
        ;
        P3DInt_CreateParticleImage( ParticleID, ?SNOWPARTICLES, 4108 )
        ;
        For XLoop = 1 To ParticleSystem( ParticleID )\Count
          DBGhostObjectOn( ParticleObject( ParticleID , XLoop )\Number )
          DBDisableObjectZWrite( ParticleObject( ParticleID , XLoop )\Number )
          DBSetLight( ParticleObject( ParticleID , XLoop )\Number , 0 )
          DBSetObjectAmbient( ParticleObject( ParticleID , XLoop )\Number , 0 )
          B3D_EnableYRot( ParticleObject( ParticleID , XLoop )\Number )
          XRand.l = Random( ParticleSystem( ParticleID )\XSize - ParticleSystem( ParticleID )\Size )
          YRand.l = Random( ParticleSystem( ParticleID )\YSize - ParticleSystem( ParticleID )\Size )
          ZRand.l = Random( ParticleSystem( ParticleID )\ZSize - ParticleSystem( ParticleID )\Size )
          ParticleObject( ParticleID , XLoop )\XPos = ParticleSystem( ParticleID )\XMin + XRand
          ParticleObject( ParticleID , XLoop )\YPos = ParticleSystem( ParticleID )\YMin + YRand
          ParticleObject( ParticleID , XLoop )\ZPos = ParticleSystem( ParticleID )\ZMin + ZRand
         Next XLoop
        ParticleSystem( ParticleID )\XMove = 0.0
        ParticleSystem( ParticleID )\YMove = 0.0625
        ParticleSystem( ParticleID )\ZMove = 0.0
        ParticleSystem( ParticleID )\Duration = 0.0
       EndIf
     EndIf
   EndIf
 EndProcedure
; **************************************************************
ProcedureCDLL P3D_SetAsSparkle( ParticleID.l )
  If P3DInitialized = 1
    If ParticleID > 0 And ParticleID < 256 
      If ParticleSystem( ParticleID )\Exist = 1
        ParticleSystem( ParticleID )\Type = 5
        ;
        P3DInt_CreateParticleImage( ParticleID, ?SPARKLEPARTICLES, 262156 )
        ;
        For XLoop = 1 To ParticleSystem( ParticleID )\Count
          DBGhostObjectOn( ParticleObject( ParticleID , XLoop )\Number )
          DBSetAlphaFactor( ParticleObject( ParticleID , XLoop )\Number , 255 )
          DBSetTransparency( ParticleObject( ParticleID , XLoop )\Number , 0 )
          DBSetObjectAmbient( ParticleObject( ParticleID , XLoop )\Number , 1 )
          DBSetLight( ParticleObject( ParticleID , XLoop )\Number , 1 )
          DBSetFog( ParticleObject( ParticleID , XLoop )\Number , 1 )
          DBDisableObjectZWrite( ParticleObject( ParticleID , XLoop )\Number )
          B3D_EnableYRot( ParticleObject( ParticleID , XLoop )\Number )
          XRand.l = Random( ParticleSystem( ParticleID )\XSize - ParticleSystem( ParticleID )\Size )
          YRand.l = Random( ParticleSystem( ParticleID )\YSize - ParticleSystem( ParticleID )\Size )
          ZRand.l = Random( ParticleSystem( ParticleID )\ZSize - ParticleSystem( ParticleID )\Size )
          ParticleObject( ParticleID , XLoop )\XPos = ParticleSystem( ParticleID )\XMin + XRand
          ParticleObject( ParticleID , XLoop )\YPos = ParticleSystem( ParticleID )\YMin + YRand
          ParticleObject( ParticleID , XLoop )\ZPos = ParticleSystem( ParticleID )\ZMin + ZRand
          ParticleObject( ParticleID , XLoop )\Duration = Random( 200.0 ) + 50.0
         Next XLoop
        ParticleSystem( ParticleID )\XMove = 0.0
        ParticleSystem( ParticleID )\YMove = 0.0
        ParticleSystem( ParticleID )\ZMove = 0.0
        ParticleSystem( ParticleID )\Duration = 250.0
       EndIf
     EndIf
   EndIf
 EndProcedure
; **************************************************************
Procedure P3D_UpdateDefault( ParticleID.l )
  If P3DInitialized = 1
    If ParticleID > 0 And ParticleID < 256 
      If ParticleSystem( ParticleID )\Exist = 1
        For XLoop = 1 To ParticleSystem( ParticleID )\Count
          ; We move the particle component to its next position.
          ParticleObject( ParticleID , XLoop )\Xpos = ParticleObject( ParticleID , XLoop )\Xpos + ParticleSystem( ParticleID )\XMove
          ParticleObject( ParticleID , XLoop )\Ypos = ParticleObject( ParticleID , XLoop )\Ypos + ParticleSystem( ParticleID )\YMove
          ParticleObject( ParticleID , XLoop )\Zpos = ParticleObject( ParticleID , XLoop )\Zpos + ParticleSystem( ParticleID )\ZMove
          ; Checking for X limits
          If ParticleObject( ParticleID , XLoop )\Xpos < ParticleSystem( ParticleID )\XMin
            ParticleObject( ParticleID , XLoop )\Xpos = ParticleSystem( ParticleID )\XMax
           EndIf
          If ParticleObject( ParticleID , XLoop )\Xpos > ParticleSystem( ParticleID )\XMax
            ParticleObject( ParticleID , XLoop )\Xpos = ParticleSystem( ParticleID )\XMin
           EndIf
          ; Checking for Y limits
          If ParticleObject( ParticleID , XLoop )\Ypos < ParticleSystem( ParticleID )\YMin
            ParticleObject( ParticleID , XLoop )\Ypos = ParticleSystem( ParticleID )\YMax
           EndIf
          If ParticleObject( ParticleID , XLoop )\Ypos > ParticleSystem( ParticleID )\YMax
            ParticleObject( ParticleID , XLoop )\Ypos = ParticleSystem( ParticleID )\YMin
           EndIf
          ; Checking for Z limits
          If ParticleObject( ParticleID , XLoop )\Zpos < ParticleSystem( ParticleID )\ZMin
            ParticleObject( ParticleID , XLoop )\Zpos = ParticleSystem( ParticleID )\ZMax
           EndIf
          If ParticleObject( ParticleID , XLoop )\Zpos > ParticleSystem( ParticleID )\ZMax
            ParticleObject( ParticleID , XLoop )\Zpos = ParticleSystem( ParticleID )\ZMin
           EndIf
          ; We finalize the object position changes.
          DBPositionObject( ParticleObject( ParticleID , XLoop )\Number , ParticleObject( ParticleID , XLoop )\Xpos , ParticleObject( ParticleID , XLoop )\Ypos , ParticleObject( ParticleID , XLoop )\Zpos )
         Next XLoop
       EndIf
     EndIf
   EndIf
 EndProcedure
; **************************************************************
Procedure P3D_UpdateSmoke( ParticleID.l )
  If P3DInitialized = 1
    If ParticleID > 0 And ParticleID < 256 
      If ParticleSystem( ParticleID )\Exist = 1
        For XLoop = 1 To ParticleSystem( ParticleID )\Count
          If ParticleObject( ParticleID , XLoop )\Number > 0
            If ParticleObject( ParticleID , XLoop )\Duration > 0
              ParticleObject( ParticleID , XLoop )\Duration = ParticleObject( ParticleID , XLoop )\Duration - ( 0.05 * TimeFactor )
              If ParticleObject( ParticleID , XLoop )\Duration < 0 : ParticleObject( ParticleID , Xloop )\Duration = 0 : EndIf
              If ParticleObject( ParticleID , XLoop )\Duration < 200
                DBFadeObject( ParticleObject( ParticleID , XLoop )\Number , Int( ParticleObject( ParticleID , XLoop )\Duration ) )
               Else
                Value.l = Abs( 200 - ParticleObject( ParticleID , Xloop )\Duration ) : Value = ( 50 - Value ) * 2.0
                DBFadeObject( ParticleObject( ParticleID , XLoop )\Number , Value )
               EndIf
              ParticleObject( ParticleID , XLoop )\YPos = ParticleObject( ParticleID , XLoop )\YPos + ( ParticleSystem( ParticleID )\YMove * TimeFactor )
              DBPositionObject( ParticleObject( ParticleID , XLoop )\Number , ParticleObject( ParticleID , XLoop )\Xpos , ParticleObject( ParticleID , XLoop )\Ypos , ParticleObject( ParticleID , XLoop )\Zpos )
              If ParticleObject( ParticleID , XLoop )\Duration <= 0 
                DBHideObject( ParticleObject( ParticleID , XLoop )\Number )
                If NextSmoke = 0 : NextSmoke = XLoop : EndIf
               EndIf
             Else
              If NextSmoke = 0 : NextSmoke = XLoop : EndIf
             EndIf
           EndIf
         Next XLoop             
        If NextSmoke > 0
          ParticleObject( ParticleID , NextSmoke )\Duration = ParticleSystem( ParticleID )\Duration
          XRand.l = Random( ParticleSystem( ParticleID )\XSize - ParticleSystem( ParticleID )\Size )
          ZRand.l = Random( ParticleSystem( ParticleID )\ZSize - ParticleSystem( ParticleID )\Size )
          ParticleObject( ParticleID , NextSmoke )\Xpos = ParticleSystem( ParticleID )\XMin + XRand + ( ParticleSystem( ParticleID )\Size / 2 )
          ParticleObject( ParticleID , NextSmoke )\Ypos = ParticleSystem( ParticleID )\YMin - 8
          ParticleObject( ParticleID , NextSmoke )\Zpos = ParticleSystem( ParticleID )\ZMin + ZRand + ( ParticleSystem( ParticleID )\Size / 2 )
          DBPositionObject( ParticleObject( ParticleID , NextSmoke )\Number , ParticleObject( ParticleID , NextSmoke )\Xpos , ParticleObject( ParticleID , NextSmoke )\Ypos , ParticleObject( ParticleID , NextSmoke )\Zpos )
          DBShowObject( ParticleObject( ParticleID , NextSmoke )\Number )
          NextSmoke = 0
         EndIf
       EndIf
     EndIf
   EndIf          
 EndProcedure
; **************************************************************
Procedure P3D_UpdateSnow( ParticleID.l )
  If P3DInitialized = 1
    If ParticleID > 0 And ParticleID < 256 
      If ParticleSystem( ParticleID )\Exist = 1
        For XLoop = 1 To ParticleSystem( ParticleID )\Count
          If ParticleObject( ParticleID , XLoop )\Number > 0
            XShift.f = TimeFactor * ( ( Random ( 10 ) - 5.0 ) / 100.0 )
            ZShift.f = TimeFactor * ( ( Random ( 10 ) - 5.0 ) / 100.0 )
            ParticleObject( ParticleID , XLoop )\Xpos = ParticleObject( ParticleID , XLoop )\Xpos + XShift
            ParticleObject( ParticleID , XLoop )\Zpos = ParticleObject( ParticleID , XLoop )\Zpos + ZShift 
            ParticleObject( ParticleID , XLoop )\YPos = ParticleObject( ParticleID , XLoop )\YPos - ( ParticleSystem( ParticleID )\YMove * TimeFactor )
            If ParticleObject( ParticleID , XLoop )\Xpos < ParticleSystem( ParticleID )\XMin
              ParticleObject( ParticleID , Xloop )\Xpos = ParticleSystem( ParticleID )\XMax - 4
             Else
              If ParticleObject( ParticleId , Xloop )\Xpos > ParticleSystem( ParticleId )\XMax
                ParticleObject( ParticleId , Xloop )\Xpos = ParticleSystem( ParticleID )\Xmin + 4
               EndIf
             EndIf
            If ParticleObject( ParticleID , XLoop )\YPos < ParticleSystem( ParticleID )\YMin
              ParticleObject( ParticleID , XLoop )\YPos = ParticleSystem( ParticleID )\YMax
              XRand.l = Random( ParticleSystem( ParticleID )\XSize - ParticleSystem( ParticleID )\Size )
              ZRand.l = Random( ParticleSystem( ParticleID )\ZSize - ParticleSystem( ParticleID )\Size )
              ParticleObject( ParticleID , XLoop )\XPos = ParticleSystem( ParticleID )\XMin + Xrand
              ParticleObject( ParticleID , XLoop )\ZPos = ParticleSystem( ParticleID )\ZMin + Zrand
             Else
              If ParticleObject( ParticleID , XLoop )\YPos > ParticleSystem( ParticleID )\YMax
                ParticleObject( ParticleID , XLoop )\YPos = ParticleSystem( ParticleID )\YMax
                XRand.l = Random( ParticleSystem( ParticleID )\XSize - ParticleSystem( ParticleID )\Size )
                ZRand.l = Random( ParticleSystem( ParticleID )\ZSize - ParticleSystem( ParticleID )\Size )
                ParticleObject( ParticleID , XLoop )\XPos = ParticleSystem( ParticleID )\XMin + Xrand
                ParticleObject( ParticleID , XLoop )\ZPos = ParticleSystem( ParticleID )\ZMin + Zrand
               EndIf
             EndIf
            If ParticleObject( ParticleID , XLoop )\Zpos < ParticleSystem( ParticleID )\ZMin
              ParticleObject( ParticleID , Xloop )\Zpos = ParticleSystem( ParticleID )\ZMax - 4
             Else
              If ParticleObject( ParticleId , Xloop )\Zpos > ParticleSystem( ParticleId )\ZMax
                ParticleObject( ParticleId , Xloop )\Zpos = ParticleSystem( ParticleID )\Zmin + 4
               EndIf
             EndIf
            DBPositionObject( ParticleObject( ParticleID , Xloop )\Number , ParticleObject( ParticleID , Xloop )\Xpos , ParticleObject( ParticleID , Xloop )\Ypos , ParticleObject( ParticleID , Xloop )\Zpos )
           EndIf
         Next XLoop
       EndIf
     EndIf
   EndIf          
 EndProcedure
; **************************************************************
Procedure P3D_UpdateRain( ParticleID.l )
  If P3DInitialized = 1
    If ParticleID > 0 And ParticleID < 256 
      If ParticleSystem( ParticleID )\Exist = 1
        For XLoop = 1 To ParticleSystem( ParticleID )\Count
          If ParticleObject( ParticleID , XLoop )\Number > 0
;            XShift.f = TimeFactor * ( ( Random ( 10 ) - 5.0 ) / 100.0 )
;            ZShift.f = TimeFactor * ( ( Random ( 10 ) - 5.0 ) / 100.0 )
;            ParticleObject( ParticleID , XLoop )\Xpos = ParticleObject( ParticleID , XLoop )\Xpos + XShift
;            ParticleObject( ParticleID , XLoop )\Zpos = ParticleObject( ParticleID , XLoop )\Zpos + ZShift 
            ParticleObject( ParticleID , XLoop )\YPos = ParticleObject( ParticleID , XLoop )\YPos - ( ParticleSystem( ParticleID )\YMove * TimeFactor )
            If ParticleObject( ParticleID , XLoop )\Xpos < ParticleSystem( ParticleID )\XMin
              ParticleObject( ParticleID , Xloop )\Xpos = ParticleSystem( ParticleID )\XMax - 4
             Else
              If ParticleObject( ParticleId , Xloop )\Xpos > ParticleSystem( ParticleId )\XMax
                ParticleObject( ParticleId , Xloop )\Xpos = ParticleSystem( ParticleID )\Xmin + 4
               EndIf
             EndIf
            If ParticleObject( ParticleID , XLoop )\YPos < ParticleSystem( ParticleID )\YMin
              ParticleObject( ParticleID , XLoop )\YPos = ParticleSystem( ParticleID )\YMax
              XRand.l = Random( ParticleSystem( ParticleID )\XSize - ParticleSystem( ParticleID )\Size )
              ZRand.l = Random( ParticleSystem( ParticleID )\ZSize - ParticleSystem( ParticleID )\Size )
              ParticleObject( ParticleID , XLoop )\XPos = ParticleSystem( ParticleID )\XMin + Xrand
              ParticleObject( ParticleID , XLoop )\ZPos = ParticleSystem( ParticleID )\ZMin + Zrand
             EndIf
            If ParticleObject( ParticleID , XLoop )\Zpos < ParticleSystem( ParticleID )\ZMin
              ParticleObject( ParticleID , Xloop )\Zpos = ParticleSystem( ParticleID )\ZMax - 4
             Else
              If ParticleObject( ParticleId , Xloop )\Zpos > ParticleSystem( ParticleId )\ZMax
                ParticleObject( ParticleId , Xloop )\Zpos = ParticleSystem( ParticleID )\Zmin + 4
               EndIf
             EndIf
            DBPositionObject( ParticleObject( ParticleID , Xloop )\Number , ParticleObject( ParticleID , Xloop )\Xpos , ParticleObject( ParticleID , Xloop )\Ypos , ParticleObject( ParticleID , Xloop )\Zpos )
           EndIf
         Next XLoop
       EndIf
     EndIf
   EndIf          
 EndProcedure
; **************************************************************
Procedure P3D_UpdateSparkles( ParticleID.l )
  If P3DInitialized = 1
    If ParticleID > 0 And ParticleID < 256 
      If ParticleSystem( ParticleID )\Exist = 1
        For XLoop = 1 To ParticleSystem( ParticleID )\Count
          ParticleObject( ParticleID, XLoop )\Duration = ParticleObject( ParticleID, XLoop )\Duration - TimeFactor
          If ParticleObject( ParticleID, XLoop )\Duration < 0
            ; On recrée la particule dans l'espace prévu pour.
            ParticleObject( ParticleID, XLoop )\Duration = ParticleSystem( ParticleID )\Duration
            XRand.l = Random( ParticleSystem( ParticleID )\XSize - ParticleSystem( ParticleID )\Size )
            YRand.l = Random( ParticleSystem( ParticleID )\YSize - ParticleSystem( ParticleID )\Size )
            ZRand.l = Random( ParticleSystem( ParticleID )\ZSize - ParticleSystem( ParticleID )\Size )
            ParticleObject( ParticleID , XLoop )\XPos = ParticleSystem( ParticleID )\XMin + XRand
            ParticleObject( ParticleID , XLoop )\YPos = ParticleSystem( ParticleID )\YMin + YRand
            ParticleObject( ParticleID , XLoop )\ZPos = ParticleSystem( ParticleID )\ZMin + ZRand     
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
            DBFadeObject( ParticleObject( ParticleID , XLoop )\Number , Percent * 3.0 )
            DBPositionObject( ParticleObject( ParticleID , Xloop )\Number , ParticleObject( ParticleID , Xloop )\Xpos , ParticleObject( ParticleID , Xloop )\Ypos , ParticleObject( ParticleID , Xloop )\Zpos )
           EndIf
         Next XLoop
       EndIf
     EndIf
   EndIf          
 EndProcedure
; ***************************************************************************************
ProcedureCDLL.l P3D_GetParticleXRange( ParticleID.l )
  If P3DInitialized = 1
    Range.l = ParticleSystem( ParticleID )\XSize
   Else
    Range = -1
   EndIf
  ProcedureReturn Range
 EndProcedure
; ***************************************************************************************
ProcedureCDLL.l P3D_GetParticleYRange( ParticleID.l )
  If P3DInitialized = 1
    Range.l = ParticleSystem( ParticleID )\YSize
   Else
    Range = -1
   EndIf
  ProcedureReturn Range
 EndProcedure
; ***************************************************************************************
ProcedureCDLL.l P3D_GetParticleZRange( ParticleID.l )
  If P3DInitialized = 1
    Range.l = ParticleSystem( ParticleID )\ZSize
   Else
    Range = -1
   EndIf
  ProcedureReturn Range
 EndProcedure
; ***************************************************************************************
ProcedureCDLL.l P3D_GetParticleXPosition( ParticleID.l )
  If P3DInitialized = 1
    Range.l = ParticleSystem( ParticleID )\XEmitter
   Else
    Range = -1
   EndIf
  ProcedureReturn Range
 EndProcedure
; ***************************************************************************************
ProcedureCDLL.l P3D_GetParticleYPosition( ParticleID.l )
  If P3DInitialized = 1
    Range.l = ParticleSystem( ParticleID )\YEmitter
   Else
    Range = -1
   EndIf
  ProcedureReturn Range
 EndProcedure
; ***************************************************************************************
ProcedureCDLL.l P3D_GetParticleZPosition( ParticleID.l )
  If P3DInitialized = 1
    Range.l = ParticleSystem( ParticleID )\ZEmitter
   Else
    Range = -1
   EndIf
  ProcedureReturn Range
 EndProcedure
; ***************************************************************************************
ProcedureCDLL.l P3D_GetParticleCount( ParticleID.l )
  If P3DInitialized = 1
    Range.l = ParticleSystem( ParticleID )\Count
   Else
    Range = -1
   EndIf
  ProcedureReturn Range
 EndProcedure
; ***************************************************************************************
ProcedureCDLL.l P3D_GetParticleType( ParticleID.l )
  If P3DInitialized = 1
    Range.l = ParticleSystem( ParticleID )\Type
   Else
    Range = -1
   EndIf
  ProcedureReturn Range
 EndProcedure
; ***************************************************************************************
ProcedureCDLL.l P3D_GetParticleSize( ParticleID.l )
  If P3DInitialized = 1
    Range.l = ParticleSystem( ParticleID )\Size
   Else
    Range = -1
   EndIf
  ProcedureReturn Range
 EndProcedure
; ***************************************************************************************
ProcedureCDLL.l P3D_GetParticleDuration( ParticleID.l )
  If P3DInitialize = 1
    PokeF( @Temp.l, ParticleSystem( ParticleID )\Duration )
   Else
    PokeF( @Temp.l, 0.0 )
   EndIf
  ProcedureReturn Temp
 EndProcedure
; IDE Options = PureBasic v4.02 (Windows - x86)
; CursorPosition = 250
; FirstLine = 210
; Folding = -----