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

unit uNBCop;

interface

uses uNBTypes, classes, upccomms, uNBCassette;

{$I 'dsp.inc'}

Const
  CASSCOM = $80;
  CASSLOD = $8C;
  PASSCOM = $90;
  DISPCOM = $A0;
  TIMCOM = $B0;
  PDNCOM = $C0;
  NULLCOM = $D0;
  RESCOM = $F0;

  BRKBIT = $04;
  REGINT = $00; // copstatus bits here
  CASSERR = $10;
  CASSIN = $20;
  KBD = $30;
  CASSOUT = $40;

  PLAYBK = 4;
  RECRD = 0;

Type
  TNBDevice = (NBUnknown, NBTape1, NBTape2, NBPrn, NBComm);
  TTapeStatus = (TSNone, TSstart, TSCountL, TSCountH, TSBlock, TSType,
    TSChkL, TSChkH);

  TTapeBlock = record
    Start: byte;
    Count: smallint;
    TPType: byte;
    chksum: smallint;
  end;

  TCop420 = Class

  private
    Tapestatus: TTapeStatus;
    Tapeblock: TTapeBlock;
    vfbuf: string;
    NextCopOutIsData: boolean;
    NextCopInIsData: boolean;
    TapeCounter: Integer;
    procedure OpenPrinter;
    procedure WritePrinter(b: byte);
    procedure DoWriteCopByte(Value: byte);
  public
    LastCopCommand: byte;
    Device: TNBDevice;
    ComBuf: Array [1 .. 12] of byte;
    StartCommInput: boolean;
    Bytes: Integer;
    f: textfile;
    prnopened: boolean;
    CommOpened: boolean;
    bithasset: boolean;
    rom3d: Integer;
    Cass1: TNBCassette;
    Cass2: TNBCassette;
    function Cassette: TNBCassette;
    procedure DoCopCommand(Value: byte);
    function GetFromCop: byte;
    procedure TranslateBuffer;
    function KBEnabled: boolean;
    constructor Create; virtual;
    procedure ClosePrinter;
    destructor Destroy; Override;
  End;

Var
  COP420: TCop420; // some cop functions

implementation

uses jcllogic, z80baseclass, windows,
  uNBTapes, uNbMemory, sysutils, new, forms,
  math, FileCtrl, uNBScreen, uNBCPM, uNBIO;

constructor TCop420.Create;
begin
  inherited;
  freeandnil(NBDiscCtrl);
  if fNewBrain.WithCPM1.Checked then
    NBDiscCtrl := TNBDISCCtrl.Create
  else
    NBDiscCtrl := nil;
  Cass1 := TNBCassette.Create;
  Cass1.TapeNo := 1;
  Cass2 := TNBCassette.Create;
  Cass2.TapeNo := 2;
end;

// returns the current tape
function TCop420.Cassette: TNBCassette;
begin
  Result := nil;
  case Device of
    NBTape1:
      Result := Cass1;
    NBTape2:
      Result := Cass2;
  end;
end;

function TCop420.GetFromCop: byte;
// Var
// DoBreak: boolean;

  procedure filegetbyte;
  begin
    // get 1 byte
    try
      Result := Cassette.ReadComm;
{$IFDEF NBTAPEDEBUG}
      ODS('$' + inttohex(prepc) + ' COP BYTE:' + inttostr(Result) + ' ' +
        inttohex(Result, 2) + ' [' + inttohex(nbio.EnableReg) + ']');
{$ENDIF}
    except
    end;
  end;

  procedure KBgetbyte;
  begin
    if nbio.kbint then
    begin
      nbio.kbint := false;
      Result := nbio.keypressed;
      nbio.keypressed := $80;
      // if DoBreak then
      // nbio.BrkPressed := false;
      exit;
    end;
  end;

  procedure getInterruptVector;
  begin
{$IFDEF NBDEBUG}
    ODS('*********Int VECTOR**********');
{$ENDIF}
    // BREAK KEY HANDLER
    if nbio.BrkPressed then
    Begin
      Result := Result or BRKBIT;
      nbio.BrkPressed := false;
      exit;
    end;

    // TAPE ERROR HANDLER
    if (Cassette <> nil) and Cassette.Loading and Cassette.CassError then
    begin
      Result := CASSERR;
      Cassette.Loading := false;
      Tapestatus := TSNone;
      exit;
    end;

    // KEYBOARD HANDLER
    // this is special case casue the screen is enabled so we give data too
    if nbio.KBStatus = SendKey then // after loop read the real key
    Begin
      nbio.KBStatus := NoKey;
      KBgetbyte;
    end
    else if nbio.KBStatus = SigKey then
    // NB expects byte dif from $80  to leave the loop
    begin
      Result := $85; // just to leave the loop
      nbio.KBStatus := SendKey;
    end
    else if nbio.kbint then
    begin
      nbio.KBStatus := SigKey; // signal cop has a key
      Result := Result or KBD; // 3X means kbd int
    end;

    // TAPE HANDLER
    if (Cassette <> nil) and Cassette.Loading then
    begin
      Result := CASSIN or (LastCopCommand and $F) // 0
    end;

    if (Cassette <> nil) and Cassette.Saving then
      Result := Result or CASSOUT;
  end;

  procedure getData;
  var
    i, t: Integer;
  begin
{$IFDEF NBDEBUG}
    ODS('*********GETDATA**********');
{$ENDIF}
    if Cassette.Loading then
    begin
      filegetbyte;
      NextCopInIsData := false;
      case Tapestatus of
        TSstart:
          begin
            Tapeblock.Start := Result;
            Tapestatus := TSCountL;
          end;
        TSCountL:
          begin
            Tapeblock.Count := Result;
            Tapestatus := TSCountH;
          end;
        TSCountH:
          begin
            Tapeblock.Count := Tapeblock.Count + Result * 256;
            Tapestatus := TSBlock;
          end;
        TSBlock:
          begin
            Tapeblock.Count := Tapeblock.Count - 1;
            if Tapeblock.Count = 0 then
              Tapestatus := TSType;
          end;
        TSType:
          begin
            Tapeblock.TPType := Result;
            Tapestatus := TSChkL;
          end;
        TSChkL:
          begin
            Tapeblock.chksum := Result;
            Tapestatus := TSChkH;
          end;
        TSChkH:
          begin
            Tapeblock.chksum := Tapeblock.chksum + Result * 256;
            Tapestatus := TSNone;
            Cassette.Loading := false; // block loaded
            t := Result;
            for i := 1 to 9 do // read 9 zeroes
              filegetbyte;
            Result := t;
          end;
      end;

    end
    else
      NextCopInIsData := false;

  end;

