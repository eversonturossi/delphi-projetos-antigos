function InputName(var Nome: string): boolean;
//
// cria uma caixa de dialogo para entrada de dados
//
// Esta função retorna true se for pressionado OK e false
// em caso contrário. Se for OK, o texto digitado pelo usuário
//   será copiado para a variável Nome
//
// Exemplo:
//
// var
//   S: string;
// begin
//   if ObterNome(S) then
//     Edit1.Text := S;
//

var
  Form: TForm; { Variável para o Form }
  Edt: TEdit; { Variável para o Edit }
begin
  Result := false; { Por padrão retorna false }
  { Cria o form }
  Form := TForm.Create(Application);
  try
    { Altera algumas propriedades do Form }
    Form.BorderStyle := bsDialog;
    Form.Caption := 'Atenção';
    Form.Position := poScreenCenter;
    Form.Width := 200;
    Form.Height := 150;
    { Coloca um Label }
    with TLabel.Create(Form) do begin
      Parent := Form;
      Caption := 'Digite seu nome:';
      Left := 10;
      Top := 10;
    end;
    { Coloca o Edit }
    Edt := TEdit.Create(Form);
    with Edt do begin
      Parent := Form;
      Left := 10;
      Top := 25;
      { Ajusta o comprimento do Edit de acordo com a largura
        do form }
      Width := Form.ClientWidth - 20;
    end;
    { Coloca o botão OK }
    with TBitBtn.Create(Form) do begin
      Parent := Form;
      { Posiciona de acordo com a largura do form }
      Left := Form.ClientWidth - (Width * 2) - 20;
      Top := 80;
      Kind := bkOK; { Botão Ok }
    end;
    { Coloca o botão Cancel }
    with TBitBtn.Create(Form) do begin
      Parent := Form;
      Left := Form.ClientWidth - Width - 10;
      Top := 80;
      Kind := bkCancel; { Botão Cancel }
    end;
    { Exibe o form e aguarda a ação do usuário. Se for OK... }
    if Form.ShowModal = mrOK then begin
      Nome := Edt.Text;
      Result := true;
    end;
  finally
    Form.Free;
  end;
end;
