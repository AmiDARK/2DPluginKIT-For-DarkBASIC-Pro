;
Procedure P2DK_DetachTileFromAnimation( TileID.l )
  If IsTileOk( TileID ) = 1 : Tiles( TileID )\AnimationID = 0 : EndIf
 EndProcedure
;
Procedure P2DK_DetachBobFromAnimation( BlitterID.l )
  If IsBlitterOk( BlitterID ) = 1 : Bobs( BlitterID )\AnimationID = 0 : EndIf
 EndProcedure
;
Procedure P2DK_DetachAnimationFromObjects( AnimID.l )
  If Animations( AnimID )\TileID > 0
    P2DK_DetachTileFromAnimation( Animations( AnimID )\TileID )
   EndIf
  If Animations( AnimID )\BobID > 0
    P2DK_DetachBobFromAnimation( Animations( AnimID )\BobID )
   EndIf
  Animations( AnimID )\SpriteID = 0
  Animations( AnimID )\BobID = 0
  Animations( AnimID )\TileID = 0
 EndProcedure
;
Procedure P2DK_SetAnimationFRAME( AnimID.l, FrameID.l, ImageID.l )
  If Animations( AnimID )\FramePTR > 0
    MemoryPTR.l = Animations( AnimID )\FramePTR + ( FrameID * 2 )
    PokeW( MemoryPTR, ImageID )
   EndIf
 EndProcedure

Procedure.l P2DK_GetAnimationFRAMETileID( AnimID.l, FrameID.l )
  If Animations( AnimID )\FramePTR > 0
    MemoryPTR.l = Animations( AnimID )\FramePTR + ( FrameID * 2 )
    Retour.l = PeekW( MemoryPTR )
   Else
    Retour = 0
   EndIf
  ProcedureReturn Retour
 EndProcedure

Procedure.l P2DK_GetFrameImage( FrameLIST.s , FrameID.l )
  If Len( FrameLIST ) = 0
    Retour.l = 0
   Else
    POS1.l = 0 : POS2.l = 0
    InPOS.l = 1 : InCHAR = 0
    Repeat
      If Mid( FrameLIST, InPOS, 1 ) = ";"
        InCHAR = InCHAR + 1
        If InCHAR = FrameID : POS1 = InPOS + 1 : EndIf
        If InCHAR = FrameID + 1 : POS2 = InPOS : EndIf
       EndIf
      InPOS = InPOS + 1
     Until InPOS > Len( FrameLIST ) Or ( POS1 > 0 And POS2 > 0 )
    If POS1 > 0 And POS2 > 0
      Retour = Val( Mid( FrameLIST, POS1, POS2 - POS1 ) )
;      MessageRequester( "2DPlugKIT DEBUG", Mid( FrameLIST, POS1, POS2 - POS1 ) )
     Else
      Retour = 0
     EndIf
   EndIf
  ProcedureReturn Retour
 EndProcedure

ProcedureCDLL P2DK_CreateAnimation( AnimID.l, FramLIST.l )
  ; On récupère le texte meme si le n° d'anim est mauvais pour éviter un crash du compiler...
  If FramLIST <> 0
    FrameLIST.s = PeekS( FramLIST ) ; We must take the string contained at Param1S
    CallCFunctionFast( *GlobPtr\CreateDeleteString, FramLIST, 0 ) ; Free memory used by the original text.
   EndIf
  If AnimID > 0 And AnimID < 257 And PlugINITIALIZED = 1
    FrameCOUNT = GetQuantity( FrameLIST, ";" )
    If FrameCOUNT = 0 : MessageRequester( "2DPlugKIT Error", "No frames defined in that animation sequence" ) : EndIf
    ; Mise en mémoire de la zone réservée pour l'animation.
    FramePTR.l = AllocateMemory( FrameCOUNT * 2 )
    Animations( AnimID )\FramePTR = FramePTR
    ; Mise en place des numéros d'images d'animations dans la liste des frames d'animation.
    TrueCOUNT.l = 0
    For XLoop = 1 To FrameCOUNT Step 1
      ImageID.l = P2DK_GetFrameImage( FrameLIST, XLoop )
      If ImageID > 0
        TrueCOUNT = TrueCOUNT + 1
        P2DK_SetAnimationFRAME( AnimID.l, TrueCOUNT, ImageID )
       EndIf
     Next XLoop
    Animations( AnimID )\FrameCOUNT = TrueCOUNT
    ; Mise en place des autres données relatives à l'animation
    Animations( AnimID )\LastFRAME = P2DK_GetAnimationFRAMETileID( AnimID, 1 )
    Animations( AnimID )\PlayANIM = 0
    Animations( AnimID )\TileID = 0
    Animations( AnimID )\SpriteID = 0
    Animations( AnimID )\BobID = 0
    Animations( AnimID )\Speed = 10
    Animations( AnimID )\Active = 1
   Else
    MessageRequester( "2DPlugKIT Error", "Animation number is invalid" )
   EndIf
 EndProcedure

