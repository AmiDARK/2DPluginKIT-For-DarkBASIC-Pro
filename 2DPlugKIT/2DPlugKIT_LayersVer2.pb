;
; ********************************************
; *                                          *
; * 2DPlugKIT Include File : TILES FUNCTIONS *
; *                                           
; ********************************************
; This include contain functions related to Layers handling.
;**************************************************************************************************************
; P2DK_CreateMapLayer( LayerID.l, Width.l, Height.l )
; P2DK_SetLayerTile( LayerID.l, X.l, Y.l, TileID.l )
; P2DK_SetLayerArea( LayerID.l, Left.l, Top.l, Right.l, Bottom.l )
; P2DK_SetLayerPosition( LayerID.l, XPos.l, YPos.l )
; P2DK_SetLayerPositionX( LayerID.l, XPos.l )
; P2DK_SetLayerPositionY( LayerID.l, YPos.l )
; P2DK_SetLayerUVMode( LayerID.l, XC.l, YC.l )
; P2DK_SetLayerTilesSizes( LayerID.l, Width.l, Height.l )
; P2DK_ScrollLayer( LayerID.l, XScroll.l, YScroll.l )
; P2DK_ScrollLayerX( LayerID2.l, XScroll2.l )
; P2DK_ScrollLayerY( LayerID2.l, YScroll2.l )
; P2DK_TraceLayer( LayerID.l, X0.l, Y0.l, X1.l, Y1.l )
; P2DK_TraceLayerEx( LayerID )
; P2DK_DeleteMapLayer( LayerID.l )
; P2DK_CopyLayer( LayerDEST.l, LayerID.l )
; P2DK_SetLayerVisible( LayerID.l, VisibleMODE.l )
;**************************************************************************************************************
; P2DK_GetLayerExist( LayerID.l )
; P2DK_GetLayerWidth( LayerID.l )
; P2DK_GetLayerHeight( LayerID.l )
; P2DK_GetLayerTileWIDTH( LayerID.l )
; P2DK_GetLayerTileHEIGHT( LayerID.l )
; P2DK_GetLayerXCycle( LayerID.l )
; P2DK_GetLayerYCycle( LayerID.l )
; P2DK_GetLayerXScroll( LayerID.l )
; P2DK_GetLayerYScroll( LayerID.l )
; P2DK_GetLayerTileID( LayerID.l, X.l, Y.l )
; P2DK_GetLayerVisible( LayerID.l )
;**************************************************************************************************************
; P2DK_WriteLAYERToFILE( ChannelID.l, LayerID.l )
; P2DK_CreateLAYERFromFile( ChannelID.l, NewLayerID.l )
; P2DK_CreateLAYERFromFileEx( ChannelID2.l )
; P2DK_WriteLayersToFile( ChannelID2.l )
; P2DK_CreateLayersFromFile( ChannelID2.l )
;**************************************************************************************************************
DeclareCDLL.l P2DK_GetLayerTileID( LayerID.l, X.l, Y.l )
DeclareCDLL.l P2DK_GetLayerTileIDV1( LayerID.l, X.l, Y.l )
Declare.l GetLayerTileIDV1INTERNAL( LayerID.l, X.l, Y.l )
;**************************************************************************************************************
;
ProcedureCDLL P2DK_CreateMapLayer( LayerID.l, CWidth.l, CHeight.l )
  If Layers( LayerID )\Active = 0 And PlugINITIALIZED = 1
    MemorySIZE.l = ( CWidth * CHeight * 2 )
