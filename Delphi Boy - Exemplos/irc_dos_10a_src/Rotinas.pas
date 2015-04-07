unit Rotinas;

interface

uses Windows, Messages, SysUtils, Classes, StdCtrls, Forms, IniFiles;

const
  VALID_STR = 'ABCDEFGHIJKLMNOPQRSTUWVXYZ'+
              'abcdefghijklmnopqrstuwvxyz'+
              '0123456789'+
              '_';
  MAX_MSG_LENGTH = 350;
  STR_ECHO = '>>>';         

 function CopyPalav(Msg: String; Index: Integer; const Separador: Char = #32): String;
 function CopyInfo(Msg: String): String;
 function ValidStr(StrIn : String; ValidStr: String) : Boolean;
 function IsInteger(StringX: String): Boolean;
 procedure UpdateMsgList(Msg: String);

 function GetWindowsDir: string;
 function GetSystemDir: string;
 procedure CaptureConsoleOutput(DosApp, ACmdDir : string; AMemo : TMemo);

 procedure SaveOptions;
 procedure LoadOptions;

var
  Ini : TIniFile;

implementation

uses Center;

// Função para copiar uma palavra determinando o Indice
function CopyPalav(Msg: String; Index: Integer; const Separador: Char = #32): String;
var
  X, I, ContPalav : Integer;
  S, Palav : string;
  label Fim;//Label que direciona para o Fim (Result := Palav;)
begin
 Palav := '';
 if Index < 1 then
  Goto Fim;

 if Length(Msg) > 0 then
 begin
    //Conta nº de palavras
    ContPalav := 0;
    for X := 1 to Length(Msg) do
    if Msg[X] <> Separador then
    begin
      //ultimo caracter
      if X = Length(Msg) then
       Inc(ContPalav);
    end
    else
     Inc(ContPalav);

    //Verifica se o Indice eh invalido
    if Index > ContPalav then
    begin
      Palav := '';
      goto Fim;
    end;

    //Retorna palavra do Indice
    I := 1;
    for X := 1 to Length(Msg) do
    begin
        if Msg[X] <> Separador then
        begin
          S := S + Msg[X];
          //ultimo caracter
          if X = Length(Msg) then
          begin
            Palav := S;
            Break;
          end;
        end
        else
        begin
          Palav := S;
          if I = Index then
           Break;
          S := '';
          Inc(I);
        end;
    end;

 end;

  //Label Fim
  Fim:
    Result := Palav;
end;

// Copia informação depois do :
function CopyInfo(Msg: String): String;
var
  P : Integer;
  S : String;
begin
  //MSGP MeuNick Nick:Minha Mensagem#13#10
  P := Pos(':', Msg) +1;

  while (Copy(Msg,P,1) <> '') and (Copy(Msg,P,1) <> #13) do
  begin
   S := S + Copy(Msg,P,1);
   Inc(P);
  end;

  Result := S;
end;

// Verifica se uma String tem caracteres VALIDOS
function ValidStr(StrIn : String; ValidStr: String) : Boolean;
var
  I  : Integer;
begin
  Result := True;
  
  if Length(StrIn) = 0 then
  begin
    Result := False;
    Exit;
  end;

   for I := 1 to Length(StrIn) do
    if NOT (AnsiPos(StrIn[I], ValidStr) > 0) then
     Result := False;
end;

function IsInteger(StringX: String): Boolean;
begin
  Result := True;
  try
   StrToInt(StringX);
  except
   on EConvertError do
    Result := False;
  end;
end;

procedure UpdateMsgList(Msg: String);
var
  N : Integer;
begin
    N := MsgList.Count;
    if N < 20 then
     MsgList.Add(Msg)
    else
    begin
     MsgList.Delete(0);
     MsgList.Add(Msg);
    end;
  ListaId := MsgList.Count;
end;
procedure SaveOptions;
begin
  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini');
  Ini.WriteString('Config','Nick', Nick);
  Ini.WriteString('Config','NickPass', NickPass);
  Ini.WriteString('Config','Nick2', Nick2);
  Ini.WriteString('Config','Nome', Nome);
  Ini.WriteString('Config','Servidor', Serv);
  Ini.WriteString('Config','Porta', Porta);
  Ini.WriteString('Config','Destino', Destino);
  Ini.Free;
end;

procedure LoadOptions;
begin
  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini');
  Nick     := Ini.ReadString('Config','Nick', 'Nick');
  NickPass := Ini.ReadString('Config','NickPass', '');
  NIck2    := Ini.ReadString('Config','Nick2', 'Nick2');
  Nome     := Ini.ReadString('Config','Nome', 'Nome');
  Serv     := Ini.ReadString('Config','Servidor', '');
  Porta    := Ini.ReadString('Config','Porta', '6667');
  Destino  := Ini.ReadString('Config','Destino', '');
  Ini.Free;
end;

function GetWindowsDir: string;
{$IFDEF WIN32}
var
  Buffer: array[0..1023] of Char;
begin
  SetString(Result, Buffer, GetWindowsDirectory(Buffer, SizeOf(Buffer)));
{$ELSE}
begin
  Result[0] := Char(GetWindowsDirectory(@Result[1], 254));
{$ENDIF}
end;

function GetSystemDir: string;
{$IFDEF WIN32}
var
  Buffer: array[0..1023] of Char;
begin
  SetString(Result, Buffer, GetSystemDirectory(Buffer, SizeOf(Buffer)));
{$ELSE}
begin
  Result[0] := Char(GetSystemDirectory(@Result[1], 254));
{$ENDIF}
end;


procedure CaptureConsoleOutput(DosApp, ACmdDir: string; AMemo : TMemo);
const
  ReadBuffer = 1048576;  // 1 MB Buffer
var 
  Security            : TSecurityAttributes; 
  ReadPipe,WritePipe  : THandle; 
  start               : TStartUpInfo; 
  ProcessInfo         : TProcessInformation; 
  Buffer              : Pchar; 
  TotalBytesRead, 
  BytesRead           : DWORD; 
  Apprunning,n, 
  BytesLeftThisMessage, 
  TotalBytesAvail : integer; 
begin 
  with Security do
  begin
    nLength              := SizeOf(TSecurityAttributes);
    bInheritHandle       := true;
    lpsecurityDescriptor := nil;
  end; 

  if CreatePipe(ReadPipe, WritePipe, @Security, 0) then
  begin 
    // Redirect In- and Output through STARTUPINFO structure 

    Buffer  := AllocMem(ReadBuffer + 1); 
    FillChar(Start,Sizeof(Start),#0); 
    start.cb          := SizeOf(start); 
    start.hStdOutput  := WritePipe; 
    start.hStdInput   := ReadPipe; 
    start.dwFlags     := STARTF_USESTDHANDLES + STARTF_USESHOWWINDOW; 
    start.wShowWindow := SW_HIDE; 

    // Create a Console Child Process with redirected input and output
    if CreateProcess(nil      ,PChar(DosApp), 
                     @Security,@Security, 
                     true     ,CREATE_NO_WINDOW or NORMAL_PRIORITY_CLASS, 
                     nil      ,nil, 
                     start    ,ProcessInfo) then 
    begin 
      n:=0; 
      TotalBytesRead:=0; 
      repeat 
        // Increase counter to prevent an endless loop if the process is dead 
        Inc(n,1); 
         
        // wait for end of child process 
        Apprunning := WaitForSingleObject(ProcessInfo.hProcess,100); 
        Application.ProcessMessages;

        // it is important to read from time to time the output information 
        // so that the pipe is not blocked by an overflow. New information 
        // can be written from the console app to the pipe only if there is 
        // enough buffer space. 

        if not PeekNamedPipe(ReadPipe        ,@Buffer[TotalBytesRead], 
                             ReadBuffer      ,@BytesRead, 
                             @TotalBytesAvail,@BytesLeftThisMessage) then break 
        else if BytesRead > 0 then 
          ReadFile(ReadPipe,Buffer[TotalBytesRead],BytesRead,BytesRead,nil); 
        TotalBytesRead:=TotalBytesRead+BytesRead; 
      until (Apprunning <> WAIT_TIMEOUT) or (n > 150); 

      Buffer[TotalBytesRead]:= #0;
      //OemToChar(Buffer,Buffer);
      
      AMemo.Text := AMemo.Text + StrPas(Buffer);
      AMemo.Lines.Add('');
      AMemo.Text := AMemo.Text + ACmdDir +'>';
      AMemo.SelStart := Length(AMemo.Text);
      SendMessage(AMemo.Handle, EM_SCROLL, SB_BOTTOM, 0);
      SendMessage(AMemo.Handle, EM_SCROLLCARET, 0, 0);
    end; 
    FreeMem(Buffer); 
    CloseHandle(ProcessInfo.hProcess); 
    CloseHandle(ProcessInfo.hThread); 
    CloseHandle(ReadPipe); 
    CloseHandle(WritePipe); 
  end; 
end;

end.
 