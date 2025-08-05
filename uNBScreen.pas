{
  Grundy NewBrain Emulator Pro Made by Despsoft
  Copyright (c) 2004-Today , Despoinidis Chris

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <https://www.gnu.org/licenses/>.

}
unit uNBScreen;

interface

Uses uNBTypes, DXDraws, uNBStream, graphics, classes, DIB;

Const
  ScreenYOffset = 2;
  ScreenXOffset = 2;

Type

  TNBScreen = Class

  private
    Char8: Boolean;
    FPSTick: Cardinal;
    GraphExists: Boolean;
    Grst: TNbStream;
    lengx, lengy: integer;
    ParamPg: integer;
    ParamOffset: Word;
    ParamGrPage: Byte;
    ParamGrOffset: Word;
    ISCpmV: Boolean;
    Startofgraph: integer;
    GrPage: Byte;
    EndOfText: integer;
    HasText: Boolean;
    Printedlines: integer;
    VirtImgC: TDxdib;
    VirtImg: TDIB;
    ScaledImg: TDIB;
    function GetNextByte(var p, Offset: integer): Byte;
    function GetDEP: Byte;
    function GetEL: Byte;
    function GetExcess: Byte;
    function GetEXFlags: Byte;
    function GetFlags: Byte;
    function GetFRM: Byte;
    function GetinpB: Byte;
    function GetinpC: Byte;
    function GetLL: Byte;
    function GetLN: Byte;
    function GetPLLEN: Byte;
    function GetPZLEN: Byte;
    function GetTvMode: Byte;
    function GetTVOverHead: integer;
    function GetVideoAddr: TPair;
    function GetVideoMem: TPair;
    function GraphWidth: Word;
    function lastGraph: TPair;
    function startgraph: TPair;
    function GetAVideoTop: TPair;
    function GetTV4: Byte;
    function GetVideoBase: TPair;
    function GetVIDEOTOP: TPair;
    function IsPaged: Boolean;
    function GetTV0: Byte;
    function GetSlotn(w: Word): integer;
    procedure dopaint(Sender: TObject);
    function getskipframe: integer;
    procedure SetVirtualImage;
    function GetMenuHeight: integer;
  public
    horzmult: integer;
    vertmult: integer;
    EMUScrheight: integer; // variable
    EMUScrWidth: integer;
    FPS: integer;
    Lastfps: integer;
    nbs: TNBStreamManipulation;
    pgnbs: TNBPGStreamManipulation;
    Newscr: TDXDraw;
    ShowFps: Boolean;
    LedText: string;
    VideoAddrReg: Word;
    TVModeReg: Byte;
    VIdeoPage: Byte;
    WhiteColor: TColor;
    BlackColor: TColor;
    Reverse: Boolean;
    Dev33Page: integer;
    VIDEOMSB: integer;
    CpTm: Cardinal;
    CkTm: Cardinal;
    Constructor Create;
    function GetGraphStrm: TNbStream;
    function Graphlines: Word;
    procedure Clearscr;
    procedure paintGraph(ISDev33: Boolean = false);
    function PaintVideo: Boolean;
    procedure PaintLetter(Const cx, cy: integer; Ch: Byte;
      const dopaint: Boolean = false);
    procedure PaintLeds(txt: String);
    procedure PaintDebug;
    function GetParamed(Offs: Word): Byte;
    function ValidGraph: Boolean;
    procedure CaptureToDisk;
    procedure TakeScreenShot;
    property DEP: Byte read GetDEP;
    property EL: Byte read GetEL;
    property Excess: Byte read GetExcess;
    property EXFlags: Byte read GetEXFlags;
    property Flags: Byte read GetFlags;
    property FRM: Byte read GetFRM;
    property inpB: Byte read GetinpB;
    property inpC: Byte read GetinpC;
    property LL: Byte read GetLL;
    property LN: Byte read GetLN;
    property PLLEN: Byte read GetPLLEN;
    property PZLEN: Byte read GetPZLEN;
    property TVMode: Byte read GetTvMode;
    property VideoAddr: TPair read GetVideoAddr;
    property VideoMem: TPair read GetVideoMem;
    property AVideoTop: TPair read GetAVideoTop;
    property TV4: Byte read GetTV4;
    property VideoBase: TPair read GetVideoBase;
    property VIDEOTOP: TPair read GetVIDEOTOP;
    property TV0: Byte read GetTV0;
  End;

procedure LoadCharSet(fname: string);

Var
  NBScreen: TNBScreen;
  CharArr: Array [0 .. 2560] of Byte; // charset array

implementation

Uses z80baseclass, Sysutils, forms, uNBMemory, frmNewdebug, new,
  jcllogic, windows, uNBCop, uNBIO, controls;

// loads the charset from the disk
procedure LoadCharSet(fname: string);
Var
  f: File Of Byte;
  i: integer;
  pth: String;
begin
  pth := Extractfilepath(application.exename);
  if FileExists(pth + fname) then
  Begin
    system.Assign(f, pth + fname);
    reset(f);
    For i := 0 to 2560 do
    BEgin
      read(f, CharArr[i]);
    End;
    system.Close(f);
  End;
end;

constructor TNBScreen.Create;
begin
  // Frame:=nil;
  WhiteColor := clWhite;
  BlackColor := clBlack;
  nbs := TNBStreamManipulation.Create;
  pgnbs := TNBPGStreamManipulation.Create;
  horzmult := 2;
  vertmult := 2;
  EMUScrheight := 250; // variable
  EMUScrWidth := 640;
  // VirtImgC:=TDxdib.create(fNewbrain);
  VirtImg := TDIB.Create;
  // Create the scaled destination image (640x500)
  ScaledImg := TDIB.Create;
  ScaledImg.Width := 640;
  ScaledImg.Height := 500;
  ScaledImg.BitCount := 24;
end;

Procedure TNBScreen.SetVirtualImage;
Begin
  if EL = 128 then
    VirtImg.Width := 640
  else
    VirtImg.Width := 320;
  VirtImg.Height := 250;
  VirtImg.BitCount := 24;
End;

procedure TNBScreen.Clearscr;
var
  i: integer;
