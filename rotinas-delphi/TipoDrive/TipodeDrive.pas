Function TipodeDrive(Unidade: String):String;
//
// Retorna o tipo de unidade referente a letra
// especificada.
//
Var
StrDrive : String;
StrDriveType : String;
intDriveType : Integer;
begin
StrDrive := Unidade;
If StrDrive[Length(StrDrive)] <> '\' Then
   begin
   StrDrive := StrDrive + ':\';
   end;
intDriveType := GetDriveType(PChar(StrDrive));
Case intDriveType Of
     0                : StrDriveType := 'Unidade inválida ou não encontrada.';
     1                : StrDriveType := 'Unidade não encontrada ou inválida.';
     DRIVE_REMOVABLE  : StrDriveType := 'Floppy Drive ou Disco Removivel.';
     DRIVE_FIXED      : StrDriveType := 'Disco Rígido.';
     DRIVE_REMOTE     : StrDriveType := 'Unidade de rede mapeada.';
     DRIVE_CDROM      : StrDriveType := 'Drive CD-ROM ou similar.';
     DRIVE_RAMDISK    : StrDriveType := 'Disco de RAM ou similar.';
end;
Result := StrDriveType;
end;
