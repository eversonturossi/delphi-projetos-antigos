{ Wheberson Hudson Migueletti, em Brasília, 2 de julho de 2000.
  Internet   : http://www.geocities.com/whebersite
  E-mail     : whebersite@zipmail.com.br
  Referências: 1) byHeart Home Page - Ian Ashdown
                  ftp://ftp.ledalite.com/pub/octree.zip
                  http://persweb.direct.ca/byheart/Ashdown.html
               2) Microsoft Foundation Class Library: PalGen - Jeff Prosise
                  http://www.microsoft.com/MSJ/1097/WICKED1097.HTM
               3) ShowDemoOne/ColorQuantizationLibrary - Earl F. Glynn
                  http://www.efg2.com
               4) DITHER.TXT - Lee Crocker
               5) Mathematical Elements of Computer Graphics
                  http://claymore.engineer.gvsu.edu/eod/software/compgraf/compgraf.html
               6) Color Image Quantization for Frame Buffer Display - Paul S. Heckbert
                  http://www.cs.cmu.edu/afs/cs.cmu.edu/Web/People/ph
                  http://www.cs.cmu.edu/afs/cs.cmu.edu/Web/People/ph/ciq_thesis
               7) An Overview of Color Quantization Techniques
                  http://www.cs.wpi.edu/~matt/courses/cs563/talks/color_quant/CQindex.html
               8) Octree Color Quantization - Nils Pipenbrinck
                  http://www.cubic.org/~submissive/sourcerer/octree.htm
               9) Color Image Quantization
                  http://web.cs.ualberta.ca/~oleg/quantization.html

  Code adapted from [1], [2], [3] and [4] }

unit DelphiColorQuantization;

interface

uses Windows, SysUtils, Classes, Graphics;

const
  cOctreeDepth= 8;

type
  TRGBSum= record
    Red, Green, Blue: Integer;
  end;

  TOctreeNode= class;

  TOctreeNodeArray= array[0..cOctreeDepth-1] of TOctreeNode;

  TOctreeNode= class
    protected
      IsLeaf: Boolean;
      Level : Byte;
      Count : Integer;
      Next  : TOctreeNode;
      Child : TOctreeNodeArray;
      Sum   : TRGBSum;
    public
      Index: SmallInt;

      constructor Create (ALevel: Byte);
      destructor  Destroy; override;
      procedure   Add (Red, Green, Blue: Byte);
      procedure   Get (var Red, Green, Blue: Byte);
  end;

  TOctree= class
    protected
      ReducibleNodes: TOctreeNodeArray;

      function GetIndex (Red, Green, Blue, Level: Byte): Byte;
    public
      Leaves: Integer; // Quantidade de cores diferentes
      Tree  : TOctreeNode;

      constructor Create;
      destructor  Destroy; override;
      procedure   Reduce;
      procedure   Add (Red, Green, Blue: Byte);
      function    Get (Red, Green, Blue: Byte): Byte;
      procedure   Delete (var Node: TOctreeNode);
  end;

procedure SetPixelFormat (var Bitmap: TBitmap; PixelFormat: TPixelFormat);

implementation

const
  cRGBSum_Zero         : TRGBSum         = (Red: 0; Green: 0; Blue: 0);
  cOctreeNodeArray_Null: TOctreeNodeArray= (nil, nil, nil, nil, nil, nil, nil, nil);

type
  PLine08 = ^TLine08;
  PLine24 = ^TLine24;
  TLine08 = array[0..0] of Byte;
  TLine24 = array[0..0] of TRGBTriple;
  TPalette= array[Byte] of TPaletteEntry;




// Floyd/Steinberg error diffusion dithering
procedure Dither (Original: TBitmap; var Bitmap: TBitmap; ColorMap: TPalette; ColorMapLength: Integer);
type
  PLineRGB= ^TLineRGB;
  TRGB    = record
              Red, Green, Blue: Real;
            end;
  TLineRGB= array[0..0] of TRGB;

var
  C             : Byte;
  NearestColor  : Byte;
  HPal          : HPALETTE;
  X, Y          : Integer;
  BitmapLine    : PLine08;
  OriginalLine  : PLine24;
  ErrorsNextLine: PLineRGB;
  Pal           : PLogPalette;
  PixelFormat   : TPixelFormat;
  Error         : TRGB;
  Error_1_16    : TRGB;
  Error_3_16    : TRGB;
  Error_5_16    : TRGB;
  Error_7_16    : TRGB;
  Color         : TRGBTriple;

