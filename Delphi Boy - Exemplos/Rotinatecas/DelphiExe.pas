{ Wheberson Hudson Migueletti, em Brasília, 18 de janeiro de 2000.
  Referências: "Resxplor, Borland" e "PEDUMP, Matt Pietrek"
  Delphi     : /Delphi/Demos/Resxplor/ExeImage.pas
               /Delphi/Demos/Resxplor/Rxtypes.pas
  Internet   : http://msdn.microsoft.com/library
               http://msdn.microsoft.com/library/specs/msdn_pecoff.htm
               http://msdn.microsoft.com/library/techart/msdn_peeringpe.htm
               http://msdn.microsoft.com/library/techart/samples/5245.exe    ---> PEDUMP
}

unit DelphiExe;

interface

uses Windows, SysUtils, Classes, Controls, Graphics;

const
  IMAGE_RESOURCE_NAME_IS_STRING         = $80000000;
  IMAGE_RESOURCE_DATA_IS_DIRECTORY      = $80000000;
  IMAGE_OFFSET_STRIP_HIGH               = $7FFFFFFF;
  IMAGE_ORDINAL_FLAG                    = $80000000;
  RT_CURSOR                             = 1;
  RT_BITMAP                             = 2;
  RT_ICON                               = 3;
  RT_MENU                               = 4;
  RT_DIALOG                             = 5;
  RT_STRING                             = 6;
  RT_FONTDIR                            = 7;
  RT_FONT                               = 8;
  RT_ACCELERATORS                       = 9;
  RT_RCDATA                             = 10;
  RT_MESSAGETABLE                       = 11;
  RT_GROUP_CURSOR                       = 12;
  RT_GROUP_ICON                         = 14;
  RT_VERSION                            = 16;
  cResourceNames: array[0..16] of String= ('?', 'Cursor', 'Bitmap', 'Icon', 'Menu',
                                           'Dialog', 'String', 'FontDir', 'Font',
                                           'Accelerators', 'RCData', 'MessageTable',
                                           'GroupCursor', '?', 'GroupIcon', '?',
                                           'Version');

