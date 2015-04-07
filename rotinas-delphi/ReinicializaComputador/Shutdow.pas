function ExitWindowsEx(uFlags : integer;  		 // shutdown operation
                   dwReserved : word) : boolean; // reserved
  external 'user32.dll' name 'ExitWindowsEx';

procedure Tchau;
const
  EWX_LOGOFF   = 0; // Dá "logoff" no usuário atual
  EWX_SHUTDOWN = 1; // "Shutdown" padrão do sistema
  EWX_REBOOT   = 2; // Dá "reboot" no equipamento
  EWX_FORCE    = 4; // Força o término dos processos
  EWX_POWEROFF = 8; // Desliga o equipamento

begin
  ExitWindowsEx(EWX_FORCE, 0);
end;
