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

unit uNBMemory;

interface

{$i 'dsp.inc'}

Type
      TNBMemBank=Array[0..$1fff] of byte;
      PNBMemBank=^TNBMemBank;
      PNBMemChip=^TNBMemChip;

  TNBMemory=Class
     Function GetRom(Addr:Integer):Byte;
     Procedure SetRom(Addr:Integer;Value:Byte);
    private

     FAltSet: Boolean;
     FPageEnabled: Boolean;
     FDCOK: Boolean;
     procedure SetAltSet(Value: Boolean);
     function GetPageEnabled: Boolean;
    Public
     NBPages:array[-1..255] of PNBMemChip;
     MainSlots:Array[0..7] of PNBMemChip;
     AltSlots:Array[0..7] of PNBMemChip;
     CurSlots:Array[0..7] of PNBMemChip;
     PageSys:Boolean;
     Fpath: string;
     LastPage: integer;
     Procedure Init;
     procedure LoadRom(FromPageNo: Byte; FName: String; NextForward: Boolean = True);
     procedure SetPageInSlot(Slot,Page:integer;Alt:Boolean);
     function GetDirectMem(Const Page,Addr:Integer): Byte;
     procedure SetDirectMem(const Page, Addr: Integer; Value: Byte);
     procedure CreatePage(PageNo:Integer);
     procedure DestroyPage(PageNo:Integer);
     constructor Create;
     function ChipExists(PageNo:Integer): Boolean;Overload;
     function ChipExists(P:PNBMemChip): Boolean;Overload;
    function GetPageLength(const Pg: Integer): Integer;
     procedure SaveMem;
     procedure SetHardware;
     function LoadMem: Boolean;
     procedure InitFDCMem;
    function is16k(PageNo: Integer): Boolean;
    function is8k(PageNo: Integer): Boolean;
     procedure MakeEmptyPage;
    procedure SetPageInSlotForce(Slot, Page: integer;Alt:Boolean=false);
    Procedure SetRomForce(Addr:Integer;Value:Byte);
    function WithPibox: Boolean;
    function WithCPM: Boolean;
    function WithExpansion: Boolean;

     //case altset gives from Main or alt slots
     property Rom[ADDR:Integer]: Byte read Getrom write Setrom;
     property AltSet: Boolean read FAltSet write SetAltSet;
     property PageEnabled: Boolean read GetPageEnabled write FPageEnabled;
  End;

  TNBMemChip=Record
    Memory:TNBMemBank;
    IsRom:Boolean;
    Name:String;
    Page:Integer;
    LnkPageTo:Integer;
    LnkPageFrom:Integer;
    TotalBytes:Integer;
  End;

Var  
  NBMem:TNBMemory;


implementation
uses Sysutils,forms,new,Inifiles,uNbTypes,frmPeriferals,dialogs,z80baseclass,uNBIO;

constructor TNBMemory.Create;
begin
  Fpath:=AppPath+'Roms\';
  PageEnabled:=False;
end;

function TNBMemory.GetPageLength(Const Pg:Integer):Integer;
Begin
  if PG<0 then
    Result:=$ffff
  else
  if not ChipExists(PG) then
    Result:=0
  Else
   Result:=Length(NBPages[PG].Memory);
end;

function TNBMemory.ChipExists(P: PNBMemChip): Boolean;
begin
 result:=p<>nil;
end;

function TNBMemory.ChipExists(PageNo:Integer): Boolean;
begin
  Result := NBPages[Pageno]<>nil;
end;

procedure TNBMemory.CreatePage(PageNo:Integer);
Var n:PNBMemChip;
    i:Integer;
begin
  system.New(n);
  NBPages[PageNo]:=n;
  n^.Name:='RAM';
  n^.Page:=Pageno;
  n^.IsRom:=False;
  n^.LnkPageTo:=-1;
  n^.LnkPageFrom:=-1;
  n^.TotalBytes:=0;
  //clear page
  for I := 0 to $1fff do
   n^.Memory[i]:=$ff;

