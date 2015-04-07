// Wheberson Hudson Migueletti, em Brasília.
// Internet   : http://www.geocities.com/whebersite
// E-mail     : whebersite@zipmail.com.br
// Assunto    : TTF - TrueType Font
// Referências: [1] TrueType 1.0 Font File Specification, Revision 1.66 (http://www.wotsit.org)
//              [2] http://fonts.apple.com

unit DelphiTTF;

interface

uses Windows, Classes, SysUtils;

const
  cTTFTagCMap= $636D6170; // cmap
  cTTFTagCVT = $63767420; // cvt
  cTTFTagFPgm= $6670676D; // fpgm
  cTTFTagGASP= $67617370; // gasp
  cTTFTagGlyf= $676C7966; // glyf
  cTTFTagHDMx= $68646D78; // hdmx
  cTTFTagHead= $68656164; // head
  cTTFTagHHea= $68686561; // hhea
  cTTFTagHMtx= $686D7478; // hmtx
  cTTFTagKern= $6B65726E; // kern
  cTTFTagLoca= $6C6F6361; // loca
  cTTFTagMaxP= $6D617870; // maxp
  cTTFTagName= $6E616D65; // name
  cTTFTagOS2 = $4F532F32; // OS/2
  cTTFTagPCLT= $50434C54; // PCLT
  cTTFTagPost= $706F7374; // post
  cTTFTagPrep= $70726570; // prep
  cTTFTagVDMX= $56444D58; // VDMX
  cTTFTagVHea= $76686561; // vhea
  cTTFTagVMtx= $766D7478; // vmtx

const
  // WGL4.0 Character Set
  cTTFGlyphName: array[0..257] of String= ('.notdef', '.null', 'nonmarkingreturn', 'space', 'exclam', 'quotedbl', 'numbersign', 'dollar',
                                           'percent', 'ampersand', 'quotesingle', 'parenleft', 'parenright', 'asterisk', 'plus', 'comma',
                                           'hyphen', 'period', 'slash', 'zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven',
                                           'eight', 'nine', 'colon', 'semicolon', 'less', 'equal', 'greater', 'question', 'at', 'A', 'B',
                                           'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U',
                                           'V', 'W', 'X', 'Y', 'Z', 'bracketleft', 'backslash', 'bracketright', 'asciicircum', 'underscore',
                                           'grave', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q',
                                           'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'braceleft', 'bar', 'braceright', 'asciitilde',
                                           'Adieresis', 'Aring', 'Ccedilla', 'Eacute', 'Ntilde', 'Odieresis', 'Udieresis', 'aacute',
                                           'agrave', 'acircumflex', 'adieresis', 'atilde', 'aring', 'ccedilla', 'eacute', 'egrave',
                                           'ecircumflex', 'edieresis', 'iacute', 'igrave', 'icircumflex', 'idieresis', 'ntilde', 'oacute',
                                           'ograve', 'ocircumflex', 'odieresis', 'otilde', 'uacute', 'ugrave', 'ucircumflex', 'udieresis',
                                           'dagger', 'degree', 'cent', 'sterling', 'section', 'bullet', 'paragraph', 'germandbls',
                                           'registered', 'copyright', 'trademark', 'acute', 'dieresis', 'notequal', 'AE', 'Oslash',
                                           'infinity', 'plusminus', 'lessequal', 'greaterequal',
                                           'yen', 'mu', 'partialdiff', 'summation', 'product', 'pi', 'integral', 'ordfeminine',
                                           'ordmasculine', 'Omega', 'ae', 'oslash', 'questiondown', 'exclamdown', 'logicalnot', 'radical',
                                           'florin', 'approxequal', 'Delta', 'guillemotleft', 'guillemotright', 'ellipsis',
                                           'nonbreakingspace', 'Agrave', 'Atilde', 'Otilde', 'OE', 'oe', 'endash', 'emdash', 'quotedblleft',
                                           'quotedblright', 'quoteleft', 'quoteright', 'divide', 'lozenge', 'ydieresis', 'Ydieresis',
                                           'fraction', 'currency', 'guilsinglleft', 'guilsinglright', 'fi', 'fl', 'daggerdbl',
                                           'periodcentered', 'quotesinglbase', 'quotedblbase', 'perthousand', 'Acircumflex',
                                           'Ecircumflex', 'Aacute', 'Edieresis', 'Egrave', 'Iacute', 'Icircumflex ', 'Idieresis', 'Igrave',
                                           'Oacute', 'Ocircumflex', 'apple', 'Ograve', 'Uacute', 'Ucircumflex', 'Ugrave', 'dotlessi',
                                           'circumflex', 'tilde', 'macron', 'breve', 'dotaccent', 'ring', 'cedilla', 'hungarumlaut',
                                           'ogonek', 'caron', 'Lslash', 'lslash', 'Scaron', 'scaron', 'Zcaron', 'zcaron', 'brokenbar',
                                           'Eth', 'eth', 'Yacute', 'yacute', 'Thorn', 'thorn', 'minus', 'multiply', 'onesuperior',
                                           'twosuperior', 'threesuperior', 'onehalf', 'onequarter', 'threequarters', 'franc', 'Gbreve',
                                           'gbreve', 'Idotaccent', 'Scedilla', 'scedilla', 'Cacute', 'cacute', 'Ccaron', 'ccaron', 'dcroat');

