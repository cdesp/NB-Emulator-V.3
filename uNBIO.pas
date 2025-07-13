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

uses upccomms, classes;

{$I 'dsp.inc'}

type

  TKeybState = (NoKey, SigKey, SendKey);

  TNBInOutSupport = Class
  private
    ACIACtrlReg: Byte;
    PRNOutDataInt: Boolean;
    PRNDataBusInt: Boolean; // D4 in port 20 in
    lastRGclk: LongWord;
    lastRGcop: LongWord;
    FCopInt: Boolean;
    FClockInt: Boolean;
    LastDevice: TPCPort;
    pn: Integer;
    minpn: Integer;
    lstick: Cardinal;
    MDloading: Boolean;
    MDsaving: Boolean;
    st: tStream;
    lsbyte: Byte;
    procedure DoPort128Out(Value: Byte);
    procedure DoPort128_DP_Out(Value: Byte);
    procedure DoPort128_MP_Out(Value: Byte);
    procedure getregisters;
    procedure DoPort7Out(Value: Byte);
    function DoPort2In(Value: Byte): Byte;
    function DoPort20In(Value: Byte): Byte;
    procedure DoPort6Out(Value: Byte);
    function DoPort22In(Value: Byte): Byte;
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
    KBStatus: TKeybState; // if true we send the data key
    UserInt: Boolean;
    AciaInt: Boolean;
    ClkEnabled: Boolean;
    TVEnabled: Boolean;
    DoClock: Boolean;
    kbint: Boolean;
    KeyPressed: Byte;
    brkpressed: Boolean;
    DAC5: Integer;
    EnableReg: Byte;
    EnableReg2: Byte;
    LatchedParOut3: Byte;
    Procedure NBout(Port: Byte; Value: Byte);
    Function NBIn(Port: Byte): Byte;
    constructor Create;
    function GetClock: LongWord;
    property CopInt: Boolean read FCopInt write SetCopInt;
    property ClockInt: Boolean read FClockInt write SetClockInt;
  End;

Var
  maxpn: Integer = 1;
  NBIO: TNBInOutSupport = nil;
  overrideDev33page: Integer = -1;
  overrideDev33addr: Integer = -1;
  overrideVidPg: Integer = -1;

implementation

uses uNBMemory, uNBScreen, new, sysutils, jclLogic, z80baseclass, uNBCop,
  windows, uNBCPM, unbtypes;

constructor TNBInOutSupport.Create;
begin
  inherited;
  TVEnabled := false;
  AciaInt := false;
  KeyPressed := $80;
  PRNDataBusInt := false; // Centronics printer
  pn := 0;
  minpn := 1;
  lstick := 0;
  MDloading := false;
  MDsaving := false;
end;

procedure TNBInOutSupport.DoPort1Out(Value: Byte);
Begin
  ODS('Port 1 Out =' + inttostr(Value));
  EnableReg2 := Value;
  // If not prnOutData then

  PRNOutDataInt := Testbit(Value, 0); // D0=0

  PRNDataBusInt := Testbit(Value, 0); // D0=0

  // D0 0 enables Data bus Interrupt and Parallel latched Data out Interrupt (PRN)
  // D1 1 Enables adc conversion and calling indicator
  // D2 1 Enables Serial Receive Clock
  // D3 1 Enables 50Kbaud Serial Data Rate
  // D4 1 Enables Serial Receive Clock to sound output summer Ans serial input from PRN 0 serial input from comms
  // D5 1 enables second bank of of four analog inputs + sound
  // D6 1 enables serial transmit clock to sound ouput summer select serial ouput to the printer 0 to comms
  // D7 9th output bit for Centronics Printer Port
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
var
  v: Integer;
  pgNo: Integer;
  is8k: Boolean;
