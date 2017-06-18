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

unit uNBCop;

interface
uses uNBTypes,classes,upccomms;



{$i 'dsp.inc'}

Type
  TNBDevice=(NBUnknown,NBTape1,NBTape2,NBPrn,NBComm);

  TCop420=Class

  private
      FFilename: String;
      procedure OpenPrinter;
      procedure WritePrinter(b:Byte);
    procedure SetCopReady;
    function CheckFileEnd: Boolean;
    function getFileName: String;
    procedure DeleteNoName;
      procedure SetFilename(Value: String);
    procedure CheckReadEOF;
    function FindFileName: string;
    procedure DoResetTape;
  public
      FileIsBinary: Boolean;
      Loading:Boolean;
      Saving:Boolean;
      Device:TNBDevice;
      ComBuf:Array[1..12] of byte;
      StartCommInput:Boolean;
      Bytes:Integer;
      f:textfile;
      cf:File of byte;
      prnopened:boolean;
      CommOpened:boolean;
      bithasset:Boolean;
      size:integer;
      comcnt:Integer;
      rom3d:Integer;
      ResetTape:Boolean;
      procedure CloseComm;
      procedure OpenComm(ToRead:boolean=false);
      function ReadComm: Byte;
      procedure TranslateBuffer;
      procedure Writecomm(b:Byte);
      function CheckReady(addr:Integer): Boolean;
      function KBEnabled: Boolean;
      constructor Create; virtual;
      procedure NBRenameFile(Fname:string);
      function Root: string;
      function CurrentExt: string;
      procedure ClosePrinter;
      destructor Destroy; Override;
      property Filename: String read FFilename write SetFilename;
  End;

Var  COP420:TCOP420; //some cop functions

implementation
uses jcllogic,z80baseclass,windows,
     uNBTapes,uNbMemory,sysutils,new,forms,
     math,FileCtrl,uNBScreen,uNBCPM,uNBIO;

constructor TCop420.Create;
begin
     inherited;
     FileName:='NoName';
     Deletenoname;
     freeandnil(NBDiscCtrl);
     if fNewBrain.WithCPM1.Checked      then
       NBDiscCtrl:=TNBDISCCtrl.create
     else
       NBDiscCtrl:=nil;
     ResetTape:=false;
end;

function TCop420.CheckFileEnd: Boolean;
Var fname:String;
    sz:Integer;
    b:Byte;
Begin
 result:=false;
 if (device=NBTape1) and Saving then
 Begin
   fname:=root+filename+CurrentExt;
   assignfile(cf,fname);
   reset(cf);
   sz:=FileSize(cf);
   Seek(cf,sz-12);
   b:=readcomm;
   CloseFile(cf);
   if b and 64=64 then //bit 6 set =last block written
    result:=true;
 End;
End;

procedure TCop420.CheckReadEOF;
Begin
    if size=comcnt then
    Begin
     if size>0 then
      closecomm;
     comcnt:=0;
     size:=0;
     loading:=false;
     if not Tapeinfo.TapeLoaded then
      FileName:='Noname';
    End;
End;


procedure TCop420.DoResetTape;
Begin
  try
    Device:=NBTape1;
    CloseComm;
    comcnt:=0;
    size:=0;
    loading:=false;
    saving:=false;
    try
      closefile(cf);
    except

    end;
  finally
    ResetTape:=false;
  end;
End;

