/*********************************************************************

ListView_GetItemCount               https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_getitemcount
ListView_InsertItem                 https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_insertitem
ListView_SetItemText                https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_setitemtext
ListView_InsertColumn               https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_insertcolumn
ListView_GetExtendedListViewStyle   https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_getextendedlistviewstyle
ListView_SetExtendedListViewStyle   https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_setextendedlistviewstyle
ListView_DeleteColumn               https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_deletecolumn
ListView_EnsureVisible              https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_ensurevisible
ListView_GetBkColor                 https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_setbkcolor
ListView_GetCountPerPage            https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_getcountperpage
ListView_GetItemState               https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_getitemstate
ListView_GetItem                    https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_getitem
ListView_GetNextItem                https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_getnextitem
ListView_GetSelectedCount           https://learn.microsoft.com/de-de/windows/win32/api/commctrl/nf-commctrl-listview_getselectedcount
ListView_GetSelectionMark           https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_getselectionmark
ListView_GetTextColor               https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_gettextcolor
ListView_GetTopIndex                https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_gettopindex
ListView_GetSubItemRect             https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_getsubitemrect
ListView_GetItemRect                https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_getitemrect
ListView_SubItemHitTest             https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_subitemhittest
ListView_RedrawItems                https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_redrawitems
ListView_Scroll                     https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_scroll
ListView_SetBkColor                 https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_setbkcolor
ListView_SetItemCount               https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_setitemcount
ListView_SetItemState               https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_setitemstate
ListView_SetTextBkColor             https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_settextbkcolor
ListView_SetTextColor               https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_settextcolor
ListView_Update                     https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_update
ListView_GetHeader                  https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_getheader
ListView_SetColumnWidth             https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_setcolumnwidth
ListView_GetColumnWidth             https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_setcolumnwidth
ListView_SetCheckState              https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_setcheckstate
ListView_GetCheckState              https://learn.microsoft.com/en-us/windows/win32/api/commctrl/nf-commctrl-listview_getcheckstate
*********************************************************************/

******************************** HB_FUNC()      ****************************

#pragma BEGINDUMP

#include <windows.h>
#include <commctrl.h>
#include <dbt.h>
#include <hbapi.h>
#include <hbapiitm.h>
#include "hbapifs.h"
#include <ShlObj.h>
#include <tchar.h>

#include <winioctl.h>
#include <stdio.h>

#define AVOID_COMPILER_WARNING   // by Dr. Claudio Soto (November 2013)

// #define UNICODE
LPWSTR AnsiToWide( LPSTR cAnsi );

// Prototypes
BOOL EjectVolume(TCHAR cDriveLetter);
HANDLE OpenVolume(TCHAR cDriveLetter);
BOOL LockVolume(HANDLE hVolume);
BOOL DismountVolume(HANDLE hVolume);
BOOL PreventRemovalOfVolume(HANDLE hVolume, BOOL fPrevent);
BOOL AutoEjectVolume(HANDLE hVolume);
BOOL CloseVolume(HANDLE hVolume);

LPTSTR szVolumeFormat = TEXT("\\\\.\\%c:");
LPTSTR szRootFormat = TEXT("%c:\\");

HANDLE OpenVolume(TCHAR cDriveLetter)
{
   HANDLE hVolume;
   UINT uDriveType;
   TCHAR szVolumeName[8];
   TCHAR szRootName[5];
   DWORD dwAccessFlags;

   wsprintf(szRootName, szRootFormat, cDriveLetter);
   uDriveType = GetDriveType(szRootName);

   switch(uDriveType)
   {
   case DRIVE_REMOVABLE:
     dwAccessFlags = GENERIC_READ | GENERIC_WRITE;
     break;
   case DRIVE_CDROM:
     dwAccessFlags = GENERIC_READ;
     break;
   default:
     return INVALID_HANDLE_VALUE;
   }

   wsprintf(szVolumeName, szVolumeFormat, cDriveLetter);

   hVolume = CreateFile( szVolumeName,
                         dwAccessFlags,
                         FILE_SHARE_READ | FILE_SHARE_WRITE,
                         NULL,
                         OPEN_EXISTING,
                         0,
                         NULL );
   return hVolume;
}

BOOL CloseVolume(HANDLE hVolume)
{
   return CloseHandle(hVolume);
}

