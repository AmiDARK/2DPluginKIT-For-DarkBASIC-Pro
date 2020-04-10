;
;**************************************************************************************************************
;
; PurePLUGIN - DarkBASIC Professional eXtra functions SET #2
;
;**************************************************************************************************************
; This include file contains functions to simulate eXtends dynamic media handlers when not available.
;
;**************************************************************************************************************
;
Procedure.l DBE_GetFreeObject()
  MediaID.l = 0
  Repeat
    MediaID = MediaID + 1
   Until DBGetObjectExist( MediaID ) = 0
  ProcedureReturn MediaID
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l DBE_GetFreeBitmep()
  MediaID.l = 0
  Repeat
    MediaID = MediaID + 1
   Until DBBitmapExist( MediaID ) = 0
  ProcedureReturn MediaID
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l DBE_GetFreeCamera()
  MediaID.l = 0
  Repeat
    MediaID = MediaID + 1
   Until DBGetCameraExist( MediaID ) = 0
  ProcedureReturn MediaID
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l DBE_GetFreeEffect()
  MediaID.l = 0
  Repeat
    MediaID = MediaID + 1
   Until DBGetEffectExist( MediaID ) = 0
  ProcedureReturn MediaID
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l DBE_GetFreeFile()
  MediaID.l = 0
  Repeat
    MediaID = MediaID + 1
   Until DBFileOpen( MediaID ) = 0
  ProcedureReturn MediaID
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l DBE_GetFreeImage()
  MediaID.l = 0
  Repeat
    MediaID = MediaID + 1
   Until DBGetImageExist( MediaID ) = 0
  ProcedureReturn MediaID
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l DBE_GetFreeMatrix()
  MediaID.l = 0
  Repeat
    MediaID = MediaID + 1
   Until DBGetMatrixExist( MediaID ) = 0
  ProcedureReturn MediaID
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l DBE_GetFreeMemblock()
  MediaID.l = 0
  Repeat
    MediaID = MediaID + 1
   Until DBMemblockExist( MediaID ) = 0
  ProcedureReturn MediaID
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l DBE_GetFreeMesh()
  MediaID.l = 0
  Repeat
    MediaID = MediaID + 1
   Until DBGetMeshExist( MediaID ) = 0
  ProcedureReturn MediaID
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l DBE_GetFreeMusic()
  MediaID.l = 0
  Repeat
    MediaID = MediaID + 1
   Until DBGetMusicExist( MediaID ) = 0
  ProcedureReturn MediaID
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l DBE_GetFreeSound()
  MediaID.l = 0
  Repeat
    MediaID = MediaID + 1
   Until DBGetSoundExist( MediaID ) = 0
  ProcedureReturn MediaID
 EndProcedure
;
;**************************************************************************************************************
;
Procedure.l DBE_GetFreeSprite()
  MediaID.l = 0
  Repeat
    MediaID = MediaID + 1
   Until DBGetSpriteExist( MediaID ) = 0
  ProcedureReturn MediaID
 EndProcedure
;
;**************************************************************************************************************
;

; IDE Options = PureBasic 4.10 Beta 2 (Windows - x86)
; CursorPosition = 3
; Folding = ---