begin

  v := Value and $06; // only bit 1 and bit 2
  // shift right v by 1
  v := v SHR 1;

  if Testbit(Value, 3) then // check if it is Ram
    v := 3; // ram in slot 3

  ODS('SLOT =' + inttostr(v));
  case v of // v has the rom slot to fetch 4 slots max
    0:
      pgNo := 118; // Datapack Rom
    1:
      pgNo := 116; // Slot 1 ROM
    2:
      pgNo := 114; // Slot 2 ROM
    3:
      pgNo := 112; // Slot 3 ram
  Else
    pgNo := 0;
    ;
  end;
  if pgNo = 0 then
    exit;

  is8k := nbmem.is8k(pgNo);

  if Testbit(Value, 7) then // check if itis 8krom
  Begin
    nbmem.SetPageInSlotForce(4, pgNo);
    nbmem.SetPageInSlotForce(3, 104); // old ram in 6/7
  end
  Else
  Begin
    nbmem.SetPageInSlotForce(4, pgNo);
    if not is8k then
      inc(pgNo);
    nbmem.SetPageInSlotForce(3, pgNo);
  end;

end;

// DataPack Support
procedure TNBInOutSupport.DoPort128_DP_Out(Value: Byte);
var
   v: Integer;
  pgNo: Integer;
  is8k: Boolean;
begin
  v := Value and $06; // only bit 1 and bit 2
  // shift right v by 1
  v := v SHR 1;
  if Testbit(Value, 3) then // check if it is Ram
    v := 3; // ram in slot 3
  ODS('SLOT =' + inttostr(v));

  case v of // v has the rom slot to fetch 4 slots max
    0:
      pgNo := 118; // Datapack Rom
    1:
      pgNo := 116; // Slot 1 ROM
    2:
      pgNo := 114; // Slot 2 ROM
    3:
      pgNo := 112; // Slot 3 ram
  Else
    pgNo := 0;
    ;
  end;
  if pgNo = 0 then
    exit;
  is8k := nbmem.is8k(pgNo);
  if Testbit(Value, 7) then // check if itis 8krom
  Begin
    nbmem.SetPageInSlotForce(4, pgNo);
    nbmem.SetPageInSlotForce(3, 104); // old ram in 6/7
  end
  Else
  Begin
    nbmem.SetPageInSlotForce(3, pgNo);
    if not is8k then
      inc(pgNo);
    nbmem.SetPageInSlotForce(3, pgNo);
  end;
end;

// PIBOX Support
// 204 - 207 status
// PIBOX has 1 slot for EPROM SLOT 0
// AND 1 slot for RAM Slot 1
function TNBInOutSupport.DoPort204In(Value: Byte): Byte;
begin
  Result := $00;
  ODS('Port 204 In =');
end;

procedure TNBInOutSupport.DoPort204Out(Value: Byte);
var
  a, v, pg: Integer;
  is16k: Boolean;
begin
  // nbmem.PageEnabled:=true;
  ODS('Port 204 Out =' + inttostr(Value));
  // a:=z80_get_reg(Z80_REG_BC);
  // ODS('BC ='+inttohex(a,4));
  // a:=z80_get_reg(Z80_REG_DE);
  // ODS('DE ='+inttohex(a,4));
  // a:=z80_get_reg(Z80_REG_HL);
  // ODS('HL ='+inttohex(a,4));
  // a:=z80_get_reg(Z80_REG_AF);
  // ODS('AF ='+inttohex(a,4));

  is16k := Testbit(Value, 7);
  v := Value and 3; // Bit 0 and 1 Only
  case v of
    0:
      Begin // EPROM
        // 1  ... 0 0  16K EPROM (6/7/8/9)
        if is16k then
        Begin
          nbmem.SetPageInSlotForce(3, 116); // 1st block
          nbmem.SetPageInSlotForce(4, 117); // 2nd block
        end
        Else
        Begin
          // 0  ... 0 0  8K EPROM (8/9)
          nbmem.SetPageInSlotForce(4, 116); // ROM
          nbmem.SetPageInSlotForce(3, 104); // Default RAM
        End;
      end;
    3:
      Begin // 1  ... 1 1  8K RAM  (8/9 +6/7)
        if is16k then // 16K RAM (8/9/6/7)
        Begin
          nbmem.SetPageInSlotForce(4, 114); // 1st block
          nbmem.SetPageInSlotForce(3, 115); // 2nd block
        end
        Else
        Begin
          // 0  ... 1 1  8K RAM (8/9)
          // nbMem.SetPageInSlotForce(4,114);   //RAM
          nbmem.SetPageInSlotForce(4, 113); // ROM
          // z80_set_reg(Z80_REG_PC,$E000);//bypass delayed page in
          nbmem.SetPageInSlotForce(3, 104); // Default RAM
          fnewbrain.bootok := false;
        End;

      end;
  Else
    pg := 0;
  end;
