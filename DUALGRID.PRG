*+--------------------------------------------------------------------
*+
*+ Source Module => c:\fwh\0\LISTVIEW\DUALGRID.PRG
*+
*+    Copyright(C) 1983-2022 by Auge & Ohr
*+
*+    Functions: Init Procedure MainInit()
*+               Procedure Main()
*+               Static Procedure LoadConfig()
*+               Static Procedure DoMyKey()
*+               Static Procedure BuildMainMenu()
*+               Static Procedure OpenComboSide()
*+               Static Procedure MakeFNbutton()
*+               Static Procedure DoResize()
*+               Static Procedure DoSplash()
*+               Static Procedure NowBuildGrid()
*+               Static Procedure DlgShow()
*+               Static Procedure SetTransparent()
*+               Static Procedure ShowHelp()
*+               Static Procedure ShowHistory()
*+               Static Procedure GoHistory()
*+               Static Procedure MakeNewFolder()
*+               Static Procedure DoCreateFolder()
*+               Static Procedure Change2Drive()
*+               Static Procedure SelectFiles()
*+               Static Procedure DoSetFilter()
*+               Static Procedure OnDeviceChange()
*+               Static Procedure CompareDir()
*+               Static Procedure DiffCompare()
*+               Static Procedure ItemMark()
*+               Static Procedure ItemUnMark()
*+               Static Procedure GodMode()
*+               Static Procedure Viewer()
*+               Static Procedure DoShowDBF()
*+               Static Procedure CalliPhone()
*+               Static Procedure NewTab()
*+               Static Procedure DelThisTab()
*+               Static Procedure UpDateInfo()
*+               Static Function DoClose()
*+               Static Function DoEndProco()
*+               Static Function GetAllDrive()
*+               Static Function BitsToDrive()
*+               Static Function WinExeError()
*+               Static Function Diskfree()
*+               Static Function DoSH3func()
*+               Static Function ShellFiles()
*+               Static Function NetConnect()
*+               Static Function NetDisconnect()
*+               Procedure MakeTop()
*+               Procedure SnapToCtrl()
*+               Procedure SayBar()
*+               Procedure GoSpecialFolder()
*+               Procedure GoFindFile()
*+               Procedure SearchRecursive()
*+               Function NumColor2RGB()
*+               Function SysColor2Num()
*+               Function RGB2Num()
*+               Function ColorDialog()
*+               Function HMS2Sec()
*+               Function CompareFile()
*+               Function Pathonly()
*+               Function Fileonly()
*+               Function FindName()
*+               Function FindExt()
*+               Function DriveNumber()
*+               Function EndwithSlash()
*+               Function AtInside()
*+               Function FillDriveArray()
*+               Function VAR2CHAR()
*+               Function onDummy()
*+               Class TExplorer
*+               Procedure TAB_CHANGE_LEFT()
*+               Procedure TAB_CHANGE_RIGHT()
*+
*+       Tables: USE (cPath+cFile) NEW VIA "DBFCDX" EXCLUSIVE
*+
*+    Reformatted by Click! 2.05.40 on Jan-7-2023 at  1:29 am
*+
*+--------------------------------------------------------------------

#include "FiveWin.ch"
#include "Directry.ch"
#include "fileio.ch"
#include "COMMON.CH"
#include "Splitter.ch"

#include "DUALGRID.CH"
#include "TGRID.CH"
//  #include "CSIDL.CH"

#xtranslate aDir_Left      => Stack_Left\[nDimLeft, 1]
#xtranslate _cGrid_Left     => Stack_Left\[nDimLeft, 2]
#xtranslate _oCombo_Left    => Stack_Left\[nDimLeft, 3]
#xtranslate oExpl_Left     => Stack_Left\[nDimLeft, 4]
#xtranslate oTab_Left      => Stack_Left\[nDimLeft, 5]
#xtranslate cPath_Left     => Stack_Left\[nDimLeft, 6]

#xtranslate aDir_Right     => Stack_Right\[nDimRight, 1]
#xtranslate _cGrid_Right    => Stack_Right\[nDimRight, 2]
#xtranslate _oCombo_Right   => Stack_Right\[nDimRight, 3]
#xtranslate oExpl_Right    => Stack_Right\[nDimRight, 4]
#xtranslate oTab_Right     => Stack_Right\[nDimRight, 5]
#xtranslate cPath_Right    => Stack_Right\[nDimRight, 6]

REQUEST DBFCDX
REQUEST DBFNTX

REQUEST HB_LANG_ES
REQUEST HB_LANG_EN
REQUEST HB_LANG_FR
REQUEST HB_LANG_PT
REQUEST HB_LANG_DEWIN
REQUEST HB_LANG_RUWIN
REQUEST HB_LANG_IT
REQUEST HB_LANG_PLWIN
REQUEST HB_LANG_EU
REQUEST HB_LANG_HR852
REQUEST HB_LANG_SLWIN
REQUEST HB_LANG_CSWIN

/********************************************
*
* use your HB_LANG_* and HB_CODEPAGE_*
*
********************************************/

//  REQUEST HB_LANG_ES
//  REQUEST HB_LANG_EN
//  REQUEST HB_LANG_FR
//  REQUEST HB_LANG_PT
REQUEST HB_LANG_DEWIN
//  REQUEST HB_LANG_RUWIN
//  REQUEST HB_LANG_IT
//  REQUEST HB_LANG_PLWIN
//  REQUEST HB_LANG_EU
//  REQUEST HB_LANG_HR852
//  REQUEST HB_LANG_SLWIN
//  REQUEST HB_LANG_CSWIN

//  REQUEST HB_CODEPAGE_BG866
//  REQUEST HB_CODEPAGE_BGISO
//  REQUEST HB_CODEPAGE_BGMIK
//  REQUEST HB_CODEPAGE_BGWIN
//  REQUEST HB_CODEPAGE_CS852
//  REQUEST HB_CODEPAGE_CS852C
//  REQUEST HB_CODEPAGE_CSISO
//  REQUEST HB_CODEPAGE_CSKAMC
//  REQUEST HB_CODEPAGE_CSWIN
REQUEST HB_CODEPAGE_DE850
REQUEST HB_CODEPAGE_DE850M
REQUEST HB_CODEPAGE_DEISO
REQUEST HB_CODEPAGE_DEWIN
//  REQUEST HB_CODEPAGE_DK865
//  REQUEST HB_CODEPAGE_EL437
//  REQUEST HB_CODEPAGE_EL737
//  REQUEST HB_CODEPAGE_ELISO
//  REQUEST HB_CODEPAGE_ELWIN
//  REQUEST HB_CODEPAGE_EN
//  REQUEST HB_CODEPAGE_ES850
//  REQUEST HB_CODEPAGE_ES850C
//  REQUEST HB_CODEPAGE_ES850M
//  REQUEST HB_CODEPAGE_ESISO
//  REQUEST HB_CODEPAGE_ESMWIN
//  REQUEST HB_CODEPAGE_ESWIN
//  REQUEST HB_CODEPAGE_FI850
//  REQUEST HB_CODEPAGE_FR850
//  REQUEST HB_CODEPAGE_FR850C
//  REQUEST HB_CODEPAGE_FR850M
//  REQUEST HB_CODEPAGE_FRISO
//  REQUEST HB_CODEPAGE_FRWIN
//  REQUEST HB_CODEPAGE_HE862
//  REQUEST HB_CODEPAGE_HEWIN
//  REQUEST HB_CODEPAGE_HR646
//  REQUEST HB_CODEPAGE_HR852
//  REQUEST HB_CODEPAGE_HRISO
//  REQUEST HB_CODEPAGE_HRWIN
//  REQUEST HB_CODEPAGE_HU852
//  REQUEST HB_CODEPAGE_HU852C
//  REQUEST HB_CODEPAGE_HUISO
//  REQUEST HB_CODEPAGE_HUWIN
//  REQUEST HB_CODEPAGE_IS850
//  REQUEST HB_CODEPAGE_IS861
//  REQUEST HB_CODEPAGE_IT437
//  REQUEST HB_CODEPAGE_IT850
//  REQUEST HB_CODEPAGE_IT850M
//  REQUEST HB_CODEPAGE_ITISB
//  REQUEST HB_CODEPAGE_ITISO
//  REQUEST HB_CODEPAGE_ITWIN
//  REQUEST HB_CODEPAGE_LT775
//  REQUEST HB_CODEPAGE_LTWIN
//  REQUEST HB_CODEPAGE_NL850
//  REQUEST HB_CODEPAGE_NL850M
//  REQUEST HB_CODEPAGE_NO865
//  REQUEST HB_CODEPAGE_PL852
//  REQUEST HB_CODEPAGE_PLISO
//  REQUEST HB_CODEPAGE_PLMAZ
//  REQUEST HB_CODEPAGE_PLWIN
//  REQUEST HB_CODEPAGE_PT850
//  REQUEST HB_CODEPAGE_PT860
//  REQUEST HB_CODEPAGE_PTISO
//  REQUEST HB_CODEPAGE_RO852
//  REQUEST HB_CODEPAGE_ROISO
//  REQUEST HB_CODEPAGE_ROWIN
//  REQUEST HB_CODEPAGE_RU1251
//  REQUEST HB_CODEPAGE_RU866
//  REQUEST HB_CODEPAGE_RUISO
//  REQUEST HB_CODEPAGE_RUKOI8
//  REQUEST HB_CODEPAGE_SK852
//  REQUEST HB_CODEPAGE_SK852C
//  REQUEST HB_CODEPAGE_SKISO
//  REQUEST HB_CODEPAGE_SKKAMC
//  REQUEST HB_CODEPAGE_SKWIN
//  REQUEST HB_CODEPAGE_SL646
//  REQUEST HB_CODEPAGE_SL852
//  REQUEST HB_CODEPAGE_SLISO
//  REQUEST HB_CODEPAGE_SLWIN
//  REQUEST HB_CODEPAGE_SR646
//  REQUEST HB_CODEPAGE_SR646C
//  REQUEST HB_CODEPAGE_SRWIN
//  REQUEST HB_CODEPAGE_SV437C
//  REQUEST HB_CODEPAGE_SV850
//  REQUEST HB_CODEPAGE_SV850M
//  REQUEST HB_CODEPAGE_SVISO
//  REQUEST HB_CODEPAGE_SVWIN
//  REQUEST HB_CODEPAGE_TR857
//  REQUEST HB_CODEPAGE_TRISO
//  REQUEST HB_CODEPAGE_TRWIN
//  REQUEST HB_CODEPAGE_UA1125
//  REQUEST HB_CODEPAGE_UA1251
//  REQUEST HB_CODEPAGE_UA866
//  REQUEST HB_CODEPAGE_UAKOI8
//  REQUEST HB_CODEPAGE_UTF16LE
//  REQUEST HB_CODEPAGE_UTF8
//  REQUEST HB_CODEPAGE_UTF8EX

STATIC lDebug       := .T.
STATIC aHistory     := {}
STATIC cDeviceEvent := ""
STATIC acBitmaps    := {}                                             // for ComboBox
STATIC acItem       := {}                                             // Image Combobox
STATIC acType       := {}
STATIC nFirstUSB    := 0
STATIC nIcoLarge    := 32                                             // 256
STATIC nIcoSmall    := 16                                             // 32
//  STATIC aSearchItems := {}
//  STATIC hDLL
STATIC oCombo_Left
STATIC oCombo_Right
STATIC oVol_Left
STATIC oVol_Right
STATIC l_Every      := .F.
STATIC l_InText     := .F.
STATIC l_InZip      := .F.

STATIC cVersion := "v0.1.86"

// ***************************************************************************
//  07.01.2023 v0.1.86 SHOWFILEPROPERTIES crash with SkinButtons()
//  06.01.2023 v0.1.85 PDF & clean-up CODE
//  05.01.2023 v0.1.84 LVS_OWNERDATA use in ShowMoreProperty()
//
//  31.12.2022 v0.1.82 RECUDIRS() if not Everything
//  30.12.2022 v0.1.81 Dark-Mode Menu
//  29.12.2022 v0.1.80 new ShowMoreProperty()
//  28.12.2022 v0.1.79 SnapToCtrl() now "in" MakeTop()
//  27.12.2022 v0.1.78 DelThisTab()
//  26.12.2022 v0.1.77 CTRL + T new TAB (TFolder)
//  25.12.2022 v0.1.76 BOOL EjectVolume()
//  24.12.2022 v0.1.75 bGotFocus := { || nGridFocus := No , UpDateInfo() }
//  23.12.2022 v0.1.74 ALT+T multi-TAB
//  19.12.2022 v0.1.73 ShowMoreProperty()
//  15.12.2022 v0.1.72 HBeject / Bitmap "small"
//  14.12.2022 v0.1.71 HBeject / TGrid() / Icon
//  01.12.2022 v0.1.70 DLL FUNCTION -> crash ...
//  30.11.2022 v0.1.69 Hbeject DLL
//  29.11.2022 v0.1.68 Device TREE / virtual Folder CopyHere()
//  28.11.2022 v0.1.67 iPhone / TGrid open all Sub-Folder
//  27.11.2022 v0.1.66 Phone2
//  26.11.2022 v0.1.65 Tree for Device
//  25.11.2022 v0.1.64 Codepage
//  24.11.2022 v0.1.63 Menu Color -> Dark-Mode
//  23.11.2022 v0.1.62 Network Connect
//  22.11.2022 v0.1.61 Everything Search
//  21.11.2022 v0.1.60 F2 CSIDL Folder / HB_FUNC( C_GETSPECIALFOLDER )
//  20.11.2022 v0.1.59 USB-Stick DBT_DEVICEARRIVAL / DBT_DEVICEREMOVECOMPLETE
//  19.11.2022 v0.1.58 TGrid:ClearAndFillDir( oDlg ) / SetGridHeaderSort( nCol )
//  18.11.2022 v0.1.57 F11 FuncMSCFolder()
//  17.11.2022 v0.1.56 go64 MSVC 64 Bit
//  16.11.2022 v0.1.55 using *.MAK BCC7, Windows Attribut
//  15.11.2022 v0.1.54 SnapToCtrl()
//  14.11.2022 v0.1.53 METHOD -> FUNCTION Change2Drive
//  13.11.2022 v0.1.52 HScroll / VScroll( nWParam, nLParam ) VIRTUAL
//  12.11.2022 v0.1.51 Volumn Info and free Diskspace
//  11.11.2022 v0.1.50 "block" WM_SYSCOMMAND in TGrid:HandleEvent()
//  10.11.2022 v0.1.49 INI : STARTPATH
//  09.11.2022 v0.1.48 DoSplash() switch Parent for Progressbar
//  08.11.2022 v0.1.47 new "Save" INI
//  07.11.2022 v0.1.46 FO_COPY inclusive multi
//  06.11.2022 v0.1.45 ShellFiles()
//  05.11.2022 v0.1.44 SIZE_MINIMIZED / SIZE_RESTORED
//  04.11.2022 v0.1.42 Resize with SPLITTER
//  03.11.2022 v0.1.41 nPerPage -> LV_HIDEWINDOW( ::oGrid:hLv )
//  02.11.2022 v0.1.40 try SPLITTER ...
//  01.11.2022 v0.1.39 ALT+F1 -> ACCELERATOR ACC_ALT, 65648
//  31.10.2022 v0.1.38 METHOD Change2Drive(cString) CLASS TExplorer
//  30.10.2022 v0.1.35 Combobox : Drives with Image
//  29.10.2022 v0.1.34 Fn Button
//  28.10.2022 v0.1.33 #xtranslate oTab_Left, oTab_Right
//  27.10.2022 v0.1.30 METHOD RButtonDown() CLASS TGrid
//  26.10.2022 v0.1.29 Right Click Menu with Image
//  25.10.2022 v0.1.27 transparent Logo as Splash Screen. WaitRun()
//  24.10.2022 v0.1.25 1st Release
//
// ***************************************************************************

MEMVAR oMain
MEMVAR oStatusBar
MEMVAR oSayActive
MEMVAR aWin
MEMVAR Stack_Left
MEMVAR Stack_Right
MEMVAR nDimLeft
MEMVAR nDimRight
MEMVAR nGridFocus
MEMVAR oFontDefault
MEMVAR oFontBig
MEMVAR nFontBig
MEMVAR BFcolor, BGcolor
MEMVAR aMeta

*+--------------------------------------------------------------------
*+
*+    Init Procedure MainInit()
*+
*+--------------------------------------------------------------------
*+
INIT PROCEDURE MainInit()

LOCAL cTitle  := "FiveWin TGrid Listview Demo " + cVersion
LOCAL hWndDlg := FindWindowEx(,,, cTitle )
   IF !( hWndDlg == 0 )
      SetForegroundWindow( hWndDlg )
      BringWindowToTop( hWndDlg )
      ShowWindow( hWndDlg, 1 )
      UpdateWindow( hWndDlg )
      QUIT                                                            // It is a second instance. Bye Bye
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure Main()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE Main()

LOCAL cPath      := hb_Dirbase()
LOCAL nWidth     := 1280
LOCAL nHeight    := 1024
LOCAL nTop       := 0
LOCAL nLeft      := 0
LOCAL cLog       := cFileSetExt( ExeName(), "LOG" )
LOCAL nPart      := nWidth / nUseButton
LOCAL nFontSize  := 20
LOCAL aButton    := {}                                                // Array Fx Buttons
LOCAL cSayActive := ""
LOCAL lRet       := .T.
LOCAL oSplit, aRect
LOCAL nSizeType
LOCAL oRootLeft, oRootRight, oUpLeft, oUpRight
LOCAL cVol_Left  := ""
LOCAL cVol_Right := ""
LOCAL oFontSmall

   //------------------------------ CONFIG.INI -------------------------------

LOCAL cRow         := "0"
LOCAL cCol         := "0"
LOCAL cWidth       := "1280"
LOCAL cHeight      := "1024"
LOCAL cFontSize    := "20"
LOCAL cFontBig     := "20"
LOCAL cTransparent := "85"
LOCAL cTranslateCP := "DE"
LOCAL cLangCode    := "DEWIN"
LOCAL cCodepage    := "DEWIN"
LOCAL cStartLeft   := hb_Dirbase()
LOCAL cStartRight  := hb_Dirbase()
LOCAL cImageLeft   := "NO"
LOCAL cImageRight  := "NO"
LOCAL cVIEWLeft    := "1"
LOCAL cVIEWRight   := "1"
LOCAL cIcoLarge    := "32"
LOCAL cIcoSmall    := "16"
LOCAL cBGcolor
LOCAL cBFcolor

   //-------------------------------------------------------------------------

