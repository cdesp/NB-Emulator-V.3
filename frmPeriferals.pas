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
unit frmPeriferals;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Buttons,uNBTypes;

type
  TfrmPerif = class(TForm)
    GB_DP: TGroupBox;
    CB_DP: TCheckBox;
    DPGRID: TStringGrid;
    GroupBox1: TGroupBox;
    CB_MP: TCheckBox;
    MPGrid: TStringGrid;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    OpenDialog1: TOpenDialog;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    SAVE: TButton;
    procedure Button3Click(Sender: TObject);
    procedure CB_DPClick(Sender: TObject);
    procedure CB_MPClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OpenDialog1FolderChange(Sender: TObject);
    procedure SAVEClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    procedure Init;
    procedure LoadIni;
    procedure SaveIni;
    procedure AddLine(grd: TStringGrid; var Lno: Integer; Slot, Page: integer;
      Rom: String);
    procedure FillTitle(Grd: TStringGrid);
    procedure FILL(grd: TStringGrid);
    { Private declarations }
  public
    procedure GetRom(Perif: TPerif; SlotNo: Integer; var PageNo: integer; var
        RomName: String);
    { Public declarations }
  end;

var
  frmPerif: TfrmPerif;

implementation


{$R *.dfm}

procedure TfrmPerif.SaveIni;
Var Sl:Tstringlist;
    fn:String;
    i:Integer;
Begin
  fn:=apppath+'\Peripherals.ini';
  Sl:=Tstringlist.create;
  try
   sl.add('[DATAPACK]');
   for i := 1 to dpgrid.RowCount-1 do
     sl.Add(dpgrid.Cells[2,i]);
   sl.add('[MICROPAGE]');
   for i := 1 to mpgrid.RowCount-1 do
     sl.Add(mpgrid.Cells[2,i]);

   sl.SaveToFile(fn);  
  finally
     sl.free;
  end;
end;

procedure TfrmPerif.LoadIni;
Var Sl:Tstringlist;
    fn:String;
    i,j:Integer;
    s:String;
    grd:tStringGrid;

    Function NExtLine:Boolean;
    Begin
     Result:=false;
     if j>=sl.count then exit;

     s:=sl[j];
     Inc(j);
     Result:=true;
    End;
Begin
  fn:=apppath+'\Peripherals.ini';
  if not fileexists(fn) then exit;

  Sl:=Tstringlist.create;
  try
   sl.LoadFromFile(fn);
   j:=0;
   repeat
     If not NextLine then break;
     grd:=nil;
     if sametext(s,'[DataPack]') then
      grd:=DPGrid;
     if sametext(s,'[MicroPage]') then
      grd:=MPGrid;

     if not assigned(grd) then break;
     
     for i := 1 to grd.RowCount-1 do
     Begin
       If not NextLine then break;
       grd.Cells[2,i]:=s;
     end;
   until j>=sl.count;
  finally
     sl.free;
  end;
end;


procedure TfrmPerif.Init;
Begin
  FILL(DPGRID);
  FILL(MPGRID);
end;

procedure TfrmPerif.FormCreate(Sender: TObject);
begin
  Init;
  loadini;
end;

procedure TfrmPerif.FillTitle(Grd:TStringGrid);
BEgin
 grd.Cells[0,0]:='SLOT';
 grd.Cells[1,0]:='PAGE';
 grd.Cells[2,0]:='ROM/RAM';
end;

procedure TfrmPerif.AddLine(grd:TStringGrid;Var Lno:Integer;Slot,Page:integer;Rom:String);
Begin
 grd.Cells[0,lno]:=inttostr(Slot);
 grd.Cells[1,lno]:=inttostr(Page);
 grd.Cells[2,lno]:=Rom;
 Inc(lno);
end;

procedure TfrmPerif.Button3Click(Sender: TObject);
begin
  if FileExists(apppath+'Peripherals.ini') then
   deletefile(apppath+'Peripherals.ini');
  Init;
end;

procedure TfrmPerif.CB_DPClick(Sender: TObject);
begin
  if CB_DP.Checked then
    SetPeripheral(DataPack)
  Else
    SetPeripheral(PNone);
  CB_MP.Checked:=false;
end;

procedure TfrmPerif.CB_MPClick(Sender: TObject);
begin
  if CB_MP.Checked then
    SetPeripheral(MicroPage)
  Else
    SetPeripheral(PNone);
  CB_DP.Checked:=false;
end;

procedure TfrmPerif.FILL(grd:TStringGrid);
Var Lno:Integer;
Begin
   FillTitle(grd);
   Lno:=1;

   If grd=DPGrid then
       Begin
         ADDLine(grd,Lno,0,118,'\DataPack\DP3#3101.rom');
         ADDLine(grd,Lno,1,116,'\DataPack\DIRIIDP.ROM');
         ADDLine(grd,Lno,2,114,'\DataPack\CHESS2DP.ROM');
         ADDLine(grd,Lno,3,112,'RAM');
       end
   Else
   If grd=MPGrid then
       Begin
         ADDLine(grd,Lno,0,118,'\MicroPage\DEVPAC3.ROM');
         ADDLine(grd,Lno,1,116,'\MicroPage\TYPIST.ROM');
         ADDLine(grd,Lno,2,114,'\MicroPage\MICROTER.ROM');
         ADDLine(grd,Lno,3,112,'RAM');
       end;
end;

procedure TfrmPerif.FormShow(Sender: TObject);
begin
 loadini;
end;

procedure TfrmPerif.SAVEClick(Sender: TObject);
begin
  SaveIni;
end;

procedure TfrmPerif.SpeedButton1Click(Sender: TObject);
Var l:integer;
    grd:tStringgrid;
    s:String;
begin
 if Sender=SpeedButton2 then
   grd:= DPGrid;
 if Sender=SpeedButton4 then
   grd:= MPGrid;
 l:=grd.Row;
 grd.Cells[2,l]:='RAM';
end;

procedure TfrmPerif.SpeedButton2Click(Sender: TObject);
Var l:integer;
    grd:tStringgrid;
    s:String;
begin
 if Sender=SpeedButton2 then
 Begin
   s:='DataPack';
   grd:= DPGrid;
 end;
 if Sender=SpeedButton4 then
 Begin
   s:='MicroPage';
   grd:= MPGrid;
 end;
 OpenDialog1.InitialDir:=apppath+'roms\'+s;
 If OpenDialog1.execute then
 Begin
   l:=grd.Row;
   grd.Cells[2,l]:='\'+s+'\'+extractfilename(OpenDialog1.FileName);
 end;
end;

Procedure  TfrmPerif.GetRom(Perif:TPerif;SlotNo:Integer;var PageNo:integer;var RomName:String);
Var grd:TStringGrid;
Begin
  case perif of
    MicroPage:grd:=MPGrid ;
    DataPack:grd:=DPGrid ;
    PIBOX: grd:=nil ;
  end;
  Pageno:=Strtoint(grd.Cells[1,SlotNo+1]);
  RomName:=grd.Cells[2,SlotNo+1];
end;

procedure TfrmPerif.OpenDialog1FolderChange(Sender: TObject);
begin
   Showmessage('DO NOT CHANGE DIRECTORY !!!!');
end;


end.
