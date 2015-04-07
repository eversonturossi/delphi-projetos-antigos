procedure SetCDAutoRun(AAutoRun:Boolean);
//
// Habilita o "Autorun" para CD-Rom
//
// Requer a Registry declarada na clausua uses
// da unit
//
const
DoAutoRun : array[Boolean] of Integer = (0,1);
var
Reg:TRegistry;
begin
try
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  if Reg.KeyExists('System\CurrentControlSet\Services\Class\CDROM') then
     begin
     if Reg.OpenKey('System\CurrentControlSet\Services\Class\CDROM',FALSE) then
        begin
        Reg.WriteBinaryData('AutoRun',DoAutoRun[AAutoRun],1);
        end;
     end;
finally
  Reg.Free;
end;
ShowMessage('Suas configurações terão efeito apos reiniciar o computador.');
end;
