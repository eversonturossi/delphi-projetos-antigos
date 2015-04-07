unit OOPClasses;

interface

    Uses Windows;

Type
  //declaracao de novos tipos para mostrar como se declarao novos tipo no Delphi.
  TIconType = (itInformation, itWarning, itStop, itQuestion);
  TOperationType = (otSoma, otSubtracao, otMultplicacao, otDivisao);

  //essa declaracao é a mesma coisa que
       {TOOPClass = Class(TObject)}
  //o Delphi Subentende que estamos descendendo de TObject.
  TOOPClass = Class
     Private
              //metodo encapsulado pela Classe TOOPClass.
       {Somente poderemos utilizar este metodo dentro desta Classe.}
       procedure ChooseIconMessage(const BodyMsg,
                                         CaptionMsg : String;
                                   const IconType : TIconType);
     //---------------------------------
     // Seção  Privada à TOOPClass.   //
     //---------------------------------
     Protected
       //metodo protegido, somente os descendentes poderao utilizar este metodo.
       procedure ChooseOperation(const X,
                                       Y : Extended;
                                       Operation : TOperationType); virtual;
     //---------------------------------
     // Seção  Protegida              //
     //---------------------------------
     Public
       procedure ShowMessageEx(const stBodyMsg,
                                     stCaptionMsg : String;
                               const itIconType : TIconType);

     //---------------------------------
     // Seção  Publica                //
     //---------------------------------
     Published
     //---------------------------------
     // Seção  Publicada              //
     //---------------------------------

  end;//TOOPClass.


  //classe descendente de TOOPClass, com isso ela herda quase tudo da classe ancestral.
  TOOPClassDescendente = Class(TOOPClass)
     Private
     //---------------------------------
     // Seção  Privada à TOOPClass.   //
     //---------------------------------
     Protected
     //---------------------------------
     // Seção  Protegida              //
     //---------------------------------
     Public
        procedure ChooseOperation(const X,
                                        Y: Extended;
                                        Operation: TOperationType); override;
     //---------------------------------
     // Seção  Publica                //
     //---------------------------------
     Published
     //---------------------------------
     // Seção  Publicada              //
     //---------------------------------

  end;//TOOPClassDescendente


implementation

  uses SysUtils;

{ TOOPClass }
procedure TOOPClass.ChooseIconMessage(const BodyMsg : String;
                                      const CaptionMsg : String;
                                      const IconType: TIconType);
begin
  case IconType of
    itInformation : MessageBox(0,
                               PChar(BodyMsg),
                               PChar(CaptionMsg),
                               MB_ICONINFORMATION);
    itWarning     : MessageBox(0,
                               PChar(BodyMsg),
                               PChar(CaptionMsg),
                               MB_ICONWARNING);
    itStop        : MessageBox(0,
                             PChar(BodyMsg),
                             PChar(CaptionMsg),
                             MB_ICONSTOP);
    itQuestion    : MessageBox(0,
                               PChar(BodyMsg),
                               PChar(CaptionMsg),
                               MB_ICONQUESTION);
  end;//case.
end;

procedure TOOPClass.ChooseOperation(const X,
                                          Y: Extended;
                                          Operation: TOperationType);
var
  Result : Extended;
begin
  //incializando o variavel.
  Result := 0;

  //escolha a operacao...
  case Operation of
    otSoma        : Result := X + Y;
    otSubtracao   : Result := X - Y;
    otMultplicacao: Result := X * Y;
    otDivisao     : Result := X / Y;
  end;//case.

   //exiba o resultado da operacao.
   MessageBox(0,
              PChar(FloatToStr(Result)),
             'ChooseOperation',
             MB_ICONINFORMATION);

end; //function.

procedure TOOPClass.ShowMessageEx(const stBodyMsg,
                                        stCaptionMsg: String;
                                  const itIconType: TIconType);
begin
  ChooseIconMessage(stBodyMsg,
                    stCaptionMsg,
                    itIconType);
end;//

{   inherited;

{ TOOPClassDescendente }

procedure TOOPClassDescendente.ChooseOperation(const X,
                                                     Y: Extended;
                                                     Operation: TOperationType);
begin
  //herdamos a codificacao do metodo ancestral....
  inherited;
  //exibimos uma mensagem, que sera somente executada no final
  //da execucao do metodo ancestral.
  ShowMessageEx('Completamos a Operacao com Sucesso.'
                +#13+#10+
                'Está Messagem é da Classe Ancestral [ TOOPClass ]...',
                'TOOPClassDescendente',
                itInformation);
end;

end.
