unit common;

interface
uses Windows, Classes, SysUtils, Forms, ScktComp;

const
  ServerPort    = 49999;
  MSG_REQUEST_FILE       = $00010001;
  MSG_FILE_FOLLOWS       = $00010002;
  MSG_REQUEST_LIST       = $00020001;
  MSG_LIST_FOLLOWS       = $00020002;
  MSG_ERR_DOES_NOT_EXIST = $00030001;
  MSG_ERR_NO_FILES       = $00030002;
  MSG_ERR_ILLEGAL_CODE   = $00030003;
  MSG_ERR_CANNOT_SEND    = $00030004;

type

  TMsgHeader = packed record
    OpCode    : DWORD;
    PayLoadLen: DWORD;
  end;

procedure SendData( Sock: TCustomWinSocket; Code: DWORD; PayLoad: string );

procedure Log( Destination: TStrings; Txt: string );

function SendFile( Socket: TCustomWinSocket; FName: string ): boolean;

procedure SendFileList( Socket: TCustomWinSocket; DirPath: string;
  WildCard: string );

procedure SendError( Socket: TCustomWinSocket; Error: DWORD );

procedure EnumFiles( WildCard: string;
  FileList: TStrings;
  StripExtensions: boolean );

function MessageComplete( var SockBuf: string; var Header: TMsgHeader;
  var PayLoad: string ): boolean;


implementation

//*****************************************************************************
procedure EnumFiles( WildCard: string;
  FileList: TStrings;
  StripExtensions: boolean );
var
  SRec          : TSearchRec;
  Error         : DWORD;
begin
  try
    FileList.Clear;
    Error := FindFirst( WildCard, faANYFILE, SRec );
    while Error = 0 do
    begin
      if SRec.Attr and faDIRECTORY = 0 then
        if not StripExtensions then
          FileList.Add( lowercase( SRec.Name ) )
        else
          FileList.Add( ChangeFileExt( lowercase( SRec.Name ), '' ) );
      Error := FindNext( SRec );
    end;
    Sysutils.FindClose( SRec );
  except
    messagebeep( 0 );
  end;
end;

//*****************************************************************************
procedure SendData( Sock: TCustomWinSocket; Code: DWORD; PayLoad: string );
var
  S             : TMemoryStream;
  Header        : TMsgHeader;
begin
  //   set up the header
  with Header do
  begin
    OpCode     := Code;
    PayLoadLen := Length( PayLoad );
  end;
  S := TMemoryStream.Create;
  S.Write( Header, SizeOf( Header ) );
  // in case of messages without payload...
  if Header.PayLoadLen > 0 then
    S.Write( PayLoad[1], Header.PayLoadLen );
  S.Position := 0;
  Sock.SendStream( S ); // **note** stream will be freed by socket !!
end;

//*****************************************************************************
procedure Log( Destination: TStrings; Txt: string );
begin

  if not Assigned( Destination ) then EXIT;
  if length( Destination.Text ) > 20000 then
    Destination.Clear;
  Destination.Add( TimeToStr( Now ) + ' : ' + Txt );

end;

//*****************************************************************************
function SendFile( Socket: TCustomWinSocket; FName: string ): boolean;
var
  Header        : TMsgHeader;
  Fs            : TFileStream;
  S             : TMemoryStream;
begin
  Result := false;
  if FileExists( FName ) then
  try

    // open file
    Fs := TFileStream.Create( FName, fmOPENREAD );
    Fs.Position := 0;

    // create the header
    S := TMemoryStream.Create;
    Header.OpCode := MSG_FILE_FOLLOWS;
    Header.PayLoadLen := Fs.Size;

    // first write the header
    S.Write( Header, SizeOf( Header ) );

    // then append file contents to stream
    S.CopyFrom( Fs, Fs.Size );
    S.Position := 0; // important...
    // send to socket
    Result := Socket.SendStream( S ); // **NOTE** socket will free memorystream!
    Fs.Free;
  except
    SendError( Socket, MSG_ERR_CANNOT_SEND );
  end
  else
    SendError( Socket, MSG_ERR_DOES_NOT_EXIST );
end;

//*****************************************************************************
procedure SendFileList( Socket: TCustomWinSocket;
  DirPath: string;
  WildCard: string );
var
  Buf           : TStringList;
begin
  Buf := TStringList.Create;
  if not ( DirPath[Length( DirPath )] in ['/', '\'] ) then
    DirPath := DirPath + '/';
  EnumFiles( DirPath + WildCard, Buf, false );
  SendData( Socket, MSG_LIST_FOLLOWS, Buf.Text );
  Buf.Free;
end;

//*****************************************************************************
procedure SendError( Socket: TCustomWinSocket; Error: DWORD );
begin
  SendData( Socket, Error, '' );
end;

//*****************************************************************************
function MessageComplete( var SockBuf: string;
  var Header: TMsgHeader;
  var PayLoad: string ): boolean;
begin
  Result := false;
  if Length( SockBuf ) > SizeOf( Header ) then // paranoia striking...
  begin
    Move( SockBuf[1], Header, SizeOf( Header ) );
    // do we have at least one complete message ?
    if length( SockBuf ) >= Header.PayLoadLen + SizeOf( Header ) then
    begin
      // if so, delete header
      Delete( SockBuf, 1, SizeOf( Header ) );
      // copy from buf to payload
      PayLoad := Copy( SockBuf, 1, Header.PayLoadLen );
      // just in case another message is already in the pipeline!
      Delete( SockBuf, 1, Header.PayLoadLen );
      Result := true;
    end;
  end;
end;

end.