end;

procedure TNBMemory.DestroyPage(PageNo:Integer);
Var n:PNBMemChip;
begin
 n:=NBPages[PageNo];
 NBPages[PageNo]:=nil;
 Dispose(n);
end;

procedure TNBMemory.SetDirectMem(Const Page,Addr:Integer;Value:Byte);
begin
 if ChipExists(Page) And (Length(NBPages[Page].Memory)>Addr) then
   NBPages[Page].Memory[Addr]:=Value;
end;


function TNBMemory.GetDirectMem(Const Page,Addr:Integer): Byte;
begin
 if ChipExists(Page) And (Length(NBPages[Page].Memory)>Addr) then
   result:= NBPages[Page].Memory[Addr]
 Else
   Result:=0;
end;

function TNBMemory.GetRom(Addr: Integer): Byte;
Var slt:Integer;
    offs:Integer;
    p:PNBMemChip;
    a:Word;
begin
  Result:=$ff;
  slt:=Addr div $2000;
  offs:=Addr-(Slt*$2000);
  if slt>7 then exit;

  p:=Curslots[slt];

  if ChipExists(p) then
   try
    result:=  p^.Memory[offs];
   except
     on e:exception do
      ;
   end;

 //For safety it should not come here
 //but if it did we change the value so we
 //do not halt
 //Usually happens when oppening #0,3 VF Only
 //THIS IS A WORKAROUND NOT A FIX
  a:=z80_get_reg(Z80_REG_PC);
  If (addr=36) and (a=$E15E )then
  Begin
    if result and 8<>8 then
    begin
     result := result or 8;
     p^.Memory[offs]:=result;
    end;
  End;
 //if (slt=0) and (offs=8) then
 //  ODS('read:' +inttostr(result));
end;

Function TNBMemory.WithCPM:Boolean;
Begin
   Result:=fnewbrain.WithCPM1.checked
End;

Function TNBMemory.WithExpansion:Boolean;
Begin
   Result:=fnewbrain.WithExpansion1.checked ;
End;

Function TNBMemory.WithPibox:Boolean;
Begin
   Result:=fnewbrain.Withpibox.checked ;
End;

procedure TNBMemory.Init;
Var i:Integer;
    oldv:Boolean;
    pg:Integer;
    rm:String;
