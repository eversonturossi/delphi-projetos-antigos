function ExecExplorer(OpenAtPath: string; OpenWithExplorer, OpenAsRoot: Boolean): boolean;
//
// Executa o Windows Explorer a partir de uma pasta
// especificada
//
// Requer a unit ShellApi
//
//  ex: execExplorer('C:\Temp', True,True);
//
var
s: string;
begin
if OpenWithExplorer then
   begin
   if OpenAsRoot then
      s := ' /e,/root,"' + OpenAtPath + '"'
   else
      s := ' /e,"' + OpenAtPath + '"';
   end
else
   s := '"' + OpenAtPath + '"';
   result := ShellExecute(Application.Handle,PChar('open'),PChar('explorer.exe'),PChar(s),nil,SW_NORMAL) > 32;
end;
