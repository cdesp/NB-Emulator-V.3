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

unit frmChrDsgn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DXDraws;

type
  Tfchrdsgn = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    chrscr: TDXDraw;
    Timer1: TTimer;
    Panel2: TPanel;
    PaintBox1: TPaintBox;
    Panel3: TPanel;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    cbten: TCheckBox;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure chrscrMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1Paint(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
  private
    cArr:Array[0..9] of byte;
    ch:Integer;

    procedure PaintLetter(cx,cy:Integer;Ch:Byte;const dopaint:boolean=false);
    function GetCharAtpos(x, y: integer): Integer;
    procedure Copychar(chfrom,chto:integer;reversed:boolean);
    procedure CopyROMchar(chfrom, chto: integer; reversed: boolean);
    procedure getchar8(ch: Integer);
    procedure Setchar8;
    { Private declarations }
  public
    function isTen: Boolean;
    function Rows: Integer;
    { Public declarations }
  end;

var
  fchrdsgn: Tfchrdsgn;

implementation
uses new,jcllogic,math,uNBScreen,unbmemory,unbtypes;

{$R *.DFM}

//Read charset file to Chararr array in uNbScreen
procedure Tfchrdsgn.Button2Click(Sender: TObject);
Var f:File Of byte;
    i,k:Integer;
begin
 if opendialog1.execute then
 Begin
  system.Assign(f,Opendialog1.FileName);
  reset(f);
  if isten then
   k:=2560
  else k:=2048;
  For i:=0 to k do
  BEgin
    read(f,chararr[i]);
  End;
  system.Close(f);
 End;
end;

//Save charset file from Chararr array in uNbScreen
procedure Tfchrdsgn.Button3Click(Sender: TObject);
Var f:File Of byte;
    i:Integer;
begin
 if Savedialog1.execute then
 Begin
  system.Assign(f,Savedialog1.FileName);
  rewrite(f);
  For i:=0 to 2560 do
  BEgin
    Write(f,chararr[i]);
  End;
  system.Close(f);
 End;


end;

//Set charset from ROM
procedure Tfchrdsgn.Button1Click(Sender: TObject);
Var i:integer;
    rommem:word;
begin
 rommem:=nbmem.rom[119]+nbmem.rom[120]*256;

 For i:=0 to 2048 do
   chararr[i]:=nbmem.rom[rommem+i];

end;

//Slow refresh we dont need a fast one
procedure Tfchrdsgn.Timer1Timer(Sender: TObject);
var i:Integer;
    x,y:Integer;
begin
 chrscr.Surface.Fill(0);

 x:=6;y:=6 ;
 for i:=0 to 255 do
 Begin
  paintLetter(x,y,i);
  inc(x,2);
  if x>46 then
  Begin
     inc(y,2);
     x:=6;
  End;
 End;

    chrscr.Surface.Canvas.Release;
   {Flip the buffer}
   chrscr.Flip;
    Paintbox1.Repaint;
end;

//This paints a letter
procedure Tfchrdsgn.PaintLetter(cx,cy:Integer;Ch:Byte;const
    dopaint:boolean=false);
Var
    x,y:Integer;
    lengx,lengy:integer;
    addr:Integer;
    hl:tpair;
    bt:Byte;
    charb:array[0..9] of byte;
    Reverse:Boolean;
    TVMode:Integer;

    //get the char from char array
    Procedure getchar;
    var i:Integer;
    Begin
     for i:=0 to rows-1 do
      charb[i]:=ReverseBits(chararr[addr+i*256]);

     exit;

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
       for i:=0 to 9 do
        charb[i]:=Charb[i] xor $ff;
    End;

    //same as the getchar now
    Procedure getchar8;
    var i:Integer;
    Begin
     for i:=0 to rows-1 do
      charb[i]:=ReverseBits(chararr[addr+i*256]);
    End;

    //Get the char position in the char array
    Function GetRomForChar(ch:byte):Integer;
    Begin
     result:=-1;
     reverse:=false;
     hl.l:=0;  //ROMCHAR
     hl.h:=0;


     Case TVMode of
      0,8:Begin              //ctrl W-D
         if ch>127 then
           ch:=ch-127
         else
           reverse:=true;
         result:=hl.w+ch;
        End;
      1,9:Begin               //ctrl W-A
         if ch>127 then
         Begin
           ch:=ch-127;
           reverse:=true;
         End;
         result:=hl.w+ch;
        End;
      2,10,6:result:=hl.w+ch;   //Ctrl W-B
      3,11:Begin              //Ctrl W-C
         result:=hl.w+ch;
         reverse:=true;
        End;
     { 8:;
      9:;
      10:Begin
          result:=hl.w+Offs+ch; // Ctrl W-J
         End;
      11:;}
     end;
    End;


begin
  lengx:=8; //8x10 chars
  LENGY:=rows;
  tvmode:=2;

  addr:=GetRomForChar(ch);
  if addr=-1 then exit;
  if lengy=10 then
   getchar
  else
   getchar8;

  for y:=0 to lengy-1 do
   for x:=1 to lengx do
   Begin
     bt:=byte(trunc(Ldexp(1,x-1)));
     if charb[y] and bt=bt then
        chrscr.Surface.Canvas.Pixels[cx*lengx+x-1,cy*lengy+y]:=clyellow
     else
       chrscr.Surface.Canvas.Pixels[cx*lengx+x-1,cy*lengy+y]:=clBlack;
   End;
end;


procedure Tfchrdsgn.FormDeactivate(Sender: TObject);
begin
timer1.enabled:=false;
end;

procedure Tfchrdsgn.FormActivate(Sender: TObject);
begin
 timer1.enabled:=true;
end;

procedure Tfchrdsgn.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 action:=cafree;
end;

//Get the char no at mouse coords x,y
Function Tfchrdsgn.GetCharAtpos(x,y:integer):Integer;
Var col,row:Integer;
Begin
   result:=-1;
   if (x<6*8) or (y<6*rows) then exit;
   x:=x-6*8;
   y:=y-6*rows;

   col:=x div 8;
   row:=y div rows;

   if (col mod 2=0) and (row mod 2=0) then
   Begin
    col:=col div 2;
    row:=row div 2;
    result:=row*21+col;
   End;
End;

Procedure Tfchrdsgn.getchar8(ch:Integer);
var i:Integer;
Begin
   for i:=0 to fchrdsgn.rows-1 do
      cArr[i]:=ReverseBits(chararr[ch+i*256]);
End;

Procedure Tfchrdsgn.Setchar8;
var i:Integer;
Begin
   for i:=0 to fchrdsgn.rows-1 do
    chararr[ch+i*256]:=ReverseBits(cArr[i]);
End;

procedure Tfchrdsgn.chrscrMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ch:=GetCharAtpos(x,y);
  if ch>-1 then
   getchar8(ch);
  Paintbox1.Repaint;
end;

//Paint the char large
procedure Tfchrdsgn.PaintBox1Paint(Sender: TObject);
Var x,y:Integer;
    ch1:integer;
    bt:Byte;

   Procedure Paint(fl:Boolean);
   var cl:Tcolor;
       cx,cy:Integer;
       leng:Integer;
       rc:trect;
   Begin
    if fl then cl:=clblack
    else cl:=clWhite;
    leng:=14;
    cx:=13+x*(leng+2);
    cy:=63+y*(leng+2);

    rc.Left:=cx;
    rc.Top:=cy;
    rc.Right:=rc.Left+leng;
    rc.Bottom:=rc.top+leng;
    PaintBox1.canvas.Brush.Style := BSSOLID;
    PaintBox1.Canvas.Brush.Color:=cl;
    Paintbox1.Canvas.FillRect(rc);
   End;


begin
  Paintbox1.Font.Size:=16;
  Paintbox1.Canvas.TextOut(5,1,' '+inttostr(ch)+' ');
  for y:=0 to rows-1 do
  Begin
   ch1:=carr[y];
   for x:=1 to 8 do
   Begin
     bt:=byte(trunc(Ldexp(1,x-1)));
     Paint(ch1 and bt=bt);
   End;
  End;

end;

//Set reset pixels to draw the char
procedure Tfchrdsgn.PaintBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var leng:Integer;
    b:byte;
begin
  leng:=14;
  x:=x-13;
  y:=y-63;
  x:=x div (leng+2)-1;
  y:=y div (leng+2);
  if (x<0) or (x>7) then exit;
  if (y<0) or (y>rows-1) then exit;

  b:=carr[y];
  if TestBit(b,Byte(x)) then
   b:=Clearbit(b,byte(x))
  else
   b:=Setbit(b,byte(x));
  carr[y]:=b;  
  paintbox1.repaint;
end;

//clear char
procedure Tfchrdsgn.Button6Click(Sender: TObject);
Var i:Integer;
begin
 For i:=0 to rows-1 do
  carr[i]:=0;
 paintbox1.repaint;
end;

//Reverse char color
procedure Tfchrdsgn.Button4Click(Sender: TObject);
Var i:Integer;
begin
  for i:=0 to rows-1 do
   carr[i]:=carr[i] xor $ff;
  paintbox1.repaint;
end;

//Exchange this char with another
procedure Tfchrdsgn.Button5Click(Sender: TObject);
Var a:string;
    tmparr:array[0..9] of byte;
    b:byte;
    i:Integer;
begin
 if inputquery('Exchange with','Char NO:',a) then
 begin
   For i:=0 to rows-1 do
     tmparr[i]:=carr[i];  //save old
   GetChar8(strtoint(a));//get new
   SetChar8; //save new at pos ch
   For i:=0 to rows-1 do
   Begin
     b:=tmparr[i];        //exchange
     tmparr[i]:=carr[i];  //tmparr=new
     Carr[i]:=b;          //carr:=old
   End;
   b:=ch;
   ch:=strtoint(a);
   SetChar8; //save old at pos ch
   ch:=b;
   For i:=0 to rows-1 do
     carr[i]:=tmparr[i];  //get new back

   paintbox1.repaint;
 End;
end;

//Save this char at char array
procedure Tfchrdsgn.Button7Click(Sender: TObject);
begin
   SetChar8;
end;

//Copy chfrom to chto normal or reversed  from char array
procedure Tfchrdsgn.Copychar(chfrom,chto:integer;reversed:boolean);
Var i:integer;
Begin
  for i:=0 to rows-1 do
   if  reversed then
     CharArr[chto+i*256]:=CharArr[chfrom+i*256] xor $ff
   else
    CharArr[chto+i*256]:=CharArr[chfrom+i*256];
End;


//Copy chfrom to chto normal or reversed  from ROM  to char array
procedure Tfchrdsgn.CopyROMchar(chfrom,chto:integer;reversed:boolean);
Var i:integer;
Begin
  for i:=0 to rows-1 do
   if  reversed then
     CharArr[chto+i*256]:=nbmem.ROM[47104+chfrom+i*256] xor $ff
   else
    CharArr[chto+i*256]:=nbmem.ROM[47104+chfrom+i*256];
End;

//transfer chars from 225 to 250 from rom to char array
procedure Tfchrdsgn.Button8Click(Sender: TObject);
Var i:integer;
begin
 // For i:=160 to 223 do
//   Copychar(i-128,i,true);
  for i:=225 to 250 do
    CopyROMchar(i-128,i,false);
end;

//move 1 row up
procedure Tfchrdsgn.Button9Click(Sender: TObject);
Var i:Integer;
begin
 For i:=1 to rows-1 do
  Carr[i-1]:=carr[i];
 Carr[rows-1]:=0;
end;

//move 1 row down
procedure Tfchrdsgn.Button10Click(Sender: TObject);
Var i:Integer;
begin
 For i:=rows-2 downto 0 do
  Carr[i+1]:=carr[i];
  Carr[0]:=0; 
end;

//if we have a 8x10 char
function Tfchrdsgn.isTen: Boolean;
begin
  Result := cbten.checked;
end;

//how many rows we have 10 or 8
function Tfchrdsgn.Rows: Integer;
begin
  if isten then
   result:=10
  else
   Result:=8;
end;

end.
