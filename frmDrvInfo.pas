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


unit frmDrvInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TfDrvInfo = class(TForm)
    ListBox1: TListBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
  private
    { Private declarations }
    curinfo:integer;
  public
    { Public declarations }
    procedure FillInfo(DrvNo:Integer);
    procedure DoResize1;
  end;

var
  fDrvInfo: TfDrvInfo;

implementation
uses uNBCPM, New,unbkeyboard2;

{$R *.DFM}

procedure TfDrvInfo.FillInfo(DrvNo:Integer);
begin
 if drvno<0 then
     drvno:=curinfo;
 case DrvNo of
  0: Begin
       listbox1.Items.assign(NBDISCCtrl.DirListA);
       listbox1.Font.Color:=clGreen;
     End;
  1: Begin
       listbox1.Items.assign(NBDISCCtrl.DirListB);
       listbox1.Font.color:=clRed;
     End;
 End;
 curinfo:=drvno;
end;

procedure TfDrvInfo.SpeedButton1Click(Sender: TObject);
begin
 FillInfo(0);
end;

procedure TfDrvInfo.SpeedButton2Click(Sender: TObject);
begin
 FillInfo(1);
end;

procedure TfDrvInfo.FormShow(Sender: TObject);
begin
 fDrvInfo.FillInfo(0);
 DoResize1;
 SpeedButton1.Font.Color:=clGreen;
 SpeedButton2.Font.Color:=clRed;
end;

procedure TfDrvInfo.DoResize1;
begin
 left:=fNewBrain.left+fNewBrain.width+3;
 top:=fNewBrain.top;
 height:=fnewbrain.height;
end;

//Auto Load the program
procedure TfDrvInfo.ListBox1DblClick(Sender: TObject);
Var s:String;
begin
   if listbox1.itemindex=-1 then exit;
   s:=Listbox1.items[listbox1.itemindex];
   if speedbutton1.Down then
     nbkeyboard.import('LOAD "'+s+'"'#10#13)
   else
   Begin
     nbkeyboard.import('LOAD "B:'+s+'"'#10#13);
   End;
   fnewbrain.SetFocus;
end;

end.


