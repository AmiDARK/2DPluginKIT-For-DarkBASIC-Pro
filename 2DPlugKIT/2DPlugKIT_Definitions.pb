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
  DefaultWIDTH.l         ; Largeur par défaut d'une tile.
  DefaultHEIGHT.l        ; Hauteur par défaut d'une tile.
  DefaultTransparency.l  ; Valeur par défaut pour la transparence des tiles.
  NewTIMER.l             ; Valeur Initiale du DBTimerL()
  StartTIMER.l           ; Valeur du DBTimerL() par rapport au début de l'application.
  LightEFFECTPercent.f   ; Valeur de pourcentage d'accomplissement de l'effet.
  DebugMODE.l            ; Mode DEBUG OUTPUT
  CollisionMODE.l        ; Mode de collision: 0=Rapide, 1=Complet, 2=Rapide+eXtends, 3=Complet+eXtends
  AutoNMAP.l             ; Générer automatiquement l'image de Normal Mapping.
  AutoMASK.l             ; Générer automatiquement le bloc mémoire de masque de collision.
  UseM2E.l               ; Permet d'utiliser le plugin M2E D3D pour l'affichage accéléré des sprites.
  SpriteMODE.l           ; Mode de redimensionnement de sprites pour dbpro...
 EndStructure
Global Setup.Setup_Structure
;
;**************************************************************************************************************
;
Structure GroupedTiles_Structure
  TilesCOUNT.l          ; Quantité maximale de tiles utilisables.
  Block.l               ; Bloc mémoire contenant toutes les tiles au format RAW.
  ImageID.l             ; Numéro de l'image à utiliser pour créer le sprites E2M pour les tiles rapides.
  ImgWIDTH.l            ; Largeur de l'image.
  ImgHEIGHT.l           ; Heuteur de l'image.
  TilesXCount.l         ; Nombre de tiles sur X.
  TilesYCount.l         ; Nombre de tiles sur Y.
  TilesWIDTH.l          ; Largeur des tiles.
  TilesHEIGHT.l         ; Hauteur des tiles.
  DBSprite.l            ; Numéro du sprite DBPro pour le rendu semi-accéléré.
  M2ESprite.l           ; Pointeur vers le sprite M2E pour le rendu accéléré.
  MaskSIZE.l         ; Quantité de mémoire crée pour les images de collisions.
  MaskMBC.l          ; Numéro du bloc mémoire utilisé pour les masques de collision.
  MaskPTR.l          ; Pointeur mémoire vers le bloc des masques.
 EndStructure
Global GroupedTiles.GroupedTiles_Structure
;
;**************************************************************************************************************
;
Global TilesLOCATION.s  ; Sous-dossier dans lequel toutes les tiles sont placées pour les charger.
Global TilesINFORMATIONSVersion.l = 1
Structure Tiles_Structure
  FileName.s             ; Définit le nom du fichier de tiles à charger.
  Active.l               ; Défini à 1 si la tile a été crée. Sinon défini à 0.
  Width.l                ; Largeur de la tile.
  Height.l               ; Hauteur de la tile.
  Transparency.l         ; Use Transparency to hide black pixels.
  ImageLOADED.l          ; Image de la tile.
  EXTImage.b             ; Si l'image a été chargée via eXtends.
  MASKFileName.s         ; Définit le nom du fichier à utiliser pour le masque de collision de la tile.
  NMAPFileName.s         ; Définit le nom du fichier à utiliser pour le normal mapping de la tile.
  NMapIMAGE.l            ; Image pour le Normal Mapping de la tile au format "Image Memblock 32 bits".
  EXTNmap.b              ; Le normal map a été crée par eXtends ou pas.
  AnimationID.l          ; Add an animation structure to the tile.
  TileANIMFrame.l        ; numéro de la tile à utiliser pour l'animation.
 EndStructure
