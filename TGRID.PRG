*+--------------------------------------------------------------------
*+
*+ Source Module => c:\fwh\0\LISTVIEW\TGRID.PRG
*+
*+    Copyright(C) 1983-2022 by Auge & Ohr
*+
*+    Functions: Class TGrid
*+               Function HandleHeader()
*+
*+    Reformatted by Click! 2.05.40 on Jan-7-2023 at  1:29 am
*+
*+--------------------------------------------------------------------

#include "FiveWin.ch"
#include "Constant.ch"

#include "TGRID.CH"
#include "Directry.ch"

// ******************************* CLASS TGrid     ***************************

*+--------------------------------------------------------------------
*+
*+    Class TGrid
*+
*+--------------------------------------------------------------------
*+
CLASS TGrid FROM TControl

   CLASSDATA aProperties INIT { "nAlign", "nClrText", "nClrPane", "nOption", ;
                                "nTop", "nLeft", "nWidth", "nHeight", "Cargo" }

   DATA oParent
   DATA aItems INIT {}
   DATA aGroups INIT {}
   DATA bAction, bDisplay
   DATA bClick, bRbClick
   DATA bSideBack, bSideNext
   DATA bheaderLbDown
   DATA nOption
   DATA nGroups INIT 0

   DATA aSource INIT {}
   DATA aHeader INIT {}
   DATA oLVCol
   DATA oLVItem
   DATA aEvents INIT {}
   DATA bOnEvent
   DATA nview
   DATA hLv
   DATA oImageListBig, oImageListSmall
   DATA hFont
   DATA cPath
   DATA nIcoLarge INIT 32
   DATA nIcoSmall INIT 16
   DATA hTheme
   DATA lImage INIT .F.
   DATA lAllowed INIT .T.
   DATA cFilter INIT "*.*"
   DATA oHeader
   DATA SortOrder INIT LVS_SORTASCENDING
   DATA nColSort INIT F_NAME
   DATA oProgress
   DATA lExHeader INIT .F.
   DATA aPrompts INIT {}
   DATA nGroups INIT 0
   DATA lDispInfo INIT .F.
   DATA lFileIcon INIT .T.

   METHOD New( nTop, nLeft, aPrompts, bAction, oWnd, nClrFore, ;
               nClrBack, lPixel, lDesign, nWidth, nHeight, ;
               cMsg, nIcoLarge, nIcoSmall, lCheckbox, lDispInfo ) CONSTRUCTOR
   METHOD ReDefine( nId, oWnd, bAction ) CONSTRUCTOR
   METHOD DEFAULT()
   METHOD Notify( nIdCtrl, nPtrNMHDR )
   METHOD OnEvent( nEvent, aParams, pParams )
   METHOD SetImageList( oImageList, nType )
   METHOD CreateHeaderColumn()
   METHOD Destroy()
   METHOD OnDISPINFO()
   METHOD SetViewStyle()
   METHOD HandleEvent( nMsg, nWParam, nLParam )
   METHOD RefreshAll()
   METHOD RefreshCurrent( nRec )
   METHOD MarkAll()
   METHOD UnMarkAll( lAll )
   METHOD Getdata()
   METHOD RButtonDown( nRow, nCol, nKeyFlags )
   METHOD SetGridHeaderSort( nCol )
   METHOD ClearAndFillDir()
   METHOD SetHeaderItem()

   METHOD HScroll( nWParam, nLParam ) VIRTUAL                         // required for default behavior
   METHOD VScroll( nWParam, nLParam ) VIRTUAL                         // required for default behavior

   METHOD Help() INLINE MsgInfo( "F1 Help TGrid" )                    // ::HelpTopic()

   METHOD InsertItem( nImageIndex, cText, nGroup ) INLINE LVInsertItem( ::hWnd, nImageIndex, cText, nGroup )
   METHOD InsertGroup( cText ) INLINE LVInsertGroup( ::hWnd, cText, ::nGroups ++ )

   ENDCLASS

METHOD New( nTop, nLeft, aPrompts, bAction, oWnd, nClrFore, nClrBack, lPixel, lDesign, nWidth, nHeight, cMsg, nIcoLarge, nIcoSmall, lCheckbox, lDispInfo ) CLASS TGrid