#define LOCK_TIMEOUT        10000       // 10 Seconds
#define LOCK_RETRIES        20

BOOL LockVolume( HANDLE hVolume )
{
   DWORD dwBytesReturned;
   DWORD dwSleepAmount;
   int nTryCount;

   dwSleepAmount = LOCK_TIMEOUT / LOCK_RETRIES;

   for( nTryCount = 0; nTryCount < LOCK_RETRIES; nTryCount++ )
   {
     if( DeviceIoControl( hVolume, FSCTL_LOCK_VOLUME, NULL, 0, NULL, 0,
                          &dwBytesReturned, NULL ) )
         return TRUE;

     Sleep( dwSleepAmount );
   }

   return FALSE;
}

BOOL DismountVolume( HANDLE hVolume )
{
   DWORD dwBytesReturned;
   return DeviceIoControl( hVolume, FSCTL_DISMOUNT_VOLUME, NULL, 0, NULL, 0,
                           &dwBytesReturned, NULL );
}

BOOL PreventRemovalOfVolume(HANDLE hVolume, BOOL fPreventRemoval)
{
   DWORD dwBytesReturned;
   PREVENT_MEDIA_REMOVAL PMRBuffer;
   PMRBuffer.PreventMediaRemoval = fPreventRemoval;
   return DeviceIoControl( hVolume, IOCTL_STORAGE_MEDIA_REMOVAL,
                           &PMRBuffer, sizeof(PREVENT_MEDIA_REMOVAL),
                           NULL, 0, &dwBytesReturned, NULL );
}

AutoEjectVolume( HANDLE hVolume )
{
   DWORD dwBytesReturned;
   return DeviceIoControl( hVolume, IOCTL_STORAGE_EJECT_MEDIA, NULL, 0, NULL, 0,
                         &dwBytesReturned,
                         NULL );
}

BOOL EjectVolume( TCHAR cDriveLetter )
{
   HANDLE hVolume;
   BOOL bResult = FALSE;

   hVolume = OpenVolume(cDriveLetter);
     if( hVolume != INVALID_HANDLE_VALUE )
   {
      bResult = LockVolume( hVolume );
      if( bResult )
      {
         bResult = DismountVolume( hVolume );
         if( bResult )
         {
            bResult = PreventRemovalOfVolume( hVolume, FALSE );
            if( bResult )
            {
               bResult = AutoEjectVolume( hVolume );
               if( bResult )
               {
                  CloseVolume( hVolume );
               }
            }
         }
      }
   }
   return  bResult ;
}

HB_FUNC( EJECTREMOVABLE )
{
   hb_retl( EjectVolume( ( TCHAR ) * hb_parc( 1 ) ) );
   return;
}

HB_FUNC( DISMOUNTVOLUME )
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   hb_retl( DismountVolume( hWnd ) );
}

SECURITY_ATTRIBUTES sa;

HB_FUNC( LPSECURITY_ATTRIBUTES )
{
   sa.nLength = sizeof( sa );
   sa.lpSecurityDescriptor = NULL;
   sa.bInheritHandle = hb_parl( 1 );

   hb_retnll( ( LONGLONG ) &sa );
}

HB_FUNC( C_GETSPECIALFOLDER ) // Contributed By Ryszard Ryüko
{
   TCHAR *lpBuffer = (TCHAR*) hb_xgrab( (MAX_PATH+1) * sizeof(TCHAR));
   LPITEMIDLIST pidlBrowse;    // PIDL selected by user
   SHGetSpecialFolderLocation(GetActiveWindow(), hb_parni(1) , &pidlBrowse) ;
   SHGetPathFromIDList(pidlBrowse,lpBuffer);
   hb_retc(lpBuffer);
   hb_xfree( lpBuffer);
}

HB_FUNC( DEVICECHANGEINFO ) // DeviceChangeInfo( wParam, lParam )
{
//   WPARAM wParam = hb_parnl( 1 );
   PDEV_BROADCAST_HDR lpdb = (PDEV_BROADCAST_HDR) hb_parnll( 2 );
//   TCHAR szMsg[80];

   if ( lpdb->dbch_devicetype == DBT_DEVTYP_VOLUME )
   {
      PDEV_BROADCAST_VOLUME lpdbv = (PDEV_BROADCAST_VOLUME) lpdb;
      hb_retnl( lpdbv->dbcv_unitmask );
   } else hb_retnl( 0 );

}

