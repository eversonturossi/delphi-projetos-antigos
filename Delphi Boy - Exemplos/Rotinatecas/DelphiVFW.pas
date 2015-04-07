// Wheberson Hudson Migueletti, em Brasília, 29 de junho de 2000.
// Internet   : http://www.geocities.com/whebersite
// E-mail     : whebersite@zipmail.com.br
// Referências: 1) 1.1) MSDN Online Library - Microsoft SDK
//                      http://msdn.microsoft.com/library
//                 1.2) Help - Win32 Developer's References
//                      mm.hlp
//              2) Borland/Inprise
//                 /Delphi 3/Source/Rtl/Win/OLE2.pas
//              3) Anderson Software - Rob Anderson
//                 anderson@nosredna.com
//                 VFW.pas
//              4) Toni Martir
//                 techni-web@pala.com
//                 VFW.pas
//              5) efg's Computer Lab - Earl F. Glynn
//                 http://www.efg2.com
//
// Video for Windows (VFW)

unit DelphiVFW;

interface

uses Windows;

type
  Long= Integer;
  PVoid= Pointer;

  TAnsiChar_64= array[0..63] of AnsiChar;
  TWideChar_64= array[0..63] of WideChar;

  // Globally unique ID
  PGUID= ^TGUID;
  TGUID= record
    D1: Integer;
    D2: Word;
    D3: Word;
    D4: array[0..7] of Byte;
  end;

  // Interface ID
  PIID= PGUID;
  TIID= TGUID;

  // Class ID
  PCLSID= PGUID;
  TCLSID= TGUID;

  PAVIFileInfoW= ^TAVIFileInfoW;
  TAVIFileInfoW= record
    dwMaxBytesPerSec     : DWord;
    dwFlags              : DWord;
    dwCaps               : DWord;
    dwStreams            : DWord;
    dwSuggestedBufferSize: DWord;
    dwWidth              : DWord;
    dwHeight             : DWord;
    dwScale              : DWord;
    dwRate               : DWord;
    dwLength             : DWord;
    dwEditCount          : DWord;
    szFileType           : TWideChar_64;
  end;

  PAVIStreamInfoA= ^TAVIStreamInfoA;
  TAVIStreamInfoA= record
    fccType              : DWord;
    fccHandler           : DWord;
    dwFlags              : DWord;
    dwCaps               : DWord;
    wPriority            : WORD;
    wLanguage            : WORD;
    dwScale              : DWord;
    dwRate               : DWord;
    dwStart              : DWord;
    dwLength             : DWord;
    dwInitialFrames      : DWord;
    dwSuggestedBufferSize: DWord;
    dwQuality            : DWord;
    dwSampleSize         : DWord;
    rcFrame              : TRect;
    dwEditCount          : TAnsiChar_64;
    dwFormatChangeCount  : TAnsiChar_64;
    szName               : TAnsiChar_64;
  end;
  PAVIStreamInfo= PAVIStreamInfoA;
  TAVIStreamInfo= TAVIStreamInfoA;

  PAVIStreamInfoW= ^TAVIStreamInfoW;
  TAVIStreamInfoW= record
    fccType              : DWord;
    fccHandler           : DWord;
    dwFlags              : DWord;
    dwCaps               : DWord;
    wPriority            : Word;
    wLanguage            : Word;
    dwScale              : DWord;
    dwRate               : DWord;
    dwStart              : DWord;
    dwLength             : DWord;
    dwInitialFrames      : DWord;
    dwSuggestedBufferSize: DWord;
    dwQuality            : DWord;
    dwSampleSize         : DWord;
    rcFrame              : TRect;
    dwEditCount          : TWideChar_64;
    dwFormatChangeCount  : TWideChar_64;
    szName               : TWideChar_64;
  end;

  IUnknown= class
  public
    function QueryInterface (const iid: TIID; var obj): HResult; virtual; stdcall; abstract;
    function AddRef: Integer; virtual; stdcall; abstract;
    function Release: Integer; virtual; stdcall; abstract;
  end;

  PAVIStream= ^IAVIStream;
  IAVIStream= class (IUnknown)
    function Create     (lParam1, lParam2: LPARAM): HResult; virtual; stdcall; abstract;
    function Delete     (lStart, lSamples: Long): HResult; virtual; stdcall; abstract;
    function Info       (var psi: PAVIStreamInfoW; lSize: Long): HResult; virtual; stdcall; abstract;
    function FindSample (lPos, lFlags: Long): Long; virtual; stdcall; abstract;
    function Read       (lStart, lSamples: Long; lpBuffer: PVoid; cbBuffer: Long; var plBytes: Long; var plSamples: Long): HResult; virtual; stdcall; abstract;
    function ReadData   (fcc: DWord; lp: PVoid; var lpcb: Long): HResult; virtual; stdcall; abstract;
    function ReadFormat (lPos: Long; lpFormat: PVoid; var lpcbFormat: Long): HResult; virtual; stdcall; abstract;
    function SetFormat  (lPos: Long; lpFormat: PVoid; lpcbFormat: Long): HResult; virtual; stdcall; abstract;
    function Write      (lStart, lSamples: Long; lpBuffer: PVoid; cbBuffer: Long; dwFlags: DWord; var plSampWritten: Long; var plBytesWritten: Long): HResult; virtual; stdcall; abstract;
    function WriteData  (fcc: DWord; lp: PVoid; cb:  Long): HResult; virtual; stdcall; abstract;
    function SetInfo    (var lpInfo: PAVIStreamInfoW; cbInfo: Long): HResult; virtual; stdcall; abstract;
  end;

  PAVIFile= ^IAVIFile;
  IAVIFile= class (IUnknown)
    function CreateStream  (var ppStream: PAVIStream; var pfi: PAVIFileInfoW): HResult; virtual; stdcall; abstract;
    function DeleteStream  (fccType: DWord; lParam: Long): HResult; virtual; stdcall; abstract;
    function EndRecord: HResult; virtual; stdcall; abstract;
    function GetStream     (var ppStream: PAVIStream; fccType: DWord; lParam: Long): HResult; virtual; stdcall; abstract;
    function Info          (var pfi: PAVIFileInfoW; lSize: Long): HResult; virtual; stdcall; abstract;
    function ReadData      (ckid: DWord; lpData: PVoid; var lpcbData: Long): HResult; virtual; stdcall; abstract;
    function WriteData     (ckid: DWord; lpData: PVoid; cbData: Long): HResult; virtual; stdcall; abstract;
  end;
  
  PGetFrame= ^IGetFrame;
  IGetFrame= class (IUnknown)
    function _Begin    (ps: PAVIStream; lStart: LONG; lEnd: LONG; lRate: LONG): HResult; virtual; stdcall; abstract;
    function _End      (ps: PAVIStream): HResult; virtual; stdcall; abstract;
    function GetFrame  (ps: PAVIStream; lPos: LONG): PVOID; virtual; stdcall; abstract;
    function SetFormat (ps: PAVIStream; lpbi: PBitmapInfoHeader; lpBits: PVOID; x, y, dx, dy: Integer): HResult; virtual; stdcall; abstract;
  end;

