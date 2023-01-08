*+--------------------------------------------------------------------
*+
*+ Source Module => c:\fwh\0\LISTVIEW\EVERYTH.PRG
*+
*+    Copyright(C) 1983-2022 by Auge & Ohr
*+
*+    Functions: Procedure SearchWithEverything()
*+               Static Function EverySearch()
*+               Function RECUDIRS()
*+
*+    Reformatted by Click! 2.05.40 on Jan-7-2023 at  1:29 am
*+
*+--------------------------------------------------------------------

#include "FiveWin.ch"
#include "Directry.ch"
#include "DLL.CH"
#include "EVERY.CH"

#define EM_SETSEL             0x00B1

STATIC aSearchItems := {}
STATIC hDLL

MEMVAR BFcolor, BGcolor, oFontDefault

DLL FUNCTION Everything_GetBuildNumber() AS LONG PASCAL FROM "Everything_GetBuildNumber" LIB hDll
DLL FUNCTION Everything_SetSearchA( cSearch AS LPSTR ) AS VOID PASCAL FROM "Everything_SetSearchA" LIB hDll
DLL FUNCTION Everything_QueryA( lWait AS BOOL ) AS BOOL PASCAL FROM "Everything_QueryA" LIB hDll
DLL FUNCTION Everything_GetNumResults() AS LONG PASCAL FROM "Everything_GetNumResults" LIB hDll
// need to check Parameter Type
DLL FUNCTION Everything_SetRequestFlags( nFlag AS DWORD ) AS VOID PASCAL FROM "Everything_SetRequestFlags" LIB hDll
DLL FUNCTION Everything_GetResultFullPathNameA( nNum AS _INT, cBuffer AS LPSTR, nSize AS _INT ) AS VOID PASCAL FROM "Everything_GetResultFullPathNameA" LIB hDll

*+--------------------------------------------------------------------
*+
*+    Procedure SearchWithEverything()
*+
*+    Called from ( dualgrid.prg )   1 - static procedure buildmainmenu()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE SearchWithEverything()

LOCAL oWnd, oListbox, oUseEveryThing, oText_1, oBtn
LOCAL a2List := {}
LOCAL cPath  := ""
LOCAL lUseIt := .T.

STATIC cFilter := "                              "

   DEFINE WINDOW oWnd FROM 0, 0 TO 800, 700 PIXEL TITLE "Search With Everything" ICON "A1MAIN" COLOR BFcolor, BGcolor NOMINIMIZE NOMAXIMIZE

      @ 004, 010 GET oText_1 VAR cFilter SIZE 360, 30 PIXEL PICTURE "@!" FONT oFontDefault OF oWnd        
      oText_1:PostMsg( EM_SETSEL, 0, LEN( TRIM( cFilter ) ) )

      @ 004, 380 CHECKBOX oUseEveryThing VAR lUseIt PROMPT "use Everything" SIZE 200, 24 PIXEL FONT oFontDefault OF oWnd
      SetWindowTheme( oUseEveryThing :hWnd, "", "" )

      @ 004, 600 BUTTON oBtn PROMPT "&OK" SIZE 080, 30 PIXEL FONT oFontDefault ACTION( EverySearch( cFilter, oListbox, lUseIt ) ) OF oWnd

      @ 40,  0 LISTBOX oListbox VAR cPath ITEMS a2List SIZE 700 - 20, 800 - 80 PIXEL FONT oFontDefault ;
              ON DBLCLICK( GoFindFile( cPath, oWnd ) ) ;
              OF oWnd COLOR BFcolor, BGcolor

      oListbox:bKeyDown := { | nKey, nFlag | IF( nKey = VK_RETURN, ( GoFindFile( cPath, oWnd ) ), nil ) }
      oWnd:bKeyDown := { | nKey, nFlag | IF( nKey = VK_ESCAPE, oWnd:End(), nil ) }

      oWnd:bResized := { | nType, nWidth, nHeight | oWnd:SetSize( 700, 800 ) }

#IFDEF __HMG__
   END WINDOW