LOCAL nPosi, nExStyle

   DEFAULT nTop := 0, nLeft := 0, ;
           aPrompts := {}, ;
           oWnd := GetWndDefault(), ;
           nClrFore := oWnd:nClrText, ;
           nClrBack := GetSysColor( COLOR_BTNFACE ), ;
           lPixel := .f., ;
           lDesign := .f., ;
           lCheckbox := .f., ;
           nWidth := 200, nHeight := 21, ;
           nIcoLarge := 32, nIcoSmall := 16, ;
           lDispInfo := .F.

   LV_INITCOMMON()

   ::oParent := oWnd

   ::nview := LVS_REPORT
   ::nStyle := nOR( LVS_SHAREIMAGELISTS, WS_CHILD, WS_VISIBLE, IF( lDesign, WS_CLIPSIBLINGS, 0 ), WS_TABSTOP, WS_BORDER, LVS_SHOWSELALWAYS, LVS_AUTOARRANGE, ::nview )

   IF lDispInfo = .T.
      ::lDispInfo := lDispInfo
      ::nStyle := nOR( ::nStyle, LVS_OWNERDATA )
      ::bDisplay := { | nPtrNMHDR | ::OnDISPINFO( nPtrNMHDR ) }
   ENDIF

   ::nId := ::GetNewId()
   ::oWnd := oWnd
   ::aPrompts := aPrompts
   ::bAction := bAction
   ::cMsg := cMsg
   ::nTop := IF( lPixel, nTop, nTop * SAY_CHARPIX_H )
   ::nLeft := IF( lPixel, nLeft, nLeft * SAY_CHARPIX_W )
   ::nBottom := ::nTop + nHeight - 1
   ::nRight := ::nLeft + nWidth - 1
   ::nWidth := nWidth
   ::lDrag := lDesign
   ::lCaptured := .f.
   ::oFont := TFont() :New( "Ms Sans Serif", 0, - 20 )
   ::nClrText := nClrFore
   ::nClrPane := nClrBack
   ::nOption := 1

   ::cPath := hb_Dirbase()

   IF !EMPTY( oWnd:hWnd )
      ::Create( CTRL_CLASS )
      oWnd:AddControl( Self )
   ELSE
      oWnd:DefControl( Self )
   ENDIF

   // ::Default()                                                     // what is this ?

   IF lDesign                                                         // what is this ?
      // ::CheckDots()
   ENDIF

   // handle of Listview
   ::hLv := ::hWnd

   //  #define Use_Header
#ifdef Use_Header
   ::bheaderLbDown := { | nPtrNMHDR, nKey, nItem | ::SetGridHeaderSort( nKey, nItem ) }
#endif
   // set FONT
   ::hFont := ::oFont:hFont
   SendMessage( ::hLv, WM_SETFONT, ::hFont, 0 )

   LV_SETBKCOLOR( ::hLv, nRGBRED( nClrBack ), nRGBGREEN( nClrBack ), nRGBBLUE( nClrBack ) )
   LV_SETTEXTBKCOLOR( ::hLv, nRGBRED( nClrBack ), nRGBGREEN( nClrBack ), nRGBBLUE( nClrBack ) )
   LV_SETTEXTCOLOR( ::hLv, nRGBRED( nClrFore ), nRGBGREEN( nClrFore ), nRGBBLUE( nClrFore ) )

   // set FULLROWSELECT
   nExStyle := nOr( LVS_EX_FULLROWSELECT, LVS_EX_DOUBLEBUFFER )
   IF lCheckbox = .T.
      nExStyle := nOr( nExStyle, LVS_EX_CHECKBOXES )
   ENDIF
   //   LV_CHANGEEXTENDEDSTYLE( ::hLv, nil,LVS_EX_GRIDLINES)
   LV_CHANGEEXTENDEDSTYLE( ::hLv, nExStyle )

   IF IsAppThemed()
      ::hTheme := C5_OpenThemeData( ::hLv, "LISTVIEW" + CHR( 0 ) )
   ENDIF

   // Icon Size
   ::nIcoLarge := nIcoLarge
   ::nIcoSmall := nIcoSmall

   ::oImageListBig := TImageList() :New( ::nIcoLarge, ::nIcoLarge )
   ::oImageListSmall := TImageList() :New( ::nIcoSmall, ::nIcoSmall )

   ::SetImageList( ::oImageListBig, LVSIL_NORMAL )
   ::SetImageList( ::oImageListSmall, LVSIL_SMALL )

RETURN Self

METHOD ReDefine( nId, oWnd, bAction ) CLASS TGrid                     // unknown

   DEFAULT oWnd := GetWndDefault()

   ::nId := nId
   ::oWnd := oWnd
   ::bAction := bAction
   ::aPrompts := {}

   oWnd:DefControl( Self )

RETURN Self

METHOD DEFAULT() CLASS TGrid

LOCAL n

   //    FOR n = 1 TO LEN( ::aPrompts )
   //       ::InsertItem( n - 1, ::aPrompts[ n ], 0 )
   //    NEXT

RETURN ::Super:Default()

METHOD Destroy() CLASS TGrid

   IF !EMPTY( ::oImageListBig )
      ::oImageListBig:End()                                           // ILDESTROY ?
   ENDIF
   IF !EMPTY( ::oImageListSmall )
      ::oImageListSmall:End()
   ENDIF
   IF ::hTheme != 0
      C5_CloseThemeData( ::hTheme )
   ENDIF

   ::Super:End()

