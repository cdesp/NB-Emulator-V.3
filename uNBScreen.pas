{
Grundy NewBrain Emulator Pro Made by Despsoft

Copyright (c) 2004, Despoinidis Chris
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation and/or
other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors
may be used to endorse or promote products derived from this software without
specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON A
NY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
}
unit uNBScreen;

interface
Uses uNBTypes,DXDraws,uNBStream,graphics,classes,DIB;

Const ScreenYOffset=2;
      ScreenXOffset=2;

Type

  TNBScreen=Class

  private
       Char8: Boolean;
       FPSTick: Cardinal;
       GraphExists: Boolean;
       Grst: TNbStream;
       lengx, lengy: integer;
       ParamPg: Integer;
       ParamOffset: Word;
       ParamGrPage: Byte;
       ParamGrOffset: Word;
       ISCpmV: Boolean;
       Startofgraph: Integer;
       GrPage: Byte;
       EndOfText: Integer;
       HasText: Boolean;
       Printedlines: Integer;
       VirtImgC:TDxdib;
       VirtImg:TDIB;
       ScaledImg : TDIB;
       function GetNextByte(var p, Offset: Integer): Byte;
       function GetDEP: byte;
       function GetEL: byte;
       function GetExcess: Byte;
       function GetEXFlags: byte;
       function GetFlags: byte;
       function GetFRM: byte;
       function GetinpB: byte;
       function GetinpC: Byte;
       function GetLL: byte;
       function GetLN: byte;
       function GetPLLEN: Byte;
       function GetPZLEN: Byte;
       function GetTvMode: Byte;
       function GetTVOverHead: Integer;
       function GetVideoAddr: TPair;
       function GetVideoMem: TPair;
       function GraphWidth: Word;
       function lastGraph: TPair;
       function startgraph: Tpair;
       function GetAVideoTop: TPair;
       function GetTV4: Byte;
       function GetVideoBase: TPair;
       function GetVIDEOTOP: TPair;
       function IsPaged: Boolean;
       function GetTV0: Byte;
       function GetSlotn(w: Word): Integer;
       procedure dopaint(Sender: TObject);
       function getskipframe: integer;
       procedure SetVirtualImage;
  public
       horzmult:Integer;
       vertmult:Integer;
       EMUScrheight:integer; //variable
       EMUScrWidth:integer;
       FPS: Integer;
       Lastfps: Integer;
       nbs:TNBStreamManipulation;
       pgnbs:TNBPGStreamManipulation;
       Newscr: TDXDraw;
       ShowFps: Boolean;
       LedText: string;
       VideoAddrReg: Word;
       TVModeReg: Byte;
       VIdeoPage: Byte;
       WhiteColor: TColor;
       BlackColor: TColor;
       Reverse:Boolean;
       Dev33Page: Integer;
       VIDEOMSB: Integer;
       CpTm:Cardinal;
       CkTm:Cardinal;
       Constructor Create;
       function GetGraphStrm: TNBStream;
       function Graphlines: Word;
       procedure Clearscr;
       procedure paintGraph(ISDev33:Boolean=false);
       function PaintVideo: Boolean;
       procedure PaintLetter(Const cx,cy:Integer;Ch:Byte;const dopaint:boolean=false);
       procedure PaintLeds(txt:String);
       procedure PaintDebug;
       function GetParamed(Offs:word): Byte;
       function ValidGraph: Boolean;
       procedure CaptureToDisk;
       procedure TakeScreenShot;
       property DEP: byte read GetDEP;
       property EL: byte read GetEL;
       property Excess: Byte read GetExcess;
       property EXFlags: byte read GetEXFlags;
       property Flags: byte read GetFlags;
       property FRM: byte read GetFRM;
       property inpB: byte read GetinpB;
       property inpC: Byte read GetinpC;
       property LL: byte read GetLL;
       property LN: byte read GetLN;
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

procedure LoadCharSet(fname:string);

Var NBScreen:TNbScreen;
    CharArr:Array[0..2560] of byte; //charset array

implementation
Uses z80baseclass,Sysutils,forms,uNBMemory,frmNewdebug,new,
     jcllogic,windows,uNBCop,uNBIO,controls;

//loads the charset from the disk
procedure LoadCharSet(fname:string);
Var f:File Of byte;
    i:Integer;
    pth:String;
begin
 pth:=Extractfilepath(application.exename);
 if FileExists(pth+fname) then
 Begin
  system.Assign(f,pth+fname);
  reset(f);
  For i:=0 to 2560 do
  BEgin
    read(f,CharArr[i]);
  End;
  system.Close(f);
 End;
end;

constructor TNBScreen.Create;
begin
//  Frame:=nil;
  WhiteColor:=clWhite;
  BlackColor:=clBlack;
  nbs:=TNBStreamManipulation.Create;
  pgnbs:=TNBPGStreamManipulation.Create;
  horzmult:=2;
  vertmult:=2;
  EMUScrheight:=250; //variable
  EMUScrWidth:=640;
//  VirtImgC:=TDxdib.create(fNewbrain);
  VirtImg:=TDIB.Create;
// Create the scaled destination image (640x500)
  ScaledImg := TDIB.Create;
  ScaledImg.Width := 640;
  ScaledImg.Height := 500;
  ScaledImg.BitCount := 24;
end;

Procedure TNBScreen.SetVirtualImage;
Begin
  if el=128 then
    VirtImg.Width:=640
  else
    VirtImg.Width:=320;
  VirtImg.Height:=250;
  VirtImg.BitCount:=24;
End;

procedure TNBScreen.ClearScr;
var i:Integer;
Begin
 for i:=videoMem.w to videoMem.w+eL*DEP do
  nbmem.rom[i]:=32;
End;

