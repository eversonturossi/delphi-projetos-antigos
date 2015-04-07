{*******************************************************}
{   LoadkeyGen                                          }
{   Fontes por: Glauber Almeida Dantas                  }
{               glauber@delphix.com.br                  }
{               www.delphix.com.br                      }
{   Os fontes podem ser modificados livremente,         }
{   peço que qualquer fonte gerado a partir deste       }
{   seja me enviado, assim todo conhecimento pode       }
{   ser compartilhado.                                  }
{   02/2004                                             }
{*******************************************************}

unit Center;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ShellAPI;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label4: TLabel;
    Edit4: TEdit;
    Button4: TButton;
    Panel1: TPanel;
    Label5: TLabel;
    ComboBox1: TComboBox;
    Label6: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  StrCaption: String;
  Handle_Edit, Handle_Btn: HWND;
  WinStr: Array[0..1024] of Char;
  Cancelar : Boolean;

implementation

{$R *.DFM}

//Função de Callback para EnumChildWindows
function EnumChildProc(Child : HWND): Boolean; Export; {$ifdef Win32} StdCall; {$endif}
var
  TempStr : String;
begin
   //Captura nome da classe de cada objeto
   GetClassName(Child, WinStr, SizeOf(WinStr));
   TempStr := StrPas(WinStr);

   //Compara nomes das classes
   //Se for TEDIT, guarda o handle do Edit
   if UpperCase(TempStr) = 'TEDIT' then
     Handle_Edit := Child;
   //Se for TBUTTON, guarda o handle do Button
   if UpperCase(TempStr) = 'TBUTTON' then
     Handle_Btn  := Child;

   Result := True;
end;


procedure TForm1.Button1Click(Sender: TObject);
var
  H : HWND;
  X, Num, Altura, Largura: Integer;
  Lista : TStringList;
  R  : TRect;
  BPoint : TPoint;
begin
  Button1.Enabled := False;

  Panel1.Caption := 'Procurando janela/arquivo...';
  if not FileExists(ExtractFilePath(Application.ExeName)+ Edit1.Text) then
  begin
    ShowMessage('O arquivo não existe.');
    Panel1.Caption := '';
    Button1.Enabled := True;
    Exit;
  end;

  //Procura janela da aplicação pelo titulo
  H := FindWindow(nil,PChar(Edit4.Text));
  //Se não encontrar, abre aplicação
  if H = 0 then
    WinExec(PChar(ExtractFilePath(Application.ExeName)+ Edit1.Text), SW_SHOW);


  while H = 0 do
  begin
    H := FindWindow(nil, PChar(Edit4.Text));

    Application.ProcessMessages;
    //Verifica estado da variavel Cancelar
    if Cancelar then
    begin
      Cancelar := False;
      Button1.Enabled := True;
      Exit;
    end;
  end;

  //Captura posição da janela
  GetWindowRect(H, R);
  OffsetRect(R, -R.Left, -R.Top);
  Largura:= R.Right  - R.Left;{Width}
  Altura := R.Bottom - R.Top;{Height}
  //Alinha janela ao Form
  MoveWindow(H, Form1.Left, Form1.Top-Altura, Largura, Altura, True);
  //Coloca janela da outra aplicação em foco
  SetForegroundWindow(H);
  //Coloca Form1 em foco
  SetForegroundWindow(Form1.Handle);
  Panel1.Caption := 'Procurando objetos...';
  //Lista/captura handles dos objetos dentro da janela
  EnumChildWindows(H, @EnumChildProc, LongInt(Self));


  Num := StrToIntDef(Edit2.Text, 10);
  Lista := TStringList.Create;
  try
    for X := 1 to Num do
    begin
       Panel1.Caption := 'Gerando key '+ IntToStr(X);
       case ComboBox1.ItemIndex of
        0 : begin
              //Manda mensagem WM_KEYDOWN depois M_KEYUP,
              //como se fosse pressionada tecla Espaço
              SendMessage(Handle_Btn , WM_KEYDOWN, VK_SPACE , 1);
              SendMessage(Handle_Btn , WM_KEYUP, VK_SPACE, 1);
            end;
        1 :   //Comando
              SendMessage(Handle_Btn , WM_COMMAND, 0, Handle_Btn);
        2 : begin
              //Coloca janela da outra aplicação com foco
              SetForegroundWindow(H);
              //Simula pressionamento de ENTER
              keybd_event(VK_RETURN, 0, 0, 0);
           end;
        3: begin
              SetForegroundWindow(H);
              //captura posição do botão em relação a tela
              BPoint.X := 0;
              BPoint.Y := 0;
              Windows.ClientToScreen(Handle_Btn , BPoint);
              //captura dimensões do Botão
              GetWindowRect(Handle_Btn, R);
              OffsetRect(R, -R.Left, -R.Top);
              Largura:= R.Right  - R.Left;{Width}
              Altura := R.Bottom - R.Top;{Height}
              //seta posição no meio do Botão
              SetCursorPos(BPoint.X + (Largura div 2), BPoint.Y + (Altura div 2));
              GetCursorPos(BPoint);
              //simula click do mouse
              Mouse_Event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_LEFTDOWN, BPoint.x, BPoint.y, 0, 0);
              Mouse_Event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_LEFTUP, BPoint.x, BPoint.y, 0, 0);
           end;
       end;

       //Espera 500 milisegudos
       Sleep(500);
       //Captura texto do Edit da outra aplicação
       SendMessage(Handle_Edit, WM_GETTEXT, SizeOf(WinStr), Longint(@WinStr));
       //Adiciona na lista
       Lista.Add(StrPas(WinStr));

       Application.ProcessMessages;
       if Cancelar then
       begin
         Cancelar := False;
         Button1.Enabled := True;
         Exit;
       end;
    end;
  finally
    Panel1.Caption := 'Salvando em arquivo...';
    //Salva lista
    Lista.SaveToFile(Edit3.Text);
    Lista.Free;
    Application.ProcessMessages;
    Sleep(500);
    Panel1.Caption := '';
  end;

  Panel1.Caption := 'Pronto.';
  Button1.Enabled := True;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ShowMessage('LoadKeyGen by Prodigy' +#13+
              '#DELPHIX - irc.brasnet.org' +#13+
              'www.delphix.com.br');
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  Cancelar := True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Cancelar := False;
  ComboBox1.ItemIndex := 0;
  Form1.Icon := Application.Icon;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Label5Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphix.com.br/', nil, nil, SW_SHOWNORMAL);
end;

end.
