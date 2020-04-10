;
; ***********************************************
; *                                             *
; * 2DPlugKIT Include File : SYSTEM DEFINITIONS *
; *                                             *
; ***********************************************
; This include contain all data definitions needed to make the system work correctly.
;
;**************************************************************************************************************
;
Global OldTIMER.l
Global ActualTIMER.l
;
;**************************************************************************************************************
;
Structure Setup_Structure
  DefaultWIDTH.l         ; Largeur par d�faut d'une tile.
  DefaultHEIGHT.l        ; Hauteur par d�faut d'une tile.
  DefaultTransparency.l  ; Valeur par d�faut pour la transparence des tiles.
  NewTIMER.l             ; Valeur Initiale du DBTimerL()
  StartTIMER.l           ; Valeur du DBTimerL() par rapport au d�but de l'application.
  LightEFFECTPercent.f   ; Valeur de pourcentage d'accomplissement de l'effet.
  DebugMODE.l            ; Mode DEBUG OUTPUT
  CollisionMODE.l        ; Mode de collision: 0=Rapide, 1=Complet, 2=Rapide+eXtends, 3=Complet+eXtends
  AutoNMAP.l             ; G�n�rer automatiquement l'image de Normal Mapping.
  AutoMASK.l             ; G�n�rer automatiquement le bloc m�moire de masque de collision.
  UseM2E.l               ; Permet d'utiliser le plugin M2E D3D pour l'affichage acc�l�r� des sprites.
  SpriteMODE.l           ; Mode de redimensionnement de sprites pour dbpro...
 EndStructure
Global Setup.Setup_Structure
;
;**************************************************************************************************************
;
Structure GroupedTiles_Structure
  TilesCOUNT.l          ; Quantit� maximale de tiles utilisables.
  Block.l               ; Bloc m�moire contenant toutes les tiles au format RAW.
  ImageID.l             ; Num�ro de l'image � utiliser pour cr�er le sprites E2M pour les tiles rapides.
  ImgWIDTH.l            ; Largeur de l'image.
  ImgHEIGHT.l           ; Heuteur de l'image.
  TilesXCount.l         ; Nombre de tiles sur X.
  TilesYCount.l         ; Nombre de tiles sur Y.
  TilesWIDTH.l          ; Largeur des tiles.
  TilesHEIGHT.l         ; Hauteur des tiles.
  DBSprite.l            ; Num�ro du sprite DBPro pour le rendu semi-acc�l�r�.
  M2ESprite.l           ; Pointeur vers le sprite M2E pour le rendu acc�l�r�.
  MaskSIZE.l         ; Quantit� de m�moire cr�e pour les images de collisions.
  MaskMBC.l          ; Num�ro du bloc m�moire utilis� pour les masques de collision.
  MaskPTR.l          ; Pointeur m�moire vers le bloc des masques.
 EndStructure
Global GroupedTiles.GroupedTiles_Structure
;
;**************************************************************************************************************
;
Global TilesLOCATION.s  ; Sous-dossier dans lequel toutes les tiles sont plac�es pour les charger.
Global TilesINFORMATIONSVersion.l = 1
Structure Tiles_Structure
  FileName.s             ; D�finit le nom du fichier de tiles � charger.
  Active.l               ; D�fini � 1 si la tile a �t� cr�e. Sinon d�fini � 0.
  Width.l                ; Largeur de la tile.
  Height.l               ; Hauteur de la tile.
  Transparency.l         ; Use Transparency to hide black pixels.
  ImageLOADED.l          ; Image de la tile.
  EXTImage.b             ; Si l'image a �t� charg�e via eXtends.
  MASKFileName.s         ; D�finit le nom du fichier � utiliser pour le masque de collision de la tile.
  NMAPFileName.s         ; D�finit le nom du fichier � utiliser pour le normal mapping de la tile.
  NMapIMAGE.l            ; Image pour le Normal Mapping de la tile au format "Image Memblock 32 bits".
  EXTNmap.b              ; Le normal map a �t� cr�e par eXtends ou pas.
  AnimationID.l          ; Add an animation structure to the tile.
  TileANIMFrame.l        ; num�ro de la tile � utiliser pour l'animation.
 EndStructure
