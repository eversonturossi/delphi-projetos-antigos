// 002 u_file_tranfer_client
// 11 may 2005

// -- (C) Felix John COLIBRI 2004
// -- documentation: http://www.felix-colibri.com

(*$r+*)

// -- server has been launched
// -- "connect"
// -- click the Edit ...
// -- "disconnect

// -- can start several clients on the same server (from a Windows Explorer)

unit u_file_tranfer_client;
  interface
    uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
        Menus, StdCtrls, Buttons, ExtCtrls, ComCtrls
        , FileCtrl
        , ScktComp
(*
        , u_c_win_socket
        , u_c_win_socket_client
        , u_c_client_socket
*)
        ;

    type Tclient_form= class(TForm)
                      Bevel1: TBevel;
                      Panel1: TPanel;
                      Memo1: TMemo;
    connect_: TButton;
    disconnect_: TButton;
    FileListBox1: TFileListBox;
    clear_: TButton;
    exit_: TButton;
    exe_: TCheckBox;
    ClientSocket1: TClientSocket;
    packet_size_edit_: TEdit;
                      procedure FileConnectItemClick(Sender: TObject);
                      procedure FormCreate(Sender: TObject);
                      procedure Disconnect1Click(Sender: TObject);
                      procedure ClientSocketConnect(Sender: TObject; Socket:
                            TCustomWinSocket);
                      procedure ClientSocketRead(Sender: TObject; Socket:
                            TCustomWinSocket);
                      procedure ClientSocketError(Sender: TObject; Socket:
                            TCustomWinSocket; ErrorEvent: TErrorEvent; var
                            ErrorCode: Integer);
    procedure ClientSocketDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure FileListBox1Click(Sender: TObject);
    procedure clear_Click(Sender: TObject);
    procedure create_Click(Sender: TObject);
    procedure exit_Click(Sender: TObject);
    procedure exe_Click(Sender: TObject);
    procedure ClientSocket1Write(Sender: TObject;
      Socket: TCustomWinSocket);
                    end;

    var client_form: Tclient_form;

  implementation
    uses u_c_display, u_c_log, u_file, u_dir
        , u_display_socket, u_winsock
        ;

    {$R *.DFM}

    const k_source_path= '..\file_transfer\_data\';

    var g_source_path: String= k_source_path;
        g_host_ip: String= '127.0.0.1';
        // g_c_client_socket: tCLientSocket= Nil;
        g_file_size: Integer= 0;
        g_received_bytes: Integer= 0;
        g_packet_size: Integer= 1024* 10;
        g_oa_buffer: Array of Byte;
        g_c_file_stream: tFileStream= Nil;

    procedure Tclient_form.ClientSocketError(Sender: TObject; Socket:
          TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
      begin
        display('*** error '+ f_socket_error_message(ErrorCode));
        ErrorCode:= 0;
      end; // ClientSocketError

    procedure Tclient_form.ClientSocketConnect(Sender: TObject; Socket:
          TCustomWinSocket);
      begin
        display('= connected ');
      end; // ClientSocketConnect

    procedure Tclient_form.ClientSocket1Write(Sender: TObject;
        Socket: TCustomWinSocket);
      begin
        display('= Write ');
      end; // ClientSocket1Write

    procedure Tclient_form.ClientSocketRead(Sender: TObject; Socket:
          TCustomWinSocket);
      var l_bytes_received: Integer;
          l_pt: Pointer;
      begin
        display('= receive ');

        if g_file_size= 0
          then begin
              l_bytes_received:= Socket.ReceiveBuf(g_file_size, 4);
              g_received_bytes:= 0;
              if l_bytes_received= 4
                then begin
                    display('  expected_file_size '+ IntToStr(g_file_size));
                    SetLength(g_oa_buffer, g_file_size);
                  end
                else begin
                    display('  size_not_yet_received');
                    g_file_size:= 0;
                  end;
            end
          else begin
              if g_received_bytes< g_file_size
                then begin
                    // -- nothing tells us how much arrived. Grab as
                    // --   much as possible. If no more was there,
                    // --   Recv will return -1
                    // -- And will even get several OnRead events, with
                    // --   nothing in the reception buffer
                    repeat
                      l_pt:= @ g_oa_buffer[g_received_bytes];
                      l_bytes_received:= Socket.ReceiveBuf(l_pt^, g_packet_size);
                      if l_bytes_received= -1
                        then begin
                            display('  -1 => no_more_for_now');
                            Break;
                          end;
                      g_c_file_stream.Write(l_pt^, l_bytes_received);

                      Inc(g_received_bytes, l_bytes_received);
                      display('  received '+ IntToStr(l_bytes_received)
                          + ' '+ IntToStr(g_received_bytes)
                          + ' / '+ IntToStr(g_file_size));
                    until g_received_bytes>= g_file_size;
                  end;

              if g_received_bytes>= g_file_size
                then begin
                    display('  received_all. Empty_buffer');

                    g_c_file_stream.Free;
                    g_c_file_stream:= Nil;
                    SetLength(g_oa_buffer, 0);
                    g_file_size:= 0;
                    g_received_bytes:= 0;
                  end;
            end;
      end; // ClientSocketRead

    procedure Tclient_form.ClientSocketDisconnect(Sender: TObject;
        Socket: TCustomWinSocket);
      // -- disconnects because of client or of server
      begin
        display('= disconnect ');
      end; // ClientSocketDisconnect

    // -- events

    procedure Tclient_form.FormCreate(Sender: TObject);
      begin
        initialize_display(Memo1.Lines);
        initialize_default_log;
        FileListBox1.Directory:= k_source_path;
      end; // FormCreate

    procedure Tclient_form.create_Click(Sender: TObject);
        // -- create the ClientSocket and connect it
      begin
(*
        g_c_client_socket.Free;
        g_c_client_socket:= tCLientSocket.Create(Self);

        with g_c_client_socket do
        begin
          ClientType:= ctNonBlocking;
          Port:= 1024;

          OnError:= ClientSocketError;
          OnConnect:= ClientSocketConnect;
          OnRead:= ClientSocketRead;
          OnDisconnect:= ClientSocketDisconnect;

          // Socket.m_display_winsock:= True;
        end;
*)
      end; // create_Click

    procedure Tclient_form.clear_Click(Sender: TObject);
      begin
        clear_display;
        g_file_size:= 0;
        g_received_bytes:= 0;
        SetLength(g_oa_buffer, 0);
      end; // clear_Click

    procedure Tclient_form.FileConnectItemClick(Sender: TObject);
      begin
        display('+ connect_click');
        if ClientSocket1.Active
          then ClientSocket1.Active:= False;

        with ClientSocket1 do
        begin
          Host:= g_host_ip;
          g_packet_size:= StrToInt(packet_size_edit_.Text);
          Active:= True;
        end;
      end; // FileConnectItemClick

    procedure Tclient_form.Disconnect1Click(Sender: TObject);
      begin
        display('+ disconnect_click');
        ClientSocket1.Active:= False;
      end; // Disconnect1Click

    procedure Tclient_form.FileListBox1Click(Sender: TObject);
      var l_file_name, l_save_name: String;
      begin
        with FileListBox1 do
          l_file_name:= Items[ItemIndex];

        if g_source_path<> k_source_path
          then begin
              l_file_name:= '..\..\_exe\'+ l_file_name;
              l_save_name:= '..\..\_exe\_'+ l_file_name;
            end
          else l_save_name:= '_'+ l_file_name;

        g_c_file_stream.Free;
        g_c_file_stream:= tFileStream.Create(l_save_name, fmCreate);

        display('+ Send('+ l_file_name+ ')');
        ClientSocket1.Socket.SendText(l_file_name);
      end; // FileListBox1Click

    procedure Tclient_form.exit_Click(Sender: TObject);
      begin
        Close;
      end; // exit_Click

    procedure Tclient_form.exe_Click(Sender: TObject);
      begin
        if exe_.Checked
          then g_source_path:= ExtractFilePath(Application.ExeName)
          else g_source_path:= k_source_path;
        set_file_listbox_directory(FileListBox1, g_source_path);  
        Caption:= g_source_path;
      end;

end.
