procedure MouseParaControle(Controle: TControl);
//
// Posiciona o mouse em cima do objeto definido em Controle
//
// use-a no evento OnShow do form:
//
// MouseParaControle(button1);
//
var
  IrPara: TPoint;
begin
  IrPara.X := Controle.Left + (Controle.Width div 2);
  IrPara.Y := Controle.Top + (Controle.Height div 2);
  if Controle.Parent <> nil then
    IrPara := Controle.Parent.ClientToScreen(IrPara);
  SetCursorPos(IrPara.X, IrPara.Y);
end;