type
  // Resource Related Structures from RESFMT.TXT in WIN32 SDK
  
  EExeError= class (Exception);

  PIMAGE_DOS_HEADER= ^IMAGE_DOS_HEADER;
  IMAGE_DOS_HEADER= packed record
    e_magic   : WORD;                       // Signature
    e_cblp    : WORD;                       // Last page size
    e_cp      : WORD;                       // Total pages in file
    e_crlc    : WORD;                       // Relocations items
    e_cparhdr : WORD;                       // Paragraphs in header
    e_minalloc: WORD;                       // Minimum extra paragraphs
    e_maxalloc: WORD;                       // Maximum extra paragraphs
    e_ss      : WORD;                       // Initial Stack Segment (SS)
    e_sp      : WORD;                       // Initial Stack Pointer (SP)
    e_csum    : WORD;                       // Checksum
    e_ip      : WORD;                       // Initial Instruction Pointer (IP)
    e_cs      : WORD;                       // Initial Code Segment (CS)
    e_lfarlc  : WORD;                       // Relocation table offset
    e_ovno    : WORD;                       // Overlay number
    e_res     : packed array[0..3] of WORD; // Reserved words
    e_oemid   : WORD;                       // OEM identifier (for e_oeminfo)
    e_oeminfo : WORD;                       // OEM information; e_oemid specific
    e_res2    : packed array[0..9] of WORD; // Reserved words
    e_lfanew  : LongInt;                    // File address of new exe header
  end;
  
  PIMAGE_FILE_HEADER = ^IMAGE_FILE_HEADER;
  IMAGE_FILE_HEADER = packed record
    Machine              : WORD;
    NumberOfSections     : WORD;
    TimeDateStamp        : DWORD;
    PointerToSymbolTable : DWORD;
    NumberOfSymbols      : DWORD;
    SizeOfOptionalHeader : WORD;
    Characteristics      : WORD;
  end;

  PIMAGE_DATA_DIRECTORY= ^IMAGE_DATA_DIRECTORY;
  IMAGE_DATA_DIRECTORY= packed record
    VirtualAddress: DWORD;
    Size          : DWORD;
  end;

  PIMAGE_OPTIONAL_HEADER= ^IMAGE_OPTIONAL_HEADER;
  IMAGE_OPTIONAL_HEADER= packed record
   { Standard fields. }
    Magic                      : WORD;
    MajorLinkerVersion         : Byte;
    MinorLinkerVersion         : Byte;
    SizeOfCode                 : DWORD;
    SizeOfInitializedData      : DWORD;
    SizeOfUninitializedData    : DWORD;
    AddressOfEntryPoint        : DWORD;
    BaseOfCode                 : DWORD;
    BaseOfData                 : DWORD;
   { NT additional fields. }
    ImageBase                  : DWORD;
    SectionAlignment           : DWORD;
    FileAlignment              : DWORD;
    MajorOperatingSystemVersion: WORD;
    MinorOperatingSystemVersion: WORD;
    MajorImageVersion          : WORD;
    MinorImageVersion          : WORD;
    MajorSubsystemVersion      : WORD;
    MinorSubsystemVersion      : WORD;
    Reserved1                  : DWORD;
    SizeOfImage                : DWORD;
    SizeOfHeaders              : DWORD;
    CheckSum                   : DWORD;
    Subsystem                  : WORD;
    DllCharacteristics         : WORD;
    SizeOfStackReserve         : DWORD;
    SizeOfStackCommit          : DWORD;
    SizeOfHeapReserve          : DWORD;
    SizeOfHeapCommit           : DWORD;
    LoaderFlags                : DWORD;
    NumberOfRvaAndSizes        : DWORD;
    DataDirectory              : packed array [0..IMAGE_NUMBEROF_DIRECTORY_ENTRIES-1] of IMAGE_DATA_DIRECTORY;
  end;

  PIMAGE_SECTION_HEADER= ^IMAGE_SECTION_HEADER;
  IMAGE_SECTION_HEADER= packed record
    Name                : packed array[0..IMAGE_SIZEOF_SHORT_NAME-1] of Char;
    PhysicalAddress     : DWORD; // or VirtualSize (union);
    VirtualAddress      : DWORD;
    SizeOfRawData       : DWORD;
    PointerToRawData    : DWORD;
    PointerToRelocations: DWORD;
    PointerToLinenumbers: DWORD;
    NumberOfRelocations : WORD;
    NumberOfLinenumbers : WORD;
    Characteristics     : DWORD;
  end;

  PIMAGE_NT_HEADERS= ^IMAGE_NT_HEADERS;
  IMAGE_NT_HEADERS= packed record
    Signature     : DWORD;
    FileHeader    : IMAGE_FILE_HEADER;
    OptionalHeader: IMAGE_OPTIONAL_HEADER;
  end;

  PIMAGE_IMPORT_DESCRIPTOR= ^IMAGE_IMPORT_DESCRIPTOR;
  IMAGE_IMPORT_DESCRIPTOR= packed record
    Characteristics: DWORD;
    TimeDateStamp  : DWORD;
    ForwarderChain : DWORD;
    Name           : DWORD;
    FirstThunk     : DWORD; // PIMAGE_THUNK_DATA
  end;
  
  PIMAGE_IMPORT_BY_NAME= ^IMAGE_IMPORT_BY_NAME;
  IMAGE_IMPORT_BY_NAME= packed record
    Hint: WORD;
    Name: array[0..0] of Char;
  end;

  PIMAGE_RESOURCE_DIRECTORY= ^IMAGE_RESOURCE_DIRECTORY;
  IMAGE_RESOURCE_DIRECTORY= packed record
    Characteristics     : DWORD;
    TimeDateStamp       : DWORD;
    MajorVersion        : WORD;
    MinorVersion        : WORD;
    NumberOfNamedEntries: WORD;
    NumberOfIdEntries   : WORD;
  end;

  PIMAGE_RESOURCE_DIRECTORY_ENTRY= ^IMAGE_RESOURCE_DIRECTORY_ENTRY;
  IMAGE_RESOURCE_DIRECTORY_ENTRY= packed record
    Name        : DWORD;        // Or ID: Word (Union)
    OffsetToData: DWORD;
  end;

  PIMAGE_RESOURCE_DATA_ENTRY = ^IMAGE_RESOURCE_DATA_ENTRY;
  IMAGE_RESOURCE_DATA_ENTRY = packed record
    OffsetToData: DWORD;
    Size        : DWORD;
    CodePage    : DWORD;
    Reserved    : DWORD;
  end;

  PIMAGE_RESOURCE_DIR_STRING_U= ^IMAGE_RESOURCE_DIR_STRING_U;
  IMAGE_RESOURCE_DIR_STRING_U= packed record
    Length    : WORD;
    NameString: array[0..0] of WCHAR;
  end;

  PIMAGE_THUNK_DATA= ^IMAGE_THUNK_DATA;
  IMAGE_THUNK_DATA= packed record
    case Integer of
      0: (ForwarderString: DWORD); // PBYTE
      1: (Func           : DWORD); // PDWORD
      2: (Ordinal        : DWORD);
      3: (AddressOfData  : DWORD); // PIMAGE_IMPORT_BY_NAME
  end;

  PResourceItem= ^TResourceItem;
  TResourceItem= record
    Name  : String;
    Stream: TMemoryStream;
  end;

  TExe= class
    private
      SerResourceRequisitado: Boolean;
      Resource              : Integer;
      ResourceBase          : DWORD;
      ResourceRVA           : DWORD;
      FileBase              : Pointer;
      FileHandle            : THandle;
      FileMapping           : THandle;
      Images                : TList;
      Strings               : TStringList;

      procedure DumpResourceDirectory (ResourceDirectory: PIMAGE_RESOURCE_DIRECTORY; CurrentResource: Integer);
      procedure DumpResourceEntry     (ResourceDirectoryEntry: PIMAGE_RESOURCE_DIRECTORY_ENTRY; ResourceName: String);
    public
      DosHeader    : PIMAGE_DOS_HEADER;
      NTHeader     : PIMAGE_NT_HEADERS;
      SectionHeader: PIMAGE_SECTION_HEADER;

      constructor Create (const FileName: String);
      destructor  Destroy; override;
      procedure   ClearImages;
      function    GetSectionHeader (const SectionName: String; var Header: PIMAGE_SECTION_HEADER): Boolean;
      function    GetImages        (ResourceType: Integer): TList;
      function    GetStrings       (ResourceType: Integer): TStringList;
  end;