;    MemoryPTR = AllocateMemory( MemorySIZE )
    MemoryMBC.l = MBC_DynamicMake( MemorySIZE )
    If MemoryMBC <> 0
      MemoryPTR.l = DBGetMemblockPtr( MemoryMBC )
      Layers( LayerID )\Active = 1
      Layers( LayerID )\MemoryMBC = MemoryMBC
      Layers( LayerID )\MemoryPTR = MemoryPTR
      Layers( LayerID )\MemorySIZE = MemorySIZE
      Layers( LayerID )\Width = CWidth : Layers( LayerID )\Height= CHeight
      Layers( LayerID )\TileWIDTH = Setup\DefaultWIDTH
      Layers( LayerID )\TileHEIGHT = Setup\DefaultHEIGHT
      Layers( LayerID )\Hide = 0
      Layers( LayerID )\XDisplay = 0 : Layers( LayerID )\YDisplay = 0
      Layers( LayerID )\XCycle = 0 : Layers( LayerID )\YCycle = 0
      Layers( LayerID )\BitmapToTrace = 0
      Layers( LayerID )\XStart = 0 : Layers( LayerID )\YStart = 0
      Layers( LayerID )\XEnd = 0 : Layers( LayerID )\YEnd = 0
     Else
      MessageRequester( "2DPlugKIT Error", "Cannot create layer" )
     EndIf
   Else
    MessageRequester( "2DPlugKIT Error", "Asked layer already exist" )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetLayerTile( LayerID.l, X.l, Y.l, TileID.l )
  If Layers( LayerID )\Active = 1 And PlugINITIALIZED = 1
    If X > -1 And Y > -1 And X <= Layers( LayerID )\Width And Y <= Layers( LayerID )\Height
      If TileID > -1 And TileID < 65536
        MemoryPTR.l = Layers( LayerID )\MemoryPTR + ( ( ( Layers( LayerID )\Width * Y ) + X ) * 2 )
        PokeW( MemoryPTR, TileID )
       Else
        MessageRequester( "2DPlugKIT Error", "Tile is invalid" )
       EndIf 
     Else
      MessageRequester( "2DPlugKIT Error", "Tile position is outside layer" )
     EndIf
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetLayerArea( LayerID.l, Left.l, Top.l, Right.l, Bottom.l )
  If IsLayerOk( LayerID ) = 1 And PlugINITIALIZED = 1
    Layers( LayerID )\XStart = Left : Layers( LayerID )\YStart = Top
    Layers( LayerID )\XEnd = Right : Layers( LayerID )\YEnd = Bottom
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetLayerPosition( LayerID.l, XPos.l, YPos.l )
  If IsLayerOk( LayerID ) = 1 And PlugINITIALIZED = 1
    Layers( LayerID )\XDisplay = PeekF( @XPos )
    Layers( LayerID )\YDisplay = PeekF( @YPos )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetLayerPositionX( LayerID.l, XPos.l )
  If IsLayerOk( LayerID ) = 1 And PlugINITIALIZED = 1
    Layers( LayerID )\XDisplay = PeekF( @XPos )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetLayerPositionY( LayerID.l, YPos.l )
  If IsLayerOk( LayerID ) = 1 And PlugINITIALIZED = 1
    Layers( LayerID )\YDisplay = PeekF( @YPos )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetLayerUVMode( LayerID.l, XC.l, YC.l )
  If IsLayerOk( LayerID ) = 1 And PlugINITIALIZED = 1
    Layers( LayerID )\XCycle = XC
    Layers( LayerID )\YCycle = YC
   EndIf  
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetLayerTilesSizes( LayerID.l, Width.l, Height.l )
  If IsLayerOk( LayerID ) = 1 And PlugINITIALIZED = 1
    Layers( LayerID )\TileWIDTH = Width
    Layers( LayerID )\TileHEIGHT = Height
   EndIf  
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_ScrollLayer( LayerID.l, XScroll.l, YScroll.l )
  If IsLayerOk( LayerID ) = 1 And PlugINITIALIZED = 1
    Layers( LayerID )\XDisplay = Layers( LayerID )\XDisplay + XScroll
    Layers( LayerID )\YDisplay = Layers( LayerID )\YDisplay + YScroll
    LayerWIDTH = Layers( LayerID )\Width * Layers( LayerID )\TileWIDTH
    LayerHEIGHT = Layers( LayerID )\Height * Layers( LayerID )\TileHEIGHT
    If Layers( LayerID )\XDisplay < 0 - LayerWIDTH
      Layers( LayerID )\XDisplay = Layers( LayerID )\XDisplay + LayerWIDTH
     Else
      If Layers( LayerID )\XDisplay > LayerWIDTH
        Layers( LayerID )\XDisplay = Layers( LayerID )\XDisplay - LayerWIDTH
       EndIf
     EndIf
    If Layers( LayerID )\YDisplay < 0 - LayerHEIGHT
      Layers( LayerID )\YDisplay = Layers( LayerID )\YDisplay + LayerHEIGHT
     Else
      If Layers( LayerID )\YDisplay > LayerHEIGHT
        Layers( LayerID )\YDisplay = Layers( LayerID )\YDisplay - LayerHEIGHT
       EndIf
     EndIf   
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_ScrollLayerX( LayerID2.l, XScroll2.l )
  P2DK_ScrollLayer( LayerID2, XScroll2, 0 )
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_ScrollLayerY( LayerID2.l, YScroll2.l )
  P2DK_ScrollLayer( LayerID2, 0, YScroll2 )
 EndProcedure
