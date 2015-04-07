procedure SaveDeskTopImageToBitmap (aFileName:String);
//
// Salva o Desktop Capturado em um arquivo
//
procedure CaptureDesktop(aBitmap:TBitMap);
var
    Canvas : TCanvas;
begin
   Canvas:=Tcanvas.Create;
   try
      Canvas.Handle:=GetDc(0);
      aBitMap.Canvas.CopyRect(Canvas.ClipRect,Canvas,Canvas.ClipRect);
   finally
     ReleaseDc(0,Canvas.Handle);
     Canvas.Free;
   end;
end;

var
   BitMap : TBitMap;
begin
  BitMap := TBitMap.Create;
  try
    BitMap.Width := Screen.Width;
    BitMap.Height := Screen.Height;
    CaptureDesktop(BitMap);
    BitMap.SaveToFile(aFilename);
  finally
    BitMap.Free;
  end;
end;

