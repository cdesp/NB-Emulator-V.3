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

unit uNBIO;

interface
uses upccomms,classes;

{$i 'dsp.inc'}

type

   TKeybState=(NoKey,SigKey,SendKey);

  TNBInOutSupport=Class
  private
    KBStatus:TKeybState;//if true we send the data key
    ACIACtrlReg: Byte;
    PRNOutDataInt: Boolean;
    PRNDataBusInt: Boolean;//D4 in port 20 in
    lastRGclk:LongWord;
    lastRGcop:LongWord;
    LastCopCMD: Integer;
    FCopInt: Boolean;
    FClockInt: Boolean;
    LastDevice: TPCPort;
    ccc:Integer; //prt 6 variable kb
    vfbuf:String; //vf Buffer
    pn:Integer;
    minpn:Integer;
    lstick:Cardinal;
    MDloading:boolean;
    MDsaving:boolean;
    st:tStream;
    lsbyte:byte;
    procedure DoPort128Out(Value: Byte);
    procedure DoPort128_DP_Out(Value: Byte);
    procedure DoPort128_MP_Out(Value: Byte);
    procedure getregisters;
    procedure DoPort7Out(Value: Byte);
    function DoPort2In(Value: Byte): byte;
    function DoPort20In(Value: Byte): byte;
    procedure DoPort6Out(Value: Byte);
    function DoPort22In(Value: Byte): byte;
    function DoPort6In(Value: Byte): Byte;
    function DoPort4Out(Value: Byte): Byte;
    procedure DoPort2Out(Value: Byte);
    procedure DoPort255Out(Value: Byte);
    function DoPort24In(Value: Byte): Byte;
    procedure DoPort24Out(Value: Byte);
    procedure SetCopInt(Value: Boolean);
    procedure SetClockInt(Value: Boolean);
    function DoPort21In(Value: Byte): Byte;
    function DoPort12In(Value: Byte): Byte;
    procedure DoPort12Out(Value: Byte);
    function DoPort9In(Value: Byte): Byte;
    procedure DoPort9Out(Value: Byte);
    function DoPort8In(Value: Byte): Byte;
    procedure DoPort8Out(Value: Byte);
    procedure DoPort28Out(Value: Byte);
    procedure DoPort29Out(Value: Byte);
    procedure DoPort30Out(Value: Byte);
    procedure DoPort1Out(Value: Byte);
    procedure DoPort3Out(Value: Byte);
    function DoPort25In(Value: Byte): Byte;
    procedure DoPort25Out(Value: Byte);
    procedure DoPort5Out(Value: Byte);
    procedure DoPort23Out(Value: Byte);
    function DoPort23In(Value: Byte): Byte;
    procedure DoPort204Out(Value: Byte);
    function DoPort204In(Value: Byte): Byte;
    procedure DoPort205Out(Value: Byte);
    function DoPort205In(Value: Byte): Byte;
    procedure DoPort206Out(Value: Byte);
    function DoPort206In(Value: Byte): Byte;
    procedure DoPort207Out(Value: Byte);
    function DoPort207In(Value: Byte): Byte;
    function DoPort33In(Value: Byte): Byte;
    procedure DoPort33Out(Value: Byte);
    function DoPort44In(Value: Byte): Byte;
    procedure DoPort44Out(Value: Byte);

  public
    UserInt: Boolean;
    AciaInt: Boolean;
    ClkEnabled: Boolean;
    TVEnabled: Boolean;
    DoClock: Boolean;
    kbint: Boolean;
    KeyPressed: Byte;
    brkpressed: Boolean;
    DAC5: Integer;
    EnableReg:Byte;
    EnableReg2:Byte;
    LatchedParOut3:Byte;
    Procedure NBout(Port:Byte;Value:Byte);
    Function NBIn(Port:Byte):byte;
    constructor Create;
    function GetClock: LongWord;
    property CopInt: Boolean read FCopInt write SetCopInt;
    property ClockInt: Boolean read FClockInt write SetClockInt;
  End;


Var
       maxpn:Integer=1;
       NBIO:TNBInOutSupport=nil;
       overrideDev33page:integer=-1;
       overrideDev33addr:Integer=-1;
       overrideVidPg:integer=-1;

implementation
uses uNBMemory,uNBScreen,new,sysutils,jclLogic,z80baseclass,uNBCop,windows,uNBCPM,unbtypes;

constructor TNBInOutSupport.Create;
begin
     inherited;
     tvenabled:=false;
     aciaint:=false;
     KeyPressed:=$80;
     PRNDataBusInt:=false;//Centronics printer
     pn:=0;
     minpn:=1;
     lstick:=0;
     MDloading:=false;
     MDsaving:=false;
end;


procedure TNBInOutSupport.DoPort1Out(Value:Byte);
Begin
  ODS('Port 1 Out ='+inttostr(Value));
  EnableReg2:=Value;
  //If not prnOutData then

  PRNOutDataInt:= Testbit(Value,0); //D0=0

  PRNDataBusInt:= Testbit(Value,0); //D0=0

         
  //D0 0 enables Data bus Interrupt and Parallel latched Data out Interrupt (PRN)
  //D1 1 Enables adc conversion and calling indicator
  //D2 1 Enables Serial Receive Clock
  //D3 1 Enables 50Kbaud Serial Data Rate
  //D4 1 Enables Serial Receive Clock to sound output summer Ans serial input from PRN 0 serial input from comms
  //D5 1 enables second bank of of four analog inputs + sound
  //D6 1 enables serial transmit clock to sound ouput summer select serial ouput to the printer 0 to comms
  //D7 9th output bit for Centronics Printer Port