HB_FUNC( SHFILE )
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif

   SHFILEOPSTRUCT sh;

   memset( ( char * ) &sh, 0, sizeof( sh ) );

   sh.hwnd   = hWnd ;
   sh.wFunc  = ( UINT ) hb_parnl( 2 );
   sh.pFrom  = ( LPSTR ) hb_parc( 3 );
   sh.pTo    = ( LPSTR ) hb_parc( 4 );
   sh.fFlags = ( FILEOP_FLAGS ) hb_parnl( 5 );
   sh.hNameMappings = 0;
   sh.lpszProgressTitle = NULL;

   hb_retnl( SHFileOperation( &sh ) );
}

HB_FUNC( SHOWFILEPROPERTIES )
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif

   SHELLEXECUTEINFO SHExecInfo;
   ZeroMemory(&SHExecInfo, sizeof(SHExecInfo));

   SHExecInfo.cbSize       = sizeof(SHExecInfo);
   SHExecInfo.fMask        = SEE_MASK_INVOKEIDLIST;
   SHExecInfo.lpVerb       = "Properties";
   SHExecInfo.lpDirectory  = hb_parc(2);
   SHExecInfo.lpFile       = hb_parc(3);
   SHExecInfo.nShow        = SW_SHOW;
   SHExecInfo.hwnd         = hWnd;

   ShellExecuteEx(&SHExecInfo);
}

HB_FUNC( GETKEYBOARDLAYOUT )
{
   DWORD idThread = (DWORD) hb_parni (1);   // Zero for the current thread
   HKL hkl = GetKeyboardLayout (idThread);
   hb_retnll ((LONG_PTR) hkl );
}

HB_FUNC( FINDWINDOWEX )
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
      HWND hWnd2 = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
      HWND hWnd2 = ( HWND ) hb_parnll( 1 );
   #endif


   hb_retnll((LONG_PTR)  FindWindowEx ( hWnd ,
                                        hWnd2,
                                        hb_parc  (3),
                                        hb_parc  (4)  ));
}

HB_FUNC( XDRAWTEXT )
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   RECT rct;

      rct.top    = hb_parvni( 3, 1 );
      rct.left   = hb_parvni( 3, 2 );
      rct.bottom = hb_parvni( 3, 3 );
      rct.right  = hb_parvni( 3, 4 );

      hb_retni( DrawText( ( HDC ) hWnd ,
                                  hb_parc( 2 ),
                                  -1,
                                  &rct,
                                  hb_parnl( 4 ) ) );
      hb_storvni( rct.top, 3, 1 );
      hb_storvni( rct.left, 3, 2 );
      hb_storvni( rct.bottom, 3, 3 );
      hb_storvni( rct.right, 3, 4 );
}

HB_FUNC( IMAGELIST_REMOVEALL )
{
   #ifndef _WIN64
   ImageList_RemoveAll( ( HIMAGELIST ) hb_parnl( 1 ) );
   #else
   ImageList_RemoveAll( ( HIMAGELIST ) hb_parnll( 1 ) );
   #endif
}

HB_FUNC( REDRAWWINDOW )
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   RedrawWindow (hWnd, NULL , NULL , RDW_ERASE | RDW_FRAME | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
}

//******************************** Listview ********************************

// LV_ADDITEM ( hWnd, aItem, [nRow] )
HB_FUNC( LV_ADDITEM )
{
   LV_ITEM lvi;
   WORD nColumnCount;
   int nCol, nRow;

   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   nColumnCount = ( WORD ) hb_parinfa (2, 0);

   if ( HB_ISNIL(4) )
      nRow = ListView_GetItemCount (hWnd);
   else
      nRow = hb_parni (3);

   lvi.mask       = LVIF_TEXT ;
   lvi.state      = 0;
   lvi.stateMask  = 0;
   lvi.iImage     = -1;
   lvi.iSubItem   = 0;
   lvi.iItem      = nRow;
   lvi.pszText    = (TCHAR*) hb_parvc (2, 1);

   ListView_InsertItem (hWnd, &lvi);

   for (nCol = 1; nCol < nColumnCount; nCol++)
       ListView_SetItemText (hWnd, nRow, nCol, (TCHAR*) hb_parvc (2, nCol+1));

}

