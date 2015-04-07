unit MainUnit;

interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
 Dialogs, ExtDlgs, Menus, ExtCtrls, StdCtrls;

type
 TRGBTripleArray = array[0..1000] of RGBTriple;
 PRGBTripleArray = ^TRGBTripleArray;
 
 TPoints = array of TPoint;
 
 TForm1 = class(TForm)
  Image1: TImage;
  MainMenu1: TMainMenu;
  File1: TMenuItem;
  Open1: TMenuItem;
  N1: TMenuItem;
  Exit1: TMenuItem;
  OpenPictureDialog1: TOpenPictureDialog;
  Button1: TButton;
  Button2: TButton;
  SaveAs1: TMenuItem;
  SavePictureDialog1: TSavePictureDialog;
  N2: TMenuItem;
  Animate1: TMenuItem;
  procedure Exit1Click(Sender: TObject);
  procedure Open1Click(Sender: TObject);
  procedure Button1Click(Sender: TObject);
  procedure Skeletonize(var Points: TPoints; AWidth, AHeight: integer);
  procedure SkeletonizeAnimate(var Points: TPoints; AWidth, AHeight: integer);
  function Neighbour(ANeighbour: byte): TPoint;
  procedure FormCreate(Sender: TObject);
  procedure Button2Click(Sender: TObject);
  procedure SaveAs1Click(Sender: TObject);
  procedure Animate1Click(Sender: TObject);
 private
  { Private declarations }
  UndoBitmap: TBitmap;
 public
  { Public declarations }
 end;
 
var
 Form1: TForm1;
 
implementation

{$R *.dfm}

// initialization

procedure TForm1.FormCreate(Sender: TObject);
begin
 UndoBitmap := TBitmap.Create;
 UndoBitmap.PixelFormat := pf24bit;
end;

// open an image

procedure TForm1.Open1Click(Sender: TObject);
begin
 if not OpenPictureDialog1.Execute then Exit;
 Image1.Picture.Bitmap.LoadFromFile(OpenPictureDialog1.FileName);
 Image1.Picture.Bitmap.PixelFormat := pf24bit;
 Image1.AutoSize := True;
 Button1.Enabled := True;
end;

// save the image as a bitmap

procedure TForm1.SaveAs1Click(Sender: TObject);
begin
 if not SavePictureDialog1.Execute then Exit;
 Image1.Picture.Bitmap.PixelFormat := pf1bit;
 Image1.Picture.Bitmap.SaveToFile(SavePictureDialog1.FileName);
 Image1.Picture.Bitmap.PixelFormat := pf24bit;
end;

// exit

procedure TForm1.Exit1Click(Sender: TObject);
begin
 Close;
end;

// skeletonize the image

procedure TForm1.Button1Click(Sender: TObject);
var
 LScan: PRGBTripleArray;
 Lx, Ly: integer;
 LPoints: TPoints;
begin
 UndoBitmap.Width := Image1.Width;
 UndoBitmap.Height := Image1.Height;
 UndoBitmap.Canvas.Draw(0, 0, Image1.Picture.Bitmap);
 Button2.Enabled := True;
 // create a list of points from the image
 SetLength(LPoints, 0);
 for Ly := 0 to Image1.Height - 1 do
  begin
   LScan := Image1.Picture.Bitmap.ScanLine[Ly];
   for Lx := 0 to Image1.Width - 1 do
    begin
     if LScan[Lx].rgbtBlue = 0 then
      begin
       SetLength(LPoints, length(LPoints) + 1);
       LPoints[High(LPoints)] := Point(Lx, Ly);
      end;
    end;
  end;
 // skeletonize the list of points
 if Animate1.Checked then
  SkeletonizeAnimate(LPoints, Image1.Width, Image1.Height)
 else
  Skeletonize(LPoints, Image1.Width, Image1.Height);
 // draw the skeleton back on the image from the skeletonized points list
 Image1.Canvas.FillRect(Image1.ClientRect);
 for Ly := 0 to High(LPoints) do
  begin
   Image1.Canvas.Pixels[LPoints[Ly].X, LPoints[Ly].Y] := clblack;
  end;
end;

// undo the skeletonization by restoring the previous bitmap to the image

procedure TForm1.Button2Click(Sender: TObject);
begin
 Image1.Canvas.Draw(0, 0, UndoBitmap);
 Button2.Enabled := False;
end;

// thin a binary image to a single pixel width skeleton by erosion

procedure TForm1.Skeletonize(var Points: TPoints;
 AWidth, AHeight: integer);
var
 Lx, Ly, Lindex: integer;
 LB, LA, LN, LAN6, LAN4: byte;
 LNOff: TPoint;
 LChanging: boolean;
 LRemove: array of boolean;
 LImage: array of array of byte;
