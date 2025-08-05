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


