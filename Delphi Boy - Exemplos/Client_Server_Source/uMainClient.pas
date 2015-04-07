unit uMainClient;

interface

uses
 Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
 ScktComp, IniFiles, StdCtrls, uCommon, ComCtrls, ShellAPI, ExtCtrls;

const
 DELAY_TIME = 500;
 SUPORTE = 'Contacte o suporte técnico.';
 
type
 TReceiveMode = (rmIDLE,
  rmRECEIVING_INFO, // nao eh usado!
  rmRECEIVING_FILE);
 
 TfMain = class(TForm)
  sktCliente: TClientSocket;
  Timer: TTimer;
  Etapas: TPanel;
  lbEtapa1: TLabel;
  lbEtapa2: TLabel;
  lbEtapa3: TLabel;
  PBar: TProgressBar;
  Etapa1: TImage;
  Etapa2: TImage;
  Etapa3: TImage;
  Label1: TLabel;
  Animate1: TAnimate;
  procedure FormCreate(Sender: TObject);
  procedure sktClienteError(Sender: TObject; Socket: TCustomWinSocket;
   ErrorEvent: TErrorEvent; var ErrorCode: Integer);
  procedure sktClienteRead(Sender: TObject; Socket: TCustomWinSocket);
  procedure sktClienteDisconnect(Sender: TObject;
   Socket: TCustomWinSocket);
  procedure TimerTimer(Sender: TObject);
 private
  { Private declarations }
  NomeArquivoINI: string;
  LocalApp, RemoteApp: TAppInfo;
  RMode: TReceiveMode;
  Fs: TFileStream;
  DataLen: integer;
  Finished: boolean;
  procedure AbortaTransfer;
  procedure ProcessHeader(Buffer: string);
  procedure ProcessFile(Buffer: string);
  procedure Conecta;
  procedure GetAppInfo;
  function NeedUpdate(Local, Remote: TAppInfo): boolean;
  procedure GetAppFile;
  function IsWorking(Remote: TAppInfo): boolean;
  procedure RunApp(FName: string);
  procedure ErrorHandler(ErrorCode: integer);
  procedure Espera;
 public
  { Public declarations }
 end;
 
var
 fMain: TfMain;
 
implementation

{$R *.DFM}

procedure TfMain.FormCreate(Sender: TObject);
var
 Servidor: string;
 ArquivoINI: TIniFile;
 Porta: integer;