function TNBScreen.GetDEP: byte;
begin
//tvmode reg is set by out at port 12
// Bit 0 is Reverse video
// Bit 1 is full character Set
// Bit 2 is narrow screen
// Bit 3 is 30 lines display
// Bit 6 is 40 lines width if 0 , 80 lines if 1
  If testbit(TVModeReg,3) then
   result:=30
  else
   result:=26;
end;

function TNBScreen.GetEL: byte;
begin
  If testbit(TVModeReg,6) then
   result:=128
  else
   result:=64;
end;

function TNBScreen.GetExcess: Byte;
begin
  result:=24;  //fixed for model AD
  exit;
  if not ispaged then
    Result := nbmem.ROM[$0c]
  else
   result:=24;
end;

function TNBScreen.GetEXFlags: byte;
begin
  if not ispaged then
     Result := nbmem.ROM[videoaddr.w+8]
  Else
   result:=GetParamed(8);
end;

function TNBScreen.GetFlags: byte;
begin
  if not ispaged then
     Result := nbmem.ROM[videoaddr.w+7]
  else
   result:=GetParamed(7);
end;

function TNBScreen.GetFRM: byte;  //Not Used
begin
 result:=0;
 exit;

 if IsCPMv then
   Result:=0
 Else
 if not ispaged then
   Result := nbmem.ROM[videoaddr.w+10]
 Else
 Begin
   result:=GetParamed(10);
   Result:=0;
   //it is valid but we have the right
   //start address anyway so we dont need frm
 End;
end;

//Get the stream for device 11=Graphics
function TNBScreen.GetGraphStrm: TNBStream;
begin
  result:=nbs.FindStrmByMem(VideoAddr);
  if nbs.found then
  Begin
     nbs.found:=false;
     result:=nbs.FindStrmForGraph(11,result.PortNo);
  End;
end;

function TNBScreen.GetinpB: byte;
begin
 if not ispaged then
     Result := nbmem.ROM[videoaddr.w+12]
   else
     result:=GetParamed(12);
end;

function TNBScreen.GetinpC: Byte;
begin
 if not ispaged then
     Result := nbmem.ROM[videoaddr.w+13]
 Else
   result:=GetParamed(13);
end;

function TNBScreen.GetLL: byte;
begin
  If testbit(TVModeReg,6) then
   result:=80
  else
   result:=40;

exit;
 if IsCPMv then
   Result:=80
 Else
 if not ispaged then
  Result := nbmem.ROM[videoaddr.w+5]
 else
  result:=GetParamed(5);
end;

function TNBScreen.GetLN: byte;
begin
  If testbit(TVModeReg,6) then
   result:=80
  else
   result:=40;

exit;

 if IsCPMv then
   Result:=80
 else
 if not ispaged then
  Result := nbmem.ROM[videoaddr.w+9]
 Else
  result:=GetParamed(9);
end;

function TNBScreen.GetPLLEN: Byte;
begin
     //Chars per line 40 or 80
    Result := nbmem.ROM[$1b];
end;

function TNBScreen.GetPZLEN: Byte;
begin
     Result := nbmem.ROM[$1d];   //10 for 40 chars
end;                       //17 for 80 chars

function TNBScreen.GetTvMode: Byte;
begin
 if IsCPMv then
   Result:=1
 Else
 if not ispaged then
  Result:=nbmem.rom[VideoAddr.w+1] and $f
 Else
   result:=GetParamed(1) and $f;
end;

function TNBScreen.GetTVOverHead: Integer;  //Not Used
Begin
 if IsCPMv then
   Result:=0
 else
 if Not ispaged then
  Result:=nbmem.Rom[videoAddr.w]+5
 Else
  result:=1;
End;

function TNBScreen.GetVideoAddr: TPair;
begin
  if not IsCpmV then
  Begin
     Result.h := nbmem.rom[$5d];
     Result.l := nbmem.rom[$5c];
  End
  Else
   Result.w:=0;
end;

function TNBScreen.GetVideoMem: TPair;
begin
//  Result.w:=videoAddr.w+GetTVOverHead //actual address
 If testbit(TVModeReg,6) then
  Result.w:=videoAddrreg+4 //actual address
 Else
  Result.w:=videoAddrreg+2; //actual address
end;

function TNBScreen.GraphLines: Word;
begin
 result:=0;
 If not ispaged then
  result:=nbmem.rom[GRst.Memory.w+28]
 Else
  if nbmem.chipexists(ParamGRPage) then
   result:=nbmem.nbPages[ParamGRPage]^.Memory[ParamGROffset+34];//28
end;

function TNBScreen.GraphWidth: Word;
begin
 result:=0;
 If Not ispaged then
  result:=nbmem.rom[GRst.Memory.w+25]
 Else
  if nbmem.chipexists(ParamGRPage) then
   result:=nbmem.nbPages[ParamGRPage]^.Memory[ParamGROffset+31]; //25
end;

function TNBScreen.LastGraph: TPair;      //Not Used
begin
  result.l:=nbmem.rom[GRst.Memory.w+44];
  result.h:=nbmem.rom[GRst.Memory.w+45];
  result.w:=  result.w-1;
end;