Global Dim Tiles.Tiles_Structure( 16384 )
;
;**************************************************************************************************************
;
Structure LayerSTRUCTURE
  Active.l              ; =1 si le layer est crée.
  MemoryMBC.l           ; Numéro du bloc mémoire utilisé pour stoquer le layer.
  MemoryPTR.l           ; Pointeur vers la zone mémoire allouée pour créer le layer.
  MemorySIZE.l          ; Dimension de la zone mémoire allouée pour créer le layer.
  Width.l               ; Largeur en nombre de tiles du layer.
  Height.l              ; Hauteur en nombre de tiles du layer.
  TileWIDTH.l           ; Largeur de tracé des tiles du layer.
  TileHEIGHT.l          ; Hauteur de tracé des tiles du layer.
  Hide.l                ; Hide a layer to not draw it when not required.
  BitmapToTrace.l       ; Numéro du bitmap dans lequel le tracé du layer sera fait.
  XDisplay.f            ; A partir de quel endroit dans le layer, sur X, on tracera sur l'écran (scrolling).
  YDisplay.f            ; A partir de quel endroit dans le layer, sur Y, on tracera sur l'écran (scrolling).
  XStart.l              ; Début du tracé sur X dans l'écran.
  YStart.l              ; Début du tracé sur Y dans l'écran.
  XEnd.l                ; Fin du tracé sur X dans l'écran.
  YEnd.l                ; Fin du tracé sur Y dans l'écran.
  XCycle.l              ; Le layer cycle t-il sur X ?
  YCycle.l              ; Le layer cycle t-il sur Y ?
  ScrollMODE.l          ; Défini le type de scrolling du layer 0=Statique, 1=Relatif, 2 = Constant
  XSpeed.f              ; Défini la vitesse de scrolling sur X.
  YSpeed.f              ; Défini la vitesse de scrolling sur Y.
  CameraLOCK.l          ; Défini si la caméra peut afficher des zones hors layer ou si elle se bloque en bordure.
 EndStructure
Global Dim Layers.LayerSTRUCTURE( 16 )
Global Dim LayersLights( 16, 256 )
Global Dim LayersBOBS( 16, 16384 )
Global Dim LayersParticle( 16, 256 )
Global GameLayer.l   ; Défini quel layer sera utilisé comme référence
;
;**************************************************************************************************************
;
Structure P2DLights_Type
  Active.l             ; La lumière existe ou pas.
  PlayMODE.l           ; 0 = Statique, 1 = Torche, 2 = Pulse, 3 = Défectueuse
  CyclePOS.l           ; Position dans le cycle ... 
  XPos.l               ; abscisse de la lumière dans le layer.
  YPos.l               ; Ordonnée de la lumière dans le layer.
  Rouge.l              ; Composante rouge de la couleur de la lumière virtuelle.
  Vert.l               ; Composante verte de la couleur de la lumière virtuelle.
  Bleu.l               ; Composante bleue de la couleur de la lumière virtuelle.
  Intensite.l          ; Intensité de la lumière virtuelle.
  Range.l              ; Range de l'image
  ImgWIDTH.l           ; Largeur et hauteur de l'image, utilisée pour les calculs de positionnement de la lumière.
  Mode.l               ; Mode utilisé pour la lumière.
  Hide.l               ; La lumière doit-elle être tracée dans l'écran ou pas ?
  ImageLOADED.l        ; Image qui sert à rendre la lumière dans la zone de jeu.
  LayerID.l            ; Layer auquel l'image sera rattachée.
  XDisplayPOS.l        ; Position de la lumière lors du dernier tracé dans l'écran.
  YDisplayPOS.l        ; Position de la lumière lors du dernier tracé dans l'écran.
  CastSHADOWS.l        ; If the light cast shadows.
  CastNMAP.l           ; If the light case Normal mapping.
  CastBRIGHT.l         ; If the max brightness is enabled
  M2ESprite.l          ; Si nous utilisont le plugin M2E D3D.DLL
  DBSprite.l           ; Si nous utilisons le mode SPRITES de DarkBASIC Professional.
 EndStructure
