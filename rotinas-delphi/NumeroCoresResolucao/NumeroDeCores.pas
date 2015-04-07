function NumeroDeCores : Integer;
{Retorna a quantidade atual de cores no Windows (16, 256, 65536 = 16 ou 24 bit}
var
  DC:HDC;
  BitsPorPixel: Integer;
begin
Dc := GetDc(0); // 0 = vídeo
BitsPorPixel := GetDeviceCaps(Dc,BitsPixel);
Result := 2 shl (BitsPorPixel - 1);
end;