//Paint the debug information on Newdebug form
procedure TNBScreen.PaintDebug;
Var
    h,i:Integer;
    s:String;
    Col1,Col2,Col3,col4:Integer;

    Procedure PaintFlags;
    Var af:TPair;
        f:Byte;
        s:String;
        i:Integer;

    Begin
      af.w:=z80_get_reg(Z80_REG_AF);
      f:=af.l;
      s:='szxnxpnc';
      for i:=0 to 7 do
       if TestBit(f,Byte(i)) then
        s[8-i]:=Uppercase(s[8-i])[1]
       else
        s[8-i]:=Lowercase(s[8-i])[1];
      NewDebug.debugscr.Surface.Canvas.
        TextOut(Col3,1*h,'FL : '+s);
    End;

    Procedure PAintSP;
    var sp:TPair;
        i:Integer;
    Begin
      sp.w:=z80_get_reg(Z80_REG_SP);
      i:=2;
      with NewDebug.debugscr.Surface.Canvas do
      begin
       repeat
        s:=Format('%s : %s',[inttohex(sp.w,4),Inttohex(nbmem.rom[sp.w],4)]);
        sp.w:=sp.w-2;
        inc(i);
        TextOut(Col4,i*h,s);
        if i>15 then break;
       until false;
      End;
    End;