Global Dim Tiles.Tiles_Structure( 16384 )
;
;**************************************************************************************************************
;
Structure LayerSTRUCTURE
  Active.l              ; =1 si le layer est cr�e.
  MemoryMBC.l           ; Num�ro du bloc m�moire utilis� pour stoquer le layer.
  MemoryPTR.l           ; Pointeur vers la zone m�moire allou�e pour cr�er le layer.
  MemorySIZE.l          ; Dimension de la zone m�moire allou�e pour cr�er le layer.
  Width.l               ; Largeur en nombre de tiles du layer.
  Height.l              ; Hauteur en nombre de tiles du layer.
  TileWIDTH.l           ; Largeur de trac� des tiles du layer.
  TileHEIGHT.l          ; Hauteur de trac� des tiles du layer.
  Hide.l                ; Hide a layer to not draw it when not required.
  BitmapToTrace.l       ; Num�ro du bitmap dans lequel le trac� du layer sera fait.
  XDisplay.f            ; A partir de quel endroit dans le layer, sur X, on tracera sur l'�cran (scrolling).
  YDisplay.f            ; A partir de quel endroit dans le layer, sur Y, on tracera sur l'�cran (scrolling).
  XStart.l              ; D�but du trac� sur X dans l'�cran.
  YStart.l              ; D�but du trac� sur Y dans l'�cran.
  XEnd.l                ; Fin du trac� sur X dans l'�cran.
  YEnd.l                ; Fin du trac� sur Y dans l'�cran.
  XCycle.l              ; Le layer cycle t-il sur X ?
  YCycle.l              ; Le layer cycle t-il sur Y ?
  ScrollMODE.l          ; D�fini le type de scrolling du layer 0=Statique, 1=Relatif, 2 = Constant
  XSpeed.f              ; D�fini la vitesse de scrolling sur X.
  YSpeed.f              ; D�fini la vitesse de scrolling sur Y.
  CameraLOCK.l          ; D�fini si la cam�ra peut afficher des zones hors layer ou si elle se bloque en bordure.
 EndStructure
Global Dim Layers.LayerSTRUCTURE( 16 )
Global Dim LayersLights( 16, 256 )
Global Dim LayersBOBS( 16, 16384 )
Global Dim LayersParticle( 16, 256 )
Global GameLayer.l   ; D�fini quel layer sera utilis� comme r�f�rence
;
;**************************************************************************************************************
;
Structure P2DLights_Type
  Active.l             ; La lumi�re existe ou pas.
  PlayMODE.l           ; 0 = Statique, 1 = Torche, 2 = Pulse, 3 = D�fectueuse
  CyclePOS.l           ; Position dans le cycle ... 
  XPos.l               ; abscisse de la lumi�re dans le layer.
  YPos.l               ; Ordonn�e de la lumi�re dans le layer.
  Rouge.l              ; Composante rouge de la couleur de la lumi�re virtuelle.
  Vert.l               ; Composante verte de la couleur de la lumi�re virtuelle.
  Bleu.l               ; Composante bleue de la couleur de la lumi�re virtuelle.
  Intensite.l          ; Intensit� de la lumi�re virtuelle.
  Range.l              ; Range de l'image
  ImgWIDTH.l           ; Largeur et hauteur de l'image, utilis�e pour les calculs de positionnement de la lumi�re.
  Mode.l               ; Mode utilis� pour la lumi�re.
  Hide.l               ; La lumi�re doit-elle �tre trac�e dans l'�cran ou pas ?
  ImageLOADED.l        ; Image qui sert � rendre la lumi�re dans la zone de jeu.
  LayerID.l            ; Layer auquel l'image sera rattach�e.
  XDisplayPOS.l        ; Position de la lumi�re lors du dernier trac� dans l'�cran.
  YDisplayPOS.l        ; Position de la lumi�re lors du dernier trac� dans l'�cran.
  CastSHADOWS.l        ; If the light cast shadows.
  CastNMAP.l           ; If the light case Normal mapping.
  CastBRIGHT.l         ; If the max brightness is enabled
  M2ESprite.l          ; Si nous utilisont le plugin M2E D3D.DLL
  DBSprite.l           ; Si nous utilisons le mode SPRITES de DarkBASIC Professional.
 EndStructure
Global Dim P2DLights.P2DLights_Type( 256 )
Structure AmbientLight_Type
  Red.l                ; Composante rouge de la lumi�re d'ambiance.
  Green.l              ; Composante verte de la lumi�re d'ambiance.
  Blue.l               ; Composante Bleue de la lumi�re d'ambiance.
 EndStructure
