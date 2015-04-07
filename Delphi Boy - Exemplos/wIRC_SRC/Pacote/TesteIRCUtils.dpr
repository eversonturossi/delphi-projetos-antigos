program TesteIRCUtils;
{$APPTYPE CONSOLE}
uses
  IRCUtils,
  SysUtils,
  Classes;

var
  Saida: TStringList;
  Contador: integer;
  TipoMsg: TIRCMsg;

begin
  writeln('Programa para testes na biblioteca IRCUtils');
  TipoMsg:=AnalisarIRC(':EAccessViolation!~semnome@127.0.0.X PRIVMSG Waack3_Marks :PING 1015686028', Saida);

  if (TipoMsg = imDccChat) then
    writeln('CHAT');

  if (TipoMsg = imDccSend) then
    writeln('SEND');

  if (TipoMsg = imCtcpPing) then
    writeln('PING');

  if (TipoMsg = imCtcpTime) then
    writeln('TIME');

  if (TipoMsg = imCtcpVersion) then
    writeln('VERSION');

  if (TipoMsg = imDesconhecido) then
    writeln('Menssagem desconhecida');

  for Contador:=0 to Saida.Count - 1 do
    writeln(Saida.Strings[Contador]);

  //Pausa e sai
  writeln('Pressione <ENTER> para sair...');
  readln;
end.