Begin
  Col1:=10;
  Col2:=140;
  Col3:=320;
  col4:=450;


  if not NewDebug.debugscr.CanDraw then exit;

  NewDebug.debugscr.Surface.Fill(5);
  NewDebug.debugscr.Surface.Lock();

  with NewDebug.debugscr.Surface.Canvas do
  begin
    Brush.Style := bsClear;
    Font.Name:='Courier New';
    Font.Color := clWhite;
    Font.Size := 8;
    h:=10;
    if fNewBrain.Suspended then
     s:='Suspended'
    else
     s:='Running';
    Textout(Col1, 0, DateTimeToStr(Now)+' Engine is '+s);
    TextOut(Col1,1*h,'PC    : '+inttohex(z80_get_reg(Z80_REG_PC),4));
    TextOut(Col1,2*h,'AF    : '+inttohex(z80_get_reg(Z80_REG_AF),4));
    TextOut(Col1,3*h,'HL    : '+inttohex(z80_get_reg(Z80_REG_HL),4)+'('+Inttostr(nbmem.rom[z80_get_reg(Z80_REG_HL)])+')');
    TextOut(Col1,4*h,'DE    : '+inttohex(z80_get_reg(Z80_REG_DE),4));
    TextOut(Col1,5*h,'BC    : '+inttohex(z80_get_reg(Z80_REG_BC),4));
    TextOut(Col1,6*h,'IX    : '+inttohex(z80_get_reg(Z80_REG_IX),4));
    TextOut(Col1,7*h,'IY    : '+inttohex(z80_get_reg(Z80_REG_IY),4));
    TextOut(Col1,8*h,'IM    : '+inttohex(z80_get_reg(Z80_REG_IM),4));
    TextOut(Col1,9*h,'IR    : '+inttohex(z80_get_reg(Z80_REG_IR),4));
    TextOut(Col1,10*h,'IF1   : '+inttohex(z80_get_reg(Z80_REG_IFF1),4));
    TextOut(Col1,11*h,'IF2   : '+inttohex(z80_get_reg(Z80_REG_IFF2),4));
    TextOut(Col1,12*h,'SP    : '+inttohex(z80_get_reg(Z80_REG_SP),4));
    TextOut(Col1,13*h,'IRQV  : '+inttohex(z80_get_reg(Z80_REG_IRQVector),4));
    TextOut(Col1,14*h,'IRQL  : '+inttohex(z80_get_reg(Z80_REG_IRQLine),4));
    TextOut(Col1,15*h,'Halt  : '+inttohex(z80_get_reg(Z80_REG_Halted),4));

    PaintFlags;

    TextOut(Col1,18*h,'COPCTL: '+getbinaryfrombyte(nbmem.ROM[$3b]));
    TextOut(Col1,19*h,'COPST : '+getbinaryfrombyte(nbmem.ROM[$3c]));
    TextOut(Col1,20*h,'ENREG1: '+getbinaryfrombyte(nbmem.ROM[$24]));
    TextOut(Col1,21*h,'IOPUC : '+inttohex(nbmem.ROM[$25],2));
    s:=inttohex(nbmem.ROM[$1f],2)+inttohex(nbmem.ROM[$1e],2);
    TextOut(Col1,22*h,'SAVE1 : '+s);
    TextOut(Col1,23*h,'EL    : '+inttohex(EL,4));
    TextOut(Col1,24*h,'LL    : '+inttohex(LL,4));
    TextOut(Col1,25*h,'LN    : '+inttohex(LN,4));
    TextOut(Col1,26*h,'DEP   : '+inttohex(DEP,4));
    TextOut(Col1,27*h,'FRM   : '+inttohex(FRM,4));
    TextOut(Col1,28*h,'FLAGS : '+getbinaryfrombyte(FLAGS));
    TextOut(Col1,29*h,'EXFLAG: '+getbinaryfrombyte(EXFLAGS));
    TextOut(Col1,30*h,'INPB  : '+inttohex(inpb,4));
    TextOut(Col1,31*h,'INPC  : '+inttohex(inpc,4));
    s:=inttohex(nbmem.ROM[$5b],2)+inttohex(nbmem.ROM[$5a],2);
    TextOut(Col1,32*h,'TVCUR : '+s);
    s:=inttohex(nbmem.ROM[$5d],2)+inttohex(nbmem.ROM[$5c],2);
    TextOut(Col1,33*h,'TVRAM : '+s);
    s:=inttohex(nbmem.ROM[$05],2)+inttohex(nbmem.ROM[$04],2);
    TextOut(Col1,34*h,'B3PRM : '+s);
    s:=inttohex(nbmem.ROM[$38],2)+inttohex(nbmem.ROM[$3A],2)+inttohex(nbmem.ROM[$39],2);
    TextOut(Col1,35*h,'RST56 : '+s);
    s:=inttohex(nbmem.ROM[$2d],2)+inttohex(nbmem.ROM[$2c],2);
    TextOut(Col1,36*h,'GSPR  : '+s);
    s:=inttohex(nbmem.ROM[$07],2)+inttohex(nbmem.ROM[$06],2);
    TextOut(Col1,37*h,'B4    : '+s);
    s:=inttohex(nbmem.ROM[$57],2)+inttohex(nbmem.ROM[$56],2);
    TextOut(Col1,38*h,'STRTAB: '+s);
    s:=inttohex(nbmem.ROM[$65],2)+inttohex(nbmem.ROM[$64],2);
    TextOut(Col1,39*h,'STRTOP: '+s);
    TextOut(Col1,40*h,'ENREG2: '+getbinaryfrombyte(nbmem.ROM[$B6]));

    if Breaked or stopped then
     TextOut(Col1,41*h,'Breakpoint reached');



    TextOut(Col2,30*h,'TVMode: '+inttostr(TVMode));

    s:=inttohex(nbmem.ROM[120],2)+inttohex(nbmem.ROM[119],2);
    TextOut(Col2,31*h,'CHRROM: '+s);

    s:=inttohex(nbmem.ROM[85],2)+inttohex(nbmem.ROM[84],2)
       +inttohex(nbmem.ROM[83],2)+inttohex(nbmem.ROM[82],2);
    TextOut(Col2,1*h,'CL/CK : '+s);
    s:=inttohex(nbmem.ROM[107],2)+inttohex(nbmem.ROM[106],2)
       +inttohex(nbmem.ROM[105],2);
    TextOut(Col2,2*h,'FICLK : '+s);
    s:=inttohex(nbmem.ROM[21],2)+inttohex(nbmem.ROM[20],2);
    TextOut(Col2,3*h,'SAVE2 : '+s);
    s:=inttohex(nbmem.ROM[23],2)+inttohex(nbmem.ROM[22],2);
    TextOut(Col2,4*h,'SAVE3 : '+s);
    s:=inttohex(nbmem.ROM[$3D],2);
    TextOut(Col2,6*h,'COPBF : '+s);
    s:=inttohex(nbmem.ROM[$51],2)+inttohex(nbmem.ROM[$50],2);
    TextOut(Col2,7*h,'CHSUM : '+s);

    TextOut(Col2,37*h,'TV0   : '+inttostr(nbmem.rom[13]));
    TextOut(Col2,38*h,'TV2   : '+getbinaryfrombyte(nbmem.rom[14]));
    TextOut(Col2,39*h,'TV1   : '+inttostr(nbmem.rom[15]));
    TextOut(Col3,39*h,'TV4   : '+inttostr(TV4));

    For i:=0 to 7 do
     if nbmem.mainslots[i]<>nil then
      TextOut(Col2,(10+i)*h,'M/S '+inttostr(i)+' : '+Inttostr(nbmem.mainslots[i].Page)+'.'+nbmem.mainslots[i].Name)
     Else
      TextOut(Col2,(10+i)*h,'M/S '+inttostr(i)+' : 000.N/A');

    If nbmem.AltSet then
     TextOut(Col2,19*h,'ALTN Set ')
    Else
     TextOut(Col2,19*h,'MAIN Set ');

    For i:=0 to 7 do
     if nbmem.Altslots[i]<>nil then
       TextOut(Col2,(21+i)*h,'A/S '+inttostr(i)+' : '+Inttostr(nbmem.altslots[i].Page)+'.'+nbmem.Altslots[i].Name)
     Else
       TextOut(Col2,(21+i)*h,'A/S '+inttostr(i)+' : 0.N/A');

    TextOut(Col3,4*h,'VTop  : '+inttostr(Videotop.w));
    TextOut(Col3,5*h,'VBase : '+inttostr(VideoBase.w));
    TextOut(Col3,6*h,'AVtop : '+inttostr(AVideotop.w));

    TextOut(Col3,7*h,'DiscB : '+inttostr(nbmem.rom[$7a]*256+nbmem.rom[$79]));
    TextOut(Col3,8*h,'STR11 : '+inttostr(nbmem.rom[$76]));

    TextOut(Col3,10*h,'S0    : '+inttostr(GetSlotn(nbmem.rom[$8c]*256+nbmem.rom[$8b])));
    TextOut(Col3,11*h,'S1    : '+inttostr(GetSlotn(nbmem.rom[$8e]*256+nbmem.rom[$8d])));
    TextOut(Col3,12*h,'S2    : '+inttostr(GetSlotn(nbmem.rom[$90]*256+nbmem.rom[$8f])));
    TextOut(Col3,13*h,'S3    : '+inttostr(GetSlotn(nbmem.rom[$92]*256+nbmem.rom[$91])));
    TextOut(Col3,14*h,'S4    : '+inttostr(GetSlotn(nbmem.rom[$94]*256+nbmem.rom[$93])));
    TextOut(Col3,15*h,'S5    : '+inttostr(GetSlotn(nbmem.rom[$96]*256+nbmem.rom[$95])));
    TextOut(Col3,16*h,'S6    : '+inttostr(GetSlotn(nbmem.rom[$98]*256+nbmem.rom[$97])));
    TextOut(Col3,17*h,'S7    : '+inttostr(GetSlotn(nbmem.rom[$9a]*256+nbmem.rom[$99])));
  if pclist<>nil then
  Begin
    For i:=pclist.count-1 downto 0 do
    Begin
     TextOut(Col3,(19+(pclist.count-i))*h,'PC-'+inttoStr(i)+' : '+inttoHex(Integer(PClist[i]),4));
     if pclist.count-i>10 then break;
    End;

    For i:=splist.count-1 downto 0 do
    Begin
     TextOut(Col4,(19+(splist.count-i))*h,'sp-'+inttoStr(i)+' : '+inttoHex(Integer(splist[i]),4));
     if splist.count-i>10 then break;
    End;

    PaintSp;
 End;

    try
     newdebug.PaintListing;
    Except
    End;
    Release; {  Indispensability  }
  end;

  NewDebug.debugscr.Surface.unLock;
  NewDebug.DebugScr.Flip;

