// 002 u_file_tranfer_server
// 11 may 2005

// -- (C) Felix John COLIBRI 2004
// -- documentation: http://www.felix-colibri.com

(*$r+*)

// -- start the server
// -- if "automatic"
// --   "listen"
// -- if non "automatic"
// --   "listen"
// --   select a client
// --   write a packet

unit u_file_tranfer_server;
  interface
    uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
        Menus, StdCtrls, Buttons, ExtCtrls, ComCtrls
        , ScktComp;

    type Tserver_form= class(TForm)
                      Bevel1: TBevel;
                      Panel1: TPanel;
                      Memo1: TMemo;

                      ServerSocket: TServerSocket;
    listen_: TButton;
    disconnect_: TButton;
    ListBox1: TListBox;
    status_: TButton;
    exit_: TButton;
    clear_: TButton;
    sleep_edit_: TEdit;
    sleep: TLabel;

                      procedure disconnect_Click(Sender: TObject);
                      procedure FormCreate(Sender: TObject);
                      procedure ServerSocketClientRead(Sender: TObject; Socket:
                            TCustomWinSocket);
                      procedure ServerSocketAccept(Sender: TObject; Socket:
                            TCustomWinSocket);
                      procedure ServerSocketClientConnect(Sender: TObject; Socket:
                            TCustomWinSocket);
                      procedure ServerSocketClientDisconnect(Sender: TObject;
                            Socket: TCustomWinSocket);
    procedure FormDestroy(Sender: TObject);
    procedure ServerSocketClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure ServerSocketListen(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure status_Click(Sender: TObject);
    procedure ServerSocketClientWrite(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure exit_Click(Sender: TObject);
    procedure clear_Click(Sender: TObject);
    procedure listen_Click(Sender: TObject);
                    end;

    var server_form: Tserver_form;

  implementation
    uses WinSock
        , u_c_display, u_c_log
        , u_display_socket
        , u_winsock
        ;

    {$R *.DFM}

    //.create_path ..\_data
    //.copy_file ..\_data\Felix_Colibri_Site_Map.txt

    const k_source_path= '..\file_transfer\_data\';

    var g_host_ip: String= '127.0.0.1';

    procedure Tserver_form.ServerSocketClientError(Sender: TObject;
        Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
        var ErrorCode: Integer);
        // -- an error occured on ClientSocket
      begin
        display('*** client_error '+ f_socket_error_message(ErrorCode));
        display(IntToStr(ErrorCode));

        // -- do not raise further exceptions
        ErrorCode:= 0;
      end; // ServerSocketClientError

    procedure Tserver_form.ServerSocketListen(Sender: TObject;
        Socket: TCustomWinSocket);
      begin
        display_line;
        display('= listen '+ IntToStr(Socket.LocalPort));
      end; // ServerSocketListen

    procedure Tserver_form.ServerSocketClientConnect(Sender: TObject; Socket:
          TCustomWinSocket);
        // -- a client started a connection
      begin
        display_line;
        display('= connect '+ f_display_socket(Socket));
      end; // ServerSocketClientConnect

    function f_socket_key(p_c_server_client_socket: TCustomWinSocket): String;
      begin
        Result:= IntToStr(p_c_server_client_socket.SocketHandle)
      end; // f_socket_key

    procedure Tserver_form.ServerSocketAccept(Sender: TObject; Socket:
          TCustomWinSocket);
        // -- a client was connected. The server accepts the connection
        // --   place the socket address in the ListBox => will allow
        // --   selection of client
      begin
        display_line;
        display('= accept '+ f_display_socket(Socket));

        ListBox1.Items.Add(f_socket_key(Socket));
        ListBox1.ItemIndex:= ListBox1.Items.Count- 1;
      end; // ServerSocketAccept

    procedure Tserver_form.ServerSocketClientRead(Sender: TObject;
        Socket: TCustomWinSocket);
        // -- analyze incoming data
      const k_buffer_size= 4096;
      var l_text: String;
          l_file_name: String;
          l_listbox_index: Integer;
          l_c_file_stream: tFileStream;
          l_size, l_start_position: Integer;
          l_sleep: Integer;

          l_buffer: array[0..k_buffer_size- 1] of byte;
          l_to_send, l_sent_count: Integer;
      begin
        display_line;
        display('>= read '+ f_display_socket(Socket));

        l_text:= Socket.ReceiveText;
        display('  received '+ l_text);

        // -- now locate the file
        l_file_name:= k_source_path+ l_text;

        // -- find or create the stream
        l_listbox_index:= ListBox1.Items.IndexOf(f_socket_key(Socket));
        display('  ix '+ IntToStr(l_listbox_index));

        if l_listbox_index< 0
          then display_bug_halt('  *** no_listbox_ix '+ IntToStr(Socket.SocketHandle))
          else
            if ListBox1.Items.Objects[l_listbox_index]= Nil
              then begin
                  display('  create_stream');
                  l_c_file_stream:= tFileStream.Create(l_file_name, fmOpenRead or fmShareDenyNone);
                  // -- attach the stream to the tListBox.Objects
                  ListBox1.Items.Objects[l_listbox_index]:= l_c_file_stream;
                end
              else begin
                  display_bug_stop('  *** no_2_overlapping_read_from_same_socket');
                  Exit;
                end;

        with l_c_file_stream do
        begin
          display('  file_size '+ IntToStr(Size)+ ' pos '+ IntToStr(Position));
          if Position= Size
            then Position:= 0;

          // -- send the size back to the client
          if Position= 0
            then begin
                l_size:= Size;
                Socket.SendBuf(l_size, 4);
              end;

          // -- send the bytes
          l_sleep:= StrToInt(sleep_edit_.Text);

          if l_sleep= 0
            then begin
                // -- send all
                if Socket.SendStream(l_c_file_stream)
                  then begin
                      // -- ScktCmp frees the stream, and NIL its local pointer
                      // -- so we also NIL our pointer
                      ListBox1.Items.Objects[l_listbox_index]:= NIL;
                      display('  finished '+ IntToStr(l_size));
                    end
                  else display('  *** not_finished ');
              end
            else begin
                while l_c_file_stream.Position< l_c_file_stream.Size do
                begin
                  l_start_position:= l_c_file_stream.Position;

                  l_to_send:= l_c_file_stream.Read(l_buffer, k_buffer_size);
                  if l_to_send> 0
                    then
                      l_sent_count:= Socket.SendBuf(l_buffer, l_to_send);
                      // -- should check status

                  display('  '+ f_socket_key(Socket)
                      + ' sent from '+ IntToStr(l_start_position)
                      + ' '+ IntToStr(l_sent_count)+ ' bytes');
                  Application.ProcessMessages;
                  SysUtils.Sleep(l_sleep);
                end; // while not end_of_stream
              end; // send by packets with some delay
        end; // with g_c_file_stream

        display('<= read '+ f_display_socket(Socket));
      end; // ServerSocketClientRead

    procedure Tserver_form.ServerSocketClientWrite(Sender: TObject;
        Socket: TCustomWinSocket);
      begin
        display('= write '+ f_display_socket(Socket));
      end; // ServerSocketClientWrite

    procedure Tserver_form.ServerSocketClientDisconnect(Sender: TObject; Socket:
          TCustomWinSocket);
        // -- a client disconnected
      var l_socket_index: Integer;
      begin
        display('= disconnect '+ IntToStr(Socket.SocketHandle));

        // -- remove this client IP from the ListBox
        With ListBox1 do
        begin
          l_socket_index:= Items.IndexOf(f_socket_key(Socket));
          Items.Delete(l_socket_index);
        end;
      end; // ServerSocketClientDisconnect

    // -- events

    procedure Tserver_form.FormCreate(Sender: TObject);
      begin
        initialize_display(Memo1.Lines);
        initialize_default_log;
      end; // FormCreate

    procedure Tserver_form.listen_Click(Sender: TObject);
        // -- toggle the status and set the socket to listening
      var l_path_name: String;
      begin
        display_line;
        display('+ listen_Click');
        ServerSocket.Active:= Not ServerSocket.Active;

        status_Click(Nil);
      end; // listen_Click

    procedure Tserver_form.status_Click(Sender: TObject);
      begin
        if ServerSocket.Active
          then begin
              display('  server active');
              with ServerSocket.Socket do
              begin
                display('  HostName '+ LocalHost);
                if Connected
                  then display('  Socket connected')
                  else display('  Socket disconnected');
              end;
            end
          else display('  server inactive');
      end; // status_Click

    procedure Tserver_form.disconnect_Click(Sender: TObject);
      begin
        display_line;
        display('+ disconnect_server');
        ServerSocket.Close;
        // -- todo: close server client sockets
        ListBox1.Items.Clear;
      end; // disconnect_Click

    procedure Tserver_form.FormDestroy(Sender: TObject);
      begin
        display_line;
        display('+ form_destroy');
        ServerSocket.Close;
      end; // FormDestroy

     procedure Tserver_form.exit_Click(Sender: TObject);
       begin
         Close;
       end; // exit_Click

    procedure Tserver_form.clear_Click(Sender: TObject);
      begin
        clear_display;
      end; // clear_Click

end.