Global Ambient.AmbientLight_Type
;
;**************************************************************************************************************
;
Structure Animations_Structure
  Active.l               ; L'animation existe.
  LoopMODE.l             ; D�fini si l'animation se joue en boucle.
  FrameCount.l           ; Nombre de frames pr�sentes dans l'animation
  FramePTR.l             ; Zone m�moire contenant la liste des animations � utiliser.
  LastFRAME.l            ; Position dans la s�quence d'animation de la tile.
  PlayANIM.l             ; Est-ce que l'on a command� d'activer la s�quence d'animation de la tile.
  StartTIMER.l           ; Valeur du timer au lancement de l'animation.
  TileID.l               ; Lien vers la tile qui utilisera cette animation.
  SpriteID.l             ; Lien vers le sprite qui utilisera cette animation.
  BobID.l                ; Lien vers un BOB qui utilisera cette animation.
  Speed.l                ; D�fini la vitesse d'animation.
 EndStructure 
Global Dim Animations.Animations_Structure( 1024 ) 
;
;**************************************************************************************************************
;
Structure Bobs_Structure
  Active.l               ; L'objet blitter existe.
  InstanceID.l           ; Si le bob est une instance d'un autre bob.
  ImageID.l              ; Num�ro de l'image � utiliser dessus.
  EXTLoaded.l            ; = 1 si l'image � �t� charg�e par eXtends via 2DPlugKIT.
  Width.l                ; Largeur de l'image utilis�e pour le bob.
  Height.l               ; Hauteur de l'image utilis�es pour le bob.
  AnimationID.l          ; Add an animation structure to the tile.
  LayerID.l              ; Num�ro du layer dans lequel le bob sera affich� (juste au dessus du layer)
  XPos.l                 ; Position sur X dans le layer.
  YPos.l                 ; Position sur Y dans le layer.
  Hide.l                 ; D�finit si l'objet doit �tre cach� ou pas.
  Transparency.l         ; Tracer l'image en utilisant la transparence.
  M2ESprite.l            ; Utiliser les sprites M2E pour le trac�.
  DBSprite.l             ; Utiliser les sprites de DBPro pour le trac�.
  XTiles.l               ; Nombre d'images par lignes sur X (de gauche � droite )
  YTiles.l               ; Nombre de lignes d'images sur Y (de haut en bas)
  TilesWIDTH.l
  TilesHEIGHT.l
  FramesCOUNT.l          ; Nombre d'images d�coup�es dans le bob
  CurrentFRAME.l         ; Num�ro de l'image ou de la frame dans le sprite � afficher.
 EndStructure
Global Dim Bobs.Bobs_Structure( 1024 )
;
;**************************************************************************************************************
;
Structure Particle_Structure
  Exist.l                ; Particule cr�e.
  Type.l                 ; Type de particule.
  Count.l                ; Nombre d'objets dans le jeu de particules.
  Size.f                 ; Largeur des particules.
  XEmitter.f             ; Coordonn�es de l'�m�tteur du jeu de particules dans le layer choisi.
  YEmitter.f             ; Coordonn�es de l'�m�tteur du jeu de particules dans le layer choisi.
  XSize.f : YSize.f      ; Dimension maximale du champ d'action du jeu de particules. 
  XMove.f : YMove.f      ; D�placement relatif des particules dans le jeu.
  XMin.f : XMax.f        ; Coordonn�es Max/Min sur X.
  YMin.f : YMax.f        ; Coordonn�es Max/Min sur Y.
  Duration.f
  Hide.l
  LoadedImage.l
  UseInternal.l
  DBPSprite.l            ; Sprite DarkBASIC Professional cr�e par d�faut.
  M2ESprite.l            ; Sprite E2M cr�e optionnellement.
  LayerID.l              ; Num�ro du layer d'attache du jeu de particules.
 EndStructure
Global Dim ParticleSystem.Particle_Structure( 256 )
Structure ParticleObject_Structure
  XPos.f : YPos.f : Duration.f
 EndStructure
Global Dim ParticleObject.ParticleObject_Structure( 256 , 256 )
Global ActualTime.l : Global OldTime.l : Global TimeFactor.f
Global NextFlame.l : Global NextSmoke.l
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
; CursorPosition = 126
; FirstLine = 92
; Folding = -