const
  cRGB_Zero: TRGB= (Red: 0; Green: 0; Blue: 0);

 function Clip (Value: Integer): Byte;

 begin
   if Value < 0 then
     Result:= 0
   else if Value > 255 then
     Result:= 255
   else
     Result:= Value;
 end;

 procedure Get_Nearest_Color;

 begin
   NearestColor:= GetNearestPaletteIndex (HPal, RGB (Color.rgbtRed, Color.rgbtGreen, Color.rgbtBlue));
 end;

 procedure PutColor;

 begin
   case PixelFormat of
     pf8bit: BitmapLine[X]:= NearestColor;
     pf4bit: case (X mod 2) of
               0: BitmapLine[X shr 1]:= NearestColor shl 4;
               1: BitmapLine[X shr 1]:= BitmapLine[X shr 1] or NearestColor;
             end;
     pf1bit: BitmapLine[X div 8]:= (BitmapLine[X div 8] and (not (128 shr (X mod 8)))) or (NearestColor shl (7-(X mod 8)));
   end;
 end;

begin
  if Assigned (Original) and Assigned (Bitmap) and (Original.PixelFormat = pf24bit) and (Bitmap.PixelFormat in [pf1bit, pf4bit, pf8bit]) then begin
    GetMem (ErrorsNextLine, Original.Width*SizeOf (TRGB));
    try
      Pal:= nil;
      try
        GetMem (Pal, SizeOf (TLogPalette) + Sizeof (TPaletteEntry)*ColorMapLength);
        Pal.palVersion   := $300;
        Pal.palNumEntries:= ColorMapLength;
        for X:= 0 to ColorMapLength-1 do 
          Pal.palPalEntry[X]:= ColorMap[X];
        HPal:= CreatePalette (Pal^);
        if HPal <> 0 then
          Bitmap.Palette:= HPal;
      finally
        FreeMem (Pal);
      end;

      PixelFormat:= Bitmap.PixelFormat;
      for X:= 0 to Original.Width-1 do
        ErrorsNextLine[X]:= cRGB_Zero;
      for Y:= 0 to Original.Height-1 do begin
        OriginalLine:= Original.ScanLine[Y];
        BitmapLine  := Bitmap.ScanLine[Y];
        Error_7_16  := cRGB_Zero;
        for X:= 0 to Original.Width-1 do begin
          Color.rgbtRed  := Clip (Round (OriginalLine[X].rgbtRed   + Error_7_16.Red   + ErrorsNextLine[X].Red));
          Color.rgbtGreen:= Clip (Round (OriginalLine[X].rgbtGreen + Error_7_16.Green + ErrorsNextLine[X].Green));
          Color.rgbtBlue := Clip (Round (OriginalLine[X].rgbtBlue  + Error_7_16.Blue  + ErrorsNextLine[X].Blue));

          Get_Nearest_Color;
          PutColor;

          Error.Red       := Color.rgbtRed   - ColorMap[NearestColor].peRed;
          Error.Green     := Color.rgbtGreen - ColorMap[NearestColor].peGreen;
          Error.Blue      := Color.rgbtBlue  - ColorMap[NearestColor].peBlue;

          Error_7_16.Red  := (7/16)*Error.Red;
          Error_7_16.Green:= (7/16)*Error.Green;
          Error_7_16.Blue := (7/16)*Error.Blue;

          Error_1_16.Red  := (1/16)*Error.Red;
          Error_1_16.Green:= (1/16)*Error.Green;
          Error_1_16.Blue := (1/16)*Error.Blue;

          Error_5_16.Red  := (5/16)*Error.Red;
          Error_5_16.Green:= (5/16)*Error.Green;
          Error_5_16.Blue := (5/16)*Error.Blue;

          Error_3_16.Red  := (3/16)*Error.Red;
          Error_3_16.Green:= (3/16)*Error.Green;
          Error_3_16.Blue := (3/16)*Error.Blue;

          if X > 0 then
            with ErrorsNextLine[X-1] do begin
              Red  := Red   + Error_3_16.Red;
              Green:= Green + Error_3_16.Green;
              Blue := Blue  + Error_3_16.Blue;
            end;

          if X = 0 then 
            with ErrorsNextLine[X] do begin
              Red  := Error_5_16.Red;
              Green:= Error_5_16.Green;
              Blue := Error_5_16.Blue;
            end
          else
            with ErrorsNextLine[X] do begin
              Red  := Red   + Error_5_16.Red;
              Green:= Green + Error_5_16.Green;
              Blue := Blue  + Error_5_16.Blue;
            end;

          if X < Original.Width-1 then
            with ErrorsNextLine[X+1] do begin
              Red  := Error_1_16.Red;
              Green:= Error_1_16.Green;
              Blue := Error_1_16.Blue;
            end;
        end;
      end;
    finally
      FreeMem (ErrorsNextLine);
    end;
  end;