begin
  oldv:=WithExpansion;
  fnewbrain.WithExpansion1.checked:=true;
  PageEnabled:=True;
 try
  MakeEmptyPage;
  // For i:=0 to 3 do
   //  CreatePage(i); // std ram

  For i:=96 to 107 do
   CreatePage(i); // Exp ram 96k

  if vers=1 then
  Begin
   if not oldv then
   Begin
    if svers=40 then begin
      LoadRom(122,'Aben14.rom'); //version 1.40 rom
  //    LoadRom(5,'Aben14.rom'); //version 1.40 rom
    end;
    if svers=90 then begin
      LoadRom(122,'Aben19.rom'); //version 1.90 rom
   //   LoadRom(5,'Aben19.rom'); //version 1.90 rom
    end;
    if svers=91 then begin
      LoadRom(122,'Aben191.rom'); //version 1.91 rom
    //  LoadRom(5,'Aben191.rom'); //version 1.91 rom
    end;
   End
   else begin
     LoadRom(122,'Aben191.rom'); //version 1.91 rom with expansion
    // LoadRom(5,'Aben191.rom'); //version 1.91 rom with expansion
   end;

   LoadRom(121,'cd.rom');  //no change to this rom ever
   LoadRom(120,'ef1x.rom');

  // LoadRom(6,'cd.rom');  //no change to this rom ever
  // LoadRom(7,'ef1x.rom');
  End
  else
  if vers=2 then
  Begin
    Case svers of
    0:
      Begin
       LoadRom(122,'SERIES2.A#B'); //VERSION 2 ROM  Original
       LoadRom(121,'cd.rom'); //no change to this rom ever
       LoadRom(120,'SERIES2.E#F');
      end;
    1:
      Begin
       LoadRom(122,'ZRT20AB.rom'); //VERSION 2 ROM no ram test
       LoadRom(121,'cd.rom'); //no change to this rom ever
       LoadRom(120,'ZRT20EF.rom');
      end;
    2:
      Begin
       LoadRom(122,'EMU_ABROM.rom'); //Series 2 ROM
       LoadRom(121,'EMU_CDROM.rom');
       LoadRom(120,'EMU_EFROM.rom'); //Series 2 ROM
      end;
    3:
      Begin
       LoadRom(123,'MOD_80ROM.rom'); //Modular newbrain Rom
       LoadRom(122,'MOD_ABROM.rom'); //Modular newbrain Rom
       LoadRom(121,'MOD_CDROM.rom');
       LoadRom(120,'MOD_EFROM.rom'); //Series 2 ROM
       SetPageInSlot(4,123,False); //A000   rom
       //uses page 96 and 97 of ram for 16KB Video RAM
      end;

    end;
  end;

  SetPageInSlot(0,107,False); //0000   ram Original chips
  SetPageInSlot(1,106,False); //2000   video only here
  SetPageInSlot(2,105,False); //4000
  SetPageInSlot(3,104,False); //6000

  SetPageInSlot(5,122,False); //A000   rom
  SetPageInSlot(6,121,False); //C000
  SetPageInSlot(7,120,False); //E000

  SetRomForce($E160,$18);//not halted ever
  SetRomForce($E2E0,$18);//not halted ever

  //----------TESTING-----------

  {
   // This Code makes an Unexpanded NB to Have 40K RAM
  CreatePage(117);
  SetPageInSlot(4,117,False); //8000   ram/rom
  }
 // LoadRom(123,'ZRT20AB.rom');

  //TODO:Load from frmperiferals

  if WithPibox then
  Begin
   LoadRom(118,'\pibox\forth.ROM');   //1st USER ROM
   LoadRom(113,'\pibox\utility.ROM');   //1st USER ROM
   CreatePage(114);//PIBOX CMOS Ram
   CreatePage(115);//PIBOX CMOS Ram
   LoadRom(116,'\pibox\piboxp.rom');   //unpaged system
   SetPageInSlot(4,113,False);
  end;

  if WithDatapack then
  Begin
  // CreatePage(112);//DataBox CMOS Ram           Slot 3  8K
  // LoadRom(114,'\datapack\CHESS2DP.ROM');  //16 KB        Slot 2  16k
  // LoadRom(116,'\datapack\DIRIIDP.ROM');  //16 KB         Slot 1 16K
  // LoadRom(118,'\datapack\DP3#3101.rom');  //Datapack ROM Slot 0 8K
   for i := 0 to 3 do
   Begin
     frmPerif.GetRom(DataPack,i,pg,rm);
     if sametext(rm,'RAM') then
      CreatePage(pg)
     else
      LoadRom(pg,rm);
   end;
   SetPageInSlot(4,118,False);
  end;

  if WithMicroPage then
  Begin
   //CreatePage(112);//MicroPage CMOS Ram           Slot 3  8K
   //LoadRom(114,'\MicroPage\MICROTER.ROM');  //16 KB        Slot 2  16k
   //LoadRom(116,'\MicroPage\TYPIST.ROM');  //16 KB         Slot 1 16K
   //LoadRom(118,'\MicroPage\DEVPAC3.ROM');  //16 KB        Slot 0  16k
   for i := 0 to 3 do
   Begin
     frmPerif.GetRom(MicroPage,i,pg,rm);
     if sametext(rm,'RAM') then
      CreatePage(pg)
     else
      LoadRom(pg,rm);
   end;
   SetPageInSlot(4,118,False);
  end;

  //--------END TESTING---------

  SetHardware;
 //Load the Extra roms
 if not oldV then   //not expansion interface
 Begin
  if WithCPM then
  Begin
