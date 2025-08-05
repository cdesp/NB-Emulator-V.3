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

unit uNBCPM;

interface

uses uNBTypes,Classes;

Const

   ALUSectors=8;
   ALUDir=0; //Side=0,Track=1,Sect(1-8)

   ALUStart=1;//Side=0,Track=1,Sect(9-10)
              //Side=1,Track=1,Sect(1-6)

type
  TNBDiskFileType=(dft80DS,dft80SS,dft40DS,dft40SS,dft80DS_NS,dftNone);

  //this resides on the start of the disk saved by configur
  TNBDiskConfig=Record
     B0:BYTE;
     B1:array[0..1] of Byte;
     Unk1:Byte;// either 16 or 32
     B2:array[0..2] of Byte;
     GapLenOnFormatting:Byte;//always $28=40
     B3: Byte;
     BSH:Byte;//05 for 80 04 for 40  gives 4096 bytes for 80 and 2048 for 40      3 gives 1024
     BLM:Byte;//1f for 80 0f for 40 (BLOCK SIZE)                                  7
     EXM:BYTE;//3 for 80DS 1 for 40SS
     DSM:BYTE;//NO-1 of CPM blocks(2048 or 4096)
     B4:Byte;
     DirEntries:Byte;    //$0e
     B5:array[0..2] of Byte;
     Unk3:Byte; //either 16 or 32 ???
     B6:array[0..2] of Byte;
     NoOfTracks:Byte;       //$16
     B7:array[0..3] of Byte;
     SectorsPerTrack:Byte;  //$1b
     B8:array[0..7] of Byte;
     SeekRate:Byte;

  end;
  PNBDiskConfig=^TNBDiskConfig;
      //EX S1 S2 RC from dir entry
{
EX = Extent counter, low byte - takes values from 0-31
S2 = Extent counter, high byte.

      An extent is the portion of a file controlled by one directory entry.
    If a file takes up more blocks than can be listed in one directory entry,
    it is given multiple entries, distinguished by their EX and S2 bytes. The
    formula is: Entry number = ((32*S2)+EX) / (exm+1) where exm is the
    extent mask value from the Disc Parameter Block.

S1 - reserved, set to 0.
RC - Number of records (1 record=128 bytes) used in this extent, low byte.
    The total number of records used in this extent is

    (EX & exm) * 128 + RC

    If RC is 80h, this extent is full and there may be another one on the disc.
    File lengths are only saved to the nearest 128 bytes.

AL - Allocation. Each AL is the number of a block on the disc. If an AL
    number is zero, that section of the file has no storage allocated to it
    (ie it does not exist). For example, a 3k file might have allocation
    5,6,8,0,0.... - the first 1k is in block 5, the second in block 6, the
    third in block 8.
     AL numbers can either be 8-bit (if there are fewer than 256 blocks on the
    disc) or 16-bit (stored low byte first).


}
  TDirEntryNormal=Record
      Userno:Byte;
      FName:Array[0..7] of Ansichar;
      Ext:Array[0..2] of Ansichar;
      Extent:Byte;
      No13:Byte;
      No14:Byte;
      NoExtend:Byte;
      ALU:Array[0..15] of Byte;
     End;


  TNBDiscRec=Record
   CBUFFER:TPair;
   COTHER:TPair;
   CLSTTRA:TPair;
   CDRIVE:Byte;
   CGAP:Byte;
   CSECSIZ:Byte;
   CSPEED:Byte;
   CSEEKRA:Byte;
   CSECTOR:Byte;
   CTRACK:TPair;
   CSIDE:Byte;
   CRESULT:Byte;
   CCOMMAN:Byte;
