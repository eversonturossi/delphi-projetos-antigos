unit Unit1;

interface

uses
   Windows, Forms, Controls, StdCtrls, Classes, Messages;

type
   TForm1 = class(TForm)
    CloseBtn: TButton;
    Label1: TLabel;
      procedure FormCreate(Sender: TObject);
      procedure FormPaint(Sender: TObject);
      procedure CloseBtnClick(Sender: TObject);
      private
      { Private declarations }
      procedure WmNCHitTest(var Msg :TWMNCHitTest); message WM_NCHITTEST;
      public
      { Public declarations }
   end;

   var  Form1: TForm1;

   implementation
   {$R *.DFM}

   const
  { An array of points for the star region. }

 RgnPoints : array[1..10] of TPoint = ((X:203;Y:22), (X:157;Y:168), (X:3;Y:168),
                                       (X:128;Y:257), (X:81;Y:402), (X:203;Y:334),
                                       (X:325;Y:422), (X:278;Y:257), (X:402;Y:168),
                                       (X:249;Y:168));
  { An array of points used to draw a line    }
  { around the region in the OnPaint handler. }
  LinePoints : array[1..11] of TPoint =  ((X:199;Y:0), (X:154;Y:146), (X:2;Y:146),
                                          (X:127;Y:235), (X:79;Y:377), (X:198;Y:308),
                                          (X:320;Y:396), (X:272;Y:234),(X:396;Y:146),
                                          (X:244;Y:146), (X:199;Y:0));

 procedure TForm1.FormCreate(Sender: TObject);
 var  Rgn : HRGN;
 begin
 { Create a polygon region from our points. }
 Rgn := CreatePolygonRgn(RgnPoints, High(RgnPoints), ALTERNATE);
 { Set the window region. }
 SetWindowRgn(Handle, Rgn, True);
 end;

 procedure TForm1.FormPaint(Sender: TObject);
 begin
 { Draw a line around the star. }
 Canvas.Pen.Width := 3;
 Canvas.Polyline(LinePoints);
 end;

 procedure TForm1.CloseBtnClick(Sender: TObject);
 begin
 Close();
 end;

 { Catch the WM_NCHITTEST message so the user }
{ can drag the window around the screen.     }
procedure TForm1. WmNCHitTest(var Msg: TWMNCHitTest);
begin
DefaultHandler(Msg);
if Msg.Result = HTCLIENT then
   Msg.Result := HTCAPTION;
end;

end.