type
  TTTFCMapFormat= packed record
    FormatNumber: Word; // Format number is set to 0
    Len         : Word; // This is the length in bytes of the subtable
    Version     : Word; // Version number (starts at 0)
  end;

  TTTFCMapFormat0= array[0..255] of Byte; // An array that maps character codes to glyph index values

  TTTFCMapFormat2= array[0..255] of Word; // Array that maps high bytes to subHeaders: value is subHeader index * 8

  TTTFCMapFormat2SubHeader= packed record
    FirstCode    : Word;     // First valid low byte for this subHeader.
    EntryCount   : Word;     // Number of valid low bytes for this subHeader.
    IDDelta      : SmallInt;
    IDRangeOffset: Word;
  end;

  TTTFCMapFormat4= packed record
    SegCountX2   : Word; // 2 x SegCount
    SearchRange  : Word; // 2 x (2**Floor (Log2 (segCount)))
    EntrySelector: Word; // Log2 (SearchRange/2)
    RangeShift   : Word; // 2 x SegCount - SearchRange
  end;

  TTTFCMapFormat6= packed record
    FirstCode : Word; // First character code of subrange
    EntryCount: Word; // Number of character codes in subrange
  end;

  TTTFCMapHeader= packed record
    Version  : Word; // Table version number 
    NumTables: Word; // Number of encoding tables
  end;

  TTTFCMapSubtable= packed record
    PlatformID        : Word;  // Platform identifier
    PlatformSpecificID: Word;  // Platform-specific encoding identifier
    Offset            : ULong; // Offset from beginning of table to the subtable
  end;

  TTTFFontHeader= packed record
    Version           : Integer;
    FontRevision      : Integer;
    CheckSumAdjustment: Integer;
    MagicNumber       : Integer;         // 5F0F3CF5H
    Flags             : Word;
    UnitsPerEm        : Word;
    Created           : Comp;            // International date. The Date format used in this table follows the Macintosh convention of the number of seconds since 1904 (see Apple's Inside Macintosh series)
    Modified          : Comp;
    XMin              : SmallInt;
    YMin              : SmallInt;
    XMax              : SmallInt;
    YMax              : SmallInt;
    MacStyle          : Word;
    LowestRecPPEM     : Word;
    FontDirectionHint : SmallInt;
    IndexToLocFormat  : SmallInt;        // 0 for short offsets, 1 for long
    GlyphDataFormat   : SmallInt;
  end;

  TTTFGASPHeader= packed record
    Version  : Word; // Version number (set to 0)
    NumRanges: Word; // Number of records
  end;

  TTTFGASPRange= packed record
    RangeMaxPPEM     : Word; // Upper limit of range, in PPEM
    RangeGaspBehavior: Word; // Flags describing desired rasterizer behavior
  end;

  TTTFGlyfHeader= packed record
    NumberOfContours: SmallInt; // If the number of contours is greater than or equal to zero, this is a single glyph; if negative, this is a composite glyph
    XMin            : SmallInt; // Minimum x for coordinate data
    YMin            : SmallInt; // Minimum y for coordinate data
    XMax            : SmallInt; // Maximum x for coordinate data
    YMax            : SmallInt; // Maximum y for coordinate data
  end;

  TTTFHorizontalDeviceMetricsHeader= packed record
    Version   : Word;     // Table version number (starts at 0)
    NumRecords: SmallInt; // Number of device records
    Size      : Integer;  // Size of a device record, long aligned
  end;

  TTTFHorizontalDeviceRecord= packed record
    PixelSize: Byte; // Pixel size for following widths (as ppem)
    MaxWidth : Byte; // Maximum width
  end;

  TTTFHorizontalHeader= packed record
    Version            : Integer;  // 00010000H for version 1.0
    Ascender           : SmallInt; // Typographic ascent
    Descender          : SmallInt; // Typographic descent
    LineGap            : SmallInt; // Typographic line gap. Negative LineGap values are treated as zero in Windows 3.1, System 6, and System 7
    AdvanceWidthMax    : Word;     // Maximum advance width value in 'hmtx' table
    MinLeftSideBearing : SmallInt; // Minimum left sidebearing value in 'hmtx' table
    MinRightSideBearing: SmallInt; // Minimum right sidebearing value; calculated as Min(aw - lsb - (xMax - xMin))
    XMaxExtent         : SmallInt; // Max(lsb + (xMax - xMin))
    CaretSlopeRise     : SmallInt; // Used to calculate the slope of the cursor (rise/run); 1 for vertical
    CaretSlopeRun      : SmallInt; // 0 for vertical
    Reserved0          : SmallInt; // 0
    Reserved1          : SmallInt; // 0
    Reserved2          : SmallInt; // 0
    Reserved3          : SmallInt; // 0
    Reserved4          : SmallInt; // 0
    MetricDataFormat   : SmallInt; // 0
    NumberOfHMetrics   : Word;     // Number of hMetric entries in  'hmtx' table; may be smaller than the total number of glyphs in the font
  end;

  TTTFHorizontalMetrics= packed record
    AdvanceWidth   : Word;
    LeftSideBearing: SmallInt;
  end;

  TTTFKernFormat0= packed record
    NPairs       : Word; // This gives the number of kerning pairs in the table
    SearchRange  : Word; // The largest power of two less than or equal to the value of nPairs, multiplied by the size in bytes of an entry in the table
    EntrySelector: Word; // This is calculated as log2 of the largest power of two less than or equal to the value of nPairs. This value indicates how many iterations of the search loop will have to be made. (For example, in a list of eight items, there would have to be three iterations of the loop)
    RangeShift   : Word; // The value of nPairs minus the largest power of two less than or equal to nPairs, and then multiplied by the size in bytes of an entry in the table
  end;

  TTTFKernHeader= packed record
    Version: Word; // Table version number
    NTables: Word; // Number of subtables in the kerning table
  end;

  TTTFKernPair= packed record
    Left : Word;     // The glyph index for the left-hand glyph in the kerning pair.
    Right: Word;     // The glyph index for the right-hand glyph in the kerning pair.
    Value: SmallInt; // The kerning value for the above pair, in FUnits. If this value is greater than zero, the characters will be moved apart. If this value is less than zero, the character will be moved closer together.
  end;

  TTTFKernSubtableHeader= packed record
    Version : Word; // Kern subtable version number
    Len     : Word; // Length of the subtable, in bytes (including this header)
    Coverage: Word; // What type of information is contained in this table
  end;

  TTTFMaximumProfile= packed record
    Version              : Integer; // 0x00010000 for version 1.0.
    NumGlyphs            : Word;    // The number of glyphs in the font.
    MaxPoints            : Word;    // Maximum points in a non-composite glyph.
    MaxContours          : Word;    // Maximum contours in a non-composite glyph.
    MaxCompositePoints   : Word;    // Maximum points in a composite glyph.
    MaxCompositeContours : Word;    // Maximum contours in a composite glyph.
    MaxZones             : Word;    // 1 if instructions do not use the twilight zone (Z0), or 2 if instructions do use Z0; should be set to 2 in most cases.
    MaxTwilightPoints    : Word;    // Maximum points used in Z0.
    MaxStorage           : Word;    // Number of Storage Area locations.
    MaxFunctionDefs      : Word;    // Number of FDEFs.
    MaxInstructionDefs   : Word;    // Number of IDEFs.
    MaxStackElements     : Word;    // Maximum stack depth .
    MaxSizeOfInstructions: Word;    // Maximum byte count for glyph instructions.
    MaxComponentElements : Word;    // Maximum number of components referenced at "top level" for any composite glyph.
    MaxComponentDepth    : Word;    // Maximum levels of recursion; 1 for simple components.
  end;

  TTTFNameRecord= packed record
    PlatformID        : Word; // Platform identifier code
    PlatformSpecificID: Word; // Platform-specific encoding identifier
    LanguageID        : Word; // Language identifier
    NameID            : Word; // Name identifiers
    StringLength      : Word; // Name string length in bytes
    StringOffset      : Word; // Name string offset in bytes from StringOffset
  end;

  TTTFNameTableFormat= packed record
    Format      : Word; // 0
    Count       : Word; // Number of "NameRecords"
    StringOffset: Word; // Offset to start of string storage (from start of table)
  end;

  TTTFOffsetSubtable= packed record
    SFNTVersion  : Integer; // Fixed Version (00010000H)
    NumTables    : Word;    // Number of tables
    SearchRange  : Word;    // (Maximum power of 2 <= NumTables) x 16
    EntrySelector: Word;    // Log2 (maximum power of 2 <= NumTables)
    RangeShift   : Word;    // NumTables x 16-SearchRange
  end;

  TTTFAchVendID= array[0..3] of Char;
  TTTFPanose= array[0..9] of Byte;
  TTTFOS2Header= packed record
    Version            : Word;          // 0001H
    XAvgCharWidth      : SmallInt;
    USWeightClass      : Word;
    USWidthClass       : Word;
    FsType             : SmallInt;
    YSubscriptXSize    : SmallInt;
    YSubscriptYSize    : SmallInt;
    YSubscriptXOffset  : SmallInt;
    YSubscriptYOffset  : SmallInt;
    YSuperscriptXSize  : SmallInt;
    YSuperscriptYSize  : SmallInt;
    YSuperscriptXOffset: SmallInt;
    YSuperscriptYOffset: SmallInt;
    YStrikeoutSize     : SmallInt;
    YStrikeoutPosition : SmallInt;
    SFamilyClass       : SmallInt;
    Panose             : TTTFPanose;
    ULUnicodeRange1    : ULong;         // Bits 0-31
    ULUnicodeRange2    : ULong;         // Bits 32-63
    ULUnicodeRange3    : ULong;         // Bits 64-95
    ULUnicodeRange4    : ULong;         // Bits 96-127
    AchVendID          : TTTFAchVendID;
    FsSelection        : Word;
    USFirstCharIndex   : Word;
    USLastCharIndex    : Word;
    STypoAscender      : Word;
    STypoDescender     : Word;
    STypoLineGap       : Word;
    USWinAscent        : Word;
    USWinDescent       : Word;
    ULCodePageRange1   : ULong;         // Bits 0-31
    ULCodePageRange2   : ULong;         // Bits 32-63
  end;

  TTTFPCLTHeader= packed record
    Version            : Integer;
    FontNumber         : ULong;
    Pitch              : Word;
    XHeight            : Word;
    Style              : Word;
    TypeFamily         : Word;
    CapHeight          : Word;
    SymbolSet          : Word;
    Typeface           : array[0..15] of Char;
    CharacterComplement: Double;                
    FileName           : array[0..05] of Char;
    StrokeWeight       : ShortInt;
    WidthType          : ShortInt;
    SerifStyle         : Byte;
    Reserved           : Byte;
  end;

  TTTFPostScript= packed record
    FormatType        : Integer;  // 0x00010000 for format 1.0, 0x00020000 for format 2.0, and so on...
    ItalicAngle       : Integer;  // Italic angle in counter-clockwise degrees from the vertical. Zero for upright text, negative for text that leans to the right (forward)
    UnderlinePosition : SmallInt; // Suggested values for the underline position (negative values indicate below baseline)
    UnderlineThickness: SmallInt; // Suggested values for the underline thickness
    IsFixedPitch      : ULong;    // Set to 0 if the font is proportionally spaced, non-zero if the font is not proportionally spaced (i.e. monospaced)
    MinMemType42      : ULong;    // Minimum memory usage when a TrueType font is downloaded
    MaxMemType42      : ULong;    // Maximum memory usage when a TrueType font is downloaded
    MinMemType1       : ULong;    // Minimum memory usage when a TrueType font is downloaded as a Type 1 font
    MaxMemType1       : ULong;    // Maximum memory usage when a TrueType font is downloaded as a Type 1 font
  end;

  TTTFReadError= class (Exception);

  TTTFTableDirectory= packed record
    Tag     : Integer; // 4-byte identifier
    CheckSum: Integer; // CheckSum for this table
    Offset  : Integer; // Offset from beginning of TrueType font file
    Len     : Integer; // Length of this table
  end;

  TTTFVDMXGroupHeader= packed record
    Recs   : Word; // Number of height records in this group
    StartsZ: Byte; // Starting yPelHeight
    EndsZ  : Byte; // Ending yPelHeight
  end;

  TTTFVDMXGroupTable= packed record
    YPelHeight: Word;     // YPelHeight to which values apply
    YMax      : SmallInt; // YMax (in pels) for this YPelHeight
    YMin      : SmallInt; // YMin (in pels) for this YPelHeight
  end;

  TTTFVDMXHeader= packed record
    Version  : Word;   // Version number (starts at 0).
    NumRecs  : Word;   // Number of VDMX groups present
    NumRatios: Word;   // Number of aspect ratio groupings
  end;

  TTTFVDMXRatio= packed record
    BCharSet   : Byte; // Character set
    XRatio     : Byte; // Value to use for x-Ratio 
    YStartRatio: Byte; // Starting y-Ratio value
    YEndRatio  : Byte; // Ending y-ratio value
  end;

  TTTFVerticalHeader= packed record
    Version             : Integer;  // Version number of the vertical header table (0x00010000 for the initial version).
    Ascent              : SmallInt; // Distance in FUnits from the centerline to the previous line's descent.
    Descent             : SmallInt; // Distance in FUnits from the centerline to the next line's ascent.
    LineGap             : SmallInt; // Reserved; set to 0
    AdvanceHeightMax    : SmallInt; // The maximum advance height measurement in FUnits found in the font. This value must be consistent with the entries in the vertical metrics table.
    MinTopSideBearing   : SmallInt; // The minimum top sidebearing measurement found in the font, in FUnits. This value must be consistent with the entries in the vertical metrics table.
    MinBottomSideBearing: SmallInt; // The minimum bottom sidebearing measurement found in the font, in FUnits. This value must be consistent with the entries in the vertical metrics table.
    YMaxExtent          : SmallInt; // Defined as yMaxExtent=minTopSideBearing+(yMax-yMin)
    CaretSlopeRise      : SmallInt; // The value of the caretSlopeRise field divided by the value of the caretSlopeRun Field determines the slope of the caret. A value of 0 for the rise and a value of 1 for the run specifies a horizontal caret. A value of 1 for the rise and a value of 0 for the run specifies a vertical caret. Intermediate values are desirable for fonts whose glyphs are oblique or italic. For a vertical font, a horizontal caret is best.
    CaretSlopeRun       : SmallInt; // See the caretSlopeRise field. Value=1 for nonslanted vertical fonts.
    CaretOffset         : SmallInt; // The amount by which the highlight on a slanted glyph needs to be shifted away from the glyph in order to produce the best appearance. Set value equal to 0 for nonslanted fonts.
    Reserved0           : SmallInt; // Set to 0.
    Reserved1           : SmallInt; // Set to 0.
    Reserved2           : SmallInt; // Set to 0.
    Reserved3           : SmallInt; // Set to 0.
    MetricDataFormat    : SmallInt; // Set to 0.
    NumOfLongVerMetrics : Word;     // Number of advance heights in the vertical metrics table.
  end;

  TTTFVerticalMetrics= packed record
    AdvanceHeight : Word;     // The advance height of the glyph
    TopSideBearing: SmallInt; // The top sidebearing of the glyph
  end;

  TTTF= class
    protected
      Stream: TStream;

      procedure Read (var Buffer; Count: Integer); virtual;
    public
      constructor Create (AStream: TStream); virtual;  
  end;