end;

function TNBInOutSupport.DoPort205In(Value: Byte): Byte;
begin
  Result := $00;
  ODS('Port 205 In =');
end;

procedure TNBInOutSupport.DoPort205Out(Value: Byte);
begin
  ODS('Port 205 Out =' + inttostr(Value));
end;

function TNBInOutSupport.DoPort206In(Value: Byte): Byte;
begin
  Result := $00;
  ODS('Port 206 In =');
end;

procedure TNBInOutSupport.DoPort206Out(Value: Byte);
begin
  ODS('Port 206 Out =' + inttostr(Value));
end;

function TNBInOutSupport.DoPort207In(Value: Byte): Byte;
begin
  Result := $00;
  ODS('Port 207 In =');
end;

procedure TNBInOutSupport.DoPort207Out(Value: Byte);
begin
  ODS('Port 207 Out =' + inttostr(Value));
end;

// PIBOX Support End

var
  copready: Boolean = false;

  // Read COP Status
function TNBInOutSupport.DoPort20In(Value: Byte): Byte;

Begin

  Result := 0;


  // bit 0

  // 11 =  Not call Ind
  If Testbit(EnableReg, 7) and Testbit(EnableReg, 6) then
    if not dmCommd.CanReadFromCom then // if we dont have a byte to read
      Result := 1; // set bit 0

  // 10 = Tape In
  if Testbit(EnableReg, 7) and // bit 7 set
    Not Testbit(EnableReg, 6) // bit 6 not set
  then // tape in
    if (cop420.Cassette <> nil) and (not cop420.Cassette.Loading) then
      Result := 1;

  // 01= 40/80
  if not Testbit(EnableReg, 7) and // bit 7 not set
    Testbit(EnableReg, 6) // bit 6  set
  then // Chars per tv
    // todo:get it
    Result := 1; // 1=40 chars 0=80 chars

  // 00 = Excess
  if not Testbit(EnableReg, 7) and // bit 7 not set
    not Testbit(EnableReg, 6) // bit 6 not set
  then // Excess
    Result := 1; // 1=24 excess 0=4 excess

  EnableReg := ClearBit(EnableReg, 7);
  EnableReg := ClearBit(EnableReg, 6);

  // bit 1

  // 11 = Not Call Ind
  if Testbit(EnableReg, 5) and // bit 5  set
    Testbit(EnableReg, 4) // bit 4  set
  then // Callind
  Begin
    If EnableReg2 and 1 = 1 then // ACIA
      Result := Result or 2
    else if not dmCommd.CanReadFromCom then
      Result := Result or 2; // set bit 1
  End;

  // 10 = Not Bee
  if Testbit(EnableReg, 5) and // bit 5  set
    Not Testbit(EnableReg, 4) // bit 4 not set
  then // Bee
    Result := Result or 2; // set =Processor Model A

  // 01= Tv Console
  if not Testbit(EnableReg, 5) and // bit 5 not set
    Testbit(EnableReg, 4) // bit 4 set
  then // TvCnsl
    if TVEnabled then
      Result := Result or 2; // set = Pri Cons out is video

  // 00= Power Up
  if not Testbit(EnableReg, 5) and // bit 5 not set
    not Testbit(EnableReg, 4) // bit 4 not set
  then // PwrUp For battery version
      ; // result:=result or 2; // NOT set = Power is supplied

  EnableReg := ClearBit(EnableReg, 5);
  EnableReg := ClearBit(EnableReg, 4);

  // rest bits 2-8
  Result := Result or 4; // set =mains present

  If not PRNOutDataInt then
    Result := Result or 8 // Centronics printer port interrupt if not set
  Else
    PRNOutDataInt := PRNOutDataInt;

  { Userint:= PRNDataBusInt;

    if not userint then          //parallel Data bus port int if not set
    result:=result or 16   //User int if not set
    Else
    PRNDataBusInt:=PRNDataBusInt; }

  if copready then
    Result := Result or 16; // cop ready
  copready := not copready;

  if not ClockInt then
    Result := Result or 32; // clock int if not set

  if not AciaInt then
    Result := Result or 64; // acia int if not set

  if not CopInt then
    Result := Result or 128; // cop int if not set


  // ENABLEREG:=TMP;
  // Result:=SetBit(result,0);   //Always bit 0 is 1
  // Result:=ClearBit(result,1); //Always bit 1 is 0 we dont have a battery