//   LoadRom(122,'Aben19.rom');
   LoadRom(123,'31#5#83.CPM');
   SetPageInSlot(4,123,False);
//   SetPageInSlot(5,122,False);
  End;
 End
 Else
 Begin
  //load expansion roms
   if WithCPM then
   Begin
    LoadRom(119,'31#5#83.CPM'); //126
   End;
   LoadRom(124,'10#8#83.MTV');
   LoadRom(125,'19#8#83.ACI');
 //ThisPage Contains EIM at $8000
   LoadRom(123,'16#8#83.POS'); //ok slot 4
 //  LoadRom(123,'8#6#83.POS'); //ok slot 4
   SetPageInSlot(4,123,False);
 End;

 finally
  AltSet:=True;
  AltSet:=False;
  fnewbrain.WithExpansion1.checked:=Oldv;
  PageEnabled:=False;
 end;
end;

Function TNBMemory.is8k(PageNo:Integer):Boolean;
Begin
 Result:= true; //Empty pages also
 if ChipExists(PageNo) then
   Result:=NBPages[PageNo].LnkPageTo=-1;
end;

Function TNBMemory.is16k(PageNo:Integer):Boolean;
Begin
 Result:= false;
 if ChipExists(PageNo) then
 Begin
   Result:=(NBPages[PageNo].LnkPageTo>-1) and
         (NBPages[NBPages[PageNo].LnkPageTo].LnkPageTo=-1);
 end;
end;

procedure TNBMemory.LoadRom(FromPageNo: Byte; FName: String; NextForward:
    Boolean = True);
var f:File;

      k:Integer;
      PAux: PByte;
      t,n,prevpage:Integer;
      fl:String;
