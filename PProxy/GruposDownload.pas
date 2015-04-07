unit GruposDownload;

interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
 Dialogs, StdCtrls, ExtCtrls, ComCtrls, OleCtrls, Math;

const
 ArquivoDeDados = 'GruposDeDownloads.conf';
 
type
 
 TGrupos = record
  Nome: string;
  Links: TstringList;
 end;
 
 TGruposDeDownload = class(TObject)
 private
  Gruposs: array of TGrupos;
 public
  constructor Create;
  destructor Destroy;
  procedure SaveToFile(Filename: string);
  procedure LoadFromFile(Filename: string);
  procedure AdicionarGrupo(Nome: string);
  procedure RemoverGrupo(Nome: string);
  function LinkRandomico: string;
  function tamanho: integer;
  function getLinks(NomeDoGrupo: string): TstringList;
  function PosicaoNaLista(NomeDoGrupo: string): integer;
  procedure AdicionarAlterarLinks(NomeDoGrupo: string; lista: Tstrings);
 end;
 
implementation

constructor TGruposDeDownload.Create;
begin
 SetLength(Gruposs, 0);
end;

destructor TGruposDeDownload.Destroy;
begin
 SetLength(Gruposs, 0);
end;

procedure TGruposDeDownload.SaveToFile(Filename: string);
var
 arquivo: TStringList;
 ContGrupo, ContLinks: integer;
begin
 Filename := ArquivoDeDados;
 arquivo := TStringList.Create();
 for ContGrupo := 0 to Length(Gruposs) - 1 do
  begin
   arquivo.Add('#' + Gruposs[ContGrupo].Nome);
   for ContLinks := 0 to Gruposs[ContGrupo].Links.Count - 1 do
    arquivo.Add(Gruposs[ContGrupo].Nome + '#' + Gruposs[ContGrupo].Links.Strings[ContLinks]);
  end;
 arquivo.SaveToFile(Filename);
 arquivo.Free;
end;

procedure TGruposDeDownload.AdicionarGrupo(Nome: string);
var
 G: string;
begin
 SetLength(Gruposs, Length(Gruposs) + 1);
 G := Trim(Nome);
 if (Copy(G, 1, 1) = '#') then
  Delete(G, 1, 1);
 Gruposs[Length(Gruposs) - 1].Nome := G;
 Gruposs[Length(Gruposs) - 1].Links := TStringList.Create();
 // GruposDownloadListBox.Items.Add(G);
end;

procedure TGruposDeDownload.LoadFromFile(Filename: string);
var
 arquivo: TStringList;
 Cont, I: integer;
 G, L: string;
begin
 Filename := ArquivoDeDados;
 arquivo := TStringList.Create();
 if FileExists(Filename) then
  begin
   arquivo.LoadFromFile(Filename);
   for cont := 0 to arquivo.Count - 1 do
    begin
     if (Copy(arquivo.Strings[cont], 1, 1) = '#') then
      begin
       AdicionarGrupo(arquivo.Strings[cont]);
      end
     else
      begin
       G := Copy(arquivo.Strings[cont], 1, Pos('#', arquivo.Strings[cont]));
       L := arquivo.Strings[cont];
       Delete(L, 1, Pos('#', arquivo.Strings[cont]));
       Gruposs[Length(Gruposs) - 1].Links.Add(L)
      end;
    end;
  end;
 arquivo.Free;
end;

procedure TGruposDeDownload.RemoverGrupo(Nome: string);
var
 CONT, I: integer;
begin
 for CONT := 0 to Length(Gruposs) - 1 do
  if (Nome = Gruposs[CONT].Nome) then
   I := CONT;
 if (I < Length(Gruposs) - 1) then
  for Cont := I to Length(Gruposs) do
   Gruposs[I] := Gruposs[I + 1];
 SetLength(Gruposs, Length(Gruposs) - 1);
 SaveToFile(ArquivoDeDados);
 
end;

function TGruposDeDownload.LinkRandomico: string;
var
 idGrupo, idLink: integer;
 Link: string;
begin
 link := 'about:blank';
 if length(Gruposs) > 0 then
  begin
   Randomize;
   idGrupo := RandomRange(0, Length(Gruposs) - 1);
   Randomize;
   idLink := RandomRange(0, Gruposs[idGrupo].Links.Count - 1);
   link := Gruposs[idGrupo].Links.Strings[idlink];
  end;
 result := link;
end;

function TGruposDeDownload.tamanho: Integer;
begin
 Result := Length(Gruposs);
end;

function TGruposDeDownload.PosicaoNaLista(NomeDoGrupo: string): integer;
var
 CONT, Posicao: integer;
begin
 Posicao := -1;
 for CONT := 0 to tamanho - 1 do
  if (NomeDoGrupo = Gruposs[CONT].Nome) then
   Posicao := CONT;
 Result := Posicao;
end;

function TGruposDeDownload.getLinks(NomeDoGrupo: string): TstringList;
begin
 Result := Gruposs[PosicaoNaLista(NomeDoGrupo)].Links;
end;

procedure TGruposDeDownload.AdicionarAlterarLinks(NomeDoGrupo: string; lista: Tstrings);
begin
 Gruposs[PosicaoNaLista(NomeDoGrupo)].Links.Clear;
 Gruposs[PosicaoNaLista(NomeDoGrupo)].Links.Assign(lista);
end;
end.

