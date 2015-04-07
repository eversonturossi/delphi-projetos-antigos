unit uDetectaPixelsVisinhos;

interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
 Dialogs, StdCtrls, ExtCtrls;

type
 TForm1 = class(TForm)
  Button1: TButton;
  procedure Button1Click(Sender: TObject);
 private
  { Private declarations }
 public
  { Public declarations }
 end;
 
var
 Form1: TForm1;
 
implementation

{$R *.dfm}

function PixelsProximos(I: TBitmap): integer;
var
 P: integer;
 c: TColor;
begin
 P := 0;
 C := clBlack;
 if I.Canvas.Pixels[0, 0] = C then P := P + 1;
 if I.Canvas.Pixels[0, 1] = C then P := P + 1;
 if I.Canvas.Pixels[0, 2] = C then P := P + 1;
 if I.Canvas.Pixels[1, 0] = C then P := P + 1;
 if I.Canvas.Pixels[1, 1] = C then P := P + 1;
 if I.Canvas.Pixels[1, 2] = C then P := P + 1;
 if I.Canvas.Pixels[2, 0] = C then P := P + 1;
 if I.Canvas.Pixels[2, 1] = C then P := P + 1;
 if I.Canvas.Pixels[2, 2] = C then P := P + 1;
 Result := P;
end;

procedure EncontraCirculoAberto(IMG: TBitmap);
var
 PVertical, PHorizontal: integer;
 IMG3x3: TBitmap;
begin
 for PVertical := 1 to IMG.Height - 2 do
  for PHorizontal := 1 to IMG.Width - 2 do
   begin
    if IMG.Canvas.Pixels[PHorizontal, PVertical] = ClBlack then
     begin
      IMG3x3 := TBitmap.Create;
      IMG3x3.Width := 3;
      IMG3x3.Height := 3;

      IMG3x3.Canvas.Pixels[0, 0] := IMG.Canvas.Pixels[PHorizontal - 1, PVertical - 1];
      IMG3x3.Canvas.Pixels[0, 1] := IMG.Canvas.Pixels[PHorizontal - 1, PVertical];
      IMG3x3.Canvas.Pixels[0, 2] := IMG.Canvas.Pixels[PHorizontal - 1, PVertical + 1];
      IMG3x3.Canvas.Pixels[1, 0] := IMG.Canvas.Pixels[PHorizontal, PVertical - 1];
      IMG3x3.Canvas.Pixels[1, 1] := IMG.Canvas.Pixels[PHorizontal, PVertical];
      IMG3x3.Canvas.Pixels[1, 2] := IMG.Canvas.Pixels[PHorizontal, PVertical + 1];
      IMG3x3.Canvas.Pixels[2, 0] := IMG.Canvas.Pixels[PHorizontal + 1, PVertical - 1];
      IMG3x3.Canvas.Pixels[2, 1] := IMG.Canvas.Pixels[PHorizontal + 1, PVertical];
      IMG3x3.Canvas.Pixels[2, 2] := IMG.Canvas.Pixels[PHorizontal + 1, PVertical + 1];
      IMG3x3.SaveToFile('3x3.bmp');
      if PixelsProximos(IMG3x3) = 2 then
       ShowMessage('Posicao aberta: ' + IntToStr(PHorizontal) + ' x' + IntToStr(PVertical));
      IMG3x3.Free;
     end;
   end;   
end;


procedure EncontraCirculoAberto2(IMG: TBitmap);
var
 PVertical, PHorizontal: integer;
 IMG3x3: TBitmap;
begin
 for PVertical := 1 to IMG.Height - 2 do
  for PHorizontal := 1 to IMG.Width - 2 do
   begin
    if IMG.Canvas.Pixels[PHorizontal, PVertical] = ClBlack then
     begin
      IMG3x3 := TBitmap.Create;
      IMG3x3.Width := 3;
      IMG3x3.Height := 3;
      IMG3x3.Canvas.Pixels[0, 0] := IMG.Canvas.Pixels[PHorizontal - 1, PVertical - 1];
      IMG3x3.Canvas.Pixels[0, 1] := IMG.Canvas.Pixels[PHorizontal - 1, PVertical];
      IMG3x3.Canvas.Pixels[0, 2] := IMG.Canvas.Pixels[PHorizontal - 1, PVertical + 1];
      IMG3x3.Canvas.Pixels[1, 0] := IMG.Canvas.Pixels[PHorizontal, PVertical - 1];
      IMG3x3.Canvas.Pixels[1, 1] := IMG.Canvas.Pixels[PHorizontal, PVertical];
      IMG3x3.Canvas.Pixels[1, 2] := IMG.Canvas.Pixels[PHorizontal, PVertical + 1];
      IMG3x3.Canvas.Pixels[2, 0] := IMG.Canvas.Pixels[PHorizontal + 1, PVertical - 1];
      IMG3x3.Canvas.Pixels[2, 1] := IMG.Canvas.Pixels[PHorizontal + 1, PVertical];
      IMG3x3.Canvas.Pixels[2, 2] := IMG.Canvas.Pixels[PHorizontal + 1, PVertical + 1];
      IMG3x3.SaveToFile('3x3.bmp');
      if PixelsProximos(IMG3x3) = 2 then
       ShowMessage('Posicao aberta: ' + IntToStr(PHorizontal) + 'x' + IntToStr(PVertical));
      IMG3x3.Free;
     end;
   end;   
end;


procedure TForm1.Button1Click(Sender: TObject);
var
 imagem: TBitmap;
begin
 imagem := TBitmap.Create;
 
 imagem.LoadFromFile('teste.bmp');
 //Image1.Canvas.Assign(imagem.Canvas);
 EncontraCirculoAberto(imagem);
 imagem.free;
 
 //Image1.AutoSize := true;
end;


end.

