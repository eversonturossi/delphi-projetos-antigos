function MouseShowCursor(const Show: boolean): boolean;
//
// Oculta e Mostra o cursor do mouse
//
// MouseShowCursor(false); { Oculta o cursor }
// 
// MouseShowCursor(true); { Exibe o cursor }
// 
var
  I: integer;
begin
  I := ShowCursor(LongBool(true));
  if Show then begin
    Result := I >= 0;
    while I < 0 do begin
      Result := ShowCursor(LongBool(true)) >= 0;
      Inc(I);
    end;
  end else begin
    Result := I < 0;
    while I >= 0 do begin
      Result := ShowCursor(LongBool(false)) < 0;
      Dec(I);
    end;
  end;
end;
