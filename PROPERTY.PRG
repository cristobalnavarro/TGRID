*+--------------------------------------------------------------------
*+
*+ Source Module => c:\fwh\0\LISTVIEW\PROPERTY.PRG
*+
*+    Copyright(C) 1983-2022 by Auge & Ohr
*+
*+    Functions: Procedure ShowMoreProperty()
*+               Static Function GetMetaData()
*+               Static Function OnlySign()
*+
*+    Reformatted by Click! 2.05.40 on Jan-7-2023 at  1:29 am
*+
*+--------------------------------------------------------------------

#include "FiveWin.ch"

#include "TGRID.CH"

MEMVAR BFcolor, BGcolor
MEMVAR oFontDefault

*+--------------------------------------------------------------------
*+
*+    Procedure ShowMoreProperty()
*+
*+    Called from ( dualgrid.prg )   2 - class texplorer
*+
*+--------------------------------------------------------------------
*+
PROCEDURE ShowMoreProperty( cPath, cFile, nIcoLarge, nIcoSmall )

LOCAL oWnd
LOCAL ii, iMax
LOCAL oGrid, aItem
LOCAL aMeta
LOCAL nStart    := 1
LOCAL cDrive    := SPACE( 80 )
LOCAL bAction   := { | x | nil }
LOCAL cMsg      := ""
LOCAL aHeader   := {}
LOCAL lPixel    := .T.
LOCAL lDesign   := .F.
LOCAL lChkBoxes := .F.
LOCAL lDispInfo := .T.

   DEFAULT nIcoLarge := 256                                           // 32
   DEFAULT nIcoSmall := 32                                            // 16

   FW_SetUnicode( .F. )                                               // MUST use ANSI Mode

   aMeta := GetMetaData( cPath, cFile )

   DEFINE WINDOW oWnd FROM 0, 0 TO 800, 800 PIXEL TITLE "more Property" ICON "A1MAIN" COLOR BFcolor, BGcolor NOMINIMIZE NOMAXIMIZE

      oGrid := TGrid() :New( 0, 0,, bAction, oWnd, ;
                       BFcolor, BGcolor, lPixel, lDesign, ;
                       800, 800, cMsg, nIcoLarge, nIcoSmall, lChkBoxes, lDispInfo )

      AADD( aHeader, { "No", 080, LVCFMT_LEFT, "C" } )
      AADD( aHeader, { "Description", 250, LVCFMT_LEFT, "C" } )
      AADD( aHeader, { "Value", 440, LVCFMT_LEFT, "C" } )

      oGrid:aHeader := aHeader
      oGrid:aSource := aMeta
      // no FileIcon
      oGrid:lFileIcon := .F.

      oGrid:CreateHeaderColumn()

      oGrid:bRbClick := { | oCtrl, nRow, nCol, nKeyFlags | MsgInfo( "right-menu" ) }

      IF oGrid:lDispInfo = .T.
         iMax := LEN( aMeta )
         // need for LVS_OWNERDATA / ::OnDISPINFO()
         LV_SETITEMCOUNT( oGrid:hLv, iMax )
         oGrid:refreshall()
      ELSE
         iMax := LEN( aMeta )
         FOR ii := 1 TO iMax
            aItem := { aMeta[ ii ] [ 1 ], aMeta[ ii ] [ 2 ], aMeta[ ii ] [ 3 ] }
            LV_ADDITEM( oGrid:hLv, aItem )
         NEXT
      ENDIF

      oGrid:Setfocus()
      IF !EMPTY( nStart )
         LV_SETITEMSELECT( oGrid:hLv, nStart )
      ENDIF

      oWnd:bKeyDown := { | nKey, nFlag | IF( nKey = VK_ESCAPE, oWnd:End(), nil ) }
      oWnd:oClient := oGrid

      oWnd:bResized := { | nType, nWidth, nHeight | oWnd:SetSize( 800, 800 ) }

#IFDEF __HMG__
   END WINDOW
#ENDIF

   ACTIVATE WINDOW oWnd ON INIT MakeTop( oWnd, oGrid ) CENTER

   FW_SetUnicode( .T. )                                               // SET back Unicode Mode
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function GetMetaData()
*+
*+    Called from ( property.prg )   1 - procedure showmoreproperty()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION GetMetaData( cPath, cFilename )

LOCAL aRet          := {}
LOCAL nItem, iMax := 333
LOCAL objShell      := CreateObject( "Shell.Application" )
LOCAL objFolder
LOCAL objFolderItem
LOCAL cFileInfo
LOCAL cHeaderInfo

   objFolder := objShell:Namespace( cPath )
   objFolderItem := objFolder:ParseName( cFilename )

   FOR nItem := 1 TO iMax
      cFileInfo := objFolder:GetDetailsOf( objFolderItem, nItem )
      cFileInfo := OnlySign( cFileInfo )

      cHeaderInfo := objFolder:GetDetailsOf( objFolder:Items, nItem )
      IF !EMPTY( cHeaderInfo ) .AND. !EMPTY( cFileInfo )
         AADD( aRet, { STRZERO( nItem, 3 ), TRIM( cHeaderInfo ), STRTRAN( TRIM( cFileInfo ), "?", "" ) } )
      ENDIF
   NEXT

   objFolderItem := NIL
   objFolder := NIL
   objShell := NIL

RETURN ACLONE( aRet )

*+--------------------------------------------------------------------
*+
*+    Static Function OnlySign()
*+
*+    Called from ( property.prg )   1 - static function getmetadata()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION OnlySign( cIn )

LOCAL cOut  := ""
LOCAL cSign, ii, iMax := LEN( cIn )

   FOR ii := 1 TO iMax
      cSign := SUBSTR( cIn, ii, 1 )
      IF ASC( cSign ) > 31
         cOut += cSign
      ELSE
         EXIT
      ENDIF
   NEXT
   cOut := SUBSTR( cOut + SPACE( 50 ), 1, 50 )
RETURN cOut

*+ EOF: PROPERTY.PRG