// AVIFile
procedure AVIFileInit; stdcall;
procedure AVIFileExit; stdcall;
function  AVIFileOpen           (var ppfile: PAVIFile; szFile: LPCSTR; uMode: UINT; lpHandler: PCLSID): HResult; stdcall;
function  AVIFileCreateStream   (pfile: PAVIFile; var ppavi: PAVIStream; psi: PAVIStreamInfo): HResult; stdcall;
function  AVIFileRelease        (pfile: PAVIFile): ULONG; stdcall;

// AVIStream
function  AVIStreamInfo         (pavi: PAVIStream; psi: PAVIStreamInfo; lSize: DWord): HResult; stdcall; 
function  AVIStreamLength       (pavi: PAVIStream): DWord; stdcall;
function  AVIStreamStart        (pavi: PAVIStream): DWord; stdcall;
function  AVIStreamSetFormat    (pavi: PAVIStream; lPos: Long; lpFormat: PVoid; cbFormat: Long): HResult; stdcall;
function  AVIStreamWrite        (pavi: PAVIStream; lStart, lSamples: Long; lpBuffer: PVoid; cbBuffer: Long; dwFlags: DWord; var plSampWritten: Long; var plBytesWritten: Long): HResult; stdcall;
function  AVIStreamRelease      (pavi: PAVIStream): ULONG; stdcall;
function  AVIStreamOpenFromFile (var pavi: PAVIStream; szFile: LPCSTR; fccType: DWord; lParam: Long; uMode: UINT; lpHandler: PCLSID): HResult; stdcall;
function  AVIStreamReadFormat   (pavi: PAVIStream; lPos: Long; lpFormat: PVoid; var lpcbFormat: Long): HResult; stdcall;
function  AVIStreamRead         (pavi: PAVIStream; lStart, lSamples: Long; lpBuffer: PVoid; cbBuffer: Long; var plBytes: Long; var plSamples: Long): HResult; stdcall;

// AVIStreamGetFrame
function  AVIStreamGetFrameOpen  (pavi: PAVIStream; lpbiWanted: PBitmapInfoHeader): PGetFrame; stdcall;
function  AVIStreamGetFrameClose (pget: PGetFrame): HResult; stdcall;
function  AVIStreamGetFrame      (pgf: PGetFrame; lPos: Long): PVoid; stdcall;