// LV_ADDITEMS ( hWnd, aItem, iImage, [nRow] )
HB_FUNC( LV_ADDITEMS )
{
   LV_ITEM lvi;
   WORD nColumnCount;
   int nCol, nRow;

   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   nColumnCount = ( WORD ) hb_parinfa (2, 0);

   if ( HB_ISNIL(4) )
      nRow = ListView_GetItemCount (hWnd);
   else
      nRow = hb_parni (4);

   lvi.mask       = LVIF_TEXT | LVIF_IMAGE;
   lvi.state      = 0;
   lvi.stateMask  = 0;
   lvi.iImage     = hb_parni (3);
   lvi.iSubItem   = 0;
   lvi.iItem      = nRow;
   lvi.pszText    = (TCHAR*) hb_parvc (2, 1);

   ListView_InsertItem (hWnd, &lvi);

   for (nCol = 1; nCol < nColumnCount; nCol++)
       ListView_SetItemText (hWnd, nRow, nCol, (TCHAR*) hb_parvc (2, nCol+1));

}

// LV_ADDCOLUMN( hWnd, nSubItem, nWeight, cText, nFMT )
HB_FUNC( LV_ADDCOLUMN )
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   LV_COLUMN COL;

   COL.mask= LVCF_WIDTH | LVCF_TEXT | LVCF_FMT | LVCF_SUBITEM ;
   COL.cx= hb_parni(3);
   COL.pszText = (TCHAR*) hb_parc(4);
   COL.iSubItem=hb_parni(2)-1;
   COL.fmt = hb_parni(5) ;

   ListView_InsertColumn ( hWnd, hb_parni(2)-1, &COL );
}

// LV_ChangeExtendedStyle ( hWnd, [ nAddStyle ], [ nRemoveStyle ] )
HB_FUNC( LV_CHANGEEXTENDEDSTYLE )
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   DWORD Add     = (DWORD) hb_parnl  (2);
   DWORD Remove  = (DWORD) hb_parnl  (3);
   DWORD OldStyle, NewStyle, Style;

   OldStyle = ListView_GetExtendedListViewStyle (hWnd);
   NewStyle = (OldStyle | Add) & ( ~Remove );
   Style = ListView_SetExtendedListViewStyle ( hWnd, NewStyle );
   hb_retnl ((LONG) Style);
}

HB_FUNC( LV_COLUMNEND )
{
   hb_xfree( ( void * ) hb_parptr( 1 ) );
}

HB_FUNC( LV_DELETECOLUMN )
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   ListView_DeleteColumn ( hWnd, hb_parni(2)-1 );
}

// LV_ENSUREVISIBLE( hWnd, nItem, lPart)
HB_FUNC( LV_ENSUREVISIBLE)
{
   BOOL lEnablePartialView = HB_ISLOG (3) ? hb_parl (3) : TRUE;
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   ListView_EnsureVisible( hWnd, hb_parni(2)-1 , lEnablePartialView ) ;
}

HB_FUNC( LV_GETBKCOLOR )
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   hb_retnl ( ListView_GetBkColor ( hWnd ) ) ;
}

HB_FUNC( LV_GETCOUNTPERPAGE )
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   hb_retnl ( ListView_GetCountPerPage ( hWnd ) ) ;
}

HB_FUNC( LV_GETITEMSTATE )
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   INT  nRow   = (INT)  hb_parni  (2);
   UINT uMask  = (UINT) hb_parni  (3);

   hb_retni ((INT) ListView_GetItemState ( hWnd, (nRow - 1), uMask ) );
}

// LV_GETITEMTEXT (ControlHandle, nRow, nCol)
HB_FUNC( LV_GETITEMTEXT )
{
   TCHAR buffer [1024] ;
   LV_ITEM lvi;

   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif

   lvi.mask = LVIF_TEXT | LVIF_IMAGE;
   lvi.state = 0;
   lvi.stateMask = 0;
   lvi.iItem = hb_parni( 2 ) - 1;
   lvi.iSubItem = hb_parni( 3 ) - 1; ;
   lvi.cchTextMax = 1022;
   lvi.pszText = buffer;
   buffer[ 0 ] = 0;
   buffer[ 1023 ] = 0;

   ListView_GetItem( hWnd, &lvi );

   hb_retc (lvi.pszText);
}

