*+--------------------------------------------------------------------
*+
*+ Source Module => c:\fwh\0\LISTVIEW\HBEJECT.PRG
*+
*+    Copyright(C) 1983-2022 by Auge & Ohr
*+
*+    Functions: Procedure USBeject()
*+               Static Procedure EjectMedia()
*+               Function SHELLOPENFILE()
*+
*+    Reformatted by Click! 2.05.40 on Jan-7-2023 at  1:29 am
*+
*+--------------------------------------------------------------------

#include "FIVEWIN.ch"
#include "common.ch"
#include "dll.ch"

#include "EJECTDLL.CH"

MEMVAR oFontDefault
MEMVAR oFontBig
MEMVAR BFcolor, BGcolor

*+--------------------------------------------------------------------
*+
*+    Procedure USBeject()
*+
*+    Called from ( dualgrid.prg )   1 - static procedure buildmainmenu()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE USBeject( nIcoLarge, nIcoSmall )

LOCAL oDlg, oListbox, oIco
LOCAL cDrive       := SPACE( 2 )
LOCAL cTitle       := "Please, select"
LOCAL aDrives      := FillDriveArray()
LOCAL nStyle       := CBS_SIMPLE
LOCAL acItem
LOCAL acBitmaps
LOCAL acType
LOCAL bChange
LOCAL bValid
LOCAL bLDblClicked
LOCAL bWhen
LOCAL bDrawItem
LOCAL ii, iMax
LOCAL oImageList, iImage, iImage_0, aItem, nFirstUSB := 0
LOCAL oGrid, oBmp1
LOCAL cMsg         := ""
LOCAL lPixel       := .T.
LOCAL lDesign      := .F.
LOCAL lChkBoxes    := .F.
LOCAL lDispInfo    := .F.
LOCAL aHeader      := {}
LOCAL nOption      := 1
LOCAL bAction      := { | x | cDrive := acItem[ x ] }

   DEFAULT nIcoLarge := 256                                           // 32
   DEFAULT nIcoSmall := 32                                            // 16

   acItem := aDrives[ 1 ]
   acBitmaps := aDrives[ 2 ]
   acType := aDrives[ 3 ]
   nFirstUSB := aDrives[ 4 ]

   DEFINE WINDOW oDlg FROM 0, 0 TO 400, 450 PIXEL TITLE cTitle ICON "A1MAIN" COLOR BFcolor, BGcolor NOMINIMIZE NOMAXIMIZE

      oGrid := TGrid() :New( 0, 0,, bAction, oDlg, ;
                       BFcolor, BGcolor, lPixel, lDesign, ;
                       300, 350, cMsg, nIcoLarge, nIcoSmall, lChkBoxes, lDispInfo )

      AADD( aHeader, { "Drive", 200, 0, "C" } )
      AADD( aHeader, { "Type", 100, 0, "N" } )
      oGrid:aHeader := aHeader
      oGrid:aSource := aDrives[ 1 ]

      oGrid:CreateHeaderColumn()

      IF oGrid:lDispInfo = .T.
         iMax := LEN( oGrid:aSource )
         // need for LVS_OWNERDATA / ::OnDISPINFO()
         LV_SETITEMCOUNT( oGrid:hLv, iMax )
         oGrid:refreshall()
      ELSE
         iMax := LEN( aDrives[ 1 ] )
         FOR ii := 1 TO iMax
            aItem := { acItem[ ii ], STR( acType[ ii ] ) }

            oBmp1 := TBitmap() :Define( acBitmaps[ ii ],, oDlg )

            // "only" add "small"
            iImage := oGrid:oImageListSmall:Add( oBmp1 )
            // iImage_0 := MAX( 0, oGrid:oImageListBig:Add( oBmp1))

            LV_ADDITEMS( oGrid:hLv, aItem, iImage )

            DeleteObject( iImage )
            DeleteObject( oBmp1 )
         NEXT
      ENDIF

      oGrid:Setfocus()
      IF !EMPTY( nFirstUSB )
         LV_SETITEMSELECT( oGrid:hLv, nFirstUSB )
      ELSE
         MsgInfo( "no removeable Drive" )
      ENDIF

      oGrid:bClick := { | nItem | EjectMedia( cDrive ), oDlg:End() }

      @ 000, 304 BUTTON "&OK" OF oDlg SIZE 120, 160 PIXEL FONT oFontDefault ;
              ACTION( EjectMedia( cDrive ), oDlg:End() )              // DEFAULT

      @ 190, 304 BUTTON "&Cancel" OF oDlg SIZE 120, 160 PIXEL FONT oFontDefault ;
              ACTION( cDrive := nil, oDlg:End() )

#IFDEF __HMG__
   END WINDOW
