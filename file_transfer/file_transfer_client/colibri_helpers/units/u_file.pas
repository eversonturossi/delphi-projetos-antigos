// 012 u_file
// 03 feb 2005

// -- (C) Felix John COLIBRI 2004
// -- documentation: http://www.felix-colibri.com

(*$r+*)

unit u_file;
  interface
    uses Classes;

    procedure copy_file(p_source_name, p_destination_name: String);
    function f_check_and_copy_file(p_source_name, p_destination_name: String): Boolean;
    procedure rename_file(p_complete_source_name, p_destination_name: String);
    function f_erase(p_file_name: String): Boolean;
      
    procedure check_path_and_name(p_name: String);
    function f_exe_file_name: String;
    function f_unique_file_name(p_full_name: String): String;
    function f_file_size(p_file_name: String): Integer;

  implementation
    uses SysUtils, FileCtrl, Dialogs, Forms
        , u_c_display;

    function f_erase(p_file_name: String): Boolean;
      var l_file: File;
      begin
        if FileExists(p_file_name)
          then begin
              Assign(l_file, p_file_name);
              Erase(l_file);
              Result:= True;
            end
          else Result:= False;
      end; // f_erase

    procedure copy_file(p_source_name, p_destination_name: String);
      var fluxSource, fluxDestination: TFileStream;
      begin
        fluxSource:= TFileStream.Create(p_source_name, fmOpenRead);
        try
          fluxDestination:= TFileStream.Create(p_destination_name, fmOpenWrite or fmCreate);
          try
            fluxDestination.CopyFrom(fluxSource, fluxSource.Size);
          finally
            fluxDestination.Free;
          end;
        finally
          fluxSource.Free;
        end;
      end; // copy_file

    function f_check_and_copy_file(p_source_name, p_destination_name: String): Boolean;
      begin
        Result:= False;
        display('copy '+ p_source_name);
        display('  to '+ p_destination_name);

        if not DirectoryExists(ExtractFilePath(p_source_name))
          then begin
              display('source dir not there');
              exit;
            end
          else display('  source_dir ok');

        if not FileExists(p_source_name)
          then begin
              display('source file not there');
              exit;
            end
          else display('  source_file ok');

        if not DirectoryExists(ExtractFilePath(p_destination_name))
          then begin
              display('destination dir not there');
              exit;
            end
          else display('  dest_dir ok');

        copy_file(p_source_name, p_destination_name);
        Result:= True;
      end; // check_and_copy_file

    procedure rename_file(p_complete_source_name, p_destination_name: String);
        // -- pb win XT: seems to change the copy to the current dir ?
        // -- when uses "u_find_files_in_dir", deletes and copies to the root of
        // --  the directory listbox !!
      var l_path, l_source_name, l_destination_name, l_complete_destination_name: String;
          l_file: File;
          l_save_current_dir: String;
      begin
        l_path:= ExtractFilePath(p_complete_source_name);
        l_source_name:= ExtractFileName(p_complete_source_name);
        l_destination_name:= ExtractFileName(p_destination_name);

        if FileExists(p_complete_source_name)
          then begin
              l_complete_destination_name:= l_path+ l_destination_name;

              // -- if a files exists with the new name, erase it first
              if FileExists(l_complete_destination_name)
                then begin
                    AssignFile(l_file, l_complete_destination_name);
                    Erase(l_file);
                  end;

              // RenameFile(p_complete_source_name, l_destination_name);

              // -- for c_to_pas did copy in the current dir (in addition to renaming)
              // -- but also had a bug in the source segment/
              //-- used
              l_save_current_dir:= GetCurrentDir;
              ChDir(l_path);

              RenameFile(p_complete_source_name, l_destination_name);

              ChDir(l_save_current_dir);
            end
          else display_bug_stop('no_original '+ p_complete_source_name);
