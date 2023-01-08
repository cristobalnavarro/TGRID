#define CTRL_CLASS            "SysListView32"

#define NM_FIRST              0
#define NM_CLICK              (NM_FIRST-2)
#define NM_DBLCLK             (NM_FIRST-3)

#define WM_ERASEBKGND         20
#define WM_SETFONT            0x0030
#define WM_NOTIFY             0x004E
#define WM_DRAWITEM           0x002B
#define WM_MEASUREITEM        0x002C
#define WM_SYSCOMMAND         274   // 0x0112
#define WM_XBUTTONDOWN        0x020B
#define MK_XBUTTON1           0x0020
#define MK_XBUTTON2           0x0040

#define GWL_STYLE             -16

#define CLR_NONE              0xFFFFFFFF
#define CLR_DEFAULT           0xFF000000

#define COLOR_WINDOW          5
#define COLOR_WINDOWTEXT      8
#define COLOR_BTNFACE         15
#define COLOR_BTNSHADOW       16
#define COLOR_BTNHIGHLIGHT    20

#define SW_HIDE               0
#define SW_NORMAL             1
#define SW_SHOW               5

#define HDF_LEFT              0
#define HDF_OWNERDRAW         0x8000
#define HDF_BITMAP            0x2000
#define HDF_BITMAP_ON_RIGHT   0x1000
#define HDF_SORTDOWN          0x200
#define HDF_SORTUP            0x0400

#define ID_HEADER             1
#define ID_WIDTH              2
#define ID_ALIGN              3
#define ID_TYPE               4

#define LVCFMT_CENTER         0x02

#define LVM_FIRST             4096 // 0x1000
#define LVM_SETIMAGELIST      ( LVM_FIRST + 3 )
#define LVM_DELETEALLITEMS    ( LVM_FIRST + 9 )

#define LVN_FIRST             -100
#define LVN_ITEMCHANGED       ( LVN_FIRST - 1 )
#define LVN_COLUMNCLICK       ( LVN_FIRST - 8 )
#define LVN_GETDISPINFO       ( LVN_FIRST - 50)
#define LVN_KEYDOWN           ( LVN_FIRST - 55)

#define LVS_OWNERDATA         0x1000
#define LVS_OWNERDRAWFIXED    0x0400
#define LVS_AUTOARRANGE       0x0100
#define LVS_SHAREIMAGELISTS   0x040
#define LVS_SINGLESEL         0x04
#define LVS_SORTASCENDING     0x10
#define LVS_SORTDESCENDING    0x20
#define LVS_NOCOLUMNHEADER    0x4000
#define LVS_SHOWSELALWAYS     0x08

#define LVS_ICON              0
#define LVS_REPORT            0x01
#define LVS_SMALLICON         0x02
#define LVS_LIST              0x03

#define LVS_EX_DOUBLEBUFFER   0x010000
#define LVS_EX_FULLROWSELECT  0x20
#define LVS_EX_GRIDLINES      0x01
#define LVS_EX_CHECKBOXES     0x04

#define LV_VIEW_ICON          0
#define LV_VIEW_DETAILS       0x01
#define LV_VIEW_SMALLICON     0x02
#define LV_VIEW_LIST          0x03
#define LV_VIEW_MAX           0x04
#define LV_VIEW_TILE          0x04

#define LVSIL_NORMAL          0
#define LVSIL_SMALL           1
#define LVSIL_STATE           2

#define LVCFMT_LEFT           0
#define LVCFMT_RIGHT          0x01

#define LVCF_FMT              0x01
#define LVCF_IMAGE            0x10
#define LVCF_ORDER            0x20
#define LVCF_SUBITEM          0x08
#define LVCF_TEXT             0x04
#define LVCF_WIDTH            0x02

#define LVIS_FOCUSED          0x01
#define LVIS_SELECTED         0x02

#define LVNI_FOCUSED          0x01
#define LVNI_SELECTED         0x02

#define DWM_BB_ENABLE                  0x00000001
#define DWM_BB_BLURREGION              0x00000002
#define DWM_BB_TRANSITIONONMAXIMIZED   0x00000004

#define FO_MOVE                                    0x0001
#define FO_COPY                                    0x0002
#define FO_DELETE                                  0x0003
#define FO_RENAME                                  0x0004

#define FOF_MULTIDESTFILES                         0x0001
#define FOF_CONFIRMMOUSE                           0x0002
#define FOF_SILENT                                 0x0004
#define FOF_RENAMEONCOLLISION                      0x0008
#define FOF_NOCONFIRMATION                         0x0010
#define FOF_WANTMAPPINGHANDLE                      0x0020
#define FOF_ALLOWUNDO                              0x0040
#define FOF_FILESONLY                              0x0080
#define FOF_SIMPLEPROGRESS                         0x0100
#define FOF_NOCONFIRMMKDIR                         0x0200
#define FOF_NOERRORUI                              0x0400
#define FOF_NOCOPYSECURITYATTRIBS                  0x0800
#define FOF_NORECURSION                            0x1000
#define FOF_NO_CONNECTED_ELEMENTS                  0x2000
#define FOF_WANTNUKEWARNING                        0x4000
#define FOF_NORECURSEREPARSE                       0x8000

// Header Notifications
#define HDN_FIRST               -300 //(0U-300U)       // header
#define HDN_ITEMCHANGING       (HDN_FIRST-0)
#define HDN_ITEMCHANGED        (HDN_FIRST-1)
#define HDN_ITEMCLICK          (HDN_FIRST-2)
#define HDN_ITEMDBLCLICK       (HDN_FIRST-3)
#define HDN_DIVIDERDBLCLICK    (HDN_FIRST-5)
#define HDN_BEGINTRACK         (HDN_FIRST-6)
#define HDN_ENDTRACK           (HDN_FIRST-7)
#define HDN_TRACK              (HDN_FIRST-8)
