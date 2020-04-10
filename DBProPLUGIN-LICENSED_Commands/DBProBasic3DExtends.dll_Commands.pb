; DarkBasic Professional RC2PBIncludes Ver 1. File - COMMANDS WRAPPING
; By Frederic Cordier - 07.02.13
;
; *********************************************************************
Procedure.l Basic3D_Init()
  Retour.l = CallCFunctionFast( *DB_Basic3DExtends\Basic3D_Init )
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l B3D_DynamicLoad( FileName.s )
  If GetDLLInitialized( #Basic3DExtends ) = 1
    CallCFunctionFast( *GlobPtr\CreateDeleteString, @FileNamePTR.l, Len( FileName ) + 1 ) ; CreateString
    PokeS( FileNamePTR, FileName )
    If TextureQuality = 0
      Retour.l = CallCFunctionFast( *DB_Basic3DExtends\B3D_DynamicLoad, FileNamePTR )
     Else
      Retour.l = CallCFunctionFast( *DB_Basic3DExtends\B3D_DynamicLoadEx2, FileNamePTR, 1, TextureQuality )
     EndIf
   Else
    Retour.l = DBE_GetFreeObject()
    If TextureQuality = 0
      DBLoadObject( FileName, Retour )
     Else
      DBLoadObject2( FileName, Retour, 1, TextureQuality )
     EndIf
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l B3D_Delete( ObjectNumber.l )
  If GetDLLInitialized( #Basic3DExtends ) = 1
    Retour.l = CallCFunctionFast( *DB_Basic3DExtends\B3D_Delete, ObjectNumber )
   Else
    Retour = 0
    DBDeleteObject( ObjectNumber)
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l B3D_DynamicMake( Meshe.l, Texture.l )
  If GetDLLInitialized( #Basic3DExtends ) = 1
    Retour.l = CallCFunctionFast( *DB_Basic3DExtends\B3D_DynamicMake, Meshe, Texture )
   Else
    Retour.l = DBE_GetFreeObject()
    DBMakeObject( Retour, Meshe, Texture )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l B3D_DynamicMakeBox( Width.f, Height.f, Depth.f )
  If GetDLLInitialized( #Basic3DExtends ) = 1
    Retour.l = CallCFunctionFast( *DB_Basic3DExtends\B3D_DynamicMakeBox, Width, Height, Depth )
   Else
    Retour.l = DBE_GetFreeObject()
    DBMakeObjectBox( Retour, Width, Height, Depth )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l B3D_DynamicMakeCone( Size.f )
  If GetDLLInitialized( #Basic3DExtends ) = 1
    Retour.l = CallCFunctionFast( *DB_Basic3DExtends\B3D_DynamicMakeCone, Size )
   Else
    Retour.l = DBE_GetFreeObject()
    DBMakeObjectCone( Retour, Size )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l B3D_DynamicMakeCube( Size.f )
  If GetDLLInitialized( #Basic3DExtends ) = 1
    Retour.l = CallCFunctionFast( *DB_Basic3DExtends\B3D_DynamicMakeCube, Size )
   Else
    Retour.l = DBE_GetFreeObject()
    DBMakeObjectCube( Retour, Size )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l B3D_DynamicMakeCylinder( Size.f )
  If GetDLLInitialized( #Basic3DExtends ) = 1
    Retour.l = CallCFunctionFast( *DB_Basic3DExtends\B3D_DynamicMakeCylinder, Size )
   Else
    Retour.l = DBE_GetFreeObject()
    DBMakeObjectCylinder( Retour, Size )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l B3D_DynamicMakeSphere( Size.f )
  If GetDLLInitialized( #Basic3DExtends ) = 1
    Retour.l = CallCFunctionFast( *DB_Basic3DExtends\B3D_DynamicMakeSphere, Size )
   Else
    Retour.l = DBE_GetFreeObject()
    DBMakeObjectSphere( Retour, Size )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l B3D_DynamicMakeTriangle( X1.f, Y1.f, Z1.f, X2.f, Y2.f, Z2.f, X3.f, Y3.f, Z3.f )
  If GetDLLInitialized( #Basic3DExtends ) = 1
    Retour.l = CallCFunctionFast( *DB_Basic3DExtends\B3D_DynamicMakeTriangle, X1, Y1, Z1, X2, Y2, Z2, X3, Y3, Z3 )
   Else
    Retour.l = DBE_GetFreeObject()
    DBMakeObjectTriangle( Retour, X1, Y1, Z1, X2, Y2, Z2, X3, Y3, Z3 )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l B3D_DynamicMakePlain( XSize.f, ZSize.f )
  If GetDLLInitialized( #Basic3DExtends ) = 1
    Retour.l = CallCFunctionFast( *DB_Basic3DExtends\B3D_DynamicMakePlain, XSize, ZSize )
   Else
    Retour.l = DBE_GetFreeObject()
    DBMakeObjectPlane( Retour, XSize, ZSize )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l B3D_MakeFromLimb( ObjectNumber.l, LimbNumber.l )
  If GetDLLInitialized( #Basic3DExtends ) = 1
    Retour.l = CallCFunctionFast( *DB_Basic3DExtends\B3D_MakeFromLimb, ObjectNumber, LimbNumber )
   Else
    Retour.l = DBE_GetFreeObject()
    DBMakeObjectObjectFromLimb( Retour, ObjectNumber, LimbNumber )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l B3D_DynamicClone( SourceObject.l )
  If GetDLLInitialized( #Basic3DExtends ) = 1
    Retour.l = CallCFunctionFast( *DB_Basic3DExtends\B3D_DynamicClone, SourceObject )
   Else
    Retour.l = DBE_GetFreeObject()
    DBCloneObject( Retour, SourceObject )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l B3D_DynamicInstance( SourceObject.l )
  If GetDLLInitialized( #Basic3DExtends ) = 1
    Retour.l = CallCFunctionFast( *DB_Basic3DExtends\B3D_DynamicInstance, SourceObject )
   Else
    Retour.l = DBE_GetFreeObject()
    DBInstanceObject( Retour, SourceObject )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure B3D_AddBillBoardToList( ObjectID.l )
  CallCFunctionFast( *DB_Basic3DExtends\B3D_AddBillBoardToList, ObjectID )
 EndProcedure
;
; *********************************************************************
Procedure B3D_RemoveBillBoardFromList( ObjectID.l )
  CallCFunctionFast( *DB_Basic3DExtends\B3D_RemoveBillBoardFromList, ObjectID )
 EndProcedure
;
; *********************************************************************
Procedure B3D_DisableYRot( ObjectID.l )
  CallCFunctionFast( *DB_Basic3DExtends\B3D_DisableYRot, ObjectID )
 EndProcedure
;
; *********************************************************************
Procedure B3D_EnableYRot( ObjectID.l )
  CallCFunctionFast( *DB_Basic3DExtends\B3D_EnableYRot, ObjectID )
 EndProcedure
;
; *********************************************************************
Procedure B3D_RefreshBillBoards()
  CallCFunctionFast( *DB_Basic3DExtends\B3D_RefreshBillBoards )
 EndProcedure
;
; *********************************************************************
Procedure.f B3D_GetPointsDistance( XPoint1.f, YPoint1.f, ZPoint1.f, XPoint2.f, YPoint2.f, ZPoint2.f )
  Retour.l = CallCFunctionFast( *DB_Basic3DExtends\B3D_GetPointsDistance, XPoint1, YPoint1, ZPoint1, XPoint2, YPoint2, ZPoint2 )
  RetourFLT.f = PeekF( @Retour )
  ProcedureReturn RetourFLT
 EndProcedure
;
; *********************************************************************
Procedure.f B3D_GetDistanceFromCamera( ObjectNumber.l )
  Retour.l = CallCFunctionFast( *DB_Basic3DExtends\B3D_GetDistanceFromCamera, ObjectNumber )
  RetourFLT.f = PeekF( @Retour )
  ProcedureReturn RetourFLT
 EndProcedure
;
; *********************************************************************
Procedure.f B3D_GetObjectsDistance( Object1.l, Object2.l )
  Retour.l = CallCFunctionFast( *DB_Basic3DExtends\B3D_GetObjectsDistance, Object1, Object2 )
  RetourFLT.f = PeekF( @Retour )
  ProcedureReturn RetourFLT
 EndProcedure
;
; *********************************************************************
Procedure.f B3D_GetPointDistancetoObject( Object.l, XPoint.f, YPoint.f, ZPoint.f )
  Retour.l = CallCFunctionFast( *DB_Basic3DExtends\B3D_GetPointDistancetoObject, Object, XPoint, YPoint, ZPoint )
  RetourFLT.f = PeekF( @Retour )
  ProcedureReturn RetourFLT
 EndProcedure
;
; *********************************************************************
Procedure.f B3D_GetPointDistancetoCamera( XPoint.f, YPoint.f, ZPoint.f )
  Retour.l = CallCFunctionFast( *DB_Basic3DExtends\B3D_GetPointDistancetoCamera, XPoint, YPoint, ZPoint )
  RetourFLT.f = PeekF( @Retour )
  ProcedureReturn RetourFLT
 EndProcedure
;
; *********************************************************************
Procedure B3D_SetBBCameraControl( CameraNumber.l )
  CallCFunctionFast( *DB_Basic3DExtends\B3D_SetBBCameraControl, CameraNumber )
 EndProcedure
;
; *********************************************************************
Procedure.l B3D_DynamicLoad1( FileName.s, Flag.l )
  If GetDLLInitialized( #Basic3DExtends ) = 1
    CallCFunctionFast( *GlobPtr\CreateDeleteString, @FileNamePTR.l, Len( FileName ) + 1 ) ; CreateString
    PokeS( FileNamePTR, FileName )
    If TextureQuality = 0
      Retour.l = CallCFunctionFast( *DB_Basic3DExtends\B3D_DynamicLoadEx, FileNamePTR, Flag )
     Else
      Retour.l = CallCFunctionFast( *DB_Basic3DExtends\B3D_DynamicLoadEx2, FileNamePTR, Flag, TextureQuality )
     EndIf
   Else
    Retour.l = DBE_GetFreeObject()
    If TextureQuality = 0
      DBLoadObject1( FileName, Retour, Flag )
     Else
      DBLoadObject2( FileName, Retour, Flag, TextureQuality )
     EndIf
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure B3D_ClearBillBoardList()
  CallCFunctionFast( *DB_Basic3DExtends\B3D_ClearBillBoardList )
 EndProcedure
;
; *********************************************************************
Procedure.l B3D_GetBillBoardCount()
  Retour.l = CallCFunctionFast( *DB_Basic3DExtends\B3D_GetBillBoardCount )
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l B3D_DynamicLoadEx2( FileName.s, Param2.l, Param3.l )
  If GetDLLInitialized( #Basic3DExtends ) = 1
    CallCFunctionFast( *GlobPtr\CreateDeleteString, @FileNamePTR.l, Len( FileName ) + 1 ) ; CreateString
    PokeS( FileNamePTR, FileName )
    Retour.l = CallCFunctionFast( *DB_Basic3DExtends\B3D_DynamicLoadEx2, FileNamePTR, Param2, Param3 )
   Else
    Retour.l = DBE_GetFreeObject()
    DBLoadObject2( FileName, Retour, Param2, Param3 )
   EndIf
  ProcedureReturn Retour
 EndProcedure

; IDE Options = PureBasic 4.10 Beta 2 (Windows - x86)
; CursorPosition = 4
; Folding = -----