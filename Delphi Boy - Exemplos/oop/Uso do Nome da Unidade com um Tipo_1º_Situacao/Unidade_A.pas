unit Unidade_A;

interface
   Uses
     SysUtils;
type
   TClass_A = Class
     Private
     Protected
     Public
       procedure ShowClassName(const Obj : TObject);
       class procedure Soma;
     Published
   end;//

implementation

  //declarando essa Unidade nesta secao da Unidade_A, outra unidade que possa acessar
  //a Unidade_A nao mais vai poder se utilizar do conteudo da Unidade " Windows ".
  Uses Windows;

{ TClass_A }

procedure TClass_A.ShowClassName(const Obj: TObject);
var
   ClassName : String;
begin
   //pegamos o nome do Objeto.
   ClassName := Obj.ClassName;

   //mostramos o nome da classe desse objeto.
   MessageBox(0,
              PChar(ClassName),
              'Class Name',
              MB_ICONINFORMATION);
end;//


class procedure TClass_A.Soma;
var
  Soma : Integer;
begin
  Soma := 2 + 3;
  MessageBox(0,
             PChar('A Soma de é: ' + IntToStr(Soma)),
             'Unidade_A',
             MB_ICONINFORMATION);
end;
end.