#ENDIF

   oDlg:bKeyDown := { | nKey, nFlag | IF( nKey = VK_ESCAPE, oDlg:End(), IF( nKey = VK_RETURN, ( EjectMedia( cDrive ), oDlg:End() ), nil ) ) }
   oDlg:bResized := { | nType, nWidth, nHeight | oDlg:SetSize( 450, 400 ) }

   ACTIVATE WINDOW oDlg CENTERED

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure EjectMedia()
*+
*+    Called from ( hbeject.prg )   3 - procedure usbeject()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE EjectMedia( cDriveLetter )

LOCAL cRoot   := "RUNDLL32.EXE "
LOCAL cPath   := GETENV( "TEMP" ) + "\"
LOCAL cAction := GETENV( "SYSTEMROOT" ) + "\SYSTEM32\HOTPLUG.DLL"

   cAction += ",HotPlugSafeRemovalDriveNotification "
   cAction += VOLUMENAME( cDriveLetter + ":\" )
   cAction += " ("
   cAction += cDriveLetter + ":)"

   IF EJECTREMOVABLE( cDriveLetter )                                  // in HB_FUNC.PRG
      // MsgInfo( "The Drive " + cDriveLetter + " Can be Safely Removed", "Atenttion ! , Remove USB Ok" )

      MEMOWRIT( cPath + "ShowMsg.BAT", cRoot + cAction )
      ShellOpenFile( cPath, "ShowMsg.BAT",,, SW_MINIMIZE )
      hb_IdleSleep( 2.0 )
      FERASE( cPath + "ShowMsg.BAT" )

   ELSE
      MsgInfo( "Failed to Safely Remove/Eject Drive " + cDriveLetter, "Atenttion ! , Failed Remove USB" )
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Function SHELLOPENFILE()
*+
*+    Called from ( hbeject.prg )   1 - static procedure ejectmedia()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SHELLOPENFILE( cPath, cFILE, cPara, cHome, nShow )

LOCAL lSuccess   := 0
LOCAL Retvar     := .F.
LOCAL bSaveError, oError

   DEFAULT cPath := ""
   DEFAULT cFILE := ""
   DEFAULT cPara := ""
   DEFAULT cHome := CURDIR()
   DEFAULT nShow := SW_NORMAL

   IF hb_OSIS64BIT()
      // disable before API Call
      DllCall( "Kernel32.dll", DLL_OSAPI, "Wow64EnableWow64FsRedirection", FALSE )
   ENDIF

   bSaveError := ERRORBLOCK( { | oError | BREAK( oError ) } )
   BEGIN SEQUENCE

      lSuccess := ShellExecute( 0, ;
                                "open", ;
                                cPath + cFILE, ;
                                cPara, ;
                                cHome, ;
                                nShow )

   RECOVER
   END SEQUENCE
   ERRORBLOCK( bSaveError )

   DO CASE

      CASE lSuccess > 32                                              // Aufruf erfolgreich
         Retvar := .T.

      CASE lSuccess = SE_ERR_NOASSOC                                  // Keine verknÂpfte Anwendung

         // Falls ShowOpenWithDialog = True, wird der Dialog
         // "”ffnen mit" fr diese Datei angezeigt:
         // Shell "RunDLL32 shell32.dll,OpenAs_RunDLL " & Filename

         DllCall( "shell32", DLL_OSAPI, "OpenAs_RunDLL", ;
                  0, ;
                  0, ;
                  cPath + cFile, ;
                  cPara, ;
                  0, ;
                  nShow )

         // Die Auswahlm”glichkeit wird als Erfolg gewertet:
         Retvar := .T.

      OTHERWISE
         // ShellExecute war erfolglos.
         // Boolean-Standardwert False zurckgeben
         DO CASE
            CASE lSuccess = SE_ERR_FNF
               MsgInfo( "File not found.", cPath + cFILE )
            CASE lSuccess = SE_ERR_PNF
               MsgInfo( "Path not found.", cPath + cFILE )
            CASE lSuccess = SE_ERR_ACCESSDENIED
               MsgInfo( "Access denied !", cPath + cFILE )
            CASE lSuccess = SE_ERR_OOM
               MsgInfo( "Out of memory !", cPath + cFILE )
            CASE lSuccess = SE_ERR_SHARE
               MsgInfo( "Cannot share an open file.", cPath + cFILE )
            CASE lSuccess = SE_ERR_ASSOCINCOMPLETE
               MsgInfo( "File association information not complete.", cPath + cFILE )
            CASE lSuccess = SE_ERR_DDETIMEOUT
               MsgInfo( "DDE operation timed out.", cPath + cFILE )
            CASE lSuccess = SE_ERR_DDEFAIL
               MsgInfo( "DDE operation failed.", cPath + cFILE )
            CASE lSuccess = SE_ERR_DDEBUSY
               MsgInfo( "DDE operation is busy.", cPath + cFILE )
         ENDCASE
         Retvar := .F.
   ENDCASE

   IF hb_OSIS64BIT()
      DllCall( "Kernel32.dll", DLL_OSAPI, "Wow64EnableWow64FsRedirection", TRUE )                                                           // enable again
   ENDIF

   Sysrefresh()

RETURN Retvar

*+ EOF: HBEJECT.PRG
