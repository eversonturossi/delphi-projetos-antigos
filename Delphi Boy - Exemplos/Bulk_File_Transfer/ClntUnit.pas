unit ClntUnit;

interface

uses
 Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
 Common,
 ScktComp, Buttons, StdCtrls, ComCtrls, ExtCtrls;

const
 Version = ' 2.1';
type
 TReceiveMode = (rmWAIT_HEADER, rmRECEIVING_FILE, rmRECEIVING_LIST);
 
 TForm1 = class(TForm)
  edtServer: TEdit;
  btnConnect: TSpeedButton;
  ClSock: TClientSocket;
  Memo1: TMemo;
  lbFiles: TListBox;
  StaticText1: TStaticText;
  PBar: TProgressBar;
  Timer1: TTimer;
  lbFetch: TListBox;
  StaticText3: TStaticText;
  btnFetch: TSpeedButton;
  btnDisconnect: TSpeedButton;
  procedure btnConnectClick(Sender: TObject);
  procedure ClSockConnect(Sender: TObject; Socket: TCustomWinSocket);
  procedure ClSockDisconnect(Sender: TObject; Socket: TCustomWinSocket);
  procedure ClSockError(Sender: TObject; Socket: TCustomWinSocket;
   ErrorEvent: TErrorEvent; var ErrorCode: Integer);
  procedure ClSockRead(Sender: TObject; Socket: TCustomWinSocket);
  procedure lbFilesClick(Sender: TObject);
  procedure Timer1Timer(Sender: TObject);
  procedure FormCreate(Sender: TObject);
  procedure lbFetchClick(Sender: TObject);
  procedure btnFetchClick(Sender: TObject);
  procedure btnDisconnectClick(Sender: TObject);
 private
  { Private declarations }
  RMode: TReceiveMode;
  FRequestedFile: string;
  DataLen: integer;
  KbReceived: integer;
  Fs: TFileStream;
  Header: TMsgHeader;
  TotalBytes: integer;
  TotalSecs: integer;
  procedure ProcessHeader(Data: string);
  procedure ProcessFile(Data: string);
  procedure ProcessList(Data: string);
  procedure BailOut;
  procedure FetchNext;
 public
  { Public declarations }
 end;
 
var
 Form1: TForm1;
 
implementation

{$R *.DFM}

//*****************************************************************************

procedure TForm1.FormCreate(Sender: TObject);
begin
 Caption := Caption + Version;
 RMode := rmWAIT_HEADER;
end;

//*****************************************************************************

procedure TForm1.btnConnectClick(Sender: TObject);
var
 OldMode: DWORD;
begin
 OldMode := SetErrorMode(SEM_FAILCRITICALERRORS);
 with ClSock do
  try
   Host := edtServer.Text;
   Port := Common.ServerPort;
   Open;
   edtServer.Color := clGREEN;
  except
   Log(memo1.lines, 'connect error, check hostname/address');
  end;
 SetErrorMode(OldMode);
end;

//*****************************************************************************

procedure TForm1.ClSockConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
 Log(memo1.Lines, 'connected, requesting file list...');
 SendData(ClSock.Socket, MSG_REQUEST_LIST, '');
end;

//*****************************************************************************

procedure TForm1.ClSockDisconnect(Sender: TObject;
 Socket: TCustomWinSocket);
begin
 Log(memo1.Lines, 'disconnected from server');
 lbFiles.Clear;
 lbFetch.Clear;
 edtServer.Color := clRED;
 BailOut;
end;

//*****************************************************************************

