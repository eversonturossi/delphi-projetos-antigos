// 015 u_c_basic_object
// 10 dec 2004

// -- (C) Felix John COLIBRI 2004
// -- documentation: http://www.felix-colibri.com

(*$r+*)

unit u_c_basic_object;
  interface

    type c_basic_object= class
                           m_name: String;

                           destructor Destroy; Override;

                           constructor create_basic_object(p_name: String); Virtual;
                           constructor construct_empty;
                           procedure display_abstract(p_texte: string);
                 end;

  implementation
    uses u_c_display;

    constructor c_basic_object.create_basic_object(p_name: String);
      begin
        m_name:= p_name;
      end; // create_basic_object

    constructor c_basic_object.construct_empty;
      begin
      end; // construct_empty

    procedure c_basic_object.display_abstract(p_texte: string);
      begin
        display_bug_halt(m_name+ ' '+ p_texte+ ': abstract procedure');
      end; // display_abstract

    destructor c_basic_object.Destroy;
      begin
      end; // Destroy

    begin // u_c_basic_object
    end. // u_c_basic_object