begin
  Result := $0;

  if (nbio.EnableReg shr 4 <> 0) or (prepc = $E255) or NextCopInIsData then
    getData
  else
  begin
    getInterruptVector;
    if Tapestatus <> TSNone then
      NextCopInIsData := true;
  end;

{$IFDEF NBDEBUG}
  ODS('$' + inttohex(prepc) + ' COP IN:' + inttostr(Result) + ' (' +
    inttohex(Result, 2) + ') ENREG=[' + inttohex(nbio.EnableReg) + ']');
{$ENDIF}
  exit;
end;

// this is a byte that cop needs to write somewhere (tape or vf)
procedure TCop420.DoWriteCopByte(Value: byte);
var
  s: char;
begin
  if (Cassette <> nil) and Cassette.Saving then // write a byte to file
  begin
    Cassette.Writecomm(Value);
    NextCopOutIsData := false;
    exit;
  end;

  If (LastCopCommand = $A0) and (Length(vfbuf) < 18) then
  Begin
    s := chr(Value);
    vfbuf := s + vfbuf;
{$IFDEF NBDEBUG}
    ODS('COP DISP INP ' + inttostr(Value));
{$ENDIF}
    exit;
  End
  else
  begin
    nbscreen.PaintLeds(vfbuf); // Refresh vf disp
    LastCopCommand := $80;
    NextCopOutIsData := false;
{$IFDEF NBDEBUG}
    ODS('VFBUF= ' + vfbuf)
{$ENDIF}
      ;
    exit;
  end;

{$IFDEF NBDEBUG}
  ODS('??????LOST OUT ' + inttohex(LastCopCommand) + ' Value:' +
    inttostr(Value))
{$ENDIF}
end;

procedure TCop420.DoCopCommand(Value: byte);
var
  CopCMD: byte;
  CopData: byte;
begin

  if NextCopOutIsData then
  begin
{$IFDEF NBDEBUG}
    ODS('COP Write Byte ' + inttostr(Value));
{$ENDIF}
    DoWriteCopByte(Value);
    exit;
  end
  else
  begin
{$IFDEF NBDEBUG}
    ODS('COP Command Byte ' + inttohex(Value) + ' ENREG=' +
      inttohex(nbio.EnableReg));
{$ENDIF}
  end;

  CopCMD := Value shr 4; // Hi 4 bits
  CopData := Value and $0F; // low 4 bits

  case CopCMD of
    $08: // CASSCOM
      begin
{$IFDEF NBDEBUG}
        s := 'CASSCOM' + '  ENREG:' + inttohex(nbio.EnableReg);
        // CASSCOM      1
{$ENDIF}
        if CopData and $08 = $08 then // TAPE 1 Command
          Device := NBTape1
        else if CopData and $02 = $02 then // TAPE 2 Command
          Device := NBTape2
        else
        begin
          ODS('TAPE CMD:' + inttohex(CopData));
          exit;
        end;

