{----------------------------------------------------------------
 Nome: UntProcMsgIRCSrv
 Descrição: Unit que contém uma função para processar
menssagens vindas do servidor.
 ----------------------------------------------------------------}

unit UntProcMsgIRCSrv;

interface
 uses
   Classes, Dialogs, SrvAnalisesUtils, UntPrincipal, UntwIRCStatus;

 procedure ProcMsgIRCSrv(Tipo: TIRCSrvMsg; SaidaSrv: TStringList);

implementation

 procedure ProcMsgIRCSrv;
 var
   Contador: integer;

 begin
   if (Tipo = ismSimples) then
   begin {Menssagens que não são interpretadas, apenas mostradas no FrmStatus}
     wIRCStatus.AdLinha(SaidaSrv.Strings[0]);
   end
   else
   begin
     case Tipo of

       ism353:
       begin {Listagem de nicks de um canal}
         {SaidaSrv.Strings[0] contém o nome do canal o restante da lista são os nicks}
         for Contador:=1 to SaidaSrv.Count - 1 do
           FrmPrincipal.AdNick(SaidaSrv.Strings[Contador], SaidaSrv.Strings[0], true);
       end;

     end;
   end;
 end;

end.
