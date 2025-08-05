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
unit uNBCassette;

interface

uses uNBTapes, classes;

Type

  TCassetteState = (csIdle, csLoading, csSaving);

  TNBCassette = class
    constructor Create;
    destructor Destroy; override;
  private
    FFilename: string;
    cf: File of byte;
    state: TCassetteState;
    comcnt: Integer;
    size: Integer;
    Commopened: Boolean;
    FTapeNo: Integer;
    function getLoading: Boolean;
    function getSaving: Boolean;
    function CheckFileEnd: Boolean;
    function CurrentExt: string;
    function CheckReadEOF: Boolean;
    function getFileName: String;
    function FindFileName: string;
    procedure NBRenameFile(Fname: string);
    procedure setLoading(const Value: Boolean);
    procedure setSaving(const Value: Boolean);
    procedure DeleteNoName;
    procedure SetFilename(Value: String);
    procedure setTapeNo(const Value: Integer);
    procedure UpdateVi;
  public
    CassError: Boolean;
    ResetTape: Boolean;
    FileIsBinary: Boolean;
    TapeInfo: TTapeInfo;
    wrcnt: Integer;
    function Root: string;
    procedure DoResetTape;
    procedure OpenCassette(ToRead: Boolean = false);
    procedure CloseComm;
    function ReadComm: byte;
    procedure Writecomm(b: byte);
    property loading: Boolean read getLoading write setLoading;
    property saving: Boolean read getSaving write setSaving;
    property Filename: String read FFilename write SetFilename;
    property TapeNo: Integer read FTapeNo write setTapeNo;
  end;

implementation

uses sysutils, forms, new, uNbTypes, uNBIO;

{ TNBCassette }

constructor TNBCassette.Create;
begin
  TapeInfo := TTapeInfo.Create;
  Filename := 'NoName';
  DeleteNoName;
  state := csIdle;
  ResetTape := false;
  TapeNo := 0;
end;

destructor TNBCassette.Destroy;
begin
  TapeInfo.free;
  inherited;
end;

function TNBCassette.getLoading: Boolean;
begin
  result := state = csLoading;
end;

function TNBCassette.getSaving: Boolean;
begin
  result := state = csSaving;
end;

function TNBCassette.Root: string;
begin
  if TapeInfo.TapeLoaded then
    result := TapeInfo.Directory
  Else
    result := Extractfilepath(application.exename) + 'Basic\';
end;

procedure TNBCassette.setLoading(const Value: Boolean);
begin
  if Value then
    state := csLoading
  else
    state := csIdle;
end;

procedure TNBCassette.setSaving(const Value: Boolean);
begin
  if Value then
    state := csSaving
  else
    state := csIdle;
end;

procedure TNBCassette.setTapeNo(const Value: Integer);
begin
  FTapeNo := Value;
  TapeInfo.TapeNo := Value;
end;

function TNBCassette.CurrentExt: string;
begin
  if FileIsBinary then
    result := '.bin'
  else
    result := '.bas';
end;

function TNBCassette.FindFileName: string;
Var
  Fname: String;
  f: String;
  i: Integer;
Begin
  for i := 1 to 10000 do
  Begin
    f := 'UnKnown' + inttostr(i);
    Fname := Root + f + CurrentExt;
    if not fileexists(Fname) then
      break;
  End;
  fnewbrain.WriteP2('Saved as ' + f + CurrentExt);
  result := f;
End;

Function TNBCassette.getFileName: String;
Var
  ln: tpair;
  s: String;
  i: Integer;
  Fname: string;
  r: byte;
Begin

  if pos('.', Filename) = 0 then
  Begin
    Fname := Root + Filename + CurrentExt
  End
  Else
    Fname := Root + Filename;

  assignfile(cf, Fname);
  reset(cf);
  seek(cf, 1);
  ln.l := ReadComm;
  ln.h := ReadComm;
  s := '';
  if ln.w > 0 then
  Begin
    for i := 1 to ln.w do
    begin
      read(cf, r);
      s := s + char(r); // char(ReadComm); //was ReadComm
    end;
  End;
  if s = '' then
  Begin
    if sametext(Filename, 'noname') then
      s := FindFileName
    else
      s := Filename;
  end;
  i := pos(':', s);
  if i > 0 then
    s := copy(s, i + 1, maxint);
  closefile(cf);
  result := s;
End;

procedure TNBCassette.UpdateVi;
begin
  if TapeNo = 1 then
    fnewbrain.lblTape1Info.Caption := Filename + CurrentExt
  else
    fnewbrain.lblTape2Info.Caption := Filename + CurrentExt;
end;

procedure TNBCassette.SetFilename(Value: String);
Var
  k: Integer;