// LV_GETGRIDVKEY( nPtrNMHDR )
HB_FUNC( LV_GETGRIDVKEY )
{
   #ifndef _WIN64
      LPARAM lParam = (LPARAM) hb_parnl (1);
   #else
      LPARAM lParam = (LPARAM) hb_parnll (1);
   #endif
   LV_KEYDOWN * LVK = (LV_KEYDOWN*) lParam;
   hb_retni ( LVK->wVKey );
}

HB_FUNC( LV_GETGRIDCOLUMN )
{
   #ifndef _WIN64
      LPARAM lParam = (LPARAM) hb_parnl (1);
   #else
      LPARAM lParam = (LPARAM) hb_parnll (1);
   #endif

   NM_LISTVIEW * NMLV = (NM_LISTVIEW*) lParam;

   hb_retni ( NMLV->iSubItem );
}

HB_FUNC( LV_GETNEXTITEM )
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   hb_retni( ListView_GetNextItem( hWnd, (int) (hb_parni(2)-1) , LVNI_ALL | LVNI_SELECTED ) + 1 );
}

HB_FUNC( LV_GETSELECTEDCOUNT )
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   #ifdef AVOID_COMPILER_WARNING
      hb_retnll( SendMessage( hWnd, LVM_GETSELECTEDCOUNT, 0, 0) ) ;
   #else
      hb_retnll( ListView_GetSelectedCount(hWnd) );
   #endif
}

HB_FUNC( LV_GETSELECTIONMARK )
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   #ifdef AVOID_COMPILER_WARNING
      hb_retnll( SendMessage( hWnd, LVM_GETSELECTIONMARK, 0, 0) ) ;
   #else
      hb_retnll( ListView_GetSelectionMark(hWnd) );
   #endif
}

HB_FUNC( LV_GETTEXTCOLOR )
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   hb_retnl ( ListView_GetTextColor ( hWnd ) ) ;
}

HB_FUNC( LV_GETTOPINDEX )
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   hb_retnl ( ListView_GetTopIndex ( hWnd ) ) ;
}

HB_FUNC( LV_GETSUBITEMRECT )
{
   RECT Rect;
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   int  iItem    = (int)  hb_parni (2);   // Index of the subitem's parent item
   int  iSubItem = (int)  hb_parni (3);   // The one-based index of the subitem
   int  code     = (int)  LVIR_BOUNDS;    // A portion of the list-view subitem for which to retrieve the bounding rectangle information

   #ifdef AVOID_COMPILER_WARNING
      Rect.top  = iSubItem;
      Rect.left = code;
      SendMessage ( hWnd, LVM_GETSUBITEMRECT, (WPARAM) iItem, (LPARAM) &Rect );
   #else
      ListView_GetSubItemRect ( hWnd, iItem, iSubItem, code, &Rect ) ;
   #endif

   hb_reta( 4 );
   hb_storvni( Rect.top  , -1, 1 );
   hb_storvni( Rect.left  , -1, 2 );
   hb_storvni( Rect.right - Rect.left , -1, 3 );
   hb_storvni( Rect.bottom - Rect.top  , -1, 4 );
}

HB_FUNC( LV_GETITEMRECT )
{
   RECT Rect ;
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   int  i    = (int)  hb_parni (2);   // The index of the list-view item
   int  code = (int)  LVIR_LABEL;     // The portion of the list-view item from which to retrieve the bounding rectangle

   #ifdef AVOID_COMPILER_WARNING
      Rect.left = code;
      SendMessage ( hWnd, LVM_GETITEMRECT, (WPARAM) i, (LPARAM) &Rect );
   #else
      ListView_GetItemRect ( hWnd, i, &Rect, code );
   #endif

   hb_reta( 4 );
   hb_storvni( Rect.top  , -1, 1 );
   hb_storvni( Rect.left  , -1, 2 );
   hb_storvni( Rect.right - Rect.left , -1, 3 );
   hb_storvni( Rect.bottom - Rect.top  , -1, 4 );
}

HB_FUNC( LV_HIDEWINDOW )
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   hb_retnl( ShowWindow(hWnd, SW_HIDE) );
}

