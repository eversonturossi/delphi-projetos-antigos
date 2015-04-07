unit MP20MICI;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    ComboBox1: TComboBox;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    GroupBox2: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Panel1: TPanel;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    PROCEDURE Button1Click(Sender: TObject);
    PROCEDURE Button2Click(Sender: TObject);
    PROCEDURE Button3Click(Sender: TObject);
    PROCEDURE ComboBox1Change(Sender: TObject);
    PROCEDURE Button5Click(Sender: TObject);
    PROCEDURE Button4Click(Sender: TObject);
    PROCEDURE Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  buffer, cmd: String;
  comunica: String;
  envia, porta, comando, fecha, modo: Integer;
  negrito, italico, sublinhado, expandido: Integer;

implementation

FUNCTION IniciaPorta(Porta:string):integer; stdcall; far; external 'Mp2032.dll';
FUNCTION FechaPorta:integer; stdcall; far; external 'Mp2032.dll';
FUNCTION BematechTX(BufTrans:string):integer; stdcall; far; external 'Mp2032.dll';
FUNCTION FormataTX(BufTras:string; TpoLtra:integer; Italic:integer; Sublin:integer; expand:integer; enfat:integer):integer; stdcall; far; external 'Mp2032.dll';
FUNCTION ComandoTX (BufTrans:string;TamBufTrans:integer):integer; stdcall; far; external 'Mp2032.dll';

{$R *.DFM}

// Imprime Texto sem Formatação.
PROCEDURE TForm1.Button1Click(Sender: TObject);
    BEGIN
        porta := IniciaPorta(Pchar(comunica));
        If porta <= 0 Then
           BEGIN
                showmessage('Problemas ao abrir a porta de Comunicação. Verifique.');
           END;
         buffer  := Edit1.Text + Chr(13) + Chr(10);
         comando := FormataTX(buffer, 3, 0, 0, 0, 0);
         fecha   := FechaPorta();
    END;

// Imprime Texto com Formatação.
PROCEDURE TForm1.Button2Click(Sender: TObject);
    BEGIN
         // Verifica modo NORMAL, ELITE ou CONDENSADO.
         If RadioButton1.Checked = True Then
            BEGIN
                 modo := 2;
            END;
         If RadioButton2.Checked = True Then
            BEGIN
                 modo := 3;
            END;
         If RadioButton3.Checked = True Then
            BEGIN
                 modo := 1;
            END;
         // Negrito, Itálico, Sublinhado e Expandido
         If (CheckBox1.Checked = True) And (CheckBox2.Checked = True) And
            (CheckBox3.Checked = True) And (CheckBox4.Checked = True) Then
                BEGIN
                     Negrito    := 1;
                     Italico    := 1;
                     Sublinhado := 1;
                     Expandido  := 1;
                END
            Else
                // sem Negrito, sem Italico, sem Sublinhado e sem Expandido
                If (CheckBox1.Checked = False) And (CheckBox2.Checked = False) And
                   (CheckBox3.Checked = False) And (CheckBox4.Checked = False) Then
                   BEGIN
                        Negrito    := 0;
                        Italico    := 0;
                        Sublinhado := 0;
                        Expandido  := 0;
                   END
            Else
                // Negrito, Itálico e Sublinhado
                If (CheckBox1.Checked = True) And (CheckBox2.Checked = True) And
                   (CheckBox3.Checked = True) Then
                   BEGIN
                        Negrito    := 1;
                        Italico    := 1;
                        Sublinhado := 1;
                        Expandido  := 0;
                   END
            Else
                // Negrito e Itálico
                If (CheckBox1.Checked = True) And (CheckBox2.Checked = True) Then
                   BEGIN
                        Negrito    := 1;
                        Italico    := 1;
                        Sublinhado := 0;
                        Expandido  := 0;
                   END
            Else
                // Negrito e Expandido
                If (CheckBox1.Checked = True) And (CheckBox4.Checked) = True Then
                   BEGIN
                        Negrito    := 1;
                        Italico    := 0;
                        Sublinhado := 0;
                        Expandido  := 1;
                   END
            Else
                // Negrito e Sublinhado
                If (CheckBox1.Checked = True) And (CheckBox3.Checked = True) Then
                   BEGIN
                        Negrito    := 1;
                        Italico    := 0;
                        Sublinhado := 1;
                        Expandido  := 0;
                   END
            Else
                // Italico e Expandido
                If (CheckBox2.Checked = True) And (CheckBox4.Checked = True) Then
                   BEGIN
                        Negrito    := 0;
                        Italico    := 1;
                        Sublinhado := 0;
                        Expandido  := 1;
                   END
            Else
                // Italico e Sublinhado
                If (CheckBox2.Checked = True) And (CheckBox3.Checked = True) Then
                   BEGIN
                        Negrito    := 0;
                        Italico    := 1;
                        Sublinhado := 1;
                        Expandido  := 0;
                   END
            Else
                // Sublinhado e Expandido
                If (CheckBox3.Checked = True) And (CheckBox4.Checked = True) Then
                   BEGIN
                        Negrito    := 0;
                        Italico    := 0;
                        Sublinhado := 1;
                        Expandido  := 1;
                   END
            Else
                // Negrito
                If (CheckBox1.Checked = True) Then
                   BEGIN
                        Negrito    := 1;
                        Italico    := 0;
                        Sublinhado := 0;
                        Expandido  := 0;
                   END
            Else
                // Italico
                If (CheckBox2.Checked = True) Then
                   BEGIN
                        Negrito    := 0;
                        Italico    := 1;
                        Sublinhado := 0;
                        Expandido  := 0;
                   END
            Else
                // Expandido
                If (CheckBox4.Checked = True) Then
                   BEGIN
                        Negrito    := 0;
                        Italico    := 0;
                        Sublinhado := 0;
                        Expandido  := 1;
                   END
            Else
                // Sublinhado
                If (CheckBox3.Checked = True) Then
                   BEGIN
                        Negrito    := 0;
                        Italico    := 0;
                        Sublinhado := 1;
                        Expandido  := 0;
                   END;
    // Envio do comando
    porta := IniciaPorta(Pchar(comunica));
    If porta <= 0 Then
       BEGIN
            showmessage('Problemas ao abrir a porta de Comunicação. Verifique.');
       END;
    buffer  := Edit1.Text + Chr(13) + Chr(10);
    comando := FormataTX(buffer, modo, Italico, Sublinhado, Expandido, Negrito);
    fecha   := FechaPorta();
