procedure SetTaskBar(Visible: Boolean);
{Oculta A Barra de Tarefas}
var
  wndHandle : THandle;
  wndClass  : array[0..50] of Char;
begin
StrPCopy(@wndClass[0],'Shell_TrayWnd');
wndHandle := FindWindow(@wndClass[0], nil);
If Visible = True Then
   begin
   ShowWindow(wndHandle, SW_RESTORE);
   end
else
   Begin
   ShowWindow(wndHandle, SW_HIDE);
   end;
end;
