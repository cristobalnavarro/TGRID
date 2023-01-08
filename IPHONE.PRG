*+--------------------------------------------------------------------
*+
*+ Source Module => c:\fwh\0\LISTVIEW\IPHONE.PRG
*+
*+    Copyright(C) 1983-2022 by Auge & Ohr
*+
*+    Functions: Procedure iPhoneWin()
*+               Static Function OnEnd()
*+               Static Procedure DoTreeAction()
*+               Static Procedure BuildRoot()
*+               Static Procedure SearchDevice()
*+               Static Procedure SelectDevice()
*+               Static Procedure DoTreeRecursiv()
*+               Static Procedure DoCopySingle()
*+               Static Function GoNext()
*+               Static Procedure ShowGrid()
*+               Static Procedure GetTargetFolder()
*+               Static Procedure Start_CopyHere()
*+
*+    Reformatted by Click! 2.05.40 on Jan-7-2023 at  1:29 am
*+
*+--------------------------------------------------------------------

#include "FIVEWIN.CH"
#include "TGRID.CH"

#define CSIDL_DRIVES                   0x0011
#define cDevice                        "APPLE IPHONE"

#define ID_Folder                      1
#define ID_Name                        2
#define ID_Level                       3
#define ID_Parent                      4
#define ID_Element                     5

STATIC oIPHONE
STATIC oTree_1
STATIC oButton_Target
STATIC oTargetDir
STATIC oButton_CopyHere
STATIC oButton_MoveHere
STATIC oFontDefault
STATIC oImageList
STATIC oShell, oFolder
STATIC oBrwCP
STATIC oGrid
STATIC oTreeLast

STATIC nLevel     := 0
STATIC nElement   := 0
STATIC aFileSys   := {}
STATIC aGridfiles := { "", "", "", "", "", "" }
STATIC aFolder    := {}
STATIC lRecursiv  := .F.
STATIC c_Target

MEMVAR BFcolor, BGcolor

*+--------------------------------------------------------------------
*+
*+    Procedure iPhoneWin()
*+
*+    Called from ( dualgrid.prg )   1 - static procedure calliphone()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE iPhoneWin( cPara )

LOCAL aPrompts
LOCAL nFontSize := 20
LOCAL lPixel    := .T., lDesign := .F., nWidth := 200, nHeight := 600, cMsg := "", lCheckBoxes := .F., bChange, lEditable := .F.
LOCAL aHeader   := {}
LOCAL bAction   := { || nil }
LOCAL nIcoLarge := 32
LOCAL nIcoSmall := 32
LOCAL lCheckbox := .T.

   IF !EMPTY( cPara )
      c_Target := EndwithSlash( cPara )
   ELSE
      c_Target := SPACE( 250 )
   ENDIF

   DEFINE FONT oFontDefault NAME "TAHOMA" SIZE 0, - nFontSize
      ACTIVATE FONT oFontDefault
#IFDEF __HMG__
   END FONT
#ENDIF

   AADD( aHeader, { "Name", 200, 0, "C" } )
   AADD( aHeader, { "Size", 150, 1, "N" } )
   AADD( aHeader, { "Date", 110, 1, "D" } )
   AADD( aHeader, { "Time", 090, 1, "C" } )
   AADD( aHeader, { "Note", 250, 0, "C" } )

   aGridfiles := DIRECTORY( "*.*", "DHS" )

   DEFINE WINDOW oIPHONE FROM 0, 0 TO 768, 1024 PIXEL TITLE "Device " ICON "A1MAIN" COLOR BFcolor, BGcolor NOMINIMIZE NOMAXIMIZE

      oGrid := TGrid() :New( 20, 220, aPrompts, bAction, oIPHONE, BFcolor, BGcolor, ;
                       lPixel, lDesign, 780, 600, cMsg, nIcoLarge, nIcoSmall, lCheckbox )
      oGrid:aHeader := aHeader
      oGrid:aSource := aGridfiles

      oTree_1 := TTreeView() :New( 20, 10, oIPHONE, BFcolor, BGcolor, lPixel, lDesign, nWidth, nHeight, cMsg, lCheckBoxes, bChange, lEditable )

      oImageList := TImageList() :New()
      oImageList:Add( TBitmap() :Define( "folder",, oIPHONE ), ;
                      TBitmap() :Define( "fldmask",, oIPHONE ) )

      oTree_1:SetImageList( oImageList )

      oTree_1:bLDblClick = { || DoTreeAction( oTree_1:GetSelected() ) }

      @ 624, 010 BUTTON oButton_Target PROMPT "&Target Folder" SIZE 200, 30 PIXEL FONT oFontDefault ACTION GetTargetFolder() OF oIPHONE
      @ 624, 220 GET oTargetDir VAR c_Target SIZE 780, 30 PIXEL FONT oFontDefault OF oIPHONE         

      @ 660, 010 BUTTON oButton_CopyHere PROMPT "&CopyHere" SIZE 100, 30 PIXEL FONT oFontDefault ACTION Start_CopyHere( .F. ) OF oIPHONE
      @ 660, 110 BUTTON oButton_MoveHere PROMPT "&MoveHere" SIZE 100, 30 PIXEL FONT oFontDefault ACTION Start_CopyHere( .T. ) OF oIPHONE