Begin
  for i := VideoMem.w to VideoMem.w + EL * DEP do
    nbmem.rom[i] := 32;
End;

function TNBScreen.GetDEP: Byte;
begin
  // tvmode reg is set by out at port 12
  // Bit 0 is Reverse video
  // Bit 1 is full character Set
  // Bit 2 is narrow screen
  // Bit 3 is 30 lines display
  // Bit 6 is 40 lines width if 0 , 80 lines if 1
  If testbit(TVModeReg, 3) then
    result := 30
  else
    result := 26;
end;

function TNBScreen.GetEL: Byte;
begin
  If testbit(TVModeReg, 6) then
    result := 128
  else
    result := 64;
end;

function TNBScreen.GetExcess: Byte;
begin
  result := 24; // fixed for model AD
  exit;
  if not IsPaged then
    result := nbmem.rom[$0C]
  else
    result := 24;
end;

function TNBScreen.GetEXFlags: Byte;
begin
  if not IsPaged then
    result := nbmem.rom[VideoAddr.w + 8]
  Else
    result := GetParamed(8);
end;

function TNBScreen.GetFlags: Byte;
begin
  if not IsPaged then
    result := nbmem.rom[VideoAddr.w + 7]
  else
    result := GetParamed(7);
end;

function TNBScreen.GetFRM: Byte; // Not Used
begin
  result := 0;
  exit;

  if ISCpmV then
    result := 0
  Else if not IsPaged then
    result := nbmem.rom[VideoAddr.w + 10]
  Else
  Begin
    result := GetParamed(10);
    result := 0;
    // it is valid but we have the right
    // start address anyway so we dont need frm
  End;
end;

// Get the stream for device 11=Graphics
function TNBScreen.GetGraphStrm: TNbStream;
begin
  result := nbs.FindStrmByMem(VideoAddr);
  if nbs.found then
  Begin
    nbs.found := false;
    result := nbs.FindStrmForGraph(11, result.PortNo);
  End;
end;

function TNBScreen.GetinpB: Byte;
begin
  if not IsPaged then
    result := nbmem.rom[VideoAddr.w + 12]
  else
    result := GetParamed(12);
end;

function TNBScreen.GetinpC: Byte;
begin
  if not IsPaged then
    result := nbmem.rom[VideoAddr.w + 13]
  Else
    result := GetParamed(13);
end;

function TNBScreen.GetLL: Byte;
begin
  If testbit(TVModeReg, 6) then
    result := 80
  else
    result := 40;

  exit;
  if ISCpmV then
    result := 80
  Else if not IsPaged then
    result := nbmem.rom[VideoAddr.w + 5]
  else
    result := GetParamed(5);
end;

function TNBScreen.GetLN: Byte;
begin
  If testbit(TVModeReg, 6) then
    result := 80
  else
    result := 40;

  exit;

  if ISCpmV then
    result := 80
  else if not IsPaged then
    result := nbmem.rom[VideoAddr.w + 9]
  Else
    result := GetParamed(9);
end;

function TNBScreen.GetPLLEN: Byte;
begin
  // Chars per line 40 or 80
  result := nbmem.rom[$1B];
end;

function TNBScreen.GetPZLEN: Byte;
begin
  result := nbmem.rom[$1D]; // 10 for 40 chars
end; // 17 for 80 chars

function TNBScreen.GetTvMode: Byte;
begin
  if ISCpmV then
    result := 1
  Else if not IsPaged then
    result := nbmem.rom[VideoAddr.w + 1] and $F
  Else
    result := GetParamed(1) and $F;
end;

function TNBScreen.GetTVOverHead: integer; // Not Used
Begin
  if ISCpmV then
    result := 0
  else if Not IsPaged then
    result := nbmem.rom[VideoAddr.w] + 5
  Else
    result := 1;
End;

function TNBScreen.GetVideoAddr: TPair;
begin
  if not ISCpmV then
  Begin
    result.h := nbmem.rom[$5D];
    result.l := nbmem.rom[$5C];
  End
  Else
    result.w := 0;
end;

function TNBScreen.GetVideoMem: TPair;
begin
  // Result.w:=videoAddr.w+GetTVOverHead //actual address
  If testbit(TVModeReg, 6) then
    result.w := VideoAddrReg + 4 // actual address
  Else
    result.w := VideoAddrReg + 2; // actual address
end;

function TNBScreen.Graphlines: Word;
begin
  result := 0;
  If not IsPaged then
    result := nbmem.rom[Grst.Memory.w + 28]
  Else if nbmem.chipexists(ParamGrPage) then
    result := nbmem.nbPages[ParamGrPage]^.Memory[ParamGrOffset + 34]; // 28
end;

function TNBScreen.GraphWidth: Word;
begin
  result := 0;
  If Not IsPaged then
    result := nbmem.rom[Grst.Memory.w + 25]
  Else if nbmem.chipexists(ParamGrPage) then
    result := nbmem.nbPages[ParamGrPage]^.Memory[ParamGrOffset + 31]; // 25
end;

function TNBScreen.lastGraph: TPair; // Not Used
begin
  result.l := nbmem.rom[Grst.Memory.w + 44];
  result.h := nbmem.rom[Grst.Memory.w + 45];
  result.w := result.w - 1;
end;

// Paint the debug information on Newdebug form
procedure TNBScreen.PaintDebug;
Var
  h, i: integer;
  s: String;
  Col1, Col2, Col3, col4: integer;

  Procedure PaintFlags;
  Var
    af: TPair;
    f: Byte;
    s: String;
    i: integer;

  Begin
    af.w := z80_get_reg(Z80_REG_AF);
    f := af.l;
    s := 'szxnxpnc';
    for i := 0 to 7 do
      if testbit(f, Byte(i)) then
        s[8 - i] := Uppercase(s[8 - i])[1]
      else
        s[8 - i] := Lowercase(s[8 - i])[1];
    NewDebug.debugscr.Surface.Canvas.TextOut(Col3, 1 * h, 'FL : ' + s);
  End;

  Procedure PAintSP;
  var
    sp: TPair;
    i: integer;
  Begin
    sp.w := z80_get_reg(Z80_REG_SP);
    i := 2;
    with NewDebug.debugscr.Surface.Canvas do
    begin
      repeat
        s := Format('%s : %s', [inttohex(sp.w, 4),
          inttohex(nbmem.rom[sp.w], 4)]);
        sp.w := sp.w - 2;
        inc(i);
        TextOut(col4, i * h, s);
        if i > 15 then
          break;
      until false;
    End;
  End;