RETURN Self

METHOD CreateHeaderColumn() CLASS TGrid

LOCAL nCol, nMax
LOCAL nWidth, cCaption, nFMT
LOCAL nClrFore, nClrBack
LOCAL aColSizes := {}

   IF ::lExHeader = .T.
      FOR nCol := 1 TO LEN( ::aHeader )
         nWidth := ::aHeader[ nCol ] [ ID_WIDTH ]
         AADD( aColSizes, nWidth )
      NEXT

      ::oHeader := THeader() :New( Self, 0, 0, ::nWidth, 30, AFILL( ARRAY( LEN( ::aHeader ) ), "" ), aColSizes, ::oFont, nClrFore, nClrBack, ;
                             { | nItem, oHeader, nMessage | MsgInfo( hb_valToExp( nItem ), hb_valToExp( nMessage ) ) } )

      //    {|nItem, oHeader, nMessage| HandleHeader( Self, nItem, oHeader, nMessage ) }  )
      //   ::oHeader:ahBmps := {"GRID_ASC","GRID_DSC"}
   ENDIF

   FOR nCol := 1 TO LEN( ::aHeader )
      nWidth := ::aHeader[ nCol ] [ ID_WIDTH ]
      cCaption := hb_valToExp( ::aHeader[ nCol ] [ ID_HEADER ] ) + CHR( 0 )
      nFMT := ::aHeader[ nCol ] [ ID_ALIGN ]

      // add Ownerdraw
      //  ::oLVCol:fmt := nOr(::oLVCol:fmt, HDF_OWNERDRAW)
      nFMT := nOr( nFMT, HDF_OWNERDRAW )

      LV_INSERTCOLUMN( ::hLv, nCol, nWidth, cCaption, nFMT )

      IF ::lExHeader = .T.
         ::oHeader:SetItem( nCol, cCaption, nWidth, nFMT, 1 )
      ENDIF

   NEXT

   IF ::lDispInfo = .T.
      nMax := LEN( ::aSource )
      // need for LVS_OWNERDATA / ::OnDISPINFO()
      LV_SETITEMCOUNT( ::hLv, nMax )
   ENDIF

RETURN self

METHOD SetHeaderItem( nIndex, cCaption, nWidth, nAlign, nSort, hBmp ) CLASS TGrid

   //    local hBmp := 0

   DEFAULT nIndex := 1, cCaption := "", nAlign := HDF_LEFT, nSort := 0

   nIndex --

   IF nSort != 0
      IF IsAppThemed()
         nAlign := nOr( nAlign, nSort )
      ELSE
         nAlign := nOr( nAlign, HDF_BITMAP, HDF_BITMAP_ON_RIGHT )

         /*
         if nSort == HDF_SORTDOWN
            hBmp := ::ahBmps[ 1 ]
         else
            hBmp := ::ahBmps[ 2 ]
         endif
         */
      ENDIF
   ENDIF

   HeaderSet( ::hLv, nIndex, cCaption, nWidth, nAlign, hBmp )

RETURN nil

METHOD Notify( nIdCtrl, nPtrNMHDR ) CLASS TGrid

LOCAL nCode := GetNMHDRCode( nPtrNMHDR )
LOCAL nItem := GETNMHEAITEM( nPtrNMHDR )
LOCAL nKey

STATIC nOption

   DO CASE
      CASE nCode == NM_DBLCLK
         nOption := GetNMListViewItem( nPtrNMHDR ) + 1
         IF ::bClick != nil
            ::nOption := nOption
            EVAL( ::bClick, ::nOption, Self )
         ENDIF

      CASE nCode == LVN_GETDISPINFO
         IF ::bDisplay != nil
            EVAL( ::bDisplay, nPtrNMHDR, Self )
         ENDIF

      CASE nCode == LVN_ITEMCHANGED
         nOption := GetNMListViewItem( nPtrNMHDR ) + 1
         IF ::nOption != nOption
            ::nOption := nOption
            IF ::bAction != nil
               EVAL( ::bAction, ::nOption, Self )
            ENDIF
         ENDIF

      CASE nCode == LVN_KEYDOWN
         nKey := LV_GETGRIDVKEY( nPtrNMHDR )
         IF nKey = 13
            IF ::bClick != nil
               IF ::lAllowed = .T.
                  //  ::nOption := nOption
                  //  use last from LVN_ITEMCHANGED
                  EVAL( ::bClick, ::nOption, Self )
               ENDIF
            ENDIF
         ENDIF

