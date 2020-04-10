; DarkBasic Professional RC2PBIncludes Ver 1. File - COMMANDS WRAPPING
; By Frederic Cordier - 07.02.13
;
; *********************************************************************
Procedure.l CMR_Init()
  Retour.l = CallCFunctionFast( *DB_CameraExtends\CMR_Init )
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure CMR_Clear()
  CallCFunctionFast( *DB_CameraExtends\CMR_Clear )
 EndProcedure
;
; *********************************************************************
Procedure.l CMR_Count()
  Retour.l = CallCFunctionFast( *DB_CameraExtends\CMR_Count )
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l CMR_Delete( CameraNumber.l )
  If GetDLLInitialized( #CameraExtends ) = 1
    Retour.l = CallCFunctionFast( *DB_CameraExtends\CMR_Delete, CameraNumber )
   Else
    Retour = 0
    DBDeleteCamera( CameraNumber )
   Endif
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l CMR_DynamicMake()
  If GetDLLInitialized( #CameraExtends ) = 1
    Retour.l = CallCFunctionFast( *DB_CameraExtends\CMR_DynamicMake )
   Else
    Retour = DBE_GetFreeCamera()
    DBMakeCamera( Retour )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;
; *********************************************************************
Procedure.l CMR_DynamicClone( SourceCAM.l )
  If GetDLLInitialized( #CameraExtends ) = 1
    Retour.l = CallCFunctionFast( *DB_CameraExtends\CMR_DynamicClone, SourceCAM )
   Else
    Retour = DBE_GetFreeCamera()
    DBMakeCamera( Retour )
    DBPositionCamera1( Retour, DBGetCameraXPosition1( SourceCAM ), DBGetCameraYPosition1( SourceCAM ), DBGetCameraZPosition1( SourceCAM ) )
    DBSetCameraRotation1( Retour, DBGetXAngle1( SourceCAM ), DBGetYAngle1( SourceCAM ), DBGetZAngle1( SourceCAM ) )
   EndIf
  ProcedureReturn Retour
 EndProcedure
;

; IDE Options = PureBasic 4.10 Beta 2 (Windows - x86)
; CursorPosition = 27
; FirstLine = 12
; Folding = --