procedure TForm1.ClSockError(Sender: TObject; Socket: TCustomWinSocket;
 ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
 Log(memo1.Lines, 'SOCKET ERROR ' + IntToStr(ErrorCode));
 ErrorCode := 0;
 BailOut;
end;

//*****************************************************************************

procedure TForm1.BailOut;
begin
 ClSock.Close;
 case RMode of
  rmRECEIVING_LIST: lbFiles.Clear;
  rmRECEIVING_FILE: begin
    Fs.Free;
    DeleteFile(PChar(FRequestedFile));
   end;
 end;
end;

//*****************************************************************************

procedure TForm1.ProcessHeader(Data: string);
begin
 Move(Data[1], Header, SizeOf(Header));
 // delete header
 Delete(Data, 1, SizeOf(Header));
 // remember number of bytes
 DataLen := Header.PayLoadLen;
 // init. progressbar
 PBar.Max := DataLen;
 PBar.StepBy(length(Data));
 KbReceived := 0;
 case Header.OpCode of
  MSG_FILE_FOLLOWS:
   begin
    RMode := rmRECEIVING_FILE;

    try
     Fs := TFileStream.Create(FRequestedFile,
      fmCREATE or fmOPENWRITE);
     Log(memo1.lines, 'receiving file, '
      + IntToStr(DataLen) + ' bytes...');
     inc(TotalBytes, DataLen);
     ProcessFile(Data);
    except
     Log(memo1.lines, 'error writing file: '
      + SysErrorMessage(GetLastError));
    end;
   end;
  MSG_LIST_FOLLOWS:
   begin
    RMode := rmRECEIVING_LIST;
    lbFiles.Clear;
    ProcessList(Data);
   end

  else begin
    Log(memo1.lines, 'server reports error!');
    BailOut;
   end;
 end;
 
end;

//*****************************************************************************

procedure TForm1.ProcessFile(Data: string);
begin
 try
  if Length(Data) = 0 then EXIT;
  inc(KbReceived, Length(Data));
  PBar.StepBy(length(Data));
  Fs.Write(Data[1], Length(Data));
  Dec(DataLen, Length(Data));

  //Log(memo1.lines,'received:' + Inttostr(length(Data)) +', left:'+ IntToStr(DataLen));
  if DataLen = 0 then
   begin
    RMode := rmWAIT_HEADER;
    Fs.Free;
    lbFiles.Enabled := true;
    PBar.Position := 0;
    FetchNext;
   end;
  Data := '';
 except
  Log(memo1.lines, 'error writing file: '
   + SysErrorMessage(GetLastError));
 end;
end;

//*****************************************************************************

procedure TForm1.ProcessList(Data: string);
begin
 lbFiles.Items.Text := lbFiles.Items.Text + Data;
 dec(DataLen, Length(Data));
 Data := '';
 if DataLen = 0 then
  begin
   Log(Memo1.Lines, ' filelist received, '
    + IntToStr(lbFiles.Items.Count)
    + ' items');
   RMode := rmWAIT_HEADER;
   lbFiles.Enabled := true;
   PBar.Position := 0;
  end;
end;

//*****************************************************************************

procedure TForm1.ClSockRead(Sender: TObject; Socket: TCustomWinSocket);
var
 Buf: string;
 MsgLen,
  LenReceived: integer;
begin
 
 // get the *approximate* message length
 MsgLen := Socket.ReceiveLength;
 
 while MsgLen > 0 do
  begin
   // prepare a buffer and get message
   SetLength(Buf, MsgLen);
   LenReceived := Socket.ReceiveBuf(Buf[1], MsgLen);
   // **always** adjust for actual received # of bytes!
   Buf := Copy(Buf, 1, LenReceived);
   case RMode of
    rmWAIT_HEADER: ProcessHeader(Buf);
    rmRECEIVING_FILE: ProcessFile(Buf);
    rmRECEIVING_LIST: ProcessList(Buf);
   end;
   MsgLen := Socket.ReceiveLength;
  end;
 
end;

//*****************************************************************************

procedure TForm1.lbFilesClick(Sender: TObject);
begin
 if lbFetch.Items.IndexOf(lbFiles.Items[lbFiles.ItemIndex]) = -1 then
  lbFetch.Items.Add(lbFiles.Items[lbFiles.ItemIndex]);
 
end;

//*****************************************************************************

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 inc(TotalSecs);
end;

procedure TForm1.lbFetchClick(Sender: TObject);
begin
 lbFetch.Items.Delete(lbFetch.ItemIndex);
end;

//*****************************************************************************

procedure TForm1.FetchNext;
begin
 if lbFetch.Items.Count > 0 then
  begin
   FRequestedfile := lbFetch.Items[0];
   lbFetch.Items.Delete(0);
   Log(memo1.Lines, 'requesting file ' + FRequestedFile + ' ...');
   SendData(ClSock.Socket, MSG_REQUEST_FILE, FRequestedFile);
  end
 else begin
   Timer1.Enabled := false;
   if TotalSecs > 0 then
    Log(memo1.Lines, 'All done, average: ' + Format('%0.2f Kb/sec', [(
      TotalBytes / TotalSecs) / 1024]));
   ClSock.Close;
   lbFiles.Enabled := true;
   lbFetch.Enabled := true;
   btnFetch.Enabled := true;
   btnDisconnect.Enabled := true;
  end;
end;

//*****************************************************************************

procedure TForm1.btnFetchClick(Sender: TObject);
begin
 if (lbFetch.Items.Count = 0)
  or not ClSock.Socket.Connected then EXIT;
 btnDisconnect.Enabled := false;
 btnFetch.Enabled := false;
 lbFiles.Enabled := false;
 lbFetch.Enabled := false;
 TotalBytes := 0;
 TotalSecs := 0;
 Timer1.Enabled := true;
 FetchNext;
end;

procedure TForm1.btnDisconnectClick(Sender: TObject);
begin
 BailOut;
end;

end.