End;

function TNBInOutSupport.DoPort21In(Value: Byte): Byte;
Begin
  Result := 4 + 8 + 16 + 64;
End;

// read a byte from comm or tape
function TNBInOutSupport.DoPort22In(Value: Byte): Byte;
var
  DE, DEhigh, PC: DWord;
Begin
  Result := 0;
  // Communications port v24 and PRN and tape

  // Readonly in 22
  // 0 Rec Data V24
  // 1 CTS V24 (not)
  // 2 -4 not used
  // 5 Tape In
  // 6 Not used
  // 7 CTS Prn (not)

  DE := z80_get_reg(Z80_REG_DE);
  PC := z80_get_reg(Z80_REG_PC);
  DEhigh := DE shl 8;
  ODS(inttostr(DE));
  Value := EnableReg;

  Result := Result or 2; // not CTS mean not ready   0 = ready
  Result := Result or 128; // not CTS prn

  if dmCommd.recv then
  begin

    if dmCommd.CanReadFromCom then
      Result := Result or dmCommd.ReadFromComm
    else
      Result := Result or 1;
    exit;
  End;
  if cop420.Cassette.Loading then
    Result := Result or $20; // set bit 5

  if Testbit(Value, 4) and Testbit(Value, 5) and ((DE = 544) OR (PC = 58630))
  then // port #9
  Begin
    Result := Result - 2; // UnSet Bit 1
    LastDevice := pcpCom1;
  End;

  if Testbit(Value, 7) and (DE = 32896) then // port #8
  Begin
    Result := Result - 128; // UnSet bit 7
    LastDevice := pcpPrn;
  End;

  { if fnewbrain.bootok then
    Begin
    cop420.StartCommInput:=true;
    cop420.Device:=NBUnknown;
    End;
  }
  ODS('Port 22 =' + inttostr(Result));
  // OutputdebugString(Pchar('Port 22 ='+inttostr(result)));
End;

function TNBInOutSupport.DoPort23In(Value: Byte): Byte;
Begin
  Result := $00;
  ODS('Port 23 In =');
End;

// Control Reg ACIA
procedure TNBInOutSupport.DoPort23Out(Value: Byte);
Begin
  ODS('Port 23 Out =' + inttostr(Value) + ' Control Reg ACIA');
End;

// Control Reg ACIA
function TNBInOutSupport.DoPort24In(Value: Byte): Byte;
Begin
  // Result:=ACIACtrlReg;

  ODS('Port 24 In =' + inttostr(Value) + '   ' + inttostr(ACIACtrlReg) +
    ' Control Reg ACIA');
  // case  EnableReg2
  Result := 0;
  Result := SetBit(Result, 0); // RDRF
  Result := SetBit(Result, 1); // TDRF
  Result := SetBit(Result, 2); // DCD
  Result := SetBit(Result, 3); // CTS
  // Result:=SetBit(Result,4); //FE
  // Result:=SetBit(Result,5); //OVRN
  // Result:=SetBit(Result,6); //PE
End;