ProcedureCDLL P2DK_SetAnimationToSprite( AnimID.l, SpriteID.l )
  If AnimID > 0 And AnimID < 257 And PlugINITIALIZED = 1
    If SpriteID > 0
      If DBGetSpriteExist( SpriteID ) = 1
        If Animations( AnimID )\Active = 1
          P2DK_DetachAnimationFromObjects( AnimID )
          Animations( AnimID )\SpriteID = SpriteID
         Else
          MessageRequester( "2DPlugKIT Error", "Animation sequence does not exist" )
         EndIf
       Else
        MessageRequester( "2DPlugKIT Error", "Sprite does not exist" )
       EndIf
     Else
      MessageRequester( "2DPlugKIT Error", "Sprite number is invalid" )
     EndIf
   Else
    MessageRequester( "2DPlugKIT Error", "Animation number is invalid" )
   EndIf
 EndProcedure

ProcedureCDLL P2DK_SetAnimationToTile( AnimID.l, TileID.l )
  If AnimID > 0 And AnimID < 257 And PlugINITIALIZED = 1
    If TileID > 0
      If Tiles( TileID )\Active = 1
        If Animations( AnimID )\Active = 1
          P2DK_DetachAnimationFromObjects( AnimID )
          Animations( AnimID )\TileID = TileID
          Tiles( TileID )\AnimationID = AnimID
         Else
          MessageRequester( "2DPlugKIT Error", "Animation sequence does not exist" )
         EndIf
       Else
        MessageRequester( "2DPlugKIT Error", "Tile does not exist" )
       EndIf
     Else
      MessageRequester( "2DPlugKIT Error", "Tile number is invalid" )
     EndIf
   Else
    MessageRequester( "2DPlugKIT Error", "Animation number is invalid" )
   EndIf
 EndProcedure

ProcedureCDLL P2DK_SetAnimationToBob( AnimID.l, BlitterID.l )
  If AnimID > 0 And AnimID < 257 And PlugINITIALIZED = 1
    If IsBlitterOk( BlitterID ) = 1
      If Animations( AnimID )\Active = 1
        P2DK_DetachAnimationFromObjects( AnimID )
        Animations( AnimID )\BobID = BlitterID
        Bobs( BlitterID )\AnimationID = AnimID
       Else
        MessageRequester( "2DPlugKIT Error", "Animation sequence does not exist" )
       EndIf
     Else
      MessageRequester( "2DPlugKIT Error", "Bob does not exist or is invalid" )
     EndIf
   Else
    MessageRequester( "2DPlugKIT Error", "Animation number is invalid" )
   EndIf
 EndProcedure

ProcedureCDLL P2DK_SetAnimationSpeed( AnimID.l, PlaySPEED.l )
  If AnimID > 0 And AnimID < 257 And PlugINITIALIZED = 1
    If Animations( AnimID )\Active = 1
      Animations( AnimID )\Speed = PlaySPEED
     Else
      MessageRequester( "2DPlugKIT Error", "Animation sequence does not exist" )
     EndIf
   Else
    MessageRequester( "2DPlugKIT Error", "Animation number is invalid" )
   EndIf
 EndProcedure

ProcedureCDLL P2DK_PlayANIMATION( AnimID.l )
  If AnimID > 0 And AnimID < 257 And PlugINITIALIZED = 1
    If Animations( AnimID )\Active = 1
      Animations( AnimID )\PlayANIM = 1
      Animations( AnimID )\StartTIMER = DBTimerL()
      Animations( AnimID )\LoopMODE = 1
     Else
      MessageRequester( "2DPlugKIT Error", "Animation sequence does not exist" )
     EndIf
   Else
    MessageRequester( "2DPlugKIT Error", "Animation number is invalid" )
   EndIf
 EndProcedure