procedure ExeError          (const ErrMsg: String);
function  HighBitSet        (L: LongInt): Boolean;
function  StripHighBit      (L: LongInt): LongInt;
function  WideCharToStr     (WStr: PWChar; Len: Integer): String;
//function  GetIconFromList   (List: TList; Index: Integer; Icon: Boolean; var Info: TBitmapInfoHeader): TIcon;
function  GetIconFromList   (List: TList; Index: Integer; Icon: Boolean; var IconName: String; var Info: TBitmapInfoHeader): TIcon;
function  GetBitmapFromList (List: TList; Index: Integer; var BitmapName: String): TBitmap;

implementation





procedure ExeError (const ErrMsg: String);

begin
  raise EExeError.Create (ErrMsg);
end;




// Assumes: IMAGE_RESOURCE_NAME_IS_STRING = IMAGE_RESOURCE_DATA_IS_DIRECTORY
function HighBitSet (L: LongInt): Boolean;

begin
  Result:= (L and IMAGE_RESOURCE_DATA_IS_DIRECTORY) <> 0;
end;





function StripHighBit (L: LongInt): LongInt;

begin
  Result:= L and IMAGE_OFFSET_STRIP_HIGH;
end;





function WideCharToStr (WStr: PWChar; Len: Integer): String;

begin
  if Len = 0 then
    Len:= -1;
  Len:= WideCharToMultiByte (CP_ACP, 0, WStr, Len, nil, 0, nil, nil);
  SetLength (Result, Len);
  WideCharToMultiByte (CP_ACP, 0, WStr, Len, PChar (Result), Len, nil, nil);
end;





function GetIconFromList (List: TList; Index: Integer; Icon: Boolean; var IconName: String; var Info: TBitmapInfoHeader): TIcon;
var
  Tamanho: Integer;
  Inicio : Pointer;
  BI     : PBitmapInfoHeader;