//   ----
   CSEKDPH:TPair;
   CSEKDSK:Byte;
   CSEKTRK:TPair;
   CSEKSEC:Byte;
   CSEKHST:Byte;

   CHSTDPH:TPair;
   CHSTDSK:Byte;
   CHSTTRK:TPair;
   CHSTSEC:Byte;

   CHSTACT:Byte;
   CHSTWRT:Byte;

   CUNACNT:Byte;
   CUNADSK:Byte;
   CUNATRK:TPair;
   CUNASEC:Byte;

   CERFLAG:Byte;
   CRSFLAG:Byte;
   CREADOP:Byte;
   CWRTYPE:Byte;
   CDMAADR:TPair;

   CMAXDSK:Byte;
   CADPBAS:TPair;

   CAHSTBU:TPair;

   CREADWRITE1:Byte;
   CREADWRITE2:Byte;
   CREADWRITE3:Byte;

  End;

  PNBDiscRec=^TNBDiscRec;

  PDirEntryNormal=^TDirEntryNormal;

  TnbDisc=Array[0..819200] of byte;
  PNBDisc=^TnbDisc;


  TNBDISCCtrl=Class

    Procedure Save;
    Procedure Load;
    Procedure GetReadyForCommand;
    Procedure DoCommand;
  private
    DiskBuf:Array[0..1] of TnbDisc;
    SecSize: Integer;
    SecPerTrack:Integer;
    DiskNo,Side,TrackNo,SectorNo:Integer;
    FDir1: Ansistring;
    FDir2: Ansistring;
    CPMBase: Integer;
    CPMSLOT: Integer;
    FNPaged: Boolean;
    res: Byte;
    procedure SetResult(Val:Byte=255);
    procedure MakeDisk(Dir: AnsiString);
    procedure ReadDisk(nm: AnsiString);
    procedure MakeDir(Dir: AnsiString);
    procedure SetDir1(const Value: Ansistring);
    procedure SetDir2(const Value: Ansistring);
    procedure SetNPaged(Value: Boolean);
    function GetFileType(fsz: Integer): TNBDiskFileType;
  public
    DirListA: TStringList;
    DirListB: TStringList;
    Procedure ForceDir1(d:String);
    procedure CPMRead(Disk,Side:Byte;Track:Integer;Sector:Byte);
    constructor Create; virtual;
    procedure CPMWrite(Disk,Side:Byte;Track:Integer;Sector:Byte);
    destructor Destroy; override;
    procedure DoReset;
    procedure SaveNewSystem(SysNm:AnsiString);
    procedure WriteDisk(nm: AnsiString);
    procedure DiskExtract(fn:Ansistring);
    property Dir1: Ansistring read FDir1 write SetDir1;
    property Dir2: Ansistring read FDir2 write SetDir2;
    property NPaged: Boolean read FNPaged write SetNPaged;

  End;

function GetFileSize(const FileName : AnsiString) : LongInt;

function GetFiles(path, mode : AnsiString; list : TStrings): Boolean;

Function DISKSIZE:Longint;

Var
    NBDisc:PNBDiscRec=nil;
    NBDiscCtrl:TNBDISCCtrl=nil;
    NBDiskFileType:TNBDiskFileType; //Reading DSK file type
    NBDiskConfigur:array[0..1] of PNBDiskConfig;
    DSKfs:Longint; //Reading DSK file Size

implementation

uses new,sysutils,uNBMemory,math,dialogs;

