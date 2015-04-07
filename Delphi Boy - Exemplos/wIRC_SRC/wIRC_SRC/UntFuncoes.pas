unit UntFuncoes;

interface
 uses
   SysUtils, Classes;

 function PosToLinha(const Texto: string; Pos: Longint): Longint;

implementation

 function PosToLinha(const Texto: string; Pos: Longint): Longint;
 var
   I: Integer;

 begin
   result:=1;
   for I:=1 to Pos do
     if Texto[I] = #10 then Inc(result); {Deve funciobar no Linux também}
 end;

end.
