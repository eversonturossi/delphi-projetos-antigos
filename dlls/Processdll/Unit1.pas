unit Unit1;

interface

uses
 Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
 StdCtrls, Grids, Buttons, TLHelp32, ExtCtrls;

type
 TForm1 = class(TForm)
  StringGrid1: TStringGrid;
  Label1: TLabel;
  Label2: TLabel;
  Label3: TLabel;
  Label4: TLabel;
  Label5: TLabel;
  Timer1: TTimer;
  Panel1: TPanel;
  BitBtn1: TBitBtn;
  BitBtn2: TBitBtn;
  BitBtn3: TBitBtn;
  RadioGroup1: TRadioGroup;
  procedure BitBtn3Click(Sender: TObject);
  procedure FormCreate(Sender: TObject);
  procedure BitBtn2Click(Sender: TObject);
  procedure BitBtn1Click(Sender: TObject);
  procedure Timer1Timer(Sender: TObject);
  procedure RadioGroup1Click(Sender: TObject);
 private
  { Private declarations }
 public
  { Public declarations }
 end;
 
var
 Form1: TForm1;
 
implementation

{$R *.DFM}

procedure TForm1.BitBtn3Click(Sender: TObject);
var
 SnapShot: THandle;
 pe: TModuleEntry32;
 ii: integer;
begin
 // lista os processos no grid
 ii := 1;
 SnapShot := CreateToolhelp32Snapshot((TH32CS_SNAPMODULE), 0);
 pe.dwSize := sizeof(TModuleEntry32);
 Module32First(SnapShot, pe);
 repeat
  if (StringGrid1.RowCount < ii + 1) then
   StringGrid1.RowCount := ii + 1;
  StringGrid1.Cells[0, ii] := format('%x', [pe.th32ModuleID]);
  StringGrid1.Cells[1, ii] := IntToStr(pe.dwSize);
  StringGrid1.Cells[2, ii] := string(pe.szModule);
  inc(ii);
 until Module32Next(SnapShot, pe) = false;
 StringGrid1.RowCount := ii;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 // inicializa o grid
 StringGrid1.Cells[0, 0] := 'Processo';
 StringGrid1.Cells[1, 0] := 'path';
 StringGrid1.Cells[2, 0] := 'Programa';
 BitBtn3Click(nil);
end;

procedure TForm1.BitBtn2Click(Sender: TObject); // Perfeito
var
 processo: dword;
 i: integer;
 ss: string;
begin
 // mata o processo selecionado
 processo := 0;
 with StringGrid1 do
  begin
   if (Row < 1) then // sai se naum houver processo selecionado
    exit;
   ss := Cells[0, Row];
   // Converte a string em dword
   for i := 1 to length(ss) do
    begin
     processo := processo shl 4;
     if ord(ss[i]) >= ord('A') then
      processo := processo + (ord(ss[i]) - ord('A') + 10)
     else
      processo := processo + (ord(ss[i]) - ord('0'));
    end;
   //Mata o Processo
   try
    TerminateProcess(OpenProcess($0001, false, processo), 0); // $0001 = Process_Terminate.
   except
    showmessage('Falha ao tentar matar o processo ' + Cells[0, Row]);
   end;
   BitBtn3Click(nil);
  end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
 close;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 BitBtn3Click(nil);
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
 Timer1.Enabled := (RadioGroup1.ItemIndex = 1)
end;

end.

