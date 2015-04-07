unit Rotinas;

interface

uses SysUtils, Windows;

    procedure MandaTexto(SText: String);
    procedure MandaPrivMsg(Destino, Texto: String);
    procedure MandaNotice(Destino, Texto: String);
    procedure SetNick(SNick: String);
    procedure SetUsuario(Mail, Serv, SNome: String);
    function IsInteger(StringX: String): Boolean;
    function CopyInfo(Msg: String): String;
    function CopyPalav(Msg: String; Index: Integer; const Separador: Char = #32): String;

implementation

uses Unit1;

procedure MandaTexto(SText: String);
begin
  Form1.ClientSocket.Socket.SendText(SText + #13#10);
end;

procedure MandaPrivMsg(Destino, Texto: String);
begin
  MandaTexto(Format('PRIVMSG %s :%s', [Destino, Texto]));
  Form1.RichEdit1.Lines.Add(Format('-->PRIVMSG %s :%s', [Destino, Texto]));
end;

procedure MandaNotice(Destino, Texto: String);
begin
  MandaTexto(Format('NOTICE %s :%s' , [Destino, Texto]));
end;

procedure SetNick(SNick: String);
begin
  MandaTexto(Format('NICK %s', [SNick]));
end;

procedure SetUsuario(Mail, Serv, SNome: String);
var
  M_user, M_serv : String;
  P : Integer;
begin
  P := Pos('@',Mail);
  M_user := Copy(Mail,1, P-1);
  M_serv := Copy(Mail, P+1 , Length(Mail)-P);

  MandaTexto(Format('USER %s "%s" "%s" :%s', [M_user, M_serv, Serv, SNome]));
  Form1.RichEdit1.Lines.Add(Format('-->USER %s "%s" "%s" :%s', [M_user, M_serv, Serv, SNome]));

end;

//Se String é Integer
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

// Função para copiar uma palavra determinando o Indice
function CopyPalav(Msg: String; Index: Integer; const Separador: Char = #32): String;
var
  X, I, ContPalav : Integer;
  S, Palav : string;
  label Fim;//Label que direciona para o Fim (Result := Palav;)
begin
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

 end
 else
  Palav := '';

  //Label Fim
  Fim:
    Result := Palav;
end;



end.
 