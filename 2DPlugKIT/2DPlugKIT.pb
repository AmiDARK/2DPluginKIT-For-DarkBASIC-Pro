;
; ***********************************
; *                                 *
; * PurePLUGIN TPC Plug-In Ver 2.00 *
; *                                 *
; ***********************************
; ADDITIONAL NOTES: if you use the PureBASIC TPC tutorial that was released on the Thegamecreators newsletter:
; http://www.thegamecreators.com/data/newsletter/newsletter_issue_22.html#17
; Consider that the informations available here are more recent and must be used instead of old ones in the tutorial.
; Especially to String input/output.
; Ver 1.1 Addons: PurePLUGINVersion checking.
Structure PurePLUGINStructure
  Version.l : Revision.l : DebugMODE.l
 EndStructure
Global PurePLUGIN.PurePLUGINStructure
Global Dim TempCODE( 32 )
; Define your UserNAME and UserCODE here. They were provided with the PurePLUGIN registration.
; If you set them incorrectly, your plugin may not work.
; We advice you to try to crypt your UserNAME and UserCODE in your DLL and uncrypt them only in memory
; for security reasons. If you simply put them here without crypting them, they can be seen by someone editing the DLL with an HEX editor.
  Global UserNAME.s = "rtjopaezrEZRFTtryji"
  Global UserCODE.s = "XUMTTAMdRGeXGYbaaLJXaMXTH"
; First of all, we include the constants that can be used to know which DarkBASIC Professional DLL's
; Were included by the compiler in the .EXE
  IncludeFile "..\DBPro_Constants.pb"
; Now we include some commands I've done and that can sometimes be useful.
  IncludeFile "..\AdvancedFunctions.pb" ; Pour contenir des fonctions spécifiques au système PurePLUGIN.
; we firstly included all structures needed to use DarkBASIC Professional's DLL set.
  IncludeFile "..\DBPro_Structures.pb"
  IncludeFile "..\DBPro_Structures_Init.pb" ; Setup for main, Init for sub.
; Now we inlude DarkBASIC Professional command set.
  IncludeFile "..\DBPro_Init.pb" ; Pour l'initialisation secondaire pour les DLLs du pack.
; We now include the command that can be used directly from your TPC DLL.
; You can put in comments the DLL that are not used in your TPC Plugin to make your TPC Plugin be smaller.
  IncludeFile "..\DBPro_Commands\DBProAnimationDebug.dll_Commands.pb"
  IncludeFile "..\DBPro_Commands\DBProBasic2DDebug.dll_Commands.pb"
  IncludeFile "..\DBPro_Commands\DBProBasic3DDebug.dll_Commands.pb"
  IncludeFile "..\DBPro_Commands\DBProBitmapDebug.dll_Commands.pb"
  IncludeFile "..\DBPro_Commands\DBproCameraDebug.dll_Commands.pb"
  IncludeFile "..\DBPro_Commands\DBProCore.dll_Commands.pb"
  IncludeFile "..\DBPro_Commands\DBProCSGDebug.dll_Commands.pb"
  IncludeFile "..\DBPro_Commands\DBProFileDebug.dll_Commands.pb"
  IncludeFile "..\DBPro_Commands\DBProFTPDebug.dll_Commands.pb"
  IncludeFile "..\DBPro_Commands\DBProImageDebug.dll_Commands.pb"
  IncludeFile "..\DBPro_Commands\DBProInputDebug.dll_Commands.pb"
  IncludeFile "..\DBPro_Commands\DBProLightDebug.dll_Commands.pb"
  IncludeFile "..\DBPro_Commands\DBProLODTerrainDebug.dll_Commands.pb"
  IncludeFile "..\DBPro_Commands\DBProMatrixDebug.dll_Commands.pb"
  IncludeFile "..\DBPro_Commands\DBProMemblocksDebug.dll_Commands.pb"
  IncludeFile "..\DBPro_Commands\DBProMultiPlayerDebug.dll_Commands.pb"
  IncludeFile "..\DBPro_Commands\DBProMusicDebug.dll_Commands.pb"
  IncludeFile "..\DBPro_Commands\DBProParticlesDebug.dll_Commands.pb"
  IncludeFile "..\DBPro_Commands\DBProSetupDebug.dll_Commands.pb"
  IncludeFile "..\DBPro_Commands\DBProSoundDebug.dll_Commands.pb"
  IncludeFile "..\DBPro_Commands\DBProSpritesDebug.dll_Commands.pb"
  IncludeFile "..\DBPro_Commands\DBProSystemDebug.dll_Commands.pb"
  IncludeFile "..\DBPro_Commands\DBProTextDebug.dll_Commands.pb"
  IncludeFile "..\DBPro_Commands\DBProVectorsDebug.dll_Commands.pb"
  IncludeFile "..\DBPro_Commands\DBProWorld3DDebug.dll_Commands.pb"
  IncludeFile "..\DBProPLUGIN-LICENSED_Commands\AdvancedTerrain.dll_Commands.pb"
  IncludeFile "..\DBProPLUGIN-LICENSED_Commands\DBProGameFX.dll_Commands.pb"
  IncludeFile "..\DBProPLUGIN-LICENSED_Commands\EnhancementsOV.dll_Commands.pb"
  IncludeFile "..\DBProPLUGIN-USER_Commands\DBProMultiplayerPlusDebug.dll_Commands.pb"
  IncludeFile "..\DBProPLUGIN-USER_Commands\DBProODEDebug.dll_Commands.pb"
  IncludeFile "..\DBProPLUGIN-USER_Commands\ShaderData.dll_Commands.pb"