function TCop420.CheckReady(addr:Integer): Boolean;
Var i:Integer;
begin
  Result := false;

  if not Loading and (nbmem.rom[$3b]=$8c)  then
  Begin
   if ResetTape then
     DoResetTape;
   Loading:=true;
   Opencomm(true);
   Device:=NBTape1;
  End;

  if not saving and (nbmem.rom[$3b]=$88)  then
  Begin
   if ResetTape then
     DoResetTape;
   saving:=true;
   bithasset:=false;
   rom3d:=-1;
   Device:=NBTape1;
   Opencomm;
   Writecomm(0);
  End;

  if saving and (nbmem.rom[$3b]=$D0) then
  Begin
   bithasset:=false;
   Closecomm;
   saving:=false;
  End
  else
  if Loading and (nbmem.rom[$3b]=$D0) then
  Begin
    for i:=1 to 9 do
     readcomm;
    CheckReadEOF;
    Loading:=false;
  End;

  if KBEnabled then
  Begin
    SetCopReady;
    Exit;
  End;

  if saving then
  Begin
      if not bithasset or (rom3d=-1) then
        Begin
          rom3d:=-1;
          SetCopReady;
          bithasset:=true;
        End;

      if Rom3d<>-1 then
        Begin
         bithasset:=false;
         Writecomm(nbmem.rom[$3d]);
        End;
  End
  else
  If loading then
  Begin
      if not bithasset or (addr<>$3d) then
        Begin
          SetCopReady;
          nbmem.rom[$3c]:=nbmem.rom[$3c] and ($ff-16);
          bithasset:=true;
        End;

      if Addr=$3d then
        Begin
         bithasset:=false;
         nbmem.rom[$3d]:=readcomm;
         result:=true;
        End;
  End;

end;

procedure TCop420.CloseComm;
Var s:String;
Begin
 if Commopened then
 Begin
  closefile(cf);
  if (device=NBTape1) and Saving then
  Begin
   if CheckFileEnd then
   Begin
    s:=getFileName;
    if not sametext(filename,s) then
      NBRenameFile(s);
    if tapeinfo.TapeLoaded then
    Begin
     tapeinfo.AddFile(FileName+CurrentExt);
     tapeinfo.Lastfile;
    End;
    FileName:='NoName';
    Saving:=false;
   End;
  End;
 End;
 if tapeinfo.TapeLoaded and not saving then
 Begin
   tapeinfo.NextFile;
   FileName:=tapeinfo.GetNextFileName;
 End;

 Commopened:=false;
 NBIO.CopInt:=false;
End;

procedure TCop420.ClosePrinter;
Begin
 if prnopened then
  closefile(f);
 prnopened:=false;
End;

function TCop420.CurrentExt: string;
begin
 if fileisbinary then
  Result := '.bin'
 else
  Result := '.bas';
end;

Procedure TCop420.DeleteNoName;
Begin
     if fileexists(root+'Noname.bas') then
      deletefile(root+'Noname.bas');
     if fileexists(root+'Noname.bin') then
      deletefile(root+'Noname.bin');

End;

function TCop420.FindFileName: string;
Var fname:String;
    f:String;
    i:Integer;
Begin
  for i:=1 to 10000 do
  Begin
    f:='UnKnown'+inttostr(i);
    fname:=root+f+CurrentExt;
    if not fileexists(fname) then break;
  End;
 fnewbrain.WriteP2('Saved as '+f+CurrentExt);
 result:=f;
End;

Function TCop420.getFileName:String;
Var ln:tpair;
    s:String;
    i:Integer;
    fname:string;
Begin
   if pos('.',Filename)=0 then
   Begin
    fname:=root+filename+CurrentExt
   End
   Else
    fname:=root+filename;
    
   assignfile(cf,fname);
   reset(cf);
   seek(cf,1);
   ln.l:=readComm;
   ln.h:=readcomm;
   s:='';
   if ln.w>0 then
   Begin
     for i:=1 to ln.w do
       s:=s+char(readcomm);
   End;
   if s='' then
   Begin
    if sametext(filename,'noname') then
     s:=FindFileName
    else
     s:=FileName;
   end;
  closefile(cf);
  result:=s;
End;

function TCop420.KBEnabled: Boolean;
begin

    Result := not loading and not saving;
end;

procedure TCop420.NBRenameFile(Fname:string);
begin
  if fileexists(root+fname+Currentext) then
   Begin
     renameFile(root+fname+Currentext,root+fname+'.bak');
     fnewbrain.writep2(Fname+' was replaced');
   End;

  RenameFile(root+filename+Currentext,root+fname+Currentext);
  filename:=root+fname+Currentext;
end;

