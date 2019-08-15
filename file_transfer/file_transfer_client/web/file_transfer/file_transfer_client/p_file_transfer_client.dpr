program p_file_transfer_client;

uses
  Forms,
  u_file_tranfer_client in 'u_file_tranfer_client.pas' {client_form};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(Tclient_form, client_form);
  Application.Run;
end.
