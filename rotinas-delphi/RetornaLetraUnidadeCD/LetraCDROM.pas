Function LetraCDROM: String;
//
// Retorna a letra atribuida a unidade de
// CDRom
//
Var
Unidades, Contador: Integer;
Unidad: String;
Begin
Unidades := GetLogicalDrives;
For Contador := 0 To 31 Do
    begin
    If (Unidades And (Trunc(Exp(Contador*Ln(2))))) <> 0 Then
        Begin
        Unidad := Char(Contador + 65) + ':\';
        If GetDriveType(PChar(Unidad)) = DRIVE_CDROM Then
           begin
           Break;
           end;
        end;
    Result := Unidad;
    end;
End;