// Control Reg ACIA
procedure TNBInOutSupport.DoPort24Out(Value: Byte);
Begin
  ACIACtrlReg := Value;
  ODS('Port 24 Out =' + inttostr(Value) + '   ' + inttostr(ACIACtrlReg) +
    ' Control Reg ACIA');
End;

// Page OS Control
procedure TNBInOutSupport.DoPort255Out(Value: Byte);
Var
  bc: Word;
  b, c: Byte;
  s: String;

Begin
  // pAGING

  s := 'PAGE CMD-->';
  bc := z80_get_reg(Z80_REG_BC);
  b := Byte(bc Shr 8);
  c := Byte(bc And $00FF); // Not Used
  if Value And 1 = 1 then
    nbmem.PageEnabled := true // pagememon
  else
    nbmem.PageEnabled := false;
  If Value And 4 = 4 then
    nbmem.AltSet := true // Turntoalt
  Else
    nbmem.AltSet := false;

  // -------- fOR dISCS

  If b And 2 = 2 then
  Begin
    if Value And 128 = 128 then // Disc IO
    Begin
      NBDiscCtrl.GetReadyForCommand;
    End
    Else if Value And 32 = 32 then // Disc IO
    Begin
      NBDiscCtrl.DoCommand;
    End;
  End; // if b and 2

{$IFDEF NBPgDebug}
  // FOR DEBUGGING
  if nbmem.PageEnabled then
    s := s + 'PageEnabled'
  Else
    s := s + 'PageDisabled';
  if nbmem.AltSet then
    s := s + ' - Set Alt Slots'
  Else
    s := s + ' - Set Main Slots';

  ODS(s);
  // b has one of the following
  // EXPANSION	EQU 00000001B
  // DISCCONTROLLER	EQU 00000010B
  // NETWORKCONTROL	EQU 00000100B
  // ALLPERIPHERALS	EQU 11111111B
{$ENDIF}
End;

// Control Reg ACIA
function TNBInOutSupport.DoPort25In(Value: Byte): Byte;
Begin
  ODS('Port 25 In =' + inttostr(Value) + ' Control Reg ACIA');
End;

// Control Reg ACIA
procedure TNBInOutSupport.DoPort25Out(Value: Byte);
Begin

  ODS('Port 25 Out =' + inttostr(Value) + ' Control Reg ACIA');
  // This is Where the bytes come for
  // print#16,nn
  // We must Resend them to the Selected printer Device
  dmCommd.PrinterSend(Value);
End;

// Ch0 CTC
procedure TNBInOutSupport.DoPort28Out(Value: Byte);
Begin
  ODS('Port 28 Out Ch0 CTC =' + inttostr(Value));
End;

// Ch1 CTC
procedure TNBInOutSupport.DoPort29Out(Value: Byte);
Begin
  ODS('Port 29 Out Ch1 CTC=' + inttostr(Value));
End;

function TNBInOutSupport.DoPort2In(Value: Byte): Byte;
begin
  ODS('Port 2 In =' + inttohex(Value, 4));
  Result := 255;
end;

// page OS Setting pages to slots
procedure TNBInOutSupport.DoPort2Out(Value: Byte);
Var
  bc: Word;
  b, c: Byte;
  slt: Integer;
  pg: Integer;
  alt: Boolean;
  IsRom: Boolean; // Not USed
  s: string;
Begin
  bc := z80_get_reg(Z80_REG_BC);
  b := Byte(bc Shr 8);
  c := Byte(bc And $00FF); // Not Used

  if b and $10 = $10 then
    alt := true
  Else
    alt := false;
  if b and $8 = $8 then
    IsRom := true // Not Used
  else
    IsRom := false; // Not used

  slt := b div $20;
  pg := Value;

  nbmem.SetPageInSlot(slt, pg, alt);
  {$ifdef NBPGDEBUG}
   s:='';
   if alt then
     s:='Alt';
   ODS('Slot:'+inttostr(slt)+' page:'+inttostr(pg)+' '+s);
  {$ENDIF}
End;

