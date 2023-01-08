*+--------------------------------------------------------------------
*+
*+ Source Module => c:\fwh\0\LISTVIEW\CODEPAGE.PRG
*+
*+    Copyright(C) 1983-2022 by Auge & Ohr
*+
*+    Functions: Procedure ChangeCodePage()
*+               Static Procedure DoSetNewCP()
*+               Static Function CompareKeyboard()
*+               Static Function Get_cdpSelect()
*+               Static Function Get_LCID()
*+
*+       Tables: USE (cPath+cFile) VIA (cVia) ALIAS (cAlias) EXCLUSIVE CODEPAGE TRIM(cCodepage)
*+
*+    Reformatted by Click! 2.05.40 on Jan-7-2023 at  1:29 am
*+
*+--------------------------------------------------------------------

#include "FIVEWIN.CH"
#include "common.CH"

#include "DUALGRID.CH"
#include "TGRID.CH"

MEMVAR BFcolor, BGcolor

*+--------------------------------------------------------------------
*+
*+    Procedure ChangeCodePage()
*+
*+    Called from ( dualgrid.prg )   1 - static procedure doshowdbf()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE ChangeCodePage( cPath, cFile, cAlias, nIcoLarge, nIcoSmall )

LOCAL oWnd
LOCAL ii, iMax
LOCAL oGrid, aItem
LOCAL aCDP     := Get_cdpSelect()
LOCAL nCountry := HB_bitAND( GETKEYBOARDLAYOUT(), 0xFFFF )
LOCAL aLCID    := CompareKeyboard( nCountry )
LOCAL nStart   := 0
LOCAL cDrive   := SPACE( 80 )
LOCAL bAction  := { | x | nil }
LOCAL cMsg     := ""
LOCAL aHeader  := {}

   DEFAULT nIcoLarge := 256                                           // 32
   DEFAULT nIcoSmall := 32                                            // 16

   nStart := ASCAN( aCDP, { | e | TRIM( e[ LANG_CODEPAGE ] ) = TRIM( aLCID[ LANG_LANGWIN ] ) } )
   IF EMPTY( nStart )
      nStart := 1
   ENDIF

   DEFINE WINDOW oWnd FROM 0, 0 TO 1024, 470 PIXEL TITLE "Codepage" ICON "A1MAIN" COLOR BFcolor, BGcolor NOMINIMIZE NOMAXIMIZE

      oGrid := TGrid() :New( 0, 0,, bAction, oWnd, ;
                       BFcolor, BGcolor, .T., .F., ;
                       470, 1024, cMsg, nIcoLarge, nIcoSmall )

      AADD( aHeader, { "Country", 250, LVCFMT_LEFT, "C" } )
      AADD( aHeader, { "Codepage", 200, LVCFMT_LEFT, "C" } )

      oGrid:aHeader := aHeader
      oGrid:aSource := aCDP

      oGrid:CreateHeaderColumn()

      iMax := LEN( aCDP )
      FOR ii := 1 TO iMax
         aItem := { aCDP[ ii ] [ 1 ], aCDP[ ii ] [ 6 ] }
         LV_ADDITEM( oGrid:hLv, aItem )
      NEXT

      oGrid:Setfocus()
      IF !EMPTY( nStart )
         LV_SETITEMSELECT( oGrid:hLv, nStart )
      ENDIF

      oGrid:bClick := { | nItem | DoSetNewCP( cPath, cFile, aCDP[ nItem ] [ 6 ], cAlias ), oWnd:End() }

      oWnd:oClient := oGrid
      oWnd:bKeyDown := { | nKey, nFlag | IF( nKey = VK_ESCAPE, oWnd:End(), nil ) }
      oWnd:bResized := { | nType, nWidth, nHeight | oWnd:SetSize( 470, 1024 ) }

#IFDEF __HMG__
   END WINDOW
#ENDIF

   ACTIVATE WINDOW oWnd ON INIT MakeTop( oWnd, oGrid ) CENTER

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoSetNewCP()
*+
*+    Called from ( codepage.prg )   1 - procedure changecodepage()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoSetNewCP( cPath, cFile, cCodepage, cAlias )

LOCAL cVia := "DBFCDX"

   CLOSE
   USE (cPath+cFile) VIA (cVia) ALIAS (cAlias) EXCLUSIVE CODEPAGE TRIM(cCodepage)

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function CompareKeyboard()
*+
*+    Called from ( codepage.prg )   1 - procedure changecodepage()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION CompareKeyboard( nKey )

LOCAL aLCID := Get_LCID()
LOCAL nPosi := ASCAN( aLCID, { | e | VAL( LTRIM( e[ LANG_LCIDDECIMAL ] ) ) = nKey } )
LOCAL cLCID := {}

   IF nPosi > 0
      cLCID := aLCID[ nPosi ]
   ELSE
      msgInfo( "not found Keyboard Code " + VAR2CHAR( nKey ) )
   ENDIF

RETURN cLCID

*+--------------------------------------------------------------------
*+
*+    Static Function Get_cdpSelect()
*+
*+    Called from ( codepage.prg )   1 - procedure changecodepage()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION Get_cdpSelect()

