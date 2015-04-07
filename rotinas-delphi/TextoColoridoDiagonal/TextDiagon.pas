procedure TextDiagon(Const Text: string);
//
// Gera um texto colorido e na diagonal no form
//
// deve ser declarada da seguinte forma:
//
// procedure TForm1.TextDiagon(Const Text: string);
//
var
   logfont:TLogFont;
   font: Thandle;
   count: integer;
begin
       LogFont.lfheight:=20;
       logfont.lfwidth:=20;
       logfont.lfweight:=750;
       LogFont.lfEscapement:=-200;
       logfont.lfcharset:=1;
       logfont.lfoutprecision:=out_tt_precis;
       logfont.lfquality:=draft_quality;
       logfont.lfpitchandfamily:=FF_Modern;

       font:=createfontindirect(logfont);

       Selectobject(Form1.canvas.handle,font);

       SetTextColor(Form1.canvas.handle,rgb(0,0,200));
       SetBKmode(Form1.canvas.handle,transparent);

       for count:=1 to 100 do
       begin
        canvas.textout(Random(form1.width),Random(form1.height),Text);
        SetTextColor(form1.canvas.handle,rgb(Random(255),Random(255),Random
         (255)));
       end;
     Deleteobject(font);
end;