#ENDIF

   oText_1:SetFocus()
   ACTIVATE WINDOW oWnd ON INIT MakeTop( oWnd, oText_1 ) CENTER

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function EverySearch()
*+
*+    Called from ( everyth.prg )   1 - procedure searchwitheverything()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION EverySearch( cText, oListbox, lUseIt )

LOCAL n, nNum, buf, nRet, bufsize := 250
LOCAL aResult := {}
LOCAL cAttr   := ""
LOCAL cItem
LOCAL oError, bSaveError
LOCAL cPath

   DEFAULT lUseIt := .T.

   aSearchItems := {}

   IF lUseIt = .T.
      bSaveError := ERRORBLOCK( { | oErr | BREAK( oErr ) } )
      BEGIN SEQUENCE

         IF EMPTY( hDll )
            IF IsWin64()
               hDll = LoadLibrary( "everything64.dll" )
            ELSE
               hDll = LoadLibrary( "everything32.dll" )
            ENDIF
         ENDIF

         IF EMPTY( hDll )
            BREAK
         ENDIF

         Everything_SetSearchA( cText )
         Everything_SetRequestFlags( nOr( EVERYTHING_REQUEST_PATH, EVERYTHING_REQUEST_FILE_NAME, EVERYTHING_REQUEST_SIZE ) )

         Everything_QueryA( .T. )
         nNum := Everything_GetNumResults()
         FOR n := 1 TO nNum
            buf := SPACE( bufsize )
            nRet := Everything_GetResultFullPathNameA( n, @buf, bufsize )
            AADD( aResult, UPPER( TRIM( buf ) ) )
         NEXT

         // sort it here
         aResult := ASORT( aResult )
         nNum := LEN( aResult )

         FOR n := 1 TO nNum
            cItem := aResult[ n ]
            cItem := STRTRAN( cItem, CHR( 0 ), "" )
            cItem := TRIM( cItem )
            IF EMPTY( cItem )
               LOOP
            ENDIF
            AADD( aSearchItems, cItem )
         NEXT

         oListbox:SetItems( aSearchItems )
         oListbox:refresh()

      RECOVER USING oError
         ERRORBLOCK( bSaveError )
         MsgInfo( "Error EverySearch()" )

      END SEQUENCE
      ERRORBLOCK( bSaveError )

   ELSE
      SearchRecursive( cText, cAttr )

      aSearchItems := ASORT( aSearchItems )
      oListbox:SetItems( aSearchItems )
      oListbox:refresh()

   ENDIF

RETURN .T.

*+--------------------------------------------------------------------
*+
*+    Function RECUDIRS()
*+
*+    Called from ( dualgrid.prg )   1 - procedure searchrecursive()
*+                ( everyth.prg )   1 - function recudirs()
*+
*+--------------------------------------------------------------------
*+
FUNCTION RECUDIRS( cPath, cMask, cAttr )

LOCAL c_File
LOCAL n_Size
LOCAL c_Attr
LOCAL a_DIR
LOCAL n_LEN
LOCAL n_Count
LOCAL nSum    := 0
LOCAL cTemp, aFiles, ii, iMax, a_File := {}

   a_DIR := DIRECTORY( cPath + "*.*", "D" )
   n_LEN := LEN( a_DIR )

   FOR n_Count := 1 TO n_LEN
      c_File := a_DIR[ n_Count, F_NAME ]
      c_Attr := a_DIR[ n_Count, F_ATTR ]

      IF "D" $ c_Attr .AND. .NOT. ( c_File = "." .OR. c_File = ".." )
         RECUDIRS( cPath + c_File + "\", cMask, cAttr )
      ENDIF
   NEXT

   a_DIR := DIRECTORY( cPath + cMask )
   n_LEN := LEN( a_DIR )

   FOR n_Count := 1 TO n_LEN
      c_File := a_DIR[ n_Count, F_NAME ]
      c_Attr := a_DIR[ n_Count, F_ATTR ]
      n_Size := a_DIR[ n_Count, F_SIZE ]

      IF "D" $ c_Attr
      ELSE
         AADD( aSearchItems, cPath + c_File )
         nSum += n_Size
      ENDIF
   NEXT

RETURN nSum

*+ EOF: EVERYTH.PRG
