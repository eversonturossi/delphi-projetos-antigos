Procedure ExisteDrives;
{Retorna todos os drives existentes na maquina. Esta procedure
 exige um listbox}
var
DriveNum: Integer;
DriveChar: Char;
DriveBits: set of 0..25;
DriveType: TDriveType;
begin
Integer(DriveBits) := GetLogicalDrives;
for DriveNum := 0 to 25 do
    begin
    if not (DriveNum in DriveBits) then
            begin
            Continue;
            end;
   DriveChar := UpCase(Char(DriveNum + Ord('a')));
   DriveType := TDriveType(GetDriveType(PChar(DriveChar +':\')));
   case DriveType of
        dtFloppy: ListBox1.Items.Add(DriveChar + ': Disco Flexível');
        dtFixed: ListBox1.Items.Add(DriveChar + ': Disco Fixo');
        dtNetwork: ListBox1.Items.Add(DriveChar + ': Network Volume');
        dtCDROM: ListBox1.Items.Add(DriveChar + ': CD-ROM');
        dtRAM: ListBox1.Items.Add(DriveChar + ': RAM');
    end;
end;
end;