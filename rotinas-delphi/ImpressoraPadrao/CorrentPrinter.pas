function CorrentPrinter :String;
// Retorna a impressora padrão do windows
// Requer a unit printers declarada na clausula uses da unit
var
Device : array[0..255] of char;
Driver : array[0..255] of char;
Port   : array[0..255] of char;
hDMode : THandle;
begin
Printer.GetPrinter(Device, Driver, Port, hDMode);
Result := Device+' na porta '+Port;
end;
