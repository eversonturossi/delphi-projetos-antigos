procedure OpenInternetExplorer( sURL : string );
//
// Executa o Internet Explorer a partir de uma Url especificada
//
// ex: OpenInternetExplorer('http://www.geocities.com/Broadway/3367');
//
// Requer a unit ComObj na clausula Uses
//
const
csOLEObjName = 'InternetExplorer.Application';
var
  IE : Variant;WinHanlde : HWnd;
begin
if( VarIsEmpty( IE ) )then
   begin
   IE := CreateOleObject( csOLEObjName );
   IE.Visible := true;
   IE.Navigate( sURL );
   end
else
   begin
   WinHanlde := FindWIndow( 'IEFrame', nil );
   if( 0 <> WinHanlde )then
      begin
      IE.Navigate( sURL );
      SetForegroundWindow( WinHanlde );
      end
   else
      begin
      Showmessage('Ocorreu um erro não informado!');
      end;
  end;
end;