#ifdef Use_Header
      CASE nCode == LVN_COLUMNCLICK
         nOption := GetNMListViewItem( nPtrNMHDR ) + 1
         nKey := LV_GETGRIDCOLUMN( nPtrNMHDR )
         IF ::bheaderLbDown != nil
            IF ::lAllowed = .T.
               EVAL( ::bheaderLbDown, nPtrNMHDR, nKey + 1, nItem )
            ENDIF
         ENDIF
#endif

   ENDCASE

RETURN nil

METHOD OnDISPINFO( nPtrNMHDR ) CLASS TGrid

LOCAL aItem
LOCAL nRec
LOCAL nSub
LOCAL ctext
LOCAL cFile
LOCAL iImage
LOCAL bSaveError, oError

STATIC iLast := 0                                                     // unused

   bSaveError := ERRORBLOCK()
   ERRORBLOCK( { | e | BREAK( e ) } )
   BEGIN SEQUENCE

      aItem := LV_GETGRIDDISPINFOINDEX( nPtrNMHDR )
      SysRefresh()

      nRec := aItem[ 1 ]
      nSub := aItem[ 2 ]
      ctext := ::aSource[ nRec ] [ nSub ]                             // + CHR( 0 )

      DO CASE
         CASE VALTYPE( cText ) = "C"
            cText := TRIM( cText )
         CASE VALTYPE( cText ) = "N"
            cText := TRANSFORM( cText, "999,999,999,999" )
         CASE VALTYPE( cText ) = "D"
            cText := DTOC( cText )
         CASE VALTYPE( cText ) = "L"
            cText := IF( cText, "Y", "N" )
      ENDCASE

      LV_SETGRIDQUERYDATA( nPtrNMHDR, ctext, LEN( ctext ) )
      //  fwlog nRec,nSub, ctext

      IF ::lFileIcon = .T.
         IF nSub == 1
            cFile := ::cPath + ctext
            iImage := Icon_Read( cFile )
            //          IF iLast <> iImage
            iLast := iImage
            ILADDICON( ::oImageListSmall:hImageList, iImage )
            iImage := MAX( 0, ILADDICON( ::oImageListBig:hImageList, iImage ) )
            LV_SETGRIDQUERYIMAGE( nPtrNMHDR, iImage )
            //          ENDIF
            DeleteObject( iImage )
         ENDIF
      ENDIF

   END SEQUENCE
   ERRORBLOCK( bSaveError )

RETURN 0

METHOD OnEvent( nEvent, aParams, pParams ) CLASS TGrid                // unused

LOCAL nAt    := ASCAN( ::aEvents, { | aEvent | aEvent[ 2 ] == nEvent } )
LOCAL cEvent := IF( nAt != 0, ::aEvents[ nAt ] [ 1 ], "" )

   IF !EMPTY( ::bOnEvent )
      EVAL( ::bOnEvent, IF( !EMPTY( cEvent ), cEvent, nEvent ), aParams, pParams )
   ENDIF

RETURN nil

METHOD SetImageList( oImageList, nType ) CLASS TGrid

LOCAL nResult

   DEFAULT nType := LVSIL_NORMAL

   nResult = SendMessage( ::hLv, LVM_SETIMAGELIST, nType, oImageList:hImageList )

   SysRefresh()

RETURN nResult

METHOD SetViewStyle( nView, lUseExHeader ) CLASS TGrid

   DEFAULT nView := LVS_REPORT
   DEFAULT lUseExHeader := .F.

   ::lExHeader := lUseExHeader
   DO CASE
      CASE nView = LVS_ICON
         ::nStyle := nOR( LVS_SHAREIMAGELISTS, WS_CHILD, WS_VISIBLE, WS_TABSTOP, WS_BORDER, LVS_SHOWSELALWAYS, LVS_AUTOARRANGE, LVS_ICON )
      CASE nView = LVS_SMALLICON
         ::nStyle := nOR( LVS_SHAREIMAGELISTS, WS_CHILD, WS_VISIBLE, WS_TABSTOP, WS_BORDER, LVS_SHOWSELALWAYS, LVS_AUTOARRANGE, LVS_SMALLICON )
      CASE nView = LVS_LIST
         ::nStyle := nOR( LVS_SHAREIMAGELISTS, WS_CHILD, WS_VISIBLE, WS_TABSTOP, WS_BORDER, LVS_SHOWSELALWAYS, LVS_AUTOARRANGE, LVS_LIST )
      CASE nView = LVS_REPORT
         ::nStyle := nOR( LVS_SHAREIMAGELISTS, WS_CHILD, WS_VISIBLE, WS_TABSTOP, WS_BORDER, LVS_SHOWSELALWAYS, LVS_AUTOARRANGE, LVS_REPORT )
   ENDCASE
   IF ::lDispInfo = .T.
      ::nStyle := nOR( ::nStyle, LVS_OWNERDATA )
   ENDIF

   IF lUseExHeader = .T.
      ::nStyle := nOR( ::nStyle, LVS_NOCOLUMNHEADER )
   ENDIF

   SetWindowLong( ::hLv, GWL_STYLE, ::nStyle )
   ::nview := nView

   REDRAWWINDOW( ::hLv )
   UpdateWindow( ::hLv )

