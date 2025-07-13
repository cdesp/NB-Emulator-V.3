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

unit uNBTapes;

interface

uses classes;

Type
  TTapeInfo = Class
  private
    FCurrentFile: Integer;
    FDirectory: String;
    FTapeName: String;
    procedure UpdateVI;
    procedure SetDirectory(const Value: String);
    procedure setCurrentFile(const Value: Integer);
    procedure setTapeName(const Value: String);
  public
    Files: Tstringlist;
    TapeNo: Integer;
    Constructor Create;
    Destructor Destroy; Override;
    Function GetFileName: string;
    Procedure NextFile;
    Procedure PrevFile;
    Procedure FirstFile;
    Procedure Lastfile;
    procedure LoadTape(Tpnm: String);
    function TapeLoaded: Boolean;
    procedure Eject;
    function GetNextFileName: string;
    procedure AddFile(fn: String);
    property TapeName: string read FTapeName write setTapeName;
    property CurrentFile: Integer read FCurrentFile write setCurrentFile;
    property Directory: String read FDirectory write SetDirectory;
  End;

  // Var   TapeInfo:TTapeInfo=nil;

implementation

uses sysutils, new, forms, dialogs;

constructor TTapeInfo.Create;
begin
  Files := Tstringlist.Create;
  Directory := '';
  FCurrentFile := -1;
end;

destructor TTapeInfo.Destroy;
begin
  Files.free;
  inherited;
end;

procedure TTapeInfo.setCurrentFile(const Value: Integer);
begin
  if FCurrentFile <> Value then
  begin
    FCurrentFile := Value;
    UpdateVI;
  end;

end;

procedure TTapeInfo.setTapeName(const Value: String);
begin
  if FTapeName <> Value then
  begin
    FTapeName := Value;
    UpdateVI;
  end;
end;

procedure TTapeInfo.AddFile(fn: String);
begin
  if Files.indexof(fn) = -1 then
  Begin
    Files.Add(ExtractFileName(fn));
    Files.SaveToFile(Directory + '\_Dir.txt');
  End;
end;

procedure TTapeInfo.Eject;
begin
  LoadTape('');
  Directory := '';
  if TapeNo = 1 then
    fnewbrain.lblTape1Info2.Caption := 'No Tape'
  else
    fnewbrain.lblTape2Info2.Caption := 'No Tape';
end;

procedure TTapeInfo.FirstFile;
begin
  CurrentFile := 0;
end;

function TTapeInfo.GetFileName: string;
begin
  Result := Directory + '\' + Files[CurrentFile];
end;

function TTapeInfo.GetNextFileName: string;
begin
  if CurrentFile = -1 then
    Result := 'Noname'
  else
  begin
    if Files.Count > 0 then
      Result := Files[CurrentFile]
    else
      Result := '';
  end;
end;

procedure TTapeInfo.Lastfile;
begin
  CurrentFile := Files.Count - 1;
end;

procedure TTapeInfo.UpdateVI;
Begin
  if TapeNo = 1 then
  begin
    fnewbrain.lblTape1Info.Caption := GetNextFileName;
    fnewbrain.lblTape1Info.Hint := fnewbrain.lblTape1Info.Caption;
    fnewbrain.lblTape1Info2.Caption := TapeName;
    fnewbrain.lblTape1Info2.Hint := fnewbrain.lblTape1Info2.Caption;
  end
  else
  Begin
    fnewbrain.lblTape2Info.Caption := GetNextFileName;
    fnewbrain.lblTape2Info.Hint := fnewbrain.lblTape2Info.Caption;
    fnewbrain.lblTape2Info2.Caption := TapeName;
    fnewbrain.lblTape2Info2.Hint := fnewbrain.lblTape2Info2.Caption;
  End;
End;

// Load the _dir.txt that has the order of the files on virtual tape
procedure TTapeInfo.LoadTape(Tpnm: String);
var
  fnm: String;
begin
  Files.clear;
  TapeName := Tpnm;
  if Tpnm <> '' then
  Begin
    Directory := extractfilepath(Application.exename) + 'Basic\' + Tpnm;
    fnm := Directory + '\_Dir.txt';
    if fileexists(fnm) then
    Begin
      Files.LoadFromFile(fnm);
      CurrentFile := 0;
    End
    else
    Begin
      ShowMessage('Invalid Tape Directory');
      Directory := '';
    End;
    // else create a default maybe
  End
  Else
    CurrentFile := -1;
end;

procedure TTapeInfo.NextFile;
begin
  if CurrentFile < (Files.Count - 1) then
    CurrentFile := CurrentFile + 1
  else
    CurrentFile := 0;
end;

procedure TTapeInfo.PrevFile;
begin
  if CurrentFile > 0 then
    CurrentFile := CurrentFile - 1
  else
    CurrentFile := Files.Count - 1;
end;

procedure TTapeInfo.SetDirectory(const Value: String);
begin
  if FDirectory <> Value then
  begin
    if (Value <> '') and (Value[Length(Value)] <> '\') then
      FDirectory := Value + '\'
    else
      FDirectory := Value;
  end;
end;

function TTapeInfo.TapeLoaded: Boolean;
begin
  Result := Directory <> '';
end;

end.
