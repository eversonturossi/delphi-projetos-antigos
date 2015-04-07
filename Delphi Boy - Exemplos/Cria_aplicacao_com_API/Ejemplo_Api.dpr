{Bueno, este ejemplo tratara de mostraros como elaborar una aplicacion sencilla utilizando
 llamadas a API, para crearla debereis hacer una Console Application y quitar la directiva
 (*$APPTYPE CONSOLE*) despues añadir a uses Windows y Messages, y el resto lo esplico paso
 a paso a lo largo del programa. Si bien escribir aplicacion con API es mas complicado tiene
 la gran ventaja de que los programas son pequeñisimos, Este por ejemplo sin APi serian unos
 300 Kb, con API 40 kb ;-)}

 {Copyright ® MrRidk 2000-2001 All rights reserved}
 {ridk@hotmail.com -- http://www.mrridk.cjb.net}
program Ejemplo_Api;

uses
 Windows,
 Messages,
 SysUtils;

var
 Clase: TWndClassA; // Definimos Variables.
 Mensaje: tmsg; // Definimos la variable del mensaje de windows
 Label1, Label2, Label3, Edit1, Edit2, Edit3: Integer; // Definimos variables
 Buton1, Buton2, Fuente, Handle, Instancia: Integer; // Definimos variables.
 Sumando1, Sumando2: Pchar; // Definimos variables.
 Valor, Longitud: Integer; // Definimos Variables
 
function WindowProc(hWnd, uMsg, wParam, lParam: Integer): Integer; stdcall; // Definimos la variable encargada de procesar los mensajes.
begin
 Result := DefWindowProc(hWnd, uMsg, wParam, lParam);
 if (uMsg = WM_DESTROY) then Halt; // Si damos al boton de la X, la aplicacion termina
 
 if (lParam = Buton2) and (uMsg = WM_COMMAND) then begin // Si el mensaje viene del boton y es la pulsacion de este . . .
   Halt; // Cerramos la Aplicacion.
  end;
 if (lParam = Buton1) and (uMsg = WM_COMMAND) then begin // Si el mensaje viene del boton y es la pulsacion de este . . .
   Longitud := GetWindowTextLength(Edit1); // Averiguamos cual es la longitud del texto de la primera edit
   GetMem(Sumando1, Longitud + 1); // Cogemos memoria para el texto.
   GetWindowText(Edit1, Sumando1, Longitud + 1); // COgemos el texto que hay en el edit y lo almacenamos en la variable Sumando1
   Longitud := GetWindowTextLength(Edit2); // Averiguamos cual es la longitud del texto de la segunda edit
   GetMem(Sumando2, Longitud + 1); // Cogemos memoria para el texto.
   GetWindowText(Edit2, Sumando2, Longitud + 1); // Cogemos el texto que hay en el edit y lo almacenamos en la variable Sumando2
   Valor := StrToInt(Sumando1) + StrToInt(Sumando2); // Realizamos la suma.
   SetWindowText(Edit3, Pchar(IntToStr(Valor))); // Ponemos el texto en el edit3
  end;
end;

begin
 Instancia := hInstance;
 { Damos a la variable instance, el handle que aplicara windows
   a nuestro programa }
 
 Fuente := CreateFont(-1, 0, 0, 0, 400, 0, 0, 0, DEFAULT_CHARSET,
  OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS,
  DEFAULT_QUALITY, DEFAULT_PITCH + FF_DONTCARE,
  'MS Sans Serif');
 { Creamos la fuente que usaremos en nuestra aplicacion }
 
 with Clase do begin // Comenzamos a definir la clase de nuestro programa
   Style := CS_CLASSDC or CS_PARENTDC; // Definimos el estilo
   lpfnWndProc := @WindowProc; // La funcion que manejara los mensajes
   hInstance := Instancia; // La handle de nuestra aplicacion
   hbrBackGround := Color_btnFace + 1; // El color de fondo
   lpszClassName := 'MrRidk'; // El nombre de la class
   hCursor := LoadCursor(0, IDC_ARROW); // El cursor que usara nuestra aplicacion
  end; // Fin
 
 RegisterClassA(Clase); // Registramos la clase en windows.
 
 Handle := CreateWindowEx(0, 'MrRidk', 'Ejemplo de Programa Con Api', WS_SYSMENU + WS_VISIBLE, 150, 150, 280, 140, 0, 0, Instancia, nil);
 {Creamos la ventana, Estilo, Clase,  Titulo,                        Estilo,                  Posicion,    Tamaño,      , El Padre de la ventana, El menu,  La hInstance, El lParam.}
{ ************************************************************************************************************ }
 
 Edit1 := CreateWindowEx(WS_EX_CLIENTEDGE, 'Edit', '3', WS_VISIBLE + WS_CHILD + BS_TEXT, 90, 10, 175, 20, Handle, 0, Instancia, nil);
 {Creamos la ventana, Estilo,         Tipo, Texto, Estilo,                  Posicion,Tamaño,Padre,Menu,hInstance,El lparam}
{ ************************************************************************************************************ }
 
 Edit2 := CreateWindowEx(WS_EX_CLIENTEDGE, 'Edit', '2', WS_VISIBLE + WS_CHILD + BS_TEXT, 90, 31, 175, 20, Handle, 0, Instancia, nil);
 {Creamos la ventana, Estilo,         Tipo, Texto, Estilo,                  Posicion,Tamaño,Padre,Menu,hInstance,El lparam}
{ ************************************************************************************************************ }
 
 Edit3 := CreateWindowEx(WS_EX_CLIENTEDGE, 'Edit', '5', WS_VISIBLE + WS_CHILD + BS_TEXT, 90, 52, 175, 20, Handle, 0, Instancia, nil);
 {Creamos la ventana, Estilo,         Tipo, Texto, Estilo,                  Posicion,Tamaño,Padre,Menu,hInstance,El lparam}
{ ************************************************************************************************************ }
 
 Label1 := CreateWindow('Static', 'Sumando 1:', WS_VISIBLE + WS_CHILD, 10, 16, 75, 20, Handle, 0, Instancia, nil);
 {Creamos la ventana, Tipo, Texto,    Estilo,               Posicion,Tamaño,Padre,Menu,hInstance,El lparam}
{ ************************************************************************************************************ }
 
 Label2 := CreateWindow('Static', 'Sumando 2:', WS_VISIBLE + WS_CHILD, 10, 37, 75, 20, Handle, 0, Instancia, nil);
 {Creamos la ventana, Tipo, Texto,    Estilo,               Posicion,Tamaño,Padre,Menu,hInstance,El lparam}
{ ************************************************************************************************************ }
 
 Label3 := CreateWindow('Static', 'Resultado:', WS_VISIBLE + WS_CHILD, 10, 57, 75, 20, Handle, 0, Instancia, nil);
 {Creamos la ventana, Tipo, Texto,    Estilo,               Posicion,Tamaño,Padre,Menu,hInstance,El lparam}
{ ************************************************************************************************************ }
 
 Buton1 := CreateWindow('Button', 'Sumar', WS_VISIBLE + WS_CHILD, 65, 85, 60, 20, Handle, 0, Instancia, nil);
 {Creamos la ventana, Tipo, Texto,    Estilo,               Posicion,Tamaño,Padre,Menu,hInstance,El lparam}
{ ************************************************************************************************************ }
 
 Buton2 := CreateWindow('Button', 'Salir', WS_VISIBLE + WS_CHILD, 150, 85, 60, 20, Handle, 0, Instancia, nil);
 {Creamos la ventana, Tipo, Texto,    Estilo,               Posicion,Tamaño,Padre,Menu,hInstance,El lparam}
{ ************************************************************************************************************ }
 
 SendMessage(Label1, WM_SETFONT, Fuente, Label1); // Ponemos la fuente que antes hemos definido
 SendMessage(Label2, WM_SETFONT, Fuente, Label1); // Ponemos la fuente que antes hemos definido
 SendMessage(Label3, WM_SETFONT, Fuente, Label1); // Ponemos la fuente que antes hemos definido
 SendMessage(Buton1, WM_SETFONT, Fuente, Buton1); // Ponemos la fuente que antes hemos definido
 SendMessage(Buton2, WM_SETFONT, Fuente, Buton2); // Ponemos la fuente que antes hemos definido
 SendMessage(Edit1, WM_SETFONT, Fuente, Edit1); // Ponemos la fuente que antes hemos definido
 SendMessage(Edit2, WM_SETFONT, Fuente, Edit2); // Ponemos la fuente que antes hemos definido
 SendMessage(Edit3, WM_SETFONT, Fuente, Edit3); // Ponemos la fuente que antes hemos definido
 
 while (GetMessage(Mensaje, Handle, 0, 0)) do // Vamos tratando los mensajes.
  begin
   TranslateMessage(Mensaje);
   DispatchMessage(Mensaje);
  end;
 
end.