RETURN nView

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TGrid              // unused

   DO CASE
         //  use for LVS_OWNERDRAWFIXED
      CASE nMsg == WM_MEASUREITEM
      CASE nMsg == WM_DRAWITEM

      CASE nMsg == WM_XBUTTONDOWN
         IF NLOWORD( nWParam ) = MK_XBUTTON1
            IF !EMPTY( ::bSideBack )
               EVAL( ::bSideBack )
            ENDIF
         ELSEIF NLOWORD( nWParam ) = MK_XBUTTON2
            IF !EMPTY( ::bSideNext )
               EVAL( ::bSideNext )
            ENDIF
         ENDIF

      CASE nMsg == WM_SYSCOMMAND
         RETURN nil

   ENDCASE

RETURN ::Super:HandleEvent( nMsg, nWParam, nLParam )

METHOD RefreshAll() CLASS TGrid

LOCAL nCount := LV_GetCountPerPage( ::hLv )
LOCAL nTopNo := LV_GetTopIndex( ::hLv )
   LV_RedrawItems( ::hLv, nTopNo, nTopNo + nCount )
RETURN self

METHOD RefreshCurrent( nRec ) CLASS TGrid

   LV_RedrawItems( ::hLv, nRec, nRec )
   LV_ENSUREVISIBLE( ::hLv, nRec )

RETURN self

METHOD UnMarkAll() CLASS TGrid

LOCAL iMax   := LV_GETSELECTEDCOUNT( ::hLv )
LOCAL nCount := 0
LOCAL nSel
LOCAL nState := hb_BitOr( LVIS_SELECTED, LVIS_FOCUSED )
LOCAL nMask  := hb_BitOr( LVIS_SELECTED, LVIS_FOCUSED )

   LOCKWINDOWUPDATE( ::hLv )

   nSel := LV_GetSelectionMark( ::hLv )
   LV_SETITEMSTATE( ::hLv, nSel, 0, nOr( LVIS_SELECTED, LVIS_FOCUSED ) )

   iMax := LV_GETSELECTEDCOUNT( ::hLv )

   IF iMax > 0
      nSel := LV_GETNEXTITEM( ::hLv, - 1 )
      LV_SETITEMSTATE( ::hLv, nSel, 0, nOr( LVIS_SELECTED, LVIS_FOCUSED ) )

      DO WHILE .T.
         nSel := LV_GETNEXTITEM( ::hLv, nSel )

         nCount ++
         IF nSel > 0
            LV_SETITEMSTATE( ::hLv, nSel, 0, nOr( LVIS_SELECTED, LVIS_FOCUSED ) )
         ELSE
            EXIT
         ENDIF
         IF nCount > iMax
            EXIT
         ENDIF
      ENDDO
   ENDIF

   LOCKWINDOWUPDATE( 0 )

RETURN self

METHOD MarkAll() CLASS TGrid

LOCAL i, iMax := LEN( ::aSource )                                     // LV_GETITEMCOUNT()
LOCAL nState := nOr( LVIS_FOCUSED, LVIS_SELECTED )
LOCAL nMask  := nOr( LVIS_SELECTED, LVIS_FOCUSED )
LOCAL aDir   := DIRECTORY( EndwithSlash( ::cPath ) + ::cFilter )
LOCAL nFirst := 1000000
LOCAL cAttr, cName, cExt, cFile

   LOCKWINDOWUPDATE( ::hLv )

   //  ( 0 based )
   FOR i := 1 TO iMax
      LV_SETITEMSTATE( ::hLv, i, 0, nOr( LVIS_SELECTED, LVIS_FOCUSED ) )

      cAttr := ::aSource[ i ] [ F_ATTR ]
      cName := UPPER( TRIM( ::aSource[ i ] [ F_NAME ] ) )
      //      cExt  := TRIM(::aSource[ i ] [ LV_EXT  ])

      DO CASE
         CASE "S" $ cAttr
         CASE "D" $ cAttr
         CASE cName == ".."
         CASE cName == "."
         OTHERWISE
            IF ASCAN( aDir, { | x | UPPER( x[ F_NAME ] ) = cName } ) > 0
               LV_SETITEMSTATE( ::hLv, i, nState, nOr( LVIS_SELECTED, LVIS_FOCUSED ) )

               IF i < nFirst
                  nFirst := i
               ENDIF
            ENDIF
      ENDCASE
   NEXT
   LOCKWINDOWUPDATE( 0 )

   //    ::setTopItem(nFirst)