; PurePLUGIN Ver 1.1 Upgrades support :
  IncludeFile "..\DBProPLUGIN-LICENSED_Commands\DarkPHYSICS.dll_Commands.pb"
; Ver 1.1 Addons: eXtends 1.3 version needed.
  IncludeFile "..\DBPro_Extras\DBProExtraFunctions2-eXtends.pb"
  IncludeFile "..\DBProPLUGIN-LICENSED_Commands\DBProBasic2DExtends.dll_Commands.pb"
  IncludeFile "..\DBProPLUGIN-LICENSED_Commands\DBProBasic3DExtends.dll_Commands.pb"
  IncludeFile "..\DBProPLUGIN-LICENSED_Commands\DBProBitmapExtends.dll_Commands.pb"
  IncludeFile "..\DBProPLUGIN-LICENSED_Commands\DBProCameraExtends.dll_Commands.pb"
  IncludeFile "..\DBProPLUGIN-LICENSED_Commands\DBProEffects3DExtends.dll_Commands.pb"
  IncludeFile "..\DBProPLUGIN-LICENSED_Commands\DBProExtends.dll_Commands.pb"
  IncludeFile "..\DBProPLUGIN-LICENSED_Commands\DBProFileExtends.dll_Commands.pb"
  IncludeFile "..\DBProPLUGIN-LICENSED_Commands\DBProImageExtends.dll_Commands.pb"
  IncludeFile "..\DBProPLUGIN-LICENSED_Commands\DBProLight3DExtends.dll_Commands.pb"
  IncludeFile "..\DBProPLUGIN-LICENSED_Commands\DBProMatrixExtends.dll_Commands.pb"
  IncludeFile "..\DBProPLUGIN-LICENSED_Commands\DBProMemblocksExtends.dll_Commands.pb"
  IncludeFile "..\DBProPLUGIN-LICENSED_Commands\DBProMesh3DExtends.dll_Commands.pb"
  IncludeFile "..\DBProPLUGIN-LICENSED_Commands\DBProMusicExtends.dll_Commands.pb"
  IncludeFile "..\DBProPLUGIN-LICENSED_Commands\DBProParticles3DExtends.dll_Commands.pb"
  IncludeFile "..\DBProPLUGIN-LICENSED_Commands\DBProRTSkyboxExtends.dll_Commands.pb"
  IncludeFile "..\DBProPLUGIN-LICENSED_Commands\DBProSoundExtends.dll_Commands.pb"
  IncludeFile "..\DBProPLUGIN-LICENSED_Commands\DBProSpriteExtends.dll_Commands.pb"
  IncludeFile "..\DBProPLUGIN-LICENSED_Commands\DBProTextExtends.dll_Commands.pb"
  IncludeFile "..\DBProPLUGIN-LICENSED_Commands\DBProVector2Extends.dll_Commands.pb"
  IncludeFile "..\DBProPLUGIN-LICENSED_Commands\DBProVector3Extends.dll_Commands.pb"
  IncludeFile "..\DBProPLUGIN-LICENSED_Commands\DBProVector4Extends.dll_Commands.pb"
