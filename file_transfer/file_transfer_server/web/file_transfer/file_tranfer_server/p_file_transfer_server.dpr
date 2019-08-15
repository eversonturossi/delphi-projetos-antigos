program p_file_transfer_server;

uses
  Forms,
  u_file_tranfer_server in 'u_file_tranfer_server.pas' {server_form};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(Tserver_form, server_form);
  Application.Run;
end.