RETURN NIL

METHOD Getdata() CLASS TGrid

LOCAL aRet   := {}
LOCAL nSel   := - 1
LOCAL iMax
LOCAL nCount := 0
LOCAL nPosi

   iMax := LV_GETSELECTEDCOUNT( ::hLv )

   IF iMax > 0
      nSel := LV_GETNEXTITEM( ::hLv, - 1 )
      AADD( aRet, nSel )
      DO WHILE .T.
         nSel := LV_GETNEXTITEM( ::hLv, nSel )
         nCount ++
         IF nSel > 0
            AADD( aRet, nSel )
         ELSE
            EXIT
         ENDIF
         IF nCount > iMax
            EXIT
         ENDIF
      ENDDO

      //    ELSE
      //       AADD(aRet, ::lv_GetSelectionMark() )
   ENDIF

   nPosi := 1
   DO WHILE !EMPTY( nPosi )
      nPosi := ASCAN( aRet, { | x | x = 0 } )
      IF nPosi > 0
         ADEL( aRet, nPosi )
         ASIZE( aRet, LEN( aRet ) - 1 )
      ENDIF
   ENDDO
RETURN aRet

METHOD RButtonDown( nRow, nCol, nKeyFlags ) CLASS TGrid

   IF ::bRbClick != nil
      EVAL( ::bRbClick, ::oWnd, nRow, nCol, nKeyFlags )
   ENDIF
RETURN Self

METHOD SetGridHeaderSort( nCol, nItem ) CLASS TGrid

LOCAL aDirOut  := ACLONE( ::aSource )
LOCAL aCol     := ACLONE( ::aHeader )
LOCAL hGrid    := ::hLv
LOCAL nStartAt := 1
LOCAL jj, jMax
LOCAL nWidth, cCaption, nAlign
LOCAL hBmpA    := LoadBitmap( GetResources(), "GRID_ASC" )
LOCAL hBmpD    := LoadBitmap( GetResources(), "GRID_DSC" )

   ::nColSort := nCol

   jMax := LEN( aCol )
   jj := 1
   FOR jj := 1 TO jMax
      LV_SetSortHeader( hGrid, jj, 0 )
   NEXT
   IF ::SortOrder = LVS_SORTASCENDING
      LV_SetSortHeader( hGrid, nCol, 1 )
   ELSE
      LV_SetSortHeader( hGrid, nCol, - 1 )
   ENDIF

   IF nCol = F_DATE .OR. nCol = F_TIME
      nStartAt := 0
   ELSE
      // "D"irectry on Top
      ASORT( aDirOut,,, { | x, y | "D" $ x[ F_ATTR ] } )
      AEVAL( aDirOut, { | x, i | nStartAt := IF( "D" $ x[ F_ATTR ], i, nStartAt ) } )
      ASORT( aDirOut, 1, nStartAt, { | x, y | LOWER( x[ F_NAME ] ) < LOWER( y[ F_NAME ] ) } )
   ENDIF

   cCaption := hb_valToExp( ::aHeader[ nCol ] [ ID_HEADER ] ) + CHR( 0 )
   nWidth := ::aHeader[ nCol ] [ ID_WIDTH ]
   nAlign := ::aHeader[ nCol ] [ ID_ALIGN ]

   DO CASE
      CASE nCol = F_NAME
         IF ::SortOrder = LVS_SORTASCENDING
            //             ASORT( aDirOut, nStartAt + 1,, { | x, y | ( x[ F_NAME ], y[ F_NAME ], .T. ) } )
            ASORT( aDirOut, nStartAt + 1,, { | x, y | CompareFile( x[ F_NAME ], y[ F_NAME ], .T. ) } )
            HEADERSET( ::hLv, nCol, cCaption, nWidth, nAlign, hBmpA )
         ELSE
            //             ASORT( aDirOut, nStartAt + 1,, { | x, y | ( x[ F_NAME ], y[ F_NAME ], .F. ) } )
            ASORT( aDirOut, nStartAt + 1,, { | x, y | CompareFile( x[ F_NAME ], y[ F_NAME ], .F. ) } )
            HEADERSET( ::hLv, nCol, cCaption, nWidth, nAlign, hBmpD )
         ENDIF

      CASE nCol = F_SIZE
         IF ::SortOrder = LVS_SORTASCENDING
            ASORT( aDirOut, nStartAt + 1,, { | x, y | ( x[ F_SIZE ] ) < ( y[ F_SIZE ] ) } )
            HEADERSET( ::hLv, nCol, cCaption, nWidth, nAlign, hBmpA )
         ELSE
            ASORT( aDirOut, nStartAt + 1,, { | x, y | ( x[ F_SIZE ] ) > ( y[ F_SIZE ] ) } )
            HEADERSET( ::hLv, nCol, cCaption, nWidth, nAlign, hBmpD )
         ENDIF

      CASE nCol = F_DATE
         IF ::SortOrder = LVS_SORTASCENDING
            ASORT( aDirOut, nStartAt + 1,, { | x, y | ( x[ F_DATE ] ) < ( y[ F_DATE ] ) } )
            HEADERSET( ::hLv, nCol, cCaption, nWidth, nAlign, hBmpA )
         ELSE
            ASORT( aDirOut, nStartAt + 1,, { | x, y | ( x[ F_DATE ] ) > ( y[ F_DATE ] ) } )
            HEADERSET( ::hLv, nCol, cCaption, nWidth, nAlign, hBmpD )
         ENDIF

      CASE nCol = F_TIME
         IF ::SortOrder = LVS_SORTASCENDING
            ASORT( aDirOut, nStartAt + 1,, { | x, y | ( x[ F_TIME ] ) < ( y[ F_TIME ] ) } )
            HEADERSET( ::hLv, nCol, cCaption, nWidth, nAlign, hBmpA )
         ELSE
            ASORT( aDirOut, nStartAt + 1,, { | x, y | ( x[ F_TIME ] ) > ( y[ F_TIME ] ) } )
            HEADERSET( ::hLv, nCol, cCaption, nWidth, nAlign, hBmpD )
         ENDIF

      CASE nCol = F_ATTR
         IF ::SortOrder = LVS_SORTASCENDING
            ASORT( aDirOut, nStartAt + 1,, { | x, y | ( x[ F_ATTR ] ) < ( y[ F_ATTR ] ) } )
            HEADERSET( ::hLv, nCol, cCaption, nWidth, nAlign, hBmpA )
         ELSE
            ASORT( aDirOut, nStartAt + 1,, { | x, y | ( x[ F_ATTR ] ) > ( y[ F_ATTR ] ) } )
            HEADERSET( ::hLv, nCol, cCaption, nWidth, nAlign, hBmpD )
         ENDIF

   ENDCASE

   IF ::SortOrder = LVS_SORTASCENDING
      ::SortOrder := LVS_SORTDESCENDING
   ELSE
      ::SortOrder := LVS_SORTASCENDING
   ENDIF

   DeleteObject( hBmpA )
   DeleteObject( hBmpD )

   ::aSource := aDirOut

   ::ClearAndFillDir()

