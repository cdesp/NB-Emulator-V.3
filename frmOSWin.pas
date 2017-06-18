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
unit frmOSWin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfOSWin = class(TForm)
    GroupBox1: TGroupBox;
    LAF: TLabel;
    LBC: TLabel;
    LDE: TLabel;
    LHL: TLabel;
    EDcopctl: TEdit;
    EDCopST: TEdit;
    EdEnReg1: TEdit;
    EDCopBf: TEdit;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    EdEL: TEdit;
    EdLL: TEdit;
    EdLN: TEdit;
    EdDEP: TEdit;
    Label5: TLabel;
    EdTVCUR: TEdit;
    Label6: TLabel;
    EdTVRAM: TEdit;
    Label7: TLabel;
    EdTVMODE: TEdit;
    Label8: TLabel;
    EdCHRROM: TEdit;
    GroupBox3: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    EdENREG2: TEdit;
    EdCLCK: TEdit;
    EdFICLK: TEdit;
    EdDISCB: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    EdTV4: TEdit;
    EdTV2: TEdit;
    EdTV1: TEdit;
    EdTV0: TEdit;
    Label17: TLabel;
    EdSTR11: TEdit;
    Timer1: TTimer;
    Label20: TLabel;
    EDVTop: TEdit;
    Label18: TLabel;
    EdVBAse: TEdit;
    Label19: TLabel;
    EdAVtop: TEdit;
    procedure Timer1Timer(Sender: TObject);
  private
    procedure ShowCOP;
    procedure ShowSCREEN;
    procedure ShowVarious;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fOSWin: TfOSWin;

implementation
uses uNBTypes,uNBMemory,uNBScreen;

{$R *.dfm}

Procedure TfOSWin.ShowCOP;
Begin
  EDCopCtl.Text:=getbinaryfrombyte(nbmem.ROM[$3b]);
  EDCopST.Text :=getbinaryfrombyte(nbmem.ROM[$3c]);
  EdEnReg1.Text:=getbinaryfrombyte(nbmem.ROM[$24]);
  EDCopBf.Text :=inttohex(nbmem.ROM[$3D],2);;
end;

Procedure TfOSWin.ShowSCREEN;
Var s:String;
Begin
  EdEL.Text:= inttohex(nbscreen.EL,4);
  EdLL.Text:= inttohex(nbscreen.LL,4);
  EdLN.Text:= inttohex(nbscreen.LN,4);
  EdDEP.Text:= inttohex(nbscreen.DEP,4);
  s:=inttohex(nbmem.ROM[$5b],2)+inttohex(nbmem.ROM[$5a],2);
  EdTVCUR.Text:= s;
  s:=inttohex(nbmem.ROM[$5d],2)+inttohex(nbmem.ROM[$5c],2);
  EdTVRAM.Text:=s;
  EdTVMODE.Text:=inttostr(nbScreen.TVMode);
  s:=inttohex(nbmem.ROM[120],2)+inttohex(nbmem.ROM[119],2);
  EdCHRROM.Text:=s;

  EdTV0.Text:=inttostr(nbmem.rom[13]);
  EdTV1.Text:=inttostr(nbmem.rom[15]);
  EdTV2.Text:=getbinaryfrombyte(nbmem.rom[14]);
  EdTV4.Text:=inttostr(nbScreen.TV4);
  EdSTR11.Text:=inttostr(nbmem.rom[$76]);

  EdVtop.Text:= inttostr(nbScreen.Videotop.w);
  EDVBase.Text:=inttostr(nbScreen.VideoBase.w);
  EdAVtop.Text:= inttostr(nbScreen.AVideotop.w);
end;

Procedure TfOSWin.ShowVarious;
var s:String;
Begin
 EdENREG2.Text:=getbinaryfrombyte(nbmem.ROM[$B6]);
 s:=inttohex(nbmem.ROM[85],2)+inttohex(nbmem.ROM[84],2)
       +inttohex(nbmem.ROM[83],2)+inttohex(nbmem.ROM[82],2);
 EdCLCK.Text:=s;
 s:=inttohex(nbmem.ROM[107],2)+inttohex(nbmem.ROM[106],2)
       +inttohex(nbmem.ROM[105],2);
 EdFICLK.Text:=s;

 EdDISCB.Text:=inttostr(nbmem.rom[$7a]*256+nbmem.rom[$79]);
end;

procedure TfOSWin.Timer1Timer(Sender: TObject);
begin
  ShowCOP;
  ShowSCREEN;
  ShowVarious;
end;

end.
