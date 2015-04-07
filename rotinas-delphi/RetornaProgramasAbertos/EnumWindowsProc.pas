Function EnumWindowsProc (Wnd: HWND; lb: TListbox): BOOL; stdcall;
//
// Retorna todos os programas que estao abertos na memoria
// Esta funcao requer um ListBox
//
// Sintaxe:
//
// listbox1.clear;
// EnumWindows( @EnumWindowsProc, integer(listbox1));
//
var
caption: Array [0..128] of Char;
begin
Result := True;
if IsWindowVisible(Wnd) and ((GetWindowLong(Wnd, GWL_HWNDPARENT) = 0) or (HWND(GetWindowLong(Wnd, GWL_HWNDPARENT)) = GetDesktopWindow)) and ((GetWindowLong(Wnd, GWL_EXSTYLE) and WS_EX_TOOLWINDOW) = 0) then
   begin
   SendMessage( Wnd, WM_GETTEXT, Sizeof( caption ),integer(@caption));
   lb.Items.AddObject( caption, TObject( Wnd ));
   end;
end;
