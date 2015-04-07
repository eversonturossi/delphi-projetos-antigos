//*********************************************************//
//      (*) COMUNIDADE DE PROGRAMAÇÃO #DelphiX (*)         //
//                                                         //
// FILOSOFIA DA COMUNIDADE : Disseminar(Expalhar) o Nosso  //
// Conhecimento para que assim a programação possa melhorar//
// com novas idéias e melhores profissionais.              //
//                                                         //
// PROJETO DESENVOLVIDO POR _CR4SH_, MEMBRO DO #DelphiX    //
// DESDE AGOSTO DE 2001                                    //
//*********************************************************//
// Nick : _Cr4sh_                                          //
// Nome Programador : José Roberto Ferreira de Araújo Jr.  //
// Data da Implementacao : 30/12/2002                      //
// Rede IRC : Brasnet                                      //
// Contato  : jroberto_jr@lycos.com ou webdelphi@lycos.com //
//---------------------------------------------------------//
// OBS.:  TODOS OS DIREITOS RESERVADOS                     //
//---------------------------------------------------------//
//*********************************************************//
unit FormAbout;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, jpeg, StdCtrls, WebLabel;

type
  TAboutForm = class(TForm)
    Timer: TTimer;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    LabelEMail: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure TimerTimer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LabelEMailClick(Sender: TObject);
  private
     inIndex : Integer;
     strText : string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation
  uses ShellApi;
{$R *.DFM}

procedure TAboutForm.TimerTimer(Sender: TObject);
var
  strCaptionTemp : string;
begin
  //incrementamos a variavel do indice(inIndex)
  //dos caracteres de uma Unidade.
  Inc(inIndex, 1);

  //nossa variavel com um tamanho maior
  //que o tamanho do Texto?
  if inIndex > Length(strText) then
  begin
    //sim, entao desabilita o Timer.
    Timer.Enabled := False;
    //sai da procedure.
    Exit;
  end;//if-then.

  //pegamos o conteudo do Caption do Label.
  strCaptionTemp := Label1.Caption;
  //deletamos caracter especial por caracter especial
  Delete(strCaptionTemp, inIndex, 1);
  //inserimos o caracter da Descricao da "Community DelphiX"
  //na mesma posicao que aquele caracter especial foi apagado.
  Insert(strText[inIndex], strCaptionTemp, inIndex);
  //mandamos de volta a string formatada para
  //o caption do Label. 
  Label1.Caption := strCaptionTemp;
  //permite que o Windows Processe suas Mensagens.
  Application.ProcessMessages;
end;//TimerTimer.

procedure TAboutForm.FormActivate(Sender: TObject);
begin
  //habilitamos o Timer.
  Timer.Enabled := True;
end;//FormActivate.

procedure TAboutForm.FormCreate(Sender: TObject);
begin
  //iniciamos as variaveis.
  inIndex := 0;
  strText := 'Community #DelphiX';
end;//FormCreate.

procedure TAboutForm.LabelEMailClick(Sender: TObject);
begin
  //chamamos o OutLook para o Usuário mandar um Email.
  ShellExecute(Screen.ActiveForm.Handle,
               'open',
               PChar('mailto:' + LabelEMail.Caption),
               nil,
               nil, SW_NORMAL);
end;

end.
