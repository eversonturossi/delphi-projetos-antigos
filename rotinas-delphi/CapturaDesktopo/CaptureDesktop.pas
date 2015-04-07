procedure CaptureDesktop(aBitmap:TBitMap);
//
// Captura o Desktop corrente
//
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
