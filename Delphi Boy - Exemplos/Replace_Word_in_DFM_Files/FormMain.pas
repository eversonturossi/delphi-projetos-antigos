//*********************************************************//
//      (*) COMUNIDADE DE PROGRAMAÇÃO #DelphiX (*)         //
//                                                         //
// FILOSOFIA DA COMUNIDADE : Disseminar(Expalhar) o Nosso  //
// Conhecimento para que assim a programação possa melhorar//
// com novas idéias e melhores profissionais.              //
//                                                         //
// PROJETO DESENVOLVIDO POR _CR4SH_, MEMBRO DO #DelphiX    //
// DESDE AGOSTO DE 2001                                    //
//*********************************************************//
// Nick : _Cr4sh_                                          //
// Nome Programador : José Roberto Ferreira de Araújo Jr.  //
// Data da Implementacao : 30/12/2002                      //
// Rede IRC : Brasnet                                      //
// Contato  : jroberto_jr@lycos.com ou webdelphi@lycos.com //
//---------------------------------------------------------//
// OBS.:  TODOS OS DIREITOS RESERVADOS                     //
//---------------------------------------------------------//
//*********************************************************//
unit FormMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ComCtrls, StdCtrls, ExtCtrls, Buttons;

type
  TMainForm = class(TForm)
    ListBoxFiles: TListBox;
    Label1: TLabel;
    StatusBar1: TStatusBar;
    MainMenu: TMainMenu;
    OpenFiles1: TMenuItem;
    Open1: TMenuItem;
    About1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    OpenDialogFiles: TOpenDialog;
    GroupBox1: TGroupBox;
    EditNewWord: TEdit;
    EditOldWord: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    PageControlContentFiles: TPageControl;
    CheckBoxSelectAll: TCheckBox;
    AutomaticSave1: TMenuItem;
    PopupMenu: TPopupMenu;
    PopupSaveModifies1: TMenuItem;
    N2: TMenuItem;
    ReplaceWordinDFMFiles1: TMenuItem;
    About2: TMenuItem;
    ListBoxFileNames: TListBox;
    Label4: TLabel;
    procedure Open1Click(Sender: TObject);
    procedure ListBoxFilesClick(Sender: TObject);
    procedure ButtonSubstituteClick(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure PageControlContentFilesChange(Sender: TObject);
    procedure CheckBoxSelectAllClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure AutomaticSave1Click(Sender: TObject);
    procedure PopupSaveModifies1Click(Sender: TObject);
  private
    //*
    inPageIndex : Integer;
    //*
    mmMemoOldContentFile,
    mmMemoNewContentFile  : TMemo;
//    function GetFileNames(const ATextValue : string) : TStringList;
    procedure SaveAllFilesModifies;
    procedure SetNewContentFile(const APageControl : TPageControl; AStringList : TStringList);
    procedure SetTabSheets(const AFileNames : TStrings{TStringList});
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses FormAbout;

{$R *.DFM}

//*******************************************************************//
// AUTOR, Nick : Roberto, _Cr4sh_                                    //
// DATA : 14/03/2003                                                 //
// DESCRIÇÃO : Lista os Nomes dos Arquivos com seus Diretorios no    //
//             ListBox.                                              //
//*******************************************************************//
procedure TMainForm.Open1Click(Sender: TObject);
begin
  //fomos executados?
  if OpenDialogFiles.Execute then
    //pegamos todos os arquivos que foram selecionados
    //no OpenDialogFiles.
    ListBoxFiles.Items := OpenDialogFiles.Files;
  //habilitamos o CheckBox, isso se o ListBox contiver Items. 
  CheckBoxSelectAll.Enabled := ListBoxFiles.Items.Count > 0
end;//Open1Click.

//*******************************************************************//
// AUTOR, Nick : Roberto, _Cr4sh_                                    //
// DATA : 14/03/2003                                                 //
// DESCRIÇÃO : setamos o(s) nome(s) do(s) arquivo(s) no Painel do    //
//             StatusBar.                                            //
//*******************************************************************//
procedure TMainForm.ListBoxFilesClick(Sender: TObject);
var
  //*
  SimpleTextTemp        : string;
  //*
  inIndex               : Integer;
  //*
//  slStringListFileNames : TStringList;
begin
  //com o Primeiro Painel do StattusBar Faça.
  with StatusBar1 do
  begin
    //com o ListBoxFiles faça.
    with ListBoxFiles do
    begin
      //a quantidade de itens selecionados é igual a quantidade total de items?
      //e nao estamos com o CheckBox Marcado?
      if (SelCount = Items.Count) and not CheckBoxSelectAll.Checked then
        //sim, entao marcamos de acordo com as condicoes,
        CheckBoxSelectAll.Checked := True;
      //temos algum Item Selecionado?
      if SelCount > 0 then
      begin
        //Habilitamos o CheckBox.
        CheckBoxSelectAll.Enabled := True;
        //percorremos todos os Items do ListBoxFiles.
        for inIndex := 0 to Items.Count - 1 do
        begin
          //este item esta selecionado?
          if Selected[inIndex] then
            //concatenamos ele com os nomes dos arquivos.
            SimpleTextTemp :=  SimpleTextTemp + ', ' + ExtractFileName(Items[inIndex])
        end;//for-do.
        //apagamos o primeiro ",".
        Delete(SimpleTextTemp, 1, 1);
        //pegamos os nomes dos arquivos selecionados.
        ListBoxFileNames.Items.CommaText := SimpleTextTemp;
        //informamos a quantidade de items escolhidos.
        Panels[1].Text := 'Amount Selected Items: ' + IntToStr(ListBoxFileNames.Items.Count);
      end//if-then.
      //senao.
      else begin
        //ainda estamos selecionados?
        if CheckBoxSelectAll.Checked then
          //sim, entao desmarque-me.
          CheckBoxSelectAll.Checked := False;
        //limpamos o conteudo do ListBox.
        ListBoxFileNames.Items.Clear;
        //formatamos o Texto do Segundo Painel do StatusBar.
        Panels[1].Text := 'Amount Selected Items: 0';
      end;//else.
    end;//with-do.
   //temos algum arquivo no ListBox?
   if ListBoxFileNames.Items.Count > 0 then
     //Setamos os TabSheets com o(s) Nome(s) do(s) arquivo(s).
     SetTabSheets(ListBoxFileNames.Items);
   //senao.
   if ListBoxFiles.SelCount = 0 then
   begin
    //com o nosso PageControl faça.
     with PageControlContentFiles do
     begin
       //percorra todas as suas Abas.
       for inIndex := 0 to PageCount - 1 do
         //Libere essa Aba.
         Pages[ActivePageIndex].Free;
     end;//with-do.
   end;//if-then.
  end;//with-do.
  //pegamos o Indice da Primeira Página Ativa no PageControl.
  inPageIndex := PageControlContentFiles.ActivePageIndex;
end;//ListBoxFilesClick.

//*******************************************************************//
// AUTOR, Nick : Roberto, _Cr4sh_                                    //
// DATA : 14/03/2003                                                 //
// DESCRIÇÃO : Executamos as substituicoes das palavras.             //
//*******************************************************************//
procedure TMainForm.ButtonSubstituteClick(Sender: TObject);
var
  //*
  inIndex,
  inIndex2,
  PosOldTextInLine : Integer;
  //*
  strLines,
  strNewWord,
  strOldWord       : string;
  //*
  slDFMContent     : TStringList;
begin
  //inicializamos o Objeto.
  slDFMContent := nil;

  try
    //estamos preenchidos?
    if (Trim(EditNewWord.Text) <> '') and (Trim(EditOldWord.Text) <> '') then
    begin
      //pegamos a instancia do Objeto TStringList.
      slDFMContent := TStringList.Create;
      //pegamos a palavra a ser Substituida(EditOldWord)
      //e a nova Palavra(EditNewWord);
      strNewWord := EditNewWord.Text;
      strOldWord := EditOldWord.Text;

      //Com o ListBox faca.
      with ListBoxFiles do
      begin
        //nao temos items selecionados?
        if SelCount = 0 then
        begin
          //exibimos a mensagem de erro.
          MessageBox(Screen.ActiveForm.Handle,
                     'Selected a Archive in the List To We Can Process the Modifies.',
                     'No Items Selected',
                     MB_ICONSTOP);
          //saimos da procedure.
          Exit;
        end;//if-then.
        //percorremos todos os Items(que no nosso caso serao os arquivos) do Listbox.
        for inIndex := 0 to (Items.Count - 1) do
        begin
          //estamos com algum conteudo?
          if slDFMContent.Text <> '' then
            //sim, entao limpe o conteudo do TStringList(slDFMContent).
            slDFMContent.Clear;
          //estou selecionado?
          if Selected[inIndex] then
          begin
            //carregamos o conteudo do arquivo em memoria,
            //nas linhas da variavel TStringList(slDFMContent);
            slDFMContent.LoadFromFile(Items[inIndex]);

            //percorremos todas as linhas do TStringList.
            for inIndex2 := 0 to slDFMContent.Count - 1 do
            begin
              //pegamos o conteudo da linha atual do arquivo.
              strLines := slDFMContent.Strings[inIndex2];
              //pegamos a posicao da palavra antiga dentro da linha.
              PosOldTextInLine := Pos(UpperCase(strOldWord), UpperCase(strLines));
              //realmente encontramos a palavra antiga nessa linha?
              if PosOldTextInLine > 0 then
              begin
                //apagamos a palavra antiga.
                Delete(strLines, PosOldTextInLine, Length(strOldWord));
                //inserimos a nova palavra, na posicao a qual
                //apagamos a palavra antiga.
                Insert(strNewWord, strLines, PosOldTextInLine);
                //
                slDFMContent.Strings[inIndex2] := strLines;
              end;//if-then.
            end;//while-do.
            //queremos que sejamos salvos automaticamente?
            if AutomaticSave1.Checked then
            begin
             //sim, entao salvamos o arquivo e assim sobrepomos o que já existia.
             slDFMContent.SaveToFile(Items[inIndex]);
            end;//if-then.
            //Seta o Conteudo do(s) arquivo(s) alterado(s) no(s) Memo(s).
            SetNewContentFile(PageControlContentFiles,
                              slDFMContent);
          end;//if-then.
        end;//for-do.
      end;//with-do.
    end//if-then.
    //senao.
    else begin
      //exiba a mensagem de erro.
      MessageBox(Screen.ActiveForm.Handle,
                 'Inform the Word to be Substituted and the New Word.',
                 'Incomplete Fields',
                 MB_ICONSTOP);
      //formatamos o Primeiro Painel do StattusBar.
      StatusBar1.Panels[0].Text := 'No Modifies';
      //Liberamos o Objeto.
      slDFMContent.Free;
      //saimos da Procedure
      Exit;
    end;//else;
  finally
    //Liberamos o Objeto.
    slDFMContent.Free;
  end;//try-finally.
  //formatamos o Primeiro Painel do StattusBar.
  StatusBar1.Panels[0].Text := 'Modifies Complete Successfully';
end;//ButtonSubstituteClick.

//*******************************************************************//
// AUTOR, Nick : Roberto, _Cr4sh_                                    //
// DATA : 14/03/2003                                                 //
// DESCRIÇÃO : Chamamos o Formulário Sobre.                          //
//*******************************************************************//
procedure TMainForm.About1Click(Sender: TObject);
begin
  try
    //pegamos a instancia do formulario Sobre.
    AboutForm := TAboutForm.Create(Application);
    //mostramos o formulário de forma Modal.
    AboutForm.ShowModal;
  finally
    //liberamos o formulário.
    AboutForm.Free;
  end;//try-finally.
end;//About1Click.

//*******************************************************************//
// AUTOR, Nick : Roberto, _Cr4sh_                                    //
// DATA : 14/03/2003                                                 //
// DESCRIÇÃO : Execerramos a aplicacao.                              //
//*******************************************************************//
procedure TMainForm.Exit1Click(Sender: TObject);
begin
  //encerramos a aplicacao.
  Application.Terminate;
end;//Exit1Click.

//*******************************************************************//
// AUTOR, Nick : Roberto, _Cr4sh_                                    //
// DATA : 14/03/2003                                                 //
// DESCRIÇÃO : Retorna os Nomes dos arquivos que estao no Status do  //
//             programa dentro de um StringList.                     //
//*******************************************************************//
{function TMainForm.GetFileNames(const ATextValue: string): TStringList;
var
  slStringListTemp : TStringList;
begin
  //nao temos nada no nosso parametro?
  if ATextValue = '' then
  begin
    //iniciamos sem TStringList nenhum.
    Result := nil;
    //sim, entao sai da funcao.
    Exit;
  end;//if-then.
  //pegamos a instancia do Objeto.
  slStringListTemp := TStringList.Create;
  //pegamos o texto do Painel do StatusBar, sendo que
  //essa propriedade tem a capacidade de separar os Texto
  //que tenha separadores como ",", """, "'", maiores
  //detalhes Help On-Line do Delphi.
  slStringListTemp.CommaText := ATextValue;

  //
  Result := slStringListTemp
end;//GetFileNames.}

//*******************************************************************//
// AUTOR, Nick : Roberto, _Cr4sh_                                    //
// DATA : 14/03/2003                                                 //
// DESCRIÇÃO : Cria os TabSheets, Memos de cada TabSheet e os Confi- //
//            gura para que sejam colocados os textos das mudanças   //
//            dos arquivos.                                          //
//*******************************************************************//
procedure TMainForm.SetTabSheets(const AFileNames: TStrings{TStringList});
var
  //*
  tbsTabSheet : TTabSheet;
{  //*
  mmMemoOldContentFile,
  mmMemoNewContentFile  : TMemo;}
  //*
  inIndex     : Integer;
begin
  //temos mais que uma Aba criada?
  if PageControlContentFiles.PageCount > 0 then
    //sim, entao percorremos todas elas.
    for inIndex := 0 to PageControlContentFiles.PageCount - 1 do
      //liberamos a Aba que corresponder com o arquivo Deselecionado.
      PageControlContentFiles.Pages[PageControlContentFiles.ActivePageIndex].Free;

  //percorre nos nomes dos arquivos.
  for inIndex := 0 to AFileNames.Count - 1 do
  begin
    //*
    //pegamos a instancia do Objeto.
    tbsTabSheet             := TTabSheet.Create(PageControlContentFiles);
    //setamos o PageControl do TabSheet para que seja o Nosso PageControl.
    tbsTabSheet.PageControl := PageControlContentFiles;
    //o caption do TabSheet será o nome do arquivo.
    tbsTabSheet.Caption     := AFileNames.Strings[inIndex];
    //setamos um nome para o TabSheet.
    tbsTabSheet.Name        := 'tbsTabSheet' + Copy(AFileNames.Strings[inIndex],1,Pos('.', AFileNames.Strings[inIndex])-1);

    //*
    //pegamos a instancia do Objeto.
    mmMemoOldContentFile        := TMemo.Create(tbsTabSheet);
    //setamos o nosso pai para que seja o TabSheet Instanciado.
    mmMemoOldContentFile.Parent := tbsTabSheet;
    //setamos um nome para o Objeto.
    mmMemoOldContentFile.Name   := 'MemoOldContentFile';
    //setamos o alinhamento dele em relacao ao controle(TabSheet - tbsTabSheet)
    //como sendo à esquerda.
    mmMemoOldContentFile.Align  := alLeft;
    //setamos o tipo do cursor do Memo.
    mmMemoOldContentFile.Cursor := crNo;
    //setamos o Hint do Memo.
    mmMemoOldContentFile.Hint := 'Memo que contem o Texto Antigo do DFM "'+
                                  ExtractFileName(AFileNames.Strings[inIndex])+
                                  '"';
    //mandamos Exibir o Hint.
    mmMemoOldContentFile.ShowHint := True;
    //setamos o Memo como somento Leitura.
    mmMemoOldContentFile.ReadOnly := True;
    //setamos a largura do Memo.
    mmMemoOldContentFile.Width  := 391;
    //setamos a ScrollBar do Memo como sendo somente Vertical.
    mmMemoOldContentFile.ScrollBars := ssVertical;
    //já carregamos o Conteudo desse DFM para dentro desse Memo.
    mmMemoOldContentFile.Lines.LoadFromFile(AFileNames.Strings[inIndex]);
    //adicionamos essa string nessa linha.
    mmMemoOldContentFile.Lines.Add('******************************************************'+
                                   '************');
    //adicionamos o nome do arquivo nessa linha.
    mmMemoOldContentFile.Lines.Add('Fim do Arquivo :: "'+
                                   ExtractFileName(AFileNames.Strings[inIndex])+
                                   '"');
    //adicionamos essa string nessa linha.
    mmMemoOldContentFile.Lines.Add('******************************************************'+
                                   '************');
                                   
    //*
    //pegamos a instancia do Objeto.
    mmMemoNewContentFile        := TMemo.Create(tbsTabSheet);
    //setamos o nosso pai para que seja o TabSheet Instanciado.
    mmMemoNewContentFile.Parent := tbsTabSheet;
    //setamos um nome para o Objeto.
    mmMemoNewContentFile.Name   := 'MemoNewContentFile';
    //setamos o alinhamento dele em relacao ao controle(TabSheet - tbsTabSheet)
    //como sendo à Direita.
    mmMemoNewContentFile.Align  := alRight;
    //setamos o tipo do cursor do Memo.
    mmMemoNewContentFile.Cursor := crNo;
    //setamos o Hint do Memo.
    mmMemoNewContentFile.Hint := 'Memo que contem o Texto Novo do DFM "'+
                                  ExtractFileName(AFileNames.Strings[inIndex])+
                                  '"';
    //mandamos Exibir o Hint.
    mmMemoNewContentFile.ShowHint := True;
    //setamos o Memo para somente Leitura.
    mmMemoNewContentFile.ReadOnly := True;
    //setamos a largura do Memo.
    mmMemoNewContentFile.Width  := 391;
    //setamos a ScrollBar do Memo como sendo somente Vertical.
    mmMemoNewContentFile.ScrollBars := ssVertical;
    //apagamos o conteudo inicial do Memo.
    mmMemoNewContentFile.Clear;
  end;//for-do.
end;//SetTabSheets.

//*******************************************************************//
// AUTOR, Nick : Roberto, _Cr4sh_                                    //
// DATA : 14/03/2003                                                 //
// DESCRIÇÃO : Pegamos o Indice dessa Página.                        //
//*******************************************************************//
procedure TMainForm.PageControlContentFilesChange(Sender: TObject);
begin
  //pegamos o Indice da dessa pagina.
  inPageIndex := PageControlContentFiles.ActivePageIndex
end;//PageControlContentFilesChange.

//*******************************************************************//
// AUTOR, Nick : Roberto, _Cr4sh_                                    //
// DATA : 15/03/2003                                                 //
// DESCRIÇÃO : Marcar/Desmarcar os Items do ListBox.                 //
//*******************************************************************//
procedure TMainForm.CheckBoxSelectAllClick(Sender: TObject);
var
  inIndex : Integer;
begin
  //estamos checados?
  if CheckBoxSelectAll.Checked then
  begin
    //percorremos todos os Items.
    for inIndex := 0 to ListBoxFiles.Items.Count - 1 do
      //selecionamos esse Item.
      ListBoxFiles.Selected[inIndex] := True;
    ListBoxFiles.OnClick(Self);
  end
  //senao.
  else begin
    //percorremos todos os Items.
    for inIndex := 0 to ListBoxFiles.Items.Count - 1 do
      //desmarcamos esse item.
      ListBoxFiles.Selected[inIndex] := False;
    ListBoxFiles.OnClick(Self);
  end;//

end;//CheckBoxSelectAllClick.

//*******************************************************************//
// AUTOR, Nick : Roberto, _Cr4sh_                                    //
// DATA : 15/03/2003                                                 //
// DESCRIÇÃO : Seta os Novos Valores alterados dos arquivos nos res- //
//             pectivos Memos.                                       //
//*******************************************************************//
procedure TMainForm.SetNewContentFile(const APageControl: TPageControl;
                                            AStringList: TStringList);
var
  inIndex,
  inIndex2 : Integer;
begin
  //com nosso PageControl faça.
  with APageControl do
  begin
    //percorremos todas as Abas.
    for inIndex2 := 0 to PageCount - 1 do
    begin
      //percorre todos os controles do PageControl.
      for inIndex := 0 to Pages[inPageIndex].ControlCount - 1 do
      begin
        //o controle do TabSheet desse Item do PageControl é um Controle do tipo TMemo?
        if Pages[inPageIndex].Controls[inIndex] is TMemo then
          //o nosso TMemo tem como Nome(propriedade "Name") 'MemoNewContentFile'?
          if TMemo(Pages[inPageIndex].Controls[inIndex]).Name = 'MemoNewContentFile' then
          begin
            //entao recebemos nosso StringLits que contem os dados já alterados.
            TMemo(Pages[inPageIndex].Controls[inIndex]).Lines := AStringList;
          end;//if-then.
      end;//for-do.
    SelectNextPage(True);  
    end;//for-do.
   end;//with-do.
end;//SetNewContentFile.

//*******************************************************************//
// AUTOR, Nick : Roberto, _Cr4sh_                                    //
// DATA : 15/03/2003                                                 //
// DESCRIÇÃO : Desmarca o CheckBox porque inicialmente nao temos Item//
//*******************************************************************//
procedure TMainForm.FormActivate(Sender: TObject);
begin
  //desabilitamos porque inicialmente nao temos nenhum item.
  CheckBoxSelectAll.Enabled := False;
  //mudamos o caption do formulário.
  Caption := Caption + ' - State [Automatic Saving]';
  //formatamos o Primeiro Painel do StattusBar.
  StatusBar1.Panels[0].Text := 'No Modifies';
  //formatamos o conteudo do segundo Painel do StatusBar.
  StatusBar1.Panels[1].Text := 'Amount Selected Items: 0';
  //Desabilitamos o Salvamento Manual.
  PopupSaveModifies1.Enabled := False;
end;//FormActivate.

//*******************************************************************//
// AUTOR, Nick : Roberto, _Cr4sh_                                    //
// DATA : 15/03/2003                                                 //
// DESCRIÇÃO : Marca/Desmarca o Item Automatic Saving do Menu.       //
//*******************************************************************//
procedure TMainForm.AutomaticSave1Click(Sender: TObject);
begin
  //estamos marcado?
  if AutomaticSave1.Checked then
  begin
    //sim, entao desmarque.
    AutomaticSave1.Checked := False;
    //Habilitamos o Salvamento Manual.
    PopupSaveModifies1.Enabled := True;
    //mudamos o Caption do Formulário.
    Caption := 'Replace Word in DFM Files - State [Manual Saving]';
  end//if-then.
  //senao.
  else begin
    //marque-me.
    AutomaticSave1.Checked := True;
     //Desabilitamos o Salvamento Manual.
     PopupSaveModifies1.Enabled := False;
    //mudamos o Caption do Formulário.
    Caption := 'Replace Word in DFM Files - State [Automatic Saving]';    
  end;//else.
end;//AutomaticSave1Click.

//*******************************************************************//
// AUTOR, Nick : Roberto, _Cr4sh_                                    //
// DATA : 15/03/2003                                                 //
// DESCRIÇÃO : Salva o conteudo de todos os Memos.                   //
//*******************************************************************//
procedure TMainForm.SaveAllFilesModifies;
var
  inIndex,
  inIndex2,
  inFiles : Integer;
begin
  inFiles := 0;
  //com nosso PageControl faça.
  with PageControlContentFiles do
  begin
    //percorremos todoas as Abas.
    for inIndex2 := 0 to PageCount - 1 do
    begin
      //percorre todos os controles do PageControl.
      for inIndex := 0 to Pages[inPageIndex].ControlCount - 1 do
      begin
        //o controle do TabSheet desse Item do PageControl é um Controle do tipo TMemo?
        if Pages[inPageIndex].Controls[inIndex] is TMemo then
          //o nosso TMemo tem como Nome(propriedade "Name") 'MemoNewContentFile'?
          if TMemo(Pages[inPageIndex].Controls[inIndex]).Name = 'MemoNewContentFile' then
          begin
            //entao recebemos nosso StringLits que contem os dados já alterados.
            TMemo(Pages[inPageIndex].Controls[inIndex]).
              Lines.SaveToFile(ListBoxFiles.Items[inFiles]);
            Inc(inFiles, 1);
          end;//if-then.
      end;//for-do.
      //vamos para a proxima Aba.
      SelectNextPage(True);
    end;//for-do.
  end;//with-do.
end;//SaveAllFilesModifies.

//*******************************************************************//
// AUTOR, Nick : Roberto, _Cr4sh_                                    //
// DATA : 15/03/2003                                                 //
// DESCRIÇÃO : Chama a procedure para salvar o conteudo dos Memos.   //
//*******************************************************************//
procedure TMainForm.PopupSaveModifies1Click(Sender: TObject);
begin
  SaveAllFilesModifies;
end;//SaveModifies1Click.

end.