End;

//returns the bank slot  that this address is
Function TNBScreen.GetSlotn(w:Word):Integer;
Var {sl,}pg:word;
    //t:Tpair;
Begin
 // sl:=w and $E000;
  pg:=w And $ff;
  //t.w:=pg;
  Result:=pg;
End;



//Paint the graphics screen if there is one
procedure TNBScreen.paintGraph(ISDev33:Boolean=false);
Var i,j:Integer;
    x,y:Integer;
    lengx,lengy:integer;
    addr:Integer;
    nocx:integer;
    nocy:integer;
    ch:Byte;

   Procedure DrawPixel(const x1,y1:integer; DoSet:Boolean);
   var clr:TColor;
       nx,ny:Integer;
       i,j:Integer;
   Begin
    if reverse then doset:=not doset;
    if doset then clr:=WhiteColor else clr:=BlackColor;
    VirtImg.Pixels[x1,startofgraph+y1]:=clr;
    exit;
    nx:=ScreenXOffset+x1*horzmult;
    ny:=ScreenYOffset+(startofgraph+y1)*vertmult;
    for i:=0 to horzmult-1 do
     for j:=0 to vertmult-1 do
       newscr.Surface.Pixel[nx+i,(ny+j)]:=clr;
       //frame.plot(nx+i,EMUSCRHeight-(ny+j),clr);
   End;

   var grp:Integer;

     narrow:boolean;
     ident:Integer;
begin


  GraphExists:=false;
  If not ValidGraph  then exit;
  GraphExists:=true;
  If printedlines>=250 then exit;//max lines

  lengx:=8; //8 bit
  lengy:=1; //1 byte

 // if not HasText then
 //    addr:=startGraph.w;


  nocx:=GraphWidth;     //280 bytes
  nocy:=GraphLines;
  if nocx=0 then
  Begin
     GraphExists:=false;
     Exit;
  End;


   addr:=EndOftext;
   grpage:=dev33page;//nbmem.lastpage;
   nocy:=nocy+10-(nocy mod 10);  //multiple of 10 lines always
   if nocy>249 then nocy:=249;
//   ODS(Format('Start Graph Video=%4x , Page=%d',[addr,grpage]));

  reverse:= testbit(tvmodereg,0);

  grp:=grpage;
  narrow:=(nocx=32) or (nocx=64);
  if narrow then
  Begin
   Ident:=nocx div 8;
   addr:=addr+ident;
   nocx:=nocx+ident;
  End
  else
   ident:=0;

 //addr:=addr+1;
 if addr>=$ffff then exit;
{ if IsPaged and (addr>=$2000) then
 Begin
     //todo:Find this somehow
    addr:=addr-$2000;
    grp:=grp-1;
    if grp<0 then exit;
 End;}


 for i:=0 to nocy-1 do     //count lines
 Begin
  for j:=0 to nocx-1 do //count column bytes
  Begin
   If narrow and (j<ident) then
    continue;
   for y:=0 to lengy-1 do   //enlarge pixel  y
   Begin
    if IsPaged  then
      ch:=GetNextByte(grp,addr)
    Else
     Begin
       ch:=nbmem.Rom[addr];
       inc(addr);
     end;
    for x:=Lengx-1 downto 0 do //enlarge pixel   x
       Drawpixel(j*8+x,(i*1)+y, TestBit(ch,Byte(x)) );
   End; //for y bit count
  End; //for j

  printedlines:=printedlines+1;
  If printedlines>=250 then break;//max lines
 End;//for i

// ODS(Format('End  Video=%4x , Page=%d',[addr,grp]));
end;

//paint the 16 char vfd
procedure TNBScreen.PaintLeds(txt:String);
begin
   ledtext:=copy(txt,1,16);
   Fnewbrain.SetLed(nil);
end;

//Paint a letter(ch) on screen at position cx,cy
procedure TNBScreen.PaintLetter(Const cx,cy:Integer;Ch:Byte;const
    dopaint:boolean=false);
Var
    x,y:Integer;
    addr:Integer;
    charb:array[0..9] of byte;

    Procedure getchar;
    var i:Integer;
    Begin
     for i:=0 to 7 do
      charb[i]:=ReverseBits(Chararr[addr+i*256]);

     charb[8]:=0;
     charb[9]:=0;

     //two bottom lines
     if ((ch>31) and (ch<128)) or (ch>159)  then
     Begin
       if charb[0] and 128=128 then
       Begin
         charb[0]:=charb[0] and $7f; //clear bit 8
         charb[8]:=charb[0];
         charb[0]:=0;
       End;
       if charb[1] and 128=128 then
       Begin
         charb[1]:=charb[1] and $7f; //clear bit 8
         charb[9]:=charb[1];
         charb[1]:=0;
       End;
     End
     else
      charb[8]:=charb[7];

     if reverse then
     Begin
       for i:=0 to 9 do
        charb[i]:=Charb[i] xor $ff;
     End;
    End;

    Procedure getchar8;
    var i:Integer;
    Begin
     for i:=0 to lengy-1 do
      charb[i]:=ReverseBits(Chararr[addr+i*256]);
     if reverse then
     Begin
       for i:=0 to lengy-1 do
        charb[i]:=Charb[i] xor $ff;
     End;

    End;

    Function GetRomForChar(ch:byte):Integer;
    Begin
     result:=-1;
     reverse:=false;

     Case TVMode of
      0,4:Begin              //ctrl W-D  set1
         if ch>127 then
           ch:=ch-128
         else
           reverse:=true;
         result:=ch;
        End;
      1,5:Begin               //ctrl W-A  set1 reversed
         if ch>127 then
         Begin
           ch:=ch-128;
           reverse:=true;
         End;
         result:=ch;
        End;
      2,6:result:=ch;   //Ctrl W-B set2
      3,7:Begin              //Ctrl W-C   set2 reversed
         result:=ch;
         reverse:=true;
        End;
      8,12:Begin
          if ch>127 then
          BEgin
           ch:=ch-128;
           reverse:=true;
          End;
          result:=ch; // Ctrl W-H Set 3
        End;
      9,13:Begin
          if ch>127 then
          BEgin
           ch:=ch-128;
          End
          else
            reverse:=true;
          result:=ch; // Ctrl W-I Set 3 reversed
        End;
      10,14:Begin
          result:=ch; // Ctrl W-J Set 4
         End;
      11,15:Begin
          result:=ch; // Ctrl W-k Set 4 reversed
          reverse:=true;
         End;
     end;
    End;

   Procedure DrawPixel(const x,y:integer;const DoSet:Boolean);
   var clr:TColor;
       nx,ny:Integer;
       i,j:Integer;
   Begin
    if doset then clr:=WhiteColor else clr:=blackColor;
    VirtImg.Pixels[x,y]:=clr;
    exit;
    nx:=ScreenXOffset+x*horzmult;
    ny:=ScreenYOffset+y*vertmult;
    for i:=0 to horzmult-1 do
     for j:=0 to vertmult-1 do
       newscr.Surface.Pixel[nx+i,ny+j]:=clr;