Begin
  Col1 := 10;
  Col2 := 140;
  Col3 := 320;
  col4 := 450;

  if not NewDebug.debugscr.CanDraw then
    exit;

  NewDebug.debugscr.Surface.Fill(5);
  NewDebug.debugscr.Surface.Lock();

  with NewDebug.debugscr.Surface.Canvas do
  begin
    Brush.Style := bsClear;
    Font.Name := 'Courier New';
    Font.Color := clWhite;
    Font.Size := 8;
    h := 10;
    if fNewBrain.Suspended then
      s := 'Suspended'
    else
      s := 'Running';
    TextOut(Col1, 0, DateTimeToStr(Now) + ' Engine is ' + s);
    TextOut(Col1, 1 * h, 'PC    : ' + inttohex(z80_get_reg(Z80_REG_PC), 4));
    TextOut(Col1, 2 * h, 'AF    : ' + inttohex(z80_get_reg(Z80_REG_AF), 4));
    TextOut(Col1, 3 * h, 'HL    : ' + inttohex(z80_get_reg(Z80_REG_HL), 4) + '('
      + Inttostr(nbmem.rom[z80_get_reg(Z80_REG_HL)]) + ')');
    TextOut(Col1, 4 * h, 'DE    : ' + inttohex(z80_get_reg(Z80_REG_DE), 4));
    TextOut(Col1, 5 * h, 'BC    : ' + inttohex(z80_get_reg(Z80_REG_BC), 4));
    TextOut(Col1, 6 * h, 'IX    : ' + inttohex(z80_get_reg(Z80_REG_IX), 4));
    TextOut(Col1, 7 * h, 'IY    : ' + inttohex(z80_get_reg(Z80_REG_IY), 4));
    TextOut(Col1, 8 * h, 'IM    : ' + inttohex(z80_get_reg(Z80_REG_IM), 4));
    TextOut(Col1, 9 * h, 'IR    : ' + inttohex(z80_get_reg(Z80_REG_IR), 4));
    TextOut(Col1, 10 * h, 'IF1   : ' + inttohex(z80_get_reg(Z80_REG_IFF1), 4));
    TextOut(Col1, 11 * h, 'IF2   : ' + inttohex(z80_get_reg(Z80_REG_IFF2), 4));
    TextOut(Col1, 12 * h, 'SP    : ' + inttohex(z80_get_reg(Z80_REG_SP), 4));
    TextOut(Col1, 13 * h, 'IRQV  : ' +
      inttohex(z80_get_reg(Z80_REG_IRQVector), 4));
    TextOut(Col1, 14 * h, 'IRQL  : ' +
      inttohex(z80_get_reg(Z80_REG_IRQLine), 4));
    TextOut(Col1, 15 * h, 'Halt  : ' +
      inttohex(z80_get_reg(Z80_REG_Halted), 4));

    PaintFlags;

    TextOut(Col1, 18 * h, 'COPCTL: ' + getbinaryfrombyte(nbmem.rom[$3B]));
    TextOut(Col1, 19 * h, 'COPST : ' + getbinaryfrombyte(nbmem.rom[$3C]));
    TextOut(Col1, 20 * h, 'ENREG1: ' + getbinaryfrombyte(nbmem.rom[$24]));
    TextOut(Col1, 21 * h, 'IOPUC : ' + inttohex(nbmem.rom[$25], 2));
    s := inttohex(nbmem.rom[$1F], 2) + inttohex(nbmem.rom[$1E], 2);
    TextOut(Col1, 22 * h, 'SAVE1 : ' + s);
    TextOut(Col1, 23 * h, 'EL    : ' + inttohex(EL, 4));
    TextOut(Col1, 24 * h, 'LL    : ' + inttohex(LL, 4));
    TextOut(Col1, 25 * h, 'LN    : ' + inttohex(LN, 4));
    TextOut(Col1, 26 * h, 'DEP   : ' + inttohex(DEP, 4));
    TextOut(Col1, 27 * h, 'FRM   : ' + inttohex(FRM, 4));
    TextOut(Col1, 28 * h, 'FLAGS : ' + getbinaryfrombyte(Flags));
    TextOut(Col1, 29 * h, 'EXFLAG: ' + getbinaryfrombyte(EXFlags));
    TextOut(Col1, 30 * h, 'INPB  : ' + inttohex(inpB, 4));
    TextOut(Col1, 31 * h, 'INPC  : ' + inttohex(inpC, 4));
    s := inttohex(nbmem.rom[$5B], 2) + inttohex(nbmem.rom[$5A], 2);
    TextOut(Col1, 32 * h, 'TVCUR : ' + s);
    s := inttohex(nbmem.rom[$5D], 2) + inttohex(nbmem.rom[$5C], 2);
    TextOut(Col1, 33 * h, 'TVRAM : ' + s);
    s := inttohex(nbmem.rom[$05], 2) + inttohex(nbmem.rom[$04], 2);
    TextOut(Col1, 34 * h, 'B3PRM : ' + s);
    s := inttohex(nbmem.rom[$38], 2) + inttohex(nbmem.rom[$3A], 2) +
      inttohex(nbmem.rom[$39], 2);
    TextOut(Col1, 35 * h, 'RST56 : ' + s);
    s := inttohex(nbmem.rom[$2D], 2) + inttohex(nbmem.rom[$2C], 2);
    TextOut(Col1, 36 * h, 'GSPR  : ' + s);
    s := inttohex(nbmem.rom[$07], 2) + inttohex(nbmem.rom[$06], 2);
    TextOut(Col1, 37 * h, 'B4    : ' + s);
    s := inttohex(nbmem.rom[$57], 2) + inttohex(nbmem.rom[$56], 2);
    TextOut(Col1, 38 * h, 'STRTAB: ' + s);
    s := inttohex(nbmem.rom[$65], 2) + inttohex(nbmem.rom[$64], 2);
    TextOut(Col1, 39 * h, 'STRTOP: ' + s);
    TextOut(Col1, 40 * h, 'ENREG2: ' + getbinaryfrombyte(nbmem.rom[$B6]));

    if Breaked or stopped then
      TextOut(Col1, 41 * h, 'Breakpoint reached');

    TextOut(Col2, 30 * h, 'TVMode: ' + Inttostr(TVMode));

    s := inttohex(nbmem.rom[120], 2) + inttohex(nbmem.rom[119], 2);
    TextOut(Col2, 31 * h, 'CHRROM: ' + s);

    s := inttohex(nbmem.rom[85], 2) + inttohex(nbmem.rom[84], 2) +
      inttohex(nbmem.rom[83], 2) + inttohex(nbmem.rom[82], 2);
    TextOut(Col2, 1 * h, 'CL/CK : ' + s);
    s := inttohex(nbmem.rom[107], 2) + inttohex(nbmem.rom[106], 2) +
      inttohex(nbmem.rom[105], 2);
    TextOut(Col2, 2 * h, 'FICLK : ' + s);
    s := inttohex(nbmem.rom[21], 2) + inttohex(nbmem.rom[20], 2);
    TextOut(Col2, 3 * h, 'SAVE2 : ' + s);
    s := inttohex(nbmem.rom[23], 2) + inttohex(nbmem.rom[22], 2);
    TextOut(Col2, 4 * h, 'SAVE3 : ' + s);
    s := inttohex(nbmem.rom[$3D], 2);
    TextOut(Col2, 6 * h, 'COPBF : ' + s);
    s := inttohex(nbmem.rom[$51], 2) + inttohex(nbmem.rom[$50], 2);
    TextOut(Col2, 7 * h, 'CHSUM : ' + s);

    TextOut(Col2, 37 * h, 'TV0   : ' + Inttostr(nbmem.rom[13]));
    TextOut(Col2, 38 * h, 'TV2   : ' + getbinaryfrombyte(nbmem.rom[14]));
    TextOut(Col2, 39 * h, 'TV1   : ' + Inttostr(nbmem.rom[15]));
    TextOut(Col3, 39 * h, 'TV4   : ' + Inttostr(TV4));

    For i := 0 to 7 do
      if nbmem.mainslots[i] <> nil then
        TextOut(Col2, (10 + i) * h, 'M/S ' + Inttostr(i) + ' : ' +
          Inttostr(nbmem.mainslots[i].Page) + '.' + nbmem.mainslots[i].Name)
      Else
        TextOut(Col2, (10 + i) * h, 'M/S ' + Inttostr(i) + ' : 000.N/A');

    If nbmem.AltSet then
      TextOut(Col2, 19 * h, 'ALTN Set ')
    Else
      TextOut(Col2, 19 * h, 'MAIN Set ');

    For i := 0 to 7 do
      if nbmem.Altslots[i] <> nil then
        TextOut(Col2, (21 + i) * h, 'A/S ' + Inttostr(i) + ' : ' +
          Inttostr(nbmem.Altslots[i].Page) + '.' + nbmem.Altslots[i].Name)
      Else
        TextOut(Col2, (21 + i) * h, 'A/S ' + Inttostr(i) + ' : 0.N/A');

    TextOut(Col3, 4 * h, 'VTop  : ' + Inttostr(VIDEOTOP.w));
    TextOut(Col3, 5 * h, 'VBase : ' + Inttostr(VideoBase.w));
    TextOut(Col3, 6 * h, 'AVtop : ' + Inttostr(AVideoTop.w));

    TextOut(Col3, 7 * h, 'DiscB : ' + Inttostr(nbmem.rom[$7A] * 256 +
      nbmem.rom[$79]));
    TextOut(Col3, 8 * h, 'STR11 : ' + Inttostr(nbmem.rom[$76]));

    TextOut(Col3, 10 * h, 'S0    : ' + Inttostr(GetSlotn(nbmem.rom[$8C] * 256 +
      nbmem.rom[$8B])));
    TextOut(Col3, 11 * h, 'S1    : ' + Inttostr(GetSlotn(nbmem.rom[$8E] * 256 +
      nbmem.rom[$8D])));
    TextOut(Col3, 12 * h, 'S2    : ' + Inttostr(GetSlotn(nbmem.rom[$90] * 256 +
      nbmem.rom[$8F])));
    TextOut(Col3, 13 * h, 'S3    : ' + Inttostr(GetSlotn(nbmem.rom[$92] * 256 +
      nbmem.rom[$91])));
    TextOut(Col3, 14 * h, 'S4    : ' + Inttostr(GetSlotn(nbmem.rom[$94] * 256 +
      nbmem.rom[$93])));
    TextOut(Col3, 15 * h, 'S5    : ' + Inttostr(GetSlotn(nbmem.rom[$96] * 256 +
      nbmem.rom[$95])));
    TextOut(Col3, 16 * h, 'S6    : ' + Inttostr(GetSlotn(nbmem.rom[$98] * 256 +
      nbmem.rom[$97])));
    TextOut(Col3, 17 * h, 'S7    : ' + Inttostr(GetSlotn(nbmem.rom[$9A] * 256 +
      nbmem.rom[$99])));
    if pclist <> nil then
    Begin
      For i := pclist.count - 1 downto 0 do
      Begin
        TextOut(Col3, (19 + (pclist.count - i)) * h, 'PC-' + Inttostr(i) + ' : '
          + inttohex(integer(pclist[i]), 4));
        if pclist.count - i > 10 then
          break;
      End;

      For i := splist.count - 1 downto 0 do
      Begin
        TextOut(col4, (19 + (splist.count - i)) * h, 'sp-' + Inttostr(i) + ' : '
          + inttohex(integer(splist[i]), 4));
        if splist.count - i > 10 then
          break;
      End;

      PAintSP;
    End;

    try
      NewDebug.PaintListing;
    Except
    End;
    Release; { Indispensability }
  end;

  NewDebug.debugscr.Surface.unLock;
  NewDebug.debugscr.Flip;

