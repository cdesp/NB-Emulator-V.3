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
uses uNBTypes,classes,upccomms,uNBCassette;



{$i 'dsp.inc'}

Const
   CASSCOM=$80;
   CASSLOD=$8C;
   PASSCOM=$90;
   DISPCOM=$A0;
   TIMCOM =$B0;
   PDNCOM =$C0;
   NULLCOM=$D0;
   RESCOM =$F0;

   BRKBIT =$04;
   REGINT =$00;        //copstatus bits here
   CASSERR=$10;
   CASSIN =$20;
   KBD    =$30;
   CASSOUT=$40;

   PLAYBK=4;
   RECRD=0;

Type
//  TNBDevice=(NBUnknown,NBTape1,NBTape2,NBPrn,NBComm);
  TTapeStatus=(TSNone,TSstart,TSCountL,TSCountH,TSBlock,TSType,TSChkL,TSChkH);

  TTapeBlock=record
     Start:byte;
     Count:smallint;
     TPType:byte;
     chksum:smallint;
  end;

  TCop420=Class

  private
      FFilename: String;
      Tapestatus:TTapeStatus;
      Tapeblock:TTapeBlock;
      vfbuf:string;
      NextCopOutIsData:boolean;
      NextCopInIsData:boolean;
      TapeCounter:Integer;
      Cass1:TNBCassette;
      Cass2:TNBCassette;
      procedure OpenPrinter;
      procedure WritePrinter(b:Byte);
    procedure SetCopReady;
    function CheckFileEnd: Boolean;
    function getFileName: String;
    procedure DeleteNoName;
      procedure SetFilename(Value: String);
    function CheckReadEOF:boolean;
    function FindFileName: string;
    procedure DoWriteCopByte(Value: Byte);

  public
      CassError:boolean;
      LastCopCommand:Byte;
      CopBytesToRead: Integer;
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
      procedure DoResetTape;
      procedure DoCopCommand(Value: Byte);
      function GetFromCop: Byte;
      procedure CloseComm;
      procedure OpenComm(ToRead:boolean=false);
      function ReadComm: Byte;
      procedure TranslateBuffer;
      procedure Writecomm(b:Byte);
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

function TCop420.CheckReadEOF:boolean;
Begin
 result:=false;
    if size=comcnt then
    Begin
     if size>0 then
      closecomm;
     comcnt:=0;
     size:=0;
     loading:=false;
     result:=true;
     if not Tapeinfo.TapeLoaded then
      FileName:='Noname';
    End;
End;


procedure TCop420.DoResetTape;
Begin
  try
    CassError:=false;
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
  except
    CassError:=true;
    commOpened:=false;
  end;
  ResetTape:=false;
End;

