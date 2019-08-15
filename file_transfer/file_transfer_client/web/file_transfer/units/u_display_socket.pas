// 002 u_display_socket
// 11 may 2005

// -- (C) Felix John COLIBRI 2004
// -- documentation: http://www.felix-colibri.com

(*$r+*)

unit u_display_socket;
  interface
    uses WinSock
        , ScktComp
        ;

    function f_display_socket(p_custom_win_socket: TCustomWinSocket): String;

  implementation
    uses SysUtils;


    function f_display_socket(p_custom_win_socket: TCustomWinSocket): String;
      begin
        with p_custom_win_socket do
          Result:= 's_'+ IntToStr(SocketHandle)+ ' local= '+ LocalAddress+ ' '+ IntToStr(LocalPort)
            + ' remote '+ RemoteAddress+ ' '+ IntToStr(RemotePort);
      end; // f_display_socket


  end.