// Ch2 CTC
procedure TNBInOutSupport.DoPort30Out(Value: Byte);
Begin
  ODS('Port 30 Out Ch2 CTC=' + inttostr(Value));
End;

procedure TNBInOutSupport.DoPort3Out(Value: Byte);
Begin
  ODS('Port 3 Out =' + inttostr(Value));
  LatchedParOut3 := Value;
End;

// An out here clears clock interrupt
function TNBInOutSupport.DoPort4Out(Value: Byte): Byte;
Begin
  InterruptServed := true;
  Result := 0;
  ClockInt := false;
End;

procedure TNBInOutSupport.DoPort5Out(Value: Byte);
Var
  RVal: Byte;
Begin
  DAC5 := Value;
  // Reverse Value and send to printer // Open#22,22
  RVal := ReverseBits(Value);
  dmCommd.PrinterSend(RVal);
  If RVal = 13 then
    dmCommd.PrinterSend(10);
End;

function TNBInOutSupport.DoPort6In(Value: Byte): Byte;
// for regint
// bit 0 = timer0
// bit 1 = power low
// bit 2 = Brk
// bit 3 = resp
// bits 0-2 goes to Copst
Begin
  InterruptServed := true;
  CopInt := false;

  Result := cop420.GetFromCop;
End;

// Cop Communication mainly the vf display
// tape loading , saving
procedure TNBInOutSupport.DoPort6Out(Value: Byte);
Begin
  cop420.DoCopCommand(Value);
End;

procedure TNBInOutSupport.DoPort7Out(Value: Byte);
  Procedure ReadAByte;
  Begin
    inc(cop420.Bytes);
    cop420.ComBuf[cop420.Bytes] := Value;
    if cop420.Bytes = 12 then
    Begin
      cop420.StartCommInput := false;
      cop420.Bytes := 0;
      cop420.TranslateBuffer;
    End;
  End;

Begin
  // if value<>14 then
  // ODS('port 7='+inttostr(value));
  if Testbit(Value, 4) and Testbit(Value, 5) then
    dmCommd.OpenComm(pcpCom1);

  if Testbit(Value, 7) then
    dmCommd.OpenComm(pcpPrn);
  // bit 4 is ~CTS bit 5 is comm port
  // bit 6 is not used
  // bit 7 is PRN
  if LastDevice <> pcpNone then
  Begin
    If not Testbit(Value, 4) and Testbit(Value, 5) then
      dmCommd.readytoreceive(true)
    Else if (not Testbit(Value, 2)) and not dmCommd.recv then
    // bit 2 is tvenable
    Begin
      dmCommd.SendToComm(LastDevice, Value)
    End;
  End;

  if cop420.StartCommInput then
  Begin
    // ReadAbyte;
  End;

  // model A
  EnableReg := Value;
  if EnableReg and 1 = 1 then // clock enable   =set bit 0
    ClkEnabled := false
  else
    ClkEnabled := true;

  if EnableReg and 4 = 4 then // Tv Enable    = set bit 2
    TVEnabled := true
  else
    TVEnabled := false;

  if EnableReg and 16 = 16 then // Not Clear For Sending     bit 4
  Begin
    fnewbrain.bootok := true;
    nbmem.InitFDCMem;
  End;

  if EnableReg and 32 = 32 then // Transmit data on modem port bit 5
      ;

  if EnableReg and 128 = 128 then // Transmit data PRN     bit 7
      ;
End;

// Screen handling PORTS 8,9,12

PRocedure TNBInOutSupport.getregisters;

  procedure ODS2(a: String);
  Begin
    Outputdebugstring(Pchar(a));
  end;

Begin
  ODS2('PC=' + inttostr(z80_get_reg(Z80_REG_PC)));
  ODS2('AF=' + inttostr(z80_get_reg(Z80_REG_AF)));
  ODS2('HL=' + inttostr(z80_get_reg(Z80_REG_HL)));
  ODS2('BC=' + inttostr(z80_get_reg(Z80_REG_BC)));
  ODS2('DE=' + inttostr(z80_get_reg(Z80_REG_DE)));
  ODS2('IX=' + inttostr(z80_get_reg(Z80_REG_IX)));
  ODS2('IY=' + inttostr(z80_get_reg(Z80_REG_IY)));
  ODS2('BC2=' + inttostr(z80_get_reg(Z80_REG_BC2)));