#IFDEF __HMG__
   END WINDOW
#ENDIF

   oIPHONE:bKeyDown := { | nKey, nFlag | IF( nKey = VK_ESCAPE, oIPHONE:End(), nil ) }
   oIPHONE:bResized := { | nType, nWidth, nHeight | oIPHONE:SetSize( 1024, 768 ) }

   ACTIVATE WINDOW oIPHONE ON INIT( BuildRoot(), MakeTop( oIPHONE, oTree_1 ) ) VALID OnEnd() CENTER

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function OnEnd()
*+
*+    Called from ( iphone.prg )   1 - procedure iphonewin()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION OnEnd()

RETURN .T.

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoTreeAction()
*+
*+    Called from ( iphone.prg )   1 - procedure iphonewin()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoTreeAction( oTreeNext )

LOCAL cThis       := oTreeNext:Cargo[ 1 ]
LOCAL nItem       := oTreeNext:Cargo[ 2 ]
LOCAL oFolderItem := oTreeNext:Cargo[ 3 ]
LOCAL aSelect, xFolder, xName, xLevel, xParent, xElement
LOCAL nPosi

   aGridfiles := {}
   DO CASE
      CASE nLevel = 0
         BuildRoot()
      CASE nLevel = 1
         SearchDevice()
      CASE nLevel = 2
         SelectDevice()

      OTHERWISE

         IF !EMPTY( aFolder ) .AND. !EMPTY( cThis )
            nPosi := ASCAN( aFolder, { | e | e[ ID_Name ] = UPPER( cThis ) } )
            //  .AND. e[ ID_Parent ] = nParent
            IF nPosi > 0
               aSelect := aFolder[ nPosi ]
               xLevel := aSelect[ ID_Level ]

               DoTreeRecursiv( oFolderItem, xLevel + 1, .F., .F., .F., .F., oTreeNext )

               ShowGrid()
            ENDIF
         ENDIF
   ENDCASE
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure BuildRoot()
*+
*+    Called from ( iphone.prg )   1 - procedure iphonewin()
*+                                   1 - static procedure dotreeaction()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE BuildRoot()

LOCAL oTreeItem

   oTree_1:DeleteAll()
   oTreeItem := oTree_1:Add( "This PC", 0, 0 )
   oTreeItem:Cargo := { "ROOT", 0, 0 }

   nLevel := 1
   aFileSys := {}
   aFolder := {}
   AADD( aFolder, { NIL, "This PC", 1, nElement } )

   // now include at Start
   SearchDevice( oTreeItem )

   oTree_1:Expand()

   oGrid:CreateHeaderColumn()

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SearchDevice()
*+
*+    Called from ( iphone.prg )   1 - static procedure dotreeaction()
*+                                   1 - static procedure buildroot()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SearchDevice( oTreeRoot )

LOCAL cName, oItems
LOCAL i, iMax
LOCAL oTreeItem
LOCAL oFolderItem

   nLevel := 2

   oShell := CreateObject( "shell.application" )
   IF NIL <> oShell
      oFolder := oShell:NameSpace( CSIDL_DRIVES )
      IF NIL <> oFolder
         oItems := oFolder:Items()
         iMax := oItems:Count
         FOR i := 1 TO iMax
            oFolderItem := oItems:Item( i - 1 )
            IF !EMPTY( oFolderItem )
               cName := UPPER( oFolderItem:name )
               IF cName = "DESKTOP"
                  LOOP
               ENDIF
               IF ASCAN( aFolder, { | e | e[ ID_Name ] = cName } ) > 0
               ELSE
                  nElement ++

                  oTreeItem := oTreeRoot:Add( cName, 0, nElement )
                  oTreeItem:Cargo := { cName, nLevel + 1, oFolderItem }                                                                     // next Level Action
                  AADD( aFolder, { oTreeItem, cName, nLevel + 1 } )

                  oTreeLast := oTreeItem

                  IF .NOT. oFolderItem:isFileSystem
                     AADD( aFileSys, i )
                  ENDIF
               ENDIF
            ENDIF
         NEXT
      ENDIF
   ENDIF

   Sysrefresh()

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SelectDevice()
*+
*+    Called from ( iphone.prg )   1 - static procedure dotreeaction()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SelectDevice()

