// 011 u_c_display
// 07 may 2005

// -- (C) Felix John COLIBRI 2004
// -- documentation: http://www.felix-colibri.com


(*$r+*)

unit u_c_display;
  interface
    uses SysUtils, Classes, u_c_basic_object, u_c_log;

    type c_display= class(c_basic_object)
                      public
                        m_do_display: Boolean;
                        m_indentation: Integer;
                        m_current_string: String;
                        m_c_strings: tStrings;

                        m_c_log: c_log;

                        Constructor create_display(p_name: String; p_c_strings: tStrings;
                            p_c_log: c_log); Virtual;

                        procedure clear_display;

                        procedure display_string(p_text: String);
                        procedure display(p_text: String);
                        procedure display_line;

                        procedure display_strings(p_c_strings: tStrings);

                        function f_save_display: Boolean;
                        procedure restore_display(p_display: Boolean);

                        procedure stop(p_text: String);
                        procedure display_bug(p_text: String);
                        procedure display_bug_stop(p_text: String);
                        procedure display_bug_halt(p_text: String);

                        Destructor Destroy; Override;
                    end;

    procedure initialize_display(p_c_strings: tStrings);
    procedure initialize_display_log(p_complete_name: String);
    procedure initialize_default_log;

    procedure clear_display;

    procedure display_string(p_text: String);
    procedure display(p_text: String);
    procedure display_line;
    procedure display_strings(p_c_strings: tStrings);

    function f_save_display: Boolean;
    procedure stop_display;
    procedure start_display;
    procedure restore_display(p_display: Boolean);

    procedure stop(p_text: String);
    procedure display_bug(p_text: String);
    procedure display_bug_stop(p_text: String);
    procedure display_bug_halt(p_text: String);

    procedure change_indentation(p_delta: Integer);
    function f_indentation: Integer;

    // -- THE global display, used by the non-object calls
    var g_c_display: c_display= Nil;

  implementation
    uses Windows, Dialogs, u_strings
        , u_dir, u_file
        ;

    // -- c_display

    Constructor c_display.create_display(p_name: String; p_c_strings: tStrings; p_c_log: c_log);
      begin
        Inherited ;

        m_c_strings:= p_c_strings;
        m_do_display:= True;

        m_c_log:= p_c_log;
      end; // create_display

    procedure c_display.clear_display;
      begin
        m_c_strings.Clear;
      end; // clear_display

    procedure c_display.display_string(p_text: String);
        // -- add this string to the current one
      begin
        m_current_string:= m_current_string+ p_text;
      end; // display_string

    procedure c_display.display(p_text: String);
      var l_text: String;
          l_length: Integer;
      begin
        if not m_do_display
          then exit;

        l_length:= Length(p_text);
        if (l_length> 0) and (p_text[1]= '<')
          then begin
              dec(m_indentation, 2);
              if m_indentation< 0
                then begin
                    display('*** negative indent');
                    m_indentation:= 0;
                  end;
            end;

        // -- if no Write, add indentation
        if m_current_string= ''
          then l_text:= f_spaces(m_indentation)
          else l_text:= '';

        // -- compute the indentation, the current strings, and this parameter
        l_text:= l_text+ m_current_string+ p_text;

        // -- add the result to the tStrings
        m_c_strings.Add(l_text);

        // -- flush to the log
        if Assigned(m_c_log)
          then m_c_log.write_line(l_text);

        if (l_length> 0) and (p_text[1]= '>')
          then inc(m_indentation, 2);

        m_current_string:= '';
      end; // display

    procedure c_display.display_line;
        // -- a blank line
      begin
        display('');
      end; // display_line

    procedure c_display.display_strings(p_c_strings: tStrings);
      var l_line: Integer;
      begin
        for l_line:= 0 to p_c_strings.Count- 1 do
          display(p_c_strings[l_line]);
      end; // display_strings

    // -- toggle display

    function c_display.f_save_display: Boolean;
      begin
        Result:= m_do_display;
        m_do_display:= True;
      end; // f_save_display

    procedure c_display.restore_display(p_display: Boolean);
      begin
        m_do_display:= p_display;
      end; // restore_display

    // -- bugs, warnings

    procedure c_display.stop(p_text: String);
      var l_save_display: Boolean;
      begin
        l_save_display:= f_save_display;
        display('*** Stop '+ p_text);
        ShowMessage(p_text);
        restore_display(l_save_display);
      end; // stop

    procedure c_display.display_bug(p_text: String);
      var l_save_display: Boolean;
      begin
        l_save_display:= f_save_display;
        display('*** BUG: '+ p_text);
        restore_display(l_save_display);
      end; // display_bug

    procedure c_display.display_bug_stop(p_text: String);
      begin
        stop('BUG '+ p_text);
      end; // display_bug_stop

    procedure c_display.display_bug_halt(p_text: String);
      begin
        display_bug(p_text);
        stop('BUG '+ p_text+ '. HALT');
        Halt(1);
      end; // display_bug_halt

    // -- free

    Destructor c_display.Destroy;
      begin
        Inherited;
      end; // Destroy

    // -- the global procedures

    procedure initialize_display(p_c_strings: tStrings);
      begin
        if Assigned(g_c_display)
          then g_c_display.Free;

        g_c_display:= c_display.create_display('dispay', p_c_strings, Nil);
      end; // initialize_display

    procedure initialize_display_log(p_complete_name: String);
      begin
        if Assigned(g_c_display)
          then g_c_display.m_c_log:= c_log.create_log('log', p_complete_name);
      end; // initialise_display_log

    procedure initialize_default_log;
        // -- the exe has a sub_path "log\" where the log file is created
      begin
        if Assigned(g_c_display)
          then g_c_display.m_c_log:= c_log.create_log('log', f_exe_path+ 'log\log_'+ ChangeFileExt(f_exe_file_name, '.log'));
      end; // initialize_default_log

    procedure clear_display;
      begin
        if Assigned(g_c_display)
          then g_c_display.clear_display;
      end; // clear_display

    procedure display_string(p_text: String);
      begin
        if Assigned(g_c_display)
          then g_c_display.display_string(p_text);
      end; // display_string

    procedure display(p_text: String);
      begin
        if Assigned(g_c_display)
          then g_c_display.display(p_text);
      end; // display

    procedure display_line;
      begin
        if Assigned(g_c_display)
          then g_c_display.display_line;
      end; // display_line

    procedure display_strings(p_c_strings: tStrings);
      begin
        if Assigned(g_c_display)
          then g_c_display.display_strings(p_c_strings);
      end; // display_strings

    function f_save_display: Boolean;
      begin
        if Assigned(g_c_display)
          then Result:= g_c_display.f_save_display;
      end; // f_save_display

    procedure stop_display;
      begin
        if Assigned(g_c_display)
          then g_c_display.m_do_display:= False;
      end; // stop_display

    procedure start_display;
      begin
        if Assigned(g_c_display)
          then g_c_display.m_do_display:= True;
      end; // start_display

    procedure restore_display(p_display: Boolean);
      begin
        if Assigned(g_c_display)
          then g_c_display.restore_display(p_display);
      end; // restore_display

    procedure stop(p_text: String);
      begin
        if Assigned(g_c_display)
          then g_c_display.stop(p_text);
      end; // stop

    procedure display_bug(p_text: String);
      begin
        if Assigned(g_c_display)
          then g_c_display.display_bug(p_text);
      end; // display_bug

    procedure display_bug_stop(p_text: String);
      begin
        if Assigned(g_c_display)
          then g_c_display.display_bug_stop(p_text);
      end; // display_bug_stop

    procedure display_bug_halt(p_text: String);
      begin
        if Assigned(g_c_display)
          then g_c_display.display_bug_halt(p_text);
      end; // display_bug_halt

    procedure change_indentation(p_delta: Integer);
      begin
        if Assigned(g_c_display)
          then Inc(g_c_display.m_indentation, p_delta);
      end; // change_indentation

    function f_indentation: Integer;
      begin
        if Assigned(g_c_display)
          then Result:= g_c_display.m_indentation
          else Result:= 0;
      end; // f_indentation

   end.





