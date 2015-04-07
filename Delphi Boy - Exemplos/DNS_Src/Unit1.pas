unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Winsock;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    GroupBox2: TGroupBox;
    Edit2: TEdit;
    Button1: TButton;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    Button2: TButton;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Function GetHostName(strIPAddress : String) : String;
Var
  strHost : String ;
  pszIPAddress : PChar ;
  pReturnedHostEnt : PHostEnt ;
  InternetAddr : u_long ;
  GInitData : TWSADATA ;
Begin
 strHost := '';
 If WSAStartup($101, GInitData) = 0 then
 Begin
    pszIPAddress := StrAlloc( Length( strIPAddress ) + 1 ) ;
    StrPCopy( pszIPAddress, strIPAddress ) ;
    InternetAddr := Inet_Addr(pszIPAddress) ;
    StrDispose( pszIPAddress ) ;
    pReturnedHostEnt := GetHostByAddr( PChar(@InternetAddr),4, PF_INET );
   try
    strHost := pReturnedHostEnt^.h_name;
    WSACleanup;
    Result := strHost ;
   except
    Result := 'Host inválido ou não encontrado';
   end;
 end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Memo1.Lines.Add('IP: '+ Edit2.Text);
  Memo1.Lines.Add('Host: '+ GetHostName(Edit2.Text));
  Memo1.Lines.Add('');
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  p : PHostEnt;
  p2 : pchar;
begin
  p := GetHostByName(Pchar(Edit1.Text));
  Memo1.Lines.Add('Host: '+ Edit1.Text);
  Memo1.Lines.Add('Nome: ' + p^.h_Name);
  p2 := iNet_ntoa(PInAddr(p^.h_addr_list^)^);
  Memo1.Lines.Add('IP: ' + p2);
  Memo1.Lines.Add('');
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  wVersionRequested : WORD;
  wsaData : TWSAData;
begin
  wVersionRequested := MAKEWORD(1, 1);
  WSAStartup(wVersionRequested, wsaData);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  WSACleanup;
end;

end.
