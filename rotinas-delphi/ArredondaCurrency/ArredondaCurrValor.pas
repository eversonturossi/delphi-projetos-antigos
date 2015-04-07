Function ArredondaCurrValor(eValor:Extended;iNumCasasDecimais:Integer):String;
//
// Arredonda para duas casas decimais um valor currency
//
begin
  Result := FLOATTOSTRF(eValor,ffCurrency,18,iNumCasasDecimais);
end;