End;

// returns the bank slot  that this address is
Function TNBScreen.GetSlotn(w: Word): integer;
Var { sl, }
  pg: Word;
  // t:Tpair;
Begin
  // sl:=w and $E000;
  pg := w And $FF;
  // t.w:=pg;
  result := pg;
End;

// Paint the graphics screen if there is one
procedure TNBScreen.paintGraph(ISDev33: Boolean = false);
Var
  i, j: integer;
  x, y: integer;
  lengx, lengy: integer;
  addr: integer;
  nocx: integer;
  nocy: integer;
  Ch: Byte;

  Procedure DrawPixel(const x1, y1: integer; DoSet: Boolean);
  var
    clr: TColor;
    nx, ny: integer;
    i, j: integer;
  Begin
    if Reverse then
      DoSet := not DoSet;
    if DoSet then
      clr := WhiteColor
    else
      clr := BlackColor;
    VirtImg.Pixels[x1, Startofgraph + y1] := clr;
    exit;
    nx := ScreenXOffset + x1 * horzmult;
    ny := ScreenYOffset + (Startofgraph + y1) * vertmult;
    for i := 0 to horzmult - 1 do
      for j := 0 to vertmult - 1 do
        Newscr.Surface.Pixel[nx + i, (ny + j)] := clr;
    // frame.plot(nx+i,EMUSCRHeight-(ny+j),clr);
  End;