End;

function TNBInOutSupport.DoPort8In(Value: Byte): Byte;
// Sets 9th bit of video address counter
Begin
  Result := $FF;
End;

// If Tvaddress msb is set then we get an out here
// very rare so we don't implement yet
procedure TNBInOutSupport.DoPort8Out(Value: Byte);
Begin
  nbscreen.VIDEOMSB := 1;
End;

function TNBInOutSupport.DoPort9In(Value: Byte): Byte;
// load first 8 bits of video address counter
Begin
  Result := $FF;
End;

// Out the TV address to video hardware
procedure TNBInOutSupport.DoPort9Out(Value: Byte);
Var
  GrPage: Integer;
Begin
  nbscreen.VideoAddrReg := Value shl 7; // on a 64 byte boundary so shl 7
  try
    // todo:This is not a good way to find the device 33 video ram page
    if nbmem.mainslots[3]^.Page = 124 then
    Begin
      GrPage := nbmem.mainslots[5]^.Page;
      nbscreen.Dev33Page := GrPage;
    End;

    nbscreen.Dev33Page := nbscreen.VIdeoPage;
    if overrideDev33page <> -1 then
      nbscreen.Dev33Page := overrideDev33page;

    // inc(pn);
    // if pn=1 then

    TThread.Queue(nil,
      procedure
      begin
        nbscreen.Paintvideo // safely call with thread info
      end);

    // sleep(nbdel);
  Except
  End;
  nbscreen.VIDEOMSB := 0;

End;

function TNBInOutSupport.DoPort12In(Value: Byte): Byte;
// load video control reg
Begin
  Result := $FF;
End;

// Send the TVMODE Byte to Video Hardware
procedure TNBInOutSupport.DoPort12Out(Value: Byte);
Begin
  if nbmem.PageEnabled then
    nbscreen.VIdeoPage := nbmem.lastpage
  else
    nbscreen.VIdeoPage := 0;
  // ODS('VidePg='+inttostr(nbscreen.videopage));
  nbscreen.TVModeReg := Value;
End;

// Testing for NB Laptop
var
  dirsending: Boolean = false;

var
  dirlist: TStringlist = nil;

var
  dirlin, dirch: Integer;

var
  dirret: Integer = 255;

var
  selectedfile: string;

function TNBInOutSupport.DoPort33In(Value: Byte): Byte; // MY DEV DRIVER
var
  b: Byte;