LOCAL aCDP := {}

   AADD( aCDP, { "Bulgarian            ", "866         ", "BG866 ", "cp866     ", "866         ", "BG866 " } )                              //
   AADD( aCDP, { "Bulgarian            ", "ISO-8859-5  ", "BGISO ", "iso8859-5 ", "ISO-8859-5  ", "BGISO " } )                              //
   AADD( aCDP, { "Bulgarian            ", "MIK         ", "BGMIK ", "bg-mik    ", "MIK         ", "BGMIK " } )                              //
   AADD( aCDP, { "Bulgarian            ", "Windows-1251", "BGWIN ", "cp1251    ", "Windows-1251", "BGWIN " } )                              //
   AADD( aCDP, { "Croatian             ", "437         ", "HR437 ", "          ", "437         ", "HR437 " } )                              // no
   AADD( aCDP, { "Croatian             ", "852         ", "HR852 ", "          ", "852         ", "HR852 " } )                              //
   AADD( aCDP, { "Croatian             ", "Windows-1250", "HR1250", "          ", "Windows-1250", "HRWIN " } )                              //
   AADD( aCDP, { "Czech                ", "852         ", "CS852 ", "cp852     ", "852         ", "CS852 " } )                              //
   AADD( aCDP, { "Czech                ", "ISO-8859-2  ", "CSISO ", "iso8859-2 ", "ISO-8859-2  ", "CSISO " } )                              //
   AADD( aCDP, { "Czech                ", "KAM         ", "CSKAM ", "kamenicky ", "KAM         ", "CSKAM " } )                              // no
   AADD( aCDP, { "Czech                ", "Windoes-1250", "CSWIN ", "cp1250    ", "Windoes-1250", "CSWIN " } )                              //
   AADD( aCDP, { "English              ", "437         ", "EN    ", "          ", "437         ", "EN    " } )                              //
   AADD( aCDP, { "French               ", "850         ", "FR    ", "          ", "850         ", "FR850 " } )                              //
   AADD( aCDP, { "German OEM           ", "850         ", "DE    ", "          ", "850         ", "DE850 " } )                              //
   AADD( aCDP, { "German ANSI          ", "ISO-8859-1  ", "DEWIN ", "cp1252    ", "ISO-8859-1  ", "DEWIN " } )                              //
   AADD( aCDP, { "Greek                ", "737         ", "EL    ", "cp737     ", "737         ", "EL737 " } )                              //
   AADD( aCDP, { "Greek                ", "Windows-1253", "ELWIN ", "cp1253    ", "Windows-1253", "ELWIN " } )                              //
   AADD( aCDP, { "Hungarian (ntxhu852) ", "852         ", "HU852 ", "          ", "852         ", "HU852C" } )                              //
   AADD( aCDP, { "Hungarian (sixhu852) ", "852         ", "HU852S", "          ", "852         ", "HU852 " } )                              //
   AADD( aCDP, { "Hungarian (ntxhu852) ", "ISO-8859-2  ", "HUISO ", "          ", "CWI-2       ", "HUCWI " } )                              // ?
   AADD( aCDP, { "Hungarian (sixhu852) ", "ISO-8859-2  ", "HUISOS", "          ", "ISO-8859-2  ", "HUISO " } )                              //
   AADD( aCDP, { "Hungarian (ntxhu852) ", "Windows-1250", "HUWIN ", "          ", "Windows-1250", "HUWIN " } )                              //
   AADD( aCDP, { "Hungarian (sixhu852) ", "Windows-1250", "HUWINS", "          ", "            ", "HUWINS" } )                              // ?
   AADD( aCDP, { "Italian              ", "437         ", "IT437 ", "          ", "437         ", "IT437 " } )                              //
   AADD( aCDP, { "Italian              ", "850         ", "IT850 ", "          ", "850         ", "IT850 " } )                              //
   AADD( aCDP, { "Italian              ", "ISO-8859-1b ", "ITISB ", "iso8859-1b", "ISO-8859-1b ", "ITISB " } )                              //
   AADD( aCDP, { "Italian              ", "ISO-8859-1  ", "ITISO ", "          ", "ISO-8859-1  ", "ITISO " } )                              //
   AADD( aCDP, { "Lithuanian           ", "Windows-1257", "LT    ", "cp1257    ", "Windows-1257", "LTWIN " } )                              //
   AADD( aCDP, { "Polish               ", "852         ", "PL852 ", "          ", "852         ", "PL852 " } )                              //
   AADD( aCDP, { "Polish               ", "ISO-8859-2  ", "PLISO ", "          ", "ISO-8859-2  ", "PLISO " } )                              //
   AADD( aCDP, { "Polish               ", "Mazowia     ", "PLMAZ ", "mazovia   ", "Mazowia     ", "PLMAZ " } )                              //
   AADD( aCDP, { "Polish               ", "Windows-1250", "PLWIN ", "          ", "Windows-1250", "PLWIN " } )                              //
   AADD( aCDP, { "Portuguese           ", "850         ", "PT850 ", "          ", "850         ", "PT850 " } )                              //
   AADD( aCDP, { "Portuguese           ", "ISO-8859-1  ", "PTISO ", "          ", "ISO-8859-1  ", "PTISO " } )                              //
   AADD( aCDP, { "Russian              ", "866         ", "RU866 ", "          ", "866         ", "RU866 " } )                              //
   AADD( aCDP, { "Russian              ", "KOI-8       ", "RUKOI8", "koi-8     ", "KOI-8       ", "RUKOI8" } )                              //
   AADD( aCDP, { "Russian              ", "Windows-1251", "RU1251", "          ", "Windows-1251", "RU1251" } )                              //
   AADD( aCDP, { "Serbian              ", "Windows-1251", "SRWIN ", "          ", "Windows-1251", "SRWIN " } )                              //
   AADD( aCDP, { "Slovak               ", "852         ", "SK852 ", "          ", "852         ", "SK852 " } )                              //
   AADD( aCDP, { "Slovak               ", "ISO-8859-2  ", "SKISO ", "          ", "ISO-8859-2  ", "SKISO " } )                              //
   AADD( aCDP, { "Slovak               ", "Kamenicky   ", "SKKAM ", "          ", "Kamenicky   ", "SKKAM " } )                              // no
   AADD( aCDP, { "Slovak               ", "Windows-1250", "SKWIN ", "          ", "Windows-1250", "SKWIN " } )                              //
   AADD( aCDP, { "Slovenian            ", "437         ", "SL437 ", "          ", "437         ", "SL437 " } )                              // no
   AADD( aCDP, { "Slovenian            ", "852         ", "SL852 ", "          ", "852         ", "SL852 " } )                              //
   AADD( aCDP, { "Slovenian            ", "ISO-8859-2  ", "SLISO ", "          ", "ISO-8859-2  ", "SLISO " } )                              //
   AADD( aCDP, { "Slovenian            ", "Windows-1250", "SLWIN ", "          ", "Windows-1250", "SLWIN " } )                              //
   AADD( aCDP, { "Spanish              ", "850         ", "ES    ", "          ", "850         ", "ES850 " } )                              //
   AADD( aCDP, { "Spanish              ", "ISO-8859-1  ", "ESWIN ", "          ", "ISO-8859-1  ", "ESWIN " } )                              //
   AADD( aCDP, { "Spanish Modern       ", "ISO-8859-1  ", "ESMWIN", "          ", "ISO-8859-1  ", "ESMWIN" } )                              //
   AADD( aCDP, { "Swedish              ", "850         ", "SV850 ", "          ", "850         ", "SV850 " } )                              //
   AADD( aCDP, { "Swedish (Clipper)    ", "437         ", "SVCLIP", "          ", "437         ", "SV437C" } )                              //
   AADD( aCDP, { "Swedish              ", "ISO-8859-1  ", "SVWIN ", "          ", "ISO-8859-1  ", "SVWIN " } )                              //
   AADD( aCDP, { "Turkish              ", "857         ", "TR857 ", "cp857     ", "857         ", "TR857 " } )                              //
   AADD( aCDP, { "Turkish              ", "Windows-1254", "TRWIN ", "cp1254    ", "Windows-1254", "TRWIN " } )                              //
   AADD( aCDP, { "Ukrainian            ", "866         ", "UA866 ", "          ", "866         ", "UA866 " } )                              //
   AADD( aCDP, { "Ukrainian            ", "KOI-8U      ", "UAKOI8", "koi-8u    ", "KOI-8U      ", "UAKOI8" } )                              //
   AADD( aCDP, { "Ukrainian            ", "Windows-1251", "UA1251", "          ", "Windows-1251", "UA1251" } )                              //
   AADD( aCDP, { "UTF-8                ", "UTF8        ", "UTF8  ", "          ", "            ", "UTF8  " } )                              //
   AADD( aCDP, { "UTF-8 BOM            ", "UTF8EX      ", "UTF8EX", "          ", "            ", "UTF8EX" } )                              //

   // not exact identify

   AADD( aCDP, { "Czech                ", "CS852C      ", "      ", "          ", "            ", "CS852C" } )
   AADD( aCDP, { "Czech                ", "CSKAMC      ", "      ", "          ", "            ", "CSKAMC" } )
   AADD( aCDP, { "German               ", "DE850M      ", "      ", "          ", "            ", "DE850M" } )
   AADD( aCDP, { "German               ", "DEISO       ", "      ", "          ", "            ", "DEISO " } )
   AADD( aCDP, { "Danmark              ", "DK865       ", "      ", "          ", "            ", "DK865 " } )
   AADD( aCDP, { "Greek                ", "EL437       ", "      ", "          ", "            ", "EL437 " } )
   AADD( aCDP, { "Greek                ", "ELISO       ", "      ", "          ", "            ", "ELISO " } )
   AADD( aCDP, { "Spanish              ", "ES850C      ", "      ", "          ", "            ", "ES850C" } )
   AADD( aCDP, { "Spanish              ", "ES850M      ", "      ", "          ", "            ", "ES850M" } )
   AADD( aCDP, { "Spanish              ", "ESISO       ", "      ", "          ", "            ", "ESISO " } )
   AADD( aCDP, { "Finnland             ", "FI850       ", "      ", "          ", "            ", "FI850 " } )
   AADD( aCDP, { "French               ", "FR850C      ", "      ", "          ", "            ", "FR850C" } )
   AADD( aCDP, { "French               ", "FR850M      ", "      ", "          ", "            ", "FR850M" } )
   AADD( aCDP, { "French               ", "FRISO       ", "      ", "          ", "            ", "FRISO " } )
   AADD( aCDP, { "French               ", "FRWIN       ", "      ", "          ", "            ", "FRWIN " } )
   AADD( aCDP, { "Hebrew               ", "HE862       ", "      ", "          ", "            ", "HE862 " } )
   AADD( aCDP, { "Hebrew               ", "HEWIN       ", "      ", "          ", "            ", "HEWIN " } )
   AADD( aCDP, { "Croatian             ", "HRISO       ", "      ", "          ", "            ", "HRISO " } )
   AADD( aCDP, { "Icelandic            ", "IS850       ", "      ", "          ", "            ", "IS850 " } )
   AADD( aCDP, { "Icelandic            ", "IS861       ", "      ", "          ", "            ", "IS861 " } )
   AADD( aCDP, { "Italian              ", "IT850M      ", "      ", "          ", "            ", "IT850M" } )
   AADD( aCDP, { "Italian              ", "ITWIN       ", "      ", "          ", "            ", "ITWIN " } )
   AADD( aCDP, { "Lithuanian           ", "LT775       ", "      ", "          ", "            ", "LT775 " } )
   AADD( aCDP, { "Nederland            ", "NL850       ", "      ", "          ", "            ", "NL850 " } )
   AADD( aCDP, { "Nederland            ", "NL850M      ", "      ", "          ", "            ", "NL850M" } )
   AADD( aCDP, { "Norway               ", "NO865       ", "      ", "          ", "            ", "NO865 " } )
   AADD( aCDP, { "Portuguese           ", "PT860       ", "      ", "          ", "            ", "PT860 " } )
   AADD( aCDP, { "Romanian             ", "RO852       ", "      ", "          ", "            ", "RO852 " } )
   AADD( aCDP, { "Romanian             ", "ROISO       ", "      ", "          ", "            ", "ROISO " } )
   AADD( aCDP, { "Romanian             ", "ROWIN       ", "      ", "          ", "            ", "ROWIN " } )
   AADD( aCDP, { "Russian              ", "RUISO       ", "      ", "          ", "            ", "RUISO " } )
   AADD( aCDP, { "Slovak               ", "SK852C      ", "      ", "          ", "            ", "SK852C" } )
   AADD( aCDP, { "Slovak               ", "SKKAMC      ", "      ", "          ", "            ", "SKKAMC" } )
   AADD( aCDP, { "Slovenian            ", "SL646       ", "      ", "          ", "            ", "SL646 " } )
   AADD( aCDP, { "Serbian              ", "SR646       ", "      ", "          ", "            ", "SR646 " } )
   AADD( aCDP, { "Serbian              ", "SR646C      ", "      ", "          ", "            ", "SR646C" } )
   AADD( aCDP, { "Swedish              ", "SV850M      ", "      ", "          ", "            ", "SV850M" } )
   AADD( aCDP, { "Turkish              ", "TRISO       ", "      ", "          ", "            ", "TRISO " } )
   AADD( aCDP, { "Ukrainian            ", "UA1125      ", "      ", "          ", "            ", "UA1125" } )
   AADD( aCDP, { "UTF16LE              ", "UTF16LE     ", "      ", "          ", "            ", "UTF16LE" } )