End;


procedure TNBInOutSupport.DoPort128Out(Value: Byte);
Begin
  if WithMicroPage then
     DoPort128_MP_Out(Value);
  if WithDataPack then
     DoPort128_DP_Out(Value);
end;


// MicroPage Support

procedure TNBInOutSupport.DoPort128_MP_Out(Value: Byte);
var a,v,b,d,h,p:integer;
    pgNo:Integer;
    is8k:Boolean;
begin

  v:= Value and $06;    //only bit 1 and bit 2
  //shift right v by 1
  v:=v SHR 1;

  if testbit(Value,3) then //check if it is Ram
   v:=3; //ram in slot 3

  ODS('SLOT ='+inttostr(v));
  case v of //v has the rom slot to fetch 4 slots max
    0:pgno:=118;    //Datapack Rom
    1:pgno:=116;    //Slot 1 ROM
    2:pgno:=114;    //Slot 2 ROM
    3:pgno:=112;    //Slot 3 ram
    Else
     pgno:=0;
     ;
  end;
  if pgno=0 then exit;


  is8k:=nbmem.is8k(pgno);

  if testbit(Value,7) then //check if itis 8krom
  Begin
    nbMem.SetPageInSlotForce(4,pgno);
    nbMem.SetPageInSlotForce(3,104); //old ram in 6/7
  end
  Else
  Begin
    nbMem.SetPageInSlotForce(4,pgno);
    if not is8k then
       inc(pgno);
    nbMem.SetPageInSlotForce(3,pgno);
  end;


end;

//DataPack Support
procedure TNBInOutSupport.DoPort128_DP_Out(Value: Byte);
var a,v,b,d,h,p:integer;
    pgNo:Integer;
    is8k:Boolean;
begin
  v:= Value and $06;    //only bit 1 and bit 2
  //shift right v by 1
  v:=v SHR 1;
  if testbit(Value,3) then //check if it is Ram
   v:=3; //ram in slot 3
  ODS('SLOT ='+inttostr(v));
  is8k:=false;
  case v of //v has the rom slot to fetch 4 slots max
    0:pgno:=118;    //Datapack Rom
    1:pgno:=116;    //Slot 1 ROM
    2:pgno:=114;    //Slot 2 ROM
    3:pgno:=112;    //Slot 3 ram
    Else
     pgno:=0;
     ;
  end;
  if pgno=0 then exit;
  is8k:=nbmem.is8k(pgno);
  if testbit(Value,7) then //check if itis 8krom
  Begin
    nbMem.SetPageInSlotForce(4,pgno);
    nbMem.SetPageInSlotForce(3,104); //old ram in 6/7
  end
  Else
  Begin
    nbMem.SetPageInSlotForce(3,pgno);
    if not is8k then
       inc(pgno);
    nbMem.SetPageInSlotForce(3,pgno);
  end;
end;


//PIBOX Support
//204 - 207 status
// PIBOX has 1 slot for EPROM SLOT 0
// AND 1 slot for RAM Slot 1
function TNBInOutSupport.DoPort204In(Value: Byte): Byte;
begin
   Result:=$00;
   ODS('Port 204 In =');
end;

procedure TNBInOutSupport.DoPort204Out(Value: Byte);
var a,v,pg:integer;
    is16k:Boolean;
begin
 // nbmem.PageEnabled:=true;
  ODS('Port 204 Out ='+inttostr(Value));
 // a:=z80_get_reg(Z80_REG_BC);
//  ODS('BC ='+inttohex(a,4));
//  a:=z80_get_reg(Z80_REG_DE);
//  ODS('DE ='+inttohex(a,4));
//  a:=z80_get_reg(Z80_REG_HL);
//  ODS('HL ='+inttohex(a,4));
//  a:=z80_get_reg(Z80_REG_AF);
//  ODS('AF ='+inttohex(a,4));

  Is16K:=TestBit(Value,7);
  v:=Value and 3;//Bit 0 and 1 Only
  case v  of
     0  :Begin  //EPROM
               //1  ... 0 0  16K EPROM (6/7/8/9)
            if IS16K then
            Begin
              nbMem.SetPageInSlotForce(3,116);   //1st block
              nbMem.SetPageInSlotForce(4,117);   //2nd block
            end
            Else
            Begin
             //0  ... 0 0  8K EPROM (8/9)
             nbMem.SetPageInSlotForce(4,116);   //ROM
             nbMem.SetPageInSlotForce(3,104);   //Default RAM
            End;
         end;
     3:Begin    //1  ... 1 1  8K RAM  (8/9 +6/7)
            if IS16K then     //16K RAM (8/9/6/7)
            Begin
              nbMem.SetPageInSlotForce(4,114);   //1st block
              nbMem.SetPageInSlotForce(3,115);   //2nd block
            end
            Else
            Begin
             //0  ... 1 1  8K RAM (8/9)
            // nbMem.SetPageInSlotForce(4,114);   //RAM
             nbMem.SetPageInSlotForce(4,113);   //ROM
             //z80_set_reg(Z80_REG_PC,$E000);//bypass delayed page in
             nbMem.SetPageInSlotForce(3,104);   //Default RAM
             fnewbrain.bootok:=false;
            End;

       end;
      Else
       pg:=0;
  end;