const
  AVIERR_OK= 0;
  
  AVIIF_LIST= $01;
  AVIIF_TWOCC= $02;
  AVIIF_KEYFRAME= $10;

  streamtypeVIDEO= $73646976; // DWord ('v', 'i', 'd', 's')

  // AVI interface IDs
  IID_IAVIFile      : TGUID= (D1:$00020020;D2:$0;D3:$0;D4:($C0,$0,$0,$0,$0,$0,$0,$46));
  IID_IAVIStream    : TGUID= (D1:$00020021;D2:$0;D3:$0;D4:($C0,$0,$0,$0,$0,$0,$0,$46));
  IID_IAVIStreaming : TGUID= (D1:$00020022;D2:$0;D3:$0;D4:($C0,$0,$0,$0,$0,$0,$0,$46));
  IID_IGetFrame     : TGUID= (D1:$00020023;D2:$0;D3:$0;D4:($C0,$0,$0,$0,$0,$0,$0,$46));
  IID_IAVIEditStream: TGUID= (D1:$00020024;D2:$0;D3:$0;D4:($C0,$0,$0,$0,$0,$0,$0,$46));

  // AVI class IDs
  CLSID_AVISimpleUnMarshal: TGUID= (D1:$00020009;D2:$0;D3:$0;D4:($C0,$0,$0,$0,$0,$0,$0,$46));
  CLSID_AVIFile           : TGUID= (D1:$00020000;D2:$0;D3:$0;D4:($C0,$0,$0,$0,$0,$0,$0,$46));

implementation

// AVIFile
procedure AVIFileInit; stdcall; external 'avifil32.dll' name 'AVIFileInit';
procedure AVIFileExit; stdcall; external 'avifil32.dll' name 'AVIFileExit';
function  AVIFileOpen            (var ppfile: PAVIFILE; szFile: LPCSTR; uMode: UINT; lpHandler: PCLSID): HResult; external 'avifil32.dll' name 'AVIFileOpenA';
function  AVIFileCreateStream    (pfile: PAVIFile; var ppavi: PAVIStream; psi: PAVIStreamInfo): HResult;     external 'avifil32.dll' name 'AVIFileCreateStreamA';
function  AVIFileRelease         (pfile: PAVIFile): ULONG;                                                        external 'avifil32.dll' name 'AVIFileRelease';

// AVIStream
function  AVIStreamInfo          (pavi: PAVIStream; psi: PAVIStreamInfo; lSize: DWord): HResult; stdcall; external 'avifil32.dll' name 'AVIStreamInfoA';
function  AVIStreamStart         (pavi: PAVIStream): DWord; stdcall; external 'avifil32.dll' name 'AVIStreamStart';
function  AVIStreamLength        (pavi: PAVIStream): DWord; stdcall; external 'avifil32.dll' name 'AVIStreamLength';
function  AVIStreamSetFormat     (pavi: PAVIStream; lPos: Long; lpFormat: PVoid; cbFormat: Long): HResult; external 'avifil32.dll' name 'AVIStreamSetFormat';
function  AVIStreamWrite         (pavi: PAVIStream; lStart, lSamples: Long; lpBuffer: PVoid; cbBuffer: Long; dwFlags: DWord; var plSampWritten: Long; var plBytesWritten: Long): HResult; external 'avifil32.dll' name 'AVIStreamWrite';
function  AVIStreamRelease       (pavi: PAVIStream): ULONG; external 'avifil32.dll' name 'AVIStreamRelease';
function  AVIStreamOpenFromFile  (var pavi: PAVIStream; szFile: LPCSTR; fccType: DWord; lParam: Long; uMode: UINT; lpHandler: PCLSID): HResult; external 'avifil32.dll' name 'AVIStreamOpenFromFileA';
function  AVIStreamReadFormat    (pavi: PAVIStream; lPos: Long; lpFormat: PVoid; var lpcbFormat: Long): HResult; external 'avifil32.dll' name 'AVIStreamReadFormat';
function  AVIStreamRead          (pavi: PAVIStream; lStart, lSamples: Long; lpBuffer: PVoid; cbBuffer: Long; var plBytes: Long; var plSamples: Long): HResult; external 'avifil32.dll' name 'AVIStreamRead';

// AVIStreamGetFrame
function  AVIStreamGetFrameOpen  (pavi: PAVIStream; lpbiWanted: PBitmapInfoHeader): PGetFrame; stdcall; external 'avifil32.dll' name 'AVIStreamGetFrameOpen';
function  AVIStreamGetFrameClose (pget: PGetFrame): HResult; stdcall; external 'avifil32.dll' name 'AVIStreamGetFrameClose';
function  AVIStreamGetFrame      (pgf: PGetFrame; lPos: Long): PVoid; stdcall; external 'avifil32.dll' name 'AVIStreamGetFrame';

end.
