// 016 u_c_log
// 07 may 2005

// -- (C) Felix John COLIBRI 2004
// -- documentation: http://www.felix-colibri.com

(*$r+*)

// -- todo: concatenate with the previous

unit u_c_log;
  interface
    uses Classes;

    type c_log= class
                  public
                    m_log_file: File;
                    m_name, m_file_name: String;
                    // m_do_log: Boolean;
                    // m_concatenate_to_previous: Boolean;

                    constructor create_log(p_name, p_file_name: String); Virtual;

                    procedure write_string(p_text: String);
                    procedure write_line(p_text: String);
                    procedure write_strings(p_title: String; p_strings: tStrings);

                    destructor Destroy; Override;
                end;

  implementation
    uses SysUtils, Dialogs, FileCtrl, Forms
        , u_types_constants, u_characters;

    constructor c_log.create_log(p_name, p_file_name: String);
      var l_path: String;
      begin
        m_name:= p_name;
        m_file_name:= p_file_name;

        // -- if the file name is relative, add the Application path
        l_path:= ExtractFilePath(m_file_name);
        if (Length(l_path)< 2) or  (l_path[2]<> ':')
          then begin
              l_path:= ExtractFilePath(Application.ExeName)+ l_path;
              m_file_name:= l_path+ ExtractFileName(p_file_name);
            end;

        // m_do_log:= True;

        // -- concatenate log

        // -- create the file
        if Not DirectoryExists(ExtractFilePath(m_file_name))
          then begin
              // bug_halt('log could not create '+ p_file_name);
              ShowMessage('BUG no path '+ ExtractFilePath(m_file_name)+ '. Halt.');
              Halt(55);
            end;

        Assign(m_log_file, m_file_name);
        Rewrite(m_log_file);
        Close(m_log_file);

        // -- the date
        write_line('// -- '+ m_file_name+ ' '+ DateTimeToStr(Now));
      end; // create_log

    procedure c_log.write_string(p_text: String);
      // var l_length: Integer;
      begin
        Reset(m_log_file, 1);
        Seek(m_log_file, FileSize(m_log_file));
        BlockWrite(m_log_file, p_text[1], Length(p_text));
        Close(m_log_file);
      end; // write_string

    procedure c_log.write_line(p_text: String);
      begin
        p_text:= p_text+ k_return_line_feed;
        // ShowMessage(m_file_name+ IntToStr(Integer(Self)));

        // -- if used DirectoryListbox.Directory, with a wrong name, bombs here
        if not FileExists(m_file_name)
          then ShowMessage('no '+ m_file_name);

        // Assign(m_log_file, m_file_name);
        Reset(m_log_file, 1);
        Seek(m_log_file, FileSize(m_log_file));
        BlockWrite(m_log_file, p_text[1], Length(p_text));
        Close(m_log_file);
      end; // write_line

    procedure c_log.write_strings(p_title: String; p_strings: tStrings);
      var l_line: Integer;
      begin
        if p_strings= nil
          then write_line(p_title+ ' Strings NIL')
          else
            if p_strings.Count= 0
              then write_line(p_title+ ' = empty')
              else
                for l_line:= 0 to p_strings.Count- 1 do
                  write_line(p_title+ ' '+ IntToStr(l_line)+ '= '+ p_strings[l_line]);
      end; // write_strings

    destructor c_log.Destroy;
      begin
        // Inherited Destroy;
      end; // Destroy

    // -- global

    begin // u_c_log
    end. // u_c_log

og