end;

function TNBInOutSupport.DoPort205In(Value: Byte): Byte;
begin
   Result:=$00;
   ODS('Port 205 In =');
end;

procedure TNBInOutSupport.DoPort205Out(Value: Byte);
begin
  ODS('Port 205 Out ='+inttostr(Value));
end;

function TNBInOutSupport.DoPort206In(Value: Byte): Byte;
begin
   Result:=$00;
   ODS('Port 206 In =');
end;

procedure TNBInOutSupport.DoPort206Out(Value: Byte);
begin
    ODS('Port 206 Out ='+inttostr(Value));
end;

function TNBInOutSupport.DoPort207In(Value: Byte): Byte;
begin
   Result:=$00;
   ODS('Port 207 In =');
end;

procedure TNBInOutSupport.DoPort207Out(Value: Byte);
begin
   ODS('Port 207 Out ='+inttostr(Value));
end;

//PIBOX Support End

var copready:boolean=false;

//Read COP Status
function TNBInOutSupport.DoPort20In(Value: Byte): byte;

Begin

  result:=0;


  //bit 0

  // 11 =  Not call Ind
  If TestBit(EnableReg,7) and
     TestBit(EnableReg,6) then
    if not dmCommd.CanReadFromCom then //if we dont have a byte to read
      result:=1; //set bit 0

  // 10 = Tape In
  if TestBit(EnableReg,7) and //bit 7 set
     Not TestBit(EnableReg,6) //bit 6 not set
  then       // tape in
   if not cop420.Loading then
     result:=1;

  // 01= 40/80
  if not TestBit(EnableReg,7) and //bit 7 not set
     TestBit(EnableReg,6) //bit 6  set
  then       //Chars per tv
  //todo:get it
     result:=1; //1=40 chars 0=80 chars

  // 00 = Excess
  if not TestBit(EnableReg,7) and //bit 7 not set
     not TestBit(EnableReg,6) //bit 6 not set
  then       //Excess
     result:=1; //1=24 excess 0=4 excess

   EnableReg:=ClearBit(EnableReg,7);
   EnableReg:=ClearBit(EnableReg,6);

  //bit 1

  // 11 = Not Call Ind
  if TestBit(EnableReg,5) and //bit 5  set
     TestBit(EnableReg,4) //bit 4  set
  then       //Callind
  Begin
    If EnableReg2 and 1=1 then   //ACIA
     Result:=result or 2
    else
    if  not dmCommd.CanReadFromCom then
     Result:=result or 2; //set bit 1
  End;

  // 10 = Not Bee
  if TestBit(EnableReg,5) and //bit 5  set
     Not TestBit(EnableReg,4) //bit 4 not set
  then       //Bee
     result:=result or 2; // set =Processor Model A

  // 01= Tv Console
  if not TestBit(EnableReg,5) and //bit 5 not set
     TestBit(EnableReg,4) //bit 4 set
  then       //TvCnsl
   if tvenabled then
     result:=result or 2; // set = Pri Cons out is video

  // 00= Power Up
  if not TestBit(EnableReg,5) and //bit 5 not set
     not TestBit(EnableReg,4) //bit 4 not set
  then       //PwrUp For battery version
     ;//result:=result or 2; // NOT set = Power is supplied

   EnableReg:=ClearBit(EnableReg,5);
   EnableReg:=ClearBit(EnableReg,4);


 //rest bits 2-8
  result:=result or 4; //set =mains present


  If  not PRNOutDataInt then
   result:=result or 8 //  Centronics printer port interrupt if not set
  Else
    PRNOutDataInt:=PRNOutDataInt;

 { Userint:= PRNDataBusInt;

  if not userint then          //parallel Data bus port int if not set
   result:=result or 16   //User int if not set
  Else
    PRNDataBusInt:=PRNDataBusInt;}

  if copready then
    result:=result or 16; //cop ready
  copready:=not copready;

  if not clockint then
   result:=result or 32;//clock int if not set

  if not aciaint then
   result:=result or 64;//acia int if not set

  if not copint then
    result:=result or 128; //cop int if not set
  

 //  ENABLEREG:=TMP;
 // Result:=SetBit(result,0);   //Always bit 0 is 1
 // Result:=ClearBit(result,1); //Always bit 1 is 0 we dont have a battery

End;

function TNBInOutSupport.DoPort21In(Value: Byte): Byte;
Begin
  Result:=4+8+16+64;
End;

