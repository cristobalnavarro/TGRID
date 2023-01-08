*+--------------------------------------------------------------------
*+
*+ Source Module => c:\fwh\0\LISTVIEW\SHELLAPP.PRG
*+
*+    Copyright(C) 1983-2022 by Auge & Ohr
*+
*+    Functions: Function SetAttr()
*+               Function DXE_CreateLink()
*+               Function DXE_ResolveLink()
*+               Static Function GetWinMsc()
*+               Procedure FuncMSCFolder()
*+               Static Procedure DoRunMsc()
*+               Procedure FuncSysFolder()
*+               Static Function WinSysFolder()
*+
*+    Reformatted by Click! 2.05.40 on Jan-7-2023 at  1:29 am
*+
*+--------------------------------------------------------------------

#include "FIVEWIN.CH"
#include "common.ch"
#include "Directry.ch"
#include "fileio.ch"
#include "dll.ch"

#include "DUALGRID.CH"
#include "CSIDL.CH"

#define SW_SHOW               5

MEMVAR BFcolor, BGcolor, oFontDefault

*+--------------------------------------------------------------------
*+
*+    Function SetAttr()
*+
*+    Called from ( dualgrid.prg )   1 - class texplorer
*+
*+--------------------------------------------------------------------
*+
FUNCTION SetAttr( cFileName, lArchive, lReadOnly, lHidden, lSystem, lChangeDT, cDate, cTime )

LOCAL nAttribute := 0, nError, dDate := CTOD( cDate )

   IF lArchive
      nAttribute := nOr( nAttribute, FILE_ATTRIBUTE_ARCHIVE )
   ENDIF
   IF lReadOnly
      nAttribute := nOr( nAttribute, FILE_ATTRIBUTE_READONLY )
   ENDIF
   IF lHidden
      nAttribute := nOr( nAttribute, FILE_ATTRIBUTE_HIDDEN )
   ENDIF
   IF lSystem
      nAttribute := nOr( nAttribute, FILE_ATTRIBUTE_SYSTEM )
   ENDIF

   IF lChangeDT
      IF !hb_FSetDateTime( cFileName, dDate, cTime )
         MsgInfo( "Invalid date/time for " + cFileName )
      ENDIF
   ENDIF

   nError := SetFAttr( cFileName, nAttribute )
   IF nError = - 5
      MsgInfo( "Access denied to file " + cFileName )
   ENDIF

RETURN nAttribute

*+--------------------------------------------------------------------
*+
*+    Function DXE_CreateLink()
*+
*+    Called from ( dualgrid.prg )   1 - class texplorer
*+
*+--------------------------------------------------------------------
*+
FUNCTION DXE_CreateLink( cLinkTarget, cLinkFile, cWorkingDir, cCmdArgs, cDescr, aHotKey, aIcon )