begin
 // carrega o video (simbolizando a transferencia) para exibicao posterior
 Animate1.ResName := 'TRANSFER1';
 
 // Recupera (ou grava) as configuracoes num arquivo .INI
 NomeArquivoINI := ChangeFileExt(ParamStr(0), '.INI');
 ArquivoINI := TIniFile.Create(NomeArquivoINI);
 
 // Le as configuracoes do servidor
 Servidor := ArquivoINI.ReadString('Geral', 'Servidor', NO_DATA);
 if Servidor = NO_DATA then begin
   Servidor := SRV_HOST;
   ArquivoINI.WriteString('Geral', 'Servidor', Servidor);
  end;
 Porta := ArquivoINI.ReadInteger('Geral', 'Porta', -1);
 if Porta = -1 then begin
   Porta := SRV_PORTA;
   ArquivoINI.WriteInteger('Geral', 'Porta', Porta);
  end;
 
 // prepara as informacoes sobre as aplicacoes
 // a aplicacao no servidor...
 FillChar(RemoteApp, SizeOf(RemoteApp), #0);
 // a aplicacao no cliente...
 LocalApp.Nome := ArquivoINI.ReadString('Geral', 'Aplicacao', NO_DATA);
 LocalApp.Arquivo := ArquivoINI.ReadString('Geral', 'Arquivo', NO_DATA);
 LocalApp.Versao := DataArquivo(LocalApp.Arquivo);
 LocalApp.Status := ''; // nao eh necessario
 LocalApp.Comment := ''; // nao eh necessario
 
 // fecha o arquivo .INI
 ArquivoINI.Free;
 
 // configura o servidor
 sktCliente.Close;
 sktCliente.Host := Servidor;
 sktCliente.Port := Porta;
 
 // fica esperando pelo cabecalho
 RMode := rmIDLE;
end;

procedure TfMain.AbortaTransfer;
begin
 case RMode of
  rmRECEIVING_FILE: begin
    Fs.Free;
    DeleteFile(RemoteApp.Arquivo);
   end;
 end;
end;

procedure TfMain.sktClienteError(Sender: TObject; Socket: TCustomWinSocket;
 ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
 // desenvolver depois uma rotina de "log de erros"
 ErrorHandler(ErrorCode);
 // para evitar mensagens de erro no servidor
 ErrorCode := 0;
end;

procedure TfMain.sktClienteDisconnect(Sender: TObject;
 Socket: TCustomWinSocket);
begin
 AbortaTransfer;
end;

procedure TfMain.sktClienteRead(Sender: TObject; Socket: TCustomWinSocket);
var
 Buffer: string;
 MsgLen, LenReceived: integer;
begin
 // tamanho aproximado da mensagem
 MsgLen := Socket.ReceiveLength;
 // prepara o tamanho do buffer e recebe a mensagem em si
 SetLength(Buffer, MsgLen);
 LenReceived := Socket.ReceiveBuf(Buffer[1], MsgLen);
 // ajusta para o numero correto de bytes
 Buffer := Copy(Buffer, 1, LenReceived);
 
 // manda o conteudo da mensagem para tratamento adequado
 case RMode of
  rmIDLE: ProcessHeader(Buffer);
  rmRECEIVING_INFO: ; // nao eh usado. Eh tratado no ProcessHeader
  rmRECEIVING_FILE: ProcessFile(Buffer);
 end;
end;

procedure TfMain.ProcessHeader(Buffer: string);
var
 Header: TMsgHeader;
 Aux: array[1..310] of char;
 i: integer;
begin
 // extrai o cabecalho
 Move(Buffer[1], Header, SizeOf(Header));
 Delete(Buffer, 1, SizeOf(Header));
 
 // guarda o tamanho da mensagem
 DataLen := Header.MsgSize;
 
 // atualiza a barra de progresso
 PBar.Max := DataLen;
 PBar.StepBy(Length(Buffer));
 
 // trata a mensagem
 case Header.MsgKind of
  MSG_APP_INFO_FOLLOWS: begin
    // limpa o buffer auxiliar
    FillChar(Aux, SizeOf(Aux), #0);
    // transfere de um para o outro
    for i := 1 to length(Buffer) do
     Aux[i] := Buffer[i];
    // copia do buffer auxiliar para a estrutura
    Move(Aux, RemoteApp, SizeOf(RemoteApp));
    // terminou; reinicializa a barra de progresso
    PBar.Position := 0;
    // sinaliza que acabou a transferencia
    Finished := True;
   end;
  MSG_FILE_FOLLOWS: begin
    // sinaliza que vai receber um arquivo
    RMode := rmRECEIVING_FILE;
    // cria o arquivo
    try
     Fs := TFileStream.Create(LocalApp.Arquivo, (fmCreate or fmOpenWrite));
     ProcessFile(Buffer);
    except
     ShowMessage('Nao foi possivel abrir o arquivo!');
    end;
   end;
  else
   Finished := True;
   ErrorHandler(Header.MsgKind);
 end;
end;

procedure TfMain.ProcessFile(Buffer: string);
begin
 try
  // atualiza a barra de progresso
  PBar.StepBy(Length(Buffer));
  // escreve o arquivo
  Fs.Write(Buffer[1], Length(Buffer));
  // verifica se jah terminou o arquivo
  Dec(DataLen, Length(Buffer));
  if DataLen = 0 then begin
    // volta ao modo de espera
    RMode := rmIDLE;
    // libera o TFileStream
    Fs.Free;
    // sinaliza que acabou a transferencia
    Finished := True;
   end;
 except
  ShowMessage('Houve um erro durante a transferencia do arquivo!');
 end;
 Buffer := '';
end;

procedure TfMain.ErrorHandler(ErrorCode: integer);
var
 Msg: string;
begin
 case ErrorCode of
  MSG_ERR_ILLEGAL_CODE: Msg := 'Erro desconhecido!';
  MSG_ERR_APP_NOT_FOUND: Msg := 'Aplicação não existe!';
  MSG_ERR_FILE_NOT_FOUND: Msg := 'Arquivo não encontrado!';
  MSG_ERR_CANNOT_SEND: Msg := 'Transferência não concluída!';
  MSG_ERR_DISCONECTING: Msg := 'Erro de comunicação!';
  else
   Msg := Format('ERRO No. %d', [ErrorCode]);
 end;
 // exibe a mensagem
 Erro(Msg);
 // fecha a conexao
 sktCliente.Close;
end;

// processamento do cliente (excluindo conexao)

procedure TfMain.Espera;
begin
 Delay(DELAY_TIME);
end;

procedure TfMain.Conecta;
begin
 // exibe o inicio da etapa
 lbEtapa1.Enabled := True;
 
 try
  sktCliente.Open;

  // artificio para contornar problemas por ser conexao assincrona
  while not sktCliente.Socket.Connected do
   Application.ProcessMessages;

  // espera um pouco para efeito visual
  Espera;
  // marca a etapa como concluida
  Etapa1.Visible := True;
 except
  sktCliente.Close;
 end;
end;

procedure TfMain.GetAppInfo;
begin
 // exibe o inicio da etapa
 lbEtapa2.Enabled := True;
 
 Finished := False;
 SendData(sktCliente.Socket, MSG_REQUEST_APP_INFO, LocalApp.Nome);
 // aguarda o fim da transferencia
 while not Finished do
  Application.ProcessMessages;
 
 // espera um pouco para efeito visual
 Espera;
 // marca a etapa como concluida
 Etapa2.Visible := True;
end;

function TfMain.NeedUpdate(Local, Remote: TAppInfo): boolean;
begin
 Result := (LocalApp.Versao < RemoteApp.Versao);
end;

procedure TfMain.GetAppFile;
begin
 // exibe o inicio da etapa
 lbEtapa3.Enabled := True;
 // exibe (e inicia) o video simbolizando a transferencia
 Animate1.Visible := True;
 Animate1.Active := True;
 // exibe a barra de progresso
 PBar.Visible := True;
 
 // sinaliza o inicio da transferencia
 Finished := False;
 SendData(sktCliente.Socket, MSG_REQUEST_FILE, RemoteApp.Nome);
 // aguarda o fim da transferencia
 while not Finished do
  Application.ProcessMessages;
 
 // desliga a animacao
 Animate1.Active := False;
 // marca a etapa como concluida
 Etapa3.Visible := True;
end;

function TfMain.IsWorking(Remote: TAppInfo): boolean;
begin
 Result := (StrToInt(Remote.Status) = 1)
end;

procedure TfMain.RunApp(FName: string);
begin
 ShellExecute(0, 'Open', PChar(FName), nil, nil, SW_SHOW);
end;

procedure TfMain.TimerTimer(Sender: TObject);
begin
 // evita que seja executado outra vez
 Timer.Enabled := False;
 
 // verifica se tem aplicacao configurada no .INI
 if LocalApp.Nome <> NO_DATA then begin
   // conecta ao servidor
   Conecta;

   // se conectou...
   if sktCliente.Active then begin
     // solicita dados da aplicacao no servidor
     GetAppInfo;

     // se o servidor atende a essa aplicacao...
     if RemoteApp.Nome <> NO_DATA then begin

       // se estah desatualizado...
       if NeedUpdate(LocalApp, RemoteApp) then
        GetAppFile;

       // se arquivo existe (realizou a atualizacao com sucesso)
       if FileExists(LocalApp.Arquivo) then begin

         // se o banco de dados estah disponivel...
         if IsWorking(RemoteApp) then begin
           // exibe mensagem como INFO, se o campo "comment" estiver preenchido
           if RemoteApp.Comment <> '' then
            Informacao(RemoteApp.Comment);

           // executa a aplicacao
           RunApp(LocalApp.Arquivo)
          end else begin
           // o banco de dados nao estah disponivel
           Erro(RemoteApp.Comment);
          end;
        end else begin
         // o arquivo nao existe (nao atualizou)
         Erro('Erro ao transferir arquivos!' + #13 + SUPORTE);
        end;
      end else begin
       // o servidor nao atende a essa aplicacao
       Erro('Aplicação não instalada no servidor!' + #13 + SUPORTE);
      end;
    end else begin
     // nao conectou
     Erro('Servidor não encontrado!' + #13 + SUPORTE);
    end;
  end else begin
   // nao ha aplicacao configurada
   Erro('Erro de configuração!' + #13 + SUPORTE);
  end;
 
 // fecha o lancador
 Close;
end;

end.

