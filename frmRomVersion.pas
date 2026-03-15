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
unit frmRomVersion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfRomVersion = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ListBox1: TListBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure getRomVersion(var v, sv: integer);
    Function mjVersion:Integer;
    Function mnVersion:Integer;
  end;

var
  fRomVersion: TfRomVersion;

implementation
uses inifiles;

{$R *.dfm}


{ TfRomVersion }

procedure TfRomVersion.FormClose(Sender: TObject; var Action: TCloseAction);
Var Inif:TIniFile;
    pth:String;
begin
  pth:=ExtractFilePath(Application.Exename);

  Inif:=TIniFile.create(pth+'Config.Ini');
  Inif.WriteInteger('ROM','Version',ListBox1.ItemIndex);
  inif.Free
end;

procedure TfRomVersion.getRomVersion(var v:integer;var sv:integer);
Begin
  FormShow(nil);
  if listbox1.itemindex<>-1 then
  Begin
   v:=mjVersion;
   sv:=mnVersion;
  End;
End;

procedure TfRomVersion.FormShow(Sender: TObject);
Var Inif:TIniFile;
    pth:String;
begin
  pth:=ExtractFilePath(Application.Exename);
  Inif:=TIniFile.create(pth+'Config.Ini');
  try
    ListBox1.ItemIndex:=Inif.ReadInteger('ROM','Version',-1);
  except
  end;
  inif.Free
end;

function TfRomVersion.mjVersion: Integer;
Var k:Integer;
begin
  k:=ListBox1.ItemIndex+1;
  case k of
     1:Result:=1;
     2:Result:=1;
     3:Result:=1;
     4:Result:=2;
     5:Result:=2;
     6:Result:=2;
  end;
end;

function TfRomVersion.mnVersion: Integer;
Var k:Integer;
begin
 k:=ListBox1.ItemIndex+1;
  case k of
     1:Result:=40;
     2:Result:=90;
     3:Result:=91;
     4:Result:=00;
     5:Result:=01;
     6:Result:=02;
  end;
end;

end.
