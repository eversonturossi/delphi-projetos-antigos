// 002 u_winsock
// 09 may 2005

// -- (C) Felix John COLIBRI 2004
// -- documentation: http://www.felix-colibri.com

(*$r+*)

unit u_winsock;
  interface
    uses WinSock;

    const k_invalid_port= -1;

    function f_socket_error_message(p_error: integer): string;
    function f_wsa_error_name(p_error: Integer): String;
    function f_get_last_error_message: String;

    procedure display_socket_error_halt(p_socket: tSocket; p_function_name: string; p_error: Integer);

      function f_local_socket_ip(p_socket: tSocket): String;
      function f_local_socket_port(p_socket: tSocket): Integer;
    function f_socket_handle_string(p_socket: tSocket): String;
    function f_socket_local_name(p_socket: tSocket): String;
    function f_socket_name(p_socket: tSocket): String;
    function f_socket_notification_name(p_notification: Integer): String;

  implementation
    uses Windows, SysUtils, Forms, Dialogs;

    function f_socket_error_message(p_error: integer): string;
      begin
        case p_error of
          WSAEINTR: result:= 'Interrupted system call';
          WSAEBADF: result:= 'Bad file number';
          WSAEACCES: result:= 'Permission denied';
          WSAEFAULT: result:= 'Bad address';
          WSAEINVAL: result:= 'Invalid argument';
          WSAEMFILE: result:= 'Too many open files';

          WSAEWOULDBLOCK: result:= 'Operation would block';

          WSAEINPROGRESS: result:= 'Operation now in progress';
          WSAEALREADY: result:= 'Operation already in progress';
          WSAENOTSOCK: result:= 'Socket operation on non-socket';
          WSAEDESTADDRREQ: result:= 'Destination address required';
          WSAEMSGSIZE: result:= 'Message too long';
          WSAEPROTOTYPE: result:= 'Protocol wrong type for socket';
          WSAENOPROTOOPT: result:= 'Protocol not available';
          WSAEPROTONOSUPPORT: result:= 'Protocol not supported';
          WSAESOCKTNOSUPPORT: result:= 'Socket type not supported';
          WSAEOPNOTSUPP: result:= 'Operation not supported on socket';
          WSAEPFNOSUPPORT: result:= 'Protocol family not supported';
          WSAEAFNOSUPPORT: result:= 'Address family not supported by protocol family';
          WSAEADDRINUSE: result:= 'Address already in use';
          WSAEADDRNOTAVAIL: result:= 'Can''t assign requested address';
          WSAENETDOWN: result:= 'Network is down';
          WSAENETUNREACH: result:= 'Network is unreachable';
          WSAENETRESET: result:= 'Network dropped connection on reset';
          WSAECONNABORTED: result:= 'Software caused connection abort';
          WSAECONNRESET: result:= 'Connection reset by peer';
          WSAENOBUFS: result:= 'No buffer space available';
          WSAEISCONN: result:= 'Socket is already connected';
          WSAENOTCONN: result:= 'Socket is not connected';
          WSAESHUTDOWN: result:= 'Can''t send after socket shutdown';
          WSAETOOMANYREFS: result:= 'Too many references: can''t splice';
          WSAETIMEDOUT: result:= 'Connection timed out';
          WSAECONNREFUSED: result:= 'Connection refused';
          WSAELOOP: result:= 'Too many levels of symbolic links';
          WSAENAMETOOLONG: result:= 'File name too long';
          WSAEHOSTDOWN: result:= 'Host is down';
          WSAEHOSTUNREACH: result:= 'No route to host';
          WSAENOTEMPTY: result:= 'Directory not empty';
          WSAEPROCLIM: result:= 'Too many processes';
          WSAEUSERS: result:= 'Too many users';
          WSAEDQUOT: result:= 'Disc quota exceeded';
          WSAESTALE: result:= 'Stale NFS file handle';
          WSAEREMOTE: result:= 'Too many levels of remote in path';
          WSASYSNOTREADY: result:= 'Network sub-system is unusable';
          WSAVERNOTSUPPORTED: result:= 'WinSock DLL cannot support this application';
          WSANOTINITIALISED: result:= 'WinSock not initialized';
          WSAHOST_NOT_FOUND: result:= 'Host not found';
          WSATRY_AGAIN: result:= 'Non-authoritative host not found';
          WSANO_RECOVERY: result:= 'Non-recoverable error';
          WSANO_DATA: result:= 'No Data';
          else result:= 'Not a WinSock error';
        end;
      end; // f_socket_error_message

    function f_wsa_error_name(p_error: Integer): String;
      begin
        case p_error of
          WSAEINTR: result:= 'WSA_E_INTR';
          WSAEBADF: result:= 'WSA_E_BADF';
          WSAEACCES: result:= 'WSA_E_ACCESS';
          WSAEFAULT: result:= 'WSA_E_FAULT';
          WSAEINVAL: result:= 'WSA_E_INVAL';
          WSAEMFILE: result:= 'WSA_E_MFILE';

          WSAEWOULDBLOCK: result:= 'WSA_E_WOULDBLOCK';

          WSAEINPROGRESS:    result:= 'WSA_E_INPROGRESS';
          WSAEALREADY:       result:= 'WSA_E_ALREADY';
          WSAENOTSOCK:       result:= 'WSA_E_NOT_SOCK';
          WSAEDESTADDRREQ:   result:= 'WSA_E_DEST_ADDR_REQ';
          WSAEMSGSIZE:       result:= 'WSA_E_MSG_SIZE';
          WSAEPROTOTYPE:     result:= 'WSA_E_PROTO_TYPE';
          WSAENOPROTOOPT:    result:= 'WSA_E_NO_PROTO_OPT';
          WSAEPROTONOSUPPORT: result:= 'WSA_E_PROTO_NOT_SUPPORT';
          WSAESOCKTNOSUPPORT: result:= 'WSA_E_SOCKT_NO_SUPPORT';
          WSAEOPNOTSUPP:      result:= 'WSA_E_OP_NOT_SUPP';
          WSAEPFNOSUPPORT:    result:= 'WSA_E_PF_NO_SUPPORT';

          WSAEAFNOSUPPORT:    result:= 'WSA_E_Address family not supported by protocol family';
          WSAEADDRINUSE:      result:= 'WSA_E_Address already in use';
          WSAEADDRNOTAVAIL:   result:= 'WSA_E_Can''t assign requested address';
          WSAENETDOWN:        result:= 'WSA_E_Network is down';
          WSAENETUNREACH:     result:= 'WSA_E_Network is unreachable';
          WSAENETRESET:       result:= 'WSA_E_Network dropped connection on reset';
          WSAECONNABORTED:    result:= 'WSA_E_CONN_ABORTED';
          WSAECONNRESET:      result:= 'WSA_E_CONN_RESET';
          WSAENOBUFS:         result:= 'WSA_E_No buffer space available';
          WSAEISCONN:         result:= 'WSA_E_Socket is already connected';
          WSAENOTCONN:        result:= 'WSA_E_NOT_CONN';
          WSAESHUTDOWN: result:= 'WSA_E_Can''t send after socket shutdown';
          WSAETOOMANYREFS: result:= 'WSA_E_Too many references: can''t splice';
          WSAETIMEDOUT: result:= 'WSA_E_Connection timed out';
          WSAECONNREFUSED: result:= 'WSA_E_Connection refused';
          WSAELOOP: result:= 'WSA_E_Too many levels of symbolic links';
          WSAENAMETOOLONG: result:= 'WSA_E_File name too long';
          WSAEHOSTDOWN: result:= 'WSA_E_Host is down';
          WSAEHOSTUNREACH: result:= 'WSA_E_No route to host';
          WSAENOTEMPTY: result:= 'WSA_E_Directory not empty';
          WSAEPROCLIM: result:= 'WSA_E_Too many processes';
          WSAEUSERS: result:= 'WSA_E_Too many users';
          WSAEDQUOT: result:= 'WSA_E_Disc quota exceeded';
          WSAESTALE: result:= 'WSA_E_Stale NFS file handle';
          WSAEREMOTE: result:= 'WSA_E_Too many levels of remote in path';
          WSASYSNOTREADY: result:= 'WSA_E_Network sub-system is unusable';
          WSAVERNOTSUPPORTED: result:= 'WSA_E_WinSock DLL cannot support this application';
          WSANOTINITIALISED: result:= 'WSA_E_WinSock not initialized';
          WSAHOST_NOT_FOUND: result:= 'WSA_E_Host not found';
          WSATRY_AGAIN: result:= 'WSA_E_Non-authoritative host not found';
          WSANO_RECOVERY: result:= 'WSA_E_Non-recoverable error';
          WSANO_DATA: result:= 'WSA_E_No Data';
          else result:= 'Not a WinSock error';
        end;
      end; // f_wsa_error_name

    function f_get_last_error_message: String;
      var l_last_error: Integer;
      begin
        l_last_error:= WsaGetLastError;
        Result:= f_wsa_error_name(l_last_error)
            + ' '+ f_socket_error_message(l_last_error);
      end; // f_get_last_error_message

    procedure display_socket_error_halt(p_socket: tSocket; p_function_name: string; p_error: Integer);
      var l_buffer: array[0..255] of char;
          l_text: String;
      begin
        l_text:= 'error '+ IntToStr(p_error)+ ' '+ f_wsa_error_name(p_error)
           + ' '+ f_socket_error_message(p_error)+ #13#10
           + 'in '+ p_function_name;
        StrPCopy(l_buffer, l_text);

        Application.MessageBox(l_buffer, 'error', mb_OKCancel+ mb_DefButton1);

        Halt;
      end; // display_socket_error_halt

    // -- display socket content

    function f_socket_handle_string(p_socket: tSocket): String;
        // -- handle -> s_ and string
      begin
        Result:= 's_'+ IntToStr(p_socket);
      end; // f_socket_handle_string

    function f_local_socket_ip(p_socket: tSocket): String;
        // -- handle -> aaa.bbb.ccc.ddd
      var l_result: Integer;
          l_address_in: tSockAddrIn;
          l_size: Integer;
      begin
        l_size:= SizeOf(tSockAddr);

        l_result:= GetSockName(p_socket, tSockAddr(l_address_in), l_size);

        if l_result= 0
          then Result:= inet_ntoa(l_address_in.sin_addr)
          else Result:= f_get_last_error_message;
      end; // f_local_socket_ip

    function f_local_socket_port(p_socket: tSocket): Integer;
        // -- handle -> 21
      var l_result: Integer;
          l_address_in: tSockAddrIn;
          l_size: Integer;
      begin
        l_size:= SizeOf(tSockAddr);

        l_result:= GetSockName(p_socket, tSockAddr(l_address_in), l_size);

        if l_result= 0
          then Result:= nToHs(l_address_in.sin_port)
          else // -- convention
               Result:= k_invalid_port;
      end; // f_local_socket_port

    function f_socket_local_name(p_socket: tSocket): String;
        // -- only the local part
      var l_result: Integer;
          l_address_in: tSockAddrIn;
          l_size: Integer;
      begin
        Result:= f_socket_handle_string(p_socket)+ ' ';

        l_size:= SizeOf(tSockAddr);
        l_result:= GetSockName(p_socket, tSockAddr(l_address_in), l_size);

        if l_result= 0
          then Result:= Result+ 'loc_IP '+ inet_ntoa(l_address_in.sin_addr)
            + ', loc_Port: '+ IntToStr(nToHs(l_address_in.sin_port))
          else Result:= Result+ 'loc_IP *** '+ f_get_last_error_message;
      end; // f_socket_local_name

    function f_socket_name(p_socket: tSocket): String;
      var l_result: Integer;
          l_address_in: tSockAddrIn;
          l_names: String;
          l_size: Integer;
      begin
        l_names:= f_socket_local_name(p_socket);

        GetPeerName(p_socket, tSockAddr(l_address_in), l_size);
        l_names:= l_names+ ', rem_IP '+ inet_ntoa(l_address_in.sin_addr)
            + ', rem_Port ' + IntToStr(nToHs(l_address_in.sin_port));

        f_socket_name:= l_names;
      end; // f_socket_name

    function f_socket_notification_name(p_notification: Integer): String;
      begin
(*
        FD_READ         = $01;
        FD_WRITE        = $02;
        FD_OOB          = $04;
        FD_ACCEPT       = $08;
        FD_CONNECT      = $10;
        FD_CLOSE        = $20;

*)
        case p_notification of
          FD_READ: Result:= 'FD_READ';
          FD_WRITE: Result:= 'FD_WRITE';
          FD_CLOSE: Result:= 'FD_CLOSE';
          FD_ACCEPT: Result:= 'FD_ACCEPT';
          FD_CONNECT: Result:= 'FD_CONNECT';
          else Result:= '???_'+ IntToHex(p_notification, 4);
        end; // case
      end; // f_socket_notification_name

    end.