begin
  Result:= nil;
  if Assigned (List) and (Index >= 0) and (Index < List.Count) and Assigned (List.Items[Index]) then begin
    IconName:= PResourceItem (List.Items[Index]).Name;
    Inicio  := PResourceItem (List.Items[Index]).Stream.Memory;
    Tamanho := PResourceItem (List.Items[Index]).Stream.Size;
    BI      := PBitmapInfoHeader (Inicio);
    Result  := TIcon.Create;
    try
      Result.Handle:= CreateIconFromResource (Pointer (Inicio), Tamanho, Icon, $30000);
      if not Icon then
        PChar (BI):= PChar (BI) + 4;
      Info:= BI^;
    except
      Result.Free;
      Result:= nil;
    end;
  end;
end;





function GetBitmapFromList (List: TList; Index: Integer; var BitmapName: String): TBitmap;

begin
  Result:= nil;
  if Assigned (List) and (Index >= 0) and (Index < List.Count) and Assigned (List.Items[Index]) then begin
    BitmapName:= PResourceItem (List.Items[Index]).Name;
    Result    := TBitmap.Create;
    try
      Result.LoadFromStream (PResourceItem (List.Items[Index]).Stream);
    except
      Result.Free;
      Result:= nil;
    end;
  end;
end;





constructor TExe.Create (const FileName: String);

