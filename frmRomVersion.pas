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