{$IFDEF NBTAPEDEBUG}
        ODS('TAPE:' + inttostr(TapeNo));
{$ENDIF}
        if CopData and PLAYBK = PLAYBK then // Loading
        begin
{$IFDEF NBDEBUG}
          s := 'CASSLOAD' + '  ENREG:' + inttohex(nbio.EnableReg);
          // CASSCOM      1
{$ENDIF}
          if not Cassette.Loading then
          Begin
            if Cassette.ResetTape then
              Cassette.DoResetTape;
            Cassette.Loading := true;
            NextCopInIsData := false;
            Tapestatus := TSstart;
            TapeCounter := 0;
            try
              Cassette.CassError := false;
              Cassette.OpenCassette(true);
            except
              Cassette.CassError := true;
              Tapestatus := TSNone;
            end;
{$IFDEF NBTAPEDEBUG}
            ODS('----------------START LOADING----------------');
{$ENDIF}
          End;
        end
        else if CopData and RECRD = RECRD then // Saving
        begin
          if not Cassette.Saving then
          begin
            if Cassette.ResetTape then
              Cassette.DoResetTape;
            Cassette.Saving := true;
            NextCopOutIsData := false;
            Cassette.OpenCassette;
            Cassette.Writecomm(0);
          end
          else
            NextCopOutIsData := true;
        end;
      end;
    $09: {$IFDEF NBDEBUG} s := 'PASSCOM' + ' ENREG:' + inttohex(nbio.EnableReg)
{$ENDIF}; // PASSCOM
    $0A: // DISPCOM
      begin
{$IFDEF NBDEBUG}
        s := 'DISPCOM ' + ' ENREG:' + inttohex(nbio.EnableReg); {$ENDIF} // DISPCOM      1 for vf display
        vfbuf := '';
        NextCopOutIsData := true; // Cop will get 18 bytes
      end;
    $0B: {$IFDEF NBDEBUG} s := 'TIMCOM' {$ENDIF}; // TIMCOM       1
    $0C: {$IFDEF NBDEBUG} s := 'PDNCOM' {$ENDIF}; // PDNCOM
    $0D: // NULLCOM
      begin
{$IFDEF NBDEBUG}
        s := 'NULLCOM' + ' ENREG:' + inttohex(nbio.EnableReg); {$ENDIF}
        if (Cassette <> nil) and Cassette.Saving then
        begin
          Cassette.closecomm;
          Cassette.Saving := false;
        end;
      end;
    $0E0: {$IFDEF NBDEBUG} s := '???COM' {$ENDIF};
    $0F0: {$IFDEF NBDEBUG} s := 'RESCOM' {$ENDIF}; // RESCOM
  else
    Begin
{$IFDEF NBDEBUG}
      ODS('LastCop Cmd=' + s + ' ' + inttostr(Value)); {$ENDIF}
      exit;
    End;
  end; // end case

{$IFDEF NBDEBUG}
  if Value <> $0D0 then
    ODS(s);
{$ENDIF}
  LastCopCommand := Value;

end;

procedure TCop420.ClosePrinter;
Begin
  if prnopened then
    closefile(f);
  prnopened := false;
End;

function TCop420.KBEnabled: boolean;
begin
  Result := true;
  // Result := not loading and not saving;
end;

procedure TCop420.OpenPrinter; // Obsolete Look uPCComms
var
  fname: String;
Begin
  if prnopened then
    exit;
  fname := extractfilepath(application.exename);
  fname := fname + 'printer.txt';
  prnopened := true;
  assignFile(f, fname);
  if not fileexists(fname) then
    rewrite(f)
  else
    Append(f);
  Writeln(f, '');
  Writeln(f, '');
  Writeln(f, '--------------------------------');
  Writeln(f, '--NewBrain Printer [' + datetimetostr(now) + '] ---------');
  Writeln(f, '--------------------------------');
  Writeln(f, '');
End;

procedure TCop420.TranslateBuffer;
Var
  tbit: byte;

  Function GetByte: byte;
  Var
    i: byte;
  Begin
    Result := 0;
    if Device = NBPrn then
      tbit := 7
    else
      tbit := 5;
    For i := 0 to 7 do
      if TestBit(ComBuf[i + 3], tbit) then
        Result := SetBit(Result, i);
  End;

Var
  b: byte;

Begin
  if TestBit(ComBuf[1], 5) then
    Device := NBComm // comms
  else
    Device := NBPrn; // printer

  b := GetByte;
  Case Device of
    NBTape1:
      ;
    NBTape2:
      ;
    NBPrn:
      begin
        OpenPrinter;
        WritePrinter(b);
      end;
    NBComm:
      begin
        // OpenComm;       //todo:
        // WriteComm(b);
      end;
  End;

End;

procedure TCop420.WritePrinter(b: byte);
Begin
  Write(f, char(b));
End;

destructor TCop420.Destroy;
begin
  ClosePrinter;
  Cass1.closecomm;
  Cass2.closecomm;
  Cass1.free;
  Cass2.free;
  inherited;
end;

end.