LOCAL cThis, oItems
LOCAL i, iMax, xParent := 0
LOCAL nItem
LOCAL cPhone      := "APPLE IPHONE"
LOCAL oFolderItem

   nLevel := 3
   IF NIL <> oFolder
      oItems := oFolder:Items()
      iMax := oItems:Count
      FOR i := 1 TO iMax
         oFolderItem := oItems:Item( i - 1 )
         IF !EMPTY( oFolderItem )
            // https://learn.microsoft.com/de-de/windows/win32/shell/folderitem-name
            cThis := UPPER( oFolderItem:name )

            IF cThis = UPPER( cPhone )
               // EXIT here
               EXIT
            ENDIF
         ENDIF
      NEXT
   ENDIF

   Sysrefresh()

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoTreeRecursiv()
*+
*+    Called from ( iphone.prg )   1 - static procedure dotreeaction()
*+                                   1 - static procedure dotreerecursiv()
*+                                   1 - static procedure start_copyhere()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoTreeRecursiv( xFolder, xLevel, xRecursiv, lTransfer, lMove, lisFileSys, oTreeNext )

LOCAL xThis, xItems
LOCAL ii, iMax, xFolderItem
LOCAL c_Name, c_Size, c_Date, c_Attr, c_Type
LOCAL cTarget     := c_Target
LOCAL oTreeItem
LOCAL oItemParent

   DEFAULT lTransfer := .F.
   DEFAULT lisFileSys := .T.

   IF NIL <> xFolder
      nLevel := xLevel
      xItems := xFolder:GetFolder:Items()
      IF lTransfer = .T.
         DoCopySingle( xItems, cTarget, lMove )
      ELSE

         iMax := xItems:Count
         FOR ii := 1 TO iMax
            xFolderItem := xItems:Item( ii - 1 )
            IF !EMPTY( xFolderItem )
               IF xFolderItem:IsLink
                  LOOP
               ENDIF
               IF xFolderItem:IsFolder                                // is it a folder
                  xThis := UPPER( xFolderItem:name )

                  IF ASCAN( aFolder, { | e | e[ ID_Name ] = xThis } ) > 0
                  ELSE

                     // search for Child and its Parent
                     nElement ++

                     oTreeItem := oTreeNext:Add( xThis, 0, xLevel )
                     oTreeItem:Cargo := { xThis, xLevel, xFolderItem }                                                                      // next Level Action
                     oTreeNext:Expand()
                     AADD( aFolder, { oTreeItem, xThis, nLevel + 1 } )

                     oTreeLast := oTreeItem

                     // not used here
                     IF xRecursiv = .T.
                        DoTreeRecursiv( xFolderItem, xLevel + 1, xRecursiv, .F., .F., lisFileSys,, oTreeNext )
                     ENDIF
                  ENDIF
               ELSE
                  c_Name := xFolderItem:name
                  c_Size := xFolderItem:Size
                  c_Date := xFolderItem:ModifyDate
                  c_Type := xFolderItem:Type
                  c_Attr := ""
                  AADD( aGridfiles, { c_Name, c_Size, c_Date, c_Attr, c_Type, LTRIM( STR( xLevel + 1 ) ) } )
               ENDIF
            ENDIF
         NEXT
      ENDIF
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoCopySingle()
*+
*+    Called from ( iphone.prg )   1 - static procedure dotreerecursiv()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoCopySingle( oDirFolder, cTarget, lMove )

