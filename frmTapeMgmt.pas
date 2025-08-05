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
Var
  sl: TStringList;
begin
  sl := TStringList(getfiles('\basic\*.*', true));
  ListBox1.Items.Assign(sl);
  sl.free;
end;

procedure TfTapeMgmt.GetDirFiles;
Var
  sl: TStringList;
  s: String;
  i: Integer;
begin
  if ListBox1.itemindex = -1 then
    exit;

  s := ListBox1.Items[ListBox1.itemindex];
  sl := TStringList(getfiles('\basic\' + s + '\*.*', False));
  GetTapeFiles;
  ListBox3.Items.Clear;
  For i := 0 to sl.count - 1 do
  Begin
    if TpFiles.IndexOf(sl[i]) = -1 then
      ListBox3.Items.add(sl[i]);
  End;
  // listbox3.Items.Assign(sl);
  sl.free;
end;

procedure TfTapeMgmt.GetTapeFiles;
Var
  s, pth: String;
Begin
  pth := ExtractFilepath(application.exename);
  if ListBox1.itemindex = -1 then
    exit;
  s := ListBox1.Items[ListBox1.itemindex];
  if fileexists(pth + '\basic\' + s + '\_dir.txt') then
    TpFiles.loadfromfile(pth + '\basic\' + s + '\_dir.txt')
  Else
    TpFiles.Clear;
  ListBox2.Items.Assign(TpFiles);
End;

procedure TfTapeMgmt.FormShow(Sender: TObject);
begin
  TpFiles := TStringList.create;
  GetTapes;
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
  if ListBox3.itemindex = -1 then
    exit;
  ListBox2.Items.add(ListBox3.Items[ListBox3.itemindex]);
  ListBox3.Items.Delete(ListBox3.itemindex);
  TpFiles.Assign(ListBox2.Items);
end;

procedure TfTapeMgmt.Button7Click(Sender: TObject);
begin
  if ListBox2.itemindex = -1 then
    exit;
  ListBox3.Items.add(ListBox2.Items[ListBox2.itemindex]);
  ListBox2.Items.Delete(ListBox2.itemindex);
  TpFiles.Assign(ListBox2.Items);
end;

procedure TfTapeMgmt.Button3Click(Sender: TObject);
begin
  if ListBox2.itemindex = -1 then
    exit;
  if ListBox2.itemindex < 1 then
    exit;
  ListBox2.Items.Exchange(ListBox2.itemindex, ListBox2.itemindex - 1);
  TpFiles.Assign(ListBox2.Items);
end;

procedure TfTapeMgmt.Button4Click(Sender: TObject);
begin
  if ListBox2.itemindex = -1 then
    exit;
  if ListBox2.itemindex > ListBox2.Items.count - 2 then
    exit;
  ListBox2.Items.Exchange(ListBox2.itemindex, ListBox2.itemindex + 1);
  TpFiles.Assign(ListBox2.Items);
end;

procedure TfTapeMgmt.Button5Click(Sender: TObject);
Var
  s, pth: String;
Begin
  pth := ExtractFilepath(application.exename);
  if ListBox1.itemindex = -1 then
    exit;
  s := ListBox1.Items[ListBox1.itemindex];
  TpFiles.SaveToFile(pth + '\basic\' + s + '\_dir.txt');
end;

procedure TfTapeMgmt.Button8Click(Sender: TObject);
Var
  i: Integer;
begin
  For i := ListBox3.Items.count - 1 downto 0 do
  Begin
    ListBox2.Items.add(ListBox3.Items[i]);
    ListBox3.Items.Delete(i);
  End;
  TpFiles.Assign(ListBox2.Items);

end;

procedure TfTapeMgmt.Button9Click(Sender: TObject);
Var
  i: Integer;
begin
  For i := ListBox2.Items.count - 1 downto 0 do
  Begin
    ListBox3.Items.add(ListBox2.Items[i]);
    ListBox2.Items.Delete(i);
  End;
  TpFiles.Assign(ListBox2.Items);
end;

procedure TfTapeMgmt.Button10Click(Sender: TObject);
begin
  if width > 800 then
    width := fnewbrain.ScrNormalize(257)
  else
    width := fnewbrain.ScrNormalize(810);
end;

procedure TfTapeMgmt.Button1Click(Sender: TObject);
begin
  if ListBox1.itemindex = -1 then
    Selected := ''
  else
    Selected := ListBox1.Items[ListBox1.itemindex];
end;

procedure TfTapeMgmt.ListBox1DblClick(Sender: TObject);
begin
  if ListBox1.itemindex <> -1 then
  Begin
    Button1Click(nil);
    Modalresult := Mrok;
  End;
end;

end.
