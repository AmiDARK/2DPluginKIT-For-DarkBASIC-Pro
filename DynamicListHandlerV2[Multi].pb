;
; Gestionnaire de listes croissantes, décroissantes, non modifiées, de nombres.
;
Global Dim ReservedItems( 16 ) ; Give the number of used item.
Global Dim ListLength( 16 ) ; Give the position in ListItems()
Global Dim ListItems( 16, 65536 )

Procedure InsertItemInList( ListID.l, Value.l )
  ActualPOS.l = 0
  ListItems( ListID, 0 ) = $7FFFFFFF ; Numéro le plus grand possible.
  ListItems( ListID, ListLength + 1 ) = 0
  Repeat
    ActualPOS = ActualPOS + 1
    If ActualPOS = 1 : ValueLeft.l = Value + 1 : Else : ValueLEFT = ListItems( ListID, ActualPOS - 1 ) : EndIf
    ValueRIGHT.l = ListItems( ListID, ActualPOS )
   Until ( Value < ValueLEFT And Value > ValueRIGHT ) Or ActualPOS > 65535
  If ActualPOS <= ListLength( ListID ) +1
    XLoop.l = ListLength( ListID ) + 1 : Repeat
      ListItems( ListID, XLoop + 1 ) = ListItems( ListID, XLoop )
     XLoop = XLoop - 1 : Until XLoop < ActualPos
    EndIf
  ListLength( ListID ) = ListLength( ListID ) + 1 ; On incrémente le nombre de composantes dans la liste retenue.
  ListItems( ListID, ActualPOS ) = Value
  ProcedureReturn ActualPOS
 EndProcedure
;
Procedure RemoveItemFromList( ListID.l, Value.l )
  ActualPOS.l = 0
  ListItems( ListID, 0 ) = $7FFFFFFF ; Numéro le plus grand possible.
  ListItems( ListID, ListLength + 1 ) = 0
  Repeat
    ActualPOS = ActualPOS + 1  
   Until Value = ListItems( ListID, ActualPOS ) Or ActualPOS > 65535
  If ActualPOS = 65536 : MessageRequester( "PurePLUGIN Dynamic Handler Error #02 :", "Warning, ID not found in the list" ) : EndIf
  If ActualPOS < ListLength( ListID )
    XLoop.l = ActualPOS : Repeat
      ListItems( ListID, XLoop ) = ListItems( ListID, XLoop + 1 )
     XLoop = XLoop + 1 : Until XLoop > ( ListLength( ListID ) + 1 )
   EndIf
  ListLength( ListID ) = ListLength( ListID ) - 1
  ListItems( ListID, ListLength( ListID ) + 1 ) = 0
  If ListLength( ListID ) < 0 : ListLength( ListID ) = 0 : EndIf
 EndProcedure
;
Procedure.l DLH_GetNextFreeItem( ListID.l )
  FreeItem.l = 0
  If ListLength( ListID ) = 0
    ; Si la liste d'objets supprimés est vide, on incrémente le compteur d'objets réels et on l'utilise.
    ReservedItems( ListID ) = ReservedItems( ListID ) + 1
    FreeItem = ReservedItems( ListID )
   Else
    ; Si la liste d'objets supprimés n'est pas vide, on utilise la dernière valeur et on décrémente la dimension de la liste.
    FreeItem = ListItems( ListID, ListLength )
    ListLength( ListId ) = ListLength( ListID ) - 1
    ListItems( ListID, ListLength + 1 ) = 0 ; Clear the old item...
   EndIf  
  ProcedureReturn FreeItem
 EndProcedure

Procedure DLH_CheckReservedItemsList( ListID.l )
  Repeat
    VALIDATED.l = 0
    If ListLength( ListID ) > 0 And ReservedItems( ListID ) > 0
      If ListItems( ListID, 1 ) = ReservedItems( ListID )
         RemoveItemFromList( ListID, ReservedItems( ListID ) )
         ReservedItems( ListID ) = ReservedItems( ListID ) - 1
         VALIDATED = 1
        EndIf
     EndIf
   Until VALIDATED = 0
 EndProcedure
;
Procedure.l DLH_FreeItem( ListID.l, ItemNumber.l )
  If ItemNumber > 0
    If ItemNumber = ReservedItems( ListID )
      ; Si l'objet à enlever de la liste est le dernier du compteur réel, on décrémente simplement le compteur réel.
      ReservedItems( ListID ) = ReservedItems( ListID ) - 1
      DLH_CheckReservedItemsList( ListID )
     Else
      TruePos.l = InsertItemInList( ListID, ItemNumber )
     EndIf
   EndIf
  ProcedureReturn 0
 EndProcedure

Procedure.l DLH_GetCount( ListID.l )
  ItemCount.l = ReservedItems( ListID ) - ListLength( ListID )
  ProcedureReturn ItemCount
 EndProcedure

Procedure.l DLH_GetItemCounter( ListID.l )
  ProcedureReturn ReservedItems( ListID )
 EndProcedure

Procedure DLH_ClearList( ListID.l )
  If ListLength( ListID ) > 0
    XLoop.l = ListLength( ListID ) + 1 : Repeat
      ListItems( ListID, XLoop ) = 0
     XLoop = XLoop - 1 : Until XLoop = 0
    ListLength( ListID ) = 0
   EndIf
  ReservedItems( ListID ) = 0
 EndProcedure
; IDE Options = PureBasic v4.02 (Windows - x86)
; CursorPosition = 3
; Folding = --