ProcedureCDLL P2DK_StopANIMATION( AnimID.l )
  If AnimID > 0 And AnimID < 257 And PlugINITIALIZED = 1
    If Animations( AnimID )\Active = 1
      Animations( AnimID )\PlayANIM = 0
      Animations( AnimID )\StartTIMER = 0
     Else
      MessageRequester( "2DPlugKIT Error", "Animation sequence does not exist" )
     EndIf
   Else
    MessageRequester( "2DPlugKIT Error", "Animation number is invalid" )
   EndIf
 EndProcedure

ProcedureCDLL P2DK_LoopANIMATION( AnimID.l, LoopMODE.l )
  If AnimID > 0 And AnimID < 257 And PlugINITIALIZED = 1
    If Animations( AnimID )\Active = 1
      Animations( AnimID )\LoopMODE = LoopMODE
     Else
      MessageRequester( "2DPlugKIT Error", "Animation sequence does not exist" )
     EndIf
   Else
    MessageRequester( "2DPlugKIT Error", "Animation number is invalid" )
   EndIf
 EndProcedure

Procedure P2DK_UpdateANIMATION( AnimID.l )
  If Animations( AnimID )\Speed <> 0 And PlugINITIALIZED = 1
    Delay.f = ( ( Setup\NewTIMER - Animations( AnimID )\StartTIMER ) / 1000.0 )
    Frame.f = Delay * Abs( Animations( AnimID )\Speed )
    Count.l = Int( Frame / Animations( AnimID )\FrameCOUNT )
    If Animations( AnimID )\LoopMODE = 0 And Count > 0
      RealFRAME = Animations( AnimID )\FrameCOUNT
      Animations( AnimID )\PlayANIM = 0
     Else
      RealFRAME.l = Int( Frame - ( Count * Animations( AnimID )\FrameCOUNT ) ) + 1
     EndIf
    TileID.l = P2DK_GetAnimationFRAMETileID( AnimID, RealFRAME )
    If tileID > 0
      Animations( AnimID )\LastFRAME = TileID
      ; Update de la frame d'animation dans le sprite affecté.
      If Animations( AnimID )\SpriteID > 0
        If DBGetSpriteExist( Animations( AnimID )\SpriteID ) = 1 And DBGetImageExist( ImageID ) = 1
          DBSprite( Animations( AnimID )\SpriteID, DBGetSpritePositionX( Animations( AnimID )\SpriteID ), DBGetSpritePositionY( Animations( AnimID )\SpriteID ), ImageID )
         EndIf
       EndIf
      ; Update de la frame d'animation dans la tile affectée
      If Animations( AnimID )\TileID > 0
        If Tiles( Animations( AnimID )\TileID )\Active = 1
          Tiles( Animations( AnimID )\TileID )\TileANIMFrame = TileID
         EndIf
       EndIf
      ; Update de la frame d'animation dans le Blitter Object affecté.
      If Animations( AnimID )\BobID > 0
        If Bobs( Animations( AnimID )\BobID )\Active = 1
          Bobs( Animations( AnimID )\BobID )\CurrentFrame = TileID
         EndIf
       EndIf
     EndIf
   EndIf
 EndProcedure

ProcedureCDLL P2DK_UpdateANIMATIONS()
  Setup\NewTIMER = DBTimerL()
  For AnimPLAYER = 1 To 256
    If Animations( AnimPLAYER )\Active = 1 And Animations( AnimPLAYER )\PlayANIM = 1 And PlugINITIALIZED = 1
      If Animations( AnimPLAYER )\StartTIMER = 0 : Animations( AnimPLAYER )\StartTIMER = Setup\NewTIMER : EndIf
      P2DK_UpdateANIMATION( AnimPLAYER )
     EndIf
   Next AnimPLAYER
 EndProcedure

ProcedureCDLL.l P2DK_GetAnimationPlaying( AnimID )
  If AnimID > 0 And AnimID < 257 And PlugINITIALIZED = 1
    Retour.l = Animations( AnimID )\PlayANIM
   Else
    Retour = 0
   EndIf
  ProcedureReturn Retour
 EndProcedure
; IDE Options = PureBasic 4.10 Beta 2 (Windows - x86)
; CursorPosition = 215
; FirstLine = 199
; Folding = ---