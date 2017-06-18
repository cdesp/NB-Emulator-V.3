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
  TTapeInfo=Class
  private
    procedure SetDirectory(const Value: String);
  public
    FDirectory: String;
    Files:Tstringlist;
    CurrentFile:Integer;
    Constructor Create;
    Destructor Destroy;Override;
    Function GetFileName:string;
    Procedure NextFile;
    Procedure PrevFile;
    Procedure FirstFile;
    Procedure Lastfile;
    procedure LoadTape(Tpnm:String);
    function TapeLoaded: Boolean;
    procedure Eject;
    function GetNextFileName: string;
    procedure AddFile(fn:String);
    property Directory: String read FDirectory write SetDirectory;
  End;

Var   TapeInfo:TTapeInfo=nil;

implementation
uses sysutils,new,forms,dialogs;

constructor TTapeInfo.Create;
begin
  Files:=Tstringlist.create;
  Directory:='';
end;

destructor TTapeInfo.destroy;
begin
  Files.free;
  inherited;
end;

procedure TTapeInfo.AddFile(fn:String);
begin
  if files.indexof(fn)=-1 then
  Begin
   Files.Add(ExtractFileName(fn));
   Files.SaveToFile(Directory+'\_Dir.txt');
  End;
end;

procedure TTapeInfo.Eject;
begin
 LoadTape('');
 Directory:='';
 fnewbrain.StatusBar1.Panels[2].Text:='No Tape';
end;

procedure TTapeInfo.FirstFile;
begin
  Currentfile:=0;
end;

function TTapeInfo.GetFileName: string;
begin
  Result:=Directory+'\'+Files[currentfile];
end;

function TTapeInfo.GetNextFileName: string;
begin
 if currentFile=-1 then
  result:='Noname'
 else
  result:= Files[currentfile]
end;

procedure TTapeInfo.Lastfile;
begin
 Currentfile:=Files.Count-1;
end;

//Load the _dir.txt that has the order of the files on virtual tape
procedure TTapeInfo.LoadTape(Tpnm:String);
var fnm:String;
begin
   Files.clear;
   if tpnm<>'' then
   Begin
     Directory:=extractfilepath(Application.exename)+'Basic\'+tpnm;
     fnm:=Directory+'\_Dir.txt';
     if fileexists(fnm) then
     Begin
       files.LoadFromFile(fnm);
       CurrentFile:=0;
       fnewbrain.StatusBar1.Panels[2].Text:=tpnm;
       fnewbrain.StatusBar1.Panels[0].Text:=GetNextFileName;
     End
     else
     Begin
       ShowMessage('Invalid Tape Directory');
       Directory:='';
     End;
     //else create a default maybe
   End
   Else
    currentFile:=-1;
end;

procedure TTapeInfo.NextFile;
begin
 if currentfile<(files.count-1) then
  Inc(currentfile)
 else
  currentfile:=0;
end;

procedure TTapeInfo.PrevFile;
begin
 if currentfile>0 then
  Dec(currentfile)
 else
  currentfile:=Files.count-1;
end;

procedure TTapeInfo.SetDirectory(const Value: String);
begin
  if FDirectory <> Value then
  begin
    if (Value<>'') and
       (Value[Length(value)]<>'\') then
      FDirectory := Value+'\'
     else
    FDirectory := Value;
  end;
end;

function TTapeInfo.TapeLoaded: Boolean;
begin
  Result := Directory<>'';
end;


end.