LOCAL hGrid   := oGrid:hwnd                                           // GetControlHandle( "Grid_1", "IPHONE" )
LOCAL oNewSH  := CreateObject( "Shell.Application" )
LOCAL oTarget := oNewSH:NameSpace( cTarget )
LOCAL xFlag   := FOF_SIMPLEPROGRESS
LOCAL aFiles  := {}
LOCAL oFile, cFile, xCount, nCount
LOCAL i, iMax, nSkip := 0
LOCAL nState  := hb_BitOr( LVIS_SELECTED, LVIS_FOCUSED )
LOCAL nMask   := hb_BitOr( LVIS_SELECTED, LVIS_FOCUSED )

   DEFAULT lMove := .F.

   iMax := oDirFolder:Count
   FOR i := 1 TO iMax

      SYSrefresh()

      // if Checkbox is marked
      //       IF IPHONE.Grid_1.CheckBoxItem( i ) = .T.

      IF LV_GETCHECKSTATE( hGrid, i ) = .T.

         // get Item Object
         oFile := oDirFolder:Item( i - 1 )

         IF lMove = .T.
            // move single Object file
            // https://learn.microsoft.com/de-de/windows/win32/shell/folder-movehere
            oTarget:MoveHere( oFile, xFlag )
         ELSE
            // copy single Object file
            // https://learn.microsoft.com/de-de/windows/win32/shell/folder-copyhere
            oTarget:CopyHere( oFile, xFlag )
         ENDIF

         // wait until all files are written
         xCount := 0
         DO WHILE .T.
            // compare if file is written
            nCount := oTarget:items() :Count()
            IF nCount + nSkip >= i
               EXIT
            ENDIF
            hb_idleSleep( 0.1 )
            xCount ++
            IF xCount > 50
               EXIT
            ENDIF
         ENDDO

         LV_SETCHECKSTATE( hGrid, i, .F. )

         // scroll GRID if need
         LV_SETITEMSTATE( hGrid, i, nState, nMask )
         LV_EnsureVisible( hGrid, i )

      ELSE
         // Skip un-maked
         nSkip ++
      ENDIF
   NEXT
   // clean up
   hb_idleSleep( 0.5 )

   oTarget := NIL
   oNewSH := NIL

   SYSrefresh()

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function GoNext()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION GoNext()

LOCAL oSelItem := oTree_1:GetSelected(), lStop := .F., oNextItem
LOCAL lRet     := .T.

   oTree_1:Scan( { | oItem | IF( oItem:hItem == oSelItem:hItem, lStop := .T., ), ;
                   IF( lStop .AND. oItem:hItem != oSelItem:hItem, ( oNextItem := oItem, .T. ), .F. ) } )

   IF oNextItem != nil
      oTree_1:Select( oNextItem )
      IF oNextItem:Cargo[ 2 ] = oTreeLast:Cargo[ 2 ]
         lRet := .F.
      ENDIF
   ELSE
      lRet := .F.
   ENDIF

RETURN lRet

*+--------------------------------------------------------------------
*+
*+    Static Procedure ShowGrid()
*+
*+    Called from ( iphone.prg )   1 - static procedure dotreeaction()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE ShowGrid()

LOCAL ii, iMax
LOCAL hGrid := oGrid:hwnd

   oButton_CopyHere:Show()
   oButton_MoveHere:Show()

   oGrid:aSource := aGridfiles
   oGrid:ClearAndFillDir( oIPHONE )

   iMax := LEN( oGrid:aSource )
   FOR ii := 1 TO iMax
      LV_SETCHECKSTATE( hGrid, ii, .T. )
   NEXT

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure GetTargetFolder()
*+
*+    Called from ( iphone.prg )   1 - procedure iphonewin()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE GetTargetFolder()

LOCAL cFolder := cGETFOLDER( "Get Target Folder", c_Target )

   IF !EMPTY( cFolder )
      c_Target := EndwithSlash( cFolder )
      oTargetDir:Refresh()
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure Start_CopyHere()
*+
*+    Called from ( iphone.prg )   2 - procedure iphonewin()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE Start_CopyHere( lMove )

LOCAL lTransfer   := .T.
LOCAL nItem
LOCAL cThis
LOCAL oFolderItem
LOCAL nPosi
LOCAL aSelect, xFolder, xName, xLevel, xParent, xElement

   cThis := oTreeLast:Cargo[ 1 ]
   nItem := oTreeLast:Cargo[ 2 ]
   oFolderItem := oTreeLast:Cargo[ 3 ]

   IF !EMPTY( aGridfiles )
      IF nItem > 0
         aSelect := aFolder[ nItem ]
         xLevel := aSelect[ ID_Level ]

         DoTreeRecursiv( oFolderItem, xLevel, .F., lTransfer, lMove )                                                                       // "TOLEAUTO"

      ENDIF
   ENDIF
   sysrefresh()

RETURN

*+ EOF: IPHONE.PRG