var
  grp: integer;

  narrow: Boolean;
  ident: integer;
begin

  GraphExists := false;
  If not ValidGraph then
    exit;
  GraphExists := true;
  If Printedlines >= 250 then
    exit; // max lines

  lengx := 8; // 8 bit
  lengy := 1; // 1 byte

  // if not HasText then
  // addr:=startGraph.w;

  nocx := GraphWidth; // 280 bytes
  nocy := Graphlines;
  if nocx = 0 then
  Begin
    GraphExists := false;
    exit;
  End;

  addr := EndOfText;
  GrPage := Dev33Page; // nbmem.lastpage;
  nocy := nocy + 10 - (nocy mod 10); // multiple of 10 lines always
  if nocy > 249 then
    nocy := 249;
  // ODS(Format('Start Graph Video=%4x , Page=%d',[addr,grpage]));

  Reverse := testbit(TVModeReg, 0);

  grp := GrPage;
  narrow := (nocx = 32) or (nocx = 64);
  if narrow then
  Begin
    ident := nocx div 8;
    addr := addr + ident;
    nocx := nocx + ident;
  End
  else
    ident := 0;

  // addr:=addr+1;
  if addr >= $FFFF then
    exit;
  { if IsPaged and (addr>=$2000) then
    Begin
    //todo:Find this somehow
    addr:=addr-$2000;
    grp:=grp-1;
    if grp<0 then exit;
    End; }

  for i := 0 to nocy - 1 do // count lines
  Begin
    for j := 0 to nocx - 1 do // count column bytes
    Begin
      If narrow and (j < ident) then
        continue;
      for y := 0 to lengy - 1 do // enlarge pixel  y
      Begin
        if IsPaged then
          Ch := GetNextByte(grp, addr)
        Else
        Begin
          Ch := nbmem.rom[addr];
          inc(addr);
        end;
        for x := lengx - 1 downto 0 do // enlarge pixel   x
          DrawPixel(j * 8 + x, (i * 1) + y, testbit(Ch, Byte(x)));
      End; // for y bit count
    End; // for j

    Printedlines := Printedlines + 1;
    If Printedlines >= 250 then
      break; // max lines
  End; // for i

  // ODS(Format('End  Video=%4x , Page=%d',[addr,grp]));
end;

// paint the 16 char vfd
procedure TNBScreen.PaintLeds(txt: String);
begin
  LedText := copy(txt, 1, 16);
  fNewBrain.SetLed(nil);
end;

// Paint a letter(ch) on screen at position cx,cy
procedure TNBScreen.PaintLetter(Const cx, cy: integer; Ch: Byte;
  const dopaint: Boolean = false);
Var
  x, y: integer;
  addr: integer;
  charb: array [0 .. 9] of Byte;

  Procedure getchar;
  var
    i: integer;
  Begin
    for i := 0 to 7 do
      charb[i] := ReverseBits(CharArr[addr + i * 256]);

    charb[8] := 0;
    charb[9] := 0;

    // two bottom lines
    if ((Ch > 31) and (Ch < 128)) or (Ch > 159) then
    Begin
      if charb[0] and 128 = 128 then
      Begin
        charb[0] := charb[0] and $7F; // clear bit 8
        charb[8] := charb[0];
        charb[0] := 0;
      End;
      if charb[1] and 128 = 128 then
      Begin
        charb[1] := charb[1] and $7F; // clear bit 8
        charb[9] := charb[1];
        charb[1] := 0;
      End;
    End
    else
      charb[8] := charb[7];

    if Reverse then
    Begin
      for i := 0 to 9 do
        charb[i] := charb[i] xor $FF;
    End;
  End;

  Procedure getchar8;
  var
    i: integer;
  Begin
    for i := 0 to lengy - 1 do
      charb[i] := ReverseBits(CharArr[addr + i * 256]);
    if Reverse then
    Begin
      for i := 0 to lengy - 1 do
        charb[i] := charb[i] xor $FF;
    End;

  End;

  Function GetRomForChar(Ch: Byte): integer;
  Begin
    result := -1;
    Reverse := false;

    Case TVMode of
      0, 4:
        Begin // ctrl W-D  set1
          if Ch > 127 then
            Ch := Ch - 128
          else
            Reverse := true;
          result := Ch;
        End;
      1, 5:
        Begin // ctrl W-A  set1 reversed
          if Ch > 127 then
          Begin
            Ch := Ch - 128;
            Reverse := true;
          End;
          result := Ch;
        End;
      2, 6:
        result := Ch; // Ctrl W-B set2
      3, 7:
        Begin // Ctrl W-C   set2 reversed
          result := Ch;
          Reverse := true;
        End;
      8, 12:
        Begin
          if Ch > 127 then
          BEgin
            Ch := Ch - 128;
            Reverse := true;
          End;
          result := Ch; // Ctrl W-H Set 3
        End;
      9, 13:
        Begin
          if Ch > 127 then
          BEgin
            Ch := Ch - 128;
          End
          else
            Reverse := true;
          result := Ch; // Ctrl W-I Set 3 reversed
        End;
      10, 14:
        Begin
          result := Ch; // Ctrl W-J Set 4
        End;
      11, 15:
        Begin
          result := Ch; // Ctrl W-k Set 4 reversed
          Reverse := true;
        End;
    end;
  End;

  Procedure DrawPixel(const x, y: integer; const DoSet: Boolean);
  var
    clr: TColor;
    nx, ny: integer;
    i, j: integer;
  Begin
    if DoSet then
      clr := WhiteColor
    else
      clr := BlackColor;
    VirtImg.Pixels[x, y] := clr;
    exit;
    nx := ScreenXOffset + x * horzmult;
    ny := ScreenYOffset + y * vertmult;
    for i := 0 to horzmult - 1 do
      for j := 0 to vertmult - 1 do
        Newscr.Surface.Pixel[nx + i, ny + j] := clr;
    // frame.plot(nx+i,EMUSCRHeight-(ny+j),clr);
  End;

  Function GetRomCh(Ch: Byte): integer;
  Begin
    Reverse := testbit(TVModeReg, 0);
    if not testbit(TVModeReg, 1) then
    Begin
      if Ch > 127 then
      Begin
        Ch := Ch - 128;
        Reverse := not Reverse;
      End;
    End;
    result := Ch;
  End;