HB_FUNC( LV_HITTEST )
{

   POINT point ;
   LVHITTESTINFO lvhti;

   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   point.y = hb_parni(2) ;
   point.x = hb_parni(3) ;

   lvhti.pt = point;

   ListView_SubItemHitTest ( hWnd, &lvhti ) ;

   if(lvhti.flags & LVHT_ONITEM)
   {
      hb_reta( 2 );
      hb_storvni( lvhti.iItem + 1 , -1, 1 );
      hb_storvni( lvhti.iSubItem + 1 , -1, 2 );
   }
   else
   {
      hb_reta( 2 );
      hb_storvni( 0 , -1, 1 );
      hb_storvni( 0 , -1, 2 );
   }
}

HB_FUNC( LV_INSERTCOLUMN )
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif

   LV_COLUMN COL;

   COL.mask= LVCF_WIDTH | LVCF_TEXT | LVCF_FMT | LVCF_SUBITEM ;
   COL.cx= hb_parni(3);
   COL.pszText = (TCHAR*) hb_parc(4);
   COL.iSubItem=hb_parni(2)-1;
   COL.fmt = hb_parni(5) ;

   ListView_InsertColumn ( hWnd, hb_parni(2)-1, &COL );

}

HB_FUNC( LV_REDRAWITEMS )
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   hb_retnl ( ListView_RedrawItems ( hWnd, hb_parni(2) , hb_parni(3) ) ) ;
}

// LV_Scroll ( hWnd, nDx, nDy )
HB_FUNC( LV_SCROLL )
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   ListView_Scroll( hWnd, hb_parni(2), hb_parni(3) ) ;
}

HB_FUNC( LV_SETBKCOLOR )
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   ListView_SetBkColor ( hWnd, (COLORREF) RGB(hb_parni(2), hb_parni(3), hb_parni(4)) ) ;
}

// LV_SETITEMCOUNT( hWnd, nMax )
HB_FUNC( LV_SETITEMCOUNT )
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   INT  nItemCount = (INT) hb_parni (2);

//   SendMessage ( hWnd, LVM_SETITEMCOUNT, (WPARAM) hb_parni (2), (LPARAM) 0 );
   if ( (GetWindowLongPtr (hWnd, GWL_STYLE) & LVS_OWNERDATA) == LVS_OWNERDATA )   // ADD3, July 2015
       ListView_SetItemCountEx (hWnd, nItemCount, LVSICF_NOINVALIDATEALL);
   else
       ListView_SetItemCount (hWnd, nItemCount);
}

// LV_SETITEMSELECT( hWnd, nPosi )
HB_FUNC( LV_SETITEMSELECT )
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif

   ListView_EnsureVisible( hWnd, hb_parnl( 2 ) -1, FALSE );
   ListView_SetItemState( hWnd, -1, 0, LVIS_SELECTED );
   ListView_SetItemState( hWnd, hb_parnl( 2 ) -1, ( LVIS_SELECTED | LVIS_FOCUSED ), ( LVIS_SELECTED | LVIS_FOCUSED ) );
}

HB_FUNC( LV_SETITEMSTATE)
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   ListView_SetItemState( hWnd, (int) (hb_parni(2)-1) , hb_parni(3) , hb_parni(4) );
}

HB_FUNC( LV_SETTEXTBKCOLOR )
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   ListView_SetTextBkColor ( hWnd, (COLORREF) RGB(hb_parni(2), hb_parni(3), hb_parni(4)) ) ;
}

HB_FUNC( LV_SETTEXTCOLOR )
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   ListView_SetTextColor ( hWnd, (COLORREF) RGB(hb_parni(2), hb_parni(3), hb_parni(4)) ) ;
}

// LV_SetItemText (hWnd, aItem, nRow)
HB_FUNC( LV_SETITEMTEXT )
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   WORD nLen = ( WORD ) hb_parinfa (2, 0);
   int  nRow = hb_parni (3) - 1;
   TCHAR *cText;
   int nCol;

   for (nCol=0 ; nCol < nLen ; nCol++ )
   {
      cText = (TCHAR*) hb_parvc (2 , nCol + 1);
      ListView_SetItemText (hWnd, nRow, nCol, cText);
   }
}

// LV_SHOWWINDOW(hWnd)
HB_FUNC( LV_SHOWWINDOW )
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   hb_retnl( ShowWindow(hWnd, SW_SHOW) );
}

