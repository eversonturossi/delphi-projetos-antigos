function EjectCD(Drive : char) : bool;
//
// Ejeta a bandeja do CD-Rom
//
// Requer a MPlayer declarada na clausula uses da unit
//
var
mp : TMediaPlayer;
begin
result := false;
Application.ProcessMessages;
if not IsDriveCD(Drive) then
   begin
   exit;
   end;
mp := TMediaPlayer.Create(nil);
mp.Visible := false;
mp.Parent := Application.MainForm;
mp.Shareable := true;
mp.DeviceType := dtCDAudio;
mp.FileName := Drive + ':';
mp.Open;
Application.ProcessMessages;
mp.Eject;
Application.ProcessMessages;
mp.Close;
Application.ProcessMessages;
mp.free;
result := true;
end;