{ TNBDISCCtrl }



    Procedure ODSNbDisc;
    Begin
   //   Exit;
      ODS('========================================');
      ODS('-----Controller Command----- ');
      ODS(' Buffer:'+Inttostr(NBDisc.CBUFFER.w));
      ODS(' Other:'+Inttostr(NBDisc.COTHER.w));
      ODS(' Last Ttrack:'+Inttostr(NBDisc.CLSTTRA.w));
      ODS(' Drive:'+Inttostr(NBDisc.CDRIVE));
      ODS(' Gap:'+Inttostr(NBDisc.CGAP));
      ODS(' SecSize:'+Inttostr(NBDisc.CSECSIZ));
      ODS(' Drive Speed:'+Inttostr(NBDisc.CSPEED));
      ODS(' Seek Rate:'+Inttostr(NBDisc.CSEEKRA));
      ODS(' Sector:'+Inttostr(NBDisc.CSECTOR));
      ODS(' Track:'+Inttostr(NBDisc.CTRACK.w));
      ODS(' Side:'+Inttostr(NBDisc.CSIDE));
      ODS(' Result:'+Inttostr(NBDisc.CRESULT));
      ODS(' CMD:'+Inttostr(NBDisc.CCOMMAN));
      ODS('--------Seek------------ ');
      ODS(' Drv NO:'+Inttostr(NBDisc.CSEKDSK));
      ODS(' Track No:'+Inttostr(NBDisc.CSEKTRK.w));
      ODS(' Sector No:'+Inttostr(NBDisc.CSEKSEC));
      ODS(' Required host sector:'+Inttostr(NBDisc.CSEKHST));
      ODS(' Seek disc DPH address:'+Inttostr(NBDisc.CSEKDPH.w));
      ODS('-------- Host------------ ');
      ODS(' Drv NO:'+Inttostr(NBDisc.CHSTDSK));
      ODS(' Track No:'+Inttostr(NBDisc.CHSTTRK.w));
      ODS(' Sector No:'+Inttostr(NBDisc.CHSTSEC));
      ODS(' Written flag:'+Inttostr(NBDisc.CHSTWRT));
      ODS(' Active flag:'+Inttostr(NBDisc.CHSTACT));
      ODS('-------- Rest------------ ');
      ODS(' Host Active:'+Inttostr(NBDisc.CHSTACT));
      ODS(' Host Written:'+Inttostr(NBDisc.CHSTWRT));
      ODS('---------------------------------------------- ');
      ODS(' Unnaloc recs:'+Inttostr(NBDisc.CUNACNT));
      ODS(' Last Unnal Disk No:'+Inttostr(NBDisc.CUNADSK));
      ODS(' Last Unnal track No:'+Inttostr(NBDisc.CUNATRK.w));
      ODS(' Last Unnal Sec no:'+Inttostr(NBDisc.CUNASEC));
      ODS('---------------------------------------------- ');
      ODS(' Error rep:'+Inttostr(NBDisc.CERFLAG));
      ODS(' Read sector flag:'+Inttostr(NBDisc.CRSFLAG));
      ODS(' 1 if a read operation:'+Inttostr(NBDisc.CREADOP));
      ODS(' Write operation type (from BDOS):'+Inttostr(NBDisc.CWRTYPE));
      ODS(' Last DMA Addr:'+Inttostr(NBDisc.CDMAADR.w));
      ODS('---------------------------------------------- ');
      ODS(' Max Disks:'+Inttostr(NBDisc.CMAXDSK));
      ODS(' Addr DPBASE:'+Inttostr(NBDisc.CADPBAS.w));
      ODS(' Addr Hst Buff:'+Inttostr(NBDisc.CAHSTBU.w));
      ODS('---------------------------------------------- ');
      ODS(' Addr med lev dsk1:'+Inttostr(NBDisc.CREADWRITE1));
      ODS(' Addr med lev dsk2:'+Inttostr(NBDisc.CREADWRITE2));
      ODS(' Addr med lev dsk3:'+Inttostr(NBDisc.CREADWRITE3));


      ODS('========================================');

    End;

Function DiskNo:Integer;
Begin
  if not assigned(NBDiscCtrl) then
   Result:=0
  else
   result:=NBDiscCtrl.DiskNo;
End;

Function EXM:Byte;
Begin
   Result:= NBDiskConfigur[DiskNo].EXM;
End;

Function BLOCKSIZE:Integer;
Begin
   Result:=0;
   if (NBDiskConfigur[DiskNo].BSH=04) and (NBDiskConfigur[DiskNo].BLM=15) then
     Result:=2048;
   if (NBDiskConfigur[DiskNo].BSH=05) and (NBDiskConfigur[DiskNo].BLM=31) then
     Result:=4096;
End;

Function DISKSIZE:Longint;
Begin
   Result:= (NBDiskConfigur[DiskNo].DSM+1)*BLOCKSIZE;
End;

Function TRACKS:Byte;
Begin
   Result:= NBDiskConfigur[DiskNo].NoOfTracks;
End;

Function DIRECTORYENTRIES:Byte;
Begin
   Result:= NBDiskConfigur[DiskNo].DirEntries;
End;

Function TOTALALUS:Byte;
Begin
   Result:= NBDiskConfigur[DiskNo].DSM+1;
End;


Function GetOffsetBySdTrack(Sd:Byte;Track:Integer;Sector:Byte):Integer;
Begin
 //Sectors per Track =10
   case NBDiskFileType of
     dft80DS,dft40DS,dft80DS_NS:Begin
         Result:=(Track*2+Sd)*10*512;   //start of Track on side
         Result:=Result+Sector*512; //specific sector in track
     End;
     dft80SS,dft40SS:Begin
         Result:=Track*10*512;   //start of Track on side
         Result:=Result+Sector*512; //specific sector in track
     End;
   end;


  //Odd Tracks is side 1
  //Even Tracks is Side 0
  //total virtual tracks are 160 = 80 * 2 sides
End;

Function TNBDISCCtrl.GetFileType(fsz:Longint):TNBDiskFileType;
Begin
 Result:=dftNone;
 case fsz of
    819200,837632,839680,841728:Result:=dft80DS;
    204800,209920:Result:=dft40SS;
    409600:Result:=dft40DS;
 end;
 if result=dftNone then
   if fsz>800000 then
     result:=dft80DS_NS  //has multiple dir entries
   else
     Result:=dft80SS;