begin

  addr := GetRomCh(Ch);
  if addr = -1 then
    exit;

  getchar8; // get the char pattern to charb 10 byte array

  for y := 0 to lengy - 1 do
    for x := 0 to lengx - 1 do
      DrawPixel(cx * lengx + x, cy * lengy + y, testbit(charb[y], Byte(x)));
  Reverse := testbit(TVModeReg, 0);
end;

// get the page no and offset in screen buffer  and return the screen byte
Function TNBScreen.GetNextByte(var p: integer; var Offset: integer): Byte;
  Procedure NextPage;
  Begin
    // Valid pages are only the 1st 4 rams
    // 104,105,106,107
    // 1st it gives the largest possible page
    // then the smaller one it goes backwards

    p := p - 1;
    if p < 104 then // shouldn't be here
      p := 107;
    // TODO: Find Next Page From a table
  End;

Begin
  if Offset >= $2000 then
  Begin
    NextPage;
    // ODS(Format('Change Video=%4x , Page=%d',[Offset,p]));
    Offset := Offset - $2000;
    if Offset >= $2000 then // max screen bytes are 20000 is 2.4 banks
    Begin
      NextPage;
      // ODS(Format('Change Video=%4x , Page=%d',[Offset,p]));
      Offset := Offset - $2000;
    End;
  End;
  result := nbmem.GetDirectMem(p, Offset);
  inc(Offset);
End;

var
  skipped, LASTSKIPPED: integer;

var
  paintevery: integer = 0;

function TNBScreen.getskipframe: integer;
var
  t: integer;
begin
  t := Lastfps + skipped - 50;
  // paintevery:=max((trunc(fNewbrain.Mhz*50) DIV 50),1);
  paintevery := (Lastfps div 50) + 1;
  result := paintevery;
end;

function TNBScreen.GetMenuHeight: integer;
Begin
  result := GetSystemMetrics(SM_CYMENU);
End;

// Paint the video screen text
function TNBScreen.PaintVideo: Boolean;
var
  x, y, nender: integer;
  nValue: Byte;
  s: String;
  Visy: integer;
  FormOffst: integer;
  ScaleFactor: Single;

  procedure CheckScreen;
  const
    DesignDPI = 96; // Your dev system DPI
  var
    EMUScrHeightScaled: integer;
    NoScale: integer;
  begin

    ScaleFactor := Screen.PixelsPerInch / DesignDPI;

    // Scale fixed height
    EMUScrHeightScaled := Round(EMUScrheight * ScaleFactor);

    // Width: scales based on layout and horizontal scaling
    fNewBrain.ClientWidth := 2 * (fNewBrain.Newscr.Left - fNewBrain.Panel6.Left)
      + Round(horzmult * LL * 8 * ScaleFactor);

    NoScale := GetMenuHeight + fNewBrain.Panel2.Height + fNewBrain.Panel4.Height
      + 2 * fNewBrain.Newscr.Top + // gap before and after then emuscr
      fNewBrain.Panel7.Height + fNewBrain.StatusBar1.Height;

    fNewBrain.Height := 2 * EMUScrHeightScaled + NoScale;

  end;

  Function TextVideo: Boolean;
  var
    r: TPair;
  Begin
    if not IsPaged then
      result := true
    else
    Begin
      r.w := VideoAddr.w;
      result := pgnbs.GetVideoNoByAddress(r) <> -1;
    End;
    HasText := result;
  End;

  procedure checkFPS;
  Begin
    // count frames painted
    if (GetTickCount - FPSTick >= 1000) then
    Begin
      Lastfps := FPS - skipped;
      // if fps>50 then
      // inc(paintevery);
      paintevery := getskipframe;
      FPS := 0;
      FPSTick := GetTickCount;
      LASTSKIPPED := skipped;
      skipped := 0;
    End;
  End;

  procedure DoPaintDX;
  var
    r: TRect;
  begin
    if not Newscr.CanDraw then
      exit;

    // Lock surface
    Newscr.Surface.Lock;
    try
      // Fill entire surface with a visible color
      r := Rect(0, 0, Newscr.Surface.Width, Newscr.Surface.Height);
      Newscr.Surface.Canvas.Brush.Color := clFuchsia; // bright magenta
      Newscr.Surface.Canvas.FillRect(r);

      // Draw ScaledImg if it is assigned
      if Assigned(ScaledImg) then
      begin
        // newscr.Surface.Canvas.Draw(0, 0, ScaledImg);
        Newscr.Surface.Canvas.StretchDraw(r, ScaledImg);
      end;

      // Ensure the canvas updates
      Newscr.Surface.Canvas.Release;
    finally
      Newscr.Surface.unLock;
    end;

    // Flip the surface to display
    try
      Newscr.Flip;
    except
      // Handle surface lost errors here if needed
    end;
  end;