begin
  k := pos('.bin', Lowercase(Value));
  if k > 0 then
  Begin
    FileIsBinary := true;
    Value := copy(Value, 1, k - 1);
  End;
  k := pos('.bas', Lowercase(Value));
  if k > 0 then
  Begin
    FileIsBinary := false;
    Value := copy(Value, 1, k - 1);
  End;

  if FFilename <> Value then
  begin
    FFilename := Value;
    UpdateVi;
  end;
end;

procedure TNBCassette.NBRenameFile(Fname: string);
begin
  if fileexists(Root + Fname + CurrentExt) then
  Begin
    renameFile(Root + Fname + CurrentExt, Root + Fname + '.bak');
    fnewbrain.WriteP2(Fname + ' was replaced');
  End;

  renameFile(Root + Filename + CurrentExt, Root + Fname + CurrentExt);
  Filename := Root + Fname + CurrentExt;
end;

Procedure TNBCassette.DeleteNoName;
Begin
  if fileexists(Root + 'Noname.bas') then
    deletefile(Root + 'Noname.bas');
  if fileexists(Root + 'Noname.bin') then
    deletefile(Root + 'Noname.bin');

End;

procedure TNBCassette.OpenCassette(ToRead: Boolean = false);
var
  Fname: String;
Begin
  if Commopened then
    exit;
  if not ToRead then
    Filename := 'Noname';

  if ToRead and TapeInfo.TapeLoaded then
  Begin
    Fname := TapeInfo.getFileName;
  End
  Else
    Fname := Root + Filename + CurrentExt;

  if ToRead and not fileexists(Fname) then
  Begin
    Filename := 'NotFound';
    Fname := Root + 'NotFound' + CurrentExt;
    ResetTape := true;
  End;

  Commopened := true;
  assignfile(cf, Fname);
  if ToRead then
  Begin
    reset(cf);
    size := FileSize(cf);
  End
  else
  begin
    if fileexists(Fname) then
    Begin
      filemode := 2;
      reset(cf);
      size := FileSize(cf);
      seek(cf, size);
    End
    else
    begin
      Rewrite(cf);
      wrcnt := 0;
    end;
  end;
End;

procedure TNBCassette.CloseComm;
Var
  s: String;
Begin
  if Commopened then
  Begin
    closefile(cf);
    if saving then
    Begin
      if CheckFileEnd then
      Begin
        s := getFileName;
        if not sametext(Filename, s) then
          NBRenameFile(s);
        if TapeInfo.TapeLoaded then
        Begin
          TapeInfo.AddFile(Filename + CurrentExt);
          TapeInfo.Lastfile;
        End;
        Filename := 'NoName';
        saving := false;
      End;
    End;
  End;
  if TapeInfo.TapeLoaded and not saving then
  Begin
    TapeInfo.NextFile;
    Filename := TapeInfo.GetNextFileName;
  End;

  Commopened := false;
  NBIO.CopInt := false;
End;

procedure TNBCassette.DoResetTape;
Begin
  try
    CassError := false;
    CloseComm;
    comcnt := 0;
    size := 0;
    loading := false;
    saving := false;
    try
      closefile(cf);
    except

    end;
  except
    CassError := true;
    Commopened := false;
  end;
  ResetTape := false;
End;

function TNBCassette.CheckReadEOF: Boolean;
Begin
  result := false;
  if size = comcnt then
  Begin
    if size > 0 then
      CloseComm;
    comcnt := 0;
    size := 0;
    loading := false;
    result := true;
    if not TapeInfo.TapeLoaded then
      Filename := 'Noname';
  End;
End;

function TNBCassette.ReadComm: byte;
Var
  f: Boolean;
Begin
  try

    f := eof(cf);
  Except
    f := true;
    ResetTape := true;
  End;

  if not f then
  Begin
    read(cf, result);
    inc(comcnt);
    fnewbrain.WriteP2(inttostr(comcnt));
    CheckReadEOF;
  End
  else
  Begin
    comcnt := 0;
    size := 0;
    Filename := 'Noname';
    loading := false;
  End;
End;

procedure TNBCassette.Writecomm(b: byte);
Begin
  inc(wrcnt);
  Write(cf, b);
  fnewbrain.WriteP2(inttostr(wrcnt));
End;

function TNBCassette.CheckFileEnd: Boolean;
Var
  Fname: String;
  sz: Integer;
  b: byte;
Begin
  result := false;
  if saving then
  Begin
    Fname := Root + Filename + CurrentExt;
    assignfile(cf, Fname);
    reset(cf);
    sz := FileSize(cf);
    seek(cf, sz - 12);
    b := ReadComm;
    closefile(cf);
    if b and 64 = 64 then // bit 6 set =last block written
      result := true;
  End;
End;

end.