End;
                            {

Function GetOffsetByAlu(AluC:Integer):Integer;
Begin
  case NBDiskFileType of
    dft80DS:  Result:=10240+Aluc*4096;
    dft40DS:  Result:=10240+Aluc*2048;
    dft80SS:  Result:=10240+Aluc*2048;
    dft40SS:  Result:=10240+Aluc*2048;
   // dft80DS_NS:Result:=$1e80+Aluc*4096;
   // dft80DS_NS:Result:=$2400+Aluc*4096;
    dft80DS_NS:Result:=$2200+Aluc*4096;
  end;


End;
         }
function AluSize:integer;
Begin
 result:=4096;
  case NBDiskFileType of
    dft80DS:  Result:=4096;
    dft40DS:  Result:=2048;
    dft80SS:  Result:=2048;
    dft40SS:  Result:=2048;
    dft80DS_NS:Result:=4096;
  end;

End;

Function GetOffsetByAlu(AluC:Integer):Integer;
Begin
  dec(AluC);
  case NBDiskFileType of
                     //systracks+direntries+(ALU-1)*
    dft80DS:  Result:=10240+128*32+Aluc*AluSize;
    dft40DS:  Result:=10240+64*32+Aluc*AluSize;
    dft80SS:  Result:=10240+64*32+Aluc*AluSize;
    dft40SS:  Result:=10240+64*32+Aluc*AluSize;
    dft80DS_NS:Begin//non standard disks
                case DSKfs of
                  817664:  Result:=$2200+128*32+Aluc*AluSize;    //disk Basic-Misc Programmer (80DS)_hfe
                  816768:  Result:=$1e80+128*32+Aluc*AluSize;    //Assembler-A001 (80DS)_hfe
                  818176:  Result:=$2400+128*32+Aluc*AluSize;    //Misc-Programmer (80DS)_hfe
                  816128:  Result:=$1C00+128*32+Aluc*AluSize;    //System Disk-02 (80DS)_hfe
                end;
               End;
  end;
End;

Procedure GetSdTrackSecFromAlu(Aluc:integer;Var Sd:Byte;Var Track:Integer;Var Sector:Byte);
Var Offs,t:Integer;
Begin
  Offs:=GetOffsetByAlu(Aluc);
  t:=Offs div 512; //Offset Sectors
  Track:=Offs div 10; //Offset Track
  Sector:=t-(Track*10);
  if NBDiskFileType in [dft80DS,dft40DS,dft80DS_NS ] then
  Begin
    if track mod 2<>0 then
     Sd:=1
    else
     Sd:=0;
  End
  else
   sd:=0;
End;

function GetFileSize(const FileName : AnsiString) : LongInt;
var
  SearchRec : TSearchRec;
begin
  try
    if FindFirst(ExpandFileName(FileName), faAnyFile, SearchRec) = 0 then
      Result := SearchRec.Size
    else 
      Result := -1;
  finally
    SysUtils.FindClose(SearchRec);
  end;
end;

function GetFiles(path, mode : AnsiString; list : TStrings) : Boolean;
var
  SearchRec : TSearchRec;
begin
  // Επιστρέφει αρχεία η φακέλους από ένα path σε ένα StringList

  Result := False;
  if mode = 'Directory' then 
  begin
    FindFirst(path + '\*', faDirectory, SearchRec);
    FindNext(SearchRec);                   // Προσπερνά τις 2 τελείες (..)
    while FindNext(SearchRec) = 0 do 
    begin
      if (SearchRec.Attr and faDirectory) = faDirectory then
        // Ελέγχει αν είναι Κατάλογος
        list.Add(SearchRec.Name);
    end;
    Result := True;
  end 
  else if mode = 'Files' then 
  begin
    FindFirst(path + '\*.*', faAnyFile, SearchRec);
    FindNext(SearchRec);
    while FindNext(SearchRec) = 0 do
      if not ((SearchRec.Attr and faDirectory) = faDirectory) then
        // Ελέγχει αν δεν είναι Κατάλογος
        list.Add(SearchRec.Name);
    Result := True;
  end;
  FindClose(SearchRec);
end;

constructor TNBDISCCtrl.Create;
begin
  DirListA:= TStringList.create;
  DirListB:= TStringList.create;
  Dir1:='cpmmaster';
  CPMBASE:=$FFDC;
  CPMSlot:=7;
