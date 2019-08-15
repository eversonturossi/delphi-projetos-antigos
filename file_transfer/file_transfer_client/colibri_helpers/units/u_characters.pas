// 005 u_characters
// 07 may 2005

// -- (C) Felix John COLIBRI 2004
// -- documentation: http://www.felix-colibri.com

(*$r+*)

unit u_characters;
  interface
    uses u_types_constants;

    const k_tabulation= chr(9);
          k_line_feed= char(10);
          k_return= chr(13);
          k_back_space= chr(8);
          k_escape= chr(27);

          k_return_line_feed= k_return+ k_line_feed;
          k_new_line= k_return+ k_line_feed;
          k_digits= ['0'..'9'];
          k_blanks= [k_tabulation, ' '];
          k_letters= ['a'..'z', 'A'..'Z'];

          k_ord_return= 13;
          k_ord_linefeed= 10;

    type t_characters= array[0..0] of Char;
         t_pt_characters= ^t_characters;

         t_pt_character= ^Char;
         t_oa_characters= array of Char;

         t_set_of_characters= Set of Char;
         t_set_of_char= Set of Char;

    function f_lower_case(p_character: Char): Char;
    function f_set_of_characters_to_string(p_set_of_characters: t_set_of_characters): String;

  implementation

    function f_lower_case(p_character: Char): Char;
      begin
        if p_character in ['A'..'Z']
          then Result:= Chr(Ord(p_character)+ 32)
          else Result:= p_character;
      end; // f_lower_case

    function f_set_of_characters_to_string(p_set_of_characters: t_set_of_characters): String;
      var l_character: Char;
      begin
        Result:= '';
        for l_character:= chr(0) to chr(255) do
          if l_character in p_set_of_characters
            then Result:= Result+ l_character;
      end; // f_set_of_characters_to_string

  begin
  end.

