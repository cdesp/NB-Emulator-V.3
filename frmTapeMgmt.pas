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
unit frmTapeMgmt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CheckLst, ExtCtrls;

type
  TfTapeMgmt = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    ListBox1: TListBox;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    ListBox2: TListBox;
    Label2: TLabel;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    ListBox3: TListBox;
    Label3: TLabel;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Label4: TLabel;
    procedure FormShow(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
  private
TpFiles: TStringList;
    procedure GetDirFiles;
    procedure GetTapeFiles;
    { Private declarations }
  public
    Selected: string;
    procedure GetTapes;
    { Public declarations }
  end;

var
  fTapeMgmt: TfTapeMgmt;
{$R *.DFM}
implementation
uses new;

procedure TfTapeMgmt.GetTapes;
Var sl:TStringlist;
begin
  sl:=TStringlist(getfiles('\basic\*.*',true));
  listbox1.Items.Assign(sl);
  sl.free;
end;

procedure TfTapeMgmt.GetDirFiles;
Var sl:TStringlist;
    s:String;
    i:Integer;
begin
  if listbox1.itemindex=-1 then exit;

  s:=listbox1.items[listbox1.itemindex];
  sl:=TStringlist(getfiles('\basic\'+s+'\*.*',False));
  GetTapeFiles;
  listbox3.items.Clear;
  For i:=0 to sl.count-1 do
  Begin
    if tpfiles.IndexOf(sl[i])=-1 then
     listbox3.items.add(sl[i]);
  End;
//  listbox3.Items.Assign(sl);
  sl.free;
end;

procedure TfTapeMgmt.GetTapeFiles;
Var s,pth:String;
Begin
  pth:=ExtractFilepath(application.exename);
  if listbox1.itemindex=-1 then exit;
  s:=listbox1.items[listbox1.itemindex];
  if fileexists(pth+'\basic\'+s+'\_dir.txt') then
    tpfiles.loadfromfile(pth+'\basic\'+s+'\_dir.txt')
  Else
   tpfiles.clear;
  Listbox2.items.assign(tpfiles);
End;

procedure TfTapeMgmt.FormShow(Sender: TObject);
begin
  TpFiles:= TStringList.create;
  gettapes;
end;

procedure TfTapeMgmt.ListBox1Click(Sender: TObject);
begin
  GetDirFiles;
end;

procedure TfTapeMgmt.ListBox1KeyPress(Sender: TObject; var Key: Char);
begin
  GetDirFiles;
end;

procedure TfTapeMgmt.FormDestroy(Sender: TObject);
begin
  TpFiles.free;
end;

procedure TfTapeMgmt.Button6Click(Sender: TObject);
begin
  if listbox3.ItemIndex=-1 then exit;
  listbox2.Items.add(Listbox3.items[listbox3.ItemIndex]);
  Listbox3.Items.Delete(listbox3.ItemIndex);
  tpfiles.Assign(listbox2.items);
end;

procedure TfTapeMgmt.Button7Click(Sender: TObject);
begin
  if listbox2.ItemIndex=-1 then exit;
  listbox3.Items.add(Listbox2.items[listbox2.ItemIndex]);
  Listbox2.Items.Delete(listbox2.ItemIndex);
  tpfiles.Assign(listbox2.items);
end;

procedure TfTapeMgmt.Button3Click(Sender: TObject);
begin
  if listbox2.ItemIndex=-1 then exit;
  if listbox2.ItemIndex<1 then exit;
  Listbox2.Items.Exchange(listbox2.ItemIndex,listbox2.ItemIndex-1);
  tpfiles.Assign(listbox2.items);
end;

procedure TfTapeMgmt.Button4Click(Sender: TObject);
begin
  if listbox2.ItemIndex=-1 then exit;
  if listbox2.ItemIndex>Listbox2.items.count-2 then exit;
  Listbox2.Items.Exchange(listbox2.ItemIndex,listbox2.ItemIndex+1);
  tpfiles.Assign(listbox2.items);
end;

procedure TfTapeMgmt.Button5Click(Sender: TObject);
Var s,pth:String;
Begin
  pth:=ExtractFilepath(application.exename);
  if listbox1.itemindex=-1 then exit;
  s:=listbox1.items[listbox1.itemindex];
  tpfiles.SaveToFile(pth+'\basic\'+s+'\_dir.txt');
end;

procedure TfTapeMgmt.Button8Click(Sender: TObject);
Var i:Integer;
begin
 For i:=listbox3.items.count-1 downto 0 do
 Begin
  listbox2.Items.add(Listbox3.items[i]);
  Listbox3.Items.Delete(i);
 End;
 tpfiles.Assign(listbox2.items);

end;

procedure TfTapeMgmt.Button9Click(Sender: TObject);
Var i:Integer;
begin
 For i:=listbox2.items.count-1 downto 0 do
 Begin
  listbox3.Items.add(Listbox2.items[i]);
  Listbox2.Items.Delete(i);
 End;
 tpfiles.Assign(listbox2.items);
end;

procedure TfTapeMgmt.Button10Click(Sender: TObject);
begin
  if width>800 then
   width:=249
  else
   width:=807;
end;

procedure TfTapeMgmt.Button1Click(Sender: TObject);
begin
  if listbox1.ItemIndex=-1 then
   Selected:=''
  else
   Selected:=listbox1.items[listbox1.ItemIndex];
end;

procedure TfTapeMgmt.ListBox1DblClick(Sender: TObject);
begin
   if listbox1.ItemIndex<>-1 then
   Begin
    Button1Click(nil);
    Modalresult:=Mrok;
   End; 
end;

end.