//read a byte from comm or tape
function TNBInOutSupport.DoPort22In(Value: Byte): byte;
var DE,DEhigh,PC:DWord;
Begin
  result:=0;
 //Communications port v24 and PRN and tape

 //Readonly in 22
 //0 Rec Data V24
 //1 CTS V24 (not)
 //2 -4 not used
 //5 Tape In
 //6 Not used
 //7 CTS Prn (not)

 DE:=z80_get_reg(Z80_REG_DE);
 PC:=z80_get_reg(Z80_REG_PC);
 DEhigh:=de shl 8;
 ODS(inttostr(DE));
 Value:=Enablereg;

 result:=result or 2;  //not CTS mean not ready   0 = ready
 result:=result or 128;  //not CTS prn

 if dmCommd.recv then
 begin

  if dmCommd.CanReadFromCom then
    result:= result or dmCommd.ReadFromComm
  else
    result:= result or 1;
  exit;
 End;
  if COP420.Loading then
   Result := result or $20;  //set bit 5

 if  TestBit(Value,4) and TestBit(Value,5) and ((DE=544) OR (PC=58630)) then   //port #9
 Begin
  result:= result - 2 ;  //UnSet Bit 1
  lastDevice:=pcpCom1;
 End;

 if  TestBit(Value,7) and (DE=32896) then         //port #8
 Begin
  result:= result - 128; //UnSet bit 7
  lastDevice:=pcpPrn;
 End;

 {if fnewbrain.bootok then
 Begin
  cop420.StartCommInput:=true;
  cop420.Device:=NBUnknown;
 End;
  }
 ODS('Port 22 ='+inttostr(result));
// OutputdebugString(Pchar('Port 22 ='+inttostr(result)));
End;

function TNBInOutSupport.DoPort23In(Value: Byte): Byte;
Begin
   Result:=$00;
   ODS('Port 23 In =');
End;

//Control Reg ACIA
procedure TNBInOutSupport.DoPort23Out(Value:Byte);
Begin
  ODS('Port 23 Out ='+inttostr(Value)+' Control Reg ACIA');
End;

//Control Reg ACIA
function TNBInOutSupport.DoPort24In(Value: Byte): Byte;
Begin
  //Result:=ACIACtrlReg;

   ODS('Port 24 In ='+inttostr(Value)+'   '+inttostr(ACIACtrlReg)+' Control Reg ACIA');
  //case  EnableReg2
  Result:=0;
  Result:=SetBit(Result,0); //RDRF
  Result:=SetBit(Result,1); //TDRF
  Result:=SetBit(Result,2); //DCD
  Result:=SetBit(Result,3); //CTS
//  Result:=SetBit(Result,4); //FE
//  Result:=SetBit(Result,5); //OVRN
//  Result:=SetBit(Result,6); //PE
End;

//Control Reg ACIA
procedure TNBInOutSupport.DoPort24Out(Value:Byte);
Begin
  ACIACtrlReg:=Value;
  ODS('Port 24 Out ='+inttostr(Value)+'   '+inttostr(ACIACtrlReg)+' Control Reg ACIA');
End;

//Page OS Control
procedure TNBInOutSupport.DoPort255Out(Value: Byte);
Var bc:Word;
    b,c:Byte;
    s:String;

Begin
 //pAGING

   s:='PAGE CMD-->';
   bc:=z80_get_reg(Z80_REG_BC);
   b:=Byte(bc Shr 8);
   c:=Byte(bc And $00FF);    //Not Used
   if Value And 1=1 then
     nbmem.PageEnabled:=true //pagememon
   else
     nbmem.PageEnabled:=false;
   If value And 4=4 then
     nbmem.AltSet:=true //Turntoalt
    Else
     nbmem.AltSet:=False;

//-------- fOR dISCS

   If B And 2=2 then
   Begin
    if Value And 128=128 then //Disc IO
    Begin
      NBDiscCtrl.GetReadyForCommand;
    End
    Else
    if Value And 32=32 then //Disc IO
    Begin
      NBDiscCtrl.DoCommand;
    End;
   End;// if b and 2

  {$IFDEf NBPgDebug}
// FOR DEBUGGING
   if nbmem.PageEnabled then
    s:=s+'PageEnabled'
   Else
    s:=s+'PageDisabled';
   if nbmem.altset then
    s:=s+' - Set Alt Slots'
   Else
    s:=s+' - Set Main Slots';

   ODS(s);
   //b has one of the following
   //EXPANSION	EQU 00000001B
   //DISCCONTROLLER	EQU 00000010B
   //NETWORKCONTROL	EQU 00000100B
   //ALLPERIPHERALS	EQU 11111111B
  {$ENDIF} 
End;

//Control Reg ACIA
function TNBInOutSupport.DoPort25In(Value: Byte): Byte;
Begin
   ODS('Port 25 In ='+inttostr(Value)+' Control Reg ACIA');
End;

//Control Reg ACIA
procedure TNBInOutSupport.DoPort25Out(Value:Byte);
Begin

  ODS('Port 25 Out ='+inttostr(Value)+' Control Reg ACIA');
  //This is Where the bytes come for
  //print#16,nn
  //We must Resend them to the Selected printer Device
  dmCommd.PrinterSend(Value);
End;

//Ch0 CTC
procedure TNBInOutSupport.DoPort28Out(Value:Byte);
Begin
 ODS('Port 28 Out Ch0 CTC ='+inttostr(Value));
End;

//Ch1 CTC
procedure TNBInOutSupport.DoPort29Out(Value:Byte);
Begin
 ODS('Port 29 Out Ch1 CTC='+inttostr(Value));
End;

function TNBInOutSupport.DoPort2In(Value: Byte): byte;
begin
  ODS('Port 2 In ='+inttohex(Value,4));
  Result:=255;
end;

//page OS Setting pages to slots
procedure TNBInOutSupport.DoPort2Out(Value: Byte);
Var bc:Word;
    b,c:Byte;
    slt:Integer;
    pg:Integer;
    alt:Boolean;
    IsRom:Boolean;  //Not USed
    s:string;