;
;**************************************************************************************************************
;
Procedure P2DK_TraceLayerINTERNAL( LayerID.l, X0.l, Y0.l, X1.l, Y1.l )
  If IsLayerOk( LayerID ) = 1 And Layers( LayerID )\Hide = 0 And PlugINITIALIZED = 1
    P2DK_StartTILESRendering()
    XDisplay.l = Layers( LayerID )\XDisplay
    YDisplay.l = Layers( LayerID )\YDisplay
    ; Si les coordonnées bas, droite ne sont pas définies, on les colle au maximum de l'écran.
    If X0 = 0 : X0 = X0 - Layers( LayerID )\TileWIDTH : XDisplay = XDisplay - Layers( LayerID )\TileWIDTH : EndIf
    If Y0 = 0 : Y0 = Y0 - Layers( LayerID )\TileHEIGHT : YDisplay = YDisplay - Layers( LayerID )\TileHEIGHT : EndIf
    If X1 = 0 : X1 = DBBitmapWidth1() + Layers( LayerID )\TileWIDTH : EndIf
    If Y1 = 0 : Y1 = DBBitmapHeight1() + Layers( LayerID )\TileHEIGHT : EndIf
    ; Lecture des dimensions de l'écran pour le calcul de la zone de tracé.
    XCount.l = ( X1 - X0 ) / Layers( LayerID )\TileWIDTH
    YCount.l = ( Y1 - Y0 ) / Layers( LayerID )\TileHEIGHT
    XStart.l = XDisplay / Layers( LayerID )\TileWIDTH
    YStart.l = YDisplay / Layers( LayerID )\TileHEIGHT
    XShift.l = XDisplay - ( XStart * Layers( LayerID )\TileWIDTH )
    YShift.l = YDisplay - ( YStart * Layers( LayerID )\TileHEIGHT )
    YTile = YStart :
    YLoop = - YShift + Y0 : Repeat
      XTile = XStart
      XLoop = - XShift + X0 : Repeat
        TileID = GetLayerTileIDV1INTERNAL( LayerID, XTile, YTile )        
        If TileID > 0
;          If LayerID = 1
;            P2DK_PasteTileEx( TileID, XLoop, YLoop, 0 )
;           Else
            P2DK_PasteTile( TileID, XLoop, YLoop )
;           EndIf
         EndIf
       XTile = Xtile + 1
       XLoop = XLoop + Layers( LayerID )\TileWIDTH  : Until XLoop >= X1
      YTile = YTile + 1 
     YLoop = YLoop + Layers( LayerID )\TileHEIGHT : Until YLoop >= Y1
    P2DK_StopTILESRendering()
    P2DK_DisplayLayerBOBS( LayerID, X0, Y0, X1, Y1, XDisplay, YDisplay )
    P2DK_DisplayLayerPARTICLES( LayerID, X0, Y0, X1, Y1, XDisplay, YDisplay )
    P2DK_DisplayLayerLights( LayerID, X0, Y0, X1, Y1, XDisplay, YDisplay )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_TraceLayer( LayerID.l, X0.l, Y0.l, X1.l, Y1.l )
  If IsLayerOk( LayerID ) = 1 And PlugINITIALIZED = 1
    P2DK_TraceLayerINTERNAL( LayerID, X0, Y0, X1, Y1 )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;

