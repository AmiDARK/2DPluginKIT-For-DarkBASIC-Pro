; DarkBasic Professional RC2PBIncludes Ver 1. File - COMMANDS WRAPPING
; By Frederic Cordier - 07.02.13
;
; *********************************************************************
Procedure.l Mesh3D_Init()
  Retour.l = CallCFunctionFast( *DB_Mesh3DExtends\Mesh3D_Init )
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l M3D_DynamicLoad( FileName.s )
  If GetDLLInitialized( #Mesh3DExtends ) = 1
    CallCFunctionFast( *GlobPtr\CreateDeleteString, @FileNamePTR.l, Len( FileName ) + 1 ) ; CreateString
    PokeS( FileNamePTR, FileName )
    Retour.l = CallCFunctionFast( *DB_Mesh3DExtends\M3D_DynamicLoad, FileNamePTR )
   Else
    Retour = DBE_GetFreeMesh()
    DBLoadMesh( FileName, Retour )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l M3D_Delete( MeshNumber.l )
  If GetDLLInitialized( #Mesh3DExtends ) = 1
    Retour.l = CallCFunctionFast( *DB_Mesh3DExtends\M3D_Delete, MeshNumber )
   Else
    Retour = 0
    DBDeleteMesh( MeshNumber )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l M3D_DynamicMakeFromObject( SourceObject.l )
  If GetDLLInitialized( #Mesh3DExtends ) = 1
    Retour.l = CallCFunctionFast( *DB_Mesh3DExtends\M3D_DynamicMakeFromObject, SourceObject )
   Else
    Retour = DBE_GetFreeMesh()
    DBMakeMeshFromObject( Retour, SourceObject )
   EndIf
  ProcedureReturn Retour
 EndProcedure
; 
; *********************************************************************
Procedure.l M3D_DynamicMakeFromMemblock( SourceMemblock.l )
  If GetDLLInitialized( #Mesh3DExtends ) = 1
    Retour.l = CallCFunctionFast( *DB_Mesh3DExtends\M3D_DynamicMakeFromMemblock, SourceMemblock )
   Else
    Retour = DBE_GetFreeMesh()
    DBCreateMeshFromMemblock( Retour, SourceMemblock )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;

; IDE Options = PureBasic 4.10 Beta 2 (Windows - x86)
; CursorPosition = 50
; FirstLine = 10
; Folding = -