Begin
   bc:=z80_get_reg(Z80_REG_BC);
   b:=Byte(bc Shr 8);
   c:=Byte(bc And $00FF); //Not Used

   if b and $10=$10 then
    Alt:=true
   Else
    Alt:=False;
   if b and $8=$8 then
    isRom:=True           //Not Used
   else
    isRom:=False;         //Not used

   slt:=b div $20;
   pg:=Value;


   nbmem.SetPageInSlot(slt,pg,Alt);
//   s:='';
//   if alt then
//        s:='Alt';
//    ODS('Slot:'+inttostr(slt)+' page:'+inttostr(pg)+' '+s);
End;

//Ch2 CTC
procedure TNBInOutSupport.DoPort30Out(Value:Byte);
Begin
  ODS('Port 30 Out Ch2 CTC='+inttostr(Value));
End;

procedure TNBInOutSupport.DoPort3Out(Value:Byte);
Begin
  ODS('Port 3 Out ='+inttostr(Value));
  LatchedParOut3:=Value;
End;

//An out here clears clock interrupt
function TNBInOutSupport.DoPort4Out(Value: Byte): Byte;
Begin
  InterruptServed:=true;
  result:=0;
  ClockInt:=false;
End;

procedure TNBInOutSupport.DoPort5Out(Value:Byte);
Var RVal:Byte;
Begin
 DAC5:=Value;
// Reverse Value and send to printer // Open#22,22
 RVal:=ReverseBits(Value);
 dmCommd.PrinterSend(RVal);
 If Rval=13 then
  dmCommd.PrinterSend(10);
End;


function TNBInOutSupport.DoPort6In(Value: Byte): Byte;
Var DoBreak:Boolean;

    procedure filegetbyte;
    begin
   //get 1 byte
      try
        result:=cop420.ReadComm;
       // ODS('$'+inttohex(prepc)+' COP BYTE:'+inttostr(result)+' '+inttohex(result,2)+ ' ['+ inttohex(EnableReg)+']');
      except
      end;
    end;

    procedure KBgetbyte;
    begin
      if kbint then
      begin
            kbint:=false;
            result:=keypressed;
            KeyPressed:=$80;
            if DoBreak then
             BrkPressed:=false;
//            cop420.CopBytesToRead:=cop420.CopBytesToRead-1;
//            if cop420.CopBytesToRead=0 then
//              cop420.CopState:=NewCMD;
            exit;
      end;
    end;

const
  BRKBIT =$04;
  REGINT =$00;        //copstatus bits here
  CASSERR=$10;
  CASSIN =$20;
  KBD    =$30;
  CASSOUT=$40;


  procedure getInterruptVector;
  var i:integer;
  begin
     if brkpressed then
     Begin
       result:=result or BRKBIT;
       brkpressed:=false;
       exit;
     end;

     if cop420.Loading and cop420.CassError then
     begin
       result:=CASSERR;
       exit;
     end;

     if cop420.Loading and (cop420.LastCopCommand=DISPCOM)  then
     begin
       //ODS('-----------DISPLAY COMMAND----------------');
       result:=REGINT or (cop420.LastCopCommand and $f);//cassin
       if NBMEM.rom[$3b]=$8C then //should be $A0 or else we loose 2 zero bytes  WHYYYYYY?
       begin //this is a workaround not a fix
         i:=COP420.ReadComm;
       //  ODS('$'+inttohex(prepc)+'*COPNBYTE:'+inttostr(i)+' '+inttohex(i,2));
         i:=COP420.ReadComm;
       //  ODS('$'+inttohex(prepc)+'*COPNBYTE:'+inttostr(i)+' '+inttohex(i,2));
       end;

       exit;
     end;

     //this is special case casue the screen is enabled so we give data too
     if KBStatus=SendKey then //after loop read the real key
     Begin
       KBStatus:=NoKey;
       KBgetbyte;
     end
     else if KBStatus=SigKey then //NB expects byte dif from $80  to leave the loop
     begin
       Result:=$85; //just to leave the loop
       KBStatus:=SendKey;
     end
     else
     if kbint then
     begin
       KBStatus:=SigKey;   //signal cop has a key
       result:=result or KBD;     //3X means kbd int
     end;

     if cop420.Loading then
     begin
       result:=CASSIN or (cop420.LastCopCommand and $f)   //0
     end;

     if cop420.Saving then
      result:=result or CASSOUT;
  end;

  procedure getData;
  begin
     if (cop420.LastCopCommand=DISPCOM) then
     begin
       // ODS('-----------DISPLAY COMMAND 2----------------');
     end;

     if cop420.Loading then
           filegetbyte;

  end;

  //for regint
   //bit 0 = timer0
   //bit 1 = power low
   //bit 2 = Brk
   //bit 3 = resp
   //bits 0-2 goes to Copst

