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
unit uNBColorScreen;

interface

uses classes, graphics;

{$I 'dsp.inc'}

type

  TNBColorIndex = array[0..15] of TColor;

  TNBColorScreen = class
  private
    mempg:integer;
    FForeColor: byte;
    FBackColor: byte;
    NBCS_ColorIDX: TNBColorIndex;
    FScrColor: TColor;
    FColor: byte;
    FGRColor:byte;
    procedure SetBackColor(const Value: byte);
    procedure SetForeColor(const Value: byte);
    procedure InitializeColors;
    function GetScrBColor: TColor;
    function GetScrFColor: TColor;
    procedure SetColor(const Value: byte);
    procedure SetScrColor(const Value: TColor);
    function GetColor: byte;
    procedure ClearVideoPages;
    function getVRAM(Addr: Integer):Byte;
    procedure setVRAM(Addr: Integer; Value: Byte);
    function GetGRColor: byte;
    procedure SetGRColor(const Value: byte);
    function GetSCRGRBackColor: TColor;
    function GetSCRGRForeColor: TColor;
    function GetGRBackColor(col:byte): TColor;
    function GetGRForeColor(col:byte): TColor;
  protected

  public
    grAddr:word;
    constructor Create;
    procedure setTextAddr(addr:word);
    procedure setGraphAddr(addr: word);
    procedure setGraphColor(pxlSide:byte);
    function getAddrForeColor(addr: Word): TColor;
    function getAddrBackColor(addr: Word): TColor;
    function getGRAddrColor(addr: Word; pxlSide: byte): TColor;
    procedure doScrollUp;
    property ForeColor: byte read FForeColor write SetForeColor;
    property BackColor: byte read FBackColor write SetBackColor;
    property ScrFColor: TColor read GetScrFColor;
    property ScrBColor: TColor read GetScrBColor;
    property Color: byte read GetColor write SetColor;
    property GRColor: byte read GetGRColor write SetGRColor;
    property ScrGRBackColor: TColor read GetSCRGRBackColor;
    property ScrGRForeColor: TColor read GetSCRGRForeColor;
  end;

Var
  NBColScr: TNBColorScreen = nil;

implementation
uses unbmemory,uNBScreen,new,Z80BaseClass,sysutils;

{ TNBColorScreen }

constructor TNBColorScreen.Create;
begin
   FForeColor:=2;
   FBackColor:=0;
   InitializeColors;
   mempg:=96; //and 97,98,99 for 32kb video ram
   clearVideoPages;
end;

//combines the two colors to one byte
function TNBColorScreen.GetColor: byte;
begin
  result:= (FForeColor shl 4) or FBackColor;
end;

function TNBColorScreen.GetGRForeColor(col: byte): TColor;
var idx:integer;
begin
  idx:=(col and $F0) shr 4;
  Result:= NBCS_ColorIDX[idx];
end;

function TNBColorScreen.GetGRColor: byte;
begin
  result:=FGRColor;
end;

function TNBColorScreen.GetGRBackColor(col: byte): TColor;
var idx:integer;
begin
  idx:=(col and $0F);
  Result:= NBCS_ColorIDX[idx];
end;

function TNBColorScreen.GetScrBColor: TColor;
begin
  if FBackColor<length(NBCS_ColorIDX) then
  if FBackColor<16 then
   Result:= NBCS_ColorIDX[FBackColor];
end;


function TNBColorScreen.GetScrFColor: TColor;
begin
  if FForeColor<length(NBCS_ColorIDX) then
  if FForeColor<16 then
   Result:= NBCS_ColorIDX[FForeColor];
end;

function TNBColorScreen.GetSCRGRBackColor: TColor;
begin
  Result:= GetGRBackColor(GRColor);
end;

//no point to get this fore color info is on video color buffer
function TNBColorScreen.GetSCRGRForeColor: TColor;
begin
  raise exception.Create('Foreground color is set when pixel is set. no need to call this');
 // Result:= GetGRForeColor(GRColor);
end;

procedure TNBColorScreen.InitializeColors;
begin
  NBCS_ColorIDX[0] := clBlack;
  NBCS_ColorIDX[1] := clMaroon;
  NBCS_ColorIDX[2] := clGreen;
  NBCS_ColorIDX[3] := clOlive;
  NBCS_ColorIDX[4] := clNavy;
  NBCS_ColorIDX[5] := clPurple;
  NBCS_ColorIDX[6] := clTeal;
  NBCS_ColorIDX[7] := clSilver;
  NBCS_ColorIDX[8] := clGray;
  NBCS_ColorIDX[9] := clRed;
  NBCS_ColorIDX[10] := clLime;
  NBCS_ColorIDX[11] := clYellow;
  NBCS_ColorIDX[12] := clBlue;
  NBCS_ColorIDX[13] := clFuchsia;
  NBCS_ColorIDX[14] := clAqua;
  NBCS_ColorIDX[15] := clWhite;