; Ver 1.1 Addons: DKSHop plugin:
  IncludeFile "..\DBProPLUGIN-USER_Commands\DKSHOP.dll_Commands.pb"
  IncludeFile "..\DBProPLUGIN-USER_Commands\DKAVM.dll_Commands.pb"
; Ver 1.2 Addons: Sparky's Collision DLL:
  IncludeFile "..\DBProPLUGIN-USER_Commands\SC_Collision.dll_Commands.pb"
  IncludeFile "..\DBProPLUGIN-USER_Commands\EZRotateBasic_Commands.pb"
  IncludeFile "..\DBProPLUGIN-USER_Commands\AdvancedSPRITES.dll_Commands.pb"
;
  IncludeFile "..\DynamicListHandlerV2[Multi].pb" ; Gestion de listes dynamiques pour les médias
;      Lists ID : 01 = Virtual Light
;      Lists ID : 02 = Blitter Objects [Fake Sprites]
;      Lists ID : 03 = 2D Particles.
;
Global PPInitialized.l ; Global variable to store 1 if darkBASIC Professional was successfully
Global PlugINITIALIZED.l
IncludeFile "2DPlugKIT_Definitions.pb" ; Contain all structures needed for the plugin to work.
IncludeFile "DBProExtraFunctions.pb"   ; Contain setup and procedure for special functions.
; *************************************************************************************** Start()
; The main initialisation. Is called internally by DarkBASIC Professional when initializing the .EXE
; Do not forget to follow instructions on how to rename AConstructor00YAXXZ to ?Constructor@@YAXXZ
; Otherwise DarkBASIC Professional will not be able to initialize your plugin and you'll get a crash.
ProcedureCDLL AConstructor00YAXXZ()
  If *GlobPtr = 0 : InitialiseCorePtr() : EndIf
  If PPInitialized = 0
    PPInitialized = InitDLLBase()
   EndIf
  GetPPVersion()
  Setup\DefaultWIDTH = 16
  Setup\DefaultHEIGHT = 16
  Setup\DefaultTransparency = 1
  SETUP_ExtraFunctions()                         ; Support for GetBitmapData/GetImageData, etc ...
 EndProcedure
; *************************************************************************************** Quit()
; You can do the same thing than with Contructor if you need to remove stuffs from memory when the program
; exit. You'll have to rename the ADestructor00YAXXZ to ?Destructor@@YAXXZ with a tool like XVI.
; Follow instructions on how to rename constructor procedure to make changes with destructor too.
ProcedureCDLL ADestructor00YAXXZ()
  Null.l = 0
 EndProcedure
; *************************************************************************************** Get Dependencies()
ProcedureCDLL.l AGetNumDependencies00YAHXZ()
  ProcedureReturn 6
 EndProcedure
; *************************************************************************************** Return DLL names()
ProcedureCDLL.s AGetDependencyID00YAPBDH0Z( NumID.l )
  Select NumID
    Case 0 : NewPTR.s = PeekS( ?DEP_PurePLUGIN )   ; Include PurePLUGIN system for SETUP the Plugin.
    Case 1 : NewPTR = PeekS( ?DEP_DBPRO01 )      ; Include DarkBASIC Professional IMAGES
    Case 2 : NewPTR = PeekS( ?DEP_DBPRO02 )      ; Include DarkBASIC Professional SPRITES
    Case 3 : NewPTR = PeekS( ?DEP_DBPRO03 )      ; Include DarkBASIC Professional MEMBLOCKS
    Case 4 : NewPTR = PeekS( ?DEP_DBPRO04 )      ; Include DarkBASIC Professional FILE
    Case 5 : NewPTR = PeekS( ?DEP_DBPRO05 )      ; Include DarkBASIC Professional BITMAP
;    Case 6 : NewPTR = PeekS( ?DEP_EXTENDS )      ; Include EXTENDS system for SETUP the Plugin's medias.
;    Case 7 : NewPTR = PeekS( ?DEP_EXTENDS01 )    ; Include eXtends : Images
;    Case 8 : NewPTR = PeekS( ?DEP_EXTENDS02 )    ; Include eXtends : Sprites
;    Case 9 : NewPTR = PeekS( ?DEP_EXTENDS03 )    ; Include eXtends : Memblocks
;    Case 10 : NewPTR.s = PeekS( ?DEP_POWERSPRITES ) ; Include eXtends : Memblocks
    Default : NewPTR = ""
   EndSelect
  ProcedureReturn NewPTR
 EndProcedure
