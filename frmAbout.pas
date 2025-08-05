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

unit frmAbout;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfAbout = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Label8Click(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  fAbout: TfAbout;

implementation
uses shellapi,new;

{$R *.DFM}

procedure TfAbout.FormCreate(Sender: TObject);
begin
 Label9.Caption:= fNewBrain.cVers;
end;

procedure TfAbout.Label8Click(Sender: TObject);
begin
 Shellexecute(Handle,'open',Pchar(TLabeL(Sender).caption),nil,nil,SW_SHOW);
end;

end.