begin
  FileHandle:= CreateFile (PChar (FileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if FileHandle = INVALID_HANDLE_VALUE then
    ExeError ('Couldn''t open: ' + FileName);
  FileMapping:= CreateFileMapping (FileHandle, nil, PAGE_READONLY, 0, 0, nil);
  if FileMapping = 0 then
    ExeError ('Couldn''t open: ' + FileName);
  FileBase:= MapViewOfFile (FileMapping, FILE_MAP_READ, 0, 0, 0);
  if FileBase = nil then
    ExeError ('Couldn''t open: ' + FileName);
  DosHeader:= PIMAGE_DOS_HEADER (FileBase);
  if DosHeader.e_magic <> IMAGE_DOS_SIGNATURE then
    ExeError ('Unrecognized file format');
  NTHeader     := PIMAGE_NT_HEADERS (LongInt (DosHeader) + DosHeader.e_lfanew);
  SectionHeader:= PIMAGE_SECTION_HEADER (NTHeader);
  {if IsBadReadPtr (NTHeader, SizeOf (IMAGE_NT_HEADERS)) or (NTHeader.Signature <> IMAGE_NT_SIGNATURE) then
    ExeError ('Not a PE (WIN32 Executable) file');}
end;





destructor TExe.Destroy;

begin
  if FileHandle <> INVALID_HANDLE_VALUE then begin
    UnmapViewOfFile (FileBase);
    CloseHandle (FileMapping);
    CloseHandle (FileHandle);
  end;
  if Assigned (Images) then begin
    ClearImages;
    Images.Free;
  end;  
  if Assigned (Strings) then
    Strings.Free;
  inherited Destroy;
end;





procedure TExe.ClearImages;
var
  I: Integer;

begin
  if Assigned (Images) then begin
    for I:= 0 to Images.Count-1 do begin
      PResourceItem (Images.Items[I]).Stream.Free;
      SetLength (PResourceItem (Images.Items[I]).Name, 0);
      Dispose (Images.Items[I]);
    end;
    Images.Clear;
  end;
end;





function TExe.GetSectionHeader (const SectionName: String; var Header: PIMAGE_SECTION_HEADER): Boolean;
var
  I: Integer;

begin
  Header:= PIMAGE_SECTION_HEADER (NTHeader);
  Inc (PIMAGE_NT_HEADERS (Header));
  for I:= 1 to NTHeader.FileHeader.NumberOfSections do begin
    if Strlicomp (Header.Name, PChar (SectionName), IMAGE_SIZEOF_SHORT_NAME) = 0 then begin
      Result:= True;
      Exit;
    end;
    Inc (Header);
  end;
  Result:= False;
end;





function TExe.GetImages (ResourceType: Integer): TList;
var
  Section: PIMAGE_SECTION_HEADER;

begin
  if (ResourceType in [RT_ICON, RT_CURSOR, RT_BITMAP]) and GetSectionHeader ('.rsrc', Section) then begin
    if Assigned (Images) then begin
      ClearImages;
      Images.Free;
      Images:= nil;
    end;
    Images                := TList.Create;
    ResourceBase          := Section.PointerToRawData + LongInt (DosHeader);
    ResourceRVA           := Section.VirtualAddress;
    Resource              := ResourceType;
    SerResourceRequisitado:= False;
    DumpResourceDirectory (PIMAGE_RESOURCE_DIRECTORY (ResourceBase), 0);
    Result:= Images;
  end
  else
    Result:= nil;
end;





function TExe.GetStrings (ResourceType: Integer): TStringList;
var
  Section: PIMAGE_SECTION_HEADER;

begin
  if (ResourceType in [RT_MENU, RT_STRING]) and GetSectionHeader ('.rsrc', Section) then begin
    if Assigned (Strings) then begin
      Strings.Free;
      Strings:= nil;
    end;
    Strings               := TStringList.Create;
    ResourceBase          := Section.PointerToRawData + LongInt (DosHeader);
    ResourceRVA           := Section.VirtualAddress;
    Resource              := ResourceType;
    SerResourceRequisitado:= False;
    DumpResourceDirectory (PIMAGE_RESOURCE_DIRECTORY (ResourceBase), 0);
    Result:= Strings;
  end
  else
    Result:= nil;
end;





procedure TExe.DumpResourceDirectory (ResourceDirectory: PIMAGE_RESOURCE_DIRECTORY; CurrentResource: Integer);
var
  I                     : Integer;
  ResourceName          : String;
  ResourceDirectoryEntry: PIMAGE_RESOURCE_DIRECTORY_ENTRY;

 function GetResourceName (Id: Integer): String;
 var
   DirStr: PIMAGE_RESOURCE_DIR_STRING_U;

 begin
   Result:= '';
   if not (Id in [0..16]) and HighBitSet (Id) then begin
     DirStr:= PIMAGE_RESOURCE_DIR_STRING_U (StripHighBit (Id) + ResourceBase);
     Result:= WideCharToStr (@DirStr.NameString, DirStr.Length);
   end;
 end;

begin
  ResourceDirectoryEntry:= PIMAGE_RESOURCE_DIRECTORY_ENTRY (ResourceDirectory);
  ResourceName          := GetResourceName (CurrentResource);
  Inc (PIMAGE_RESOURCE_DIRECTORY (ResourceDirectoryEntry));
  if not SerResourceRequisitado then begin
    SerResourceRequisitado:= True;
    for I:= 1 to ResourceDirectory.NumberOfNamedEntries + ResourceDirectory.NumberOfIdEntries do begin
      if ResourceDirectoryEntry.Name = Resource then begin // Procurar o Resource
        DumpResourceEntry (ResourceDirectoryEntry, ResourceName);
        Break;
      end;
      Inc (ResourceDirectoryEntry);
    end;
  end
  else
    for I:= 1 to ResourceDirectory.NumberOfNamedEntries + ResourceDirectory.NumberOfIdEntries do begin
      DumpResourceEntry (ResourceDirectoryEntry, ResourceName);
      Inc (ResourceDirectoryEntry);
    end;
end;





procedure TExe.DumpResourceEntry (ResourceDirectoryEntry: PIMAGE_RESOURCE_DIRECTORY_ENTRY; ResourceName: String);

 function GetDInColors (BitCount: Word): Integer;

 begin
   if BitCount in [1, 4, 8] then
     Result:= 1 shl BitCount
   else
     Result:= 0;
 end;

var
  Len         : Word;
  ClrUsed     : Integer;
  Cnt         : Integer;
  Tamanho     : Integer;
  Imagem      : Pointer;
  Objeto      : Pointer;
  RawData     : Pointer;
  BC          : PBitmapCoreHeader;
  BI          : PBitmapInfoHeader;
  ResourceItem: PResourceItem;
  P           : PWChar;
  DataEntry   : PIMAGE_RESOURCE_DATA_ENTRY;
  BH          : TBitmapFileHeader;

// RT_MENU
var
  IsPopup  : Boolean;
  MenuID   : Word;
  MenuFlags: Word;
  NestLevel: Integer;
  NestStr  : String;
  S        : String;
  MenuEnd  : PChar;
  MenuText : PWChar;
  MenuData : PWord;
  Stream   : TMemoryStream;

begin
  if HighBitSet (ResourceDirectoryEntry.OffsetToData) then begin
    DumpResourceDirectory (PIMAGE_RESOURCE_DIRECTORY (StripHighBit (ResourceDirectoryEntry.OffsetToData) + ResourceBase), ResourceDirectoryEntry.Name);
    Exit;
  end;
  DataEntry:= PIMAGE_RESOURCE_DATA_ENTRY (ResourceDirectoryEntry.OffsetToData + ResourceBase);
  RawData  := Pointer (ResourceBase - ResourceRVA + DataEntry.OffsetToData);
  BI       := PBitmapInfoHeader (RawData);
  case Resource of
    RT_ICON, RT_CURSOR: begin
                          ResourceItem:= New (PResourceItem);
                          with ResourceItem^ do begin
                            Name  := ResourceName;
                            Stream:= TMemoryStream.Create;
                            Stream.Write (RawData^, DataEntry.Size);
                            Stream.Seek (0, soFromBeginning);
                          end;
                          Images.Add (ResourceItem);
                        end;
    RT_BITMAP         : begin
                          FillChar (BH, SizeOf (BH), #0);
                          BH.bfType:= $4D42;
                          BH.bfSize:= SizeOf (BH) + DataEntry.Size;
                          if BI.biSize = SizeOf (TBitmapInfoHeader) then begin
                            ClrUsed:= BI.biClrUsed;
                            if ClrUsed = 0 then
                              ClrUsed:= GetDInColors (BI.biBitCount);
                            BH.bfOffBits:= ClrUsed * SizeOf (TRGBQuad) + SizeOf (TBitmapInfoHeader) + SizeOf (BH);
                            if (BI.biCompression and BI_BITFIELDS) <> 0 then
                              Inc (BH.bfOffBits, 12);
                          end
                          else begin
                            BC          := PBitmapCoreHeader (RawData);
                            BH.bfOffBits:= GetDInColors (BC.bcBitCount) * SizeOf (TRGBTriple) + SizeOf (TBitmapCoreHeader) + SizeOf (BH);
                          end;
                          ResourceItem:= New (PResourceItem);
                          with ResourceItem^ do begin
                            Name  := ResourceName;
                            Stream:= TMemoryStream.Create;
                            Stream.Write (BH, SizeOf (BH));
                            Stream.Write (RawData^, DataEntry.Size);
                            Stream.Seek (0, soFromBeginning);
                          end;
                          Images.Add (ResourceItem);
                        end;
    RT_MENU           : with Strings do begin
                          BeginUpdate;
                          try
                            MenuData:= RawData;
                            MenuEnd := PChar (RawData) + DataEntry.Size;
                            Inc (MenuData, 2);
                            NestLevel:= 0;
                            while PChar (MenuData) < MenuEnd do begin
                              MenuFlags:= MenuData^;
                              Inc (MenuData);
                              IsPopup:= (MenuFlags and MF_POPUP) = MF_POPUP;
                              MenuID := 0;
                              if not IsPopup then begin
                                MenuID:= MenuData^;
                                Inc (MenuData);
                              end;
                              MenuText:= PWChar (MenuData);
                              Len     := lstrlenW (MenuText);
                              if Len = 0 then
                                S:= 'MENUITEM SEPARATOR'
                              else begin
                                S:= WideCharToStr (MenuText, Len);
                                if IsPopup then
                                  S:= Format ('POPUP "%s"', [S])
                                else
                                  S:= Format ('MENUITEM "%s",  %d', [S, MenuID]);
                              end;
                              Inc (MenuData, Len + 1);
                              Add (NestStr + S);
                              if (MenuFlags and MF_END) = MF_END then begin
                                NestLevel:= NestLevel - 1;
                                Add (NestStr + 'ENDPOPUP');
                              end;
                              if IsPopup then
                                NestLevel:= NestLevel + 1;
                            end;
                            Add ('');
                          finally
                            EndUpdate;
                          end;
                        end;
    RT_STRING         : with Strings do begin
                          BeginUpdate;
                          try
                            P  := RawData;
                            Cnt:= 0;
                            while Cnt < 16 {StringsPerBlock} do begin
                              Len:= Word (P^);
                              Inc (P);
                              if Len > 0 then begin
                                Add (Format ('"%s"', [WideCharToStr (P, Len)]));
                                Inc (P, Len);
                              end;
                              Inc (Cnt);
                            end;
                            Add ('');
                          finally
                            EndUpdate;
                          end;
                        end;
  end;
end;

end.