procedure MacSecondsToDateTime (Seconds: Comp; var Year, Month, Day, Hour, Min, Sec: Word);  

implementation





procedure MacSecondsToDateTime (Seconds: Comp; var Year, Month, Day, Hour, Min, Sec: Word);
var
  SegundosDoDia: Integer;

begin
  try
    SegundosDoDia:= Trunc (Frac (Seconds/SecsPerDay)*SecsPerDay);
    Hour         := SegundosDoDia div 3600;
    Min          := (SegundosDoDia div 60) mod 60;
    Sec          := SegundosDoDia mod 60;

    { O "TDateTime" armazena a quantidade de dias a partir de 30/12/1899 (esta data é representada
      por 0). Já o Macintosh inicia-se em 01/01/1904.
      De 30/12/1899 até 01/01/1904 tem 1462 dias.
      DecodeDate (EncodeDate (1904, 1, 1) + (Seconds/SecsPerDay), Year, Month, Day); }
    DecodeDate (1462 + (Seconds/SecsPerDay), Year, Month, Day);
  except
  end;  
end;





constructor TTTF.Create (AStream: TStream);

begin
  inherited Create;

  Stream:= AStream;
end;





procedure TTTF.Read (var Buffer; Count: Integer);
var
  Lidos: Integer;

begin
  Lidos:= Stream.Read (Buffer, Count);
  if Lidos <> Count then
    raise TTTFReadError.Create (Format ('TTF read error at %.8xH (%d byte(s) expected, but %d read)', [Stream.Position-Lidos, Count, Lidos]));
end;

end.