RETURN aDirOut

METHOD ClearAndFillDir( oDlg ) CLASS TGrid

LOCAL ii, nMax, aItem, iImage, iTemp_0, iTemp_1, cIcoOrBmp := ""
LOCAL cFile, hBitMap, aBitmaps, cExt, nError, nPosi, lErase := .F.
LOCAL cParameter, cPNG, nEvery
LOCAL nPerPage   := LV_GetCountPerPage( ::hLv )
LOCAL oParent

   IF !EMPTY( oDlg )
      oParent := oDlg
   ELSE
      oParent := ::oParent
   ENDIF

   IF ::lAllowed = .T.
      ::lAllowed := .F.                                               // disable Notify

      SendMessage( ::hLv, LVM_DELETEALLITEMS, 0, 0 )
      ImageList_RemoveAll( ::oImageListSmall )
      ImageList_RemoveAll( ::oImageListBig )
      SysRefresh()

      ::oProgress := TProgress() :New( 4, 0, oParent, 0,,, .T., .F., oParent:nWidth - 1, 8 )
      ::oProgress:SetRange( 0, 100 )
      ::oProgress:SetPos( 0 )
      ::oProgress:SetStep( 1 )

      nMax := LEN( ::aSource )
      nEvery := INT( ROUND( nMax / 100, 0 ) )
      ii := 1
      // slow Way i a loop
      FOR ii := 1 TO nMax

         cIcoOrBmp := ""

         IF ( ii % nEvery ) = 0
            SysRefresh()
            ::oProgress:StepIt()
         ENDIF

         IF ii = nPerPage
            // 1st. Screen "full" so now "Speed-up" build
            //          LV_HIDEWINDOW( ::hLv )                                 // ShowWindow(hWnd, SW_HIDE)
         ENDIF

         aItem := { ::aSource[ ii ] [ F_NAME ], ;
                    STR( ::aSource[ ii ] [ F_SIZE ] ), ;
                    DTOC( ::aSource[ ii ] [ F_DATE ] ), ;
                    ::aSource[ ii ] [ F_TIME ], ;
                    ::aSource[ ii ] [ F_ATTR ] }

         cFile := TRIM( ::aSource[ ii ] [ F_NAME ] )

         // how to show in Statusbar ???
         SayBar( cFile )
         // ::cMsg := cFile

         SysRefresh()
         IF ::lImage = .T.

            cParameter := ""
            lErase := .F.
            cExt := UPPER( cFileExt( cFile ) )

            IF cExt $ "PDF"
               cPNG := STRTRAN( UPPER( cFile ), ".PDF", ".PNG" )
               //  mutool draw -o "%1.png" -r 96 -h 150 "%1" 1-1
               cParameter := "draw -o " + ::cPath + cPNG + " -r 96 -h 192 " + ::cPath + cFile + " 1-1"

               nError := WaitRun( "mutool.exe " + cParameter, SW_HIDE )
               // FWLOG "mutool.exe", nError

               IF nError = 0
                  cExt := "PNG"
                  cFile := cPNG
                  SysRefresh()
                  lErase := .T.
               ELSE
                  lErase := .F.
               ENDIF
            ENDIF

            IF cExt $ "BMP,JPG,PNG,GIF,ICO,CUR,DLL,JPEG,TIF,TIFF,EMF,WMF"
               cIcoOrBmp := "BMP"

               // ******** small Icon ********
               // make it +8 Pixel bigger while RESIZEBMP() do NOT change Aspect Ratio

               aBitmaps := ::oWnd:ReadImage( ::cPath + cFile, { ::nIcoSmall + 8, ::nIcoSmall + 8 } )
               iTemp_0 := aBitmaps[ 1 ]

               // change Aspect Ratio while else might not display
               iTemp_1 := RESIZEBMP( iTemp_0, ::nIcoSmall, ::nIcoSmall, .T. )

               ILADD( ::oImageListSmall:hImageList, iTemp_1 )

               PalBmpFree( aBitmaps )
               // Delete Object
               DeleteObject( iTemp_0 )
               DeleteObject( iTemp_1 )
               SysRefresh()

               // ******** big Icon **********

               aBitmaps := ::oWnd:ReadImage( ::cPath + cFile, { ::nIcoLarge + ::nIcoSmall, ::nIcoLarge + ::nIcoSmall } )
               iTemp_0 := aBitmaps[ 1 ]

               // change Aspect Ratio while else might not display
               iTemp_1 := RESIZEBMP( iTemp_0, ::nIcoLarge, ::nIcoLarge, .T. )

               iImage := MAX( 0, ILADD( ::oImageListBig:hImageList, iTemp_1 ) )

               PalBmpFree( aBitmaps )
               // Delete Object
               DeleteObject( iTemp_0 )
               DeleteObject( iTemp_1 )
               SysRefresh()
            ELSE
               cIcoOrBmp := "ICO"

               // search for System Icon
               iTemp_0 := Icon_Read( ::cPath + cFile, 32 )
               ILADDICON( ::oImageListSmall:hImageList, iTemp_0 )
               iImage := MAX( 0, ILADDICON( ::oImageListBig:hImageList, iTemp_0 ) )
               DestroyIcon( iTemp_0 )
               SysRefresh()
            ENDIF
         ELSE
            cIcoOrBmp := "ICO"

            // search for System Icon
            iTemp_0 := Icon_Read( ::cPath + cFile, 32 )
            ILADDICON( ::oImageListSmall:hImageList, iTemp_0 )
            iImage := MAX( 0, ILADDICON( ::oImageListBig:hImageList, iTemp_0 ) )
            DestroyIcon( iTemp_0 )
            SysRefresh()
         ENDIF

         LV_ADDITEMS( ::hLv, aItem, iImage )

         // Delete iImage
         DO CASE
            CASE cIcoOrBmp = "BMP"
               DeleteObject( iImage )
            CASE cIcoOrBmp = "ICO"
               DestroyIcon( iImage )
         ENDCASE
         SysRefresh()

         IF !EMPTY( cParameter ) .AND. lErase = .T.
            FERASE( ::cPath + cFile )
         ENDIF
      NEXT

      ::oProgress:End()
      ::oProgress := NIL

      // LV_SHOWWINDOW( ::hLv )                                       // ShowWindow(hWnd, SW_SHOW)

      ::RefreshAll()
      LV_SETITEMSELECT( ::hLv, 1 )

      ::lAllowed := .T.                                               // enable Notify
   ENDIF

RETURN nil

*+--------------------------------------------------------------------
*+
*+    Function HandleHeader()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HandleHeader( Self, nItem, oHeader, nMessage )

   msginfo( "HandleHeader " + hb_valToExp( nItem ), hb_valToExp( nMessage ) )

   DO CASE
      CASE nMessage == HDN_ENDTRACK
      CASE nMessage == HDN_ITEMDBLCLICK
         //  msginfo("HandleHeader "+ hb_valToExp(nItem), hb_valToExp(nMessage))
   ENDCASE

RETURN 0

//
//
//

*+ EOF: TGRID.PRG