HB_FUNC( LV_UPDATE )
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   hb_retnl( ListView_Update ( hWnd, hb_parni(2) - 1 ) );
}

// LV_GETITEMCOUNT(hWnd)
HB_FUNC( LV_GETITEMCOUNT )
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   hb_retnl ( ListView_GetItemCount ( hWnd ) ) ;
}

HB_FUNC( LV_INITCOMMON )
{
   INITCOMMONCONTROLSEX i;

   memset( ( char * ) &i, 0, sizeof( INITCOMMONCONTROLSEX ) );

   i.dwSize = sizeof( INITCOMMONCONTROLSEX );
   i.dwICC  = ICC_LISTVIEW_CLASSES;

}

// ListView_SetSortHeader ( nHWndLV, nColumn [, nType
//  /*0==none, positive==UP arrow or negative==DOWN arrow*/] ) -> nType (previous setting)
HB_FUNC( LV_SETSORTHEADER )
{
   #ifndef _WIN64
      HWND hWndHD = ListView_GetHeader( ( HWND ) hb_parnl( 1 ) ) ;
   #else
      HWND hWndHD = ListView_GetHeader( ( HWND ) hb_parnll( 1 ) ) ;
   #endif
   INT    nItem  = hb_parni( 2 ) - 1;
   INT    nType;
   HDITEM hdItem;

   if( hb_parl( 4 ) )
   {
      hdItem.mask = HDI_FORMAT;

      SendMessage( hWndHD, HDM_GETITEM, nItem, ( LPARAM ) &hdItem );

      if( hdItem.fmt & HDF_SORTUP )
         hb_retni( 1 );
      else if( hdItem.fmt & HDF_SORTDOWN )
         hb_retni( -1 );
      else
         hb_retni( 0 );

      if( ( hb_pcount() > 2 ) && HB_ISNUM( 3 ) )
      {
         nType = hb_parni( 3 );

         if( nType == 0 )
            hdItem.fmt &= ~( HDF_SORTDOWN | HDF_SORTUP );
         else if( nType > 0 )
            hdItem.fmt = ( hdItem.fmt & ~HDF_SORTDOWN ) | HDF_SORTUP;
         else
            hdItem.fmt = ( hdItem.fmt & ~HDF_SORTUP ) | HDF_SORTDOWN;

         SendMessage( hWndHD, HDM_SETITEM, nItem, ( LPARAM ) &hdItem );
      }
   }
   else
   {
      hdItem.mask = HDI_BITMAP | HDI_FORMAT;

      SendMessage( hWndHD, HDM_GETITEM, nItem, ( LPARAM ) &hdItem );

      nType = hb_parni( 3 );

      if( nType == 0 )
      {
         hdItem.mask = HDI_FORMAT;
         hdItem.fmt &= ~( HDF_BITMAP | HDF_BITMAP_ON_RIGHT );
      }
      else
      {
         if( nType > 0 )
            hdItem.hbm = ( HBITMAP ) LoadImage( ( HINSTANCE ) NULL, TEXT( "GRID_ASC" ), IMAGE_BITMAP, 0, 0, LR_LOADTRANSPARENT | LR_DEFAULTCOLOR | LR_LOADMAP3DCOLORS );
         else
            hdItem.hbm = ( HBITMAP ) LoadImage( ( HINSTANCE ) NULL, TEXT( "GRID_DSC" ), IMAGE_BITMAP, 0, 0, LR_LOADTRANSPARENT | LR_DEFAULTCOLOR | LR_LOADMAP3DCOLORS );

         hdItem.fmt |= HDF_BITMAP;
         if( hdItem.fmt & HDF_RIGHT )
            hdItem.fmt &= ~HDF_BITMAP_ON_RIGHT;
         else
            hdItem.fmt |= HDF_BITMAP_ON_RIGHT;
      }

      SendMessage( hWndHD, HDM_SETITEM, nItem, ( LPARAM ) &hdItem );
   }
}

// LV_GETHEADER( hWnd )
HB_FUNC( LV_GETHEADER )
{
   #ifndef _WIN64
      HWND hGrid = ( HWND ) hb_parnl( 1 );
   #else
      HWND hGrid = ( HWND ) hb_parnll( 1 );
   #endif

   hb_retnll( ( LONG_PTR ) ListView_GetHeader( hGrid ) );
}

