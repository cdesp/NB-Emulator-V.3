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
    procedure SetBackColor(const Value: byte);
    procedure SetForeColor(const Value: byte);
    procedure InitializeColors;
    function GetScrBColor: TColor;
    function GetScrFColor: TColor;
    procedure SetColor(const Value: byte);
    procedure SetScrColor(const Value: TColor);
    function GetColor: byte;
    procedure ClearVideoPages;
  protected

  public
    constructor Create;
    procedure setTextAddr(addr:word);
    function getAddrForeColor(addr: Word): TColor;
    function getAddrBackColor(addr: Word): TColor;
    property ForeColor: byte read FForeColor write SetForeColor;
    property BackColor: byte read FBackColor write SetBackColor;
    property ScrFColor: TColor read GetScrFColor;
    property ScrBColor: TColor read GetScrBColor;
    property Color: byte read GetColor;
  end;

Var
  NBColScr: TNBColorScreen = nil;

implementation
uses unbmemory;

{ TNBColorScreen }

constructor TNBColorScreen.Create;
begin
   FForeColor:=2;
   FBackColor:=0;
   InitializeColors;
   mempg:=96; //and 97 for 16kb
   clearVideoPages;
end;

//combines the two colors to one byte
function TNBColorScreen.GetColor: byte;
begin
  result:= (FForeColor shl 4) or FBackColor;
end;

function TNBColorScreen.GetScrBColor: TColor;
begin
  if FBackColor<length(NBCS_ColorIDX) then
   Result:= NBCS_ColorIDX[FBackColor];
end;


function TNBColorScreen.GetScrFColor: TColor;
begin
  if FForeColor<length(NBCS_ColorIDX) then
   Result:= NBCS_ColorIDX[FForeColor];
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
  NBCS_ColorIDX[15] := clAqua;
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

procedure TNBColorScreen.SetScrColor(const Value: TColor);
begin
  FScrColor := Value;
end;

//A char is writen on this address on text screen
//we set the colors on our buffer
procedure TNBColorScreen.setTextAddr(addr: word);
begin
   if addr<16384 then
    nbmem.SetDirectMem(mempg,addr,Color)
   else
    nbmem.SetDirectMem(mempg+1,addr-16384,Color);
end;

function TNBColorScreen.getAddrForeColor(addr:Word):TColor;
var clr:word;
    cidx:integer;
begin
   if addr<16384 then
    clr:= nbmem.GetDirectMem(mempg,addr)
   else
    clr:= nbmem.GetDirectMem(mempg+1,addr-16384);
   cidx:=clr shr 4;
   result:=NBCS_ColorIDX[cidx];
end;

function TNBColorScreen.getAddrBackColor(addr:Word):TColor;
var clr:word;
    cidx:integer;
begin
   if addr<8192 then
    clr:= nbmem.GetDirectMem(mempg,addr)
   else
    clr:= nbmem.GetDirectMem(mempg+1,addr-8192);
   cidx:=clr and $0F;
   result:=NBCS_ColorIDX[cidx];
end;

procedure TNBColorScreen.ClearVideoPages;
var i:integer;
begin
    //clear pages with default colors
   for i:=0 to $2000-1 do
   begin
     nbmem.SetDirectMem(mempg,i,Color);
     nbmem.SetDirectMem(mempg+1,i,Color);
   end;


end;

end.