function TCop420.GetFromCop:Byte;
Var DoBreak:Boolean;

    procedure filegetbyte;
    begin
   //get 1 byte
      try
        result:=ReadComm;
       {$IFDEF NBTAPEDEBUG}
       ODS('$'+inttohex(prepc)+' COP BYTE:'+inttostr(result)+' '+inttohex(result,2)+ ' ['+ inttohex(nbio.EnableReg)+']');
       {$ENDIF}
      except
      end;
    end;

    procedure KBgetbyte;
    begin
      if nbio.kbint then
      begin
            nbio.kbint:=false;
            result:=nbio.keypressed;
            nbio.KeyPressed:=$80;
            if DoBreak then
             nbio.BrkPressed:=false;
            exit;
      end;
    end;


  procedure getInterruptVector;
  var i:integer;
  begin
     {$IFDEF NBDEBUG}
     ODS('*********Int VECTOR**********');
     {$ENDIF}

     //BREAK KEY HANDLER
     if nbio.brkpressed then
     Begin
       result:=result or BRKBIT;
       nbio.brkpressed:=false;
       exit;
     end;

     //TAPE ERROR HANDLER
     if Loading and CassError then
     begin
       result:=CASSERR;
       exit;
     end;

     //KEYBOARD HANDLER
     //this is special case casue the screen is enabled so we give data too
     if nbio.KBStatus=SendKey then //after loop read the real key
     Begin
       nbio.KBStatus:=NoKey;
       KBgetbyte;
     end
     else if nbio.KBStatus=SigKey then //NB expects byte dif from $80  to leave the loop
     begin
       Result:=$85; //just to leave the loop
       nbio.KBStatus:=SendKey;
     end
     else
     if nbio.kbint then
     begin
       nbio.KBStatus:=SigKey;   //signal cop has a key
       result:=result or KBD;     //3X means kbd int
     end;

     //TAPE HANDLER
     if cop420.Loading then
     begin
       result:=CASSIN or (cop420.LastCopCommand and $f)   //0
     end;

     if cop420.Saving then
      result:=result or CASSOUT;
  end;

  procedure getData;
  var i,t:integer;
  begin
     {$IFDEF NBDEBUG}
     ODS('*********GETDATA**********');
     {$ENDIF}

     if cop420.Loading then
     begin
        filegetbyte;
        NextCopInIsData:=false;
        case TapeStatus of
          TSstart:begin Tapeblock.Start:=Result;TapeStatus:=TSCountL;end;
          TSCountL:begin Tapeblock.Count:=Result;TapeStatus:=TSCountH;end;
          TSCountH:begin Tapeblock.Count:=Tapeblock.Count+Result*256;TapeStatus:=TSBlock;end;
          TSBlock:begin
                   Tapeblock.Count:=Tapeblock.Count-1;
                   if Tapeblock.Count=0 then
                      TapeStatus:=TSType;
                  end;
          TSType:begin Tapeblock.TPType:=Result;TapeStatus:=TSChkL;end;
          TSChkL:begin Tapeblock.chksum:=Result;TapeStatus:=TSChkH;end;
          TSChkH:begin
                   Tapeblock.chksum:=Tapeblock.chksum+Result*256;
                   TapeStatus:=TSNone;
                   Loading:=False;  //block loaded
                   t:=result;
                   for i := 1 to 9 do  //read 9 zeroes
                       filegetbyte;
                   Result:=t;
                 end;
        end;

     end;

  end;


begin
  result:=$0;

  if (nbio.EnableReg shr 4 <> 0) or (prepc=$E255) or NextCopInIsData then
          getData
  else
  begin
    getInterruptVector;
    if TapeStatus<>TSNone then
     NextCopInIsData:=true;
  end;


  {$IFDEF NBDEBUG}
   ODS('$'+inttohex(prepc)+' COP IN:'+inttostr(result)+' ('+inttohex(result,2)+ ') ENREG=['+ inttohex(nbio.EnableReg)+']');
  {$ENDIF}


  exit;
end;


//this is a byte that cop needs to write somewhere (tape or vf)
procedure TCop420.DoWriteCopByte(Value:Byte);
var s:char;
begin
   if saving  then //write a byte to file
   begin
     Writecomm(value);
     NextCopOutIsData:=false;
     exit;
   end;

   If (LastCopCommand=$A0) and (Length(vfbuf)<18)   then
   Begin
     s:=chr(Value);
     vfbuf:=s+vfbuf;
     {$IFDEF NBDEBUG}
     ODS('COP DISP INP '+inttostr(Value));
     {$ENDIF}

     Exit;
   End
   else
   begin
     nbscreen.PaintLeds(vfbuf);       //Refresh vf disp
     LastCopCommand:=$80;
     NextCopOutIsData:=false;
     {$IFDEF NBDEBUG}
     ODS('VFBUF= '+vfbuf)
     {$ENDIF}
     ;
     exit;
   end;


    {$IFDEF NBDEBUG}
     ODS('??????LOST OUT '+inttohex(LastCopCommand)+' Value:'+inttostr(value) )
    {$ENDIF}
end;

procedure TCop420.DoCopCommand(Value:Byte);
var CopCMD:Byte;
    CopData:Byte;
    TapeNo:Byte;
    s:String;
