unit AutoSize;

interface

uses
 Windows, Messages, SysUtils, Forms, Classes, Controls;

type
 TDuplicateError = class(Exception);

 TAutoSize = class(TControl)
 private
   FormHandle: HWnd;
   NewWndProc: TFarProc;
   PrevWndProc: TFarProc;
   CheckAfterShow: Boolean;
   procedure WndPro(var Msg: TMessage);
   procedure WMWindowPosChanged(var Msg: 
    TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
 protected
   procedure AdjustClientArea; virtual;
 public
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;
 end;

procedure Register;

implementation

constructor TAutoSize.Create(AOwner: TComponent);
var
 I: Word;
 AutoSizeCount: Byte;
begin
 AutoSizeCount:=0;
 NewWndProc:=nil;
 PrevWndProc:=nil;
 inherited Create(AOwner);
 with (AOwner as TForm) do begin
   if (csDesigning in ComponentState) then begin
     for I:=0 to ComponentCount-1 do
       if Components[I] is TAutoSize then
         Inc(AutoSizeCount);
     if AutoSizeCount>1 then
       raise TDuplicateError.Create('A TAutoSize
        component already exists');
   end;
   FormHandle:=Handle;
   NewWndProc:=MakeObjectInstance(WndPro);
   PrevWndProc:=Pointer(SetWindowLong(FormHandle,
    GWL_WNDPROC, LongInt(NewWndProc)));
 end;
end;

destructor TAutoSize.Destroy;
begin
 if Assigned(PrevWndProc) then begin
   SetWindowLong(FormHandle, GWL_WNDPROC,
    Longint(PrevWndProc));
   PrevWndProc:=nil;
 end;
 if NewWndProc<>nil then
   FreeObjectInstance(NewWndProc);
 inherited Destroy;
end;

procedure TAutoSize.WndPro(var Msg: TMessage);
begin
 with Msg do begin
   case Msg of
     WM_SIZE:
       if (csDesigning in ComponentState) then
       begin
         Left:=LoWord(lParam)-2;
         Top:=HiWord(lParam)-2;
       end;

     WM_SHOWWINDOW:
       if not(csDesigning in ComponentState) then
         if Boolean(wParam) then
           if not CheckAfterShow then
             begin
               AdjustClientArea;
               CheckAfterShow:=True;
             end;
   end;
   Result:=CallWindowProc(PrevWndProc, FormHandle,
    Msg, wParam, lParam);
 end;
end;

procedure TAutoSize.WMWindowPosChanged(var Msg:
   TWMWindowPosChanged);
begin
 if (csDesigning in ComponentState) then begin
   Left:=TForm(Owner).ClientWidth-2;
   Top:=TForm(Owner).ClientHeight-2;
   Width:=2;
   Height:=2;
 end else
 if not CheckAfterShow then
   AdjustClientArea;
 Msg.Result:=0;
end;

procedure TAutoSize.AdjustClientArea;
begin
 TForm(Owner).ClientWidth:=Left+Width;
 TForm(Owner).ClientHeight:=Top+Height;
end;

procedure Register;
begin
 RegisterComponents('Idms', [TAutoSize]);
end;

end.
