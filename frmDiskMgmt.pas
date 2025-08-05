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

unit frmDiskMgmt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfDiskMgmt = class(TForm)
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Panel3: TPanel;
    Label1: TLabel;
    Panel4: TPanel;
    Label2: TLabel;
    lb1: TListBox;
    lb2: TListBox;
    CPMdskimage: TOpenDialog;
    Button3: TButton;
    ComboBox1: TComboBox;
    vd: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    sd: TEdit;
    procedure Label1Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure lb1DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
  private
    pth: string;
    procedure PopulateFiles;
    procedure CreateSingleSide(fn:Ansistring;getbytes,skipbytes:Integer);
    function GetInvalidDiskType: integer;
    procedure DOExtract(time:Integer=0);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fDiskMgmt: TfDiskMgmt;

implementation
uses New,uNBCPM;

{$R *.DFM}

Function TfDiskMgmt.GetInvalidDiskType:integer;
Begin
  result:=0;
  case DSKfs of
     368640:Begin
             case DiskSize of //todo:find the real size
               194560 :Result:=3; //5_25 320Kb DSDD 300 - NB200 (Filesize=360KB)
               399360 :Result:=0;
             end;
            End;
     389120:Result:=2;//5_25 360Kb DSDD 300 - NB200 (Filesize=380KB)
  end;
End;

procedure TfDiskMgmt.ComboBox1Select(Sender: TObject);
Var strip:Integer;
begin
    strip:=Combobox1.ItemIndex;
    case strip of
      0:Begin vd.Text:=inttostr(0);sd.Text:=inttostr(0); end;
      1:Begin vd.Text:=inttostr($1400);sd.Text:=inttostr($1400); end;
      2:Begin vd.Text:=inttostr($1400);sd.Text:=inttostr($1200); end;
      3:Begin vd.Text:=inttostr($1400);sd.Text:=inttostr($1000); end;
      4:Begin vd.Text:=inttostr($1400);sd.Text:=inttostr($1000); end;
    end;
end;

procedure TfDiskMgmt.CreateSingleSide(fn:Ansistring;getbytes,skipbytes:Integer); //$1400 for 80 $fff for 40
  Var f:File OF Byte;
      p,p2:Array[0..819200] of byte;
      k,k2:integer;
      Oldname,Newname:string;
Begin
  AssignFile(f,fn);
  ReSet(f);
  DSKfs:=filesize(f);
  BlockRead(f,p,DSKfs);
  CloseFile(f);
  k:=0;k2:=0;
  repeat
     Copymemory(@p2[k2],@p[k],getbytes);
     k:=k+getbytes+skipbytes;
     k2:=k2+getbytes;
  until k>DSKfs;
  AssignFile(f,fn);
  Rewrite(f);
  BlockWrite(f,p2,k2);
  CloseFile(f);
End;

procedure TfDiskMgmt.DOExtract(time:Integer=0);
Begin
    if vd.Text<>'0' then
    Begin
     try
      CreateSingleSide(CPMdskimage.FileName,strtoint(vd.Text),strtoint(sd.Text));
     except
       exit;
     end;
    End;
    try
      NBDISCCtrl.DiskExtract(ChangeFileExt(extractfilename(CPMdskimage.FileName),''));
     try
      deletefile(CPMdskimage.FileName);
     except

     end;
    PopulateFiles;
    except
      NBDISCCtrl.ForceDir1('');
      deletefile(Changefileext(CPMdskimage.FileName,'.dsk'));
      combobox1.ItemIndex:=GetInvalidDiskType;
      ComboBox1Select(nil);
      if Combobox1.ItemIndex>0 then
      Begin
        if time=0 then
        Begin
          DOExtract(1);
          ShowMessage('Automatic Stripping was Succesfull!!!');
          combobox1.ItemIndex:=0;
          ComboBox1Select(nil);
        End
        Else
         Showmessage('Automatic stripping Failed!!!'#13'Please change strip params manually and try again.');
      End
       else
         Showmessage('Cannot auto strip image!!!'#13'You can try to strip it manually.');
    end;
End;

procedure TfDiskMgmt.Button3Click(Sender: TObject);
begin
  CPMdskimage.InitialDir:=extractfilepath(application.ExeName)+'discs\';
  if CPMdskimage.Execute then
  Begin
   DoExtract;
  End;
end;

procedure TfDiskMgmt.FormCreate(Sender: TObject);
begin
  CPMdskimage.Title:='Select CPM Disk Image';
  PopulateFiles ;
End;

procedure TfDiskMgmt.FormShow(Sender: TObject);
begin
  PopulateFiles;
end;

procedure TfDiskMgmt.Label1Click(Sender: TObject);
begin
  lb1.itemindex:=-1;
end;

procedure TfDiskMgmt.Label2Click(Sender: TObject);
begin
  lb2.itemindex:=-1;
end;

procedure TfDiskMgmt.lb1DblClick(Sender: TObject);
begin
   button1.Click;
end;

procedure TfDiskMgmt.PopulateFiles;
Var sl:TStringList;
begin
   sl:=Tstringlist(new.GetFiles('\Discs\*.*',True));
  try
   lb1.items.assign(sl);
   lb2.items.assign(sl);
  Finally
    sl.free;
  End;
 pth:=ExtractFilePath(Application.Exename)+'Discs\';
 if assigned(NBDiscCtrl) then
 Begin
   lb1.ItemIndex:=lb1.Items.IndexOf(NBDiscCtrl.Dir1);
   lb2.ItemIndex:=lb2.Items.IndexOf(NBDiscCtrl.Dir2);
 End;
End;

end.