ProcedureCDLL P2DK_TraceLayer_V1( LayerID.l, X0.l, Y0.l, X1.l, Y1.l )
  If IsLayerOk( LayerID ) = 1 And Layers( LayerID )\Hide = 0 And PlugINITIALIZED = 1
    ; Si les coordonnées bas, droite ne sont pas définies, on les colle au maximum de l'écran.
    If X1 = 0 : X1 = DBBitmapWidth1() + Layers( LayerID )\TileWIDTH : EndIf
    If Y1 = 0 : Y1 = DBBitmapHeight1() + Layers( LayerID )\TileHEIGHT : EndIf
    ; Lecture des dimensions de l'écran pour le calcul de la zone de tracé.
    DisplayWIDTH.l = X1 - X0 : DisplayHEIGHT.l = Y1 - Y0
    ; On gère le positionnement dans le layer si le CameraLOCK est activé.
    ; On Check Les coordonnées du layer selon les limitations.
    If Layers( LayerID )\CameraLOCK = 1
      If ( Layers( LayerID )\XDisplay + DisplayWIDTH ) > Layers( LayerID )\TileWIDTH * Layers( LayerID )\Width
        Layers( LayerID )\XDisplay = ( Layers( LayerID )\TileWIDTH * Layers( LayerID )\Width ) - DisplayWIDTH
       EndIf
      If ( Layers( LayerID )\YDisplay + DisplayHEIGHT ) > ( Layers( LayerID )\TileHEIGHT * Layers( LayerID )\Height )
        Layers( LayerID )\YDisplay = ( Layers( LayerID )\TileHEIGHT * Layers( LayerID )\Height ) - DisplayHEIGHT
       EndIf
      If Layers( LayerID )\XDisplay < 0 : Layers( LayerID )\XDisplay = 0 : EndIf
      If Layers( LayerID )\YDisplay < 0 : Layers( LayerID )\YDisplay = 0 : EndIf
     EndIf
    ; Calcul de la première tile du layer à tracer sur X et sur Y et vérification des limites du tracé.
    XStart.l = Int( Layers( LayerID )\XDisplay ) / Layers( LayerID )\TileWIDTH
    YStart.l = Int( Layers( LayerID )\YDisplay ) / Layers( LayerID )\TileHEIGHT
    ; Calcul des valeurs de décalage de pixels pour le tracé dans l'écran.
    XShift.l = Int( Layers( LayerID )\XDisplay ) - ( XStart * Layers( LayerID )\TileWIDTH )
    YShift.l = Int( Layers( LayerID )\YDisplay ) - ( YStart * Layers( LayerID )\TileHEIGHT )
    ; Tracé du layer dans l'écran actif
    If XShift < 0
      XBegin.l = X0 - Layers( LayerID )\TileWIDTH : XStart = XStart - 1
     Else
      XBegin = X0
     EndIf
    YLoop.l = Y0 : Repeat
      XTile.l = XStart
      XLoop.l = XBegin : Repeat
        TileID.l = P2DK_GetLayerTileID( LayerID, XTile, YStart )
        If LayerID = 1
          P2DK_PasteTileEx( TileID, XLoop - XShift, YLoop - YShift, 0 )
         Else
          P2DK_PasteTile( TileID, XLoop - XShift, YLoop - YShift )
        EndIf
        XTile = XTile + 1 ; Next Tile to display.
        XLoop = XLoop + Layers( LayerID )\TileWIDTH
       Until XLoop >= X1
      YStart = YStart + 1 ; Next tile line to display
      YLoop = YLoop + Layers( LayerID )\TileHEIGHT
     Until YLoop >= Y1 
    P2DK_DisplayLayerLights( LayerID.l, X0, Y0, X1, Y1, Layers( LayerID )\XDisplay, Layers( LayerID )\YDisplay )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_TraceLayerEx( LayerID )
  If IsLayerOk( LayerID ) = 1 And PlugINITIALIZED = 1
    XS.l = Layers( LayerID )\XStart : YS.l = Layers( LayerID )\YStart
    XE.l = Layers( LayerID )\XEnd : YE.l = Layers( LayerID )\YEnd
    P2DK_TraceLayerINTERNAL( LayerID, XS, YS, XE, YE )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_DeleteMapLayer( LayerID.l )
  If IsLayerOk( LayerID ) = 1 And PlugINITIALIZED = 1
    Layers( LayerID )\Active = 0
    Layers( LayerID )\MemoryMBC = MBC_Delete( Layers( LayerID )\MemoryMBC )
    Layers( LayerID )\MemoryPTR = 0 : Layers( LayerID )\MemorySIZE = 0
    Layers( LayerID )\Width = 0 : Layers( LayerID )\Height = 0
    Layers( LayerID )\TileWIDTH = 0 : Layers( LayerID )\TileHEIGHT = 0 
    Layers( LayerID )\Hide = 0
    Layers( LayerID )\XDisplay = 0 : Layers( LayerID )\YDisplay = 0
    Layers( LayerID )\BitmapToTrace = 0
    Layers( LayerID )\XStart = 0 : Layers( LayerID )\YStart = 0
    Layers( LayerID )\XEnd = 0 : Layers( LayerID )\YEnd = 0
    Layers( LayerID )\XCycle = 0 : Layers( LayerID )\YCycle = 0
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_CopyLayer( LayerDEST.l, LayerID.l )
  If IsLayerOk( LayerID ) = 1 And IsLayerAvailable( LayerDEST ) = 0 And PlugINITIALIZED = 1
    LWidth.l = Layers( LayerID )\Width : LHeight.l = Layers( LayerID )\Height
    MemorySIZE.l = ( LWidth * LHeight * 2 )
    MemoryMBC.l = MBC_DynamicMake( MemorySIZE )
    If MemoryMBC <> 0
      MemoryPTR.l = DBGetMemblockPtr( MemoryMBC )
      Layers( LayerDEST )\Active = 1
      Layers( LayerDEST )\MemoryMBC = MemoryMBC
      Layers( LayerDEST )\MemoryPTR = MemoryPTR
      Layers( LayerDEST )\MemorySIZE = MemorySIZE
      Layers( LayerDEST )\Width = LWidth
      Layers( LayerDEST )\Height= LHeight
      Layers( LayerDEST )\TileWIDTH = Layers( LayerID )\TileWIDTH
      Layers( LayerDEST )\TileHEIGHT = Layers( LayerID )\TileHEIGHT
      Layers( LayerDEST )\Hide = Layers( LayerID )\Hide
      Layers( LayerDEST )\XDisplay = Layers( LayerID )\XDisplay
      Layers( LayerDEST )\YDisplay = Layers( LayerID )\YDisplay
      Layers( LayerDEST )\BitmapToTrace = Layers( LayerID )\BitmapToTrace
      Layers( LayerDEST )\XCycle = Layers( LayerID )\XCycle
      Layers( LayerDEST )\YCycle = Layers( LayerID )\YCycle
      Layers( LayerDEST )\XStart = Layers( LayerID )\XStart
      Layers( LayerDEST )\YStart = Layers( LayerID )\YStart
      Layers( LayerDEST )\XEnd = Layers( LayerID )\XEnd
      Layers( LayerDEST )\YEnd = Layers( LayerID )\YEnd
      Layers( LayerDEST )\ScrollMODE = Layers( LayerID )\ScrollMODE
      Layers( LayerDEST )\XSpeed = Layers( LayerID )\XSpeed
      Layers( LayerDEST )\YSpeed = Layers( LayerID )\YSPeed
      Layers( LayerDEST )\CameraLOCK = Layers( LayerID )\CameraLOCK
      CopyMemoryM( Layers( LayerID )\MemoryPTR, Layers( LayerDEST )\MemoryPTR, MemorySIZE, 0, 0, 1)
     Else
      MessageRequester( "2DPlugKIT Warning", "Cannot create copy layer" )
     EndIf
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetLayerVisible( LayerID.l, VisibleMODE.l )
  If IsLayerOk( LayerID ) = 1
    Select VisibleMODE
      Case 0 : Layers( LayerID )\Hide = 1
      Case 1 : Layers( LayerID )\Hide = 0
     EndSelect
    If VisibleMODE < 0 Or VisibleMODE > 1
      MessageRequester( "2DPlugKIT Error", "Layer visibility flag value is invalid" )
     EndIf
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetLayerExist( LayerID.l )
  If LayerID > 0 And LayerID < 16
    Retour.l = Layers( LayerID )\Active
   Else
    Retour = 0
    MessageRequester( "2DPlugKIT Error", "Layer number is invalid" )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetLayerWidth( LayerID.l )
  If IsLayerOk( LayerID ) = 1
    Retour.l = Layers( LayerID )\Width
   Else
    Retour = 0
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetLayerHeight( LayerID.l )
  If IsLayerOk( LayerID ) = 1
    Retour.l = Layers( LayerID )\Height
   Else
    Retour.l = 0
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetLayerTileWIDTH( LayerID.l )
  If IsLayerOk( LayerID ) = 1
    Retour.l = Layers( LayerID )\TileWIDTH
   Else
    Retour = 0
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetLayerTileHEIGHT( LayerID.l )
  If IsLayerOk( LayerID ) = 1
    Retour.l = Layers( LayerID )\TileHEIGHT
   Else
    Retour = 0
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetLayerXCycle( LayerID.l )
  If IsLayerOk( LayerID ) = 1
    Retour.l = Layers( LayerID )\XCycle
   Else
    Retour = 0
   EndIf
 ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetLayerYCycle( LayerID.l )
  If IsLayerOk( LayerID ) = 1
    Retour.l = Layers( LayerID )\YCycle
   Else
    Retour = 0
   EndIf
 ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetLayerXScroll( LayerID.l )
  If IsLayerOk( LayerID ) = 1
    PokeF( @Retour.l, Layers( LayerID )\XDisplay )
   Else
    PokeF( @Retour.l, 0.0 )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetLayerYScroll( LayerID.l )
  If IsLayerOk( LayerID ) = 1
    PokeF( @Retour.l, Layers( LayerID )\YDisplay )
   Else
    PokeF( @Retour.l, 0.0 )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetLayerTileID( LayerID.l, X.l, Y.l )
