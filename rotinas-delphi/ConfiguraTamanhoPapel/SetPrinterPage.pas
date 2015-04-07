procedure SetPrinterPage(Width, Height : LongInt);
var
Device : array[0..255] of char;
Driver : array[0..255] of char;
Port   : array[0..255] of char;
hDMode : THandle;
PDMode : PDEVMODE;
begin
Printer.GetPrinter(Device, Driver, Port, hDMode);
If hDMode <> 0 then
   begin
   pDMode := GlobalLock( hDMode );
   If pDMode <> nil then
      begin
      pDMode^.dmPaperSize   := DMPAPER_USER;
      pDMode^.dmPaperWidth  := Width;
      pDMode^.dmPaperLength := Height;
      pDMode^.dmFields := pDMode^.dmFields or DM_PAPERSIZE;
      GlobalUnlock( hDMode );
      end;
   end;
end;