var
  brked: Boolean;
  v1, v2: Byte;
  v3, v4: Byte;
  vp: integer;
  v, ofs: integer;

  ISDev33: Boolean;
  nStart: integer;
  wid: integer;
  Canv: TCanvas;
begin
  result := false;
  Printedlines := 0;
  try
    if not Newscr.CanDraw or (EL = 0) then
      exit;
    if not nbio.tvenabled then
    begin
      ScaledImg.Fill(BlackColor);
      DoPaintDX;
      exit;
    end;

    if (EL < 20) or (EL > 128) or (EL = FRM) then
    Begin
      FPS := 1;
      exit;
    End
    else
      inc(FPS);

    if (paintevery > 0) and (FPS mod paintevery <> 0) then
    BEgin
      inc(skipped);
      checkFPS;
      exit;
    end;

    lengx := 8; // 8x10 chars
    if EL = 128 then
      horzmult := 1
    else
      horzmult := 2;

    if not testbit(TVModeReg, 3) then
    Begin
      lengy := 10; // 8x10 chars
      if Char8 then
        LoadCharSet('CharSet2.chr');
      Char8 := false;
    End
    else
    Begin
      lengy := 8; // 8x8
      if not Char8 then
        LoadCharSet('CharSet4.chr');
      Char8 := true;
    End;

    Visy := DEP;
    if (EL = 128) and not Char8 then
      Visy := Visy - 1; // in 80 columns we have 25 lines not 26 (why?)
    CheckScreen;
    SetVirtualImage; // 320 or 640 width

    // border color change this to be visible
    if testbit(TVModeReg, 0) then
    begin
      // newscr.Surface.Fill(WhiteColor);
      VirtImg.Fill(WhiteColor);
    end
    Else
    begin
      // newscr.Surface.Fill(blackColor);
      VirtImg.Fill(BlackColor);
    end;

    vp := VIdeoPage;
    ISDev33 := not TextVideo;
    // Even in Dev 33 it adds a pseudo text screen in front of it
    If true { not IsDev33 } then // text screen visible i.e. not dev 33 visible
    Begin
      nStart := VideoMem.w;
      // ODS(Format('Start Video=%4x , Page=%d',[nstart,vp]));
      if IsPaged and (nStart >= $2000) then
      Begin
        // todo:Find this somehow
        vp := vp - 1;
        if vp < 0 then
          exit;
        nStart := nStart - $2000;
        if nStart >= $2000 then
        Begin
          vp := vp - 1;
          nStart := nStart - $2000;
        end;
      End;
      if overrideVidPg <> -1 then
        vp := overrideVidPg;

      // ODS(Format('Start Video 2 =%4x , Page=%d',[nstart,vp]));
      brked := false;
      for y := 0 to Visy - 1 do
      Begin
        s := '';
        if (y * lengy) > 249 then
          break; // 240+10=250
        For x := 0 to EL - 1 do
        Begin
          if x > LL - 1 then
            break;
          nender := nStart + ((y + VIDEOMSB) * EL) + x;
          if nbmem.PageEnabled then
          Begin
            v1 := GetNextByte(vp, nender);
            v := vp;
            ofs := nender; // we only want one byte forward
            v2 := GetNextByte(v, ofs);
            v3 := GetNextByte(v, ofs);
            v4 := GetNextByte(v, ofs);
          end
          else
          Begin
            v1 := nbmem.rom[nender];
            v2 := nbmem.rom[nender + 1];
            v3 := nbmem.rom[nender + 2];
            v4 := nbmem.rom[nender + 3];
            inc(nender); // for page mode compatibility
          End;

          nValue := v1;
          // test End of text screen
          if (v1 = $0) and (v2 = $0) and
            (((v3 = $20) and (v4 = $20)) or ((v3 = $0) and (v4 = $0))) then
          begin
            brked := true;
            break;
          End;
          // test end of line
          if (v1 = $0) then
            break;
          if nender > $FFFF then
            continue;
          PaintLetter(x, y, nValue);
        End;
        if brked then
          break;
      End;
      Startofgraph := y * lengy;
      Printedlines := y * lengy;
      EndOfText := nender - 1;
      Dev33Page := vp;
      // ODS(Format('End Text Video=%4x , Page=%d',[EndOfText,vp]));
    End
    Else
    Begin
      Startofgraph := -1;
      EndOfText := VideoAddrReg + 1; // ?? why add 1 i don't know yet
    End;

    if overrideDev33page <> -1 then
      Dev33Page := overrideDev33page;
    if overrideDev33addr <> -1 then
      EndOfText := overrideDev33addr;

    paintGraph(ISDev33);

    checkFPS;

    // wid:=  Round(newscr.width * ScaleFactor);

    ScaledImg.Canvas.StretchDraw(Rect(0, 0, 640, 500), VirtImg);
    wid := ScaledImg.Width;
    Canv := ScaledImg.Canvas;
    Canv.Font.Color := WhiteColor;
    Canv.Font.Size := 8;

    if ShowFps then
    Begin
      Canv.TextOut(0, 5, 'Menu    : ' + Inttostr(GetMenuHeight));
      Canv.TextOut(0, 25, 'Panel2    : ' + Inttostr(fNewBrain.Panel2.Height));
      Canv.TextOut(0, 45, 'Panel4    : ' + Inttostr(fNewBrain.Panel4.Height));
      Canv.TextOut(0, 65, 'Top    : ' + Inttostr(fNewBrain.Newscr.Top));
      Canv.TextOut(0, 85, 'EmuSCR  : ' + Inttostr(fNewBrain.Newscr.Height));
      Canv.TextOut(0, 105, 'Panel7    : ' + Inttostr(fNewBrain.Panel7.Height));
      Canv.TextOut(0, 125, 'Status    : ' +
        Inttostr(fNewBrain.StatusBar1.Height));
      Canv.TextOut(0, 145, 'FORM    : ' + Inttostr(fNewBrain.Height));

      Canv.TextOut(wid - 100, 5, 'FPS    : ' + Inttostr(Lastfps));
      Canv.TextOut(wid - 100, 25, 'MULT.  : ' + Floattostr(fNewBrain.Emuls) +
        '/' + Floattostr(fNewBrain.Mhz));
      Canv.TextOut(wid - 100, 45,
        'MHz    : ' + Floattostr(fNewBrain.Emuls * 4));
      Canv.TextOut(wid - 100, 65, 'Delay  : ' + Inttostr(nbdel));
      // Canv.TextOut(newscr.width-100,85,'Frm Skp: '+inttostr(maxpn));
      Canv.TextOut(wid - 100, 85, 'COP: ' + Inttostr(CpTm));
      Canv.TextOut(wid - 100, 105, 'CLK: ' + Inttostr(CkTm));
      Canv.TextOut(wid - 100, 125, 'PNTEVERY: ' + Inttostr(paintevery));
      Canv.TextOut(wid - 100, 145, 'SKIPPED : ' + Inttostr(LASTSKIPPED));
      if doHardware in Newscr.NowOptions then
        Canv.TextOut(wid - 100, 170, 'HARDWARE')
      else
        Canv.TextOut(wid - 100, 170, 'SOFTWARE')
    end;

    DoPaintDX;
    result := true;
  Finally
  End;
