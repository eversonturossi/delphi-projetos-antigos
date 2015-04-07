// Wheberson Hudson Migueletti, em Brasília, 12 de abril de 2000.
// Internet              : http://www.geocities.com/whebersite
// E-mail                : whebersite@zipmail.com.br
// Referências (Internet): http://www.wotsit.org            ---> Wotsit's Format
//                         http://www.e-bachmann.dk         ---> Erik Bachmann

unit DelphiDBF;

interface

uses
  Windows, SysUtils, Classes;

const
   cNTXMaxKey = 256;
   cNTXBufSize= 1024;

type
  TFieldName= array[0..10] of Char;

  // dBase II
  PdBaseIIStructure= ^TdBaseIIStructure;
  TdBaseIIStructure= packed record
    FieldName            : TFieldName;
    DataType             : Char; // 'C' - Char;  'L' - Logical; 'N' - Numerical
    FieldSize            : Byte;
    FieldDataAddress     : Word;
    NumberOfdecimalPlaces: Byte;
  end;
  PdBaseIIHeader= ^TdBaseIIHeader;
  TdBaseIIHeader= packed record
    NumberOfDataRecords: Word;
    Month              : Byte;
    Day                : Byte;
    Year               : Byte;
    SizeOfDataRecord   : Word;
  end;

  // dBase III
  PdBaseStructure= ^TdBaseIIIStructure;
  TdBaseIIIStructure= packed record
    FieldName            : TFieldName;
    DataType             : Char; // 'C' - Char; 'D' - Date; 'L' - Logical; 'M' - Memo; 'N' - Numerical
    FieldDataAddress     : DWORD;
    FieldSize            : Byte;
    NumberOfdecimalPlaces: Byte;
    Reserved             : array[0..13] of Byte;
  end;
  PdBaseIIIHeader= ^TdBaseIIIHeader;
  TdBaseIIIHeader= packed record
    Year                 : Byte;
    Month                : Byte;
    Day                  : Byte;
    NumberOfDataRecords  : DWORD;
    HeaderSize           : Word;
    DataRecordSize       : Word;
    Reserved1            : Word;
    IncompleteTransaction: Byte;
    EncryptionFlag       : Byte;
    FreeRecordThread     : DWORD;
    Reserved2            : array[0..7] of Byte;//array[0..11] of Byte;
    MDXFlag              : Byte;
    LanguageDriver       : Byte;
    Reserved3            : Word;
  end;

  PNTXHeader= ^TNTXHeader;
  TNTXHeader= packed record
    Signature: Word;
    Version  : Word;
    Root     : Integer;
    NextPage : Integer;
    ItemSize : Word;
    KeySize  : Word;
    KeyDec   : Word;
    MaxItem  : Word;
    HalfPage : Word;
    KeyExpr  : array[0..cNTXMaxKey] of Char;
    Unique   : Char;
  end;

  PNTXItem= ^TNTXItem;
  TNTXItem= packed record
    Page : Integer;
    RecNo: Integer;
    Key  : array[0..0] of Char;
  end;

  PNTXBuffer= ^TNTXBuffer;
  TNTXBuffer= packed record
    ItemCount : Word;
    ItemOffset: array[0..0] of Word;
  end;

  TNTX= class
    protected
      Header: TNTXHeader;
      Stream: TStream;
    public
      constructor Create;
      destructor  Destroy; override;
      procedure   AssignTo (Dest: TStream);
      procedure   LoadFromFile (const FileName: String);
  end;

  TDBF= class 
    protected
      FirstRecord: DWORD;
      RecordSize : Integer;
      Stream     : TStream;

      procedure Clear;
      function  DumpHeader: Boolean;
    public
      RecordCount: Integer;
      Fields     : TList;

      constructor Create;
      destructor  Destroy; override;
      procedure   LoadRecord (Index: Integer; var Rec: TStringList);
      procedure   LoadFromFile (const FileName: String);
  end;

implementation





function ConvertToDate (Value: String): String;

begin
  Result:= Copy (Value, 7, 2) + DateSeparator + Copy (Value, 5, 2) + DateSeparator + Copy (Value, 1, 4);
  if ShortDateFormat <> '' then
    if UpCase (ShortDateFormat[1]) = 'M' then
      Result:= Copy (Value, 5, 2) + DateSeparator + Copy (Value, 7, 2) + DateSeparator + Copy (Value, 1, 4)
    else if UpCase (ShortDateFormat[1]) = 'Y' then
      Result:= Copy (Value, 1, 4) + DateSeparator + Copy (Value, 5, 2) + DateSeparator + Copy (Value, 7, 2);
end;





constructor TNTX.Create;

begin
  inherited Create;

  Stream:= TMemoryStream.Create;
end;





destructor TNTX.Destroy;

begin
  Stream.Free;

  inherited Destroy;
end;





