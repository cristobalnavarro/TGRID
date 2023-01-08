#define DLL_CDECL                   0x08
#define DLL_STDCALL                 0x20
#define DLL_SYSTEM                  0x04
#if defined( __PLATFORM__WINDOWS )
#define DLL_OSAPI                   DLL_STDCALL
#elif defined( __PLATFORM__OS2 )
#define DLL_OSAPI                   DLL_SYSTEM
#else
#define DLL_OSAPI                   DLL_CDECL
#endif

#define nUseButton            12

//  #define CSIDL_COMMON_DESKTOPDIRECTORY   0x0019

#define EM_SETSEL             0x00B1

#define FILE_ATTRIBUTE_READONLY         0x00000001
#define FILE_ATTRIBUTE_HIDDEN           0x00000002
#define FILE_ATTRIBUTE_SYSTEM           0x00000004
#define FILE_ATTRIBUTE_DIRECTORY        0x00000010
#define FILE_ATTRIBUTE_ARCHIVE          0x00000020
#define FILE_ATTRIBUTE_DEVICE           0x00000040
#define FILE_ATTRIBUTE_NORMAL           0x00000080

//  #define SW_HIDE               0
//  #define SW_NORMAL             1
//  #define SW_SHOW               5

#define HWND_TOP              0
#define HWND_BOTTOM           1
#define HWND_TOPMOST          -1
#define HWND_NOTOPMOST        -2

#define MB_TOPMOST            0x00040000

#define SWP_NOSIZE            0x0001
#define SWP_NOMOVE            0x0002

#define SRCPAINT              15597702   // 0xEE0086
#define SRCAND                8913094

#define LWA_COLORKEY          1
#define GWL_EXSTYLE           -20
#define WS_EX_LAYERED         524288

#define MK_SHIFT              0x0004
#define MK_CONTROL            0x0008
#define MK_MBUTTON            0x0010

#define DRIVE_UNKNOWN         0
#define DRIVE_NO_ROOT_DIR     1
#define DRIVE_REMOVABLE       2
#define DRIVE_FIXED           3
#define DRIVE_REMOTE          4
#define DRIVE_CDROM           5
#define DRIVE_RAMDISK         6

#define SIZE_INIT             NIL
#define SIZE_RESTORED         0
#define SIZE_MINIMIZED        1
#define SIZE_MAXIMIZED        2

#define RESOURCETYPE_ANY      0
#define RESOURCETYPE_DISK     1
#define RESOURCETYPE_PRINT    2


#DEFINE LANG_LOCALE          1
#DEFINE LANG_LANGCODE        2
#DEFINE LANG_LCIDSTRING      3
#DEFINE LANG_LCIDDECIMAL     4
#DEFINE LANG_LCIDHEX         5
#DEFINE LANG_CODEPAGE        6
#DEFINE LANG_LANGWIN         7

#DEFINE X_COUNTRY            1
#DEFINE X_NUM1               2
#DEFINE X_CDP1               3
#DEFINE X_ISO1               4
#DEFINE X_ISO2               5
#DEFINE X_CODEPAGE           6