END;

// Autentica Documento
PROCEDURE TForm1.Button3Click(Sender: TObject);
    BEGIN
        porta := IniciaPorta(Pchar(comunica));
        If porta <= 0 Then
           BEGIN
                showmessage('Problemas ao abrir a porta de Comunicação. Verifique.');
           END;
         comando := BematechTX(chr(27)+chr(97)+chr(1));
         envia   := FormataTX (Edit1.text + chr(13) + chr(10), 2, 0, 0, 0, 0);
         comando := BematechTX(chr(27)+chr(97)+chr(0));
         fecha   := FechaPorta();
    END;

PROCEDURE TForm1.ComboBox1Change(Sender: TObject);
    BEGIN
         If (ComboBox1.ItemIndex) = 0 Then
             BEGIN
                  comunica := 'LPT1';
             END;
         If (ComboBox1.ItemIndex) = 1 Then
             BEGIN
                  comunica := 'COM1';
             END;
         If (ComboBox1.ItemIndex) = 2 Then
             BEGIN
                 comunica := 'COM2';
             END;
    END;

PROCEDURE TForm1.Button5Click(Sender: TObject);
    BEGIN
         Application.Terminate;
         Exit;
    END;

PROCEDURE TForm1.Button4Click(Sender: TObject);
     BEGIN
         // Comando para Acionamento da GAVETA de Dinheiro
        porta := IniciaPorta(Pchar(comunica));
        If porta <= 0 Then
           BEGIN
                showmessage('Problemas ao abrir a porta de Comunicação. Verifique.');
           END;
         buffer := Chr(27) + Chr(118) + Chr(140);
         envia := ComandoTX(buffer, Length(buffer));
         fecha := FechaPorta();
     END;

// Comando para Imprimir Caracter de Autenticação.
PROCEDURE TForm1.Button6Click(Sender: TObject);
{
                  DESENHO

             1 2 3 4 5 6 7 8 9
bit 7 = 128  *               *
bit 6 = 064  * *             *
bit 5 = 032  * * *           *
bit 4 = 016  * * * *         *
bit 3 = 008  * * * * *       *
bit 2 = 004  * * * * * *     *
bit 1 = 002  * * * * * * *   *
bit 0 = 001  * * * * * * * * *
}
    BEGIN
        porta := IniciaPorta(Pchar(comunica));
        If porta <= 0 Then
           BEGIN
                showmessage('Problemas ao abrir a porta de Comunicação. Verifique.');
           END;

        // Comando que habilita o modo grafico com 9 pinos (9 colunas)
        cmd := chr(27) + chr(94) + chr(18) + chr(0);
        envia := ComandoTX(cmd, Length(cmd));

        // Sequencia de bytes para a montagem do desenho acima
        cmd := chr(255) + chr(0) + chr(0) + chr(0) + chr(127) + chr(0)
         + chr(0) + chr(0) + chr(063) + chr(0) + chr(0) + chr(0)
         + chr(031) + chr(0) + chr(0) + chr(0) + chr(015) + chr(0) + chr(0)
         + chr(0) + chr(007) + chr(0) + chr(0) + chr(0) + chr(003) + chr(0)
         + chr(0) + chr(0) + chr(001) + chr(0) + chr(0) + chr(0) + chr(255)
         + chr(0) + chr(0) + chr(0);
        envia := ComandoTX(cmd, Length(cmd));

        // Descarrega o buffer na impressora.
        cmd := chr(13) + chr(10);
        envia := ComandoTX(cmd, Length(cmd));
        fecha := FechaPorta();

END;


// Procedure de teste para a impressão em várias linhas.
procedure TForm1.Button7Click(Sender: TObject);
VAR X: INTEGER;
    BEGIN
        FOR X := 1 TO 10 DO
           BEGIN
               porta := IniciaPorta(Pchar(comunica));
               If porta <= 0 Then
                  BEGIN
                       showmessage('Problemas ao abrir a porta de Comunicação. Verifique.');
                  END;
               buffer  := 'TESTE DE IMPRESSAO' + Chr(13) + Chr(10);
               comando := FormataTX(buffer, 3, 0, 0, 0, 0);
               fecha   := FechaPorta();
           END;
    END;

END. //Fim do programa