; *************************************************************************************** Quit()
;
Procedure CHECKFORSERIAL( User.l, Code.l )
  If User <> 0
    UserN.s = PeekS( User )
;    CallCFunctionFast( *GlobPtr\CreateDeleteString, User, 0 ) ; Free memory used by the original text.
   EndIf
  If Code <> 0
    UserCode.s = PeekS( Code )
;    CallCFunctionFast( *GlobPtr\CreateDeleteString, Code, 0 ) ; Free memory used by the original text.
   EndIf
  ; Maintenant, on procède au calcul de l'activation
  ; PASSE 1 : On ajoute le nom d'utilisateur au code ( A à Z = 0 à 25 )
  If Len( UserN ) > 0 And Len( UserCode ) > 0
    RegUSER$ = "" ; On réinitialise le nom d'utilisateur.
    For XLoop.l =  1 To Len( UserN ) Step 1
      If Mid( UserN, XLoop, 1 ) <> " " : RegUSER$ = RegUSER$ + Mid( UserN, XLoop, 1 ) : EndIf
     Next XLoop
    UserNAME$ = UCase( Left( RegUSER$ + RegUSER$ + RegUSER$ + RegUSER$ + RegUSER$ ,  25 ) )
    For XLoop = 1 To 25
      VALUE.l = Asc( Mid( UserNAME$, XLoop, 1 ) ) - Asc( "A" )
      TempCODE( XLoop ) = VALUE
     Next XLoop
    ; PASSE 1 : Le code obtenu est compris entre 0 et 25
    ; PASSE 2 : On ajoute la séquence de nombre pré-définis.
    Restore REGSequency
    For XLoop = 1 To 25
      Read VALUE
      TempCODE( XLoop ) = TempCODE( XLoop ) + VALUE
     Next XLoop
    ; PASSE 3 : Le code obtenu est compris entre 0 et 35
    ; PASSE 4 : On crée le code d'enregistrement final
    FinalSERIAL$ = ""
    For XLoop = 1 To 25
      If TempCODE( XLoop ) < 26
    	  VALUE = TempCODE( XLoop )
        FinalSERIAL$ = FinalSERIAL$ + Chr( VALUE + Asc( "A" ) )
       Else
    	  VALUE = TempCODE( XLoop ) - 26
        FinalSERIAL$ = FinalSERIAL$ + Chr( VALUE + Asc( "a" ) )
       EndIf
     Next XLoop
    If FinalSERIAL$ = UserCode
      PlugINITIALIZED = 1
     Else
      PlugINITIALIZED = 0
     EndIf
   Else
    PlugINITIALIZED = 0
   EndIf
  If PlugINITIALIZED = 0
    MessageRequester( "2DPlugKIT Activation - Warning", "Your plugin activation is incorrect" )
    If OpenLibrary( 3 , "DBProCore.dll" ) 
      BreakProgram.l = GetFunction( 3 , "?Break@@YAXXZ" )
      CloseLibrary( 3 )
      CallCFunctionFast( BreakProgram )
     EndIf
   EndIf
 EndProcedure

; **************************************************************
; This function ensure your plugin is inialized
ProcedureCDLL.l Init2DPlugKIT( user.l, code.l )
  CHECKFORSERIAL( User, Code )
  DBSetBitmapFormat( 21 )
  Setup\UseM2E = 2
  Setup\StartTIMER = DBTimerL()
  ProcedureReturn PlugINITIALIZED
 EndProcedure