Begin
  InterruptServed:=true;
  copint:=false;
  result:=$0;

  if (enablereg shr 4 <> 0) then
          getData
  else  getInterruptVector;


  exit;


   if cop420.Loading and cop420.CassError then
   begin
     result:=$10;
     exit;
   end;


  result:=$0;


  if (cop420.LastCopCommand=DISPCOM) and not cop420.loading then
  begin
   result:=result;// or 16 or 4; //set bit 5 and 3
   exit;
  end;

  if (cop420.LastCopCommand=DISPCOM)  and (enablereg shr 4 = 0) then
  begin
     ODS('-----------DISPLAY COMMAND----------------');
     result:=CASSIN or (cop420.LastCopCommand and $f); //;8;
     exit;
  end
  else  if (cop420.LastCopCommand=DISPCOM)  and (enablereg shr 4 <> 0) then
  begin
    ODS('-----------DISPLAY COMMAND 2----------------');
  end;

  if brkpressed then
  Begin
     result:=result or $4;
     brkpressed:=false;
     exit;
  end;

  if KBStatus=SendKey then //after loop read the real key
  Begin
    KBStatus:=NoKey;
    KBgetbyte;
  end
  else if KBStatus=SigKey then //NB expects byte dif from $80  to leave the loop
  begin
   Result:=$85; //just to leave the loop
   KBStatus:=SendKey;
  end
  else
  if kbint then
  begin
   KBStatus:=SigKey;   //signal cop has a key
   result:=result or KBD;     //3X means kbd int
  end;


  if cop420.Loading then
  begin
    if enablereg shr 4 = 0 then
         result:=$20 or (cop420.LastCopCommand and $f)   //0
    else
       filegetbyte;

    exit;
  end;

  if cop420.Saving then
   result:=result or 64;



  //for regint
   //bit 0 = timer0
   //bit 1 = power low
   //bit 2 = Brk
   //bit 3 = resp
   //bits 0-2 goes to Copst
{  if cop420.Loading then
   result:=result or 48;
  if cop420.Saving then
   result:=result or 64;}

End;

//Cop Communication mainly the vf display
//  tape loading , saving

var lastout:byte;
procedure TNBInOutSupport.DoPort6Out(Value: Byte);
Var oldcmd:Integer;
    s:String;
    cancelDISP:boolean;
Begin
   s:='';


   if cop420.saving and (enablereg shr 4 <> 0) then //write a byte to file
   begin
     Cop420.Writecomm(value);
     exit;
   end;

   if cop420.loading and (cop420.LastCopCommand=value) and (value=DISPCOM) then
   begin
    ODS('GET A BYTE?');
   end;


   oldcmd:=LastCopcmd;

  // if not ((lastout=DISPCOM) and (value=DISPCOM) and (length(vfbuf)=0)) then
  cancelDISP:= (lastout=DISPCOM) and (value<>32) and (Length(vfbuf)=0); //cancel dispcom



   If (cop420.LastCopCommand=$A0) and (Length(vfbuf)<18) and not cancelDISP  then
   Begin
     s:=chr(Value);
     vfbuf:=s+vfbuf;
     //ODS('COP DISP INP '+inttostr(Value));
     Exit;
   End;

   lastout:=value;
   Cop420.CheckCommand(oldcmd,Value);


   //when command is $80 casscom
   //when bit 0=1 is
   //when bit 1=1 is
   //when bit 2=1 is playback on
   //when bit 3=1 is


   LastCopcmd:=Value;

   case value of
   $080:Begin
    {$IFDEF NBDEBUG}
          s:='CASSCOM'+'  ENREG:'+inttohex(EnableReg);;//CASSCOM      1
     {$ENDIF}
        End;
   $08C:Begin  //Loading
       {$IFDEF NBDEBUG}
        s:='CASSLOD'+' ENREG:'+inttohex(EnableReg);   {$ENDIF}
        End;
   $090:    {$IFDEF NBDEBUG} s:='PASSCOM'+' ENREG:'+inttohex(EnableReg)  {$ENDIF}; //PASSCOM
   $0A0:Begin
       {$IFDEF NBDEBUG}
          s:='DISPCOM '+' ENREG:'+inttohex(EnableReg); {$ENDIF} //DISPCOM      1 for vf display
          vfbuf:='';
        End;
   $0B0:    {$IFDEF NBDEBUG} s:='TIMCOM' {$ENDIF}; //TIMCOM       1
   $0C0:    {$IFDEF NBDEBUG} s:='PDNCOM' {$ENDIF}; //PDNCOM
   $0D0:Begin

         if oldcmd<>$D0 then
         Begin
           nbscreen.PaintLeds(vfbuf);
         End;
           //Refresh vf disp
     {$IFDEF NBDEBUG}
         s:='NULLCOM'+' ENREG:'+inttohex(EnableReg); {$ENDIF}
        End;
   $0E0:    {$IFDEF NBDEBUG} s:='???COM' {$ENDIF};
   $0F0:    {$IFDEF NBDEBUG} s:='RESCOM' {$ENDIF}; //RESCOM
   else
    Begin
     //copint:=true;
    {$IFDEF NBDEBUG}
     ODS('LastCop Cmd='+s+' '+inttostr(Value)); {$ENDIF}
     LastCopcmd:=oldcmd;
     Exit;
    End;
   end;
   {$IFDEF NBDEBUG}
   if value<>$0d0 then
    ods(s);
   {$ENDIF}

End;

procedure TNBInOutSupport.DoPort7Out(Value: Byte);
  Procedure ReadAByte;
   Begin
     Inc(cop420.Bytes);
     cop420.ComBuf[cop420.bytes]:=Value;
     if cop420.bytes=12 then
     Begin
      cop420.StartCommInput:=false;
      cop420.Bytes:=0;
      cop420.TranslateBuffer;
     End;
   End;
