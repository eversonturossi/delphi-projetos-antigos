{----------------------------------------------------------------
 Nome: UntComandos
 Descrição: Unit que contém 'automatizações' dos comandos de
saída do IRC(Comunicação externa.

 Métodos:
  -procedure PvtMsg(Destino, Menssagem: string); Envia menssagem
para um canal ou usuário.
  -procedure PartCha(Canal: string); Sai de um canal que esteja
conectado.
 ----------------------------------------------------------------}
unit UntComandos;

interface
 procedure PvtMsg(Destino, Menssagem: string);
 procedure PartCha(Canal: string);

 const
   cStrPvt     = 'PRIVMSG %s :%s';
   cStrPart    = 'PART %s';
   cStrJoin    = 'JOIN %s';
   cStrDccSend = #1 + 'DCC SEND %s 2130706433 4493 1719808' + #1; {TEMP}

implementation
 uses
   SysUtils, UntPrincipal, WinSock;

 procedure PvtMsg(Destino, Menssagem: string);
 begin
   FrmPrincipal.ClientePrincipal.Socket.SendText(Format(cStrPvt, [Destino, Menssagem]) + #13 + #10);
 end;

 procedure PartCha(canal: string);
 begin
   FrmPrincipal.ClientePrincipal.Socket.SendText(Format(cStrPart, [Canal]) + #13 + #10); 
 end;
 
end.