RETURN ASORT( aCDP,,, { | aX, aY | aX[ 1 ] + aX[ 2 ] < aY[ 1 ] + aY[ 2 ] } )

*+--------------------------------------------------------------------
*+
*+    Static Function Get_LCID()
*+
*+    Called from ( codepage.prg )   1 - static function comparekeyboard()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION Get_LCID()

LOCAL aLCID := {}
   //            Locale               Language code  LCID string  LCID decimal  LCID hex  Codepage
   AADD( aLCID, { "Afrikaans                    ", "af", "af    ", " 1078", " 436", "1252", "" } )
   AADD( aLCID, { "Albanian                     ", "sq", "sq    ", " 1052", " 41C", "1250", "" } )
   AADD( aLCID, { "Amharic                      ", "am", "am    ", " 1118", " 45E", "    ", "" } )
   AADD( aLCID, { "Arabic - Algeria             ", "ar", "ar-dz ", " 5121", "1401", "1256", "" } )
   AADD( aLCID, { "Arabic - Bahrain             ", "ar", "ar-bh ", "15361", "3C01", "1256", "" } )
   AADD( aLCID, { "Arabic - Egypt               ", "ar", "ar-eg ", " 3073", " C01", "1256", "" } )
   AADD( aLCID, { "Arabic - Iraq                ", "ar", "ar-iq ", " 2049", " 801", "1256", "" } )
   AADD( aLCID, { "Arabic - Jordan              ", "ar", "ar-jo ", "11265", "2C01", "1256", "" } )
   AADD( aLCID, { "Arabic - Kuwait              ", "ar", "ar-kw ", "13313", "3401", "1256", "" } )
   AADD( aLCID, { "Arabic - Lebanon             ", "ar", "ar-lb ", "12289", "3001", "1256", "" } )
   AADD( aLCID, { "Arabic - Libya               ", "ar", "ar-ly ", " 4097", "1001", "1256", "" } )
   AADD( aLCID, { "Arabic - Morocco             ", "ar", "ar-ma ", " 6145", "1801", "1256", "" } )
   AADD( aLCID, { "Arabic - Oman                ", "ar", "ar-om ", " 8193", "2001", "1256", "" } )
   AADD( aLCID, { "Arabic - Qatar               ", "ar", "ar-qa ", "16385", "4001", "1256", "" } )
   AADD( aLCID, { "Arabic - Saudi Arabia        ", "ar", "ar-sa ", " 1025", " 401", "1256", "" } )
   AADD( aLCID, { "Arabic - Syria               ", "ar", "ar-sy ", "10241", "2801", "1256", "" } )
   AADD( aLCID, { "Arabic - Tunisia             ", "ar", "ar-tn ", " 7169", "1C01", "1256", "" } )
   AADD( aLCID, { "Arabic - United Arab Emirates", "ar", "ar-ae ", "14337", "3801", "1256", "" } )
   AADD( aLCID, { "Arabic - Yemen               ", "ar", "ar-ye ", " 9217", "2401", "1256", "" } )
   AADD( aLCID, { "Armenian                     ", "hy", "hy    ", " 1067", " 42B", "    ", "" } )
   AADD( aLCID, { "Assamese                     ", "as", "as    ", " 1101", " 44D", "    ", "" } )
   AADD( aLCID, { "Azeri - Cyrillic             ", "az", "az-az ", " 2092", " 82C", "1251", "" } )
   AADD( aLCID, { "Azeri - Latin                ", "az", "az-az ", " 1068", " 42C", "1254", "" } )
   AADD( aLCID, { "Basque                       ", "eu", "eu    ", " 1069", " 42D", "1252", "" } )
   AADD( aLCID, { "Belarusian                   ", "be", "be    ", " 1059", " 423", "1251", "" } )
   AADD( aLCID, { "Bengali - Bangladesh         ", "bn", "bn    ", " 2117", " 845", "    ", "" } )
   AADD( aLCID, { "Bengali - India              ", "bn", "bn    ", " 1093", " 445", "    ", "" } )
   AADD( aLCID, { "Bosnian                      ", "bs", "bs    ", " 5146", "141A", "    ", "" } )
   AADD( aLCID, { "Bulgarian                    ", "bg", "bg    ", " 1026", " 402", "1251", "BGWIN" } )
   AADD( aLCID, { "Burmese                      ", "my", "my    ", " 1109", " 455", "    ", "" } )
   AADD( aLCID, { "Catalan                      ", "ca", "ca    ", " 1027", " 403", "1252", "" } )
   AADD( aLCID, { "Chinese - China              ", "zh", "zh-cn ", " 2052", " 804", "    ", "" } )
   AADD( aLCID, { "Chinese - Hong Kong SAR      ", "zh", "zh-hk ", " 3076", " C04", "    ", "" } )
   AADD( aLCID, { "Chinese - Macau SAR          ", "zh", "zh-mo ", " 5124", "1404", "    ", "" } )
   AADD( aLCID, { "Chinese - Singapore          ", "zh", "zh-sg ", " 4100", "1004", "    ", "" } )
   AADD( aLCID, { "Chinese - Taiwan             ", "zh", "zh-tw ", " 1028", " 404", "    ", "" } )
   AADD( aLCID, { "Croatian                     ", "hr", "hr    ", " 1050", " 41A", "1250", "HRWIN" } )
   AADD( aLCID, { "Czech                        ", "cs", "cs    ", " 1029", " 405", "1250", "CSWIN" } )
   AADD( aLCID, { "Danish                       ", "da", "da    ", " 1030", " 406", "1252", "" } )
   AADD( aLCID, { "Dutch - Belgium              ", "nl", "nl-be ", " 2067", " 813", "1252", "" } )
   AADD( aLCID, { "Dutch - Netherlands          ", "nl", "nl-nl ", " 1043", " 413", "1252", "" } )
   AADD( aLCID, { "Edo                          ", "  ", "      ", " 1126", " 466", "    ", "" } )
   AADD( aLCID, { "English - Australia          ", "en", "en-au ", " 3081", " C09", "1252", "EN" } )
   AADD( aLCID, { "English - Belize             ", "en", "en-bz ", "10249", "2809", "1252", "EN" } )
   AADD( aLCID, { "English - Canada             ", "en", "en-ca ", " 4105", "1009", "1252", "EN" } )
   AADD( aLCID, { "English - Caribbean          ", "en", "en-cb ", " 9225", "2409", "1252", "EN" } )
   AADD( aLCID, { "English - Great Britain      ", "en", "en-gb ", " 2057", " 809", "1252", "EN" } )
   AADD( aLCID, { "English - India              ", "en", "en-in ", "16393", "4009", "    ", "" } )
   AADD( aLCID, { "English - Ireland            ", "en", "en-ie ", " 6153", "1809", "1252", "EN" } )
   AADD( aLCID, { "English - Jamaica            ", "en", "en-jm ", " 8201", "2009", "1252", "EN" } )
   AADD( aLCID, { "English - New Zealand        ", "en", "en-nz ", " 5129", "1409", "1252", "EN" } )
   AADD( aLCID, { "English - Philippines        ", "en", "en-ph ", "13321", "3409", "1252", "EN" } )
   AADD( aLCID, { "English - Southern Africa    ", "en", "en-za ", " 7177", "1C09", "1252", "EN" } )
   AADD( aLCID, { "English - Trinidad           ", "en", "en-tt ", "11273", "2C09", "1252", "EN" } )
   AADD( aLCID, { "English - United States      ", "en", "en-us ", " 1033", " 409", "1252", "EN" } )
   AADD( aLCID, { "English - Zimbabwe           ", "en", "      ", "12297", "3009", "1252", "EN" } )
   AADD( aLCID, { "Estonian                     ", "et", "et    ", " 1061", " 425", "1257", "" } )
   AADD( aLCID, { "FYRO Macedonia               ", "mk", "mk    ", " 1071", " 42F", "1251", "" } )
   AADD( aLCID, { "Faroese                      ", "fo", "fo    ", " 1080", " 438", "1252", "" } )
   AADD( aLCID, { "Farsi - Persian              ", "fa", "fa    ", " 1065", " 429", "1256", "" } )
   AADD( aLCID, { "Filipino                     ", "  ", "      ", " 1124", " 464", "    ", "" } )
   AADD( aLCID, { "Finnish                      ", "fi", "fi    ", " 1035", " 40B", "1252", "" } )
   AADD( aLCID, { "French - Belgium             ", "fr", "fr-be ", " 2060", " 80C", "1252", "FRWIN" } )
   AADD( aLCID, { "French - Cameroon            ", "fr", "      ", "11276", "2C0C", "    ", "" } )
   AADD( aLCID, { "French - Canada              ", "fr", "fr-ca ", " 3084", " C0C", "1252", "FRWIN" } )
   AADD( aLCID, { "French - Congo               ", "fr", "      ", " 9228", "240C", "    ", "" } )
   AADD( aLCID, { "French - Cote d'Ivoire       ", "fr", "      ", "12300", "300C", "    ", "" } )
   AADD( aLCID, { "French - France              ", "fr", "fr-fr ", " 1036", " 40C", "1252", "FRWIN" } )
   AADD( aLCID, { "French - Luxembourg          ", "fr", "fr-lu ", " 5132", "140C", "1252", "FRWIN" } )
   AADD( aLCID, { "French - Mali                ", "fr", "      ", "13324", "340C", "    ", "" } )
   AADD( aLCID, { "French - Monaco              ", "fr", "      ", " 6156", "180C", "1252", "FRWIN" } )
   AADD( aLCID, { "French - Morocco             ", "fr", "      ", "14348", "380C", "    ", "" } )
   AADD( aLCID, { "French - Senegal             ", "fr", "      ", "10252", "280C", "    ", "" } )
   AADD( aLCID, { "French - Switzerland         ", "fr", "fr-ch ", " 4108", "100C", "1252", "FRWIN" } )
   AADD( aLCID, { "French - West Indies         ", "fr", "      ", " 7180", "1C0C", "    ", "" } )
   AADD( aLCID, { "Frisian - Netherlands        ", "  ", "      ", " 1122", " 462", "    ", "" } )
   AADD( aLCID, { "Gaelic - Ireland             ", "gd", "gd-ie ", " 2108", " 83C", "    ", "" } )
   AADD( aLCID, { "Gaelic - Scotland            ", "gd", "gd    ", " 1084", " 43C", "    ", "" } )
   AADD( aLCID, { "Galician                     ", "gl", "      ", " 1110", " 456", "1252", "" } )
   AADD( aLCID, { "Georgian                     ", "ka", "      ", " 1079", " 437", "    ", "" } )
   AADD( aLCID, { "German - Austria             ", "de", "de-at ", " 3079", " C07", "1252", "DEWIN" } )
   AADD( aLCID, { "German - Germany             ", "de", "de-de ", " 1031", " 407", "1252", "DEWIN" } )
   AADD( aLCID, { "German - Liechtenstein       ", "de", "de-li ", " 5127", "1407", "1252", "DEWIN" } )
   AADD( aLCID, { "German - Luxembourg          ", "de", "de-lu ", " 4103", "1007", "1252", "DEWIN" } )
   AADD( aLCID, { "German - Switzerland         ", "de", "de-ch ", " 2055", " 807", "1252", "DEWIN" } )
   AADD( aLCID, { "Greek                        ", "el", "el    ", " 1032", " 408", "1253", "ELWIN" } )
   AADD( aLCID, { "Guarani - Paraguay           ", "gn", "gn    ", " 1140", " 474", "    ", "" } )
   AADD( aLCID, { "Gujarati                     ", "gu", "gu    ", " 1095", " 447", "    ", "" } )
   AADD( aLCID, { "HID (Human Interface Device) ", "  ", "      ", " 1279", " 4FF", "    ", "" } )
   AADD( aLCID, { "Hebrew                       ", "he", "he    ", " 1037", " 40D", "1255", "HEWIN" } )
   AADD( aLCID, { "Hindi                        ", "hi", "hi    ", " 1081", " 439", "    ", "" } )
   AADD( aLCID, { "Hungarian                    ", "hu", "hu    ", " 1038", " 40E", "1250", "HUWIN" } )
   AADD( aLCID, { "Icelandic                    ", "is", "is    ", " 1039", " 40F", "1252", "IS85 " } )
   AADD( aLCID, { "Igbo - Nigeria               ", "  ", "      ", " 1136", " 470", "    ", "" } )
   AADD( aLCID, { "Indonesian                   ", "id", "id    ", " 1057", " 421", "1252", "" } )
   AADD( aLCID, { "Italian - Italy              ", "it", "it-it ", " 1040", " 410", "1252", "ITWIN" } )
   AADD( aLCID, { "Italian - Switzerland        ", "it", "it-ch ", " 2064", " 810", "1252", "ITWIN" } )
   AADD( aLCID, { "Japanese                     ", "ja", "ja    ", " 1041", " 411", "    ", "" } )
   AADD( aLCID, { "Kannada                      ", "kn", "kn    ", " 1099", " 44B", "    ", "" } )
   AADD( aLCID, { "Kashmiri                     ", "ks", "ks    ", " 1120", " 460", "    ", "" } )
   AADD( aLCID, { "Kazakh                       ", "kk", "kk    ", " 1087", " 43F", "1251", "" } )
   AADD( aLCID, { "Khmer                        ", "km", "km    ", " 1107", " 453", "    ", "" } )
   AADD( aLCID, { "Konkani                      ", "  ", "      ", " 1111", " 457", "    ", "" } )
   AADD( aLCID, { "Korean                       ", "ko", "ko    ", " 1042", " 412", "    ", "" } )
   AADD( aLCID, { "Kyrgyz - Cyrillic            ", "  ", "      ", " 1088", " 440", "1251", "" } )
   AADD( aLCID, { "Lao                          ", "lo", "lo    ", " 1108", " 454", "    ", "" } )
   AADD( aLCID, { "Latin                        ", "la", "la    ", " 1142", " 476", "    ", "" } )
   AADD( aLCID, { "Latvian                      ", "lv", "lv    ", " 1062", " 426", "1257", "" } )
   AADD( aLCID, { "Lithuanian                   ", "lt", "lt    ", " 1063", " 427", "1257", "LTWIN" } )
   AADD( aLCID, { "Malay - Brunei               ", "ms", "ms-bn ", " 2110", " 83E", "1252", "" } )
   AADD( aLCID, { "Malay - Malaysia             ", "ms", "ms-my ", " 1086", " 43E", "1252", "" } )
   AADD( aLCID, { "Malayalam                    ", "ml", "ml    ", " 1100", " 44C", "    ", "" } )
   AADD( aLCID, { "Maltese                      ", "mt", "mt    ", " 1082", " 43A", "    ", "" } )
   AADD( aLCID, { "Manipuri                     ", "  ", "      ", " 1112", " 458", "    ", "" } )
   AADD( aLCID, { "Maori                        ", "mi", "mi    ", " 1153", " 481", "    ", "" } )
   AADD( aLCID, { "Marathi                      ", "mr", "mr    ", " 1102", " 44E", "    ", "" } )
   AADD( aLCID, { "Mongolian                    ", "mn", "mn    ", " 2128", " 850", "    ", "" } )
   AADD( aLCID, { "Mongolian                    ", "mn", "mn    ", " 1104", " 450", "1251", "" } )
   AADD( aLCID, { "Nepali                       ", "ne", "ne    ", " 1121", " 461", "    ", "" } )
   AADD( aLCID, { "Norwegian - Bokml            ", "nb", "no-no ", " 1044", " 414", "1252", "" } )
   AADD( aLCID, { "Norwegian - Nynorsk          ", "nn", "no-no ", " 2068", " 814", "1252", "" } )
   AADD( aLCID, { "Oriya                        ", "or", "or    ", " 1096", " 448", "    ", "" } )
   AADD( aLCID, { "Polish                       ", "pl", "pl    ", " 1045", " 415", "1250", "PLWIN" } )
   AADD( aLCID, { "Portuguese - Brazil          ", "pt", "pt-br ", " 1046", " 416", "1252", "PTISO" } )
   AADD( aLCID, { "Portuguese - Portugal        ", "pt", "pt-pt ", " 2070", " 816", "1252", "PTISO" } )
   AADD( aLCID, { "Punjabi                      ", "pa", "pa    ", " 1094", " 446", "    ", "" } )
   AADD( aLCID, { "Raeto-Romance                ", "rm", "rm    ", " 1047", " 417", "    ", "" } )
   AADD( aLCID, { "Romanian - Moldova           ", "ro", "ro-mo ", " 2072", " 818", "    ", "" } )
   AADD( aLCID, { "Romanian - Romania           ", "ro", "ro    ", " 1048", " 418", "1250", "ROWIN" } )
   AADD( aLCID, { "Russian                      ", "ru", "ru    ", " 1049", " 419", "1251", "RU1251" } )
   AADD( aLCID, { "Russian - Moldova            ", "ru", "ru-mo ", " 2073", " 819", "    ", "" } )
   AADD( aLCID, { "Sami Lappish                 ", "  ", "      ", " 1083", " 43B", "    ", "" } )
   AADD( aLCID, { "Sanskrit                     ", "sa", "sa    ", " 1103", " 44F", "    ", "" } )
   AADD( aLCID, { "Serbian - Cyrillic           ", "sr", "sr-sp ", " 3098", " C1A", "1251", "" } )
   AADD( aLCID, { "Serbian - Latin              ", "sr", "sr-sp ", " 2074", " 81A", "1250", "SRWIN" } )
   AADD( aLCID, { "Sesotho (Sutu)               ", "  ", "      ", " 1072", " 430", "    ", "" } )
   AADD( aLCID, { "Setsuana                     ", "tn", "tn    ", " 1074", " 432", "    ", "" } )
   AADD( aLCID, { "Sindhi                       ", "sd", "sd    ", " 1113", " 459", "    ", "" } )
   AADD( aLCID, { "Slovak                       ", "sk", "sk    ", " 1051", " 41B", "1250", "SKWIN" } )
   AADD( aLCID, { "Slovenian                    ", "sl", "sl    ", " 1060", " 424", "1250", "SLWIN" } )
   AADD( aLCID, { "Somali                       ", "so", "so    ", " 1143", " 477", "    ", "" } )
   AADD( aLCID, { "Sorbian                      ", "sb", "sb    ", " 1070", " 42E", "    ", "" } )
   AADD( aLCID, { "Spanish - Argentina          ", "es", "es-ar ", "11274", "2C0A", "1252", "ESWIN" } )
   AADD( aLCID, { "Spanish - Bolivia            ", "es", "es-bo ", "16394", "400A", "1252", "ESWIN" } )
   AADD( aLCID, { "Spanish - Chile              ", "es", "es-cl ", "13322", "340A", "1252", "ESWIN" } )
   AADD( aLCID, { "Spanish - Colombia           ", "es", "es-co ", " 9226", "240A", "1252", "ESWIN" } )
   AADD( aLCID, { "Spanish - Costa Rica         ", "es", "es-cr ", " 5130", "140A", "1252", "ESWIN" } )
   AADD( aLCID, { "Spanish - Dominican Republic ", "es", "es-do ", " 7178", "1C0A", "1252", "ESWIN" } )
   AADD( aLCID, { "Spanish - Ecuador            ", "es", "es-ec ", "12298", "300A", "1252", "ESWIN" } )
   AADD( aLCID, { "Spanish - El Salvador        ", "es", "es-sv ", "17418", "440A", "1252", "ESWIN" } )
   AADD( aLCID, { "Spanish - Guatemala          ", "es", "es-gt ", " 4106", "100A", "1252", "ESWIN" } )
   AADD( aLCID, { "Spanish - Honduras           ", "es", "es-hn ", "18442", "480A", "1252", "ESWIN" } )
   AADD( aLCID, { "Spanish - Mexico             ", "es", "es-mx ", " 2058", " 80A", "1252", "ESWIN" } )
   AADD( aLCID, { "Spanish - Nicaragua          ", "es", "es-ni ", "19466", "4C0A", "1252", "ESWIN" } )
   AADD( aLCID, { "Spanish - Panama             ", "es", "es-pa ", " 6154", "180A", "1252", "ESWIN" } )
   AADD( aLCID, { "Spanish - Paraguay           ", "es", "es-py ", "15370", "3C0A", "1252", "ESWIN" } )
   AADD( aLCID, { "Spanish - Peru               ", "es", "es-pe ", "10250", "280A", "1252", "ESWIN" } )
   AADD( aLCID, { "Spanish - Puerto Rico        ", "es", "es-pr ", "20490", "500A", "1252", "ESWIN" } )
   AADD( aLCID, { "Spanish - Spain (Traditional)", "es", "es-es ", " 1034", " 40A", "1252", "ESWIN" } )
   AADD( aLCID, { "Spanish - Uruguay            ", "es", "es-uy ", "14346", "380A", "1252", "ESWIN" } )
   AADD( aLCID, { "Spanish - Venezuela          ", "es", "es-ve ", " 8202", "200A", "1252", "ESWIN" } )
   AADD( aLCID, { "Swahili                      ", "sw", "sw    ", " 1089", " 441", "1252", "" } )
   AADD( aLCID, { "Swedish - Finland            ", "sv", "sv-fi ", " 2077", " 81D", "1252", "SVWIN" } )
   AADD( aLCID, { "Swedish - Sweden             ", "sv", "sv-se ", " 1053", " 41D", "1252", "SVWIN" } )
   AADD( aLCID, { "Syriac                       ", "  ", "      ", " 1114", " 45A", "    ", "" } )
   AADD( aLCID, { "Tajik                        ", "tg", "tg    ", " 1064", " 428", "    ", "" } )
   AADD( aLCID, { "Tamil                        ", "ta", "ta    ", " 1097", " 449", "    ", "" } )
   AADD( aLCID, { "Tatar                        ", "tt", "tt    ", " 1092", " 444", "1251", "" } )
   AADD( aLCID, { "Telugu                       ", "te", "te    ", " 1098", " 44A", "    ", "" } )
   AADD( aLCID, { "Thai                         ", "th", "th    ", " 1054", " 41E", "    ", "" } )
   AADD( aLCID, { "Tibetan                      ", "bo", "bo    ", " 1105", " 451", "    ", "" } )
   AADD( aLCID, { "Tsonga                       ", "ts", "ts    ", " 1073", " 431", "    ", "" } )
   AADD( aLCID, { "Turkish                      ", "tr", "tr    ", " 1055", " 41F", "1254", "TRWIN" } )
   AADD( aLCID, { "Turkmen                      ", "tk", "tk    ", " 1090", " 442", "    ", "" } )
   AADD( aLCID, { "Ukrainian                    ", "uk", "uk    ", " 1058", " 422", "1251", "" } )
   AADD( aLCID, { "Unicode                      ", "  ", "UTF-8 ", "    0", "    ", "    ", "" } )
   AADD( aLCID, { "Urdu                         ", "ur", "ur    ", " 1056", " 420", "1256", "" } )
   AADD( aLCID, { "Uzbek - Cyrillic             ", "uz", "uz-uz ", " 2115", " 843", "1251", "" } )
   AADD( aLCID, { "Uzbek - Latin                ", "uz", "uz-uz ", " 1091", " 443", "1254", "" } )
   AADD( aLCID, { "Venda                        ", "  ", "      ", " 1075", " 433", "    ", "" } )
   AADD( aLCID, { "Vietnamese                   ", "vi", "vi    ", " 1066", " 42A", "1258", "" } )
   AADD( aLCID, { "Welsh                        ", "cy", "cy    ", " 1106", " 452", "    ", "" } )
   AADD( aLCID, { "Xhosa                        ", "xh", "xh    ", " 1076", " 434", "    ", "" } )
   AADD( aLCID, { "Yiddish                      ", "yi", "yi    ", " 1085", " 43D", "    ", "" } )
   AADD( aLCID, { "Zulu                         ", "zu", "zu    ", " 1077", " 435", "    ", "" } )

RETURN aLCID

*+ EOF: CODEPAGE.PRG
