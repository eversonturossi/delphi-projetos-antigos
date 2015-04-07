procedure WinCloseProg(Programa: Pchar);
//
// Fecha um aplicativo via Delphi
//
// Esta procedure não fecha aplicativos TSR's (Que ficam na barra de
// Tarefas ao lado do relógio)
//
// Para colocar o nome do programa, voce deve dar um Alt+Ctrl+del e ver
// Como aparece o nome deste programa na lista de tarefas.
// Ex: Se voce abrir o bloco de notas, ele será exibido na lista de tarefas
// como "Sem Nome - Bloco de Notas"  e é deste  jeito que voce deverá colocar
// na variável "Programa"
//
var
hHandle : THandle;
begin
hHandle := FindWindow( nil, Programa);
if hHandle <> 0 then
SendMessage( hHandle, WM_CLOSE, 0, 0);
end;