Begin
  b := 0;
  if not MDloading then
  begin
    MDloading := true;
    st := TFileStream.Create('.\discs\games2\' + selectedfile, fmOpenRead);
  end;
  if st.Position < st.Size then
    st.Read(b, 1);

  if ((lsbyte = 4) and (b = 13)) or (st.Position = st.Size) then
  Begin
    st.Free;
    st := nil;
    MDloading := false;
  end;
  lsbyte := b;
  Result := b;
End;

procedure TNBInOutSupport.DoPort33Out(Value: Byte); // MY DEV DRIVER
Begin
  if not MDsaving then
  Begin
    MDsaving := true;
    st := TFileStream.Create('.\discs\games2\test2.bas',
      fmCreate or fmOpenWrite);
  End;
  st.Write(Value, 1);
End;

// Send the directory files byte by byte
function TNBInOutSupport.DoPort44In(Value: Byte): Byte; // MY DEV DRIVER
var
  s: string;
Begin
  if dirret <> 255 then
  Begin
    Result := dirret;
    dirret := 255;
    exit;
  End;

  if dirlist = nil then
    dirlist := TStringlist.Create;

  if not dirsending then
  begin
    dirsending := true;
    dirlist := TStringlist(new.GetFiles('\Discs\games2\*.*', false));
    dirlin := 0;
    dirch := 1;
  end;

  while dirch > length(dirlist[dirlin]) do
  Begin
    if dirlin < dirlist.count - 1 then
    Begin
      dirlin := dirlin + 1;
      dirch := 1;
      Result := 13;
      exit;
    End
    else // end the dir
    Begin
      Result := 0;
      dirsending := false;
      exit;
    End;
  end;

  s := dirlist[dirlin];
  Result := Byte(s[dirch]);
  dirch := dirch + 1;
End;

// Select a file in the default directory
procedure TNBInOutSupport.DoPort44Out(Value: Byte); // MY DEV DRIVER
Begin
  if Value = 0 then
  Begin
    if dirlist = nil then
      dirlist := TStringlist.Create;
    dirlist := TStringlist(new.GetFiles('\Discs\games2\*.*', false));
    if dirlist.indexof(selectedfile) > 0 then
      dirret := 0
    else
      dirret := 250; // Error file not found
  End;
  if Value = 134 then
    selectedfile := ''
  else
    selectedfile := selectedfile + char(Value);
End;

function TNBInOutSupport.GetClock: LongWord;
begin
  Result := GetTickCount;
end;

function TNBInOutSupport.NBIn(Port: Byte): Byte;
begin
  Result := $FF;
  Case Port of
    1:
      EnableReg2 := $FF;
    2:
      Result := DoPort2In(Port);
    3:
      LatchedParOut3 := $FF;
    4:
      ; // only write;
    6:
      Result := DoPort6In(Port);
    7:
      EnableReg := $FF;
    8:
      Result := DoPort8In(Port);
    9:
      Result := DoPort9In(Port);
    12:
      Result := DoPort12In(Port);
    20:
      Result := DoPort20In(Port);
    21:
      Result := DoPort21In(Port);
    22:
      Result := DoPort22In(Port);
    23:
      Result := DoPort23In(Port);
    24:
      Result := DoPort24In(Port);
    25:
      Result := DoPort25In(Port);
    33:
      Result := DoPort33In(Port);
    44:
      Result := DoPort44In(Port);
    204:
      Result := DoPort204In(Port);
    205:
      Result := DoPort205In(Port);
    206:
      Result := DoPort206In(Port);
    207:
      Result := DoPort207In(Port);
  Else
    ODS('--IN Lost--' + inttostr(Port));
  End;

end;

procedure TNBInOutSupport.NBout(Port: Byte; Value: Byte);
begin
  Case Port of
    1:
      DoPort1Out(Value);
    2:
      DoPort2Out(Value); // paging system
    3:
      DoPort3Out(Value);
    4:
      DoPort4Out(Value);
    5:
      DoPort5Out(Value);
    6:
      DoPort6Out(Value); // cop interrupt
    7:
      DoPort7Out(Value); // enreg
    8:
      DoPort8Out(Value); // printer
    9:
      DoPort9Out(Value); // v24 rs232
    12:
      DoPort12Out(Value);
    23:
      DoPort23Out(Value);
    24:
      DoPort24Out(Value);
    25:
      DoPort25Out(Value);
    33:
      DoPort33Out(Value); // MY TEST DRIVER
    44:
      DoPort44Out(Value); // select files and dir
    128:
      DoPort128Out(Value);
    204:
      DoPort204Out(Value);
    205:
      DoPort205Out(Value);
    206:
      DoPort206Out(Value);
    207:
      DoPort207Out(Value);
    255:
      DoPort255Out(Value); // Paging
  Else
    ODS('--Out Lost--' + inttostr(Port));
  End;
end;

procedure TNBInOutSupport.SetClockInt(Value: Boolean);
begin
  if FClockInt <> Value then
  begin
    FClockInt := Value;
    if not Value then
      lastRGclk := GetClock;
  end;
end;

procedure TNBInOutSupport.SetCopInt(Value: Boolean);
begin
  if FCopInt <> Value then
  begin
    FCopInt := Value;
    if not Value then
      lastRGcop := GetClock;
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
