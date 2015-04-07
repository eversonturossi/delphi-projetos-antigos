function DiscoNoDrive(const drive : char): boolean;
{Detecta se há disco no Drive}
var
  DriveNumero : byte;
  EMode : word;
  Retval : Boolean;
begin
result := false;
DriveNumero := ord(Drive);
if DriveNumero >= ord('a') then
   begin
   dec(DriveNumero,$20);
   EMode := SetErrorMode(SEM_FAILCRITICALERRORS);
   end;
   try
      if DiskSize(DriveNumero-$40) = -1 then
         begin
         Result := False;
         end
      else
         begin
         Result := True;
         end;
   Except
         SetErrorMode(EMode);
   end;
end;

