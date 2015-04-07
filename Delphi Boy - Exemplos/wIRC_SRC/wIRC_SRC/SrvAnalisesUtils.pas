{----------------------------------------------------------------
 Nome: SrvAnalisesUtils
 Descrição: Biblioteca para analisar menssagens vindas do
servidor. Esta biblioteca faz complementação a IRCUtils.
 ----------------------------------------------------------------}

unit SrvAnalisesUtils;

interface
 uses
   SysUtils, Classes, StrUtils;

 type {Tipos de menssagens do servidor}                       
   TIRCSrvMsg = (ismSimples, ismDesconhecido, ismIndefinido,
                 ism001, ism002, ism003, ism004,
                 ism005, ism250, ism251, ism252,
                 ism254, ism255, ism265, ism266,
                 ism372, ism375, ism376, ism332,
                 ism333, ism353, ism366);

 {Os tipos [ismDesconhecido, ismIndefinido] são tipos para rastreamento de
 de erros e bugs na biblioteca}

 {Função principal da unit, analisa a menssagem do servidor e retorna seu
  tipo e dados(Organizadamente)}
 function AnalisarMsgSrv(Menssagem: string; Dados: string; var Saida: TStringList): TIRCSrvMsg;

implementation
 function AnalisarMsgSrv;
 var
   iID: integer;
   Nick, Texto,
   Canal, Nicks: string;
   Lista: TStrings;

 begin
   {Define variáveis básicas}
   Chomp(Dados); {Retira quebra de linha}
   result:=ismIndefinido;
   Saida:=TStringList.Create;
   iID:=0;

   {Verifica se a menssagem é um número identificador}
   if (ChecarDigito(Menssagem)) then
     iID:=StrToInt(Menssagem);

   {Separa os Dados entre Nick e Texto}
   Nick:=PegarStr(Dados, 1, Pos(' ', Dados) - 1); {Nick do cliente}
   Texto:=Estilete(Dados, Pos(' ', Dados) + 1, deDireita); {Texto recebido}
   {Checa qual foi a menssgaem que o servidor enviou, avaliando o identificador}
   case iID of

     {Menssagens que não são interpretadas}
     001,002,003,004,005,250,251,252,
     254,255,265,266,372,375,376:
     begin
       if (Texto[1] = ':') then
         Delete(Texto, 1, 1); {Deleta ":", se tiver}
       Saida.Add(Texto);
       result:=ismSimples;
     end;

     {__Abaixo todas as menssagens são interpretadas__}
     
     353:
     begin {Listagem dos usuários de um canal}
       {Nome do canal}
       Canal:=PegarStr(Texto, Pos('=', Texto) + 2, Pos(':', Texto) - 2);
       Nicks:=Estilete(Texto, Pos(':', Texto) + 1, deDireita);
       Saida.Add(Canal);
       Lista:=SpArToTStrLst(Split(Nicks, ' '));
       {Listagem dos Nicks do canal}
       Saida.AddStrings(Lista);
       result:=ism353;
     end;

   end;
 end;

end.