procedure TCop420.OpenComm(ToRead:boolean=false);
var fname:String;
Begin
  if commOpened then exit;
  if not toread then
   Filename:='Noname';

  if device=nbComm then
   fname:=root+'..\Comm.bin'
  else
  Begin
   if toread and tapeinfo.TapeLoaded then
   Begin
    fname:=tapeinfo.GetFileName;
   End
   Else
    fname:=root+Filename+CurrentExt
  End;

  if toread and not fileexists(fname) then
  Begin
   FileName:='NotFound';
   fname:=root+'NotFound'+CurrentExt;
   ResetTape:=true;
  End;

  Commopened:=true;
  assignFile(cf,fname);
  if toread then
  Begin
   reset(cf);
   size := FileSize(cf);
  End
  else
  begin
   if fileexists(fname) then
   Begin
    filemode:=2;
    reset(cf);
    size := FileSize(cf);
    Seek(cf,size);
   End
   else
    Rewrite(cf);
  end;
End;

procedure TCop420.OpenPrinter;  //Obsolete Look uPCComms
var fname:String;
Begin
  if prnopened then exit;
  fname:=extractfilepath(application.exename);
  fname:=fname+'printer.txt';
  prnopened:=true;
  assignFile(f,fname);
  if not fileexists(fname)  then
   rewrite(f)
  else
   Append(f);
  Writeln(f,'');  Writeln(f,'');
  Writeln(f,'--------------------------------');
  Writeln(f,'--NewBrain Printer ['+datetimetostr(now)+'] ---------');
  Writeln(f,'--------------------------------');
  Writeln(f,'');
End;

function TCop420.ReadComm: Byte;
Var f:Boolean;
Begin
   try

    f:=eof(cf);
   Except
     f:=true;
     ResetTape:=true;
   End;


   if not f then
   Begin
    read(cf,result);
    inc(comcnt);
    fnewbrain.WriteP2(inttostr(comcnt));
    CheckReadEOF;
   End
   else
   Begin
    comcnt:=0;
    size:=0;
    FileName:='Noname';
    loading:=false;
   End;
End;

function TCop420.Root: string;
begin
  if tapeinfo.TapeLoaded then
     result:=tapeinfo.Directory
  Else
     Result := Extractfilepath(application.exename)+'Basic\';
end;

Procedure TCop420.SetCopReady;
Begin
     nbmem.rom[$3c]:=nbmem.rom[$3c] or $20; //cop ready
End;

procedure TCop420.SetFilename(Value: String);
Var k:Integer;
begin
     k:=pos('.bin',Lowercase(Value));
     if k>0 then
     Begin
       Fileisbinary:=true;
       value:=copy(value,1,k-1);
     End;
     k:=pos('.bas',lowercase(Value));
     if k>0 then
     Begin
       Fileisbinary:=false;
       value:=copy(value,1,k-1);
     End;

     if FFilename <> Value then
     begin
          FFilename := Value;
          if assigned(fnewbrain) then
          Begin
            fnewbrain.StatusBar1.panels[0].text:=value+CurrentExt;
           fnewbrain.StatusBar1.Repaint;
          End;
     end;
end;

procedure TCop420.TranslateBuffer;
Var tbit:Byte;

   Function GetByte:Byte;
   Var i:byte;
   Begin
     result:=0;
     if device=NbPrn then tbit:=7
     else tbit:=5;
     For i:=0 to 7 do
       if TestBit(ComBuf[i+3],tbit) then
         Result:=SetBit(Result,i);
   End;

Var b:Byte;

Begin
  if TestBit(ComBuf[1],5) then
   device:=NBComm //comms
  else device:=NBPRN;//printer

  b:=getbyte;
  Case Device of
   NBTape1:;
   NBtape2:;
   NBPrn: begin
       OpenPrinter;
       WritePrinter(b);
      end;
   NBComm:begin
       OpenComm;
       WriteComm(b);
     end;
  End;

End;

procedure TCop420.Writecomm(b:Byte);
Begin
  Write(cf,b);
End;

procedure TCop420.WritePrinter(b:Byte);
Begin
  Write(f,char(b));
End;

destructor TCop420.Destroy;
begin
  Closeprinter;
  CloseComm;
  inherited;
end;



end.