Begin
 //if value<>14 then
  //ODS('port 7='+inttostr(value));
 if TestBit(Value,4) and TestBit(Value,5) then
  dmCommd.OpenComm(pcpcom1);

 if TestBit(Value,7)  then
  dmCommd.OpenComm(pcpPrn);
 //bit 4 is ~CTS bit 5 is comm port
 //bit 6 is not used
 //bit 7 is PRN
 if lastdevice<>pcpNone then
 Begin
   If not TestBit(Value,4) and TestBit(Value,5)  then
     dmCommd.readytoreceive(true)
   Else
   if (not TestBit(Value,2)) and not dmcommd.recv then   //bit 2 is tvenable
   Begin
     dmCommd.SendToComm(LastDevice,Value)
   End;
 End;

 if cop420.startCommInput then
 Begin
     //ReadAbyte;
 End;

 //model A
 EnableReg:=Value;
 if enablereg and 1=1 then //clock enable   =set bit 0
  clkenabled:=false
 else
  clkenabled:=true;

 if enablereg and 4=4 then //Tv Enable    = set bit 2
  TvEnabled:=true
 else
  TvEnabled:=false;

 if enablereg and 16=16 then //Not Clear For Sending     bit 4
 Begin
  fnewbrain.bootok:=true;
  nbmem.InitFDCMem;
 End;

 if enablereg and 32=32 then //Transmit data on modem port bit 5
 ;

 if enablereg and 128=128 then //Transmit data PRN     bit 7
 ;
End;

//Screen handling PORTS 8,9,12

PRocedure TNBInOutSupport.getregisters;

   procedure ODS2(a:String);
   Begin
     Outputdebugstring(Pchar(a));
   end;

Begin
  ODS2('PC='+Inttostr( z80_get_reg(Z80_REG_PC)));
  ODS2('AF='+Inttostr( z80_get_reg(Z80_REG_AF)));
  ODS2('HL='+Inttostr( z80_get_reg(Z80_REG_HL)));
  ODS2('BC='+Inttostr( z80_get_reg(Z80_REG_BC)));
  ODS2('DE='+Inttostr( z80_get_reg(Z80_REG_DE)));
  ODS2('IX='+Inttostr( z80_get_reg(Z80_REG_IX)));
  ODS2('IY='+Inttostr( z80_get_reg(Z80_REG_IY)));
  ODS2('BC2='+Inttostr( z80_get_reg(Z80_REG_BC2)));
End;

function TNBInOutSupport.DoPort8In(Value: Byte): Byte; //Sets 9th bit of video address counter
Begin
  result:=$FF;
End;

//If Tvaddress msb is set then we get an out here
// very rare so we don't implement yet
procedure TNBInOutSupport.DoPort8Out(Value:Byte);
Begin
  nbscreen.VIDEOMSB:=1;
End;

function TNBInOutSupport.DoPort9In(Value: Byte): Byte; //load first 8 bits of video address counter
Begin
  result:=$FF;
End;

//Out the TV address to video hardware
procedure TNBInOutSupport.DoPort9Out(Value:Byte);
Var GrPage:Integer;
Begin
  nbscreen.VideoAddrReg:=Value shl 7;   //on a 64 byte boundary so shl 7
  try
  //todo:This is not a good way to find the device 33 video ram page
   if nbmem.mainslots[3]^.Page=124 then
   Begin
    grpage:=nbmem.mainslots[5]^.Page;
    NBScreen.Dev33Page:=grpage;
   End;

   NBScreen.Dev33Page:=NBScreen.VIdeoPage;
   if overrideDev33page<>-1 then
       NBScreen.Dev33Page:=overrideDev33page;

   //inc(pn);
   //if pn=1 then

   TThread.Queue(nil, procedure
    begin
      Nbscreen.Paintvideo // safely call with thread info
    end);

  // sleep(nbdel);
  Except
  End;
  nbscreen.VIDEOMSB:=0;

End;

function TNBInOutSupport.DoPort12In(Value: Byte): Byte; //load video control reg
Begin
  result:=$FF;
End;

//Send the TVMODE Byte to Video Hardware
procedure TNBInOutSupport.DoPort12Out(Value:Byte);
Begin
 if nbmem.pageenabled then
  nbscreen.videopage:=nbmem.lastpage
 else
  nbscreen.videopage:=0;
// ODS('VidePg='+inttostr(nbscreen.videopage));
 nbscreen.TVModeReg:=Value;
End;

// Testing for NB Laptop
var dirsending:boolean=false;
var dirlist:TStringlist=nil;
var dirlin,dirch:integer;
var dirret:integer=255;
var selectedfile:string;

function TNBInOutSupport.DoPort33In(Value: Byte): Byte; //MY DEV DRIVER
var b:byte;
Begin
 b:=0;
 if not MDloading then
 begin
   MDloading:=true;
   st:=TFileStream.Create('.\discs\games2\'+selectedfile,
                  fmOpenRead);
 end;
 if st.Position<st.Size then
   st.Read(b,1);

 if ((lsbyte=4) and (b=13)) or (st.position=st.size) then
  Begin st.Free;st:=nil;MDloading:=false;end;
 lsbyte:=b;
 result:=b;
