unit Unidade_C;

interface

type
   TClass_A = Class
     Private
     Protected
     Public
       procedure ShowClassName(const Msg : String);
       class procedure Soma;
     Published
   end;//

implementation

  //declarando essa Unidade nesta secao da Unidade_A, outra unidade que possa acessar
  //a Unidade_A nao mais vai poder se utilizar do conteudo da Unidade " Windows ".
  Uses Windows;

{ TClass_C }

procedure TClass_A.ShowClassName(const Msg : String);
begin
   //mostramos o nome da classe desse objeto.
   MessageBox(0,
              PChar(Msg),
              'Class Name',
              MB_ICONINFORMATION);
end;//

class procedure TClass_A.Soma;
begin
 MessageBox(0,
           '1 + 2 = 3',
           'Unidade_C',
           MB_ICONINFORMATION);
end;

end.