(*
      var l_path, l_source_name, l_destination_name, l_complete_destination_name: String;
          l_file: File;
      begin
        l_path:= ExtractFilePath(p_complete_source_name);
        l_source_name:= ExtractFileName(p_complete_source_name);
        l_destination_name:= ExtractFileName(p_destination_name);

        if FileExists(p_complete_source_name)
          then begin
              display('ok '+ l_destination_name);
              l_complete_destination_name:= l_path+ l_destination_name;
              if FileExists(l_complete_destination_name)
                then begin
                    AssignFile(l_file, l_complete_destination_name);
                    Erase(l_file);
                  end;
              RenameFile(p_complete_source_name, l_destination_name);
            end;
*)
      end; // rename_file

    function f_only_alpha_numeric(p_text: String): String;
      var l_index: Integer;
      begin
        Result:= p_text;
        for l_index:= 1 to Length(Result) do
          if not (Result[l_index] in ['a'..'z', 'A'..'Z', '0'..'9', '_'])
            then Result[l_index]:= '_';
      end; // f_only_alpha_numeric

    procedure check_path_and_name(p_name: String);
      var l_index: Integer;
          l_path, l_file_name, l_name: String;
      begin
        if FileExists(p_name)
          then begin
              display('EXISTS');
              exit;
            end;

        l_path:= ExtractFilePath(p_name);
        if (l_path= p_name) and DirectoryExists(l_path)
          then begin
              display('DIR_EXISTS');
              Exit;
            end;

        display_line; display('not_found');
        display(p_name);

        l_file_name:= ExtractFileName(p_name);

        display(l_path);
        l_name:= '';
        for l_index:= 1 to Length(l_path) do
        begin
          if l_path[l_index]= '\'
            then begin
                if DirectoryExists(l_name)
                  then display('ok '+ l_name)
                  else begin
                      display('*** NO ');
                      display(' >'+ l_name+ '<');
                      ShowMessage('NO '+ l_name);
                      exit;
                    end;
              end;

          l_name:= l_name+ l_path[l_index];
        end;
      end; // check_path_and_name

    function f_exe_file_name: String;
      begin
        Result:= ExtractFileName(Application.ExeName);
      end; // f_exe_file_name
        
    function f_unique_file_name(p_full_name: String): String;
        // -- in this path, from "xxx" create unique "xxx_nnn"
      var l_path, l_name, l_extension: String;
          l_extension_length: Integer;
          l_base_file_name: String;
          l_index: Integer;
          l_index_string: String;
      begin
        l_path:= ExtractFilePath(p_full_name);
        l_name:= ExtractFileName(p_full_name);
        l_extension:= ExtractFileExt(p_full_name);

        l_extension_length:= Length(l_extension);
        if l_extension_length> 0
          then Delete(l_name, Length(l_name)- l_extension_length+ 1, l_extension_length);

        if not DirectoryExists(l_path)
          then ForceDirectories(l_path)
          ;
(*
        // -- if "c:/xxx/yyy" and ".htm" has to make sure that does not exist "c:/xxx/yyy"
          else begin
              if l_name= ''
                then begin
                    l_path:= l_path+ '\';
                    ForceDirectories(l_path);
                  end;
            end;
*)
        // display(l_path+ '-'+ l_name+ '-'+ l_extension+ '-');

        l_base_file_name:= l_path+ l_name+ '_';
        l_index:= 0;

        repeat
          l_index_string:= IntToStr(l_index);
          Inc(l_index);

          Result:= l_base_file_name+ l_index_string+ l_extension;
        until not FileExists(Result);
     end; // f_unique_file_name

    function f_file_size(p_file_name: String): Integer;
      var l_file: File;
      begin
        If FileExists(p_file_name)
          then begin
              Assign(l_file, p_file_name);
              Reset(l_file, 1);
              Result:= FileSize(l_file);
              Close(l_file);
            end
          else Result:= -1;
      end; // f_file_size

    end.