End;

procedure TNBInOutSupport.DoPort33Out(Value:Byte);   //MY DEV DRIVER
Begin
  if not MDsaving then
  Begin
    MDsaving:=true;
    st:=TFileStream.Create('.\discs\games2\test2.bas',
                  fmCreate or fmOpenWrite);
  End;
  st.Write(value,1);
End;

//Send the directory files byte by byte
function TNBInOutSupport.DoPort44In(Value: Byte): Byte; //MY DEV DRIVER
var b:byte;
    s:string;
Begin
 if dirret<>255 then
 Begin
   result:=dirret;
   dirret:=255;
   exit;
 End;

 if dirlist=nil then dirlist:=tstringlist.Create;

 b:=0;
 if not dirsending then
 begin
   dirsending:=true;
   dirlist:=Tstringlist(new.GetFiles('\Discs\games2\*.*',false));
   dirlin:=0;dirch:=1;
 end;

 while dirch>length(dirlist[dirlin]) do
  Begin
    if dirlin<dirlist.count-1 then
    Begin
     dirlin:=dirlin+1;
     dirch:=1;
     result:=13;
     exit;
    End
    else //end the dir
    Begin
      Result:=0;
      dirsending:=false;
      exit;
    End;
 end;

 s:=dirlist[dirlin];
 result:=byte(s[dirch]);
 dirch:=dirch+1;
End;

//Select a file in the default directory
procedure TNBInOutSupport.DoPort44Out(Value:Byte);   //MY DEV DRIVER
Begin
   if value=0 then
   Begin
     if dirlist=nil then dirlist:=tstringlist.Create;
     dirlist:=Tstringlist(new.GetFiles('\Discs\games2\*.*',false));
     if dirlist.indexof(selectedfile)>0 then
        dirret:=0
     else
        dirret:=250; //Error file not found
   End;
  if value=134 then
   selectedfile:=''
  else
   selectedfile:=selectedfile+char(value);
End;

function TNBInOutSupport.GetClock: LongWord;
begin
  Result := GetTickCount;
end;

function TNBInOutSupport.NBIn(Port:Byte): byte;
begin
  result:=$ff;
  Case port of
     1:Enablereg2:=$ff;
     2:result:=DoPort2In(Port);
     3:LatchedParOut3:=$ff;
     4:;//only write;
     6:result:=doport6In(port);
     7:EnableReg:=$ff;
     8:result:=DoPort8In(Port);
     9:result:=DoPort9In(Port);
     12:result:=DoPort12In(Port);
     20:result:=DoPort20In(Port);
     21:result:=DoPort21In(Port);
     22:result:=DoPort22In(Port);
     23:result:=DoPort23In(Port);
     24:result:=DoPort24In(Port);
     25:result:=DoPort25In(Port);
     33:result:=DoPort33In(Port);
     44:result:=DoPort44In(Port);
     204:result:=DoPort204In(Port);
     205:result:=DoPort205In(Port);
     206:result:=DoPort206In(Port);
     207:result:=DoPort207In(Port);
    Else
      ODS('--IN Lost--'+inttostr(port));
  End;

end;

procedure TNBInOutSupport.NBout(Port:Byte;Value:Byte);
begin
  Case port of
    1:DoPort1Out(value);
    2:DoPort2Out(value);  //paging system
    3:DoPort3Out(value);
    4:DoPort4Out(value);
    5:DoPort5Out(Value);
    6:DoPort6Out(value);//cop interrupt
    7:DoPort7Out(value);    //enreg
    8:DoPort8Out(value);    //printer
    9:DoPort9Out(value);    //v24 rs232
    12:DoPort12Out(value);
    23:DoPort23Out(Value);
    24:DoPort24Out(Value);
    25:DoPort25Out(Value);
    33:DoPort33Out(Value);//MY TEST DRIVER
    44:DoPort44Out(Value);//select files and dir
    128:DoPort128Out(Value);
    204:DoPort204Out(Value);
    205:DoPort205Out(Value);
    206:DoPort206Out(Value);
    207:DoPort207Out(Value);
    255:DoPort255Out(value); //Paging
   Else
     ODS('--Out Lost--'+inttostr(port));
  End;
end;

procedure TNBInOutSupport.SetClockInt(Value: Boolean);
begin
     if FClockInt <> Value then
     begin
          FClockInt := Value;
          if not value then
               lastRGclk:=getclock;
     end;
end;

procedure TNBInOutSupport.SetCopInt(Value: Boolean);
begin
     if FCopInt <> Value then
     begin
          FCopInt := Value;
          if not value then
               lastRGcop:=getclock;
     end;
end;


{ if not (value  in [128,0])then
 Begin
  ODS('Port 128 Out ='+inttostr(Value));
  b:=z80_get_reg(Z80_REG_BC);
  ODS('BC ='+inttohex(b,4));
  d:=z80_get_reg(Z80_REG_DE);
  ODS('DE ='+inttohex(d,4));
  h:=z80_get_reg(Z80_REG_HL);
  ODS('HL ='+inttohex(h,4));
  a:=z80_get_reg(Z80_REG_AF);
  ODS('AF ='+inttohex(a,4));
  p:=z80_get_reg(Z80_REG_PC);
  ODS('PC ='+inttohex(p,4));

 end;
 }

end.