end;

procedure TNBColorScreen.SetBackColor(const Value: byte);
begin
  FBackColor := Value;
end;

procedure TNBColorScreen.SetColor(const Value: byte);
begin
  FColor := Value;
end;

procedure TNBColorScreen.SetForeColor(const Value: byte);
begin
  FForeColor := Value;
end;

procedure TNBColorScreen.SetGRColor(const Value: byte);
begin
  FGRColor := Value;
end;

procedure TNBColorScreen.SetScrColor(const Value: TColor);
begin
  FScrColor := Value;
end;

//A char is writen on this address on text screen
//we set the colors on our buffer
procedure TNBColorScreen.setTextAddr(addr: word);
begin
   setVRam(addr,Color);
end;

//A pixel is writen on this address on Graph screen
//we set the colors on our buffer
procedure TNBColorScreen.setGraphAddr(addr: word);
begin
   setVRam(addr,GRColor);
end;

procedure TNBColorScreen.setGraphColor(pxlSide: byte);
var
  pxl, fg: Byte;
begin
  fg := (GRColor shr 4) and $0F;   // extract foreground nibble
  pxl := getVRam(grAddr);          // current color byte
  case pxlSide of
    0: pxl := (pxl and $F0) or fg;        // right pixel = foreground
    1: pxl := (pxl and $0F) or (fg shl 4); // left pixel  = foreground
  end;
  setvRAM(grAddr, pxl);
end;


function TNBColorScreen.getGRAddrColor(addr:Word;pxlSide:byte):TColor;
var clr:word;
    cidx:integer;
begin
   clr:=getVRam(addr);
   case pxlSide of
     0: cidx := clr and $0F; //0=right pixel
     1: cidx := clr shr 4;   //1=left pixel
   end;
   result:=NBCS_ColorIDX[cidx];
end;

function TNBColorScreen.getAddrForeColor(addr:Word):TColor;
var clr:word;
    cidx:integer;
begin
   clr:=getVRam(addr);
   cidx:=clr shr 4;
   result:=NBCS_ColorIDX[cidx];
end;


function TNBColorScreen.getAddrBackColor(addr:Word):TColor;
var clr:word;
    cidx:integer;
begin
   clr:=getVRam(addr);
   cidx:=clr and $0F;
   result:=NBCS_ColorIDX[cidx];
end;

procedure TNBColorScreen.ClearVideoPages;
var i:integer;
begin
    //clear pages with default colors
   for i:=0 to $8000-1 do
   begin
    setVRam(i,Color);
    // nbmem.SetDirectMem(mempg,i,Color);
    // nbmem.SetDirectMem(mempg+1,i,Color);
   end;


end;

function TNBColorScreen.getVRAM(Addr: Integer):Byte;
Var slt:Integer;
    offs:Integer;
    vmpg:integer;
begin
   slt:=Addr div $2000;
   offs:=Addr-(Slt*$2000);
   vmpg:=mempg+slt;
   Result:=nbmem.GetDirectMem(vmpg,offs);
end;

procedure TNBColorScreen.setVRAM(Addr: Integer; Value: Byte);
Var slt:Integer;
    offs:Integer;
    vmpg:integer;
begin
   slt:=Addr div $2000;
   offs:=Addr-(Slt*$2000);
   vmpg:=mempg+slt;
   nbmem.SetDirectMem(vmpg,offs,Value);
end;


//scrollup a line of colors
procedure TNBColorScreen.doScrollUp;
var stAddr,cpAddr:Word;
    LLen:Byte;
    totLines:Byte;
    col:byte;
    i: Integer;
    j: Integer;
begin
  stAddr:=nbScreen.VideoMem.w;
  LLen:=nbScreen.EL;
  totLines:=nbScreen.TXTLNS;
  for i := 1 to totLines-1 do
  begin
   cpAddr:=stAddr+LLEN;
   for j := 0 to LLEN-1 do
   begin
     col:=GetVRam(cpAddr+j);
     SetVRam(stAddr+j,col);
   end;
   stAddr:=cpAddr;
  end;
  //set lastline to current colors
  col:=Color;
  for i := 0 to LLEN-1 do
   SetVRam(stAddr+i,col);


end;


end.
