function FechaPrograma(Nomeprograma,TituloPrograma:pchar; param: integer): boolean;
//
// Fecha um programa que esteje aberto
//
// param:  determina que tipo de janela será fechada
//
//         1 - Janela Windows
//         2 - Janela Dos
//
var
Handle: HWnd;
begin
ShowMessage('Confirma o fechamento do(a) '+strpas(TituloPrograma)+'?');
Handle := FindWindow(nil,TituloPrograma);
if Handle <> 0 then
   begin
   case param of
        1: SendMessage(Handle,WM_CLOSE,0,0); // Para janela windows
        2: SendMessage(Handle,WM_QUIT,0,0); // Para janela DOS
   end;
   Result := true;
   end
else
   begin
   showmessage('Este programa não está aberto');
   Result := false;
   end;
end;