end;

destructor TNBDISCCtrl.Destroy;
begin
     Dir1:='';
     Dir2:='';
     DirListA.free;
     DirListB.free;
     inherited;
end;

procedure TNBDISCCtrl.DiskExtract(fn: Ansistring);
begin
   Forcedirectories(apppath+'Discs\'+fn);
   dir1:=fn;       //extract the old one and load the new
   if NBDiskFileType=dftNone then
   Begin
     try
      DeleteFile(AppPath+'Discs\'+fn+'.dsk');
     except

     end;
     try
      Removedir(apppath+'Discs\'+fn);
     except

     end;
      exit;
   End;


   Dir1:=''; //extract the new and select nothing
end;

procedure TNBDISCCtrl.CPMRead(Disk,Side:Byte;Track:Integer;Sector:Byte);
Var offs,k:Integer;
    Dest:Word;
begin
  Offs:=GetOffsetBySdTrack(Side,track,Sector);
  dest:=nbdisc.CBUFFER.w ;
  k:=0;
  Repeat
   nbmem.rom[dest+k]:=DiskBuf[Disk,Offs+k];
   inc(k);
   if k>SecSize-1 then exit;
  Until False;
end;

procedure TNBDISCCtrl.CPMWrite(Disk,Side:Byte;Track:Integer;Sector:Byte);
Var offs,k:Integer;
    Dest:Word;
begin
  Offs:=GetOffsetBySdTrack(Side,track,Sector);
  dest:=nbdisc.CBUFFER.w ;
  k:=0;
  Repeat
   DiskBuf[Disk,Offs+k]:=nbmem.rom[dest+k];
   inc(k);
   if k>SecSize-1 then exit;
  Until False;
end;



procedure TNBDISCCtrl.DoCommand;
begin
  res :=0;
  ODS('CMD='+inttostr(NBDisc.CCOMMAN));
  Case NBDisc.CCOMMAN of
   0:begin
      DoReset; // Reset
      Load;   //load 1st sector of drive
     End;
   1:Begin
       ODS('Command 1 - Reset Drives'); //ResetDrives  just recalibrates not needed
       //DoReset;
     end;
   5:Save; //Write
   6:Load; //Read
   7:ODS('Command 7 - Recalibrate');//Recalibrate //not used???
   13:ODS('Command 13 - Format track ');//Format Write $E5 to all sectors
   17:ODS('Command 17 - Verify');
   else
   Begin
    ODS('Unknown Command '+Inttostr(NBDisc.CCOMMAN));
    Res:=255;
   End;
  End;

  if NBDisc.CCOMMAN in [3,7,8,15,17] then
   ODS('[BREAK - BREAK]');
  

  Setresult(res);  //command executed
  ODSNbDisc;
end;

procedure TNBDISCCtrl.DoReset;
begin
 ODS('Disk Was Reset:'+inttostr(nbdisc.cdrive));
 NBDisc.CSECTOR:=0;
 NBDisc.CTRACK.w:=0;
 NBDisc.CSEEKRA:=0;
 NBDisc.CGAP:=42;
 NBDisc.CSECSIZ:=0;//512 bytes
 NBDisc.CSIDE:=0;
 NBDisc.CCOMMAN:=6;//Read
end;

procedure TNBDISCCtrl.ForceDir1(d: String);
begin
  FDir1:=d;
end;

procedure TNBDISCCtrl.GetReadyForCommand;
Var w:Word;
begin
     If not fnewbrain.WithExpansion1.Checked and
      fnewbrain.WithCPM1.checked then
     Begin
       npaged:=true;
       
     End
     else
     BEgin
       w:=nbmem.rom[$7a]*256+nbmem.rom[$79];
       if w=$9fcd then
       NPaged:=True
      Else
       NPaged:=False;
     End;

     NBDisc:=@nbmem.MainSlots[CPMSlot]^.Memory[$1FCD];

   SetResult(255); //Ready for command
end;

procedure TNBDISCCtrl.Load;
Var s:AnsiString;
begin
  DiskNo:=NBDisc.CDRIVE;
  TrackNO:=NbDisc.CTRACK.w;
  SectorNo:=NbDisc.CSECTOR;
  Side:=NbDisc.CSIDE;
  SecPerTrack:=10;
  Case NbDisc.CSECSIZ of
   0:SecSize:=512;
   1:SecSize:=1024;
   Else
    SecSize:=512;
  End;

  s:=Format('R D:%d Side: %d -Track : %d - Sector: %d',[DiskNo,Side,TrackNO,SectorNo]);
  fnewbrain.StatusBar1.Panels[1].text:=s;
  fnewbrain.StatusBar1.Repaint;
  ODS(s);
  //Sleep(500);

  s:='';
  if (Diskno=0) and (Dir1='') then
   S:='Error Disk A Empty'
  Else
  if (Diskno=1) and (Dir2='') then
   S:='Error Disk B Empty';

  if Sectorno>=SecPerTrack then
   s:='Error Sector NO>9';

  If s='' then
   CPMRead(DiskNo,Side,TrackNO,SectorNo)
  Else
  Begin
    //todo:Return error code
    res:=128;
    ODS(s);
    fnewbrain.StatusBar1.Panels[1].text:=s;
    fnewbrain.StatusBar1.Repaint;
  End;

end;


procedure TNBDISCCtrl.Save;
Var s:AnsiString;
begin
  DiskNo:=NBDisc.CDRIVE;
  TrackNO:=NbDisc.CTRACK.w;
  SectorNo:=NbDisc.CSECTOR;
  Side:=NbDisc.CSIDE;
  SecPerTrack:=10;
  Case NbDisc.CSECSIZ of
   0:SecSize:=512;
   1:SecSize:=1024;
   Else
    SecSize:=512;
  End;

  s:=Format('W D:%d Side: %d -Track : %d - Sector: %d',[DiskNo,Side,TrackNO,SectorNo]);
  fnewbrain.StatusBar1.Panels[1].text:=s;
  fnewbrain.StatusBar1.Repaint;
  ODS(s);
  s:='';

   if Sectorno>=SecPerTrack then
    s:='Error Sector NO>9';

  If s='' then
   CPMWrite(DiskNo,Side,TrackNO,SectorNo)
  Else
  Begin
    //todo:Return error code
    res:=128;
    ODS(s);
    fnewbrain.StatusBar1.Panels[1].text:=s;
    fnewbrain.StatusBar1.Repaint;
  End;
end;

procedure TNBDISCCtrl.MakeDir(Dir:AnsiString);
Var DirEntryNo:Integer;
    DirEnt:TDirEntryNormal;
    pth:AnsiString;
    Lastextent:byte;


    Procedure ReadDirEntry;
    Var offs:Integer;
        p:PAnsiChar;
        t:integer;
    Begin
     If DirEntryNo>128 then //too many entries
      Exit;
     Offs:=GetOffsetByAlu(0);
     offs:=Offs+DirEntryNo*32;
     p:=@DirEnt;
     For t:=0 to 31 do
      p[t]:=AnsiChar(DiskBuf[DiskNo,Offs+t]); //chnge
     Inc(DirEntryNo);
    End;

    Procedure SaveFile;
    Var f:File Of Byte;
        p:PAnsichar;
        tr:Integer;
        Fn:AnsiString;
        Offs,Sz:Integer;
        i:integer;
    Begin
      ForceDirectories(pth);
      Fn:=trim(Dirent.FName)+'.'+trim(Dirent.Ext);
      Offs:=GetOffsetByAlu(dirent.alu[0]);
      Assignfile(f,pth+Fn);
      if not fileexists(pth+Fn) then
      Begin
        lastextent:=0;
        ReWrite(F);
      End
      else
        Begin
          reset(f);
          Seek(f,FileSize(f));
        End;
      sz:=((Dirent.Extent-lastextent)*128*128)+(DirEnt.NoExtend*128);//+128;   //dsp1
      p:=@DiskBuf[DiskNo];
      BlockWrite(f,p[Offs],sz,tr);
      CloseFile(f);
      if DirEnt.NoExtend=$80 then
       lastextent:=Dirent.Extent+1
      else lastextent:=0;

    End;


Var i:integer;
begin
  pth:=AppPath+'Discs\'+Dir+'\';

  DirEntryNo:=0;
  lastextent:=0;
  For i:=0 to 128 do
  Begin
    ReadDirEntry ;
    if (i=0) then
    Begin
      if (dirent.Userno>2) or (dirent.FName[0]=#0) then
      Begin
        raise exception.Create('Invalid Image');
      end;
    end;
    if Dirent.Userno=$e5 then Break;
    SaveFile;
  End;
  DeleteFile(AppPath+'Discs\'+Dir+'.dsk');
end;

procedure TNBDISCCtrl.MakeDisk(Dir: AnsiString);
Var FileList:tStringlist;
    i:integer;
    DirEntryNo,Alocs:Integer;
    DirEnt:TDirEntryNormal;
    pth:AnsiString;

    Procedure LoadFile(Fn:AnsiString;Offs,sz:Integer);
    Var f:File Of Byte;
        p:PAnsichar;
        tr:Integer;
    Begin
      {$I-}
       AssignFile(F, Fn);
       FileMode := 0;  {Set file access to read only }
       Reset(F);
      {$I+}

      p:=@DiskBuf[DiskNo];
      BlockRead(f,p[Offs],sz,tr);
      CloseFile(f);
       FileMode := 2;
    End;

    Procedure WriteDirEntry;
    Var offs:Integer;
        p:PAnsiChar;
        t:integer;
    Begin
     If DirEntryNo>128 then //too many entries
      Exit;
     Offs:=GetOffsetByAlu(0);
     offs:=Offs+DirEntryNo*32;
     p:=@DirEnt;
     For t:=0 to 31 do
      DiskBuf[DiskNo,Offs+t]:=Byte(p[t]);
     Inc(DirEntryNo);
    End;

    Procedure AddEntry(fn:AnsiString);
    Var fsz:Integer;
        StartAloc,EndAloc:Integer;
        Offs:integer;
        p:PAnsichar;
        Fname:AnsiString;
        Ext:AnsiString;
        t:integer;
        VSZ:integer;
        Pass:Integer;
        Blocks:Integer;
        OverSpil:Integer;
        RC:Integer;
        LastEX:byte;
    Begin
      If Alocs>TOTALALUS then exit; //Disk Full 197

      fSz:=GetFileSize(pth+Dir+'\'+fn);
      if fsz=-1 then exit;

      Pass:=0;
      OverSpil:=0;
      LastEX:=0;
     repeat
      vsz:=BLOCKSIZE*16; //128     4096*128 for 80DS 4 * (16384 each extent) on 80DS
      p:=@DirEnt;
      For t:=0 to 31 do
       p[t]:=AnsiChar(0);

      StartAloc:=Alocs;

      vsz:=math.Min(Integer(Fsz),Integer(vsz));
      If (vsz>ALUSIZE) then
      Begin
            Alocs:=Alocs+vsz div ALUSIZE;
            If vsz mod ALUSIZE=0 then
             Dec(Alocs);
      End;
      EndAloc:=Alocs;

      Inc(Alocs);
      if pass=0 then
      Begin
       Offs:=GetOffsetByAlu(StartAloc);
       if Offs+fsz>sizeof(TnbDisc)-1 then
       Begin
        Alocs:=StartAloc;
        Exit;
       End;
        //Done:Load File At Offs
        LoadFile(pth+Dir+'\'+fn,Offs,Fsz);
      End;

      //Fill DirEntryStruct
      DirEnt.Userno:=0;
      t:=Pos('.',fn);
      If t>0 then
      Begin
        Fname:=Copy(fn,1,t-1);
        Ext:=Copy(fn,t+1,maxint);
      End
      Else
      Begin
        fname:=fn;
        ext:='';
      End;

      For t:=1 to 8 do
       if t<=Length(fname) then
        DirEnt.FName[t-1]:=fname[t]
       Else
        DirEnt.FName[t-1]:=' ';
      For t:=1 to 3 do
       If t<=Length(ext) then
        DirEnt.Ext[t-1]:=ext[t]
       Else
        DirEnt.Ext[t-1]:=' ';

      If sametext(DirEnt.Ext,'CPM') then
         DirEnt.Ext:='COM';
      DirEnt.No13:=0;
      DirEnt.No14:=0;
      Blocks:=vsz div 128;
      if vsz mod 128<>0 then
        Blocks:=Blocks+1;


      If Blocks>$80 then //means >16384=1 extend
      Begin
        OverSpil:=Blocks div $80; //how many extends
        RC:=Blocks-(Overspil*$80); //how many remain
        If (RC mod $80=0) then
        Begin
//         if (vsz=BLOCKSIZE*$80)  then         
          RC:=$80;
          Dec(OverSpil);
        End;
      End
      else
       Begin
         Overspil:=0;
         RC:=Blocks;
       End;



      DirEnt.Extent:=LastEX+Overspil;
      DirEnt.NoExtend:=RC;
      if Blocks>$80 then
        LastEX:=LastEX+OverSpil+1;
      For t:=0 to 15 do
       DirEnt.ALU[t]:=0;
      For t:=StartAloc to EndAloc do
      Begin
        DirEnt.ALU[t-StartAloc]:=t;
      End;
      //Done:WriteToDirEntry;
      WriteDirEntry;
      Fsz:=Fsz-vsz;
      inc(pass);
     Until fsz<=0;
    End;

    Procedure LoadSyStem;
    Var
        f:File Of Byte;
        t:Integer;
    Begin
     if NBDiskFileType=dft80DS then
     Begin
       AssignFile(F,pth+'System.Dsk');
       Reset(f);
       BlockRead(f,DiskBuf[DiskNo],10240,t);
       CloseFile(f);
     End;
    End;
Begin
  pth:=AppPath+'Discs\';
  Alocs:=1;
  NBDiskFileType:=dft80DS;//NB EMULATOR FILETYPE
  DirEntryNo:=0;
  //0.done: fill buff with $e5
  For i:=0 to 819200 do
    DiskBuf[DiskNo,i]:=$E5;

  //LoadSystem
  LoadSystem;
  NBDiskConfigur[DiskNo]:=@DiskBuf[DiskNo];

  //1.Get Directory Files
  FileList:=tStringlist.Create;
  GetFiles(pth+Dir,'Files',FileList);
  If (Filelist.count=0) then
  begin
    if FileExists(pth+Dir+'.dsk') then
      ReadDisk(pth+Dir+'.dsk')
    else
    if FileExists(pth+Dir+'.img') then
      ReadDisk(pth+Dir+'.img');
  end;


 //2.Make Directory and Put Files
  For i:=0 to Filelist.count-1 do
   AddEntry(Uppercase(Filelist[i]));

  For i:=0 to Filelist.count-1 do
   DeleteFile(pth+Dir+'\'+Filelist[i]);

 if diskno=0 then
  DirListA.Assign(Filelist)
 else
  DirListB.Assign(Filelist);

 Filelist.free;
 WriteDisk(pth+Dir+'.dsk');
End;



procedure TNBDISCCtrl.ReadDisk(nm:AnsiString);
Var f:File OF Byte;
Begin
  AssignFile(f,nm);
  ReSet(f);
  DSKfs:=filesize(f);
  NBDiskFileType:=GetFileType(DSKfs);
  BlockRead(f,DiskBuf[DiskNo],DSKfs);
  CloseFile(f);
  NBDiskConfigur[DiskNo]:=@DiskBuf[DiskNo];
  if NBDiskFileType=dftNone then
   showmessage('Unknown disk format or damaged image!!!');

End;


procedure TNBDISCCtrl.SaveNewSystem(SysNm:AnsiString);
Var
        f:File Of Byte;
        t:Integer;
        pth:AnsiString;
Begin
   pth:=AppPath+'Discs\';
   AssignFile(F,pth+SysNm);
   ReWrite(f);
   BlockWrite(f,DiskBuf[DiskNo],10240,t);
   CloseFile(f);
end;

procedure TNBDISCCtrl.SetDir1(const Value: Ansistring);
begin
     if FDir1 <> Value then
     begin
          DiskNo:=0;
          If Fdir1<>'' then
           MakeDir(Fdir1);
          FDir1 := Value;
          If Fdir1<>'' then
           MakeDisk(FDir1);
     end;
end;

procedure TNBDISCCtrl.SetDir2(const Value: Ansistring);
begin
     if FDir2 <> Value then
     begin
          DiskNo:=1;
          If Fdir2<>'' then
           MakeDir(Fdir2);
          FDir2 := Value;
          If Fdir2<>'' then
           MakeDisk(FDir2);
     end;
end;

procedure TNBDISCCtrl.SetNPaged(Value: Boolean);
begin
          FNPaged := Value;
          If Value then
          Begin
            CPMBASE:=$9FDC;
            CPMSlot:=4;
          End
          Else
          Begin
            CPMBASE:=$FFDC;
            CPMSlot:=7;
          End;
end;

procedure TNBDISCCtrl.SetResult(Val:Byte=255);
Begin
  NBMEM.ROM[CpmBase]:=Val; //offset 15 result
End;

procedure TNBDISCCtrl.WriteDisk(nm:AnsiString);
Var f:File OF Byte;
Begin
  AssignFile(f,nm);
  Rewrite(f);
  BlockWrite(f,DiskBuf[DiskNo],819200);
  CloseFile(f);
End;


end.