Begin
   fl:=Fpath+FName;
 try
   System.FileMode:=fmOpenRead;
   try
    System.Assign(f,fl);
    {$I-}
    System.Reset(F, 1);
    {$I+}
   finally
    System.FileMode:=fmOpenReadWrite;
   end;
   t:=0;n:=0;
   PrevPage:=-1;
   repeat
    if not ChipExists(FromPageNo) then
     CreatePage(FromPageNo);

    PAux:=PByte(@(NBPages[FromPageNo]^.Memory));
    BlockRead(F, paux^, $2000,k);
    NBPages[FromPageNo]^.IsRom:=true;
    NBPages[FromPageNo]^.Name:=FName;
    NBPages[FromPageNo]^.TotalBytes:=FileSize(F);
    if PrevPage<>-1 then
    Begin
       NBPages[FromPageNo]^.LnkPageFrom:=PrevPage;
       NBPages[PrevPage]^.LnkPageTo:=FromPageNo;
    end;

    t:=t+k;
    prevpage:=FromPageNo;
    if nextForward then
      Inc(FromPageNo)    //if more than 8k then load in next page
    Else
      Dec(FromPageNo);  //if more than 8k then load in Previous page
    Inc(n)
   Until FileSize(F)<=t;

   System.Close(f);
 Except
  On e:exception do
   raise Exception.Create('Error Loading ['+fl+'] ROM. '#13#10+e.Message);
 end;
end;

procedure TNBMemory.SetAltSet(Value: Boolean);
Var i:integer;
begin
  if FAltSet <> Value then
  begin
    FAltSet := Value;
    if not pageEnabled then exit;
    If Value then
    Begin
     For i:=0 to 7 do
     Begin
      CurSlots[i]:=AltSlots[i];
     End;
    End
    Else
    Begin
     For i:=0 to 7 do
     Begin
      CurSlots[i]:=MainSlots[i];
     End;
    End;
  end;
end;

procedure TNBMemory.SetPageInSlotForce(Slot,Page:integer;Alt:Boolean=false);
Var OldChecked:Boolean;
    OldPageEn:Boolean;
Begin
   OldChecked:=fnewbrain.WithExpansion1.checked;
   OldPageEn:=PageEnabled;
   try
   fnewbrain.WithExpansion1.checked:=true;
   PageEnabled:=true;
   SetPageInSlot(Slot,Page,false);
   finally
      fnewbrain.WithExpansion1.checked:=OldChecked;
      PageEnabled:=OldPageEn;
   end;
end;

procedure TNBMemory.SetPageInSlot(Slot,Page:integer;Alt:Boolean);
{$IFDef NBPGDEBUG}
Var s:String;
{$ENDIF}
begin
  if not fnewbrain.WithExpansion1.checked  then
       Exit;

// if page>127 then Page:=Page-128;
 page:=Page And $7F; //High bit = Rom or Ram

 {$IFDef NBPGDEBUG}
 s:='';

 If Alt then
  s:=s+'Alt -';
 if pageEnabled then
   s:=s+' PageEn -';
 s:=s+' Set Slot:'+inttostr(slot)+' to Page:'+inttostr(Page);
 if NBPages[page]<>nil then
  s:=s+' ('+NBPages[page].Name+')'
 else
  s:=s+' (Not exists)';
 ODS(s);
 {$Endif}

 If not ChipExists(Page) then Page:=-1;//Empty page returns $ff and is ROM

 if alt then
  Altslots[slot]:=NBPages[page]
 else
  Mainslots[slot]:=NBPages[page];
 if ChipExists(Page) and (Slot<4) then
  if not nbpages[Page]^.IsRom and alt then
  LastPage:=page;

  if pageEnabled then
   if alt=altset then
   Begin
    CurSlots[slot]:=NBPages[page];
   End; 
end;

//put a byte in memory address (ONLY ON RAM)
procedure TNBMemory.SetRom(Addr: Integer; Value: Byte);
Var slt:Integer;
    offs:Integer;
    p:PNBMemChip;
begin
   slt:=Addr div $2000;
   offs:=Addr-(Slt*$2000);
   p:=Curslots[slt];
   if ChipExists(p) then
   Begin
     if p^.Page=-1 then
     Begin
//       ODS('Error. Try to Write on empty slot.'+inttostr(Addr));
       Exit;
     End;

     if (not p^.IsRom) or nbio.RomWriteAble then
     Begin
      p^.Memory[offs]:=Value;
     End
     Else
     If not fnewbrain.WithExpansion1.Checked and
      fnewbrain.WithCPM1.checked then
     Begin
       if (Slt=4) and (Offs>=$1c00) then    //CPM has a 1kb Ram that is accessable by NB
       Begin
        p^.Memory[offs]:=Value;
       End;
     End;
   End;
end;

//put a byte in memory address (RAM and ROM)
procedure TNBMemory.SetRomForce(Addr: Integer; Value: Byte);
Var slt:Integer;
    offs:Integer;
    p:PNBMemChip;
begin
   slt:=Addr div $2000;
   offs:=Addr-(Slt*$2000);
   p:=Curslots[slt];
   if ChipExists(p) then
   Begin
     if p^.Page<>-1 then
      p^.Memory[offs]:=Value;
   End;
end;

function TNBMemory.GetPageEnabled: Boolean;
begin
     Result := FPageEnabled;
end;

//save to the .ini file the memory mapping
//if you change this file you can change the memory map
procedure TNBMemory.SaveMem;
Var i:integer;
    fn:String;
    inf:Tinifile;

  Procedure SaveChip(no:Integer);
  Begin
    inf.WriteString('MemoryMap',inttostr(no),nbpages[no].Name);
  End;

  Procedure SaveSlot(no:Integer;Alt:Boolean);
  Begin
    If not alt then
    Begin
     if Mainslots[no]<>nil then
       inf.WriteString('MainSlots',inttostr(no),Inttostr(MainSlots[no].Page))
     Else
       inf.WriteString('MainSlots',inttostr(no),'');
    End
    Else
    Begin
     if Altslots[no]<>nil then
       inf.WriteString('AltSlots',inttostr(no),Inttostr(AltSlots[no].Page))
     Else
     inf.WriteString('AltSlots',inttostr(no),'');
    End;
  End;

begin
  Fn:='NewBrain';
  If WithExpansion then
   Fn:=Fn+'_Exp';
  If WithCPM then
   Fn:=Fn+'_CPM';
  fn:=Fn+'.ini';

  inf:=TInifile.Create(ExtractFilepath(Application.exename)+fn);
  try
    Init;
    For i:=1 to 255 do
    Begin
      If ChipExists(i) then
       SaveChip(i);
    End;
    For i:=0 to 7 do
      SaveSlot(i,False);
    For i:=0 to 7 do
      SaveSlot(i,True);
    showmessage('File '+fn+' created.'#13'You can change this file to suit your needs.'#13'You should delete it to reset NB Emu.');
  finally
    Inf.free;
  end;
end;

procedure TNBMemory.SetHardware;
Var i,j:integer;
begin
  For j:=0 to 3 do
   For i:=0 to $1fff do
    MainSlots[j].memory[i]:=MainSlots[7].memory[i];
end;

//load memory map for .ini file
function TNBMemory.LoadMem: Boolean;
Var i:integer;
    fn:String;
    inf:Tinifile;

    Procedure LoadChip(no:Integer);
    Var s:String;
    Begin
     s:=inf.ReadString('MemoryMap',inttostr(no),'');
     if s<>'' then
     Begin
       If sametext(s,'ram') then
        Createpage(no)
       Else
        LoadRom(no,s);
     End;
    End;

  Procedure LoadSlot(No:integer;Alt:Boolean);
  var s:String;
  Begin
    If not alt then
    Begin
      s:=inf.ReadString('MainSlots',inttostr(no),'');
      if s<>'' then
       SetPageInSlot(no,strtoint(s),False)
    End
    Else
    Begin
      s:=inf.ReadString('AltSlots',inttostr(no),'');
      if s<>'' then
       SetPageInSlot(no,strtoint(s),True);
    End;
  End;

  Var oldst:boolean;

begin
  Result:=false;
  Fn:='NewBrain';
  If WithExpansion then
   Fn:=Fn+'_Exp';
  If WithCPM then
   Fn:=Fn+'_CPM';
  fn:=Fn+'.ini';

  If not Fileexists(AppPath+fn) then
   exit;

  Result:=true;
  PageEnabled:=true;
  inf:=TInifile.Create(AppPath+fn);
  MakeEmptyPage;
  For i:=1 to 255 do
   LoadChip(i);
  oldst:=WithExpansion;
  fnewbrain.WithExpansion1.checked:=true;
  For i:=0 to 7 do
    LoadSlot(i,False);
  For i:=0 to 7 do
    LoadSlot(i,True);
  SetHardWare;
  fnewbrain.WithExpansion1.checked:=oldst;
  PageEnabled:=False;
  inf.free;
end;

procedure TNBMemory.InitFDCMem;
Var i:Integer;
begin
   if not (WithCPM and not WithExpansion) then exit;
   if fdcok then exit;
   fdcok:=true;
   For i:=$1C00 to $1fff do //1K Static Ram of FDC
     NBPages[123]^.memory[i]:=0;
end;

//this is the empty page all bytes are 255 and it is not writeable
//usually occupies the $8000-$A000 space
procedure TNBMemory.MakeEmptyPage;
Var i:Integer;
begin
  if chipexists(-1) then exit;
  CreatePage(-1);
  nbpages[-1].IsRom:=true;
  nbpages[-1].Name:='EMPTY_PAGE';
  For i:=0 to $2000-1 do
   nbpages[-1].Memory[i]:=$ff;
  For i:=0 to 7 do
     SetPageInSlot(i,-1,False);
end;



end.
