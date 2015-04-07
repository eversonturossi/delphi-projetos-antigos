{ Wheberson Hudson Migueletti, em Brasília, 12 de abril de 2000.
  Internet   : http://www.geocities.com/whebersite
  E-mail     : whebersite@zipmail.com.br
  Referências: http://www.wotsit.org                         ---> Wotsit's Format
               http://www.wotsit.org/download.asp?f=paradox4 ---> Kevin Mitchell
               http://ourworld.compuserve.com/homepages/bex  ---> Randy Beck } 

unit DelphiDB;

interface

uses
  Windows, SysUtils, Classes, Dialogs;

const
  cpxAlpha      = $01;
  cpxDate       = $02;
  cpxShort      = $03;
  cpxLong       = $04;
  cpxCurrency   = $05;
  cpxNumber     = $06;
  cpxLogical    = $09;
  cpxMemoBLOb   = $0C;
  cpxBLOb       = $0D;
  cpxFmtMemoBLOb= $0E;
  cpxOLE        = $0F;
  cpxGraphic    = $10;
  cpxTime       = $14;
  cpxTimeStamp  = $15;
  cpxAutoInc    = $16;
  cpxBCD        = $17;
  cpxBytes      = $18;


type
  EUnsupportedDBFile= class (Exception);

  PDBStructure= ^TDBStructure;
  TDBStructure= record
    FieldName: String;
    FieldType: Byte;
    FieldSize: Byte;
  end;

  PDBFldInfoRec= ^TDBFldInfoRec;
  TDBFldInfoRec= packed record
    FieldType: Byte;
    FieldSize: Byte;
  end;

  PDBHeaderBlock= ^TDBHeaderBlock;
  TDBHeaderBlock= packed record
    Next              : Word;
    Previous          : Word;
    OffsetOfLastRecord: SmallInt;
  end;

  // Baseado na estrutura de "Randy Beck (in PXFMT.pas)"
  PDBDataBlock= ^TDBDataBlock;
  TDBDataBlock= packed record
    Header  : TDBHeaderBlock;
    FileData: array[0..$0FF9] of Byte;
  end;

  // Baseado na estrutura de "Randy Beck (in PXFMT.pas)" e de "Kevin Mitchell"
  PDBCommomHeader= ^TDBCommomHeader;
  TDBCommomHeader= packed record
    RecordSize           : Word;
    HeaderSize           : Word;
    FileType             : Byte;
    BlockSize            : Byte;
    NumberOfRecords      : DWORD;
    NumberOfBlocks       : Word;
    TotalBlocks          : Word;
    FirstBlock           : Word;
    LastBlock            : Word;
    Unknown12To13        : Word;
    ModifiedFlags1       : Byte;
    IndexFieldNumber	 : Byte;
    PrimaryIndexWorkspace: Pointer;
    UnknownPtr1A         : Pointer;
    Unknown1Ex20         : array[$001E..$0020] of Byte;
    NumberOfFields       : Word;
    NumberOfKeyFields    : Word;
    Encryption1          : Integer;
    SortOrder            : Byte;
    ModifiedFlags2       : Byte;
    Unknown2Bx2C         : array[$002B..$002C] of Byte;
    ChangeCount1         : Byte;
    ChangeCount2         : Byte;
    Unknown2F            : Byte;
    TableNamePtrPtr      : ^PChar;
    FldInfoPtr           : PDBFldInfoRec;
    WriteProtected       : Byte;
    FileVersionID        : Byte; // $03=V3.0; $04=V3.5; $05..$09=V4.x; $0A, $0B=V5.x; $0C=V7.x
    MaxBlocks            : Word;
    Unknown3C            : Byte;
    AuxPasswords         : Byte;
    Unknown3Ex3F         : array[$003E..$003F] of Byte;
    CryptInfoStartPtr    : Pointer;
    CryptInfoEndPtr      : Pointer;
    Unknown48            : Byte;
    AutoIncVal           : Integer;
    Unknown4Dx4E         : array[$004D..$004E] of Byte;
    IndexUpdateRequired  : Byte;
    Unknown50x54         : array[$0050..$0054] of byte;
    RefIntegrity         : Byte;
    Unknown56x57         : array[$0056..$0057] of Byte;
  end;

  // Baseado na estrutura de "Randy Beck (in PXFMT.pas)"
  PDBPartialHeader4= ^TDBPartialHeader4;
  TDBPartialHeader4= packed record
    FileVerID2        : Word;
    FileVerID3        : Word;
    Encryption2       : Integer;
    FileUpdateTime    : Integer;
    HiFieldID         : Word;
    HiFieldIDinfo     : Word;
    SometimesNumFields: Word;
    DosCodePage       : Word;
    Unknown6Cx6F      : array[$006C..$006F] of Byte;
    ChangeCount4      : Word;
    Unknown72x77      : array[$0072..$0077] of Byte;
  end;

  TDB= class
    protected
      ActiveBlock: Integer;
      BlockCount : Integer;
      BlockSize  : Integer;
      HeaderSize : Integer;
      RecordSize : Integer;
      Block      : PDBDataBlock;
      Blocks     : TMemoryStream; 
      Stream     : TStream;

      procedure Clear;
      function  DumpHeader: Boolean;
      function  DumpBlocks: Boolean;
      function  FindBlock (Index: Integer; var MinIndex: Integer): Integer;
    public
      RecordCount: Integer;
      Fields     : TList;

      constructor Create;
      destructor  Destroy; override;
      procedure   LoadRecord (Index: Integer; Rec: TStringList);
      procedure   LoadFromFile (const FileName: String);
  end;

implementation

type
  PDBInfoBlock= ^TDBInfoBlock;
  TDBInfoBlock= record
    Block   : Integer;
    MaxIndex: Integer;
  end;





constructor TDB.Create;

begin
  inherited Create;

  Blocks     := TMemoryStream.Create;
  Stream     := TMemoryStream.Create;
  Fields     := TList.Create;
  BlockCount := 0;
  RecordCount:= 0;
  RecordSize := 0;
  ActiveBlock:= -1;
  New (Block);
end;





destructor TDB.Destroy;

begin
  Blocks.Free;
  Stream.Free;
  Fields.Free;
  Dispose (Block);

  inherited Destroy;
end;





function TDB.DumpHeader: Boolean;
var
  C            : Char;
  I            : Integer;
  Header       : PDBCommomHeader;
  Structure    : PDBStructure;
  PartialHeader: TDBPartialHeader4;
  FieldInfo    : TDBFldInfoRec;

begin
  Result:= True;
  try
    New (Header);
    try
      // Obtendo o "Header"
      Stream.Seek (0, soFromBeginning);
      Stream.Read (Header^, SizeOf (TDBCommomHeader));
      RecordCount:= Header.NumberOfRecords;
      BlockCount := Header.NumberOfBlocks;
      BlockSize  := Header.BlockSize;
      BlockSize  := BlockSize*$0400;
      HeaderSize := Header.HeaderSize;
      RecordSize := Header.RecordSize;
      if Header.FileVersionID > $04 then
        Stream.Read (PartialHeader, SizeOf (TDBPartialHeader4));

      // Obtendo o tamanho/tipo dos campos da tabela
      Clear;
      for I:= 1 to Header.NumberOfFields do begin
        Stream.Read (FieldInfo, SizeOf (TDBFldInfoRec));
        Structure:= New (PDBStructure);
        with Structure^ do begin
          FieldType:= FieldInfo.FieldType;
          FieldSize:= FieldInfo.FieldSize;
        end;
        Fields.Add (Structure);
      end;

      // Obtendo os nomes dos campos da tabela
      Stream.Seek (120 + 83 + 6*Header.NumberOfFields, soFromBeginning); // Kevin Mitchell
      for I:= 1 to Header.NumberOfFields do
        with PDBStructure (Fields.Items[I-1])^ do begin
          FieldName:= '';
          while Stream.Position < Stream.Size do begin
            Stream.Read (C, 1);
            if C = #0 then
              Break;
            FieldName:= Concat (FieldName, C);
          end;
        end;
    finally
      Dispose (Header);
    end;
  except
    Result:= False;
  end;
end;

// Rotina para gerar uma lista contendo a dupla: (Índice Físico do Bloco, Índice Máximo do Registro)
// Fisicamente, os blocos NÃO estão armazenados sequencialmente/ascendentemente,
// e SIM através de uma LISTA ENCADEADA (Linked List), onde o índice do primeiro bloco é 1, e o seu "PreviousBlock" é 0.
function TDB.DumpBlocks: Boolean;
var
  I          : Integer;
  Next       : Integer;
  HeaderBlock: TDBHeaderBlock;
  Info       : TDBInfoBlock;

 procedure SeekBlock (BlockIndex: Integer);

 begin
   // "BlockIndex" in [1.."BlockCount"]
   Stream.Seek ((BlockIndex-1)*BlockSize + HeaderSize, soFromBeginning);
   Stream.Read (HeaderBlock, SizeOf (TDBHeaderBlock));
 end;

begin
  Result       := True;
  Info.MaxIndex:= 0;
  Next         := 1;
  try
    Blocks.Clear;
    for I:= 1 to BlockCount do begin
      SeekBlock (Next);
      Info.Block:= Next;
      Inc (Info.MaxIndex, (HeaderBlock.OffsetOfLastRecord div RecordSize) + 1);
      Blocks.Write (Info, SizeOf (TDBInfoBlock));
      Next:= HeaderBlock.Next;
    end;
  except
    Result:= False;
  end;
end;





function TDB.FindBlock (Index: Integer; var MinIndex: Integer): Integer;
var
  Info: TDBInfoBlock;

begin
  MinIndex:= 0;
  Blocks.Seek (0, soFromBeginning);
  while Blocks.Position < Blocks.Size do begin
    Blocks.Read (Info, SizeOf (TDBInfoBlock));
    Result:= Info.Block;
    if Index < Info.MaxIndex then
      Exit;
    MinIndex:= Info.MaxIndex;
  end;
end;





procedure TDB.LoadRecord (Index: Integer; Rec: TStringList);
const
  cSizeOfBlockHeader= 6; // NextBlock, BlockNumber e AddDataSize

var
  I, J          : Integer;
  MinIndex      : Integer;
  Offset        : DWORD;
  CurrentBlock  : Integer;
  Value         : String;

var
  Value_Logical : Boolean;
  Value_Short   : SmallInt;
  Value_Long    : Integer;
  Value_Number  : Double;
  Value_Currency: Currency;
  Buffer        : array[0..16] of Byte;

 // Falha para números ("Currency/Number") negativos
 procedure ConvertNumericField (FieldSize: Byte);
 var
   I: Byte;

 begin
   // Randy Beck
   Block.FileData[Offset]:= Block.FileData[Offset] xor $80;
   for I:= 0 to FieldSize-1 do
     Buffer[FieldSize-I-1]:= Block.FileData[Offset+I];
 end;

begin
  try
    if (Index >= 0) and (Index < RecordCount) then begin
      CurrentBlock:= FindBlock (Index, MinIndex);
      if CurrentBlock <> ActiveBlock then begin
        Offset:= (CurrentBlock-1)*BlockSize + HeaderSize; // "CurrentBlock" in [1.."BlockCount"]
        if Offset >= Stream.Size then
          Exit;
        Stream.Seek (Offset, soFromBeginning);
        Stream.Read (Block^, BlockSize);
        ActiveBlock:= CurrentBlock;
      end;
      Offset:= (Index-MinIndex)*RecordSize;
      for I:= 0 to Fields.Count-1 do begin
        Value:= '';
        with PDBStructure (Fields.Items[I])^ do begin
          try
            case FieldType of
              cpxAlpha           : for J:= 0 to FieldSize-1 do
                                     if Block.FileData[Offset+J] = 0 then
                                       Break
                                     else
                                       Value:= Concat (Value, Chr (Block.FileData[Offset+J]));
              cpxCurrency        : begin
                                     ConvertNumericField (FieldSize);
                                     Move (Buffer[0], Value_Number, FieldSize);
                                     if Value_Number >= 0 then
                                       Value:= Format ('%m', [Value_Number]);
                                   end;
              cpxNumber          : begin
                                     ConvertNumericField (FieldSize);
                                     Move (Buffer[0], Value_Number, FieldSize);
                                     if Value_Number >= 0 then
                                       Value:= Format ('%n', [Value_Number]);
                                   end;
              cpxShort           : begin
                                     ConvertNumericField (FieldSize);
                                     Move (Buffer[0], Value_Short, FieldSize);
                                     Value:= Format ('%d', [Value_Short]);
                                   end;
              cpxLong, cpxAutoInc: begin
                                     ConvertNumericField (FieldSize);
                                     Move (Buffer[0], Value_Long, FieldSize);
                                     Value:= Format ('%d', [Value_Long]);
                                   end;
              cpxTimeStamp       : begin
                                     ConvertNumericField (FieldSize);
                                     Move (Buffer[0], Value_Number, FieldSize);
                                     Value:= Format ('%0.0f', [Value_Number]);
                                   end;
              cpxTime, cpxDate   : begin
                                     ConvertNumericField (FieldSize);
                                     Move (Buffer[0], Value_Long, FieldSize);
                                     Value:= Format ('%d', [Value_Long]);
                                   end;
              cpxLogical         : begin
                                     ConvertNumericField (FieldSize);
                                     Move (Buffer[0], Value_Logical, FieldSize);
                                     if Value_Logical then
                                       Value:= 'T'
                                     else
                                       Value:= 'F';
                                   end;
            end;
          except
          end;
          Inc (Offset, FieldSize);
        end;
        Rec.Add (Value);
      end;
    end;
  except
  end;
end;





procedure TDB.Clear;
var
  I: Integer;

begin
  for I:= 0 to Fields.Count-1 do
    Dispose (PDBStructure (Fields.Items[I]));
  Fields.Clear;
end;





procedure TDB.LoadFromFile (const FileName: String);

begin
  Clear;
  TMemoryStream (Stream).Clear;
  TMemoryStream (Stream).LoadFromFile (FileName);
  if not (DumpHeader and DumpBlocks) then
    raise EUnsupportedDBFile.Create ('Unsupported DB File !');
end;

end.
