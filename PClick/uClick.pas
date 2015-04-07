unit uClick;

interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
 Dialogs, ExtCtrls, StdCtrls;

type
 TForm1 = class(TForm)
  TimerEncontraBotao: TTimer;
  lblSegundos: TLabel;
  procedure TimerEncontraBotaoTimer(Sender: TObject);
  procedure FormCreate(Sender: TObject);
 private
  { Private declarations }
 public
  Botao: string;
  Titulo: string;
  Parametro: string;
  Segundos: Real;
  { Public declarations }
 end;
 
const
 Separador = '###';
 
var
 Form1: TForm1;
 
implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
 Parametro := ParamStr(1);
 Titulo := Copy(Parametro, 0, Pos(Separador, Parametro) - 1);
 Botao := Copy(
  {}Parametro,
  {}Pos(Separador, Parametro) + Length(Separador),
  {}Length(Parametro) - (Pos(Separador, Parametro) + Length(Separador) - 1)
  );
 Segundos := 0;
 TimerEncontraBotao.Enabled := true;
end;

function EnumChildProc(Wnd: hWnd; SL: TStrings): BOOL; stdcall;
var
 szFull: array[0..MAX_PATH] of Char; //Buffer for window caption
begin
 Result := Wnd <> 0;
 if Result then
  begin
   GetWindowText(Wnd, szFull, SizeOf(szFull)); // put window text in buffer
   if (Pos(SL[0], StrPas(szFull)) > 0) // Test for text
   and (SL.IndexOfObject(TObject(Wnd)) < 0) // Test for duplicate handles
   then SL.AddObject(StrPas(szFull), TObject(Wnd)); // Add item to list
   EnumChildWindows(Wnd, @EnumChildProc, Longint(SL)); //Recurse into child windows
  end;
end;

function ClickButton(ParentWindow: Hwnd; ButtonCaption: string): Boolean;
var
 SL: TStringList;
 H: hWnd;
begin
 SL := TStringList.Create;
 try
  SL.AddObject(ButtonCaption, nil);
  EnumChildWindows(ParentWindow, @EnumChildProc, Longint(SL));
  H := 0;
  case SL.Count of
   2: H := hWnd(SL.Objects[1]);
  end;
 finally
  SL.Free;
 end;
 Result := H <> 0;
 if Result then
  PostMessage(H, BM_CLICK, 0, 0);
end;

procedure TForm1.TimerEncontraBotaoTimer(Sender: TObject);
begin
 Segundos := Segundos + 0.5;
 lblSegundos.Caption := FloatToStr(Trunc(Segundos)) + 's';
 if Segundos = 15.5 then
  Application.Terminate;
 if (Trim(Titulo) = '') or (Trim(Botao) = '') then
  Application.Terminate;
 
 if ClickButton(FindWindow(0, PChar(Titulo)), Botao) = true then
  begin
   (Sender as TTimer).Enabled := false;
   Application.Terminate;
  end;
end;

end.

