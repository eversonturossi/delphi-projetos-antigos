function GetMemoryTotalPhys : DWord;
//
// Retorna o total de memoria do computador
//
var
ms : TMemoryStatus;
begin
ms.dwLength := SizeOf( ms );
GlobalMemoryStatus( ms );
Result := ms.dwTotalPhys;
end;
