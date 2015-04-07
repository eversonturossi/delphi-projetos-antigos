// Wheberson Hudson Migueletti, em Brasília, 18 de novembro de 2000.
// Referências: [1] BDE32.hlp
//              [2] \Delphi 3\Source\VCL\DBTables.pas

unit DelphiBDE;

interface

uses Windows, SysUtils, Classes, Bde, DB, DBCommon, DBTables;

procedure GetTableNames    (const DatabaseName, Pattern: String; Extensions, SystemTables: Boolean; List: TStrings);
function  RestructureTable (Table: TTable; FieldDefs: TFieldDefs): Boolean;

implementation




// Captura os nomes das tabelas de um "Database". O método "Session.GetTableNames" mostra a caixa de diálogo do "Login" enquanto esta rotina não 
procedure GetTableNames (const DatabaseName, Pattern: String; Extensions, SystemTables: Boolean; List: TStrings);
var
  SPattern: array[0..127] of Char;
  Flag    : Boolean;
  Cursor  : HDBICur;
  WildCard: PChar;
  Name    : String;
  Desc    : TBLBaseDesc;
  Database: TDatabase;

begin
  List.BeginUpdate;
  try
    List.Clear;
    Database:= Session.FindDatabase (DatabaseName);
    Flag    := not Assigned (Database);
    if Flag then begin
      Database               := TDatabase.Create (nil);
      Database.DatabaseName  := DatabaseName;
      Database.KeepConnection:= False;
      Database.Temporary     := True;
    end;
    try
      Database.LoginPrompt:= False;
      WildCard            := nil;
      try
        Database.Open;
        if Pattern <> '' then
          WildCard:= AnsiToNative (Database.Locale, Pattern, SPattern, SizeOf (SPattern)-1);
        Check (DbiOpenTableList (Database.Handle, False, SystemTables, WildCard, Cursor));
        try
          while DbiGetNextRecord (Cursor, dbiNOLOCK, @Desc, nil) = 0 do
            with Desc do begin
              if Extensions and (szExt[0] <> #0) then
                StrCat (StrCat (szName, '.'), szExt);
              NativeToAnsi (Database.Locale, szName, Name);
              List.Add (Name);
            end;
        finally
          DbiCloseCursor (Cursor);
        end;
      except
      end;
    finally
      if Flag then
        Database.Free;
    end;
  finally
    List.EndUpdate;
  end;
end;





function RestructureTable (Table: TTable; FieldDefs: TFieldDefs): Boolean;
var
  TableDesc: CRTblDesc;
  Locale   : TLocale;

 procedure EncodeFieldDesc (var FieldDesc: FLDDesc; N: Integer; const Name: String; DataType: TFieldType; Size, Precision: Word);

 begin
   with FieldDesc do begin
     AnsiToNative (Locale, Name, szName, SizeOf (szName) - 1);
     iFldNum := N;
     iFldType:= FldTypeMap[DataType];
     iSubType:= FldSubTypeMap[DataType];
     case DataType of
       ftString,
       ftBytes,
       ftVarBytes,
       ftBlob,
       ftMemo,
       ftGraphic,
       ftFmtMemo,
       ftParadoxOle,
       ftDBaseOle,
       ftTypedBinary: iUnits1:= Size;
       ftBCD        : begin
                        iUnits2:= Size;
                        iUnits1:= 32;
                        if Precision > 0 then
                          iUnits1:= Precision;
                      end;
     end;
   end;
 end;

 function IsDBaseTable: Boolean;

 begin
   Result:= (Table.TableType = ttDBase) or (CompareText (ExtractFileExt (Table.TableName), '.DBF') = 0);
 end;

 function GetStandardLanguageDriver: String;
 var
   DriverName: String;
   Buffer    : array[0..DBIMAXNAMELEN - 1] of Char;

 begin
   if not Table.Database.IsSQLBased then begin
     DriverName:= TableDesc.szTblType;
     if DriverName = '' then
       if IsDBaseTable then
         DriverName:= szDBASE
       else
         DriverName:= szPARADOX;
     if DbiGetLdName (PChar (DriverName), nil, Buffer) = 0 then
       Result:= Buffer;
   end
   else
     Result := '';
 end;

 function GetDriverTypeName (Buffer: PChar): PChar;
 var
   Length: Word;

 begin
   Result:= Buffer;
   Check (DbiGetProp (hDBIObj (Table.DBHandle), dbDATABASETYPE, Buffer, SizeOf (DBINAME), Length));
   if StrIComp (Buffer, szCFGDBSTANDARD) = 0 then begin
     Result:= TableDesc.szTblType;
     if Assigned (Result) then
       Result:= StrCopy (Buffer, Result);
   end;
 end;

var
  Props         : CURProps;
  DriverTypeName: DBINAME;
  SQLLName      : DBIName;
  hDb           : HDBIDb;
  I             : Integer;
  PSQLLName     : PChar;
  Ops           : PCROpType;
  Flds, HFlds   : PFLDDesc;
  NewFlds       : PFLDDesc;
  LName         : String;
  TempLocale    : TLocale;

begin
  Result:= False;
  if Table.Active = False then
    raise EDatabaseError.Create ('Table must be opened to restructure');
  if Table.Exclusive = False then
    raise EDatabaseError.Create ('Table must be opened exclusively to restructure');
  NewFlds:= AllocMem (FieldDefs.Count*SizeOf (FLDDesc));
  try
    FillChar (NewFlds^, FieldDefs.Count*SizeOf (FLDDesc), 0);
    FillChar (TableDesc, SizeOf (TableDesc), 0);
    TableDesc.pfldDesc:= AllocMem (FieldDefs.Count*SizeOf (FLDDesc));
    try
      HFlds:= AllocMem (Table.FieldDefs.Count*SizeOf (FLDDesc));
      try
        Flds:= HFlds;
        FillChar (Flds^, Table.FieldDefs.Count*SizeOf (FLDDesc), 0);
        Check (DbiSetProp (hDBIObj (Table.Handle), curxltMODE, Integer (xltNONE)));
        Check (DbiGetCursorProps (Table.Handle, Props));
        Check (DbiGetFieldDescs (Table.Handle, Flds));
        StrPCopy (TableDesc.szTblName, Props.szName);
        StrPCopy (TableDesc.szTblType, Props.szTableType);
        TempLocale:= nil;
        LName     := GetStandardLanguageDriver;
        Locale    := Table.Locale;
        if (LName <> '') and (OsLdLoadBySymbName (PChar (LName), TempLocale) = 0) then
          Locale:= TempLocale;
        try
          for I:= 0 to FieldDefs.Count-1 do
            with FieldDefs[I] do
              EncodeFieldDesc (PFieldDescList (NewFlds)^[I], I+1, Name, DataType, Size, Precision);
        finally
          if Assigned (TempLocale) then
            OsLdUnloadObj (TempLocale);
        end;
        PSQLLName:= nil;
        if Table.Database.IsSQLBased then
          if DbiGetLdNameFromDB (Table.DBHandle, nil, SQLLName) = 0 then
            PSQLLName:= SQLLName;
        Check (DbiTranslateRecordStructure (nil, FieldDefs.Count, NewFlds, GetDriverTypeName (DriverTypeName), PSQLLName, TableDesc.pfldDesc, False));
        TableDesc.pecrFldOp:= AllocMem (FieldDefs.Count*SizeOf (CROpType));
        try
          Ops:= TableDesc.pecrFldOp;
          for I:= 0 to FieldDefs.Count-1 do begin
            with PFieldDescList (TableDesc.pfldDesc)^[I] do
              if I >= Table.FieldDefs.Count then
                Ops^:= crAdd
              else begin
                if (CompareText (Flds.szName, szName) <> 0) or (Flds.iFldType <> iFldType) or (Flds.iLen <> iLen) or (Flds.iFldNum <> iFldNum) then
                  Ops^:= crMODIFY
                else
                  Ops^:= crNOOP;
                Inc (Flds);
              end;
            Inc (Ops);
          end;
          Check (DbiGetObjFromObj (hDBIObj (Table.Handle), objDATABASE, hDBIObj (hDb))); // Get the database handle from the table's cursor handle...
          TableDesc.iFldCount:= FieldDefs.Count;
          Table.Close;
          Check (DbiDoRestructure (hDb, 1, @TableDesc, nil, nil, nil, False));
          Result:= True;
        finally
          FreeMem (TableDesc.pecrFldOp);
        end;
      finally
        FreeMem (HFlds);
      end;
    finally
      FreeMem (TableDesc.pfldDesc);
    end;
  finally
    FreeMem (NewFlds);
  end;
end;

end.