LOCAL lSuccess       := .F.
LOCAL nPosi          := 0
LOCAL cPath          := ""
LOCAL cFile          := ""
LOCAL cName          := ""
LOCAL oShell
LOCAL oFolder
LOCAL oStorageFolder
LOCAL oShellLink
LOCAL nHandle
LOCAL i, iMax
LOCAL nLoByte
LOCAL nHiByte

   DEFAULT cWorkingDir TO ""
   DEFAULT cCmdArgs TO ""
   DEFAULT cDescr TO ""
   DEFAULT aHotKey TO {}
   DEFAULT aIcon TO {}

   IF !EMPTY( cLinkTarget )
      nPosi := RAT( "\", cLinkFile )
      IF nPosi > 0
         cPath := SUBSTR( cLinkFile, 1, nPosi - 1 )
         cFile := SUBSTR( cLinkFile, nPosi + 1 )
      ENDIF

      // create empty file with 0 (zero) byte
      nHandle := FCREATE( cLinkFile, FC_NORMAL )
      FCLOSE( nHandle )
   ENDIF

   IF !EMPTY( cPath ) .AND. !EMPTY( cFile ) .AND. FILE( cLinkFile )
      oShell := CreateObject( "shell.application" )
      oFolder := oShell:NameSpace( cPath )
      oStorageFolder := oFolder:ParseName( cFile )

      IF !EMPTY( oStorageFolder )
         oShellLink := oStorageFolder:GetLink
         IF !EMPTY( oShellLink )
            // set Property
            oShellLink:Path := cLinkTarget
            oShellLink:WorkingDirectory := cWorkingDir
            oShellLink:Arguments := cCmdArgs
            oShellLink:Description := cDescr
            oShellLink:ShowCommand := 1

            // Shortcut Hotkey
            IF !EMPTY( aHotKey ) .AND. VALTYPE( aHotKey ) = "A"
               IF LEN( aHotKey ) = 2
                  nLoByte := aHotKey[ 1 ]
                  nHiByte := aHotKey[ 2 ]
               ENDIF
            ENDIF

            // Icon need Method
            IF !EMPTY( aIcon ) .AND. VALTYPE( aIcon ) = "A"
               IF LEN( aIcon ) = 2
                  oShellLink:SetIconLocation( aIcon[ 1 ], aIcon[ 2 ] )
               ENDIF
            ENDIF

            // now save
            oShellLink:Save( cLinkFile )

            lSuccess := .T.
         ENDIF
      ENDIF

      oShellLink := NIL
      oStorageFolder := NIL
      oFolder := NIL
      oShell := NIL

   ENDIF

RETURN lSuccess

*+--------------------------------------------------------------------
*+
*+    Function DXE_ResolveLink()
*+
*+--------------------------------------------------------------------
*+
FUNCTION DXE_ResolveLink( cFull )

LOCAL oShell
LOCAL oFolder
LOCAL oStorageFolder
LOCAL oShellLink
LOCAL cPath          := ""
LOCAL cItem          := ""
LOCAL nPosi          := 0
LOCAL cTarget        := ""
LOCAL cPara          := ""

   IF !EMPTY( cFull )
      nPosi := RAT( "\", cFull )
      IF nPosi > 0
         cPath := SUBSTR( cFull, 1, nPosi )
         cItem := SUBSTR( cFull, nPosi + 1 )

         oShell := CreateObject( "shell.application" )
         oFolder := oShell:NameSpace( cPath )
         oStorageFolder := oFolder:ParseName( cItem )

         IF !EMPTY( oStorageFolder )
            oShellLink := oStorageFolder:GetLink
            IF !EMPTY( oShellLink )
               cTarget := oShellLink:Path
               cPara := oShellLink:Arguments
            ENDIF
         ENDIF

         oStorageFolder := NIL
         oFolder := NIL
         oShell := NIL
      ENDIF
   ENDIF

RETURN cTarget + IF( EMPTY( cPara ), "", CHR( 0 ) + cPara )

*+--------------------------------------------------------------------
*+
*+    Static Function GetWinMsc()
*+
*+    Called from ( shellapp.prg )   1 - procedure funcmscfolder()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION GetWinMsc()

LOCAL aArray := {}

   AADD( aArray, { "compmgmt.msc               ", "Computer Verwaltung           ", "Computer administration       ", "ALL" } )
   AADD( aArray, { "devmgmt.msc                ", "Geräte Manager                ", "Device Management             ", "ALL" } )
   AADD( aArray, { "diskmgmt.msc               ", "Festplatten Verwaltung        ", "Disk management               ", "ALL" } )
   AADD( aArray, { "eventvwr.msc               ", "Ereigniss Anzeige             ", "Event display                 ", "ALL" } )
   AADD( aArray, { "services.msc               ", "Dienste                       ", "Services                      ", "ALL" } )
   AADD( aArray, { "wf.msc                     ", "Firewall                      ", "Firewall                      ", "ALL" } )
   AADD( aArray, { "fsmgmt.msc                 ", "Freigaben                     ", "Shared Folders                ", "ALL" } )
   AADD( aArray, { "printmanagement.msc        ", "Druck Verwaltung              ", "Print management              ", "W7" } )
   AADD( aArray, { "lusrmgr.msc                ", "Lokale Benutzer und Gruppen   ", "Local users and groups        ", "W7" } )
   AADD( aArray, { "perfmon.msc                ", "Leistungsüberwachung          ", "Performance Monitor           ", "W7" } )
   AADD( aArray, { "taskschd.msc               ", "Aufgabenplanung               ", "Task Scheduler                ", "W7" } )
   AADD( aArray, { "gpedit.msc                 ", "Groupmanager                  ", "Group Manager                 ", "W7" } )
   AADD( aArray, { "secpol.msc                 ", "Lokale Sicherheitsrichtlinien ", "Local security policies       ", "ALL" } )
   AADD( aArray, { "appwiz.cpl                 ", "Software Verwaltung           ", "Software management           ", "ALL" } )
   AADD( aArray, { "desk.cpl                   ", "Eigenschaften Anzeige         ", "Properties display            ", "ALL" } )
   AADD( aArray, { "main.cpl                   ", "Maus Eigenschaften            ", "Mouse, Fonts, Keyboard        ", "ALL" } )
   AADD( aArray, { "mmsys.cpl                  ", "Sound Eigenschaften           ", "Multimedia properties         ", "ALL" } )
   AADD( aArray, { "ncpa.cpl                   ", "Netzwerk Verbindungsübersicht ", "Network connection overview   ", "ALL" } )
   AADD( aArray, { "telefon.cpl                ", "Telefon / Modem Einstellungen ", "Telephone / modem settings    ", "ALL" } )
   AADD( aArray, { "timedate.cpl               ", "Datum / Uhrzeit Einstellungen ", "Date/Time properties          ", "ALL" } )
   AADD( aArray, { "powercfg.cpl               ", "Energieeinstellungen          ", "Power settings                ", "ALL" } )
   AADD( aArray, { "Firewall.cpl               ", "Windows Firewall              ", "Windows Firewall              ", "ALL" } )
   AADD( aArray, { "inetcpl.cpl                ", "Eigenschaften von Internet    ", "Internet properties           ", "ALL" } )
   AADD( aArray, { "intl.cpl                   ", "Region und Sprache            ", "Region and Language           ", "ALL" } )
   AADD( aArray, { "sysdm.cpl                  ", "Systemeigenschaften *         ", "System / Hardware wizard      ", "ALL" } )
   AADD( aArray, { "wscui.cpl                  ", "Sicherheits / Wartungs Center ", "Security / maintenance center ", "ALL" } )
   AADD( aArray, { "osk.exe                    ", "Bildschirmtastatur            ", "On Screen keyboard            ", "ALL" } )
   AADD( aArray, { "utilman.exe                ", "Hilfsprogramm Manager         ", "Utility manager               ", "ALL" } )
   AADD( aArray, { "perfmon.exe /res           ", "Ressourcenmonitor             ", "resource monitor              ", "ALL" } )
   AADD( aArray, { "charmap.exe                ", "Sonderzeichen                 ", "Character Map                 ", "ALL" } )
   AADD( aArray, { "shrpubw.exe                ", "Ordner freigeben              ", "Shared folder wizard          ", "ALL" } )
   AADD( aArray, { "magnify.exe                ", "Vergrösserungsglas            ", "Magnifying glass              ", "ALL" } )
   AADD( aArray, { "dccw.exe                   ", "Farbdarstellung               ", "Display Color Calibration     ", "ALL" } )
   AADD( aArray, { "explorer.exe               ", "Explorer                      ", "Explorer                      ", "ALL" } )
   AADD( aArray, { "notepad.exe                ", "Notepad                       ", "Notepad                       ", "ALL" } )
   AADD( aArray, { "calc.exe                   ", "Calculator                    ", "Calculator                    ", "ALL" } )
   AADD( aArray, { "cleanmgr.exe /lowdisk      ", "Dateiträger Bereinigung *     ", "Disk Cleanup                  ", "ALL" } )
   AADD( aArray, { "dfrgui.exe                 ", "Dateiträger Optimierung       ", "Disk Optimize                 ", "ALL" } )
   AADD( aArray, { "cmd.exe                    ", "Command shell/window          ", "Command shell/window          ", "ALL" } )
   AADD( aArray, { "ipconfig.exe               ", "IPConfig-find your IP details ", "IPConfig-find your IP details ", "ALL" } )
   AADD( aArray, { "magnify.exe                ", "Screen Magnifier              ", "Screen Magnifier              ", "ALL" } )
   AADD( aArray, { "mspaint.exe                ", "Paintbrush                    ", "Paintbrush                    ", "ALL" } )
   AADD( aArray, { "narrator.exe               ", "Windows Sprachausgabe         ", "Windows speech                ", "ALL" } )
   AADD( aArray, { "taskmgr.exe                ", "Task Manager                  ", "Task Manager                  ", "ALL" } )
   AADD( aArray, { "wordpad.exe                ", "Wordpad                       ", "Wordpad                       ", "ALL" } )
   AADD( aArray, { "stikynot.exe               ", "Notizzettel                   ", "Sticky Notes                  ", "W7" } )
   AADD( aArray, { "computerdefaults.exe       ", "Standard-Software wählen      ", "Select standard software      ", "W7" } )
   AADD( aArray, { "psr.exe                    ", "Windows-Probleme aufzeichnen  ", "Record Windows problems       ", "W7" } )
   AADD( aArray, { "iexpress.exe               ", "Selbstentpackendes Archiv     ", "Self-extracting archive       ", "W7" } )
   AADD( aArray, { "control.exe                ", "Systemsteuerrung              ", "Control Panel                 ", "ALL" } )
   AADD( aArray, { "control.exe folders        ", "Ordner Optionen               ", "Options folder                ", "ALL" } )
   AADD( aArray, { "control.exe fonts          ", "Font Manager                  ", "Font Manager                  ", "ALL" } )
   AADD( aArray, { "control.exe keyboard       ", "Keyboard Eigenschaften        ", "Keyboard properties           ", "ALL" } )
   AADD( aArray, { "control.exe userpasswords2 ", "Benutzer Konten Verwaltung    ", "User accounts management      ", "ALL" } )
   AADD( aArray, { "control.exe printers       ", "Geräte und Drucker            ", "Devices and printers          ", "W7" } )
   AADD( aArray, { "control.exe keyboard       ", "Tastatur Eigenschaften        ", "Keyboard properties           ", "W7" } )
   AADD( aArray, { "explorer.exe ms-settings:windowsupdate", "Windows Update", "Windows Update", "W10" } )
   AADD( aArray, { "TPM.msc                    ", "TPM Setup", "TPM Setup", "W10" } )

RETURN aArray

*+--------------------------------------------------------------------
*+
*+    Procedure FuncMSCFolder()
*+
*+    Called from ( dualgrid.prg )   1 - procedure main()
*+                                   1 - static procedure domykey()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE FuncMSCFolder()

LOCAL nCountry := HB_bitAND( GETKEYBOARDLAYOUT(), 0xFFFF )
LOCAL aFolder  := GetWinMsc()
LOCAL a2List   := {}
LOCAL nPosi    := 1
LOCAL i, iMax, aSort
LOCAL oWnd, oList_MSCFolder

   IF nCountry = 1031                                                 // German
      aSort := ASORT( aFolder,,, { | x, y | x[ 2 ] < y[ 2 ] } )
   ELSE
      aSort := ASORT( aFolder,,, { | x, y | x[ 3 ] < y[ 3 ] } )
   ENDIF

   ALTD()
   iMax := LEN( aSort )
   FOR i := 1 TO iMax
      IF nCountry = 1031                                              // German
         AADD( a2List, aSort[ i ] [ 2 ] )
      ELSE
         AADD( a2List, aSort[ i ] [ 3 ] )
      ENDIF
   NEXT

   IF hb_OSIS64BIT()
      // disable bevor API Call
      DllCall( "Kernel32.dll", DLL_OSAPI, "Wow64EnableWow64FsRedirection", FALSE )
   ENDIF

   DEFINE WINDOW oWnd FROM 0, 0 TO 755, 324 PIXEL TITLE "MSC " ICON "A1MAIN" COLOR BFcolor, BGcolor NOMINIMIZE NOMAXIMIZE

      @  0,  0 LISTBOX oList_MSCFolder VAR nPosi ITEMS a2List SIZE 300, 700 PIXEL FONT oFontDefault ;
              ON DBLCLICK( DoRunMsc( TRIM( aSort[ nPosi ] [ 1 ] ) ), oWnd:End() ) ;
              OF oWnd COLOR BFcolor, BGcolor

#IFDEF __HMG__
   END WINDOW
#ENDIF

   oWnd:bKeyDown := { | nKey, nFlag | IF( nKey = VK_RETURN, ( TRIM( DoRunMsc( aSort[ nPosi ] [ 1 ] ) ), oWnd:End() ), IF( nKey = VK_ESCAPE, oWnd:End(), nil ) ) }
   oWnd:oClient := oList_MSCFolder
   oWnd:bResized := { | nType, nWidth, nHeight | oWnd:SetSize( 324, 755 ) }

   ACTIVATE WINDOW oWnd ON INIT MakeTop( oWnd, oList_MSCFolder ) CENTER

   IF hb_OSIS64BIT()
      // enable again
      DLLCall( "Kernel32.dll", DLL_OSAPI, "Wow64EnableWow64FsRedirection", TRUE )
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoRunMsc()
*+
*+    Called from ( shellapp.prg )   2 - procedure funcmscfolder()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoRunMsc( cAction )

LOCAL nPosi, CEXE, CPARA

   DO CASE
      CASE EMPTY( TRIM( cAction ) )
         MsgInfo( "empty cAction" )
      CASE ".CPL" $ UPPER( cAction )
         WinExec( "RunDLL32.exe Shell32.DLL, Control_RunDLL " + cAction )
      CASE ".DLL" $ UPPER( cAction )
         ShellExecute( 0, "open", cAction,,, SW_SHOW )
      CASE ".MSC" $ UPPER( cAction )
         ShellExecute( 0, "open", cAction,,, SW_SHOW )
      CASE ".EXE" $ UPPER( cAction )
         nPosi := AT( " ", cAction )
         IF nPosi > 0
            cEXE := SUBSTR( cAction, 1, nPosi - 1 )
            cPara := SUBSTR( cAction, nPosi + 1, LEN( cAction ) - nPosi )
            ShellExecute( 0, "open", cEXE, cPara,, SW_SHOW )
         ELSE
            ShellExecute( 0, "open", cAction,,, SW_SHOW )
         ENDIF
   ENDCASE

RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure FuncSysFolder()
*+
*+    Called from ( dualgrid.prg )   1 - procedure main()
*+                                   1 - static procedure domykey()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE FuncSysFolder()

LOCAL aFolder := WinSysFolder()
LOCAL a2List  := {}
LOCAL i, iMax := LEN( aFolder )
LOCAL oWnd, oListbox, cPath

   FOR i := 1 TO iMax
      AADD( a2List, aFolder[ i ] [ 1 ] )
   NEXT

   DEFINE WINDOW oWnd FROM 0, 0 TO 600, 400 PIXEL TITLE "special Folder" ICON "A1MAIN" COLOR BFcolor, BGcolor NOMINIMIZE NOMAXIMIZE

      @  0,  0 LISTBOX oListbox VAR cPath ITEMS a2List SIZE 400, 600 PIXEL FONT oFontDefault ;
              ON DBLCLICK( GoSpecialFolder( TRIM( cPath ), aFolder ), oWnd:End() ) ;
              OF oWnd COLOR BFcolor, BGcolor

      oWnd:bKeyDown := { | nKey, nFlag | IF( nKey = VK_RETURN, ;
                         ( GoSpecialFolder( TRIM( cPath ), aFolder ), oWnd:End() ), ;
                         IF( nKey = VK_ESCAPE, oWnd:End(), nil ) ) }

      oWnd:bResized := { | nType, nWidth, nHeight | oWnd:SetSize( 400, 600 ) }
      oWnd:oClient := oListbox
#IFDEF __HMG__
   END WINDOW
#ENDIF

   ACTIVATE WINDOW oWnd ON INIT MakeTop( oWnd, oListbox ) CENTER

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function WinSysFolder()
*+
*+    Called from ( shellapp.prg )   1 - procedure funcsysfolder()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION WinSysFolder()

LOCAL aRet := {}
   AADD( aRet, { "Desktop           ", .T., "<desktop>                                                       ", CSIDL_DESKTOP } )
   AADD( aRet, { "Programs          ", .T., "Start Menu\Programs                                             ", CSIDL_PROGRAMS } )
   AADD( aRet, { "Personal          ", .T., "My Documents                                                    ", CSIDL_PERSONAL } )
   AADD( aRet, { "Favorites         ", .T., "<user name>\Favorites                                           ", CSIDL_FAVORITES } )
   AADD( aRet, { "Startup           ", .T., "Start Menu\Programs\Startup                                     ", CSIDL_STARTUP } )
   AADD( aRet, { "Recent            ", .T., "<user name>\Recent                                              ", CSIDL_RECENT } )
   AADD( aRet, { "SendTo            ", .T., "<user name>\SendTo                                              ", CSIDL_SENDTO } )
   AADD( aRet, { "StartMenu         ", .T., "<user name>\Start Menu                                          ", CSIDL_STARTMENU } )
   //    AADD( aRet, { "MyDocuments       ", .T., "logical 'My Documents' desktop icon                             ", CSIDL_MYDOCUMENTS } )
   AADD( aRet, { "MyMusic           ", .T., "'My Music' folder                                               ", CSIDL_MYMUSIC } )
   AADD( aRet, { "MyVideo           ", .T., "'My Videos' folder                                              ", CSIDL_MYVIDEO } )
   AADD( aRet, { "DesktopDir        ", .T., "<user name>\Desktop                                             ", CSIDL_DESKTOPDIRECTORY } )
   AADD( aRet, { "Nethood           ", .T., "<user name>\nethood                                             ", CSIDL_NETHOOD } )
   AADD( aRet, { "Fonts             ", .T., "windows\fonts                                                   ", CSIDL_FONTS } )
   AADD( aRet, { "Templates         ", .T., "                                                                ", CSIDL_TEMPLATES } )
   AADD( aRet, { "cmStartMenu       ", .T., "All Users\Start Menu                                            ", CSIDL_COMMON_STARTMENU } )
   AADD( aRet, { "cmPrograms        ", .T., "All Users\Start Menu\Programs                                   ", CSIDL_COMMON_PROGRAMS } )
   AADD( aRet, { "cmStartup         ", .T., "All Users\Startup                                               ", CSIDL_COMMON_STARTUP } )
   AADD( aRet, { "cmDesktop         ", .T., "All Users\Desktop                                               ", CSIDL_COMMON_DESKTOPDIRECTORY } )
   AADD( aRet, { "Appdata           ", .T., "<user name>\Application Data                                    ", CSIDL_APPDATA } )
   AADD( aRet, { "Printhood         ", .T., "<user name>\PrintHood                                           ", CSIDL_PRINTHOOD } )
   AADD( aRet, { "LocalAppData      ", .T., "<user name>\Local Settings\Applicaiton Data (non roaming)       ", CSIDL_LOCAL_APPDATA } )
   AADD( aRet, { "Altstartup        ", .T., "non localized startup                                           ", CSIDL_ALTSTARTUP } )
   AADD( aRet, { "cmAltStartup      ", .T., "non localized common startup                                    ", CSIDL_COMMON_ALTSTARTUP } )
   AADD( aRet, { "cmFavorites       ", .T., "                                                                ", CSIDL_COMMON_FAVORITES } )
   AADD( aRet, { "InternetCache     ", .T., "                                                                ", CSIDL_INTERNET_CACHE } )
   AADD( aRet, { "Cookies           ", .T., "                                                                ", CSIDL_COOKIES } )
   AADD( aRet, { "History           ", .T., "                                                                ", CSIDL_HISTORY } )
   AADD( aRet, { "cmAppdata         ", .T., "All Users\Application Data                                      ", CSIDL_COMMON_APPDATA } )
   AADD( aRet, { "Windows           ", .T., "GetWindowsDirectory()                                           ", CSIDL_WINDOWS } )
   AADD( aRet, { "System            ", .T., "GetSystemDirectory()                                            ", CSIDL_SYSTEM } )
   AADD( aRet, { "ProgramFiles      ", .T., "C:\Program Files                                                ", CSIDL_PROGRAM_FILES } )
   AADD( aRet, { "MyPictures        ", .T., "C:\Program Files\My Pictures                                    ", CSIDL_MYPICTURES } )
   AADD( aRet, { "Profile           ", .T., "USERPROFILE                                                     ", CSIDL_PROFILE } )
   AADD( aRet, { "cmProgramFiles    ", .T., "C:\Program Files\Common                                         ", CSIDL_PROGRAM_FILES_COMMON } )
   AADD( aRet, { "cmTemplates       ", .T., "All Users\Templates                                             ", CSIDL_COMMON_TEMPLATES } )
   AADD( aRet, { "cmDocuments       ", .T., "All Users\Documents                                             ", CSIDL_COMMON_DOCUMENTS } )
   AADD( aRet, { "cmAdminTools      ", .T., "All Users\Start Menu\Programs\Administrative Tools              ", CSIDL_COMMON_ADMINTOOLS } )
   AADD( aRet, { "AdminTools        ", .T., "<user name>\Start Menu\Programs\Administrative Tools            ", CSIDL_ADMINTOOLS } )
   AADD( aRet, { "cmMusic           ", .T., "All Users\My Music                                              ", CSIDL_COMMON_MUSIC } )
   AADD( aRet, { "cmPictures        ", .T., "All Users\My Pictures                                           ", CSIDL_COMMON_PICTURES } )
   AADD( aRet, { "cmVideo           ", .T., "All Users\My Video                                              ", CSIDL_COMMON_VIDEO } )
   AADD( aRet, { "Resources         ", .T., "Resource Direcotry                                              ", CSIDL_RESOURCES } )
   AADD( aRet, { "ResourcesLocalized", .T., "Localized Resource Direcotry                                    ", CSIDL_RESOURCES_LOCALIZED } )
   AADD( aRet, { "cmOemLinks        ", .T., "Links to All Users OEM specific apps                            ", CSIDL_COMMON_OEM_LINKS } )
   AADD( aRet, { "CdBurnArea        ", .T., "USERPROFILE\Local Settings\Application Data\Microsoft\CD Burning", CSIDL_CDBURN_AREA } )

RETURN aRet

*+ EOF: SHELLAPP.PRG