//        frame.plot(nx+i,EMUSCRHeight-(ny+j),clr);
   End;

   Function GetRomCh(Ch:Byte):Integer;
   Begin
     reverse:= testbit(tvmodereg,0);
     if not testbit(tvmodereg,1) then
     Begin
      if ch>127 then
      Begin
       ch:=ch-128;
       reverse:=not reverse;
      End; 
     End;
     Result:=ch;
   End;

begin

  addr:=GetRomCh(ch);
  if addr=-1 then exit;

  getchar8; //get the char pattern to charb 10 byte array

  for y:=0 to lengy-1 do
   for x:=0 to lengx-1 do
     DrawPixel(cx*lengx+x,cy*lengy+y,TestBit(charb[y],Byte(x)));
  reverse:= testbit(tvmodereg,0);
end;

//get the page no and offset in screen buffer  and return the screen byte
Function TNBScreen.GetNextByte(var p:integer;var Offset:Integer):Byte;
     Procedure NextPage;
     Begin
      //Valid pages are only the 1st 4 rams
      //104,105,106,107
      //1st it gives the largest possible page
      //then the smaller one it goes backwards


       p:=p-1;
       if p<104 then //shouldn't be here
        p:=107;
      //TODO: Find Next Page From a table  
     End;


Begin
      if offset>=$2000 then
      Begin
       NextPage;
      // ODS(Format('Change Video=%4x , Page=%d',[Offset,p]));
       Offset:=Offset-$2000;
       if offset>=$2000 then //max screen bytes are 20000 is 2.4 banks
       Begin
        NextPage;
//        ODS(Format('Change Video=%4x , Page=%d',[Offset,p]));
        Offset:=Offset-$2000;
       End;
      End;
      Result:=nbmem.GetDirectMem(p,Offset);
      inc(Offset);
End;

var skipped,LASTSKIPPED:integer;
var paintevery:integer=0;

function TNBScreen.getskipframe:integer;
var t:integer;
begin
    t:=lastFPS+SKIPPED-50;
//    paintevery:=max((trunc(fNewbrain.Mhz*50) DIV 50),1);
    paintevery:= (lastfps div 50)+1;
    result:=paintevery;
end;


//Paint the video screen text
function TNBScreen.PaintVideo: Boolean;
var x,y,nender:Integer;
    nValue:Byte;
    s:String;
    Visy:Integer;
    FormOffst:Integer;
    ScaleFactor: Single;


  procedure CheckScreen;
  const
    DesignDPI = 96; // Your dev system DPI
  var
    EMUScrHeightScaled: Integer;
    PaddingScaled: Integer;
  begin
    // Calculate how much to scale dimensions
    ScaleFactor := Screen.PixelsPerInch / DesignDPI;

    // Scale fixed height
    EMUScrHeightScaled := Round(520 * ScaleFactor);

    // Scale any padding/margin
    PaddingScaled := Round(8 * ScaleFactor);

    // Width: scales based on layout and horizontal scaling
    Fnewbrain.ClientWidth :=
       2 * (Fnewbrain.newscr.Left - Fnewbrain.Panel6.Left) +
       Round(HorzMult * LL * 8 * ScaleFactor);

    // Height offset from top panels + status bar, scaled
    FormOffst :=
      Round(Fnewbrain.Panel1.Height * ScaleFactor) +
      Round(Fnewbrain.Panel2.Height * ScaleFactor) +
      Round(Fnewbrain.StatusBar1.Height * ScaleFactor);

    // Full height with scaled values
    Fnewbrain.ClientHeight :=
      2 * Round(Fnewbrain.newscr.Top * ScaleFactor) +
      FormOffst +
      Round(250 * 2 * ScaleFactor)+   PaddingScaled;
  end;


    Function TextVideo:Boolean;
    var r:TPair;
    Begin
       if not ispaged then
        result:=true
       else
       Begin
         r.w:=videoaddr.w;
         result:=pgnbs.GetVideoNoByAddress(r)<>-1;
       End;
       HasText:=Result;
    End;

    procedure checkFPS;
    Begin
      //count frames painted
     if (GetTickCount-FpsTick>=1000) then
     Begin
      Lastfps:=fps-SKIPPED;