begin
 // create a 2D image from the points - LImage array
 // the LImage array will be larger than the actual image
 // and offset by 1 in x and y to prevent access violations
 // when accessing neighbouring points to those at the edge of the image
 SetLength(LImage, AWidth + 3);
 for Lx := 0 to AWidth + 2 do
  begin
   SetLength(LImage[Lx], AHeight + 3);
   for Ly := 0 to AHeight + 2 do begin
     LImage[Lx][Ly] := 0;
    end;
  end;
 for Lindex := 0 to High(Points) do
  LImage[Points[Lindex].X + 1][Points[Lindex].Y + 1] := 1;
 SetLength(LRemove, length(Points));
 LChanging := True;
 while LChanging do begin // stop if pixels are no longer being removed
   LChanging := False;
   // loop through all points in the binary object
   for Lindex := 0 to High(Points) do
    begin
     LRemove[Lindex] := False;
     Lx := Points[Lindex].X + 1;
     Ly := Points[Lindex].Y + 1;
     // calculate B
     // B is the sum of non-zero neighbours
     LB := 0;
     for LN := 2 to 9 do
      begin
       LNOff := Neighbour(LN);
       Inc(LB, LImage[Lx + LNOff.X][Ly + LNOff.Y]);
      end;
     if (LB < 2) or (LB > 6) then Continue; // failed B removal test
     // calculate A
     // A is the number of 0 -> 1 patterns around the neighbourhood
     LA := 0;
     for LN := 2 to 9 do
      begin
       LNOff := Neighbour(LN);
       if LImage[Lx + LNOff.X][Ly + LNOff.Y] = 0 then
        begin
         LNOff := Neighbour(LN + 1);
         if LImage[Lx + LNOff.X][Ly + LNOff.Y] = 1 then
          Inc(LA);
        end;
       if LA > 1 then
        Break; // fails if LA <> 1 so no need to continue
      end;
     if LA <> 1 then
      Continue; // failed A removal test
     // calculate the A value for neighbour 6
     LAN6 := 0;
     for LN := 2 to 9 do
      begin
       LNOff := Neighbour(LN);
       if LImage[Lx + LNOff.X][Ly + LNOff.Y + 1] = 0 then
        begin
         LNOff := Neighbour(LN + 1);
         if LImage[Lx + LNOff.X][Ly + LNOff.Y + 1] = 1 then
          Inc(LAN6);
        end;
      end;
     if (LImage[Lx][Ly + 1] * LImage[Lx + 1][Ly] * LImage[Lx - 1][Ly] <> 0) and
      (LAN6 = 1) then
      Continue; // failed test
     // calculate the A value for neighbour 4
     LAN4 := 0;
     for LN := 2 to 9 do
      begin
       LNOff := Neighbour(LN);
       if LImage[Lx + LNOff.X + 1][Ly + LNOff.Y] = 0 then
        begin
         LNOff := Neighbour(LN + 1);
         if LImage[Lx + LNOff.X + 1][Ly + LNOff.Y] = 1 then
          Inc(LAN4);
        end;
      end;
     // final removal test
     if (LImage[Lx][Ly - 1] * LImage[Lx + 1][Ly] * LImage[Lx][Ly + 1] = 0) or
      (LAN4 <> 1) then
      begin
       // erosion cannot be done sequencially - so flag all points that
       // must be removed to remove them all at once after each pass
       LRemove[Lindex] := True;
       LChanging := True; // still removing pixels so continue for another pass
      end;
    end; // loop through points
   // remove the points that are flagged in the LRemove array
   if LChanging then
    begin
     Lindex := 0;
     while Lindex < length(Points) do
      begin
       if LRemove[Lindex] then
        begin
         // set value of image for this point to zero
         LImage[Points[Lindex].X + 1][Points[Lindex].Y + 1] := 0;
         // remove point from points list by moving the last element to the
         // points position and then reducing the length of the array by 1
         Points[Lindex] := Points[High(Points)];
         SetLength(Points, High(Points));
         // must do the same for this element in the LRemove array
         LRemove[Lindex] := LRemove[High(LRemove)];
         SetLength(LRemove, High(LRemove));
        end else Inc(Lindex);
      end;
    end;
  end; // passes loop
end;

// thin a binary image to a single pixel width skeleton by erosion

procedure TForm1.SkeletonizeAnimate(var Points: TPoints;
 AWidth, AHeight: integer);
var
 Lx, Ly, Lindex: integer;
 LB, LA, LN, LAN6, LAN4: byte;
 LNOff: TPoint;
 LChanging: boolean;
 LRemove: array of boolean;
 LImage: array of array of byte;