begin


  if NextCopOutIsData then
  begin
    {$IFDEF NBDEBUG}
     ODS('COP Write Byte '+inttostr(Value));
    {$ENDIF}
    DoWriteCopByte(value);
    exit;
  end
  else
  begin
    {$IFDEF NBDEBUG}
     ODS('COP Command Byte '+inttohex(Value)+' ENREG='+inttohex(nbio.EnableReg));
    {$ENDIF}

  end;


  CopCMD := value shr 4;   //Hi 4 bits
  CopData := value and $0F; //low 4 bits

  case CopCMD of
     $08: //CASSCOM
         begin
           {$IFDEF NBDEBUG}
            s:='CASSCOM'+'  ENREG:'+inttohex(nbio.EnableReg);//CASSCOM      1
           {$ENDIF}
           if  CopData and $08 = $08  then // TAPE 1 Command
            TapeNo:=1
           else
            if  CopData and $02 = $02  then // TAPE 2 Command
             TapeNo:=2
           else
           begin
              ODS('TAPE CMD:'+inttohex(CopData));
              exit;
           end;

           {$IFDEF NBTAPEDEBUG}
             ODS('TAPE:'+inttostr(TapeNo));
           {$ENDIF}
           case TapeNo of
              1:Device:=NBTape1;
              2:Device:=NBTape2;
           end;
           if  CopData and PLAYBK = PLAYBK  then//Loading
           begin
              {$IFDEF NBDEBUG}
               s:='CASSLOAD'+'  ENREG:'+inttohex(nbio.EnableReg);//CASSCOM      1
              {$ENDIF}
              if not loading then
              Begin
               if ResetTape then
                 DoResetTape;
               Loading:=true;
               NextCopInIsData:=false;
               Tapestatus:=TSstart;
               TapeCounter:=0;
               try
                 CassError:=false;
                 Opencomm(true);
               except
                 CassError:=true;
               end;
               {$IFDEF NBTAPEDEBUG}
               ODS('----------------START LOADING----------------');
               {$ENDIF}
              End;
           end
           else if  CopData and RECRD = RECRD  then//Saving
           begin
             if not Saving then
             begin
               if ResetTape then
                 DoResetTape;
               saving:=true;
               NextCopOutIsData:=false;
               Opencomm;
               Writecomm(0);
             end else NextCopOutIsData:=true;
           end;
         end;
     $09:{$IFDEF NBDEBUG} s:='PASSCOM'+' ENREG:'+inttohex(nbio.EnableReg)  {$ENDIF}; //PASSCOM
     $0A: //DISPCOM
         begin
           {$IFDEF NBDEBUG}
           s:='DISPCOM '+' ENREG:'+inttohex(nbio.EnableReg); {$ENDIF} //DISPCOM      1 for vf display
           vfbuf:='';
           NextCopOutIsData:=true; //Cop will get 18 bytes
         end;
     $0B:    {$IFDEF NBDEBUG} s:='TIMCOM' {$ENDIF}; //TIMCOM       1
     $0C:    {$IFDEF NBDEBUG} s:='PDNCOM' {$ENDIF}; //PDNCOM
     $0D: //NULLCOM
         begin
           {$IFDEF NBDEBUG}
            s:='NULLCOM'+' ENREG:'+inttohex(nbio.EnableReg); {$ENDIF}
           if saving then
           begin
             closecomm;
             saving:=false;
           end;
         end;
     $0E0:    {$IFDEF NBDEBUG} s:='???COM' {$ENDIF};
     $0F0:    {$IFDEF NBDEBUG} s:='RESCOM' {$ENDIF}; //RESCOM
     else
      Begin
       {$IFDEF NBDEBUG}
       ODS('LastCop Cmd='+s+' '+inttostr(Value)); {$ENDIF}
       Exit;
      End;
  end; //end case

 {$IFDEF NBDEBUG}
   if value<>$0d0 then
    ods(s);
   {$ENDIF}

   LastCopCommand:=Value;

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
    result:=true;
//    Result := not loading and not saving;
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
