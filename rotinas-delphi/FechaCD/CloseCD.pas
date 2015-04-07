function CloseCD(Drive : char): Boolean;
//
// Fecha a bandeja do CD-Rom
//
// Requer a MMSystem e MPlayer declaradas na clausula uses da unit
//
var
mp : TMediaPlayer;
begin
result := false;
Application.ProcessMessages;
mp := TMediaPlayer.Create(nil);
mp.Visible := false;
mp.Parent := Application.MainForm;
mp.Shareable := true;
mp.DeviceType := dtCDAudio;
mp.FileName := Drive + ':';
mp.Open;
Application.ProcessMessages;
mciSendCommand(mp.DeviceID,
MCI_SET, MCI_SET_DOOR_CLOSED, 0);
Application.ProcessMessages;
mp.Close;
Application.ProcessMessages;
mp.free;
result := true;
end;
