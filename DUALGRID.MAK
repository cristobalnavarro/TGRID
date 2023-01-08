HBDIR=c:\harbour
BCDIR=c:\BCC7
FWDIR=c:\fwh

#change these paths as needed
.path.OBJ = .\obj
.path.PRG = .\
.path.CH  = $(FWDIR)\include;$(HBDIR)\include;$(BCDIR)\include\windows
.path.C   = .\
.path.rc  = .\

#important: Use Uppercase for filenames extensions, in the next two rules!

PRG = \
DUALGRID.PRG \
TGRID.PRG    \
SHELLAPP.PRG \
HBEJECT.PRG  \
CODEPAGE.PRG \
IPHONE.PRG   \
PROPERTY.PRG \
EVERYTH.PRG  \
HB_FUNC.PRG

PROJECT    : DUALGRID.exe

DUALGRID.exe  : $(PRG:.PRG=.OBJ) DUALGRID.res
   @echo off
   echo $(BCDIR)\lib\c0w32.obj + > b32.bc
   echo obj\DUALGRID.obj obj\TGRID.obj obj\HB_FUNC.obj obj\SHELLAPP.obj obj\HBEJECT.obj obj\CODEPAGE.obj obj\IPHONE.obj obj\PROPERTY.obj obj\EVERYTH.obj , + >> b32.bc
   echo DUALGRID.exe, + >> b32.bc
   echo DUALGRID.map, + >> b32.bc
   echo $(FWDIR)\lib\FiveH.lib $(FWDIR)\lib\FiveHC.lib + >> b32.bc
   echo $(HBDIR)\lib\win\bcc\hbrtl.lib + >> b32.bc
   echo $(HBDIR)\lib\win\bcc\hbvm.lib + >> b32.bc
   echo $(HBDIR)\lib\win\bcc\gtgui.lib + >> b32.bc
   echo $(HBDIR)\lib\win\bcc\hblang.lib + >> b32.bc
   echo $(HBDIR)\lib\win\bcc\hbmacro.lib + >> b32.bc
   echo $(HBDIR)\lib\win\bcc\hbrdd.lib + >> b32.bc
   echo $(HBDIR)\lib\win\bcc\rddntx.lib + >> b32.bc
   echo $(HBDIR)\lib\win\bcc\rddcdx.lib + >> b32.bc
   echo $(HBDIR)\lib\win\bcc\rddfpt.lib + >> b32.bc
   echo $(HBDIR)\lib\win\bcc\hbsix.lib + >> b32.bc
   echo $(HBDIR)\lib\win\bcc\hbdebug.lib + >> b32.bc
   echo $(HBDIR)\lib\win\bcc\hbcommon.lib + >> b32.bc
   echo $(HBDIR)\lib\win\bcc\hbpp.lib + >> b32.bc
   echo $(HBDIR)\lib\win\bcc\hbwin.lib + >> b32.bc
   echo $(HBDIR)\lib\win\bcc\hbcpage.lib + >> b32.bc
   echo $(HBDIR)\lib\win\bcc\hbct.lib + >> b32.bc
   echo $(HBDIR)\lib\win\bcc\hbpcre.lib + >> b32.bc
   echo $(HBDIR)\lib\win\bcc\hbcplr.lib + >> b32.bc
   echo $(HBDIR)\lib\win\bcc\xhb.lib + >> b32.bc
   
   echo $(HBDIR)\lib\win\bcc\hbziparc.lib +  >> b32.bc
   echo $(HBDIR)\lib\win\bcc\hbmzip.lib +  >> b32.bc
   echo $(HBDIR)\lib\win\bcc\hbzlib.lib +  >> b32.bc
   echo $(HBDIR)\lib\win\bcc\minizip.lib +  >> b32.bc
   echo $(HBDIR)\lib\win\bcc\png.lib +  >> b32.bc
   echo $(HBDIR)\lib\win\bcc\hbusrrdd.lib +  >> b32.bc
   echo $(HBDIR)\lib\win\bcc\hbtip.lib +  >> b32.bc
   echo $(HBDIR)\lib\win\bcc\hbzebra.lib +  >> b32.bc
   echo $(HBDIR)\lib\win\bcc\hbcurl.lib +  >> b32.bc
   echo $(HBDIR)\lib\win\bcc\libcurl.lib +  >> b32.bc
   echo $(HBDIR)\lib\win\bcc\hbxpp.lib +  >> b32.bc

   echo $(FWDIR)\lib\dolphin.lib +  >> b32.bc
   
   echo $(BCDIR)\lib\cw32.lib + >> b32.bc
   echo $(BCDIR)\lib\uuid.lib + >> b32.bc 
   echo $(BCDIR)\lib\ws2_32.lib +  >> b32.bc
   echo $(BCDIR)\lib\psdk\gdiplus.lib +  >> b32.bc
   echo $(BCDIR)\lib\import32.lib + >> b32.bc
   echo $(BCDIR)\lib\psdk\odbc32.lib + >> b32.bc
   echo $(BCDIR)\lib\psdk\nddeapi.lib + >> b32.bc
   echo $(BCDIR)\lib\psdk\iphlpapi.lib + >> b32.bc
   echo $(BCDIR)\lib\psdk\msimg32.lib + >> b32.bc
   echo $(BCDIR)\lib\psdk\psapi.lib + >> b32.bc
   echo $(BCDIR)\lib\psdk\rasapi32.lib + >> b32.bc
   echo $(BCDIR)\lib\psdk\shell32.lib,  >> b32.bc

   IF EXIST DUALGRID.res echo DUALGRID.res >> b32.bc
   $(BCDIR)\bin\ilink32 -Gn -aa -Tpe -s @b32.bc
   del b32.bc

.PRG.OBJ:
  $(HBDIR)\bin\harbour $< /L /N /W /Oobj\ /I$(FWDIR)\include;$(HBDIR)\include;$(BCDIR)\include\windows

  $(BCDIR)\bin\bcc32 -c -tWM -I$(HBDIR)\include -oobj\$& obj\$&.c

.C.OBJ:
  echo -c -tWM -D__HARBOUR__ -DHB_API_MACROS > tmp
  echo -I$(HBDIR)\include;$(FWDIR)\include >> tmp
  $(BCDIR)\bin\bcc32 -oobj\$& @tmp $&.c
  del tmp

DUALGRID.res : DUALGRID.rc
  $(BCDIR)\bin\brc32.exe -r DUALGRID.rc