;  X.f = XF : Y.f = YF
  If IsLayerOk( LayerID ) = 1 And PlugINITIALIZED = 1
    ; Checking des limites sur X.
    If X >= Layers( LayerID )\Width Or X < 0
      If Layers( LayerID )\XCycle = 1      
        Count.l = X / Layers( LayerID )\Width
        If X < 0 : Count = Count - 1 : EndIf
        X = X - ( Layers( LayerID )\Width * Count )
       Else
        X = - 1
       EndIf
     EndIf
    ; Checking des limites sur Y.
    If Y >= Layers( LayerID )\Height Or Y < 0
      If Layers( LayerID )\YCycle = 1
        Count.l = Y / Layers( LayerID )\Height
        If Y < 0 : Count = Count - 1 : EndIf
        Y = Y - ( Layers( LayerID )\Height * Count )
       Else
        Y = - 1
       EndIf
     EndIf
    If X = -1 Or Y = -1 
      Retour.l = 0
     Else
      MemoryPTR = Layers( LayerID )\MemoryPTR + ( ( ( Layers( LayerID )\Width * Y ) + X ) * 2 )
      Retour = PeekW( MemoryPTR )
     EndIf
   Else
    Retour = 0
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l GetLayerTileIDV1INTERNAL( LayerID.l, X.l, Y.l )
  If Layers( LayerID )\XCycle = 1 And X <> 0
    Count.l = X / Layers( LayerID )\Width
    If X < 0 : Count = Count - 1 : EndIf
    X = X - ( Layers( LayerID )\Width * Count )
   EndIf
  If Layers( LayerID )\YCycle = 1 And Y <> 0
    Count.l = Y / Layers( LayerID )\Height
    If Y < 0 : Count = Count - 1 : EndIf
    Y = Y - ( Layers( LayerID )\Height * Count )
   EndIf
  If X > -1 And Y > -1 And X < Layers( LayerID )\Width And Y < Layers( LayerID )\Height
    MemoryPTR = Layers( LayerID )\MemoryPTR + ( ( ( Layers( LayerID )\Width * Y ) + X ) * 2 )
    Retour.l = PeekW( MemoryPTR )
   Else
    Retour = 0
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetLayerTileIDV1( LayerID.l, X.l, Y.l )
  If IsLayerOk( LayerID ) = 1
    Retour.l = GetLayerTileIDV1INTERNAL( LayerID, X, Y )
   Else
    Retour = 0
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetLayerVisible( LayerID.l )
  If IsLayerOk( LayerID ) = 1
    Retour.l = 1 - Layers( LayerID )\Hide
   Else
    Retour = 0
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_WriteLAYERToFILE( ChannelID.l, LayerID.l )
  If IsLayerOk( LayerID ) = 1 And PlugINITIALIZED = 1
    DBWriteString( ChannelID, "[2DPKNewLayer]" )
    DBWriteLong( ChannelID, LayerID )
    DBWriteLong( ChannelID, Layers( LayerID )\Active )
    DBWriteLong( ChannelID, Layers( LayerID )\Width )
    DBWriteLong( ChannelID, Layers( LayerID )\Height )
    DBWriteLong( ChannelID, Layers( LayerID )\TileWIDTH )
    DBWriteLong( ChannelID, Layers( LayerID )\TileHEIGHT )
    DBWriteLong( ChannelID, Layers( LayerID )\XCycle )
    DBWriteLong( ChannelID, Layers( LayerID )\YCycle )
    DBWriteLong( ChannelID, Layers( LayerID )\Hide )
    DBWriteLong( ChannelID, Layers( LayerID )\XDisplay )
    DBWriteLong( ChannelID, Layers( LayerID )\YDisplay )
    DBWriteLong( ChannelID, Layers( LayerID )\BitmapToTrace )
    DBWriteLong( ChannelID, Layers( LayerID )\XStart )
    DBWriteLong( ChannelID, Layers( LayerID )\YStart )
    DBWriteLong( ChannelID, Layers( LayerID )\XEnd )
    DBWriteLong( ChannelID, Layers( LayerID )\YEnd )
    DBWriteLong( ChannelID, Layers( LayerID )\ScrollMODE )
    DBWriteFloat( ChannelID, Layers( LayerID )\XSpeed )
    DBWriteFloat( ChannelID, Layers( LayerID )\YSpeed )
    DBWriteLong( ChannelID, Layers( LayerID )\CameraLOCK )
    DBWriteString( ChannelID, "[2DPKLayerData]" )
    DBWriteMemblock( ChannelID, Layers( LayerID )\MemoryMBC )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_CreateLAYERFromFile( ChannelID.l, NewLayerID.l )
  If NewLayerID >= 0 And NewLayerID < 16 And PlugINITIALIZED = 1
    If Layers( NewLayerID )\Active = 0
      _HEADER$ = DBReadString( ChannelID )
      If _HEADER$ = "[2DPKNewLayer]"
        LayerID = DBReadLong( ChannelID )
        If NewLayerID > 0 : LayerID = NewLayerID : EndIf
        ActiveLAYER.l = DBReadLong( ChannelID )
        Layers( LayerID )\Width = DBReadLong( ChannelID )
        Layers( LayerID )\Height = DBReadLong( ChannelID )
        Layers( LayerID )\TileWIDTH = DBReadLong( ChannelID )
        Layers( LayerID )\TileHEIGHT = DBReadLong( ChannelID )
        Layers( LayerID )\XCycle = DBReadLong( ChannelID )
        Layers( LayerID )\YCycle = DBReadLong( ChannelID )
        Layers( LayerID )\Hide = DBReadLong( ChannelID )
        Layers( LayerID )\XDisplay = DBReadLong( ChannelID )
        Layers( LayerID )\YDisplay = DBReadLong( ChannelID )
        Layers( LayerID )\BitmapToTrace = DBReadLong( ChannelID )
        Layers( LayerID )\XStart = DBReadLong( ChannelID )
        Layers( LayerID )\YStart = DBReadLong( ChannelID )
        Layers( LayerID )\XEnd = DBReadLong( ChannelID )
        Layers( LayerID )\YEnd = DBReadLong( ChannelID )
        Layers( LayerID )\ScrollMODE = DBReadLong( ChannelID )
        Layers( LayerID )\XSpeed = DBReadFloat( ChannelID )
        Layers( LayerID )\YSpeed = DBReadFloat( ChannelID )
        Layers( LayerID )\CameraLOCK  = DBReadLong( ChannelID )
        _HEADER$ = DBReadString( ChannelID )
        If _HEADER$ = "[2DPKLayerData]"
          Layers( LayerID )\MemoryMBC = MBC_DynamicMake( Layers( LayerID )\Width * Layers( LayerID )\Height * 2 )
          DBDeleteMemblock( Layers( LayerID )\MemoryMBC )
          DBReadMemblock( ChannelID, Layers( LayerID )\MemoryMBC )
          Layers( LayerID )\MemoryPTR = DBGetMemblockPtr( Layers( LayerID )\MemoryMBC )
          Layers( LayerID )\MemorySIZE = DBGetMemblockSize( Layers( LayerID )\MemoryMBC )
          Layers( LayerID )\Active = 1
         Else
          LayerID = 0
         EndIf
       Else
        LayerID = 0
       EndIf
     Else
      LayerID = 0
      MessageRequester( "2DPlugKit Error", "The layer you try to override already exist" )
     EndIf
   Else
    LayerID = 0
    MessageRequester( "2DPlugKIT Error", "Layer number is invalid" )
   EndIf  
  ProcedureReturn LayerID
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_CreateLAYERFromFileEx( ChannelID2.l )
  LayerID.l = P2DK_CreateLAYERFromFile( ChannelID2, 0 )
  ProcedureReturn LayerID
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_WriteLayersToFile( ChannelID2.l )
  DBWriteString( ChannelID2, "[2DPKLayersDefinition]" )
  For LLoop = 1 To 16
    If Layers( LLoop )\Active = 1
      P2DK_WriteLAYERToFILE( ChannelID2, LLoop )
     EndIf
   Next LLoop
  DBWriteString( ChannelID2, "[2DPKLayersDefinitionEND]" )
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_CreateLayersFromFile( ChannelID2.l )
  LayersCOUNT.l = 0
  _HEADER$ = DBReadString( ChannelID2 )
  If _HEADER$ = "[2DPKLayersDefinition]"
    Repeat
      NewLayerID.l = P2DK_CreateLAYERFromFile( ChannelID.l, 0 )
      If NewLayerID > 0 : LayersCOUNT = LayersCOUNT + 1 : EndIf
     Until NewLayerID = 0