end;





procedure SetPixelFormat (var Bitmap: TBitmap; PixelFormat: TPixelFormat);
var
  Input         : PLine24;
  ColorMapLength: SmallInt;
  BitmapTmp     : TBitmap;
  Octree        : TOctree;
  ColorMap      : TPalette;

 procedure EvaluationColors;
 var
   X, Y: Integer;

 begin
   for Y:= Bitmap.Height-1 downto 0 do begin
     Input:= Bitmap.ScanLine[Y];
     for X:= 0 to Bitmap.Width-1 do begin
       Octree.Add (Input[X].rgbtRed, Input[X].rgbtGreen, Input[X].rgbtBlue);
       while Octree.Leaves > ColorMapLength do
         Octree.Reduce;
     end;
   end;
 end;

 procedure FillingColorMap;
 var
   Count: SmallInt;

  procedure Fill (Node: TOctreeNode);
  var
    I: SmallInt;

  begin
    if Assigned (Node) then
      if Node.IsLeaf then begin
        Inc (Count);
        Node.Index:= Count;
        Node.Get (ColorMap[Count].peRed, ColorMap[Count].peGreen, ColorMap[Count].peBlue);
      end
      else
        for I:= Low (Node.Child) to High (Node.Child) do
          Fill (Node.Child[I]);
  end;

 begin
   Count:= -1;
   Fill (Octree.Tree);
 end;

 function RGBToPaletteEntry (R, G, B: Byte): TPaletteEntry;

 begin
   Result.peRed  := R;
   Result.peGreen:= G;
   Result.peBlue := B;
   Result.peFlags:= 0;
 end;

begin
  if Assigned (Bitmap) and (Bitmap.PixelFormat <> PixelFormat) then
    if not (PixelFormat in [pf1bit, pf4bit, pf8bit]) then
      Bitmap.PixelFormat:= PixelFormat
    else begin
      Bitmap.PixelFormat:= pf24bit;
      case PixelFormat of
        pf1bit: ColorMapLength:= 002;
        pf4bit: ColorMapLength:= 016;
        pf8bit: ColorMapLength:= 256;
      end;
      if PixelFormat = pf1bit then begin
        ColorMap[0]:= RGBToPaletteEntry (0, 0, 0);
        ColorMap[1]:= RGBToPaletteEntry (255, 255, 255);
      end
      else begin
        Octree:= TOctree.Create;
        try
          EvaluationColors;
          FillingColorMap;
        finally
          Octree.Free;
        end;
      end;
      BitmapTmp:= TBitmap.Create;
      try
        BitmapTmp.PixelFormat:= PixelFormat;
        BitmapTmp.Width      := Bitmap.Width;
        BitmapTmp.Height     := Bitmap.Height;
        Dither (Bitmap, BitmapTmp, ColorMap, ColorMapLength);
        Bitmap.Assign (BitmapTmp);
      finally
        BitmapTmp.Free;
      end;
      Bitmap.IgnorePalette:= False;
    end;
end;




//------------------------------------------------------------------------------
constructor TOctreeNode.Create (ALevel: Byte);

begin
  inherited Create;

  Level := ALevel;
  IsLeaf:= Level = cOctreeDepth;
  Index := 0;
  Count := 0;
  Next  := nil;
  Sum   := cRGBSum_Zero;
  Child := cOctreeNodeArray_Null;
