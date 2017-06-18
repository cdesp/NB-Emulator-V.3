{
    <Grundy NewBrain Emulator Pro Made by Despsoft>
    Copyright (C) 2004  <Despinidis Chris>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit uNBStream;

interface
uses uNBtypes;

Const StreamtableL=$0B00;//Object No
      StreamtableH=$0C00;//Open or Close

      ObjectTableP=$0700; //Page
      ObjectTableL=$0800; //Offset Low
      ObjectTableH=$0900; //Offset Hi

      VideoTableF=$1600;  //Video Table First Addr
      VideoTableL=$1680;  //Video Table Last Addr

type
  TNBStream=Record
    StrmNo:Byte;
    DrvrNO:Byte;
    PortNo:Byte;
    UnUsed:Byte;
    Memory:TPair;
  End;
  PNBStream=^TNBStream;


  TNBStreamManipulation=Class
   Public
    Current:Word;
    Found:Boolean;
    ISCpmVideo: Boolean;
    function StartMem:TPair;
    Function EndMem:TPair;
    Function First:TNBStream;
    Function Next:TNBStream;
    Function Previous:TNBStream;
    Function Last:TNBStream;
    Function BOST:Boolean;
    Function EOST:Boolean;
    Function FindStrm(StNO,DrNO,Port:Byte):TNBStream;
    Function FindStrmByMem(mem:TPair):TNBStream;
    function FindStrmForGraph(DrNO,Port:Byte): TNBStream;
    procedure GetCPMVideo(Var pgno:Integer;Var Offs:Word);
  End;

  TNBPGStreamManipulation=class
  private
     CurrentStream: Byte;
     procedure SetStreamNo(Value: Byte);
  Public
     ISCpmVideo: Boolean;
     Constructor Create;
     Function IsStreamOpen(StNo:Byte):Boolean;
     function PageNo2nd: Byte;
     procedure First;
     procedure Next;
     procedure Previous;
     procedure Last;
     function ObjectNo: TpAIR;
     function PageOffset2nd: TPair;
     function NextOpen: Boolean;
     function PageNo: Byte;
     function PageOffset: TPair;
     procedure ActiveVideoParams(Var pg:Integer;Var Offset:Word);
     function GetVideoNoByAddress(RamAdd:TPair): Integer;
     function DeviceNo: Byte;
     function VideoPos: Byte;
     function HasGraphStream(sg:Integer): Boolean;
     procedure GetCPMVideo(Var pgno:Integer;Var Offs:Word);
     function GetActiveDevice33Stream(Var pg:Integer;Var Offset:Word): Integer;
  published
     property StreamNo: Byte read CurrentStream write SetStreamNo;
  End;

implementation
uses uNBMemory,uNbScreen;

function TNBStreamManipulation.BOST: Boolean;
begin
  if current<=StartMem.w then
   Result:=True
  else
  result:=false;
end;

function TNBStreamManipulation.EndMem: TPair;
begin
  result.l:=nbmem.Rom[$64];
  result.h:=nbmem.ROM[$65];
end;

function TNBStreamManipulation.EOST: Boolean;
begin
  if current>=EndMem.w then
   Result:=True
  else
  result:=false;
end;

function TNBStreamManipulation.FindStrm(StNO, DrNO, Port: Byte): TNBStream;
Var st:TNBStream;
begin
   Found:=false;
   st:=First;
   While Not EOST do
   Begin
     Found:=(st.StrmNo=stno) and (st.DrvrNO=drNo) and (st.PortNo=port);
     if found then
     Begin
      Result:=st;
      break;
     End
     else
      st:=next;
   End;
end;

function TNBStreamManipulation.FindStrmByMem(mem: TPair): TNBStream;
Var st:TNBStream;
begin
   Found:=false;
   st:=First;
   While Not EOST do
   Begin
     Found:=(st.Memory.w=mem.w);
     if found then
     Begin
      Result:=st;
      break;
     End
      else
       st:=next;
   End;
end;

function TNBStreamManipulation.FindStrmForGraph(DrNO,Port:Byte): TNBStream;
Var st:TNBStream;
   Function GetLinkPort:Byte;
   Begin
     result:=nbmem.rom[st.Memory.w+46];
   End;

begin
   Found:=false;
   st:=First;
   While Not EOST do
   Begin
//     Found:=(st.DrvrNO=drNo) and ((GetLinkPort=port) or (st.PortNo=port));
     Found:=(st.DrvrNO=drNo) and (Port=GetLinkPort);
     if found then
     Begin
      Result:=st;
      break;
     End
     else
      st:=next;
   End;
end;

function TNBStreamManipulation.First: TNBStream;
Var slt,offs:integer;
begin
  current:=StartMem.w;
  slt:= current div $2000;
  offs:=current mod $2000;
  Result:=PNBStream(@nbmem.mainslots[slt].memory[offs])^;
end;

function TNBStreamManipulation.Last: TNBStream;
Var slt,offs:integer;
begin
  current:=EndMem.w-NBSLen;
  slt:= current div $2000;
  offs:=current mod $2000;
  Result:=PNBStream(@nbmem.mainslots[slt].memory[offs])^;
//  Result:=PNBStream(@rom[Current])^;
end;

function TNBStreamManipulation.Next: TNBStream;
Var slt,offs:integer;
begin
  Current:=Current+NBSLen;
  if current>EndMem.w then
    exit;
  slt:= current div $2000;
  offs:=current mod $2000;
  Result:=PNBStream(@nbmem.mainslots[slt].memory[offs])^;
//  Result:=PNBStream(@rom[Current])^;
end;

function TNBStreamManipulation.Previous: TNBStream;
Var slt,offs:integer;
begin
  Current:=Current-NBSLen;
{  if current<StartMem.w then
    Current:=Current+NBSLen;}
  slt:= current div $2000;
  offs:=current mod $2000;
  Result:=PNBStream(@nbmem.mainslots[slt].memory[offs])^;
//  Result:=PNBStream(@rom[Current])^;
end;

function TNBStreamManipulation.StartMem: TPair;
begin
  result.l:=nbmem.Rom[$56];
  result.h:=nbmem.ROM[$57];
end;

procedure TNBStreamManipulation.GetCPMVideo(Var pgno:Integer;Var Offs:Word);
Var oldcur:Word;
    st:TNBStream;
begin
   oldcur:=Current;
   ISCpmVideo:=false;
   pgno := -1;
   St:=First;
   While Not EOST do
   Begin
    If st.DrvrNO=18 then
    Begin
     IsCpmVideo:=true;
     pgno:=3;
     offs:=200;
     break;
    End;
    st:=next;
   End;
   Current:=oldcur;
end;

constructor TNBPGStreamManipulation.Create;
begin
  CurrentStream:=1;
end;

function TNBPGStreamManipulation.IsStreamOpen(StNo: Byte): Boolean;
begin
  result:= nbmem.rom[StreamtableH+StNo]=1;
end;

function TNBPGStreamManipulation.PageNo2nd: Byte;
begin
   Result := nbmem.rom[ObjectTableP+ObjectNo.H];
end;

procedure TNBPGStreamManipulation.First;
begin
 Currentstream:=0;
end;

procedure TNBPGStreamManipulation.Next;
begin
 if Currentstream<255 then
  inc(CurrentStream);
end;

procedure TNBPGStreamManipulation.Previous;
begin
 if currentStream>0 then
  Dec(CurrentStream);
end;

procedure TNBPGStreamManipulation.Last;
begin
  Currentstream:=255;
end;

function TNBPGStreamManipulation.ObjectNo: TpAIR;
begin
   Result.L := nbmem.rom[StreamtableL+CurrentStream];
   Result.H := nbmem.rom[StreamtableH+CurrentStream];
end;

function TNBPGStreamManipulation.PageOffset2nd: TPair;
begin
   Result.H :=  nbmem.rom[ObjectTableH+ObjectNo.H];
   Result.L :=  nbmem.rom[ObjectTableL+ObjectNo.H];
   Result.W:=result.W+Objectno.L+4;
end;

procedure TNBPGStreamManipulation.SetStreamNo(Value: Byte);
begin
     if CurrentStream <> Value then
          CurrentStream := Value;
end;

function TNBPGStreamManipulation.NextOpen: Boolean;
Var st:Byte;
begin
  st:=CurrentStream;
  result:=false;
  While st<255 do
  Begin
   inc(St);
   if IsStreamOpen(st) then
   Begin
     Result:=true;
     CurrentStream:=st;
     Break;
   End;
  End;
end;

function TNBPGStreamManipulation.PageNo: Byte;
Var p2nd:Byte;
begin
 result:=0;
 p2nd:=PageNo2nd;
 if not nbmem.chipexists(p2nd) then exit;
 Result := nbmem.nbpages[p2nd]^.Memory[PageOffset2nd.w] ;
end;

function TNBPGStreamManipulation.PageOffset: TPair;
Var p2nd:Byte;
begin
 result.w:=0;
 p2nd:=PageNo2nd;
 if not nbmem.chipexists(p2nd) then exit;
 Result.L :=nbmem.nbpages[p2nd]^.Memory[PageOffset2nd.w+256] ;
 Result.H :=nbmem.nbpages[p2nd]^.Memory[PageOffset2nd.w+2*256] ;
end;

procedure TNBPGStreamManipulation.ActiveVideoParams(Var pg:Integer;Var 
    Offset:Word);
Var //VAddr:TPair;
    VNo:Byte;
begin
//  VAddr:=nbScreen.VideoAddr;
//  Vaddr.w:=Vaddr.w-1;
  //from video table
//  VNo:=Byte(GetVideoNoByAddress(VAddr));
  Vno:= nbmem.rom[$BA]; //=TV4
  pg:=-1;
  If VNo<>-1 then   // always true
  Begin
    First;
    Repeat
        //from stream table
     If ((DeviceNo=0) or (DeviceNo=4)  )and (VideoPos=Vno) then
     Begin   //Stream Found for VideoAddr
      pg:=PageNo;
      Offset:=PageOffset.w;
      Break;
     End;
    Until not nextopen;
  End;
end;

function TNBPGStreamManipulation.GetVideoNoByAddress(RamAdd:TPair): Integer;
Var i,j:Integer;
begin
    Result:=-1;
    For j:=31 downto 0 do
    Begin
     i:=VideoTableF+(j*4);
     if (RamAdd.L<>NbMem.Rom[i]+2) and
        (RamAdd.H=NbMem.Rom[i+1]) then
     Begin
        result:=j;
        Break;
     End;
    End;
end;

function TNBPGStreamManipulation.DeviceNo: Byte;
Var pno:Byte;
begin
  result:=$ff;
  pno:=Pageno;
  if not nbmem.chipexists(pno) then exit;
  Result := NBMem.NBPages[pno]^.Memory[PageOffset.W+4];
end;

function TNBPGStreamManipulation.VideoPos: Byte;
begin
   if (DeviceNo=0) or (DeviceNo=4) then
     Result := NBMem.NBPages[Pageno]^.Memory[PageOffset.W+6]
   Else
    IF DeviceNo=11 then
     Result := NBMem.NBPages[Pageno]^.Memory[PageOffset.w+$51]
   ELSE
    Result:=0;
end;

function TNBPGStreamManipulation.HasGraphStream(sg:Integer): Boolean;
Var pg:Integer;
    offs:Word;
    sno:Byte;
begin
  Result:=False;
  If sg>-1 then
  Begin
    ActiveVideoParams(pg,Offs);
    If Pg=-1 then exit;
    sno:=nbmem.nbpages[pg]^.memory[offs+30];
    if sno=0 then exit;
  End
  Else
  Begin //search for 33 device
    GetActiveDevice33Stream(pg,Offs);
    If Pg=-1 then exit;
    sno:=nbmem.nbpages[pg]^.memory[offs+53];
    if sno=0 then exit;
  End;
  Result:=true;
  CurrentStream:=sno;
end;

procedure TNBPGStreamManipulation.GetCPMVideo(Var pgno:Integer;Var Offs:Word);
begin
   ISCpmVideo:=false;
   pgno := -1;
   First;
   Repeat
    If Deviceno=18 then
    Begin
     IsCpmVideo:=true;
     pgno:=NBMEM.ALTSLOTS[1].Page;
     offs:=4;
     break;
    End;
   Until not nextopen;
end;

function TNBPGStreamManipulation.GetActiveDevice33Stream(Var pg:Integer;Var 
    Offset:Word): Integer;
begin
  pg:=-1;
  First;
  Repeat
        //from stream table
     If (DeviceNo=33) then
     Begin   //Stream Found for VideoAddr
      pg:=PageNo;
      Offset:=PageOffset.w;
      Break;
     End;
  Until not nextopen;
  Result:=Pg;
end;

end.