HB_FUNC( LV_GETHEADERLISTVIEWITEM )
{
   #ifndef _WIN64
      LPNMHEADER lpnmheader = ( LPNMHEADER ) hb_parnl( 1 );
   #else
      LPNMHEADER lpnmheader = ( LPNMHEADER ) hb_parnll( 1 );
   #endif

   hb_retnll( lpnmheader->iItem );
}

// LV_GETCOLUMNWIDTH(hWnd, nCol, nwide)          // nCol = Zero-based
HB_FUNC( LV_SETCOLUMNWIDTH )
{
   #ifndef _WIN64
      HWND hGrid = ( HWND ) hb_parnl( 1 );
   #else
      HWND hGrid = ( HWND ) hb_parnll( 1 );
   #endif
   ListView_SetColumnWidth ( hGrid, hb_parni(2) , hb_parni(3) ) ;
}

// LV_GETCOLUMNWIDTH(hWnd, nCol)                 // nCol = Zero-based
HB_FUNC( LV_GETCOLUMNWIDTH )
{
   #ifndef _WIN64
      HWND hGrid = ( HWND ) hb_parnl( 1 );
   #else
      HWND hGrid = ( HWND ) hb_parnll( 1 );
   #endif
   hb_retni ( ListView_GetColumnWidth ( hGrid, hb_parni(2) ) ) ;
}

// LV_SETCHECKSTATE (hWnd, nRow, lCheck)
HB_FUNC( LV_SETCHECKSTATE)
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   UINT nRow   = (UINT) hb_parnl (2);
   BOOL lCheck = (BOOL) hb_parl  (3);

   ListView_SetCheckState (hWnd, nRow-1, lCheck);
}

// LV_GETCHECKSTATE (hWnd, nRow)
HB_FUNC( LV_GETCHECKSTATE)
{
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   UINT nRow   = (UINT) hb_parnl (2);
   hb_retl ( ListView_GetCheckState(hWnd, nRow-1) );
}

// LV_GETGRIDDISPINFOINDEX(nPtrNMHDR)
HB_FUNC( LV_GETGRIDDISPINFOINDEX )
{
   #ifndef _WIN64
      LPARAM lParam = (LPARAM) hb_parnl (1);
   #else
      LPARAM lParam = (LPARAM) hb_parnll (1);
   #endif

   LV_DISPINFO * pDispInfo = ( LV_DISPINFO * ) lParam;
   int iItem = pDispInfo->item.iItem;
   int iSubItem = pDispInfo->item.iSubItem;

   hb_reta( 2 );
   hb_storvni( iItem    + 1, -1, 1 );
   hb_storvni( iSubItem + 1, -1, 2 );
}

// LV_SETGRIDQUERYDATA(nPtrNMHDR)
HB_FUNC( LV_SETGRIDQUERYDATA )
{
   #ifndef _WIN64
      LPARAM lParam = ( LPARAM ) hb_parnl( 1 );
   #else
      LPARAM lParam = ( LPARAM ) hb_parnll( 1 );
   #endif
   LV_DISPINFO * pDispInfo = ( LV_DISPINFO * ) lParam;

   // Copy the text to the LV_ITEM structure
   // Maximum number of characters is in pDispInfo->Item.cchTextMax
#ifdef UNICODE
   LPWSTR lpText = AnsiToWide( ( TCHAR * ) hb_parc( 2 ) );
   lstrcpyn( pDispInfo->item.pszText, ( TCHAR * ) lpText, pDispInfo->item.cchTextMax );
   hb_xfree( lpText );
#else
   lstrcpyn( pDispInfo->item.pszText, ( TCHAR * ) hb_parc( 2 ), pDispInfo->item.cchTextMax );
#endif
}

// LV_SETGRIDQUERYIMAGE(nPtrNMHDR)
HB_FUNC( LV_SETGRIDQUERYIMAGE )
{
   #ifndef _WIN64
      LPARAM lParam = ( LPARAM ) hb_parnl( 1 );
   #else
      LPARAM lParam = ( LPARAM ) hb_parnll( 1 );
   #endif
   LV_DISPINFO * pDispInfo = ( LV_DISPINFO * ) lParam;

   pDispInfo->item.iImage = hb_parni( 2 );
}


#pragma ENDDUMP

*
*
*

