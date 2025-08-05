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
unit frmInstructions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TfInstructions = class(TForm)
    RichEdit1: TRichEdit;
    Panel1: TPanel;
    Hide: TButton;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure HideClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fInstructions: TfInstructions;

implementation

uses New;

{$R *.dfm}

procedure TfInstructions.FormCreate(Sender: TObject);
Var fIstr:TFilename;
begin
  fistr:=ExtractFilepath(Application.ExeName)+'QInst.rtf';
  if Fileexists(fistr) then
    RichEdit1.Lines.LoadFromFile(fistr);
end;

procedure TfInstructions.Button1Click(Sender: TObject);
begin
  ShowMessage('You can always show this window again from the `Options` menu');
  fNewBrain.ShowInstructions1.checked:=false;
  Close;
end;

procedure TfInstructions.HideClick(Sender: TObject);
begin
  Close;
end;

Initialization
fInstructions:=nil;

end.