end;

procedure TNBScreen.TakeScreenShot;
Begin
  VirtImg.SaveToFile(AppPath + 'NbScreen_Orig.dib');
  ScaledImg.SaveToFile(AppPath + 'NbScreen_Scaled.dib');
End;

function TNBScreen.startgraph: TPair; // Not Used
Var
  mslt: Byte;
begin
  if not IsPaged then
  Begin
    result.l := nbmem.rom[Grst.Memory.w + 42];
    result.h := nbmem.rom[Grst.Memory.w + 43];
    result.w := result.w - 1;
  End
  Else
  Begin
    result.l := nbmem.nbPages[ParamGrPage]^.Memory[ParamGrOffset + 49];
    result.h := nbmem.nbPages[ParamGrPage]^.Memory[ParamGrOffset + 48];
    result.w := result.w - 1;

    mslt := result.w div $2000;

    GrPage := Dev33Page;
    result.w := result.w - mslt * $2000;
  End;
end;

function TNBScreen.GetAVideoTop: TPair;
begin
  result.h := nbmem.rom[$A4];
  result.l := nbmem.rom[$A3];
end;

function TNBScreen.GetTV4: Byte;
begin
  result := nbmem.rom[$BA];
end;

function TNBScreen.GetVideoBase: TPair;
begin
  result.h := nbmem.rom[$A2];
  result.l := nbmem.rom[$A1];
end;

function TNBScreen.GetVIDEOTOP: TPair;
begin
  result.h := nbmem.rom[$A0];
  result.l := nbmem.rom[$9F];
end;

function TNBScreen.IsPaged: Boolean;
begin
  result := nbmem.PageEnabled;
end;

function TNBScreen.GetParamed(Offs: Word): Byte;
begin
  try
    result := 0;
    if not nbmem.chipexists(ParamPg) then
      exit;
    result := nbmem.nbPages[ParamPg]^.Memory[ParamOffset + Offs + 6];
  Except
    result := 0;
  End;
end;

function TNBScreen.ValidGraph: Boolean;
begin
  result := false;
  If not IsPaged then
  Begin
    Grst := GetGraphStrm;
    if not nbs.found then
      exit;
    result := true;
  End
  Else
  Begin
    if HasText then
      result := pgnbs.HasGraphStream(Startofgraph)
    else
      result := pgnbs.HasGraphStream(-1);
    // if true pgnbs is positioned on graph stream
    if result then
    Begin
      ParamGrPage := pgnbs.PageNo;
      ParamGrOffset := pgnbs.PageOffset.w;
      if Startofgraph < 0 then
        Startofgraph := 0;
      result := ParamGrPage > 0; // Page 0 is invalid 99 to 107
    End;
  End;

end;

function TNBScreen.GetTV0: Byte;
begin
  result := nbmem.rom[13];
end;

// Save screen to disk as bitmap RAW
// Needed on NB laptop to test the screen
procedure TNBScreen.CaptureToDisk;
var
  f: TFilestream;
  xmax, ymax, x, y, i: integer;
  b: Byte;
  nbb: Byte;
  ft: tform;
Begin
  f := TFilestream.Create(AppPath + 'ScrRaw.bin', fmCreate);
  xmax := 640 div 8;
  ymax := 256;

  for y := 0 to ymax - 1 do
    for x := 0 to xmax - 1 do
    Begin
      for i := 0 to 7 do
      Begin
        b := Newscr.Surface.Canvas.Pixels[x * 8 + i, y * 2];
        if b = 0 then
          nbb := clearbit(nbb, i)
        else
          nbb := Setbit(nbb, i);
      end;
      f.Write(nbb, 1);
    End;
  f.Free;

  ft := tform.Create(application);
  ft.Caption := 'Picture Preview';
  ft.ClientWidth := 640;
  ft.ClientHeight := 256;
  ft.OnPaint := dopaint;

  ft.show;
End;

// just paint the screen to show the user what will be saved on disk
procedure TNBScreen.dopaint(Sender: TObject);
var
  xmax, ymax, x, y, i: integer;
  b: Byte;
  nbb: Byte;

Begin
  xmax := 640 div 8;
  ymax := 256;

  for y := 0 to ymax - 1 do
    for x := 0 to xmax - 1 do
    Begin
      for i := 0 to 7 do
      Begin
        b := Newscr.Surface.Canvas.Pixels[x * 8 + i, y * 2];
        tform(Sender).Canvas.Pixels[x * 8 + i, y] := b;
      End;
    End;
end;

end.
