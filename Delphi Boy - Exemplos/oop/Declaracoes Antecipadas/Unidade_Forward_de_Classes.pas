unit Unidade_Forward_de_Classes;

interface

   Uses Classes, SysUtils, DbTables;

type

  //declaracao FORWARD da ClasseBase...
  TClasseBase = Class;

  TCalculateClass = class
     Private
       //campo interno do Tipo da Classebase...
       FClassBase : TClassebase;
       //campos internos manipuladores da Base e do Exponente...
       FBase     : Extended;
       FExpoente : Integer;

       //---------------------------------
       // Seção  Privada à TOOPClass.   //
       //---------------------------------
     Protected
       function SetValue : Extended;
       //---------------------------------
       // Seção  Protegida              //
       //---------------------------------
     Public
       constructor Create;
       destructor Destroy; override;
       //---------------------------------
       // Seção  Publica                //
       //---------------------------------
     Published
       property Base        : Extended read FBase     write FBase;
       property Expoente    : Integer  read FExpoente write FExpoente;
       property ResutlValue : Extended read SetValue;
       //---------------------------------
       // Seção  Publicada              //
       //---------------------------------

  end;//

  TClasseBase = Class
     Private
       //---------------------------------
       // Seção  Privada à TOOPClass.   //
       //---------------------------------
     Protected
       function ResultPowerEx(const Base: Extended; Expoente: Integer): Extended;
       //---------------------------------
       // Seção  Protegida              //
       //---------------------------------
     Public
       constructor Create(AOwner : TObject); reintroduce;
       destructor Destroy; override;
       //---------------------------------
       // Seção  Publica                //
       //---------------------------------
     Published
       //---------------------------------
       // Seção  Publicada              //
       //---------------------------------

  end;//

implementation

{ TClasseBase }

//*******************************************************************//
// METODO :  Create                                                  //
// AUTOR, DATA : Roberto, 28/10/2002                                 //
// DESCRIÇÃO : instanciar novos objetos e/ou iniciar valores....     //
//*******************************************************************//
constructor TClasseBase.Create(AOwner : TObject);
begin
end;

//*******************************************************************//
// METODO : Destroy                                                  //
// AUTOR, DATA : Roberto, 28/10/2002                                 //
// DESCRIÇÃO : Liberar um objeto instanciado e/ou reinicalizar valor.//
//*******************************************************************//
destructor TClasseBase.Destroy;
begin
end;

//*******************************************************************//
// METODO : ResultPowerEx                                            //
// AUTOR, DATA : Roberto, 28/10/2002                                 //
// DESCRIÇÃO : Calcular o Exponencial de um Numero...                //
//*******************************************************************//
function TClasseBase.ResultPowerEx(const Base: Extended; Expoente: Integer): Extended;
var
   Index  : integer;
   exBase : Extended;
begin

  //pegamos a base passada como parametro...
  exBase := 1;

  //caso o Exponente seja...
  case Expoente of
    //Zero(0) entao Resulte 1.
    0 : begin
          Result := 1;
          //sai.
          Exit;
        end;//

  end;//case-of.

  //precorre de q ate o valor do expoente...
  for index := 1 to Expoente do
    //calculando a base
    exBase := exBase * Base;

  //resultando o valor calculado.
  Result := exBase;

end;

{ TCalculateClass }

constructor TCalculateClass.Create;
begin
  FClassBase := TClasseBase.Create(Self);
end;

destructor TCalculateClass.Destroy;
begin
  //liberando a Classe Base que se tornou Filha de TCalculateClass...
  FClassBase.Free;
end;

//*******************************************************************//
// METODO : SetValue                                                 //
// AUTOR, DATA : Roberto, 28/10/2002                                 //
// DESCRIÇÃO : Setar a propriedade ResultValue....                   //
//*******************************************************************//
function TCalculateClass.SetValue : Extended;
begin

   //se temos as propriedades preenchidas entao...
   if (Base <> 0) and (Expoente <> 0) then
     //calculamos o valor do Exponencial...
     Result := FClassBase.ResultPowerEx(Base, Expoente)
   else
     raise Exception.Create('Não Podemos continuar com o Cálculo.'+#13+#10+
                            'Para isso preencha as propriedades Base e Expoente...');
end;

end.