//      if fps>50 then
  //      inc(paintevery);
      paintevery:= getskipframe;
      fps:=0;
      fpstick:=gettickcount;
      LASTSKIPPED:=skipped;
      skipped:=0;
     End;
    End;

    procedure DoPaintDX;
    Begin
       if not newscr.candraw then exit;
       newscr.Surface.lock();
       Newscr.Surface.Canvas.Draw(0, 0, ScaledImg);
       Newscr.Surface.Canvas.Release;
      {Flip the buffer}
       try
        newscr.surface.unlock;
        Newscr.Flip;
       except
       end;
    End;


var
    brked:boolean;
    v1,v2:Byte;
    v3,v4:Byte;
    vp:Integer;
    v,ofs:Integer;

    IsDev33:Boolean;
    nStart:Integer;
    wid: integer;
    Canv:TCanvas;
begin
   Result:=false;
   Printedlines:=0;
 try
   if not newscr.candraw or (el=0) then exit;
   if not nbio.tvenabled then
   begin
      ScaledImg.Fill(255);
      DoPaintDX;
      exit;
   end;

   if (el<20) or (el>128) or (el=frm) then
   Begin
    FPS:=1;
    exit;
   End
   else Inc(fps);


   if (paintevery>0) and (fps mod paintevery <>0) then
   BEgin
    inc(skipped);
    checkFPS;
    exit;
   end;


  lengx:=8; //8x10 chars
  if el=128 then
   horzmult:=1
  else
   horzmult:=2;

  if not TEstBit(TVModeReg,3) then
  Begin
   lengy:=10; //8x10 chars
   if char8 then
    LoadCharset('CharSet2.chr');
   char8:=false;
  End
  else
  Begin
   lengy:=8; //8x8
   if not char8 then
    LoadCharset('CharSet4.chr');
   Char8:=true;
  End;

   visy:=DEP;
   if (el=128) and not char8 then
     visy:=visy-1; //in 80 columns we have 25 lines not 26 (why?)
   CheckScreen;
   SetVirtualImage; //320 or 640 width

   //border color change this to be visible
   if testbit(tvmodereg,0) then
   begin
   // newscr.Surface.Fill(WhiteColor);
    VirtImg.Fill(WhiteColor);
   end
   Else
   begin
   // newscr.Surface.Fill(blackColor);
    VirtImg.Fill(BlackColor);
   end;

  vp:=VideoPage;
  IsDev33:=not TextVideo;
  //Even in Dev 33 it adds a pseudo text screen in front of it
  If True{not IsDev33} then  //text screen visible i.e. not dev 33 visible
  Begin
   nstart:=videoMem.w;
//   ODS(Format('Start Video=%4x , Page=%d',[nstart,vp]));
       if IsPaged and (nstart>=$2000) then
       Begin
        //todo:Find this somehow
        vp:=vp-1;
        if vp<0 then exit;
        nstart:=nstart-$2000;
        if nstart>=$2000 then
        Begin
           vp:=vp-1;
           nstart:=nstart-$2000;
        end;
       End;
   if overrideVidPg<>-1 then
    vp:= overrideVidPg;

//   ODS(Format('Start Video 2 =%4x , Page=%d',[nstart,vp]));
   brked:=false;
   for y:=0 to visy-1 do
   Begin
    s:='';
    if (y*lengy)>249 then break;//240+10=250
    For x:=0 to el-1 do
    Begin
       if x>LL-1 then break;
       nender:=nstart+((y+VIDEOMSB)*el)+x;
       if nbmem.PageEnabled then
       Begin
          V1:=GetNextByte(vp,nender);
          v:=vp;ofs:=nender;   //we only want one byte forward
          V2:=GetNextByte(v,Ofs);
          V3:=GetNextByte(v,Ofs);
          V4:=GetNextByte(v,Ofs);
       end
       else
       Begin
        v1 := nbmem.ROM[nEnder];
        v2 := nbmem.ROM[nEnder+1];
        v3 := nbmem.ROM[nEnder+2];
        v4 := nbmem.ROM[nEnder+3];
        inc(nender);   //for page mode compatibility
       End;

       nvalue:=v1;
       //test End of text screen
       if (v1=$0) and (v2=$0) and
       ( ((v3=$20) and (v4=$20)) or
         ((v3=$0) and (v4=$0)) )
        then
        begin
         brked:=true;
         Break;
        End;
       // test end of line
       if (v1=$0) then break;
       if nender>$ffff then continue;
       paintletter(x,y,nvalue);
    End;
    if brked then break;
   End;
   Startofgraph:=Y*lengY;
   PrintedLines:=Y*lengY;
   EndOfText:=nEnder-1;
   dev33Page:=Vp;
//   ODS(Format('End Text Video=%4x , Page=%d',[EndOfText,vp]));
  End
  Else
  Begin
   Startofgraph:=-1;
   EndOfText:=VideoAddrReg+1;//?? why add 1 i don't know yet
  End;

  if overrideDev33page<>-1 then
    dev33page:= overrideDev33page;
  if overrideDev33addr<>-1 then
    EndOfText:=overrideDev33addr;

    paintgraph(IsDev33);


   checkFPS;

//   wid:=  Round(newscr.width * ScaleFactor);
   ScaledImg.Canvas.StretchDraw(Rect(0, 0, 640, 500), VirtImg);
   wid:=  ScaledImg.width;
   Canv:=ScaledImg.Canvas;

   if showfps then
   Begin
    //Newscr.Surface.Canvas.TextOut(0,5 ,'Width    : '+inttostr(newscr.width));
    //Newscr.Surface.Canvas.TextOut(0,25 ,'dpi    : '+inttostr(Screen.PixelsPerInch));

    Canv.TextOut(wid-100,5 ,'FPS    : '+inttostr(lastfps));
    Canv.TextOut(wid-100,25,'MULT.  : '+Floattostr(fnewbrain.Emuls)+'/'+Floattostr(fnewbrain.Mhz));
    Canv.TextOut(newscr.width-100,45,'MHz    : '+Floattostr(fnewbrain.Emuls*4));
    Canv.TextOut(newscr.width-100,65,'Delay  : '+inttostr(nbdel));
