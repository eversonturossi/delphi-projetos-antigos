unit ServUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ScktComp, common, StdCtrls, FileCtrl, Buttons;
const
  Version       = ' 2.1';
type
  TForm1 = class( TForm )
    ServSock: TServerSocket;
    Memo1: TMemo;
    edtDir: TEdit;
    StaticText1: TStaticText;
    lbFiles: TListBox;
    StaticText2: TStaticText;
    sbSetDir: TSpeedButton;
    procedure ServSockClientConnect( Sender: TObject;
      Socket: TCustomWinSocket );
    procedure ServSockClientDisconnect( Sender: TObject;
      Socket: TCustomWinSocket );
    procedure ServSockClientError( Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer );
    procedure ServSockClientRead( Sender: TObject;
      Socket: TCustomWinSocket );
    procedure sbSetDirClick( Sender: TObject );
    procedure ServSockListen( Sender: TObject; Socket: TCustomWinSocket );
    procedure FormCreate( Sender: TObject );
  private
    { Private declarations }
    FServerDir: string;
  public
    { Public declarations }
  end;

var
  Form1         : TForm1;

implementation

{$R *.DFM}

//*****************************************************************************
procedure TForm1.FormCreate( Sender: TObject );
begin
  Caption := Caption + Version;
  // set default directory;
  FServerDir := ExtractFileDir( Application.ExeName );
  EdtDir.Text := FServerDir;
  EnumFiles( FServerDir + '\*.*', lbFiles.Items, false );
  ServSock.Open;
end;

//*****************************************************************************
procedure TForm1.ServSockListen( Sender: TObject; Socket: TCustomWinSocket );
begin
  Log( Memo1.Lines, ' server listening on port ' + IntTostr( ServSock.Port ) +
    '...' );
end;

//*****************************************************************************
procedure TForm1.ServSockClientConnect( Sender: TObject;
  Socket: TCustomWinSocket );
begin
  Log( memo1.lines, 'client connect : ' + Socket.RemoteHost );
end;

//*****************************************************************************
procedure TForm1.ServSockClientDisconnect( Sender: TObject;
  Socket: TCustomWinSocket );
begin
  Log( memo1.lines, 'client disconnect : ' + Socket.RemoteHost );
end;

//*****************************************************************************
procedure TForm1.ServSockClientError( Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer );
begin
  Log( memo1.lines, 'socketerror ' + IntToStr( ErrorCode ) );
  Socket.Close;
  ErrorCode := 0; // avoid exceptions !
end;

//*****************************************************************************
procedure TForm1.ServSockClientRead( Sender: TObject;
  Socket: TCustomWinSocket );
var
  Buf           : string;
  MsgLen,
    LenReceived : integer;
  Header        : TMsgHeader;

begin

   // get approximate message length
  MsgLen := Socket.ReceiveLength;

   // prepare a buffer and get message
  SetLength( Buf, MsgLen );
  LenReceived := Socket.ReceiveBuf( Buf[1], MsgLen );

   // **always** adjust for actually received # of bytes!
  Buf := Copy( Buf, 1, LenReceived );

  if Length( Buf ) >= SizeOf( Header ) then
  begin

     // extract header
    move( Buf[1], Header, SizeOf( Header ) );
     // delete header from message
    Delete( Buf, 1, SizeOf( Header ) );
     //
    case Header.OpCode of
      MSG_REQUEST_FILE: begin
          Log( memo1.Lines, 'sending ' + Buf
            + ' to ' + Socket.RemoteHost );
          if SendFile( Socket, Buf ) then
            Log( memo1.Lines, ' file sent.' )
          else begin
            Log( memo1.Lines, ' error while sending file.' );
            Socket.Close;
          end
        end;

      MSG_REQUEST_LIST: begin
          Log( memo1.Lines, 'sending filelist'
            + ' to ' + Socket.RemoteHost );
          SendFileList( Socket, FServerDir, '*.*' );
        end;
    else
      SendError( Socket, MSG_ERR_ILLEGAL_CODE );
    end;
  end
  else begin
    Log( memo1.lines, 'message corrupt ! closing connection' );
    Socket.Close;
  end;

end;

//*****************************************************************************
procedure TForm1.sbSetDirClick( Sender: TObject );
begin
  if SelectDirectory( FServerDir, [], 0 ) then
  begin
    edtDir.Text := FServerDir;
    EnumFiles( FServerDir + '\*.*', lbFiles.Items, false );
  end;
end;

end.