begin
 // create a 2D image from the points - LImage array
 // the LImage array will be larger than the actual image
 // and offset by 1 in x and y to prevent access violations
 // when accessing neighbouring points to those at the edge of the image
 SetLength(LImage, AWidth + 3);
 for Lx := 0 to AWidth + 2 do begin
   SetLength(LImage[Lx], AHeight + 3);
   for Ly := 0 to AHeight + 2 do begin
     LImage[Lx][Ly] := 0;
    end;
  end;
 for Lindex := 0 to High(Points) do
  LImage[Points[Lindex].X + 1][Points[Lindex].Y + 1] := 1;
 SetLength(LRemove, length(Points));
 LChanging := True;
 while LChanging do
  begin // stop if pixels are no longer being removed
   LChanging := False;
   // loop through all points in the binary object
   for Lindex := 0 to High(Points) do
    begin
     LRemove[Lindex] := False;
     Lx := Points[Lindex].X + 1;
     Ly := Points[Lindex].Y + 1;
     // calculate B
     // B is the sum of non-zero neighbours
     LB := 0;
     for LN := 2 to 9 do
      begin
       LNOff := Neighbour(LN);
       Inc(LB, LImage[Lx + LNOff.X][Ly + LNOff.Y]);
      end;
     if (LB < 2) or (LB > 6) then
      Continue; // failed B removal test
     // calculate A
     // A is the number of 0 -> 1 patterns around the neighbourhood
     LA := 0;
     for LN := 2 to 9 do
      begin
       LNOff := Neighbour(LN);
       if LImage[Lx + LNOff.X][Ly + LNOff.Y] = 0 then
        begin
         LNOff := Neighbour(LN + 1);
         if LImage[Lx + LNOff.X][Ly + LNOff.Y] = 1 then
          Inc(LA);
        end;
       if LA > 1 then
        Break; // fails if LA <> 1 so no need to continue
      end;
     if LA <> 1 then
      Continue; // failed A removal test
     // calculate the A value for neighbour 6
     LAN6 := 0;
     for LN := 2 to 9 do
      begin
       LNOff := Neighbour(LN);
       if LImage[Lx + LNOff.X][Ly + LNOff.Y + 1] = 0 then
        begin
         LNOff := Neighbour(LN + 1);
         if LImage[Lx + LNOff.X][Ly + LNOff.Y + 1] = 1 then
          Inc(LAN6);
        end;
      end;
     if (LImage[Lx][Ly + 1] * LImage[Lx + 1][Ly] * LImage[Lx - 1][Ly] <> 0) and
      (LAN6 = 1) then
      Continue; // failed test
     // calculate the A value for neighbour 4
     LAN4 := 0;
     for LN := 2 to 9 do
      begin
       LNOff := Neighbour(LN);
       if LImage[Lx + LNOff.X + 1][Ly + LNOff.Y] = 0 then
        begin
         LNOff := Neighbour(LN + 1);
         if LImage[Lx + LNOff.X + 1][Ly + LNOff.Y] = 1 then
          Inc(LAN4);
        end;
      end;
     // final removal test
     if (LImage[Lx][Ly - 1] * LImage[Lx + 1][Ly] * LImage[Lx][Ly + 1] = 0) or
      (LAN4 <> 1) then
      begin
       // erosion cannot be done sequencially - so flag all points that
       // must be removed to remove them all at once after each pass
       LRemove[Lindex] := True;
       LChanging := True; // still removing pixels so continue for another pass
      end;
    end; // loop through points
   // remove the points that are flagged in the LRemove array
   if LChanging then
    begin
     Lindex := 0;
     while Lindex < length(Points) do
      begin
       if LRemove[Lindex] then
        begin
         // set value of image for this point to zero
         LImage[Points[Lindex].X + 1][Points[Lindex].Y + 1] := 0;
         // remove point from points list by moving the last element to the
         // points position and then reducing the length of the array by 1
         Points[Lindex] := Points[High(Points)];
         SetLength(Points, High(Points));
         // must do the same for this element in the LRemove array
         LRemove[Lindex] := LRemove[High(LRemove)];
         SetLength(LRemove, High(LRemove));
        end else Inc(Lindex);
      end;
    end;
   // draw the skeleton back on the image from the skeletonized points list
   Image1.Canvas.FillRect(Image1.ClientRect);
   for Ly := 0 to High(Points) do
    begin
     Image1.Canvas.Pixels[Points[Ly].X, Points[Ly].Y] := clblack;
    end;
   Image1.Refresh;
   Sleep(100);
  end; // passes loop
end;

// return the offset of a neighbouring point

function TForm1.Neighbour(ANeighbour: byte): TPoint;
begin
 ANeighbour := (ANeighbour - 2) mod 8 + 2; // neighbourhood wrap-round
 case ANeighbour of
  2: begin
    Result.X := 0;
    Result.Y := -1;
   end; //    ___________
  3: begin
    Result.X := 1;
    Result.Y := -1;
   end; //   | 9 | 2 | 3 |
  4: begin
    Result.X := 1;
    Result.Y := 0;
   end; //   |___|___|___|
  5: begin
    Result.X := 1;
    Result.Y := 1;
   end; //   | 8 | 1 | 4 |
  6: begin
    Result.X := 0;
    Result.Y := 1;
   end; //   |___|___|___|
  7: begin
    Result.X := -1;
    Result.Y := 1;
   end; //   | 7 | 6 | 5 |
  8: begin
    Result.X := -1;
    Result.Y := 0;
   end; //   |___|___|___|
  9: begin
    Result.X := -1;
    Result.Y := -1;
   end; //
 end;
end;

procedure TForm1.Animate1Click(Sender: TObject);
begin
 Animate1.Checked := not Animate1.Checked;
end;

end.