PRIVATE oMain
PRIVATE oStatusBar
PRIVATE oFontDefault
PRIVATE oFontBig
PRIVATE oSayActive
PRIVATE nFontBig     := 20
PRIVATE BGcolor      := RGB( 000, 000, 001 )                          // CLR_BLACK
PRIVATE BFcolor      := RGB( 025, 254, 255 )                          // CLR_CYAN

PUBLIC aWin        := {}                                              // hold all Window
PUBLIC Stack_Left  := {}                                              // Array Tab / Grid left
PUBLIC Stack_Right := {}                                              // Array Tab / Grid right
PUBLIC nDimLeft    := 0                                               // Layer in 2-DIM Array left
PUBLIC nDimRight   := 0                                               // Layer in 2-DIM Array right
PUBLIC nGridFocus  := 1                                               // 1=left, 2=right

   //  #define Use_Debug
#IFDEF Use_Debug
   SET ALTER ON
   SET ALTER TO "_LOGIT2.TXT "
#ENDIF

   FW_SetUnicode( .T. )                                               // use UniCode

   //------------------------------ load INI   -------------------------------

   cBGcolor := BGcolor
   cBFcolor := BFcolor

   LoadConfig( @cRow, @cCol, @cWidth, @cHeight, @cFontSize, @cFontBig, @cTranslateCP, @cTransparent, @cLangCode, @cCodepage, @cStartLeft, @cStartRight, @cImageLeft, @cImageRight, @cVIEWLeft, @cVIEWRight, @cIcoLarge, @cIcoSmall, @cBGcolor, @cBFcolor )

   BGcolor := cBGcolor
   BFcolor := cBFcolor

   nWidth := VAL( cWidth )
   nHeight := VAL( cHeight )
   nTop := VAL( cRow )
   nLeft := VAL( cCol )
   nFontSize := VAL( cFontSize )
   nFontBig := VAL( cFontBig )
   nIcoLarge := VAL( cIcoLarge )
   nIcoSmall := VAL( cIcoSmall )
   hb_LangSelect( cLangCode )
   hb_CDPSELECT( cCodepage )
   // hb_CDPSELECT( "UTF8")

   //-------------------------------------------------------------------------

   SET DATE GERMAN
   SET CENTURY ON
   //    FWLOG "Start"

   AADD( Stack_Left, ARRAY( 6 ) )
   nDimLeft := LEN( Stack_Left )
   cPath_Left := cStartLeft

   AADD( Stack_Right, ARRAY( 6 ) )
   nDimRight := LEN( Stack_Right )
   cPath_Right := cStartRight

   aDir_Left := DIRECTORY( cStartLeft + "*.*", "DHS" )
   aDir_Right := DIRECTORY( cStartRight + "*.*", "DHS" )

   GetAllDrive()

   //  SkinButtons() // crash with HB_FUNC(SHOWFILEPROPERTIES)

   DEFINE FONT oFontBig NAME "TAHOMA" SIZE 0, - nFontBig
      ACTIVATE FONT oFontBig
      DEFINE FONT oFontDefault NAME "TAHOMA" SIZE 0, - nFontSize
         ACTIVATE FONT oFontDefault
         DEFINE FONT oFontSmall NAME "TAHOMA" SIZE 0, - nFontSize / 3 * 2
            ACTIVATE FONT oFontSmall

#IFDEF __HMG__
         END FONT
      END FONT
   END FONT
