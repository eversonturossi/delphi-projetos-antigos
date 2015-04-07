procedure SetaTamPapel(mLength, mWidth, mPaper : integer);
//
// muda o tamanho do papel da impressora
//
var
ADevice, ADriver, APort: array[0..255] of char;
DeviceMode: THandle;
M: PDevMode;
s : string;
begin
S := Printer.Printers[Printer.PrinterIndex];
Printer.GetPrinter(ADevice, ADriver, APort, DeviceMode);
M := GlobalLock(DeviceMode);
if M <> nil then
   begin
// M^.dmFields := M^.dmFields or DM_PAPERSIZE;
// M^.dmPaperSize := DMPAPER_LETTER;
   M^.dmPaperSize := mPaper;
   M^.dmFields := M^.dmFields or DM_PAPERLength;
   M^.dmPaperLength := mLength;
   M^.dmFields := M^.dmFields or DM_PAPERWidth;
   M^.dmPaperWidth := mWidth;
   Printer.SetPrinter(ADevice, ADriver, APort, DeviceMode);
   end;
end;