//    Canv.TextOut(newscr.width-100,85,'Frm Skp: '+inttostr(maxpn));
    Canv.TextOut(newscr.width-100,85,'COP: '+inttostr(CPTM));
    Canv.TextOut(newscr.width-100,105,'CLK: '+inttostr(CkTm));
    Canv.TextOut(newscr.width-100,125 ,'PNTEVERY: '+inttostr(paintevery));
    Canv.TextOut(newscr.width-100,145 ,'SKIPPED : '+inttostr(LASTskipped));
    if doHardware in newscr.NowOptions then
     Canv.TextOut(newscr.width-100,170,'HARDWARE')
    else
     Canv.TextOut(newscr.width-100,170,'SOFTWARE')
   end;



   DoPaintDX;
   result:=true;
 Finally
 End;
end;

procedure TNbScreen.TakeScreenShot;
Begin
  VirtImg.SaveToFile(AppPath+'NbScreen_Orig.dib');
  ScaledImg.SaveToFile(AppPath+'NbScreen_Scaled.dib');
End;

function TNBScreen.StartGraph: Tpair;  //Not Used
Var mslt:byte;
begin
 if not ispaged then
 Begin
  result.l:=nbmem.rom[GRst.Memory.w+42];
  result.h:=nbmem.rom[GRst.Memory.w+43];
  result.w:=  result.w-1;
 End
 Else
 Begin
  result.l:=nbmem.nbPages[ParamGRPage]^.Memory[ParamGROffset+49];
  result.h:=nbmem.nbPages[ParamGRPage]^.Memory[ParamGROffset+48];
  result.w:=  result.w-1;

  mslt:=result.w div $2000;

  grPage:=Dev33Page;
  result.w:=result.w-mslt*$2000;
 End;
end;

function TNBScreen.GetAVideoTop: TPair;
begin
     Result.h := nbmem.rom[$A4];
     Result.l := nbmem.rom[$A3];
end;

function TNBScreen.GetTV4: Byte;
begin
   Result := nbmem.rom[$BA];
end;

function TNBScreen.GetVideoBase: TPair;
begin
     Result.h := nbmem.rom[$A2];
     Result.l := nbmem.rom[$A1];
end;

function TNBScreen.GetVIDEOTOP: TPair;
begin
     Result.h := nbmem.rom[$A0];
     Result.l := nbmem.rom[$9f];
end;

function TNBScreen.IsPaged: Boolean;
begin
  Result := NbMem.PageEnabled;
end;

function TNBScreen.GetParamed(Offs:word): Byte;
begin
try
 result:=0;
 if not nbmem.chipexists(parampg) then exit;
 result:=nbmem.nbpages[ParamPg]^.memory[ParamOffset+offs+6];
Except
 result:=0;
End;
end;

function TNBScreen.ValidGraph: Boolean;
begin
  result:=False;
  If not IsPaged then
  Begin
   GRst:=GetGraphStrm;
   if not nbs.found then exit;
   Result :=true ;
  End
  Else
  Begin
    if hastext then
     result:=pgnbs.HasGraphStream(StartOfGraph)
    else
     result:=pgnbs.HasGraphStream(-1);
    //if true pgnbs is positioned on graph stream
    if result then
    Begin
     ParamGrPage:=pgnbs.PageNo;
     ParamGrOffset:=pgnbs.PageOffset.w;
     if StartOfGraph<0 then
      StartOfGraph:=0;
     result:= ParamGrPage>0;//Page 0 is invalid 99 to 107
    End;
  End;

end;

function TNBScreen.GetTV0: Byte;
begin
     Result := nbmem.rom[13];
end;

//Save screen to disk as bitmap RAW
//Needed on NB laptop to test the screen
procedure TNBScreen.CaptureToDisk;
var f:TFilestream;
    xmax,ymax,x,y,i:Integer;
    b:byte;
    nbb:byte;
    ft:tform;
Begin
   f:=tfilestream.Create(AppPath+'ScrRaw.bin',fmCreate  );
   xmax:=640 div 8;
   ymax:=256 ;

   for y := 0 to ymax - 1 do
     for x := 0 to xmax - 1 do
     Begin
       for i := 0 to 7 do
       Begin
        b:=newscr.Surface.canvas.Pixels[x*8+i,y*2];
        if b=0 then
         nbb:=clearbit(nbb,i)
        else
         nbb:=Setbit(nbb,i);
       end;
        f.Write(nbb,1);
     End;
  f.Free;

  ft:=tform.Create(Application);
  ft.Caption:='Picture Preview';
  ft.ClientWidth:=640;
  ft.ClientHeight:=256;
  ft.OnPaint:= dopaint;

  ft.show;
End;

//just paint the screen to show the user what will be saved on disk
procedure TNBScreen.dopaint(Sender:Tobject);
var
    xmax,ymax,x,y,i:Integer;
    b:byte;
    nbb:byte;

Begin
   xmax:=640 div 8;
   ymax:=256 ;

   for y := 0 to ymax - 1 do
     for x := 0 to xmax - 1 do
     Begin
       for i := 0 to 7 do
       Begin
        b:=newscr.Surface.canvas.Pixels[x*8+i,y*2];
        TForm(Sender).canvas.Pixels[x*8+i,y]:=b;
       End;
     End;
end;

end.
