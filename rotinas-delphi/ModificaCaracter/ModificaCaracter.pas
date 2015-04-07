function ModificaCaracter(TEXTO:string):string;
//
// Elimina caracteres acentuados de um texto e retorna
// este texto em maiúsculas
//
var
i,tamanho:integer;
Texto_modificado:string;
Caracter:char;
begin
Texto := AnsiUpperCase(Texto);
Tamanho := Length(Texto);
for i :=1 to Tamanho do
    begin
    Caracter := Texto[i];
    case Caracter of
         'À','Á','Ã','Â','Ä': Texto_Modificdo := Texto_Modificdo + 'A';
         'È','É','Ê','Ë': Texto_Modificdo := Texto_Modificdo + 'E';
         'Ì','Í','Î','Ï': Texto_Modificdo := Texto_Modificdo + 'I';
         'Ò','Ó','Õ','Ô','Ö': Texto_Modificdo := Texto_Modificdo + 'O';
         'Ù','Ú','Û','Ü': Texto_Modificdo := Texto_Modificdo + 'U';
         'Ç': Texto_Modificdo := Texto_Modificdo + 'C';
         'Ñ': Texto_Modificdo := Texto_Modificdo + 'N';
         'Ÿ': Texto_Modificdo := Texto_Modificdo + 'Y';
         'ª': Texto_Modificdo := Texto_Modificdo + 'a';
         'º': Texto_Modificdo := Texto_Modificdo + 'o';
    else
         Texto_Modificdo := Texto_Modificdo + Caracter;
    end;
    end;
result := Texto_Modificdo;
end;