end;





destructor TOctreeNode.Destroy;
var
  I: Byte;

begin
  for I:= Low (Child) to High (Child) do
    Child[I].Free;

  inherited Destroy;
end;





procedure TOctreeNode.Add (Red, Green, Blue: Byte);

begin
  Inc (Count);
  Inc (Sum.Red, Red);
  Inc (Sum.Green, Green);
  Inc (Sum.Blue, Blue);
end;





procedure TOctreeNode.Get (var Red, Green, Blue: Byte);

begin
  if Count > 0 then begin
    Red  := Sum.Red   div Count;
    Green:= Sum.Green div Count;
    Blue := Sum.Blue  div Count;
  end;  
end;




//------------------------------------------------------------------------------
constructor TOctree.Create;

begin
  inherited Create;

  Leaves        := 0;
  Tree          := nil;
  ReducibleNodes:= cOctreeNodeArray_Null;
end;





destructor TOctree.Destroy;

begin
  Delete (Tree);

  inherited Destroy;
end;





procedure TOctree.Reduce;
var
  I   : Integer;
  Node: TOctreeNode;

begin
  I:= cOctreeDepth-1;
  while (I > 0) and (not Assigned (ReducibleNodes[I])) do
    Dec (I);

  Node             := ReducibleNodes[I];
  ReducibleNodes[I]:= Node.Next;
  Node.IsLeaf      := True;
  Node.Sum         := cRGBSum_Zero;
  Node.Count       := 0;
  Inc (Leaves);

  for I:= Low (ReducibleNodes) to High (ReducibleNodes) do
    if Assigned (Node.Child[I]) then begin
      Inc (Node.Sum.Red, Node.Child[I].Sum.Red);
      Inc (Node.Sum.Green, Node.Child[I].Sum.Green);
      Inc (Node.Sum.Blue, Node.Child[I].Sum.Blue);
      Inc (Node.Count, Node.Child[I].Count);
      Node.Child[I].Free;
      Node.Child[I]:= nil;
      Dec (Leaves);
    end;
end;





procedure TOctree.Add (Red, Green, Blue: Byte);

 // Coloca o RGB no nível 8, criando caso necessário os níveis intermediários 
 procedure AddColor (var Node: TOctreeNode; Level: Byte);

 begin
   if not Assigned (Node) then begin
     Node:= TOctreeNode.Create (Level);
     if Node.IsLeaf then begin
       Node.Next:= nil;
       Inc (Leaves);
     end
     else begin
       Node.Next            := ReducibleNodes[Level];
       ReducibleNodes[Level]:= Node;
     end;
   end;
   if Node.IsLeaf then
     Node.Add (Red, Green, Blue)
   else
     AddColor (Node.Child[GetIndex (Red, Green, Blue, Level)], Level+1);
 end;

begin
  AddColor (Tree, 0);
end;




// Processo inverso ao "Add"
function TOctree.Get (Red, Green, Blue: Byte): Byte;

 function GetColor (Node: TOctreeNode; Level: Byte): Byte;

 begin
   if Assigned (Node) then
     if Node.IsLeaf then
       Result:= Node.Index
     else
       Result:= GetColor (Node.Child[GetIndex (Red, Green, Blue, Level)], Level+1);
 end;

begin
  Result:= GetColor (Tree, 0);
end;





procedure TOctree.Delete (var Node: TOctreeNode);
var
  I: Byte;
  
begin
  if Assigned (Node) then begin
    for I:= Low (Node.Child) to High (Node.Child) do
      Delete (Node.Child[I]);
    Node.Free;
    Node:= nil;
  end;
end;




// Calcula a posição (entre 0 e 7) no nó filho ("TOctreeNode.Child") aonde o RGB deve ser armazenado
function TOctree.GetIndex (Red, Green, Blue, Level: Byte): Byte;
const
  cMask: array[0..7] of Byte= (128, 64, 32, 16, 8, 4, 2, 1);

var
  Shift: Byte;

begin
  Shift := 7-Level;
  Result:= (((Red and cMask[Level]) shr Shift) shl 2) or (((Green and cMask[Level]) shr Shift) shl 1) or ((Blue and cMask[Level]) shr Shift);
end;

end.