;
; This function ensure your plugin is inialized
ProcedureCDLL.l Init2DPlugKITEx( user.l, code.l, Mode.l )
  CHECKFORSERIAL( User, Code )
  DBSetBitmapFormat( 21 )
  Select Mode
    Case 0 : Setup\UseM2E = 0
    Case 1 : Setup\UseM2E = 2
    Case 2 : Setup\UseM2E = 1
   EndSelect
  If Setup\UseM2E = 1
    If GetDLLInitialized( #AdvancedSPRITES ) = 0
      MessageRequester( "Warning, a TPC DLL is Missing", "AdvancedSPRITES.DLL" )
     EndIf
   EndIf
  Setup\StartTIMER = DBTimerL()
  ProcedureReturn PlugINITIALIZED
 EndProcedure
; **************************************************************
; Now you can include the PureBASIC source code file that will contain all your TPC Procedures
  IncludeFile "2DPlutKIT_ImagesSUPPORT.pb"
  IncludeFile "2DPlugKIT_Miscellaneous.pb"
  IncludeFile "2DPlugKIT_System.pb"
  IncludeFile "2DPlugKIT_Internal.pb"
  IncludeFile "2DPlugKIT_TilesVer3.pb" ; 187,338,414,
  IncludeFile "2DPlugKIT_BlitterOBJECTS.pb"
  IncludeFile "2DPlugKIT_Layers&Lights&Bobs&Particles.pb"
  IncludeFile "2DPlugKIT_LayersVer2.pb"
  IncludeFile "2DPlugKIT_Collisions.pb"
  IncludeFile "3DPlugKIT_VirtualLIGHTS.pb"
  IncludeFile "2DPlugKIT_TilesANIMATIONS.pb"
  IncludeFile "2DPlugKIT_ParticlesSYSTEM.pb"
;
; **************************************************************
; Simple informations about your plugin.
DataSection
DEP_PurePLUGIN:
Data.s "PurePLUGIN.dll"
Data.b 0
DEP_DBPRO01:
Data.s "DBProImageDebug.dll"
Data.b 0
DEP_DBPRO02:
Data.s "DBProSpritesDebug.dll"
Data.b 0
DEP_DBPRO03:
Data.s "DBProMemblocksDebug.dll"
Data.b 0
DEP_DBPRO04:
Data.s "DBProFileDebug.dll"
Data.b 0
DEP_DBPRO05:
Data.s "DBProBitmapDebug.dll"
Data.b 0
DEP_EXTENDS:
Data.s "DBProExtends.dll"
Data.b 0
DEP_EXTENDS01:
Data.s "DBProImageExtends.dll"
Data.b 0
DEP_EXTENDS02:
Data.s "DBProSpriteExtends.dll"
Data.b 0
DEP_EXTENDS03:
Data.s "DBProMemblocksExtends.dll"
Data.b 0
;DEP_POWERSPRITES:
;Data.s "AdvancedSPRITES.dll"
;Data.b 0
DONNEES:
Data.s "DarkBasic Professional 2DPluginKIT / "
Data.s "2DPlugKIT.dll Ver 1.1 [ 080326 ]  / "
Data.s "Frédéric Cordier - Odyssey-Creators(c)2005-2008 "
FLAMEPARTICLES:   IncludeBinary "Medias\Flame_Alpha.raw"   ;  16.396
SNOWPARTICLES:    IncludeBinary "Medias\snow_Alpha.raw"    ;   4.108
RAINPARTICLES:    IncludeBinary "Medias\rain_Alpha.raw"    ;  16.396
REGSequency:
Data.l 1, 5, 6, 8, 1, 0, 7, 4, 3, 6, 5, 7, 9, 2, 3, 0, 1, 4, 7, 8, 6, 5, 4, 3, 1
SPARKLEPARTICLES: IncludeBinary "Medias\sparkle_Alpha.raw" ;  16.396
EndDataSection
; IDE Options = PureBasic 4.10 (Windows - x86)
; ExecutableFormat = Shared Dll
; Folding = --
; Executable = 2DPluginKIT.dll
; DisableDebugger
; CompileSourceDirectory
; IncludeVersionInfo
; VersionField0 = 1.1.0.0
; VersionField1 = 1.1.0.0
; VersionField2 = Odyssey-Creators
; VersionField3 = 2DPlugKIT
; VersionField4 = 1.1
; VersionField5 = 1.1
; VersionField6 = 2D Plugin KIT
; VersionField7 = P2DK
; VersionField8 = 2DPlugKIT.DLL
; VersionField9 = Odyssey-Creators
; VersionField10 = Odyssey-Creators
; VersionField13 = support@odyssey-creators.com
; VersionField14 = http://www.odyssey-creators.com
; VersionField15 = VOS_NT_WINDOWS32
; VersionField16 = VFT_DLL
; AddResource = E:\Odyssey-Creators\Produits\DarkBASIC Professional PlugIN - 2DPluginKIT\2DPlugKIT [Developpement]\2DPlugKIT\2DPlugKIT_Resources.rc