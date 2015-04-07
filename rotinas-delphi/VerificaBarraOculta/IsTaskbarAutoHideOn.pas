function IsTaskbarAutoHideOn : boolean;
//
// Testa se a barra de tarefas está ocultada ou não
//
// requer a unit ShellAPI na clausula uses
//
var
ABData : TAppBarData;
begin
ABData.cbSize := sizeof(ABData);
Result := (SHAppBarMessage(ABM_GETSTATE, ABData) and ABS_AUTOHIDE) > 0;
end;
