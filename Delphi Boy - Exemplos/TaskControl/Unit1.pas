
{ Fontes por Glauber A. Dantas - glauber@delphix.com.br }
{ 14/02/2004                                            }

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Commctrl, uProcessMemMgr;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Button2: TButton;
    Memo1: TMemo;
    Button3: TButton;
    Button4: TButton;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
    Buf : PChar;
    index : Integer;
    Item: TTCItem;
    PrItem: PTCItem;
    Buffer: array[0..255] of Char;

implementation

uses Unit2;

{$R *.DFM}

procedure TForm1.Button2Click(Sender: TObject);
var
  h : HWND;
begin
  h := FindWindow('Shell_TrayWnd', nil);
  if h <> 0 then h := FindWindowEx(h, 0, 'ReBarWindow32', nil);
  if h <> 0 then h := FindWindowEx(h, 0, 'MSTaskSwWClass', nil);
  if h <> 0 then h := FindWindowEx(h, 0, 'SysTabControl32', nil);
  if h <> 0 then
  begin
     ShowMessage(inttostr(SendMessage(h,TCM_GETITEMCOUNT,0,0)));

     Index := 0;
     Item.Mask := TCIF_TEXT;
     Item.pszText := Buffer;
     Item.cchTextMax := SizeOf(Buffer);

     if SendMessage(h, TCM_GETITEM, Index, Longint(@Item)) = 0
            // Explorer crashes here
      then showmessage('Doezn''t work')
      else ShowMessage(Item.pszText);
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  h: HWND;
  C, i: integer;
  Info: _TBBUTTON;
  Buff: PChar;
  S: array[0..255] of char;
  Rct: TRect;
  PID: THandle;
  PRC: THandle;
  R: Cardinal;
begin
  h := FindWindow('Shell_TrayWnd', nil);
  if h <> 0 then h := FindWindowEx(h, 0, 'ReBarWindow32', nil);
  if h <> 0 then h := FindWindowEx(h, 0, 'MSTaskSwWClass', nil);
  if h <> 0 then h := FindWindowEx(h, 0, 'SysTabControl32', nil);
  if H = 0 then Exit;
  C := SendMessage(H, TCM_GETITEMCOUNT, 0, 0);
  PID := 0;
  GetWindowThreadProcessId(H, @PID);
  PRC := OpenProcess(PROCESS_VM_OPERATION or PROCESS_VM_READ or PROCESS_VM_WRITE, False, PID);
  Buff := VirtualAllocEx(PRC, nil, 4096, MEM_RESERVE or MEM_COMMIT, PAGE_READWRITE);

  for i := 0 to C - 1 do //******************************
  begin
      // fill our pattern
      FillChar(Item, SizeOf(TTCItem), 0);
      WriteProcessMemory(PRC, Buff, @Item, SizeOf(Item), R);
     Item.Mask := TCIF_TEXT;
     Item.pszText := Buffer;
     Item.cchTextMax := SizeOf(Buffer);

      if SendMessage(H, TCM_GETITEM, i, LongInt(@Item)) <> 0 then
      begin
       ReadProcessMemory(PRC, Buff, @Info, SizeOf(Info), R);
        // read back the result
        //PrMM.Read(PrItem, Item, SizeOf(TTCItem));
        Form1.Memo1.Lines.Add(Item.pszText);
      end
      else
      begin
        Form1.Memo1.Lines.Add('??');
      end;


    //    SendMessage(H, TB_GETBUTTONTEXT, Info.idCommand,integer(integer(@Buff[0]) + SizeOf(Info)));
    //    ReadProcessMemory(PRC, Pointer(integer(@Buff[0]) + SizeOf(Info)),@S[0], SizeOf(S), R);
  end;  //**************************
  VirtualFreeEx(PRC, Buff, 0, MEM_RELEASE);
  CloseHandle(PRC);

end;

procedure TForm1.Button4Click(Sender: TObject);
var
  W: HWND;
  C, i: Integer;
  PrMM: TProcessMemMgr;
begin
  W := FindWindow('Shell_TrayWnd', nil);
  W := FindWindowEx(W, 0, 'ReBarWindow32', nil);
  W := FindWindowEx(W, 0, 'MSTaskSwWClass', nil);
  W := FindWindowEx(W, 0, 'SysTabControl32', nil);
  {Em win 2003 usa 'ToolbarWindow32'
   Em win9x/nt/xp/2k usa 'SysTabControl32' }

  if W = 0 then
    raise Exception.Create('Taskbar não encontrada');

  Memo1.Clear;
    
  // create process memory manager
  PrMM := CreateProcessMemMgrForWnd(W);
  try
      // get memory in the Explorers space
      PrItem := PrMM.AllocMem(SizeOf(TTCItem));
      // loop through all items
      C := SendMessage(W, TCM_GETITEMCOUNT, 0, 0);
      for i := 0 to C - 1 do
      begin
        FillChar(Item, SizeOf(TTCItem), 0);
        Item.Mask := TCIF_PARAM;

        // copy into the explorer space
        PrMM.Write(Item, PrItem, SizeOf(TTCItem));
        // actually call the function
        if SendMessage(W, TCM_GETITEM, i, LongInt(PrItem)) <> 0 then
        begin
          // read back the result
          PrMM.Read(PrItem, Item, SizeOf(TTCItem));


          //limpa Buffer
           FillChar(Buffer, SizeOf(Buffer), 0);
          //captura texto do botão
          GetWindowText(Item.lParam,Buffer,255);
          //compara titulos do botao com o text do Edit1
          if AnsiUpperCase(StrPas(Buffer)) = AnsiUpperCase(Edit1.Text) then
          if CheckBox1.Checked then
            ShowWindow(Item.lParam, SW_HIDE)//se quer esconder
          else
            ShowWindow(Item.lParam, SW_SHOW);//se quer mostrar
            
          Memo1.Lines.Add(IntToStr(Item.lParam)+' - '+ StrPas(Buffer));
      end
      else
      begin
          Memo1.Lines.Add('??');
      end;
    end;
  finally
    PrMM.Free;
  end;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Form2.Show;
end;

end.