;    _HEADER$ = DBReadString( ChannelID2 )
;    If _HEADER$ <> "[2DPKLayersDefinitionEND]"
;      MessageRequester( "2DPlugKIT Error", "Abnormal layers definition file nest close" )
;     EndIf
   Else
    MessageRequester( "2DPlugKIT Error", "File does not contain layer definition" )
   EndIf
  ProcedureReturn LayersCOUNT
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetLayerScrollMode( LayerID.l, ScrollMODE.l )
  If IsLayerOk( LayerID ) = 1 And PlugINITIALIZED = 1
    Layers( LayerID )\ScrollMODE = ScrollMODE
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetLayerScrollXY( LayerID.l, XSCR.l, YSCR.l )
  If IsLayerOk( LayerID ) = 1 And PlugINITIALIZED = 1
    Layers( LayerID )\XSpeed = PeekF( @XSCR )
    Layers( LayerID )\YSpeed = PeekF( @YSCR )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetLayerScrollX( LayerID.l, XSCR.l )
  If IsLayerOk( LayerID ) = 1 And PlugINITIALIZED = 1
    Layers( LayerID )\XSpeed = PeekF( @XSCR )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetLayerScrollY( LayerID.l, YSCR.l )
  If IsLayerOk( LayerID ) = 1 And PlugINITIALIZED = 1
    Layers( LayerID )\YSpeed = PeekF( @YSCR )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetLayerScrollMODE( LayerID.l )
  If IsLayerOk( LayerID ) = 1
    Retour.l = Layers( LayerID )\ScrollMODE
   Else
    Retour = 0
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetLayerXSpeed( LayerID.l )
  If IsLayerOk( LayerID ) = 1
    PokeF( @Retour.l, Layers( LayerId )\XSpeed )
   Else
    PokeF( @Retour, 0.0 )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetLayerYSpeed( LayerID.l )
  If IsLayerOk( LayerID ) = 1
    PokeF( @Retour.l, Layers( LayerId )\YSpeed )
   Else
    PokeF( @Retour, 0.0 )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetLayerCameraMODE( LayerID.l )
  If IsLayerOk( LayerID ) = 1
    Retour.l = Layers( LayerID )\CameraLOCK
   Else
    Retour = 0
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetLayerCameraMODE( LayerID.l, CameraMODE.l )
  If IsLayerOk( LayerID ) = 1 And PlugINITIALIZED = 1
    Layers( LayerID )\CameraLOCK = CameraMODE
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetGameLayer( LayerID.l )
  If IsLayerOk( LayerID ) = 1 And PlugINITIALIZED = 1
    GameLayer = LayerID
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetGameLayer()
  Retour.l = GameLayer
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_SetMainLayerPOSITION( XPos.l, YPos.l )
  XPosF.f = PeekF( @XPos ) : YPosF.f = PeekF( @YPos )
  If GameLayer > 0 And PlugINITIALIZED = 1
    If Layers( GameLayer )\Active = 1
      For LLoop = 1 To 16
        If Layers( LLoop )\Active = 1
          If LLoop = GameLayer
            Layers( LLoop )\XDisplay = XPosF
            Layers( LLoop )\YDisplay = YPosF
           Else
            Select Layers( LLoop )\ScrollMODE
              Case 0
                Layers( LLoop )\XDisplay = 0.0
                Layers( LLoop )\YDisplay = 0.0
              Case 1
                Layers( LLoop )\XDisplay = XPosF * Layers( LLoop )\XSpeed
                Layers( LLoop )\YDisplay = YPosF * Layers( LLoop )\YSpeed
              Case 2
                Layers( LLoop )\XDisplay = Layers( LLoop )\XDisplay + Layers( LLoop )\XSpeed
                Layers( LLoop )\YDisplay = Layers( LLoop )\YDisplay + Layers( LLoop )\YSpeed
             EndSelect            
           EndIf
         EndIf
       Next LLoop
     Else
      MessageRequester( "2DPlugKIT Error", "Layer does not exist" )
     EndIf
   Else
    MessageRequester( "2DPlugKIT Error", "Layer number is invalid" )
   EndIf
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL P2DK_TraceAllLayers()
  For LLoop = 1 To 16
    If Layers( LLoop )\Active = 1 : P2DK_TraceLayerEx( LLoop ) : EndIf
   Next LLoop
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetLayerAreaLEFT( LayerID.l )
  If IsLayerOk( LayerID ) = 1
    Retour.l = Layers( LayerID )\XStart
   Else
    Retour = 0
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetLayerAreaTOP( LayerID.l )
  If IsLayerOk( LayerID ) = 1
    Retour.l = Layers( LayerID )\YStart
   Else
    Retour = 0
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetLayerAreaRIGHT( LayerID.l )
  If IsLayerOk( LayerID ) = 1
    Retour.l = Layers( LayerID )\XEnd
   Else
    Retour = 0
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;
ProcedureCDLL.l P2DK_GetLayerAreaBOTTOM( LayerID.l )
  If IsLayerOk( LayerID ) = 1
    Retour.l = Layers( LayerID )\YEnd
   Else
    Retour = 0
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
;**************************************************************************************************************
;

; IDE Options = PureBasic 4.10 Beta 2 (Windows - x86)
; CursorPosition = 80
; FirstLine = 78
; Folding = ---------