Global Dim P2DLights.P2DLights_Type( 256 )
Structure AmbientLight_Type
  Red.l                ; Composante rouge de la lumière d'ambiance.
  Green.l              ; Composante verte de la lumière d'ambiance.
  Blue.l               ; Composante Bleue de la lumière d'ambiance.
 EndStructure
Global Ambient.AmbientLight_Type
;
;**************************************************************************************************************
;
Structure Animations_Structure
  Active.l               ; L'animation existe.
  LoopMODE.l             ; Défini si l'animation se joue en boucle.
  FrameCount.l           ; Nombre de frames présentes dans l'animation
  FramePTR.l             ; Zone mémoire contenant la liste des animations à utiliser.
  LastFRAME.l            ; Position dans la séquence d'animation de la tile.
  PlayANIM.l             ; Est-ce que l'on a commandé d'activer la séquence d'animation de la tile.
  StartTIMER.l           ; Valeur du timer au lancement de l'animation.
  TileID.l               ; Lien vers la tile qui utilisera cette animation.
  SpriteID.l             ; Lien vers le sprite qui utilisera cette animation.
  BobID.l                ; Lien vers un BOB qui utilisera cette animation.
  Speed.l                ; Défini la vitesse d'animation.
 EndStructure 
Global Dim Animations.Animations_Structure( 1024 ) 
;
;**************************************************************************************************************
;
Structure Bobs_Structure
  Active.l               ; L'objet blitter existe.
  InstanceID.l           ; Si le bob est une instance d'un autre bob.
  ImageID.l              ; Numéro de l'image à utiliser dessus.
  EXTLoaded.l            ; = 1 si l'image à été chargée par eXtends via 2DPlugKIT.
  Width.l                ; Largeur de l'image utilisée pour le bob.
  Height.l               ; Hauteur de l'image utilisées pour le bob.
  AnimationID.l          ; Add an animation structure to the tile.
  LayerID.l              ; Numéro du layer dans lequel le bob sera affiché (juste au dessus du layer)
  XPos.l                 ; Position sur X dans le layer.
  YPos.l                 ; Position sur Y dans le layer.
  Hide.l                 ; Définit si l'objet doit être caché ou pas.
  Transparency.l         ; Tracer l'image en utilisant la transparence.
  M2ESprite.l            ; Utiliser les sprites M2E pour le tracé.
  DBSprite.l             ; Utiliser les sprites de DBPro pour le tracé.
  XTiles.l               ; Nombre d'images par lignes sur X (de gauche à droite )
  YTiles.l               ; Nombre de lignes d'images sur Y (de haut en bas)
  TilesWIDTH.l
  TilesHEIGHT.l
  FramesCOUNT.l          ; Nombre d'images découpées dans le bob
  CurrentFRAME.l         ; Numéro de l'image ou de la frame dans le sprite à afficher.
 EndStructure
Global Dim Bobs.Bobs_Structure( 1024 )
;
;**************************************************************************************************************
;
Structure Particle_Structure
  Exist.l                ; Particule crée.
  Type.l                 ; Type de particule.
  Count.l                ; Nombre d'objets dans le jeu de particules.
  Size.f                 ; Largeur des particules.
  XEmitter.f             ; Coordonnées de l'émétteur du jeu de particules dans le layer choisi.
  YEmitter.f             ; Coordonnées de l'émétteur du jeu de particules dans le layer choisi.
  XSize.f : YSize.f      ; Dimension maximale du champ d'action du jeu de particules. 
  XMove.f : YMove.f      ; Déplacement relatif des particules dans le jeu.
  XMin.f : XMax.f        ; Coordonnées Max/Min sur X.
  YMin.f : YMax.f        ; Coordonnées Max/Min sur Y.
  Duration.f
  Hide.l
  LoadedImage.l
  UseInternal.l
  DBPSprite.l            ; Sprite DarkBASIC Professional crée par défaut.
  M2ESprite.l            ; Sprite E2M crée optionnellement.
  LayerID.l              ; Numéro du layer d'attache du jeu de particules.
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