procedure TNTX.AssignTo (Dest: TStream);

 procedure DumpPage (PageOffset: Integer);
 var
   I     : Integer;
   Page  : Pointer;
   Buffer: PNTXBuffer;
   Item  : PNTXItem;

 begin
   GetMem (Page, cNTXBufSize);
   try
     Buffer:= PNTXBuffer (Page);
     Stream.Seek (PageOffset, soFromBeginning);
     Stream.Read (Buffer^, cNTXBufSize);

     for I:= 0 to Buffer.ItemCount-1 do begin
       Item:= PNTXItem (PChar (Page) + Buffer.ItemOffset[I]);
       if Item.Page <> 0 then
         DumpPage (Item.Page);
       Dest.Write (Item.RecNo, 4);
     end;

     Item:= PNTXItem (PChar (Page) + Buffer.ItemOffset[Buffer.ItemCount]);
     if Item.Page <> 0 then
       DumpPage (Item.Page);
   finally
     FreeMem (Page);
   end;
 end;

begin
  if Stream.Size > 0 then begin
    if Dest is TMemoryStream then
      TMemoryStream (Dest).Clear;
    DumpPage (Header.Root);
  end;  
end;





procedure TNTX.LoadFromFile (const FileName: String);

begin
  if FileExists (FileName) then begin
    TMemoryStream (Stream).Clear;
    TMemoryStream (Stream).LoadFromFile (FileName);
    Stream.Seek (0, soFromBeginning);
    Stream.Read (Header, SizeOf (TNTXHeader));
  end;  
end;




//------------------------------------------------------------------------------
constructor TDBF.Create;

begin
  inherited Create;

  Stream     := TMemoryStream.Create;
  Fields     := TList.Create;
  RecordCount:= 0;
  FirstRecord:= 0;
  RecordSize := 0;
end;





destructor TDBF.Destroy;

begin
  Stream.Free;
  Fields.Free;

  inherited Destroy;
end;





function TDBF.DumpHeader: Boolean;
var
  Version    : Byte;
  Structure  : PdBaseStructure;
  StructureII: PdBaseIIStructure;
  HeaderII   : TdBaseIIHeader;
  HeaderIII  : TdBaseIIIHeader;

begin
  Stream.Seek (0, soFromBeginning);
  Result:= Stream.Read (Version, 1) = 1;
  if Result then begin
    if Version = 2 then begin
      Stream.Read (HeaderII, SizeOf (TdBaseIIHeader));
      RecordCount:= HeaderII.NumberOfDataRecords;
      RecordSize := HeaderII.SizeOfDataRecord;
      while Stream.Position < Stream.Size do begin
        Structure  := New (PdBaseStructure);
        StructureII:= New (PdBaseIIStructure);
        FirstRecord:= Stream.Position;
        Stream.Read (StructureII^, SizeOf (TdBaseIIStructure));
        if PdBaseIIStructure (StructureII).FieldName[0] = #13 then begin
          Inc (FirstRecord);
          Break;
        end;
        with PdBaseIIStructure (StructureII)^ do begin
          Structure.FieldName            := FieldName;
          Structure.DataType             := DataType;
          Structure.FieldDataAddress     := FieldDataAddress;
          Structure.FieldSize            := FieldSize;
          Structure.NumberOfdecimalPlaces:= NumberOfdecimalPlaces;
        end;
        Fields.Add (Structure);
        Dispose (StructureII);
      end;
    end
    else begin
      Stream.Read (HeaderIII, SizeOf (TdBaseIIIHeader));
      RecordCount:= HeaderIII.NumberOfDataRecords;
      RecordSize := HeaderIII.DataRecordSize;
      FirstRecord:= HeaderIII.HeaderSize;
      while Stream.Position < Stream.Size do begin
        Structure:= New (PdBaseStructure);
        Stream.Read (Structure^, SizeOf (TdBaseIIIStructure));
        if PdBaseStructure (Structure).FieldName[0] = #13 then
          Break;
        Fields.Add (Structure);
      end;
    end;
  end;
end;





procedure TDBF.LoadRecord (Index: Integer; var Rec: TStringList);
var
  Flag  : Byte;
  I     : Integer;
  Offset: DWORD;
  Value : String;

begin
  Offset:= FirstRecord + Index*RecordSize;
  if (Offset < Stream.Size ) and (Index >= 0) {and (Index < RecordCount)} then begin
    Stream.Seek (Offset, soFromBeginning);
    Stream.Read (Flag, 1);
    if Flag <> $2A then
      for I:= 0 to Fields.Count-1 do begin
        with PdBaseStructure (Fields.Items[I])^ do begin
          SetLength (Value, FieldSize);
          Stream.Read (Value[1], FieldSize);
          if DataType = 'D' then
            Value:= ConvertToDate (Value);
        end;
        Rec.Add (Value);
      end;
  end;
end;





procedure TDBF.Clear;
var
  I: Integer;

begin
  for I:= 0 to Fields.Count-1 do
    Dispose (PdBaseStructure (Fields.Items[I]));
  Fields.Clear;
end;





procedure TDBF.LoadFromFile (const FileName: String);

begin
  TMemoryStream (Stream).LoadFromFile (FileName);
  Clear;
  DumpHeader;
end;

end.