#ENDIF

   DEFINE WINDOW oMain FROM - nHeight, - nWidth TO 0, 0 PIXEL TITLE "FiveWin TGrid Listview Demo " + cVersion ICON "A1MAIN" MENU BuildMainMenu() COLOR BFcolor, BGcolor

      oMain:lVisible := .F.
      oMain:hide()

      @ nHeight - 160, 10 SAY oSayActive PROMPT cSayActive FONT oFontDefault SIZE nWidth - 20, 30 PIXEL OF oMain         

      oRootLeft := TButton() :new( 4, ( nWidth / 2 ) - 74, " \", oMain,, 32, 32,, oFontDefault,, .T. )
      oUpLeft := TButton() :new( 4, ( nWidth / 2 ) - 40, "..", oMain,, 32, 32,, oFontDefault,, .T. )

      oRootRight := TButton() :new( 4, ( nWidth ) - 84, " \", oMain,, 32, 32,, oFontDefault,, .T. )
      oUpRight := TButton() :new( 4, ( nWidth ) - 50, "..", oMain,, 32, 32,, oFontDefault,, .T. )

      __ChangeStyleWindow( oRootLeft:hWnd, WS_TABSTOP,, .F. )
      __ChangeStyleWindow( oUpLeft :hWnd, WS_TABSTOP,, .F. )
      __ChangeStyleWindow( oRootRight:hWnd, WS_TABSTOP,, .F. )
      __ChangeStyleWindow( oUpRight :hWnd, WS_TABSTOP,, .F. )

      cVol_Left := VOLUMENAME( SUBSTR( cStartLeft, 1, 2 ) + "\" ) + SPACE( 5 ) + Diskfree( cStartLeft )
      cVol_Right := VOLUMENAME( SUBSTR( cStartRight, 1, 2 ) + "\" ) + SPACE( 5 ) + Diskfree( cStartRight )

      @  4, 100                  SAY oVol_Left PROMPT cVol_Left FONT oFontDefault SIZE( nWidth / 2 ) - 176, 30 PIXEL OF oMain           
      @  4, ( nWidth / 2 ) + 100 SAY oVol_Right PROMPT cVol_Right FONT oFontDefault SIZE( nWidth / 2 ) - 164, 30 PIXEL OF oMain         

      // ************************* left Side        **************************

      oCombo_left := TComboBox() :new( 0, 0,, acItem, 90, 300, oMain,,,, BFcolor, BGcolor, .T., oFontDefault,,,, .F., acBitmaps )
      oCombo_left:nDropWidth( 200 )
      oCombo_left:nItemHeight( 32 )
      oCombo_left:nSelectionHeight( 32 )
      oCombo_left:Select( DriveNumber( cStartLeft ) )
      oCombo_left:bKeyDown := { | nKey | IF( nKey = 13, Change2Drive( oCombo_left:GetSelText(), 1 ), nil ) }

      __ChangeStyleWindow( oCombo_left:hWnd, WS_TABSTOP,, .F. )

      oTab_Left := TFolder() :New( 40, 1, { "Grid_left1" },, oMain, 1, BFcolor, BGcolor, .T., .F., ( nWidth / 2 ) - 5, nHeight - 180,,, oFontDefault )
      oTab_Left:bChange := { || nDimLeft := oTab_Left:nOption }

#define Use_Explorer
#ifdef Use_Explorer
      oExpl_Left := TExplorer() :New( oTab_Left:aDialogs[ 1 ], 10, 0, ( nWidth / 2 ) - 20, nHeight - 220, cStartLeft, nIcoLarge, nIcoSmall )
      oExpl_Left:oGrid:bGotFocus := { || nGridFocus := 1, UpDateInfo( oExpl_Left:oGrid ) }

      oExpl_Left:oSayActive := oSayActive
      oExpl_Left:oVol_Info := oVol_Left
      oExpl_Left:oCombo_Info := oCombo_Left

      oExpl_Left:SetStyle( VAL( cVIEWLeft ) )
      IF cImageLeft = "YES"
         oExpl_Left:DoSwitchCheck()
      ENDIF

      oUpLeft:bAction := { || ( nGridFocus := 1, oExpl_Left:DoLastFolder( TRIM( oExpl_Left:oGrid:cPath ) ) ) }
      oRootLeft:bAction := { || ( nGridFocus := 1, oExpl_Left:DoNextFolder( SUBSTR( oExpl_Left:oGrid:cPath, 1, 3 ) ) ) }

#endif

      // ************************* right Side       **************************

      oCombo_Right := TComboBox() :new( 0, ( nWidth / 2 ) + 5,, acItem, 90, 300, oMain,,,, BFcolor, BGcolor, .T., oFontDefault,,,, .F., acBitmaps )
      oCombo_Right:nDropWidth( 200 )
      oCombo_Right:nItemHeight( 32 )
      oCombo_Right:nSelectionHeight( 32 )
      oCombo_Right:Select( DriveNumber( cStartRight ) )
      oCombo_Right:bKeyDown := { | nKey | IF( nKey = 13, Change2Drive( oCombo_Right:GetSelText(), 2 ), nil ) }

      __ChangeStyleWindow( oCombo_Right:hWnd, WS_TABSTOP,, .F. )

      oTab_Right := TFolder() :New( 40, ( nWidth / 2 ) + 5, { "Grid_right1" },, oMain, 1, BFcolor, BGcolor, .T., .F., ( nWidth / 2 ) - 10, nHeight - 180,,, oFontDefault )
      oTab_Right:bChange := { || nDimRight := oTab_Right:nOption }

#ifdef Use_Explorer
      oExpl_Right := TExplorer() :New( oTab_Right:aDialogs[ 1 ], 10, 0, ( nWidth / 2 ) - 20, nHeight - 220, cStartRight, nIcoLarge, nIcoSmall )
      oExpl_Right:oGrid:bGotFocus := { || nGridFocus := 2, UpDateInfo( oExpl_Right:oGrid ) }

      oExpl_Right:oSayActive := oSayActive
      oExpl_Right:oVol_Info := oVol_Right
      oExpl_Right:oCombo_Info := oCombo_Right

      oExpl_Right:SetStyle( VAL( cVIEWRight ) )
      IF cImageRight = "YES"
         oExpl_Right:DoSwitchCheck()
      ENDIF

      oUpRight:bAction := { || ( nGridFocus := 2, oExpl_Right:DoLastFolder( TRIM( oExpl_Right:oGrid:cPath ) ) ) }
      oRootRight:bAction := { || ( nGridFocus := 2, oExpl_Right:DoNextFolder( SUBSTR( oExpl_Right:oGrid:cPath, 1, 3 ) ) ) }
#endif

#define Use_Splitter
#ifdef Use_Splitter
      @  0, ( nWidth / 2 ) - 10 SPLITTER oSplit ;
              VERTICAL ;
              PREVIOUS CONTROLS oTab_Left ;
              HINDS CONTROLS oTab_Right ;
              LEFT MARGIN 200 ;
              RIGHT MARGIN 200 ;
              SIZE 8, nHeight - 68 PIXEL ;
              3DLOOK ;
              ON CHANGE DoResize( nSizeType, oSplit, aButton, oRootLeft, oRootRight, oUpLeft, oUpRight ) ;
              OF oMain
#endif

      MakeFNbutton( aButton )

      aButton[ 2 ] :bAction := { || FuncSysFolder() }
      aButton[ 3 ] :bAction := { || Viewer() }

      aButton[ 5 ] :bAction := { || IF( nGridFocus = 1, oExpl_Left:ASKFORM( "COPY" ), oExpl_Right:ASKFORM( "COPY" ) ) }
      aButton[ 6 ] :bAction := { || IF( nGridFocus = 1, oExpl_Left:ASKFORM( "MOVE" ), oExpl_Right:ASKFORM( "MOVE" ) ) }
      aButton[ 7 ] :bAction := { || MakeNewFolder() }
      aButton[ 8 ] :bAction := { || IF( nGridFocus = 1, oExpl_Left:ASKFORM( "DELETE" ), oExpl_Right:ASKFORM( "DELETE" ) ) }
      aButton[ 9 ] :bAction := { || ShowHistory() }

      aButton[ 11 ] :bAction := { || FuncMSCFolder() }

      DEFINE MESSAGE oStatusBar PROMPT "" OF oMain FONT oFontSmall KEYBOARD DATE CLOCK

#IFDEF __HMG__
      END MESSAGE
   END WINDOW
#ENDIF

   oMain:bKeyDown := { | nKey, nFlag | DoMyKey( nKey, nFlag, "Main", ;
                       IF( nGridFocus = 1, oExpl_Left, oExpl_Right ) ) }

   oMain:bOnDeviceChange := { | o, w, l | OnDeviceChange( o, w, l ), oMain:Refresh() }

   oTab_Left:SetOption( 1 )
   oTab_Right:SetOption( 1 )

   //   SETHELPFILE("HELP.TXT")
   //   SETKEY( VK_F1, { || ShowHelp() } )
   //   SetHelpFile( "FiveWin.hlp" )
   //   SetHelpFile( "HELP.TXT" )
   SetHelpFile( NIL )
   SETKEY( VK_F1, { || GodMode() } )

   ACTIVATE WINDOW oMain ON INIT DoSplash( nWidth, nHeight ) ;
           ON RESIZE DoResize( nSizeType, oSplit, aButton, oRootLeft, oRootRight, oUpLeft, oUpRight ) ;
           VALID ( lRet := DoEndProco( @aRect ), lRet ) CENTER

   //------------------------------ save INI   -------------------------------

   cRow := VAR2CHAR( aRect[ 1 ] )
   cCol := VAR2CHAR( aRect[ 2 ] )
   cHeight := VAR2CHAR( aRect[ 3 ] - aRect[ 1 ] )
   cWidth := VAR2CHAR( aRect[ 4 ] - aRect[ 2 ] )
   cFontSize := VAR2CHAR( oFontDefault:nHeight )
   cFontBig := VAR2CHAR( nFontBig )

   cBGcolor := BGcolor
   cBFcolor := BFcolor

   nDimLeft := 1
   nDimRight := 1
   cStartLeft := EndwithSlash( oExpl_Left :oGrid:cPath )
   cStartRight := EndwithSlash( oExpl_Right:oGrid:cPath )

   IF oExpl_Left:oGrid:lImage = .T.
      cImageLeft = "YES"
   ELSE
      cImageLeft = "NO"
   ENDIF
   IF oExpl_Right:oGrid:lImage = .T.
      cImageRight = "YES"
   ELSE
      cImageRight = "NO"
   ENDIF

   cVIEWLeft := LTRIM( STR( oExpl_Left:oGrid:nview ) )
   cVIEWRight := LTRIM( STR( oExpl_Right:oGrid:nview ) )

   FERASE( cPath + "Config.ini" )
   LoadConfig( cRow, cCol, cWidth, cHeight, cFontSize, cFontBig, cTranslateCP, cTransparent, cLangCode, cCodepage, cStartLeft, cStartRight, cImageLeft, cImageRight, cVIEWLeft, cVIEWRight, cIcoLarge, cIcoSmall, cBGcolor, cBFcolor )

   //-------------------------------------------------------------------------

#IFDEF Use_Debug
   SET ALTER TO
   SET ALTER OFF
   //  WinExec( "notepad" + " " + "_LOGIT2.TXT " )
#ENDIF

   IF !EMPTY( oFontBig )
      // oFont:End()
   ENDIF
   IF !EMPTY( oFontDefault )
      // oFontDefault:End()
   ENDIF

   IF !EMPTY( oStatusBar )
      oStatusBar:End()
   ENDIF
   IF !EMPTY( oMain )
      oMain:End()
   ENDIF

   // FWLOG "Ende"
   // WinExec( "notepad.exe " + cLog )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure LoadConfig()
*+
*+    Called from ( dualgrid.prg )   2 - procedure main()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE LoadConfig( cRow, cCol, cWidth, cHeight, cFontSize, cFontBig, cTranslateCP, cTransparent, cLangCode, cCodepage, cStartLeft, cStartRight, cImageLeft, cImageRight, cVIEWLeft, cVIEWRight, cIcoLarge, cIcoSmall, cBGcolor, cBFcolor )

LOCAL oINI
LOCAL cPath := hb_Dirbase()

   IF !FILE( cPath + "Config.ini" )
      INI oINI FILE cPath + "Config.ini"

      Set Section "MAINWINDOW" ENTRY "Row" TO cRow OF oINI
      Set Section "MAINWINDOW" ENTRY "Col" TO cCol OF oINI
      Set Section "MAINWINDOW" ENTRY "Width" TO cWidth OF oINI
      Set Section "MAINWINDOW" ENTRY "Height" TO cHeight OF oINI
      Set Section "MAINWINDOW" ENTRY "FontSize" TO cFontSize OF oINI
      Set Section "MAINWINDOW" ENTRY "FontBig" TO cFontBig OF oINI

      Set Section "TRANSLATEWINDOW" ENTRY "TranslateCP" TO cTranslateCP OF oINI

      Set Section "COUNTRY" ENTRY "LangCode" TO cLangCode OF oINI
      Set Section "COUNTRY" ENTRY "Codepage" TO cCodepage OF oINI

      Set Section "TRANSPARENCY" ENTRY "Transparency" TO cTransparent OF oINI

      Set Section "STARTPATH" ENTRY "StartLeft" TO cStartLeft OF oINI
      Set Section "STARTPATH" ENTRY "StartRight" TO cStartRight OF oINI
      Set Section "STARTPATH" ENTRY "ImageLeft" TO cImageLeft OF oINI
      Set Section "STARTPATH" ENTRY "ImageRight" TO cImageRight OF oINI
      Set Section "STARTPATH" ENTRY "VIEWLeft" TO cVIEWLeft OF oINI
      Set Section "STARTPATH" ENTRY "VIEWRight" TO cVIEWRight OF oINI
      Set Section "STARTPATH" ENTRY "IcoLarge" TO cIcoLarge OF oINI
      Set Section "STARTPATH" ENTRY "IcoSmall" TO cIcoSmall OF oINI

      Set Section "COLORS" ENTRY "BackgroundColor" TO cBGcolor OF oINI
      Set Section "COLORS" ENTRY "ForegroundColor" TO cBFcolor OF oINI

      ENDINI
   ELSE
      INI oINI FILE cPath + "Config.ini"

      GET cRow Section "MAINWINDOW" ENTRY "Row" OF oINI
      GET cCol Section "MAINWINDOW" ENTRY "Col" OF oINI
      GET cWidth Section "MAINWINDOW" ENTRY "Width" OF oINI
      GET cHeight Section "MAINWINDOW" ENTRY "Height" OF oINI
      GET cFontSize Section "MAINWINDOW" ENTRY "FontSize" OF oINI
      GET cFontBig Section "MAINWINDOW" ENTRY "FontBig" OF oINI

      GET cTranslateCP Section "TRANSLATEWINDOW" ENTRY "TranslateCP" OF oINI

      GET cLangCode Section "COUNTRY" ENTRY "LangCode" OF oINI
      GET cCodepage Section "COUNTRY" ENTRY "Codepage" OF oINI

      GET cTransparent Section "TRANSPARENCY" ENTRY "Transparency" OF oINI

      GET cStartLeft Section "STARTPATH" ENTRY "StartLeft" OF oINI
      GET cStartRight Section "STARTPATH" ENTRY "StartRight" OF oINI
      GET cImageLeft Section "STARTPATH" ENTRY "ImageLeft" OF oINI
      GET cImageRight Section "STARTPATH" ENTRY "ImageRight" OF oINI
      GET cVIEWLeft Section "STARTPATH" ENTRY "VIEWLeft" OF oINI
      GET cVIEWRight Section "STARTPATH" ENTRY "VIEWRight" OF oINI
      GET cIcoLarge Section "STARTPATH" ENTRY "IcoLarge" OF oINI
      GET cIcoSmall Section "STARTPATH" ENTRY "IcoSmall" OF oINI

      GET cBGcolor Section "COLORS" ENTRY "BackgroundColor" OF oINI
      GET cBFcolor Section "COLORS" ENTRY "ForegroundColor" OF oINI

      ENDINI
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoMyKey()
*+
*+    Called from ( dualgrid.prg )   1 - procedure main()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoMyKey( nKey, nFlag, cWho, oSelf )

   DO CASE
      CASE GetKeyState( VK_CONTROL ) .AND. ( nKey == ASC( "t" ) .OR. nKey == ASC( "T" ) )
         NewTab()

      CASE nKey = VK_F2
         FuncSysFolder()

      CASE nKey = VK_F3
         Viewer()

      CASE nKey = VK_F5
         oSelf:ASKFORM( "COPY" )

      CASE nKey = VK_F6
         oSelf:ASKFORM( "MOVE" )

      CASE nKey = VK_F7
         MakeNewFolder()

      CASE nKey = VK_F8
         oSelf:ASKFORM( "DELETE" )

      CASE nKey = VK_F9
         ShowHistory()

      CASE nKey = VK_F11
         FuncMSCFolder()

      CASE nKey = VK_F12
         MsgWait( "Hello world", "About HBFM", 2, oMain, { BFcolor, BGcolor } )

      CASE nKey = VK_ADD
         SelectFiles( "SELECT" )

      CASE nKey = VK_SUBTRACT
         SelectFiles( "UNSELECT" )

         //  OTHERWISE
         //     msginfo(var2char(nKey),var2char(nFlag))
   ENDCASE

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure BuildMainMenu()
*+
*+    Called from ( dualgrid.prg )   1 - procedure main()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE BuildMainMenu()

LOCAL oMenu, oItem1

   IF BGcolor = Rgb( 0, 0, 1 )
      MENU oMenu 2013 ;
              COLORMENU BGcolor, BFcolor ;
              COLORPNEL BFcolor, BGcolor ;
              COLORLEFT BFcolor, BGcolor ;
              COLORSELECT BFcolor, BGcolor, BFcolor
   ELSE
      MENU oMenu 2013 ;
              COLORMENU BGcolor, BFcolor ;
              COLORPNEL BFcolor, BGcolor ;
              COLORLEFT BFcolor, BGcolor ;
              COLORSELECT BFcolor, BFcolor, BGcolor
   ENDIF

   oMenu:oFont := oFontDefault

   MENUITEM "Action"
   MENU
   MENUITEM "&Left Side" + CHR( 9 ) + "ALT+F1" RESNAME "MYLEFTSIDE" ;
                                ACCELERATOR ACC_ALT, 65648 ;
                                ACTION OpenComboSide( "left" )

   MENUITEM "&Right Side" + CHR( 9 ) + "ALT+F2" RESNAME "MYRIGHTSIDE" ;
                                 ACCELERATOR ACC_ALT, 65649 ;
                                 ACTION OpenComboSide( "right" )

   SEPARATOR
   MENUITEM "Everything" + CHR( 9 ) + "ALT+F7" RESNAME "MYEVERY" ;
                                ACCELERATOR ACC_ALT, 65654 ;
                                ACTION SearchWithEverything()

   SEPARATOR
   MENUITEM "E&xit" + CHR( 9 ) + "ALT+F4" RESNAME "MYEXIT" ACTION oMain:End()
   ENDMENU

   MENUITEM "Color"
   MENU
   MENUITEM "Background" RESNAME "MYCOLORBG" ACTION( BGcolor := Colordialog( NumColor2RGB( BGcolor ), .T. ) )
   MENUITEM "Foreground" RESNAME "MYCOLORFG" ACTION( BFcolor := Colordialog( NumColor2RGB( BFcolor ), .T. ) )
   ENDMENU

   MENUITEM "Device"
   MENU
   MENUITEM "iPhone" RESNAME "MYPHONE" ACTION CalliPhone()
   SEPARATOR
   MENUITEM "eject Device" RESNAME "MYEJECTUSB" ACTION USBeject()
   ENDMENU

   MENUITEM "Network"
   MENU
   MENUITEM "&Connect" RESNAME "MYCONNECT" ACTION NetConnect()
   MENUITEM "&Disconnect" RESNAME "MYDISCONNECT" ACTION NetDisconnect()
   ENDMENU

   MENUITEM "Info"
   MENU
   MENUITEM "&Mail to author..." RESNAME "MYEMAIL" ;
           ACTION ShellExecute( 0, "open", "rundll32.exe", ;
           "url.dll,FileProtocolHandler " + ;
           "mailto:Auge_Ohr@Web.DE" + ;
           "&subject=DUALGRID%20" + cVersion + "%20Feedback:" + ;
           "&body=Hello%20World",, 1 )
   ENDMENU

   ENDMENU

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure OpenComboSide()
*+
*+    Called from ( dualgrid.prg )   2 - static procedure buildmainmenu()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE OpenComboSide( cSide )

   DO CASE
      CASE cSide = "left"
         oCombo_left:SetFocus()
         oCombo_left:Open()
      CASE cSide = "right"
         oCombo_Right:SetFocus()
         oCombo_Right:Open()
   ENDCASE

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure MakeFNbutton()
*+
*+    Called from ( dualgrid.prg )   1 - procedure main()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE MakeFNbutton( aButton )

LOCAL nHeight    := 1024
LOCAL nWidth     := 1280
LOCAL nPart      := nWidth / nUseButton
LOCAL nCol       := 0
LOCAL lMultiline := .T.
LOCAL bAction
LOCAL oBtn, ii

   bAction := { || MsgInfo( 'under Construction ... ' ) }

   oBtn := TButton() :new( nHeight - 132, nCol, "F1", oMain,, nPart - 4, 50,, oFontDefault,, .T. )
   oBtn:bAction := bAction
   AADD( aButton, oBtn )
   nCol += nPart

   oBtn := TButton() :new( nHeight - 132, nCol, "F2" + CRLF + "CSIDL", oMain,, nPart - 4, 50,, oFontDefault,, .T.,,,,,,,, lMultiline, )
   AADD( aButton, oBtn )
   nCol += nPart

   oBtn := TButton() :new( nHeight - 132, nCol, "F3" + CRLF + "Viewer", oMain,, nPart - 4, 50,, oFontDefault,, .T.,,,,,,,, lMultiline, )
   AADD( aButton, oBtn )
   nCol += nPart

   oBtn := TButton() :new( nHeight - 132, nCol, "F4", oMain,, nPart - 4, 50,, oFontDefault,, .T. )
   oBtn:bAction := bAction
   AADD( aButton, oBtn )
   nCol += nPart

   oBtn := TButton() :new( nHeight - 132, nCol, "F5" + CRLF + "copy", oMain,, nPart - 4, 50,, oFontDefault,, .T.,,,,,,,, lMultiline, )
   AADD( aButton, oBtn )
   nCol += nPart

   oBtn := TButton() :new( nHeight - 132, nCol, "F6" + CRLF + "Move", oMain,, nPart - 4, 50,, oFontDefault,, .T.,,,,,,,, lMultiline, )
   AADD( aButton, oBtn )
   nCol += nPart

   oBtn := TButton() :new( nHeight - 132, nCol, "F7" + CRLF + "Folder", oMain,, nPart - 4, 50,, oFontDefault,, .T.,,,,,,,, lMultiline, )
   AADD( aButton, oBtn )
   nCol += nPart

   oBtn := TButton() :new( nHeight - 132, nCol, "F8" + CRLF + "delete", oMain,, nPart - 4, 50,, oFontDefault,, .T.,,,,,,,, lMultiline, )
   AADD( aButton, oBtn )
   nCol += nPart

   oBtn := TButton() :new( nHeight - 132, nCol, "F9" + CRLF + "History", oMain,, nPart - 4, 50,, oFontDefault,, .T.,,,,,,,, lMultiline, )
   AADD( aButton, oBtn )
   nCol += nPart

   oBtn := TButton() :new( nHeight - 132, nCol, "F10", oMain,, nPart - 4, 50,, oFontDefault,, .T. )
   oBtn:bAction := bAction
   AADD( aButton, oBtn )
   nCol += nPart

   oBtn := TButton() :new( nHeight - 132, nCol, "F11" + CRLF + "MSC Func", oMain,, nPart - 4, 50,, oFontDefault,, .T.,,,,,,,, lMultiline, )
   AADD( aButton, oBtn )
   nCol += nPart

   IF nUseButton = 12
      oBtn := TButton() :new( nHeight - 132, nCol, "F12", oMain,, nPart - 4, 50,, oFontDefault,, .T. )
      oBtn:bAction := bAction
      AADD( aButton, oBtn )
      nCol += nPart
   ENDIF

   FOR ii := 1 TO LEN( aButton )
      __ChangeStyleWindow( aButton[ ii ] :hWnd, WS_TABSTOP,, .F. )
   NEXT

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoResize()
*+
*+    Called from ( dualgrid.prg )   2 - procedure main()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoResize( nSizeType, oSplit, aButton, oRootLeft, oRootRight, oUpLeft, oUpRight )

LOCAL nTop
LOCAL nBottom
LOCAL nRight
LOCAL nLeft
LOCAL nHeight
LOCAL nWidth
LOCAL nPart
LOCAL nLeftWidth
LOCAL nRightWidth
LOCAL ii, oBtn, nCol := 0
LOCAL oCtrol

STATIC lInit    := .T.
STATIC nPercent := 50

   LOCKWINDOWUPDATE( oMain:Hwnd )

   // ondummy(oMain:aControls)

   nWidth := oMain:nWidth                                             // 100 %

   DO CASE
      CASE nSizeType = SIZE_INIT
         lInit = .F.

      CASE nSizeType = SIZE_RESTORED .AND. !lInit
         oSplit:SetPosition( nWidth / 100 * nPercent )

      CASE nSizeType = SIZE_MINIMIZED
         RETURN

      CASE nSizeType = SIZE_MAXIMIZED
         oSplit:SetPosition( nWidth / 100 * nPercent )
   ENDCASE

   nPart := oMain:nWidth / 12

   // **************************** left side        **************************

   oCombo_Left:SetPos( 0, 0 )                                         // not need when 0,0

#ifdef Use_Splitter

   oSplit:AdjLeft()
   oSplit:nTop := 70

   oCtrol := oSplit:aPrevCtrols[ 1 ]
   nLeftWidth := oCtrol:nWidth
   nHeight := oCtrol:nHeight

   IF nLeftWidth > oMain:nWidth
      nLeftWidth := oMain:nWidth - 100
      oSplit:SetPosition( nLeftWidth )
   ENDIF

   oCtrol:nLeft := 0
   oCtrol:nRight := nLeftWidth - 10
   oCtrol:nTop := 40
   oCtrol:nBottom := nHeight - 140
   oCtrol:SetSize( nLeftWidth, nHeight - 120 )

#ELSE
   oTab_Left:SetPos( 40, 0 )
   oTab_Left:SetSize( nLeftWidth, nHeight - 100 )
#ENDIF

#ifdef Use_Explorer
   oExpl_Left:oGrid:SetPos( 10, 0 )
   oExpl_Left:oGrid:SetSize( nLeftWidth, nHeight - 160 )
#endif

   // use old nLeftWidth for Position
   oCombo_Right:SetPos( 0, nLeftWidth )

   // **************************** right side       **************************

#IFDEF Use_Splitter

   oSplit:AdjRight()
   oSplit:nTop := 70
   oSplit:nHeight := nHeight - 150

   oCtrol := oSplit:aHindCtrols[ 1 ]
   nRightWidth := oCtrol:nWidth
   nHeight := oCtrol:nHeight

   oCtrol:nLeft := nLeftWidth + 5
   oCtrol:nRight := nRightWidth - 10
   oCtrol:nTop := 40
   oCtrol:nBottom := nHeight - 140
   oCtrol:SetSize( nRightWidth, nHeight - 120 )

#ELSE
   oTab_Right:SetPos( 40, nRightWidth )
   oTab_Right:SetSize( nRightWidth, nHeight - 100 )
#ENDIF

#ifdef Use_Explorer
   oExpl_Right:oGrid:SetPos( 10, 0 )
   oExpl_Right:oGrid:SetSize( nRightWidth, nHeight - 160 )
#endif

   // **************************** NEED Left        **************************

#IFDEF Use_Splitter
   // need to set again ?!
   oTab_Left:SetPos( 40, 0 )
   oTab_Left:SetSize( nLeftWidth, nHeight - 120 )
#endif

   // **************************** SAY Activ        **************************

   nHeight := oMain:nHeight
   oSayActive:SetPos( nHeight - 160, 10 )

   // **************************** Volumn Button    **************************

   oVol_Left:SetPos( 4, 100 )
   oVol_Left:SetSize( nLeftWidth - 176, 30 )

   oVol_Right:SetPos( 4, nLeftWidth + 100 )
   oVol_Right:SetSize( nRightWidth - 164, 30 )

   // **************************** Root / Up Button **************************

   oRootLeft :SetPos( 4, nLeftWidth - 74 )
   oUpLeft:SetPos( 4, nLeftWidth - 40 )

   oRootRight:SetPos( 4, oMain:nWidth - 84 )
   oUpRight:SetPos( 4, oMain:nWidth - 50 )

   // **************************** Fx Button        **************************

   nWidth := oMain:nWidth
   nPart := nWidth / nUseButton

   FOR ii := 1 TO LEN( aButton )
      oBtn := aButton[ ii ]
      oBtn:SetPos( nHeight - 132, nCol )
      oBtn:SetSize( nPart - 4, 50 )

      nCol += nPart
   NEXT

   // **************************** refresh / repaint *************************

   LOCKWINDOWUPDATE( 0 )

   oMain:refresh()

   nWidth := oMain:nWidth                                             // 100 %
   nPercent := INT( ROUND( nLeftWidth / ( nWidth / 100 ), 0 ) )

   IF nPercent < 10
      nPercent := 10
   ELSEIF nPercent > 90
      nPercent := 90
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoSplash()
*+
*+    Called from ( dualgrid.prg )   1 - procedure main()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoSplash( nWinWidth, nWinHeight )

LOCAL oDlg, oSay, oFont, oBmp1, oBmp2, oBrush
LOCAL nWidth  := ScreenWidth()
LOCAL nHeight := ScreenHeight()
LOCAL nTop    := nHeight / 2
LOCAL nLeft   := nWidth / 2
LOCAL nSizeH  := 530
LOCAL nSizeW  := 300
LOCAL Hwnd, oRect, nLeftRect, nTopRect, nRightRect, nBottomRect, lhRgn, oImage

   oMain:hide()

   DEFINE BITMAP oBmp1 NAME "MYLOGO"
      DEFINE BITMAP oBmp2 NAME "MYAAAA"
         DEFINE BRUSH oBrush COLOR CLR_BLUE
            DEFINE FONT oFont NAME "TAHOMA" SIZE 0, - nFontBig
               ACTIVATE FONT oFont
#IFDEF __HMG__
            END FONT
         END BRUSH
      END BITMAP
   END BITMAP
#ENDIF

   nTop -= nSizeH / 2
   nLeft -= nSizeW / 2

   DEFINE WINDOW oDlg FROM nTop, nLeft TO nTop + nSizeH, nLeft + nSizeW PIXEL STYLE WS_POPUP BRUSH oBrush

#IFDEF __HMG__
   END WINDOW
#ENDIF

   ACTIVATE WINDOW oDlg CENTERED ;
           ON PAINT( PalBmpDraw( oDlg:hDC, 0, 0, oBmp2:hBitmap, 0, 0, 0, SRCPAINT ), ;
           PalBmpDraw( oDlg:hDC, 0, 0, oBmp1:hBitmap, 0, 0, 0, SRCAND ) ) ;
           ON INIT NowBuildGrid( oDlg, oBmp1, oBmp2, nSizeH, nSizeW )

   RELEASE FONT oFont
   RELEASE OBJECTS oBmp1, oBmp2, oBrush

   SysRefresh()
   oExpl_Left:oParent := oTab_Left:aDialogs[ 1 ]
   oExpl_Right:oParent := oTab_Right:aDialogs[ 1 ]

   oMain:SetSize( nWinWidth, nWinHeight, .F. )
   oMain:Show()
   oMain:SetFocus()

   oTab_Left:SetFocus()

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure NowBuildGrid()
*+
*+    Called from ( dualgrid.prg )   1 - static procedure dosplash()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE NowBuildGrid( oDlg, oBmp1, oBmp2, nSizeH, nSizeW )

   DlgShow( oDlg, oBmp1, oBmp2 )

#ifdef Use_Explorer
   oTab_Left:SetFocus()
   oExpl_Left:oParent := oDlg
   oExpl_Left:FillGrid( F_NAME, oDlg )
   LV_SETITEMSELECT( oExpl_Left:oGrid:hLv, 1 )

   oTab_Right:SetFocus()
   oExpl_Right:oParent := oDlg
   oExpl_Right:FillGrid( F_NAME, oDlg )
   LV_SETITEMSELECT( oExpl_Right:oGrid:hLv, 1 )

   oTab_Left:SetFocus()
#endif

   oDlg:End()
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DlgShow()
*+
*+    Called from ( dualgrid.prg )   1 - static procedure nowbuildgrid()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DlgShow( oDlg, oBmp1, oBmp2 )

   oDlg:nWidth := oBmp1:nWidth()
   oDlg:nheight := oBmp1:nHeight()

   oDlg:Center()
   oDlg:Hide()

   SetTransparent( oDlg )

   oDlg:Show()

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SetTransparent()
*+
*+    Called from ( dualgrid.prg )   1 - static procedure dlgshow()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SetTransparent( oDlg )

   SetWindowLong( oDlg:hWnd, GWL_EXSTYLE, NOR( GETWINDOWLONG( oDlg:hWnd, GWL_EXSTYLE ), WS_EX_LAYERED ) )
   SetLayerEDWindowAttributes( oDlg:hWnd, CLR_BLUE,, LWA_COLORKEY )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure ShowHelp()
*+
*+    Called from ( dualgrid.prg )   1 - static procedure showhelp()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE ShowHelp()

LOCAL oWnd, oBar

   SETKEY( VK_F1, nil )

   DEFINE WINDOW oWnd TITLE "Dual-Explorer Help"

      DEFINE BUTTONBAR oBar OF oWnd SIZE 50, 25
         oBar:SetColor( "N/W" )

         oWnd:bKeyChar = { | nKey | IF( nKey == VK_ESCAPE, oWnd:End(), ) }

#IFDEF __HMG__
      END BUTTONBAR
   END WINDOW
#ENDIF

   ACTIVATE DIALOG oWnd ;
           VALID ( SETKEY( VK_F1, { || ShowHelp() } ), .t. )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure ShowHistory()
*+
*+    Called from ( dualgrid.prg )   1 - procedure main()
*+                                   1 - static procedure domykey()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE ShowHistory()

LOCAL oWnd, oListbox, cPath

   DEFINE WINDOW oWnd FROM 0, 0 TO 600, 400 PIXEL TITLE "History" ICON "A1MAIN" COLOR BFcolor, BGcolor NOMINIMIZE NOMAXIMIZE

      @  0,  0 LISTBOX oListbox VAR cPath ITEMS aHistory SIZE 400, 600 PIXEL FONT oFontDefault ;
              ON DBLCLICK( GoHistory( cPath ), oWnd:End() ) ;
              OF oWnd COLOR BFcolor, BGcolor

      oWnd:bKeyDown := { | nKey, nFlag | IF( nKey = VK_RETURN, ;
                         ( GoHistory( cPath ), oWnd:End() ), ;
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
*+    Static Procedure GoHistory()
*+
*+    Called from ( dualgrid.prg )   2 - static procedure showhistory()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE GoHistory( cPath )

LOCAL cDrive, cVol_Info

   IF EMPTY( cPath )
      MsgInfo( "Empty cPath ?", "Error Path" )
      RETURN
   ENDIF

   cDrive := SUBSTR( cPath, 1, 2 )
   cVol_Info := VOLUMENAME( cDrive + "\" ) + SPACE( 5 ) + Diskfree( cDrive )
   IF nGridFocus = 1
      oCombo_left:Select( DriveNumber( cPath ) )
      oExpl_Left:oVol_Info:SetText( cVol_Info )
      oExpl_Left:DoNextFolder( cPath )
   ELSE
      oCombo_Right:Select( DriveNumber( cPath ) )
      oExpl_Right:oVol_Info:SetText( cVol_Info )
      oExpl_Right:DoNextFolder( cPath )
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure MakeNewFolder()
*+
*+    Called from ( dualgrid.prg )   1 - procedure main()
*+                                   1 - static procedure domykey()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE MakeNewFolder()

LOCAL cSourceDir := IF( nGridFocus = 1, oExpl_Left:oGrid:cPath, oExpl_Right:oGrid:cPath )
LOCAL cPath      := SPACE( 100 )
LOCAL oWnd, oLabel_1, oText_1, oBtn

   DEFINE WINDOW oWnd FROM 0, 0 TO 180, 300 PIXEL TITLE "Create New Folder" ICON "A1MAIN" COLOR BFcolor, BGcolor NOMINIMIZE NOMAXIMIZE

      @ 010, 010 SAY oLabel_1 PROMPT cSourceDir SIZE 260, 30 PIXEL FONT oFontDefault OF oWnd         
      @ 040, 010 GET oText_1 VAR cPath SIZE 260, 30 PIXEL FONT oFontDefault                          

      @ 080, 010 BUTTON oBtn PROMPT "&OK" SIZE 260, 50 PIXEL FONT oFontDefault ACTION( DoCreateFolder( cSourceDir, TRIM( cPath ) ), oWnd:End() ) OF oWnd

#IFDEF __HMG__
   END WINDOW
#ENDIF

   oWnd:bKeyDown := { | nKey, nFlag | IF( nKey = VK_RETURN, ;
                      ( Syswait( 0.1 ), DoCreateFolder( cSourceDir, TRIM( cPath ) ), oWnd:End() ), ;
                      IF( nKey = VK_ESCAPE, oWnd:End(), nil ) ) }

   oWnd:bResized := { | nType, nWidth, nHeight | oWnd:SetSize( 300, 180 ) }

   ACTIVATE WINDOW oWnd ON INIT MakeTop( oWnd, oText_1 ) CENTER

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoCreateFolder()
*+
*+    Called from ( dualgrid.prg )   2 - static procedure makenewfolder()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoCreateFolder( cSourceDir, cPath )

LOCAL lSuccess := lMkDir( cSourceDir + cPath )
   IF lSuccess
      IF nGridFocus = 1
         oExpl_Left:DoNextFolder( cSourceDir, cPath )
      ELSE
         oExpl_Right:DoNextFolder( cSourceDir, cPath )
      ENDIF
   ELSE
      MsgInfo( "Folder " + cSourceDir + cPath + " not create" )
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure Change2Drive()
*+
*+    Called from ( dualgrid.prg )   2 - procedure main()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE Change2Drive( cString, nNo )

LOCAL cVol_Info
LOCAL cPath
LOCAL cDrive    := SUBSTR( cString, 1, 2 )

   cVol_Info := VOLUMENAME( cDrive + "\" ) + SPACE( 5 ) + Diskfree( cDrive )

   cPath := cDrive + "\"
   nGridFocus := nNo

   IF nGridFocus = 1
      oExpl_Left:oVol_Info:SetText( cVol_Info )
      oExpl_Left:oGrid:setfocus()
      oExpl_Left:DoNextFolder( cPath )
   ELSE
      oExpl_Right:oVol_Info:SetText( cVol_Info )
      oExpl_Right:oGrid:setfocus()
      oExpl_Right:DoNextFolder( cPath )
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SelectFiles()
*+
*+    Called from ( dualgrid.prg )   2 - static procedure domykey()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SelectFiles( cWhat )

LOCAL oWnd, oText_1, oBtn
STATIC cFilter := "*.*"

   DEFAULT cWhat := "SELECT"

   cFilter += SPACE( 10 )

   DEFINE WINDOW oWnd FROM 0, 0 TO 150, 200 PIXEL TITLE cWhat + " files" ICON "A1MAIN" COLOR BFcolor, BGcolor NOMINIMIZE NOMAXIMIZE

      @ 010, 010 GET oText_1 VAR cFilter SIZE 160, 30 PIXEL FONT oFontDefault OF oWnd UPDATE         
      oText_1:PostMsg( EM_SETSEL, 0, LEN( TRIM( cFilter ) ) )

      @ 050, 010 BUTTON oBtn PROMPT "&OK" SIZE 160, 50 PIXEL FONT oFontDefault ACTION DoSetFilter( cFilter, cWhat ) OF oWnd

#IFDEF __HMG__
   END WINDOW
#ENDIF

   oWnd:bKeyDown := { | nKey, nFlag | IF( nKey = VK_RETURN, ( DoSetFilter( cFilter, cWhat ), oWnd:End() ), IF( nKey = VK_ESCAPE, oWnd:End(), nil ) ) }
   oWnd:bResized := { | nType, nWidth, nHeight | oWnd:SetSize( 200, 150 ) }

   ACTIVATE WINDOW oWnd ON INIT MakeTop( oWnd, oText_1 ) CENTER

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoSetFilter()
*+
*+    Called from ( dualgrid.prg )   2 - static procedure selectfiles()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoSetFilter( cFilter, cWhat )

LOCAL oGrid      := IF( nGridFocus = 1, oExpl_Left:oGrid, oExpl_Right:oGrid )
LOCAL cSourceDir := oGrid:cPath

   oGrid:cFilter := UPPER( TRIM( cFilter ) )

   DO CASE
      CASE cWhat = "SELECT"
         oGrid:MarkAll()
      CASE cWhat = "UNSELECT"
         oGrid:UnMarkAll()
   ENDCASE
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure OnDeviceChange()
*+
*+    Called from ( dualgrid.prg )   1 - procedure main()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE OnDeviceChange( oWnd, nWParam, nLParam )

LOCAL nInfo
LOCAL aDrives

   DO CASE
      CASE nWParam == 0x0018
         cDeviceEvent := "config changed"
         //
         // SysRefresh()
         // SysWait( 0.1 )
         // CheckDockStatus()
         // if lConvertible
         //    cDeviceEvent := If( lDocked, "DOCKED", "UNDOCKED" )
         // endif
         //
      CASE nWParam == 0x8000                                          // DBT_DEVICEARRIVAL
         cDeviceEvent := "device attached"
         nInfo := DeviceChangeInfo( nWParam, nLParam )
         IF !EMPTY( nInfo ) .AND. nInfo > 0
            cDeviceEvent := BitsToDrive( nInfo ) + "inserted"
         ENDIF
      CASE nWParam == 0x8004                                          // DBT_DEVICEREMOVECOMPLETE
         cDeviceEvent := "device removed"
         nInfo := DeviceChangeInfo( nWParam, nLParam )
         IF !EMPTY( nInfo ) .AND. nInfo > 0
            cDeviceEvent := BitsToDrive( nInfo ) + "removed"
         ENDIF
      OTHERWISE
   ENDCASE

   aDrives := GetAllDrive()

   oCombo_Left:SetItems( acItem, .T. )
   oCombo_Left:SetBitmaps( acBitmaps )
   IF ASCAN( aDrives, { | x | x = SUBSTR( oExpl_Left:oGrid:cPath, 1, 1 ) } ) > 0
      oCombo_left:Select( DriveNumber( oExpl_Left:oGrid:cPath ) )
   ELSE
      nGridFocus := 1
      oCombo_left:Select( DriveNumber( "C" ) )
      oExpl_Left:oGrid:cPath := "C:\"
      oExpl_Left:FillGrid()
      LV_SETITEMSELECT( oExpl_Left:oGrid:hLv, 1 )
   ENDIF

   oCombo_Right:SetItems( acItem, .T. )
   oCombo_Right:SetBitmaps( acBitmaps )
   IF ASCAN( aDrives, { | x | x = SUBSTR( oExpl_Right:oGrid:cPath, 1, 1 ) } ) > 0
      oCombo_Right:Select( DriveNumber( oExpl_Right:oGrid:cPath ) )
   ELSE
      nGridFocus := 2
      oCombo_Right:Select( DriveNumber( "C" ) )
      oExpl_Right:oGrid:cPath := "C:\"
      oExpl_Right:FillGrid()
      LV_SETITEMSELECT( oExpl_Right:oGrid:hLv, 1 )
   ENDIF

   oWnd:Refresh()

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure CompareDir()
*+
*+    Called from ( dualgrid.prg )   1 - class texplorer
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE CompareDir()

LOCAL nState   := hb_BitOr( LVIS_SELECTED, LVIS_FOCUSED )
LOCAL nMask    := hb_BitOr( LVIS_SELECTED, LVIS_FOCUSED )
LOCAL aSMarked := {}
LOCAL aTMarked := {}
LOCAL aSource
LOCAL aTarget
LOCAL nPosi, cName, nSize, dDate, cAttr, cTime
LOCAL ii, iMax
LOCAL jj, jMax
LOCAL hGridS
LOCAL hGridO

   DO CASE
      CASE nGridFocus = 1
         hGridS := oExpl_Left:oGrid:hWnd
         hGridO := oExpl_Right:oGrid:hWnd

         aSource := ACLONE( oExpl_Left:oGrid:aSource )
         aTarget := ACLONE( oExpl_Right:oGrid:aSource )

      CASE nGridFocus = 2
         hGridS := oExpl_Right:oGrid:hWnd
         hGridO := oExpl_Left:oGrid:hWnd

         aSource := ACLONE( oExpl_Right:oGrid:aSource )
         aTarget := ACLONE( oExpl_Left:oGrid:aSource )
   ENDCASE

   //  ------------------------------------------------------------------ *

   // first Target (while Focus stay on last)
   jMax := LEN( aTarget )
   FOR jj := 2 TO jMax
      cName := TRIM( aTarget[ jj ] [ F_NAME ] )
      nSize := aTarget[ jj ] [ F_SIZE ]
      dDate := aTarget[ jj ] [ F_DATE ]
      cTime := aTarget[ jj ] [ F_TIME ]
      cAttr := aTarget[ jj ] [ F_ATTR ]

      IF "D" $ cAttr
         LOOP
      ENDIF

      // check if Source exist
      nPosi := ASCAN( aSource, { | x | LOWER( x[ F_NAME ] ) = LOWER( cName ) } )
      IF nPosi > 0
         DO CASE
            CASE aSource[ nPosi ] [ F_SIZE ] < 2                      // old Dummy files

            CASE nSize <> aSource[ nPosi ] [ F_SIZE ]                 // Target Size is different
               ItemMark( hGridO, jj, nState, nMask )
               AADD( aTMarked, jj )

            CASE dDate <> aSource[ nPosi ] [ F_DATE ]                 // Target Date is different
               ItemMark( hGridO, jj, nState, nMask )
               AADD( aTMarked, jj )

            CASE dDate = aSource[ nPosi ] [ F_DATE ]                  // Target Date is same
               IF HMS2Sec( cTime ) > HMS2Sec( aSource[ nPosi ] [ F_TIME ] ) + 2
                  ItemMark( hGridO, jj, nState, nMask )
                  AADD( aTMarked, jj )
               ENDIF

            OTHERWISE
               DiffCompare( TIME(), ii, aSource[ ii ], nPosi, aTarget[ nPosi ] )
         ENDCASE
      ELSE
         ItemMark( hGridO, jj, nState, nMask )
         AADD( aTMarked, jj )
      ENDIF
   NEXT

   IF EMPTY( aTMarked )
      ItemUnMark( hGridO, - 1, 0, LVIS_FOCUSED )
   ENDIF

   //  ------------------------------------------------------------------ *

   // now Source. Focus stay on last which is Source
   iMax := LEN( aSource )
   FOR ii := 2 TO iMax
      cName := TRIM( aSource[ ii ] [ F_NAME ] )
      nSize := aSource[ ii ] [ F_SIZE ]
      dDate := aSource[ ii ] [ F_DATE ]
      cTime := aSource[ ii ] [ F_TIME ]
      cAttr := aSource[ ii ] [ F_ATTR ]

      // not want
      IF "D" $ cAttr
         LOOP
      ENDIF

      // check if Target exist
      nPosi := ASCAN( aTarget, { | x | LOWER( x[ F_NAME ] ) = LOWER( cName ) } )
      IF nPosi > 0
         DO CASE
            CASE aTarget[ nPosi ] [ F_SIZE ] < 2                      // old Dummy files

            CASE nSize <> aTarget[ nPosi ] [ F_SIZE ]                 // Source Size is different
               ItemMark( hGridS, ii, nState, nMask )
               AADD( aSMarked, ii )

            CASE dDate <> aTarget[ nPosi ] [ F_DATE ]                 // Source Date is different
               ItemMark( hGridS, ii, nState, nMask )
               AADD( aSMarked, ii )

            CASE dDate = aTarget[ nPosi ] [ F_DATE ]                  // Source Date is same

               // check if Source Time is newer
               IF HMS2Sec( cTime ) > HMS2Sec( aTarget[ nPosi ] [ F_TIME ] ) + 2
                  ItemMark( hGridS, ii, nState, nMask )
                  AADD( aSMarked, ii )
               ENDIF

            OTHERWISE                                                 // else ... when ?
               DiffCompare( TIME(), ii, aSource[ ii ], nPosi, aTarget[ nPosi ] )
         ENDCASE
      ELSE
         // get New File Position and mark it
         ItemMark( hGridS, ii, nState, nMask )
         AADD( aSMarked, ii )
      ENDIF
   NEXT

   IF EMPTY( aSMarked )
      ItemUnMark( hGridS, - 1, 0, LVIS_FOCUSED )
   ENDIF

   //  ------------------------------------------------------------------ *

   IF LEN( aSMarked ) = 0 .AND. LEN( aTMarked ) = 0
      MSGInfo( "no difference", "compare" )
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DiffCompare()
*+
*+    Called from ( dualgrid.prg )   2 - static procedure comparedir()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DiffCompare()

LOCAL iMax   := PCOUNT()
LOCAL i
LOCAL cText  := ""
LOCAL xValue

   FOR i := 1 TO iMax - 1
      cText += Var2Char( PValue( i ) ) + CHR( 9 )
   NEXT
   cText += Var2Char( PValue( iMax ) )

   MsgInfo( cText )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure ItemMark()
*+
*+    Called from ( dualgrid.prg )   8 - static procedure comparedir()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE ItemMark( hGrid, nPos, nState, nMask )

   DEFAULT nState TO hb_BitOr( LVIS_SELECTED, LVIS_FOCUSED )
   DEFAULT nMask TO hb_BitOr( LVIS_SELECTED, LVIS_FOCUSED )

   LV_SETITEMSTATE( hGrid, nPos, nState, nMask )
   LV_EnsureVisible( hGrid, nPos, .T. )
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure ItemUnMark()
*+
*+    Called from ( dualgrid.prg )   2 - static procedure comparedir()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE ItemUnMark( hGrid, nPos, nState, nMask )

   DEFAULT nState TO hb_BitOr( LVIS_SELECTED, LVIS_FOCUSED )
   DEFAULT nMask TO hb_BitOr( LVIS_SELECTED, LVIS_FOCUSED )

   LV_SETITEMSTATE( hGrid, nPos, 0, nMask )
   LV_EnsureVisible( hGrid, nPos, .T. )
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure GodMode()
*+
*+    Called from ( dualgrid.prg )   1 - procedure main()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE GodMode()

LOCAL cText
LOCAL oWSHShell
LOCAL bSaveError := ERRORBLOCK( { | oErr | BREAK( oErr ) } )

   cText := GETENV( "windir" )
   cText += "\explorer.exe shell:::{ED7BA470-8E54-465E-825C-99712043E01C}"

   BEGIN SEQUENCE
      oWSHShell := createobject( "wscript.shell" )
      oWSHShell:run( cText )

      oWSHShell:Destroy()
   END SEQUENCE
   ERRORBLOCK( bSaveError )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure Viewer()
*+
*+    Called from ( dualgrid.prg )   1 - procedure main()
*+                                   1 - static procedure domykey()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE Viewer()

LOCAL aItem, cPath, aSource, cFile := "", cExt

   IF nGridFocus = 1
      cPath := oExpl_Left:oGrid:cPath
      aItem := oExpl_Left:oGrid:Getdata()
      aSource := oExpl_Left:oGrid:aSource
   ELSE
      cPath := oExpl_Right:oGrid:cPath
      aItem := oExpl_Right:oGrid:Getdata()
      aSource := oExpl_Right:oGrid:aSource
   ENDIF

   IF EMPTY( aItem )
   ELSE
      IF VALTYPE( aItem ) = "A"
         cFile := aSource[ aItem[ 1 ] ] [ F_NAME ]
      ENDIF
   ENDIF

   cExt := UPPER( FindExt( cFile ) )

   DO CASE
      CASE cExt $ ".DBF"
         DoShowDBF( cPath, cFile )
      CASE cExt $ ".MSSTYLES.CJSTYLES"
      CASE cExt $ ".PRG.FMG.TXT.BAT.CMD.CH.LOG.HBP.HBC.HBM.RC.HDR.INI.ARC.XPJ.CPP.BAK.SDF.CSV.PPPm"
      CASE cExt $ ".PDF.EPUB.MOBI.FB2.CHM.XPS.DJVU"
      CASE cExt $ ".RTF"
      CASE cExt $ ".BMP.GIF.JPG.JPEG.TIF.TIFF.WMF.EMF.PNG"
      CASE cExt $ ".PSD.ICO.EXR.PCX.PPM.PSD.WEBP.JP2.PPM"
      CASE cExt $ ".HTM.HTML"
      CASE cExt $ ".H.C."
      CASE cExt $ ".XLS.XLSX"
   ENDCASE

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoShowDBF()
*+
*+    Called from ( dualgrid.prg )   1 - static procedure viewer()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoShowDBF( cPath, cFile )

LOCAL oWnd, oBrwDBF, oBar, cAlias
LOCAL nRec

   USE (cPath+cFile) NEW VIA "DBFCDX" EXCLUSIVE
   cAlias := ALIAS()

   DEFINE WINDOW oWnd FROM 0, 0 TO 1024, 1280 PIXEL TITLE "DBF " + cFile ICON "A1MAIN" COLOR BFcolor, BGcolor

      DEFINE BUTTONBAR oBar SIZE 96, 48 OF oWnd
         DEFINE BUTTON OF oBar PROMPT "&Codepage" ;
                    TOOLTIP "change Codepage" NOBORDER RESOURCE "MYWORLD" ;
                    ACTION( nRec := RECNO(), ;
                    ChangeCodePage( cPath, cFile, cAlias ), ;
                    oBrwDBF:Refresh(), ;
                    DBGOTO( nRec ) )

            @ 24,  0 XBROWSE oBrwDBF PIXEL OF oWnd ;
                    FONT oFontDefault ;
                    COLOR BFcolor, BGcolor ;
                    ALIAS cAlias AUTOCOLS CELL LINES NOBORDER FASTEDIT

            oWnd:bKeyDown := { | nKey, nFlag | IF( nKey = VK_ESCAPE, oWnd:End(), nil ) }

#IFDEF __HMG__
         END BUTTON
      END BUTTONBAR
   END WINDOW
#ENDIF
   oBrwDBF:nEditTypes := EDIT_GET
   oBrwDBF:CreateFromCode()

   oWnd:oClient := oBrwDBF
   ACTIVATE WINDOW oWnd VALID DoClose() CENTER

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure CalliPhone()
*+
*+    Called from ( dualgrid.prg )   1 - static procedure buildmainmenu()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE CalliPhone()

LOCAL cPath
   IF nGridFocus = 2
      cPath := oExpl_Left:oGrid:cPath
   ELSE
      cPath := oExpl_Right:oGrid:cPath
   ENDIF

   iPhoneWin( cPath )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure NewTab()
*+
*+    Called from ( dualgrid.prg )   1 - static procedure domykey()
*+                                   1 - class texplorer
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE NewTab()

LOCAL nStackNumber := 0
LOCAL cCaption     := "Page "
LOCAL cImageName   := "MYFIXDRIVE16"
LOCAL cInitPath    := ""
LOCAL nWidth       := 1280
LOCAL nHeight      := 1024
LOCAL oObj, aDirTemp
LOCAL oVolLeft, oComboLeft
LOCAL oVolRight, oComboRight

STATIC nPageLeft  := 1
STATIC nPageRight := 1

   nWidth := oMain:nWidth
   nHeight := oMain:nHeight

   IF nGridFocus = 1
      nStackNumber := LEN( Stack_Left )

      nStackNumber ++
      cCaption += LTRIM( STR( nStackNumber ) )

      // save
      oObj := oTab_Left
      cInitPath := cPath_Left
      aDirTemp := ACLONE( aDir_Left )
      oVolLeft := oExpl_Left:oVol_Info
      oComboLeft := oExpl_Left:oCombo_Info

      // new
      oTab_Left:AddItem( cCaption )

      // fill Stack
      AADD( Stack_Left, ARRAY( 6 ) )
      nDimLeft := LEN( Stack_Left )
      cPath_Left := cInitPath
      aDir_Left := ACLONE( aDirTemp )

      oTab_Left := oObj
      oTab_Left:bChange := { || nDimLeft := oTab_Left:nOption }

      // new Explorer
      oExpl_Left := TExplorer() :New( oTab_Left:aDialogs[ nDimLeft ], 10, 0, ( nWidth / 2 ) - 20, nHeight - 220, cInitPath, nIcoLarge, nIcoSmall )
      oExpl_Left:oGrid:bGotFocus := { || nGridFocus := 1, UpDateInfo( oExpl_Left:oGrid ) }

      oExpl_Left:oSayActive := oSayActive
      oExpl_Left:oVol_Info := oVolLeft
      oExpl_Left:oCombo_Info := oComboLeft

      oExpl_Left:oParent := oTab_Left:aDialogs[ nDimLeft ]
      oExpl_Left:FillGrid( F_NAME, oTab_Left:aDialogs[ nDimLeft ] )
      LV_SETITEMSELECT( oExpl_Left:oGrid:hLv, 1 )

   ELSE
      nStackNumber := LEN( Stack_Right )

      nStackNumber ++
      cCaption += LTRIM( STR( nStackNumber ) )

      // save
      oObj := oTab_Right
      cInitPath := cPath_Right
      aDirTemp := ACLONE( aDir_Right )
      oVolRight := oExpl_Right:oVol_Info
      oComboRight := oExpl_Right:oCombo_Info

      // new
      oTab_Right:AddItem( cCaption )

      // fill Stack
      AADD( Stack_Right, ARRAY( 6 ) )
      nDimRight := LEN( Stack_Right )
      cPath_Right := cInitPath
      aDir_Right := ACLONE( aDirTemp )

      oTab_Right := oObj
      oTab_Right:bChange := { || nDimRight := oTab_Right:nOption }

      // new Explorer
      oExpl_Right := TExplorer() :New( oTab_Right:aDialogs[ nDimRight ], 10, 0, ( nWidth / 2 ) - 20, nHeight - 220, cInitPath, nIcoLarge, nIcoSmall )
      oExpl_Right:oGrid:bGotFocus := { || nGridFocus := 2, UpDateInfo( oExpl_Right:oGrid ) }

      oExpl_Right:oSayActive := oSayActive
      oExpl_Right:oVol_Info := oVolRight
      oExpl_Right:oCombo_Info := oComboRight

      oExpl_Right:oParent := oTab_Right:aDialogs[ nDimRight ]
      oExpl_Right:FillGrid( F_NAME, oTab_Right:aDialogs[ nDimRight ] )
      LV_SETITEMSELECT( oExpl_Right:oGrid:hLv, 1 )

   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DelThisTab()
*+
*+    Called from ( dualgrid.prg )   1 - class texplorer
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DelThisTab()

LOCAL i, iMax, nPos
LOCAL nStackNumber := 0

   IF nGridFocus = 1
      nStackNumber := LEN( Stack_Left )
      IF nStackNumber > 1
         nPos := oTab_Left:nOption
         IF nPos <= nStackNumber
            oTab_Left:DelItemPos( nPos )
            ADEL( Stack_Left, nPos )
            ASIZE( Stack_Left, LEN( Stack_Left ) - 1 )
            IF nPos > LEN( Stack_Left )
               nDimLeft := LEN( Stack_Left )
            ELSE
               nDimLeft := nPos
            ENDIF
         ENDIF
      ENDIF
   ELSE

      nStackNumber := LEN( Stack_Right )
      IF nStackNumber > 1
         nPos := oTab_Right:nOption
         IF nPos <= nStackNumber
            oExpl_Right:Destroy()
            oTab_Right:DelItemPos( nPos )
            ADEL( Stack_Right, nPos )
            ASIZE( Stack_Right, LEN( Stack_Right ) - 1 )
            IF nPos > LEN( Stack_Right )
               nDimRight := LEN( Stack_Right )
            ELSE
               nDimRight := nPos
            ENDIF
         ENDIF
      ENDIF
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure UpDateInfo()
*+
*+    Called from ( dualgrid.prg )   2 - procedure main()
*+                                   2 - static procedure newtab()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE UpDateInfo( oGrid )

LOCAL cDrive, cVol_Info
LOCAL cPath, nRec, aItem

   cPath := oGrid:cPath
   aItem := oGrid:Getdata()

   cDrive := SUBSTR( cPath, 1, 2 )
   cVol_Info := VOLUMENAME( cDrive + "\" ) + SPACE( 5 ) + Diskfree( cDrive )

   IF nGridFocus = 1
      oCombo_left:Select( DriveNumber( cPath ) )
      oExpl_Left:oVol_Info:SetText( cVol_Info )

      oExpl_Left:oSayActive:SetText( oExpl_Left:cActiveFile )
   ELSE
      oCombo_Right:Select( DriveNumber( cPath ) )
      oExpl_Right:oVol_Info:SetText( cVol_Info )
      oExpl_Right:oSayActive:SetText( oExpl_Right:cActiveFile )
   ENDIF

   IF !EMPTY( aItem )
      nRec := aItem[ 1 ]
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function DoClose()
*+
*+    Called from ( dualgrid.prg )   1 - static procedure doshowdbf()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION DoClose()

   CLOSE ALL
RETURN .T.

*+--------------------------------------------------------------------
*+
*+    Static Function DoEndProco()
*+
*+    Called from ( dualgrid.prg )   1 - procedure main()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION DoEndProco( aRect )

LOCAL lRet := .T.
   aRect := oMain:GetRect()

   //  Everything
   //    IF !EMPTY( hDll )
   //       FreeLibrary( hDll )
   //    ENDIF
RETURN lRet

*+--------------------------------------------------------------------
*+
*+    Static Function GetAllDrive()
*+
*+    Called from ( dualgrid.prg )   1 - procedure main()
*+                                   1 - static procedure ondevicechange()
*+                                   1 - function filldrivearray()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION GetAllDrive()

LOCAL aDrives := aDrives()
LOCAL ii, cDrive, nType, cLabel, cBitmap

   acItem := {}
   acBitmaps := {}
   acType := {}
   nFirstUSB := 0

   FOR ii := 1 TO LEN( aDrives )
      cDrive := SUBSTR( aDrives[ ii ], 1, 1 )
      nType := GETDRIVETYPE( cDrive + ":" )
      cLabel := VOLUMENAME( cDrive + ":\" )
      DO CASE
         CASE nType = DRIVE_UNKNOWN
            cBitmap := "MYUNKNOWN16"

         CASE nType = DRIVE_NO_ROOT_DIR
            cBitmap := "MYFIXDRIVE16"

         CASE nType = DRIVE_REMOVABLE
            IF cDrive $ "AB"
               cBitmap := "MYFLOPPY16"                                // Floppy
            ELSE
               cBitmap := "MYUSBSTICK16"                              // DRIVE_REMOVABLE
               IF EMPTY( nFirstUSB )
                  nFirstUSB := ii
               ENDIF
            ENDIF

         CASE nType = DRIVE_FIXED
            IF cDrive = "C"
               cBitmap := "MYSYSDRIVE16"
            ELSE
               cBitmap := "MYFIXDRIVE16"
            ENDIF

         CASE nType = DRIVE_REMOTE
            cBitmap := "MYNETDRIVE16"

         CASE nType = DRIVE_CDROM
            cBitmap := "MYCDROM16"

         CASE nType = DRIVE_RAMDISK
            cBitmap := "MYRAMDISK16"

         OTHERWISE
            cBitmap := "MYUNKNOWN16"
      ENDCASE

      AADD( acItem, cDrive + ":" + SPACE( 3 ) + cLabel )
      AADD( acBitmaps, cBitmap )
      AADD( acType, nType )
   NEXT

RETURN aDrives

*+--------------------------------------------------------------------
*+
*+    Static Function BitsToDrive()
*+
*+    Called from ( dualgrid.prg )   2 - static procedure ondevicechange()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION BitsToDrive( nBitmap )

LOCAL n      := 0
LOCAL cDrive := ""

   DO WHILE nBitmap > 0
      IF nBitmap == 1
         cDrive := CHR( n + 65 ) + ": "
         EXIT
      ENDIF
      nBitmap := INT( nBitmap / 2 )
      n ++
   ENDDO

RETURN cDrive

*+--------------------------------------------------------------------
*+
*+    Static Function WinExeError()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION WinExeError()

LOCAL aError := {}
   AADD( aError, { 1, "System was out of memory, executable file was corrupt, or relocations were invalid." } )
   AADD( aError, { 2, "File was not found." } )
   AADD( aError, { 3, "Path was not found." } )
   AADD( aError, { 5, "Attempt was made to dynamically link to a task, or there was a sharing or network-protection error." } )
   AADD( aError, { 6, "Library required separate data segments for each task." } )
   AADD( aError, { 8, "There was insufficient memory to start the application." } )
   AADD( aError, { 10, "Windows version was incorrect." } )
   AADD( aError, { 11, "Executable file was invalid. Either it was not a Windows application or there was an error in the .EXE image." } )
   AADD( aError, { 12, "Application was designed for a different operating system." } )
   AADD( aError, { 13, "Application was designed for MS-DOS 4.0." } )
   AADD( aError, { 14, "Type of executable file was unknown." } )
   AADD( aError, { 15, "Attempt was made to load a real-mode application (developed for an earlier version of Windows)." } )
   AADD( aError, { 16, "Attempt was made to load a second instance of an executable file containing multiple data segments that were not marked read-only." } )
   AADD( aError, { 19, "Attempt was made to load a compressed executable file. The file must be decompressed before it can be loaded." } )
   AADD( aError, { 20, "Dynamic-link library (DLL) file was invalid. One of the DLLs required to run this application was corrupt." } )
   AADD( aError, { 21, "Application requires 32-bit extensions." } )
RETURN aError

*+--------------------------------------------------------------------
*+
*+    Static Function Diskfree()
*+
*+    Called from ( dualgrid.prg )   2 - procedure main()
*+                                   1 - static procedure gohistory()
*+                                   1 - static procedure change2drive()
*+                                   1 - static procedure updateinfo()
*+                                   1 - procedure gospecialfolder()
*+                                   1 - procedure gofindfile()
*+                                   1 - class texplorer
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION Diskfree( cStart )

LOCAL cPath := SUBSTR( cStart, 1, 2 )
LOCAL aInfo := GetDiskFreeSpaceEx( cPath )
LOCAL cRet

   cRet := LTRIM( STR( ROUND( aInfo[ 3 ] / 1024 ^ 3, 2 ) ) ) + " GB free of " + LTRIM( STR( ROUND( aInfo[ 2 ] / 1024 ^ 3, 2 ) ) ) + " GB"

RETURN cRet

*+--------------------------------------------------------------------
*+
*+    Static Function DoSH3func()
*+
*+    Called from ( dualgrid.prg )   1 - class texplorer
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION DoSH3func( cAction, lConfirm, lPaperbin, acFiles, acTarget )

LOCAL nFocus := nGridFocus
LOCAL iMax   := LEN( acFiles )
LOCAL lRet   := .F.
LOCAL nHWnd, nFunc, fFlag

   fFlag := FOF_SIMPLEPROGRESS

   DO CASE
      CASE cAction = "COPY"
         nFunc := FO_COPY
      CASE cAction = "MOVE"
         nFunc := FO_MOVE
      CASE cAction = "DELETE"
         nFunc := FO_DELETE
      CASE cAction = "RENAME"
         nFunc := FO_RENAME
   ENDCASE

   IF iMax > 1
      fFlag := nOr( fFlag, FOF_MULTIDESTFILES )
   ENDIF

   IF lPaperbin
      fFlag := nOr( fFlag, FOF_ALLOWUNDO )
   ENDIF

   IF lConfirm
   ELSE
      //  fFlag += FOF_NOCONFIRMATION + FOF_NOCONFIRMMKDIR + FOF_RENAMEONCOLLISION
      fFlag := nOr( fFlag, FOF_NOCONFIRMATION, FOF_NOCONFIRMMKDIR )
   ENDIF

   // ===========================================================================
   // Function ShellFile( hParentWnd, aFiles, aTarget, nFunc, nFlag )
   //
   // Purpose:
   // Performs a copy, move, rename, or delete operation on a file system object.
   // Parameters:
   //   aFiles  is an Array of Source-Filenamestrings, or a single Filenamestring
   //   aTarget is an Array of Target-Filenamestrings, or a single Filenamestring
   //   nFunc   determines the action on the files:
   //           FO_MOVE, FO_COPY, FO_DELETE, FO_RENAME
   //   fFlag   Option Flag ( see the file SHELL32.CH )
   //
   // ===========================================================================

   lRet := ShellFiles( nHWnd, acFiles, acTarget, nFunc, fFlag )

   SysWait( 0.5 )

   IF cAction = "DELETE"
      IF nGridFocus = 1
         oExpl_Left:DoNextFolder( oExpl_Left:oGrid:cPath )
      ELSE
         oExpl_Right:DoNextFolder( oExpl_Right:oGrid:cPath )
      ENDIF

   ELSEIF cAction = "COPY"
      IF nGridFocus = 1
         oExpl_Right:DoNextFolder( oExpl_Right:oGrid:cPath )
      ELSE
         oExpl_Left:DoNextFolder( oExpl_Left:oGrid:cPath )
      ENDIF
   ELSE
      nGridFocus := 1
      oExpl_Left:DoNextFolder( oExpl_Left:oGrid:cPath )

      nGridFocus := 2
      oExpl_Right:DoNextFolder( oExpl_Right:oGrid:cPath )

      nGridFocus := nFocus
   ENDIF

RETURN lRet

*+--------------------------------------------------------------------
*+
*+    Static Function ShellFiles()
*+
*+    Called from ( dualgrid.prg )   1 - static function dosh3func()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION ShellFiles( hWnd, acFiles, acTarget, nFunc, fFlag )

LOCAL cTemp
LOCAL cx
LOCAL lRet  := .T.

   // SourceFiles, convert Array to String
   DEFAULT acFiles TO CHR( 0 )
   IF VALTYPE( acFiles ) == "A"
      cTemp := ""
      FOR cx := 1 TO LEN( acFiles )
         cTemp += acFiles[ cx ] + CHR( 0 )
      NEXT
      acFiles := cTemp
   ENDIF
   acFiles += CHR( 0 )

   // TargetFiles, convert Array to String
   DEFAULT acTarget TO CHR( 0 )
   IF VALTYPE( acTarget ) == "A"
      cTemp := ""
      FOR cx := 1 TO LEN( acTarget )
         cTemp += acTarget[ cx ] + CHR( 0 )
      NEXT
      acTarget := cTemp
   ENDIF
   acTarget += CHR( 0 )

   // call SHFileOperation
   DO CASE
      CASE nFunc = FO_COPY
         lRet := SHFile( hWnd, FO_COPY, acFiles, acTarget, fFlag )
      CASE nFunc = FO_MOVE
         lRet := SHFile( hWnd, FO_MOVE, acFiles, acTarget, fFlag )
      CASE nFunc = FO_DELETE
         lRet := SHFile( hWnd, FO_DELETE, acFiles, acTarget, fFlag )
      CASE nFunc = FO_RENAME
         lRet := SHFile( hWnd, FO_RENAME, acFiles, acTarget, fFlag )
   ENDCASE

RETURN lRet

*+--------------------------------------------------------------------
*+
*+    Static Function NetConnect()
*+
*+    Called from ( dualgrid.prg )   1 - static procedure buildmainmenu()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION NetConnect()

LOCAL nHandle := GetActiveWindow()
RETURN DLLCall( "Mpr.dll", DLL_OSAPI, "WNetConnectionDialog", nHandle, RESOURCETYPE_DISK )

*+--------------------------------------------------------------------
*+
*+    Static Function NetDisconnect()
*+
*+    Called from ( dualgrid.prg )   1 - static procedure buildmainmenu()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION NetDisconnect()

LOCAL nHandle := GetActiveWindow()
LOCAL cDir    := "C:\"

   DLLCall( "Mpr.dll", DLL_OSAPI, "WNetDisconnectDialog", nHandle, RESOURCETYPE_DISK )

   IF nGridFocus = 1
      // FillWithDir( "WinLeft", cGrid_Left, cdir, "TREEDN" )
   ELSE
      // FillWithDir( "WinRight", cGrid_Right, cdir, "TREEDN" )
   ENDIF

RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Procedure MakeTop()
*+
*+    Called from ( codepage.prg )   1 - procedure changecodepage()
*+                ( dualgrid.prg )   1 - static procedure showhistory()
*+                                   1 - static procedure makenewfolder()
*+                                   1 - static procedure selectfiles()
*+                                   2 - class texplorer
*+                ( everyth.prg )   1 - procedure searchwitheverything()
*+                ( iphone.prg )   1 - procedure iphonewin()
*+                ( property.prg )   1 - procedure showmoreproperty()
*+                ( shellapp.prg )   1 - procedure funcmscfolder()
*+                                   1 - procedure funcsysfolder()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE MakeTop( oWnd, o1stFocus )

LOCAL oTimer

   SetWindowPos( oWnd:hWnd, HWND_TOPMOST, ;
                 oWnd:nTop, oWnd:nLeft, ;
                 oWnd:nWidth, oWnd:nHeight, nOr( SWP_NOMOVE, SWP_NOSIZE ) )
   oWnd:SetFocus()
   o1stFocus:SetFocus()

   DEFINE TIMER oTimer INTERVAL 100 ACTION( SnapToCtrl( oWnd, o1stFocus ), oTimer:End(), oTimer := NIL ) OF oWnd
   ACTIVATE TIMER oTimer

RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure SnapToCtrl()
*+
*+    Called from ( dualgrid.prg )   1 - procedure maketop()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE SnapToCtrl( oParent, oObj )

LOCAL hWnd, nTop, nLeft, nWidth, nHeight, nCol, nRow
LOCAL nTop0, nLeft0, nWidth0, nHeight0

   oParent:CoorsUpdate()

   hWnd := oObj:hWnd

   nTop0 := oParent:nTop
   nLeft0 := oParent:nLeft
   nWidth0 := oParent:nWidth
   nHeight0 := oParent:nHeight

   nTop := oObj:nTop
   nLeft := oObj:nLeft
   nWidth := oObj:nWidth
   nHeight := oObj:nHeight

   // Center of control
   nRow := nTop0 + nTop + ( nHeight )
   nCol := nLeft0 + nLeft + ( nWidth / 2 )

   SETCURSORPOS( nCol, nRow )
   //   oObj:Setfocus()

RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure SayBar()
*+
*+    Called from ( tgrid.prg )   1 - class tgrid
*+
*+--------------------------------------------------------------------
*+
PROCEDURE SayBar( cText, nPart )

   DEFAULT nPart := 1
   // how does Statusbar work ?
   //
   //   oStatusBar:SetPartText( nPart, cText )
   //   oStatusBar:SetMsg( cText )
   //   oMain:SetMsg( cText )
RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure GoSpecialFolder()
*+
*+    Called from ( shellapp.prg )   2 - procedure funcsysfolder()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE GoSpecialFolder( cPath, aFolder )

LOCAL nPosi, cNewPath, nCSIDL
LOCAL cDrive, cVol_Info

   nPosi := ASCAN( aFolder, { | x | x[ 1 ] = cPath } )
   IF !EMPTY( nPosi )
      nCSIDL := aFolder[ nPosi ] [ 4 ]
      cNewPath := C_GETSPECIALFOLDER( nCSIDL )

      IF EMPTY( cNewPath )
         msginfo( "problem with " + VAR2CHAR( cPath ) )
         RETURN
      ENDIF

      cDrive := SUBSTR( cNewPath, 1, 2 )
      cVol_Info := VOLUMENAME( cDrive + "\" ) + SPACE( 5 ) + Diskfree( cDrive )

      IF nGridFocus = 1
         oExpl_Left:oVol_Info:SetText( cVol_Info )
         oCombo_left:Select( DriveNumber( cNewPath ) )
         oExpl_Left:DoNextFolder( cNewPath )
      ELSE
         oExpl_Right:oVol_Info:SetText( cVol_Info )
         oCombo_Right:Select( DriveNumber( cNewPath ) )
         oExpl_Right:DoNextFolder( cNewPath )
      ENDIF
   ELSE
      msginfo( "problem with " + VAR2CHAR( cPath ) )
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure GoFindFile()
*+
*+    Called from ( everyth.prg )   2 - procedure searchwitheverything()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE GoFindFile( cPathFile, oWnd )

LOCAL cDrive, cVol_Info, cNewPath, cFile

   oWnd:End()

   IF EMPTY( cPathFile )
   ELSE
      cNewPath := Pathonly( cPathFile )
      cFile := Fileonly( cPathFile )

      cDrive := SUBSTR( cNewPath, 1, 2 )
      cVol_Info := VOLUMENAME( cDrive + "\" ) + SPACE( 5 ) + Diskfree( cDrive )

      IF nGridFocus = 1
         oExpl_Left:oVol_Info:SetText( cVol_Info )
         oCombo_left:Select( DriveNumber( cNewPath ) )
         oExpl_Left:DoNextFolder( cNewPath, cFile )
      ELSE
         oExpl_Right:oVol_Info:SetText( cVol_Info )
         oCombo_Right:Select( DriveNumber( cNewPath ) )
         oExpl_Right:DoNextFolder( cNewPath, cFile )
      ENDIF
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure SearchRecursive()
*+
*+    Called from ( everyth.prg )   1 - static function everysearch()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE SearchRecursive( cText, cAttr )

LOCAL cPath
   IF nGridFocus = 1
      cPath := oExpl_Left:oGrid:cPath
   ELSE
      cPath := oExpl_Right:oGrid:cPath
   ENDIF

   cPath := EndwithSlash( cPath )
   RECUDIRS( cPath, TRIM( cText ), cAttr )
RETURN

*+--------------------------------------------------------------------
*+
*+    Function NumColor2RGB()
*+
*+    Called from ( dualgrid.prg )   2 - static procedure buildmainmenu()
*+
*+--------------------------------------------------------------------
*+
FUNCTION NumColor2RGB( nColor )

LOCAL aRetVal

   DEFAULT nColor TO - 1

   IF nColor == - 1
      aRetVal := { NIL, NIL, NIL }
   ELSE
      aRetVal := { nRGBRed( nColor ), nRGBGreen( nColor ), nRGBBlue( nColor ) }
   ENDIF

RETURN aRetVal

*+--------------------------------------------------------------------
*+
*+    Function SysColor2Num()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SysColor2Num( nColor )

RETURN GetSysColor( nColor )

*+--------------------------------------------------------------------
*+
*+    Function RGB2Num()
*+
*+--------------------------------------------------------------------
*+
FUNCTION RGB2Num( aColor )

RETURN RGB( aColor[ 1 ], aColor[ 2 ], aColor[ 3 ] )

*+--------------------------------------------------------------------
*+
*+    Function ColorDialog()
*+
*+    Called from ( dualgrid.prg )   2 - static procedure buildmainmenu()
*+
*+--------------------------------------------------------------------
*+
FUNCTION ColorDialog( aDefaultColor, lFullOpenBox )

LOCAL i, aRetVal, nColor, nInitColor

   IF VALTYPE( aDefaultColor ) == "A"
      nInitColor := RGB( aDefaultColor[ 1 ], aDefaultColor[ 2 ], aDefaultColor[ 3 ] )
   ENDIF

   IF VALTYPE( lFullOpenBox ) <> "L"
      lFullOpenBox := .T.
   ENDIF

   nColor := ChooseColor( nInitColor, lFullOpenBox )

   IF nColor = 0
      nColor = Rgb( 0, 0, 1 )
   ENDIF

RETURN nColor

*+--------------------------------------------------------------------
*+
*+    Function HMS2Sec()
*+
*+    Called from ( dualgrid.prg )   4 - static procedure comparedir()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMS2Sec( cHHMMSS )

LOCAL nSec := 0
LOCAL nHH  := 0
LOCAL nMM  := 0
LOCAL nSS  := 0

   nHH := VAL( SUBSTR( cHHMMSS, 1, 2 ) ) * 60 * 60
   nMM := VAL( SUBSTR( cHHMMSS, 4, 5 ) ) * 60
   nSS := VAL( SUBSTR( cHHMMSS, 7, 8 ) )

   nSec = nHH + nMM + nSS

RETURN nSec

*+--------------------------------------------------------------------
*+
*+    Function CompareFile()
*+
*+    Called from ( dualgrid.prg )   2 - class texplorer
*+                ( tgrid.prg )   2 - class tgrid
*+
*+--------------------------------------------------------------------
*+
FUNCTION CompareFile( aX, aY, lUp )

LOCAL cName1, cName2
LOCAL lRet

   DEFAULT lUp TO .T.

   cName1 := LOWER( FindExt( aX ) + FindName( aX ) )
   cName2 := LOWER( FindExt( aY ) + FindName( aY ) )

   IF lUp = .T.
      lRet := cName1 < cName2
   ELSE
      lRet := cName1 > cName2
   ENDIF

RETURN ( lRet )

*+--------------------------------------------------------------------
*+
*+    Function Pathonly()
*+
*+    Called from ( dualgrid.prg )   1 - procedure gofindfile()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Pathonly( cFull )

LOCAL cRet  := ""
LOCAL nPosi

   nPosi := RAT( "\", cFull )
   IF nPosi > 0
      cRet := SUBSTR( cFull, 1, nPosi - 1 )
   ENDIF

RETURN cRet

*+--------------------------------------------------------------------
*+
*+    Function Fileonly()
*+
*+    Called from ( dualgrid.prg )   1 - procedure gofindfile()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Fileonly( cFull )

LOCAL cRet  := ""
LOCAL nPosi

   nPosi := RAT( "\", cFull )
   IF nPosi > 0
      cRet := SUBSTR( cFull, nPosi + 1 )
   ENDIF

RETURN cRet

*+--------------------------------------------------------------------
*+
*+    Function FindName()
*+
*+    Called from ( dualgrid.prg )   2 - function comparefile()
*+
*+--------------------------------------------------------------------
*+
FUNCTION FindName( filename )

LOCAL nPosi := RAT( ".", filename )
RETURN SUBSTR( filename, 1, nPosi - 1 )

*+--------------------------------------------------------------------
*+
*+    Function FindExt()
*+
*+    Called from ( dualgrid.prg )   1 - static procedure viewer()
*+                                   2 - function comparefile()
*+
*+--------------------------------------------------------------------
*+
FUNCTION FindExt( filename )

LOCAL nPosi := RAT( ".", filename )
RETURN UPPER( SUBSTR( filename, nPosi + 1, LEN( filename ) ) )

*+--------------------------------------------------------------------
*+
*+    Function DriveNumber()
*+
*+    Called from ( dualgrid.prg )   2 - procedure main()
*+                                   2 - static procedure gohistory()
*+                                   4 - static procedure ondevicechange()
*+                                   2 - static procedure updateinfo()
*+                                   2 - procedure gospecialfolder()
*+                                   2 - procedure gofindfile()
*+                                   1 - class texplorer
*+
*+--------------------------------------------------------------------
*+
FUNCTION DriveNumber( cPath )

LOCAL aDrives := aDrives()
LOCAL nPosi

   nPosi := ASCAN( aDrives, { | x | x = UPPER( SUBSTR( cPath, 1, 2 ) ) } )

RETURN nPosi

*+--------------------------------------------------------------------
*+
*+    Function EndwithSlash()
*+
*+    Called from ( dualgrid.prg )   2 - procedure main()
*+                                   1 - procedure searchrecursive()
*+                                   7 - class texplorer
*+                ( iphone.prg )   1 - procedure iphonewin()
*+                                   1 - static procedure gettargetfolder()
*+                ( tgrid.prg )   1 - class tgrid
*+
*+--------------------------------------------------------------------
*+
FUNCTION EndwithSlash( cString )

LOCAL nPosi

   IF !EMPTY( cString )
      nPosi := RAT( "\", cString )
      IF nPosi = LEN( cString )
      ELSE
         cString += "\"
      ENDIF
      cString := STRTRAN( cString, "\\", "\", 3 )
   ENDIF

RETURN cString

*+--------------------------------------------------------------------
*+
*+    Function AtInside()
*+
*+    Called from ( dualgrid.prg )   2 - class texplorer
*+
*+--------------------------------------------------------------------
*+
FUNCTION AtInside( cMarker, cText )

LOCAL nPos := 1
LOCAL nIst := 0
LOCAL aRet := {}

   DO WHILE .T.
      nPos := AT( cMarker, cText )
      IF nPos > 0
         nIst ++
         AADD( aRet, LTRIM( SUBSTR( cText, 1, ( nPos - 1 ) ) ) )
         cText := SUBSTR( cText, ( nPos + 1 ), LEN( cText ) - nPos )
      ELSE
         AADD( aRet, LTRIM( cText ) )
         EXIT
      ENDIF
   ENDDO

RETURN aRet

*+--------------------------------------------------------------------
*+
*+    Function FillDriveArray()
*+
*+    Called from ( hbeject.prg )   1 - procedure usbeject()
*+
*+--------------------------------------------------------------------
*+
FUNCTION FillDriveArray()

   GetAllDrive()
RETURN { @acItem, @acBitmaps, @acType, @nFirstUSB }

*+--------------------------------------------------------------------
*+
*+    Function VAR2CHAR()
*+
*+    Called from ( codepage.prg )   1 - static function comparekeyboard()
*+                ( dualgrid.prg )   6 - procedure main()
*+                                   2 - static procedure diffcompare()
*+                                   2 - procedure gospecialfolder()
*+                                   2 - function ondummy()
*+                                   2 - class texplorer
*+
*+--------------------------------------------------------------------
*+
FUNCTION VAR2CHAR( cIn )

LOCAL cOut := hb_valToExp( cIn )
RETURN STRTRAN( cOut, '"', '' )

*+--------------------------------------------------------------------
*+
*+    Function onDummy()
*+
*+--------------------------------------------------------------------
*+
FUNCTION onDummy()

LOCAL iMax   := PCOUNT()
LOCAL i
LOCAL cText  := ""
LOCAL xValue

   IF lDebug = .T.
      FOR i := 1 TO iMax - 1
         cText += Var2Char( PValue( i ) ) + CHR( 9 )
      NEXT
      cText += Var2Char( PValue( iMax ) )

      IF EMPTY( cText )
         cText := TIME() + " no Parameter ? " + CRLF + PROCNAME( 1 ) + STR( PROCLINE( 1 ) ) + CRLF + PROCNAME( 2 ) + STR( PROCLINE( 2 ) )
      ENDIF

      SET CONSOLE OFF
      SET ALTER ON

      // ? cText
      QOUT( cText )

      SET ALTER OFF
      SET CONSOLE ON

   ENDIF

RETURN NIL

// ******************************* CLASS TExplorer ***************************

*+--------------------------------------------------------------------
*+
*+    Class TExplorer
*+
*+--------------------------------------------------------------------
*+
CLASS TExplorer FROM TGrid

   DATA oGrid
   DATA oProgress
   DATA oParent
   DATA aLastFolder INIT {}
   DATA aNextFolder INIT {}
   DATA lChecked INIT .F.
   DATA cActiveFile INIT ""
   DATA oSayActive
   DATA nStartItem INIT 0
   DATA oVol_Info, oCombo_Info
   DATA lExHeader INIT .F.

   METHOD New( oParent, nTop, nLeft, nWidth, nHeight, cPath, nIcoLarge, nIcoSmall ) CONSTRUCTOR
   METHOD DoGetItem( nRow )
   METHOD DoLastFolder( cLastPath )
   METHOD DoNextFolder( cPath )
   METHOD SetStyle( nView )
   METHOD FillGrid()
   METHOD DoGetNewTree()
   METHOD DoSayItem( nItem )
   METHOD BUILDMENU( oCtrl )
   METHOD DoSwitchCheck()
   METHOD ASKFORM( cAction )
   METHOD Start_SHfunc( cAction )
   METHOD GetNewDir()
   METHOD SetSourceInfo()
   METHOD ChangeFAttr()
   METHOD ShowProperty()
   METHOD ShowMoreProperty()
   METHOD DoRunAsAdmin()
   METHOD SendToDeskTop()
   METHOD FindAndCenter( cTitle )
   METHOD RefreshAttr( nRec, cFile, nSize, cDate, cTime, cAttr, lArchive, lReadOnly, lHidden, lSystem )
   METHOD Destroy()

   METHOD Help() INLINE MsgInfo( "F1 Help TExplorer" )                // ::HelpTopic()

   ENDCLASS

METHOD New( oParent, nTop, nLeft, nWidth, nHeight, cPath, nIcoLarge, nIcoSmall ) CLASS TExplorer

LOCAL aPrompts
LOCAL nClrFore := BFcolor                                             // GetSysColor( COLOR_WINDOWTEXT )
LOCAL nClrBack := BGcolor                                             // GetSysColor( COLOR_WINDOW )
LOCAL lPixel   := .T.
LOCAL lDesign  := .F.
LOCAL cMsg     := ""
LOCAL bAction  := nil
LOCAL aHeader  := {}
LOCAL aDir, nPosi

   DEFAULT nIcoLarge := 32
   DEFAULT nIcoSmall := 16

   ::oParent := oParent

   AADD( aHeader, { "Name", 200, LVCFMT_LEFT, "C" } )
   AADD( aHeader, { "Size", 150, LVCFMT_RIGHT, "N" } )
   AADD( aHeader, { "Date", 110, LVCFMT_RIGHT, "D" } )
   AADD( aHeader, { "Time", 090, LVCFMT_RIGHT, "C" } )
   AADD( aHeader, { "Attr", 050, LVCFMT_LEFT, "C" } )

   ::oGrid := TGrid() :New( nTop, nLeft, aPrompts, bAction, ::oParent, BFcolor, BGcolor, ;
                      lPixel, lDesign, nWidth, nHeight, cMsg, nIcoLarge, nIcoSmall )

   ::oGrid:aHeader := aHeader
   ::oGrid:SortOrder := LVS_SORTASCENDING

   aDir := DIRECTORY( cPath + "*.*", "DHS" )
   nPosi := ASCAN( aDir, { | x | x[ F_NAME ] = "." .AND. LEN( x[ F_NAME ] ) = 1 } )
   IF nPosi > 0
      // remove "."
      ADEL( aDir, nPosi )
      ASIZE( aDir, LEN( aDir ) - 1 )
   ENDIF

   ::oGrid:cPath := EndwithSlash( cPath )
   ::oGrid:aSource := aDir

   // build Grid Column
   ::oGrid:CreateHeaderColumn()

   // Codeblock "click"
   ::oGrid:bClick := { | nItem | ::DoGetItem( nItem ) }

   // Codeblock "DispInfo"
   ::oGrid:bAction := { | nItem | ::DoSayItem( nItem ) }

   // Codeblock "right-click"
   ::oGrid:bRbClick := { | oCtrl, nRow, nCol, nKeyFlags | ::BUILDMENU( oCtrl, nRow, nCol, nKeyFlags ) }

   ::oGrid:bSideBack := { || ::DoLastFolder( TRIM( ::oGrid:cPath ) ) }
   ::oGrid:bSideNext := { || nil }

   IF ASCAN( aHistory, { | x | x == TRIM( ::oGrid:cPath ) } ) > 0
   ELSE
      AADD( aHistory, TRIM( ::oGrid:cPath ) )
   ENDIF

RETURN Self

METHOD BUILDMENU( oCtrl, nRow, nCol, nKeyFlags ) CLASS TExplorer

LOCAL oMenu, oFont
LOCAL nStackNumber := 0

   IF nGridFocus = 1
      nStackNumber := LEN( Stack_Left )
   ELSE
      nStackNumber := LEN( Stack_Right )
   ENDIF

   DEFINE FONT oFont NAME "TAHOMA" SIZE 0, - nFontBig
      ACTIVATE FONT oFont
#IFDEF __HMG__
   END FONT
#ENDIF

   IF BGcolor = Rgb( 0, 0, 1 )
      MENU oMenu 2013 POPUP ;
              COLORMENU BGcolor, BFcolor ;
              COLORPNEL BFcolor, BGcolor ;
              COLORLEFT BFcolor, BGcolor ;
              COLORSELECT BFcolor, BGcolor, BFcolor
   ELSE
      MENU oMenu 2013 POPUP ;
              COLORMENU BGcolor, BFcolor ;
              COLORPNEL BFcolor, BGcolor ;
              COLORLEFT BFcolor, BGcolor ;
              COLORSELECT BFcolor, BFcolor, BGcolor
   ENDIF

   oMenu:oFont := oFont

   MENUITEM "&add TAB" + CHR( 9 ) + "CTRL+T" RESNAME "MYADDTAB" ACTION NewTab()
   IF nStackNumber > 1
      MENUITEM "&close TAB" RESNAME "MYCLOSETAB" ACTION DelThisTab()
   ENDIF
   SEPARATOR
   MENUITEM "&ICON     " RESNAME "VIEWICON" ACTION ::oGrid:SetViewStyle( LVS_ICON, ::lExHeader )
   MENUITEM "&SMALLICON" RESNAME "VIEWSMALL" ACTION ::oGrid:SetViewStyle( LVS_SMALLICON, ::lExHeader )
   MENUITEM "&LIST     " RESNAME "VIEWLIST" ACTION ::oGrid:SetViewStyle( LVS_LIST, ::lExHeader )
   MENUITEM "&REPORT   " RESNAME "VIEWREPORT" ACTION ::oGrid:SetViewStyle( LVS_REPORT, ::lExHeader )
   SEPARATOR
   IF ::lChecked
      MENUITEM "use &Image" RESNAME "MYCHECKIT" ACTION ::DoSwitchCheck()
   ELSE
      MENUITEM "use &Image" ACTION ::DoSwitchCheck()
   ENDIF
   SEPARATOR
   MENUITEM "Tree" RESNAME "VIEWTREE" ACTION ::DoGetNewTree()
   SEPARATOR
   MENUITEM "send to &Desktop" RESNAME "MYDESKTOP" ACTION ::SendToDeskTop()
   SEPARATOR
   MENUITEM "compare Folder" RESNAME "MYCOMPARE" ACTION CompareDir()
   SEPARATOR
   MENUITEM "run &as Admin" RESNAME "MYADMIN" ACTION ::DoRunAsAdmin()
   SEPARATOR
   MENUITEM "&Attribut " RESNAME "MYFILEATTR" ACTION ::ChangeFAttr()
   SEPARATOR
   MENUITEM "&Property" RESNAME "MYINFO" ACTION ::ShowProperty()
   MENUITEM "&more Property" RESNAME "MYINFO" ACTION ::ShowMoreProperty()

   ENDMENU

   ACTIVATE POPUP oMenu OF oCtrl AT nRow, nCol
RETURN oMenu

METHOD Destroy() CLASS TExplorer

   ::oGrid:Destroy()
   ::Super:End()

RETURN nil

METHOD DoGetNewTree() CLASS TExplorer

LOCAL cVol_Info, cDrive
LOCAL cTitle    := "search Folder"
LOCAL cInitPath := ::oGrid:cPath
LOCAL cDir, oTimer

   DEFINE TIMER oTimer INTERVAL 200 ACTION( ::FindAndCenter( cTitle ), oTimer:End() )
   ACTIVATE TIMER oTimer

   cDir := CGETDIR( cTitle, TRIM( cInitPath ) )

   IF !EMPTY( cDir )
      ::oCombo_Info:Select( DriveNumber( cDir ) )

      cDrive := SUBSTR( cDir, 1, 2 )
      cVol_Info := VOLUMENAME( cDrive + "\" ) + SPACE( 5 ) + Diskfree( cDrive )
      ::oVol_Info:SetText( cVol_Info )

      ::DoNextFolder( EndwithSlash( cDir ) )
   ENDIF
RETURN nil

METHOD FindAndCenter( cTitle ) CLASS TExplorer

LOCAL nCount  := 0
LOCAL hWndDlg := 0
LOCAL aRect   := GETDESKTOPAREA()
LOCAL nWidth
LOCAL nHeight

   nWidth := aRect[ 4 ] - aRect[ 2 ]
   nHeight := aRect[ 3 ] - aRect[ 1 ]

   DO WHILE hWndDlg = 0
      hWndDlg := FindWindowEx(,,, cTitle )
      IF !( hWndDlg == 0 )
         MoveWindow( hWndDlg, ( nHeight - 1024 ) / 2, ( nWidth - 300 ) / 2, 300, 1024 )
         INVALIDATERECT( hWndDlg )
         EXIT
      ENDIF
      SysWait( 0.2 )
      nCount ++
      IF nCount > 100
         EXIT
      ENDIF
   ENDDO

RETURN nil

METHOD DoSayItem( nRow ) CLASS TExplorer

LOCAL cRet  := ""
LOCAL hWnd  := ::oGrid:hWnd
LOCAL nCol  := 1                                                      // only F_NAME
LOCAL cPath := ::oGrid:cPath

   cRet := LV_GETITEMTEXT( hWnd, nRow, nCol )

   ::cActiveFile := cPath + cRet
   ::oSayActive:SetText( ::cActiveFile )

   // how does Statusbar work ?
   //
   ::oGrid:cMsg := cPath + cRet

RETURN cRet

METHOD DoGetItem( nRow ) CLASS TExplorer

LOCAL cRet    := ""
LOCAL nCol    := 1                                                    // only F_NAME
LOCAL hWnd    := ::oGrid:hWnd
LOCAL cPath   := ::oGrid:cPath
LOCAL aSource := ::oGrid:aSource
LOCAL nPosi, cAttr

   // when using LVN_GETDISPINFO you NEED Source Array
   IF ::oGrid:lDispInfo = .T.
      cRet := ::oGrid:aSource[ nRow ] [ nCol ]
   ELSE
      cRet := LV_GETITEMTEXT( hWnd, nRow, nCol )
   ENDIF

   nPosi := ASCAN( aSource, { | x | x[ F_NAME ] = TRIM( cRet ) } )
   IF nPosi > 0
      cAttr := aSource[ nPosi ] [ F_ATTR ]

      DO CASE
         CASE TRIM( cRet ) = ".."
            ::DoLastFolder( TRIM( cPath ) )
         CASE TRIM( cRet ) = "."
         OTHERWISE
            IF "D" $ cAttr
               ::DoNextFolder( TRIM( cPath + cRet ) )
            ELSE
               ShellExecute( ::oParent:hWnd, "Open", cPath + cRet,,, SW_SHOW )
            ENDIF
      ENDCASE
   ELSE
      MsgInfo( cRet + " not found in Folder " + cPath )
   ENDIF

RETURN cRet

METHOD DoLastFolder( cLastPath ) CLASS TExplorer

LOCAL cPath
LOCAL nPosi
LOCAL cFolder

   nPosi := hb_RAt( "\", cLastPath, 1, LEN( cLastPath ) - 1 )
   IF nPosi > 0

      cPath := SUBSTR( cLastPath, 1, nPosi - 1 )
      cFolder := SUBSTR( cLastPath, nPosi )
      cFolder := TRIM( STRTRAN( cFolder, "\", "" ) )

      ::DoNextFolder( EndwithSlash( cPath ), cFolder )
   ENDIF
RETURN nil

METHOD DoNextFolder( cPath, cFolder ) CLASS TExplorer

LOCAL cRet := ""
LOCAL aDir, aToken, nPosi, nMax, nDim, oTab, aPrompts

   DEFAULT cFolder := ""

   IF "\\" $ SUBSTR( cPath, 3 )                                       // UNC \\Server\Folder
      cPath := STRTRAN( cPath, "\\", "\", 3 )
   ENDIF

   IF nGridFocus = 1
      nDim := nDimLeft
      oTab := oTab_Left
   ELSE
      nDim := nDimRight
      oTab := oTab_Right
   ENDIF

   aDir := DIRECTORY( cPath + "\*.*", "DHS" )
   nPosi := ASCAN( aDir, { | x | x[ F_NAME ] = "." .AND. LEN( x[ F_NAME ] ) = 1 } )
   IF nPosi > 0
      // remove "."
      ADEL( aDir, nPosi )
      ASIZE( aDir, LEN( aDir ) - 1 )
   ENDIF

   ::oGrid:cPath := EndwithSlash( cPath )
   ::oGrid:aSource := aDir

   IF nGridFocus = 1
      cPath_Left := ::oGrid:cPath
   ELSE
      cPath_Right := ::oGrid:cPath
   ENDIF

   IF ASCAN( aHistory, { | x | x == TRIM( ::oGrid:cPath ) } ) > 0
   ELSE
      AADD( aHistory, TRIM( ::oGrid:cPath ) )
   ENDIF

   ::FillGrid()

   nMax := LEN( ::aSource )
   // need for LVS_OWNERDATA / ::OnDISPINFO()
   LV_SETITEMCOUNT( ::oGrid:hLv, nMax )

   IF !EMPTY( cFolder )
      nPosi := ASCAN( ::oGrid:aSource, { | e | LOWER( e[ F_NAME ] ) = LOWER( cFolder ) } )
      IF nPosi > 0
         LV_SETITEMSELECT( ::oGrid:hLv, nPosi )
      ELSE
         msginfo( "not found Folder " + cFolder )
      ENDIF
   ENDIF

   aToken := AtInside( "\", ::oGrid:cPath )
   aPrompts := ACLONE( oTab:aPrompts )
   // change Header of TAB
   aPrompts[ nDim ] := UPPER( aToken[ LEN( aToken ) - 1 ] )
   // set new aPrompts
   oTab:SetPrompts( aPrompts )

   ::oGrid:Setfocus()

RETURN cRet

METHOD SetStyle( nView ) CLASS TExplorer

   DEFAULT nView := LVS_REPORT

   DO CASE
      CASE nView = LVS_ICON
         ::oGrid:SetViewStyle( LVS_ICON, ::lExHeader )
      CASE nView = LVS_SMALLICON
         ::oGrid:SetViewStyle( LVS_SMALLICON, ::lExHeader )
      CASE nView = LVS_LIST
         ::oGrid:SetViewStyle( LVS_LIST, ::lExHeader )
      CASE nView = LVS_REPORT
         ::oGrid:SetViewStyle( LVS_REPORT, ::lExHeader )
   ENDCASE
RETURN self

METHOD FillGrid( nCol, oDlg ) CLASS TExplorer

LOCAL nStartAt := 1
LOCAL hGrid    := ::oGrid:hLv
LOCAL hBmpA    := LoadBitmap( GetResources(), "GRID_ASC" )
LOCAL hBmpD    := LoadBitmap( GetResources(), "GRID_DSC" )
LOCAL aToken, nDim, oTab, aPrompts, cPath
LOCAL nWidth, cCaption, nAlign := HDF_LEFT

   DEFAULT nCol := F_NAME

   IF nGridFocus = 1
      nDim := nDimLeft
      oTab := oTab_Left
      cPath := cPath_Left
   ELSE
      nDim := nDimRight
      oTab := oTab_Right
      cPath := cPath_Right
   ENDIF

   IF !EMPTY( oDlg )                                                  // lNewName = .T.
      aToken := AtInside( "\", cPath )
      aPrompts := ACLONE( oTab:aPrompts )
      aPrompts[ nDim ] := UPPER( aToken[ LEN( aToken ) - 1 ] )
      oTab:SetPrompts( aPrompts )
   ENDIF

   ASORT( ::oGrid:aSource,,, { | x, y | "D" $ x[ F_ATTR ] } )
   AEVAL( ::oGrid:aSource, { | x, i | nStartAt := IF( "D" $ x[ F_ATTR ], i, nStartAt ) } )
   // ASORT(::oGrid:aSource,1,nStartAt,{|x,y|  LOWER(x[F_NAME]) < LOWER(y[F_NAME]) })
   ASORT( ::oGrid:aSource, 1, nStartAt, { | x, y | UPPER( x[ F_NAME ] ) < UPPER( y[ F_NAME ] ) } )

   DO CASE
      CASE nCol = F_NAME
         IF ::oGrid:SortOrder = LVS_SORTASCENDING
            // ASORT( ::oGrid:aSource, nStartAt + 1,, { | x, y | ( x[ F_NAME ], y[ F_NAME ], .T. ) } )
            ASORT( ::oGrid:aSource, nStartAt + 1,, { | x, y | CompareFile( x[ F_NAME ], y[ F_NAME ], .T. ) } )
            //             SetGridHeaderSort( hGrid, 1, + 1 )
            ::oGrid:SetHeaderItem( nCol, cCaption, nWidth, nAlign, + 1, hBmpA )

         ELSE
            // ASORT( ::oGrid:aSource, nStartAt + 1,, { | x, y | ( x[ F_NAME ], y[ F_NAME ], .F. ) } )
            ASORT( ::oGrid:aSource, nStartAt + 1,, { | x, y | CompareFile( x[ F_NAME ], y[ F_NAME ], .F. ) } )
            //             SetGridHeaderSort( hGrid, 1, - 1 )
            ::oGrid:SetHeaderItem( nCol, cCaption, nWidth, nAlign, - 1, hBmpD )
         ENDIF

      CASE nCol = F_SIZE
         IF ::oGrid:SortOrder = LVS_SORTASCENDING
            ASORT( ::oGrid:aSource, nStartAt + 1,, { | x, y | ( x[ F_SIZE ] ) < ( y[ F_SIZE ] ) } )
            //             SetGridHeaderSort( hGrid, 2, + 1 )
            ::oGrid:SetHeaderItem( nCol, cCaption, nWidth, nAlign, + 1, hBmpA )
         ELSE
            ASORT( ::oGrid:aSource, nStartAt + 1,, { | x, y | ( x[ F_SIZE ] ) > ( y[ F_SIZE ] ) } )
            //             SetGridHeaderSort( hGrid, 2, - 1 )
            ::oGrid:SetHeaderItem( nCol, cCaption, nWidth, nAlign, - 1, hBmpD )
         ENDIF

      CASE nCol = F_DATE
         IF ::oGrid:SortOrder = LVS_SORTASCENDING
            ASORT( ::oGrid:aSource, nStartAt + 1,, { | x, y | ( x[ F_DATE ] ) < ( y[ F_DATE ] .AND. ( x[ F_TIME ] ) < ( y[ F_TIME ] ) ) } )
            //             SetGridHeaderSort( hGrid, 3, + 1 )
            ::oGrid:SetHeaderItem( nCol, cCaption, nWidth, nAlign, + 1, hBmpA )
         ELSE
            ASORT( ::oGrid:aSource, nStartAt + 1,, { | x, y | ( x[ F_DATE ] ) > ( y[ F_DATE ] .AND. ( x[ F_TIME ] ) > ( y[ F_TIME ] ) ) } )
            //             SetGridHeaderSort( hGrid, 3, - 1 )
            ::oGrid:SetHeaderItem( nCol, cCaption, nWidth, nAlign, - 1, hBmpD )
         ENDIF

      CASE nCol = F_TIME
         IF ::oGrid:SortOrder = LVS_SORTASCENDING
            ASORT( ::oGrid:aSource, nStartAt + 1,, { | x, y | ( x[ F_TIME ] ) < ( y[ F_TIME ] ) } )
            //             SetGridHeaderSort( hGrid, 4, + 1 )
            ::oGrid:SetHeaderItem( nCol, cCaption, nWidth, nAlign, + 1, hBmpA )
         ELSE
            ASORT( ::oGrid:aSource, nStartAt + 1,, { | x, y | ( x[ F_TIME ] ) > ( y[ F_TIME ] ) } )
            //             SetGridHeaderSort( hGrid, 4, - 1 )
            ::oGrid:SetHeaderItem( nCol, cCaption, nWidth, nAlign, - 1, hBmpD )
         ENDIF

      CASE nCol = F_ATTR
         IF ::oGrid:SortOrder = LVS_SORTASCENDING
            ASORT( ::oGrid:aSource, nStartAt + 1,, { | x, y | ( x[ F_ATTR ] ) < ( y[ F_ATTR ] ) } )
            //             SetGridHeaderSort( hGrid, 5, + 1 )
            ::oGrid:SetHeaderItem( nCol, cCaption, nWidth, nAlign, + 1, hBmpA )
         ELSE
            ASORT( ::oGrid:aSource, nStartAt + 1,, { | x, y | ( x[ F_ATTR ] ) > ( y[ F_ATTR ] ) } )
            //             SetGridHeaderSort( hGrid, 5, - 1 )
            ::oGrid:SetHeaderItem( nCol, cCaption, nWidth, nAlign, - 1, hBmpD )
         ENDIF

   ENDCASE

   DeleteObject( hBmpA )
   DeleteObject( hBmpD )

   // IF ::oGrid:SortOrder = LVS_SORTASCENDING
   //    ::oGrid:SortOrder := LVS_SORTDESCENDING
   // ELSE
   //    ::oGrid:SortOrder := LVS_SORTASCENDING
   // ENDIF

   ::oGrid:ClearAndFillDir( oDlg )

RETURN self

METHOD DoSwitchCheck() CLASS TExplorer

   IF ::lChecked
      ::oGrid:lImage := .F.
   ELSE
      ::oGrid:lImage := .T.
   ENDIF
   ::lChecked := !::lChecked

RETURN nil

METHOD ASKFORM( cAction ) CLASS TExplorer

LOCAL oASKFORM, oText_1, oText_2, oLabel_1, oLabel_2, oSourceInfo     //, oTimer
LOCAL olConfirm, olPaperbin, oButton_Start, oButton_Tree, oButton_Abort
LOCAL iMax, nPosi
LOCAL cSourceDir := IF( nGridFocus = 1, cPath_Left, cPath_Right )
LOCAL cTargetDir := IF( nGridFocus = 1, cPath_Right, cPath_Left )
LOCAL aItem      := ::oGrid:Getdata()
LOCAL cFile      := ::cActiveFile
LOCAL lConfirm   := .F.
LOCAL lPaperbin  := .T.
LOCAL lRet       := .F.

   IF EMPTY( aItem )
   ELSE
      IF VALTYPE( aItem ) = "A"
         iMax := LEN( aItem )
         IF iMax = 1
            IF aItem[ 1 ] = 0                                         // ".."
               Msginfo( "can't " + cAction + " '..'" )
               RETURN Nil
            ENDIF
         ELSE
            cFile := LTRIM( STR( iMax ) ) + " Files"
         ENDIF
      ELSEIF VALTYPE( aItem ) = "C"
      ENDIF
   ENDIF

   IF cAction = "DELETE"
      // msgInfo("DELETE" )
   ENDIF

   DEFINE WINDOW oASKFORM FROM 0, 0 TO 270, 534 PIXEL TITLE cAction ICON "A1MAIN" COLOR BFcolor, BGcolor NOMINIMIZE NOMAXIMIZE

      @ 010, 080 SAY oSourceInfo PROMPT cFile SIZE 400, 30 PIXEL FONT oFontDefault OF oASKFORM         

      @ 010, 010 SAY oLabel_1 PROMPT "Source" SIZE 60, 30 PIXEL FONT oFontDefault OF oASKFORM         
      @ 040, 010 GET oText_1 VAR cSourceDir SIZE 500, 30 PIXEL FONT oFontDefault OF oASKFORM          

      @ 080, 210 CHECKBOX olConfirm VAR lConfirm PROMPT "want &Confirm" SIZE 200, 24 PIXEL FONT oFontDefault OF oASKFORM
      @ 080, 210 CHECKBOX olPaperbin VAR lPaperbin PROMPT "to &Paperbin" SIZE 200, 24 PIXEL FONT oFontDefault OF oASKFORM

      SetWindowTheme( olConfirm :hWnd, "", "" )
      SetWindowTheme( olPaperbin:hWnd, "", "" )

      @ 080, 010 SAY oLabel_2 PROMPT "Target" SIZE 60, 30 PIXEL FONT oFontDefault OF oASKFORM         
      @ 110, 010 GET oText_2 VAR cTargetDir SIZE 500, 30 PIXEL FONT oFontDefault OF oASKFORM          

      @ 150, 010 BUTTON oButton_Start PROMPT "&OK" SIZE 100, 64 PIXEL FONT oFontDefault ACTION ::Start_SHfunc( aItem, cAction, cSourceDir, cTargetDir, lConfirm, lPaperbin, oASKFORM ) OF oASKFORM
      @ 150, 210 BUTTON oButton_Tree PROMPT "&Tree" SIZE 100, 64 PIXEL FONT oFontDefault ACTION ::GetNewDir( oText_2 ) OF oASKFORM
      @ 150, 410 BUTTON oButton_Abort PROMPT "&Abort" SIZE 100, 64 PIXEL FONT oFontDefault ACTION oASKFORM:End() OF oASKFORM

#IFDEF __HMG__
   END WINDOW
#ENDIF

   IF cAction = "DELETE"
      oText_2:hide()
      oLabel_2:hide()

      olConfirm:hide()
      oButton_Tree:hide()
   ELSE
      olPaperbin:hide()
   ENDIF

   oASKFORM:bKeyDown := { | nKey, nFlag | IF( nKey = VK_ESCAPE, oASKFORM:End(), nil ) }
   oASKFORM:bResized := { | nType, nWidth, nHeight | oASKFORM:SetSize( 534, 270 ) }

   ACTIVATE WINDOW oASKFORM ON INIT MakeTop( oASKFORM, oButton_Start ) CENTER

   IF nGridFocus = 1
      Tab_Change_Left()
   ELSE
      Tab_Change_Right()
   ENDIF
RETURN Nil

METHOD Start_SHfunc( aItem, cAction, cSourceDir, cTargetDir, lConfirm, lPaperbin, oASKFORM ) CLASS TExplorer

LOCAL lRet     := .F.
LOCAL acDelete := {}
LOCAL acFiles  := {}
LOCAL acTarget := {}
LOCAL ii, iMax, nPosi
LOCAL cFile, nSize, dDate, cTime, cAttr

   oASKFORM:Hide()

   cSourceDir := EndwithSlash( cSourceDir )
   cTargetDir := EndwithSlash( cTargetDir )

   cSourceDir := STRTRAN( cSourceDir, "\\", "\", 3 )
   cTargetDir := STRTRAN( cTargetDir, "\\", "\", 3 )

   ::nStartItem := 0

   iMax := LEN( aItem )
   FOR ii := 1 TO iMax
      nPosi := aItem[ ii ]

      IF ii = 1
         ::nStartItem := nPosi
      ENDIF

      cFile := ::oGrid:aSource[ nPosi ] [ F_NAME ]
      nSize := ::oGrid:aSource[ nPosi ] [ F_SIZE ]
      dDate := ::oGrid:aSource[ nPosi ] [ F_DATE ]
      cTime := ::oGrid:aSource[ nPosi ] [ F_TIME ]
      cAttr := ::oGrid:aSource[ nPosi ] [ F_ATTR ]

      AADD( acFiles, cSourceDir + cFile )
      IF cAction = "DELETE"
         AADD( acTarget, "" + CHR( 0 ) )
         AADD( acDelete, { cSourceDir, cFile, cAttr } )
      ELSE
         AADD( acTarget, cTargetDir + cFile )
      ENDIF

   NEXT

   lRet := DoSH3func( cAction, lConfirm, lPaperbin, acFiles, acTarget )

   LV_SETITEMSELECT( ::oGrid:hLv, ::nStartItem )

   oASKFORM:End()

RETURN lRet

METHOD GetNewDir( oText_2 ) CLASS TExplorer

LOCAL cTitle           := "search Folder"
LOCAL lNewFolderButton := .T.
LOCAL cDir, nPosi, cInitPath := ""

   IF nGridFocus = 1
      cInitPath := cPath_Left
   ELSE
      cInitPath := cPath_Right
   ENDIF

   cDir := CGETDIR( cTitle, TRIM( cInitPath ) )

   IF !EMPTY( cDir ) .AND. !EMPTY( oText_2 )
      oText_2:cText( cDir + "\" )
      oText_2:Refresh()
   ENDIF

RETURN cDir

METHOD SetSourceInfo( cFile ) CLASS TExplorer

LOCAL cText := ""
LOCAL aItem := ::oGrid:Getdata()
LOCAL i, iMax

   IF !EMPTY( aItem )
      iMax := LEN( aItem )
      FOR i := 1 TO iMax
         cText += aItem[ i ]
         IF i <> iMax
            cText += "*"
         ENDIF
      NEXT

      IF iMax > 1
         cFile := LTRIM( STR( iMax ) ) + " Items"
      ELSE
         cFile := cText
      ENDIF

   ENDIF

RETURN nil

METHOD ChangeFAttr() CLASS TExplorer

LOCAL oWnd, aItem, iMax, nItem
LOCAL lArchive, lReadOnly, lHidden, lSystem
LOCAL cDate, cTime, aDir, nSize, cAttr
LOCAL cPath, cName, cFile, lChange := .f.
LOCAL aSource, nRec := 1
LOCAL oFA_Check_1, oFA_Check_2, oFA_Check_3, oFA_Check_4, oFA_Check_5
LOCAL oFA_Button_1, oFA_Button_2, oFA_Button_3
LOCAL oFA_Text_1, oFA_Text_2, oFA_Text_3
LOCAL cSourceDir   := ::oGrid:cPath

   aSource := ::oGrid:aSource
   aItem := ::oGrid:Getdata()
   cPath := EndwithSlash( ::oGrid:cPath )

   IF EMPTY( aItem )
      Msginfo( "no Item ?" )
      RETURN Nil
   ELSE
      IF VALTYPE( aItem ) = "A"
         iMax := LEN( aItem )
         IF iMax = 1
            IF aItem[ 1 ] = 0                                         // ".."
               Msginfo( "can't use '..'" )
               RETURN Nil
            ENDIF
            cFile := aSource[ aItem[ 1 ] ] [ F_NAME ]
         ELSE
            Msginfo( "multi select not allowed" )
            RETURN Nil
         ENDIF
      ELSEIF VALTYPE( aItem ) = "C"
         cFile := aSource[ aItem[ 1 ] ] [ F_NAME ]
      ENDIF
   ENDIF
   nRec := aItem[ 1 ]

   aDir := DIRECTORY( cPath + cFile )
   IF EMPTY( aDir )
      Msginfo( "no " + cPath + cFile )
      RETURN nil
   ENDIF

   cDate := DTOC( aDir[ 1 ] [ F_DATE ] )
   cTime := aDir[ 1 ] [ F_TIME ]
   cAttr := aDir[ 1 ] [ F_ATTR ]
   lArchive := "A" $ aDir[ 1 ] [ F_ATTR ]
   lReadOnly := "R" $ aDir[ 1 ] [ F_ATTR ]
   lHidden := "H" $ aDir[ 1 ] [ F_ATTR ]
   lSystem := "S" $ aDir[ 1 ] [ F_ATTR ]

   nSize := aDir[ 1 ] [ F_SIZE ]

   DEFINE WINDOW oWnd FROM 0, 0 TO 290, 300 PIXEL TITLE "File attributes for " + cFile ICON "A1MAIN" NOMINIMIZE NOMAXIMIZE COLOR BFcolor, BGcolor

      @ 026, 14 CHECKBOX oFA_Check_1 VAR lArchive PROMPT "&Archive" SIZE 180, 16 PIXEL FONT oFontDefault OF oWnd
      @ 048, 14 CHECKBOX oFA_Check_2 VAR lReadOnly PROMPT "&Read only" SIZE 180, 16 PIXEL FONT oFontDefault OF oWnd
      @ 070, 14 CHECKBOX oFA_Check_3 VAR lHidden PROMPT "&Hidden" SIZE 180, 16 PIXEL FONT oFontDefault OF oWnd
      @ 092, 14 CHECKBOX oFA_Check_4 VAR lSystem PROMPT "&System" SIZE 180, 16 PIXEL FONT oFontDefault OF oWnd

      @ 130, 14 CHECKBOX oFA_Check_5 VAR lChange PROMPT "Change &date/time" SIZE 180, 16 PIXEL FONT oFontDefault OF oWnd

      SetWindowTheme( oFA_Check_1:hWnd, "", "" )
      SetWindowTheme( oFA_Check_2:hWnd, "", "" )
      SetWindowTheme( oFA_Check_3:hWnd, "", "" )
      SetWindowTheme( oFA_Check_4:hWnd, "", "" )
      SetWindowTheme( oFA_Check_5:hWnd, "", "" )

      oFA_Check_1:SetColor( BFcolor, BGcolor )
      oFA_Check_2:SetColor( BFcolor, BGcolor )
      oFA_Check_3:SetColor( BFcolor, BGcolor )
      oFA_Check_4:SetColor( BFcolor, BGcolor )
      oFA_Check_5:SetColor( BFcolor, BGcolor )

      @ 110, 206 BUTTON oFA_Button_3 PROMPT "C&urrent" SIZE 74, 42 PIXEL FONT oFontDefault ;
              ACTION( cDate := DTOC( DATE() ), oFA_Text_1:refresh(), ;
              cTime := TIME(), oFA_Text_2:refresh(), ;
              lChange := .t., oFA_Check_5:refresh() )

      @ 160, 014 GET oFA_Text_1 VAR cDate SIZE 120, 28 PIXEL FONT oFontDefault COLOR BFcolor, BGcolor OF oWnd        
      @ 160, 182 GET oFA_Text_2 VAR cTime SIZE 100, 28 PIXEL FONT oFontDefault COLOR BFcolor, BGcolor OF oWnd        

      @ 202, 014 BUTTON oFA_Button_2 PROMPT "&Cancel" SIZE 80, 42 PIXEL FONT oFontDefault ACTION oWnd:End()
      @ 202, 206 BUTTON oFA_Button_1 PROMPT "&Ok" SIZE 74, 42 PIXEL FONT oFontDefault ACTION( SetAttr( cPath + cFile, lArchive, lReadOnly, lHidden, lSystem, lChange, cDate, cTime ), oWnd:End() )

#IFDEF __HMG__
   END WINDOW
#ENDIF

   oWnd:bKeyDown := { | nKey, nFlag | IF( nKey = VK_ESCAPE, oWnd:End(), nil ) }
   oWnd:bResized := { | nType, nWidth, nHeight | oWnd:SetSize( 300, 290 ) }

   ACTIVATE WINDOW oWnd ON INIT MakeTop( oWnd, oFA_Button_1 ) VALID ;
           ::RefreshAttr( nRec, cFile, nSize, cDate, cTime, cAttr, lArchive, lReadOnly, lHidden, lSystem ) ;
           CENTER

RETURN Nil

METHOD RefreshAttr( nRec, cFile, nSize, cDate, cTime, cAttr, lArchive, lReadOnly, lHidden, lSystem ) CLASS TExplorer

LOCAL aItem

LOCAL nAttribute := 0
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

   aItem := { cFile, vAR2CHAR( nSize ), cDate, cTime, nAttribute }

   LV_SETITEMTEXT( ::oGrid:hLv, aItem, nRec )

   ::oGrid:aSource[ nRec ] [ F_NAME ] := cFile
   ::oGrid:aSource[ nRec ] [ F_SIZE ] := vAR2CHAR( nSize )
   ::oGrid:aSource[ nRec ] [ F_DATE ] := CTOD( cDate )
   ::oGrid:aSource[ nRec ] [ F_TIME ] := cTime
   ::oGrid:aSource[ nRec ] [ F_ATTR ] := cAttr

   ::oGrid:RefreshCurrent( nRec )

   LV_SETITEMSELECT( ::oGrid:hLv, nRec )

RETURN .T.

METHOD ShowProperty() CLASS TExplorer

LOCAL cPath := ::oGrid:cPath
LOCAL nSel  := LV_GetSelectionMark( ::oGrid:hLv )
LOCAL cFile := ::oGrid:aSource[ nSel + 1 ] [ F_NAME ]
LOCAL aRet

   //   SHOWFILEPROPERTIES( ::oGrid:hLv, cPath, cFile )
   SHOWFILEPROPERTIES( ::oParent:Hwnd, cPath, cFile )

RETURN Nil

METHOD ShowMoreProperty() CLASS TExplorer

LOCAL cPath := ::oGrid:cPath
LOCAL nSel  := LV_GetSelectionMark( ::oGrid:hLv )
LOCAL cFile := ::oGrid:aSource[ nSel + 1 ] [ F_NAME ]

   ShowMoreProperty( cPath, cFile )                                   // in PROPERTY.PRG

RETURN Nil

METHOD DoRunAsAdmin() CLASS TExplorer

LOCAL cPath := ::oGrid:cPath
LOCAL nSel  := LV_GetSelectionMark( ::oGrid:hLv )
LOCAL cFile := ::oGrid:aSource[ nSel + 1 ] [ F_NAME ]

   ShellExecute( 0, "runas", cPath + cFile,,, SW_SHOW )

RETURN Nil

METHOD SendToDeskTop() CLASS TExplorer

LOCAL cUser       := GETENV( "USERPROFILE" )
LOCAL cStart      := cUser + "\Desktop\"
LOCAL cPath       := ::oGrid:cPath
LOCAL nSel        := LV_GetSelectionMark( ::oGrid:hLv )
LOCAL cFile       := ::oGrid:aSource[ nSel + 1 ] [ F_NAME ]
LOCAL cLinkTarget := ""
LOCAL cLinkFile   := ""
LOCAL cWorkingDir := ""
LOCAL cDescr      := ""
LOCAL cAttr       := ""
LOCAL cCmdArgs

   cWorkingDir := cPath
   cLinkTarget := cPath + cFile
   cLinkFile := cStart + cFile + ".lnk"

   DXE_CreateLink( cLinkTarget, cLinkFile, cWorkingDir, cCmdArgs, cDescr )

RETURN nil

*+--------------------------------------------------------------------
*+
*+    Procedure TAB_CHANGE_LEFT()
*+
*+    Called from ( dualgrid.prg )   1 - class texplorer
*+
*+--------------------------------------------------------------------
*+
PROCEDURE TAB_CHANGE_LEFT()

RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure TAB_CHANGE_RIGHT()
*+
*+    Called from ( dualgrid.prg )   1 - class texplorer
*+
*+--------------------------------------------------------------------
*+
PROCEDURE TAB_CHANGE_RIGHT()

RETURN

*+ EOF: DUALGRID.PRG
