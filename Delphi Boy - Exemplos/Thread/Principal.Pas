// Wheberson Hudson Migueletti, em Brasília, 23 de setembro de 1999.

unit Principal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TThreadContador= class (TThread)
    protected
      Min, Max: Integer;
      Pos     : Integer;
      Edit    : TEdit;

      procedure Execute; override;
      procedure Mostrar;
      procedure Contar; virtual; abstract;
    public
      constructor Create (_Edit: TEdit; _Min, _Max: Integer);
  end;
  TThread1= class (TThreadContador)
    protected
      procedure Contar; override; 
  end;
  TThread2= class (TThreadContador)
    protected
      procedure Contar; override;
  end;
  TFormPrincipal = class(TForm)
    Edit1       : TEdit;
    Edit2       : TEdit;
    Label1      : TLabel;
    Label2      : TLabel;
    BotaoIniciar: TButton;
    BotaoParar  : TButton;

    procedure BotaoIniciarClick (Sender: TObject);
    procedure BotaoPararClick   (Sender: TObject);
    private
      ThreadsRunning: Integer;
      Thread1       : TThread1;
      Thread2       : TThread2;

      procedure ThreadDone (Sender: TObject);
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.DFM}



constructor TThreadContador.Create (_Edit: TEdit; _Min, _Max: Integer);

begin
  Pos            := 0;
  Min            := _Min;
  Max            := _Max;
  Edit           := _Edit;
  FreeOnTerminate:= True;

  inherited Create (False);
end;





procedure TThreadContador.Execute;

begin
  Contar;
end;





procedure TThreadContador.Mostrar;

begin
  Edit.Text:= IntToStr (Pos);
end;




// Incrementa
procedure TThread1.Contar;
var
  P: Integer;

begin
  for P:= Min to Max do
    if Terminated then
      Exit
    else begin
      Pos:= P;
      Synchronize (Mostrar);
    end;
end;




// Decrementa
procedure TThread2.Contar;
var
  P: Integer;

begin
  for P:= Max downto Min do
    if Terminated then
      Exit
    else begin
      Pos:= P;
      Synchronize (Mostrar);
    end;
end;





procedure TFormPrincipal.BotaoIniciarClick (Sender: TObject);

begin
  ThreadsRunning      := 2;
  Thread1             := TThread1.Create (Edit1, 0, 2000);
  Thread1.OnTerminate := ThreadDone;
  Thread2             := TThread2.Create (Edit2, 0, 2000);
  Thread2.OnTerminate := ThreadDone;
  BotaoIniciar.Enabled:= False;
  BotaoParar.Enabled  := True;
end;





procedure TFormPrincipal.ThreadDone (Sender: TObject);

begin
  Dec (ThreadsRunning);
  if ThreadsRunning = 0 then begin
    BotaoIniciar.Enabled:= True;
    BotaoParar.Enabled  := False;
  end;
end;





procedure TFormPrincipal.BotaoPararClick (Sender: TObject);

begin
  Thread1.Terminate;
  Thread2.Terminate;
end;

end.
