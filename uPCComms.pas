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

unit uPCComms;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AdPort, OoMisc, AdWnPort, AdSocket;

type
  TPCPort = (pcpNone, pcpCOM1, pcpTCP, pcpPRN);
  TPCState = (pcsNone, pcsTransmit, pcsReceive);

  TPCDevice = Record
    Opened: Boolean;
    BaudRate: Integer;
    StopBits: Byte;
    Parity: Char;
    State: TPCState;
  End;

  TdmCommd = class(TDataModule)
    PCCom: TApdWinsockPort;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    Com1: TPCDevice;
    TCP1: TPCDevice;
    PRN1: TPCDevice;
    cnt: Integer;
    B: Byte;
    f: textfile;
    procedure OpenPrinterfile;
    { Private declarations }
  public
    recv: Boolean;
    procedure SendToComm(VAr Port: TPCPort; bt: Byte);
    procedure OpenComm(Port: TPCPort);
    procedure CloseComm(Port: TPCPort);
    procedure SetState(Port: TPCPort; St: TPCState);
    function ReadFromComm: Byte;
    function CanReadFromCom: Boolean;
    procedure readytoreceive(fl: Boolean = True);
    procedure PrinterSend(B: Byte);
    { Public declarations }
  end;

var
  dmCommd: TdmCommd;

implementation

uses new, jcllogic, frmOptions, printers;

{$R *.DFM}

procedure TdmCommd.SendToComm(VAr Port: TPCPort; bt: Byte);
Var
  s: String;

begin
  if not Com1.Opened and not PRN1.Opened then
    exit;

  if cnt = 0 then
    B := 0;

  if cnt = 1 then
  Begin
    if testbit(bt, 7) then
      Port := pcpCOM1;
    if testbit(bt, 5) then
      Port := pcpPRN;
  End;

  Case Port of
    pcpCOM1:
      Begin
        if not Com1.Opened then
          exit;

        s := 'COM:';
        If (cnt >= 2) And (cnt <= 9) and testbit(bt, 5) then
          B := Setbit(B, Byte(cnt - 2));
        inc(cnt);
        if cnt = 12 then
        Begin
          Port := pcpNone;
          cnt := 0;
          ODS('Byte to Com Send:' + inttostr(B));
          if PCCom.OutBuffFree >= 1 then
            While True do
              if PCCom.OutBuffUsed = 0 then
              Begin
                PCCom.PutChar(AnsiChar(B));
                Break;
              End
              Else
                PCCom.ProcessCommunications;
          // slpv:=strtoint(foptions.edDelay.text);
          // if slpv>0 then
          // sleep(slpv);

          // OutputDebugString(Pchar(String(chr(b))))
        End;
      End;
    pcpTCP:
      s := 'TCP:';
    pcpPRN:
      Begin
        s := 'PRN:';
        If (cnt >= 2) And (cnt <= 9) and testbit(bt, 7) then
          B := Setbit(B, Byte(cnt - 2));
        inc(cnt);
        if cnt = 12 then
        Begin
          Port := pcpNone;
          cnt := 0;
          ODS('Byte to PRN Send:' + inttostr(B));
          PrinterSend(B);
          // OutputDebugString(Pchar(String(chr(b))))
        End;
      End;
  End;
end;

procedure TdmCommd.OpenComm(Port: TPCPort);
Var
  s: String;
begin
  Case Port of
    pcpCOM1:
      Begin
        s := 'COM';
        if Com1.Opened then
          exit;
        if foptions.ComGroup.ItemIndex = 4 then
          exit; // no com port available

        Com1.Opened := True;
        PCCom.ComNumber := foptions.ComGroup.ItemIndex + 1;
        try
          PCCom.Baud :=
            strtoint(foptions.BaudGroup.items[foptions.BaudGroup.ItemIndex]);
        Except

        End;

        PCCom.Parity := tparity(foptions.Parity.ItemIndex);
        try
          PCCom.StopBits := strtoint(foptions.edstop.text);
        except
          PCCom.StopBits := 1;
        end;
        try
          PCCom.DataBits := strtoint(foptions.eddatab.text);
        Except
          PCCom.DataBits := 8;
        end;

        case foptions.rgFlow.ItemIndex of
          0:
            Begin // RTS/CTS
              PCCom.HWFlowOptions := [hwfUseRTS, hwfRequireCTS];
            End;
          1:
            Begin // DTR/DSR
              PCCom.HWFlowOptions := [hwfUseDTR, hwfRequireDSR];
            End;
          2:
            Begin // None
              PCCom.HWFlowOptions := [];
            End;
        end;

        if foptions.chkEnabled.Checked then
        Begin
          PCCom.DeviceLayer := dlWinsock;
          PCCom.WsAddress := foptions.edAddress.text;
          PCCom.WsLocalAddressIndex := foptions.cmbLocalAddr.ItemIndex;
          if foptions.RGGroup.ItemIndex = 0 then
            PCCom.WsMode := wsClient
          else
            PCCom.WsMode := wsServer;

          PCCom.WsPort := foptions.edPort.text;
        End
        Else
          PCCom.DeviceLayer := dlWin32;
        try
          PCCom.Open := True;
        except
          on e: exception do
          Begin
            LastError := e.message + #13 +
              'Goto General Options and select a valid com port.'#13'You may need to restart the emulator.'#13
              + 'ALSO you might have the dissassembly window open which uses COM1, so close it';
          End;
        end;
      end;
    pcpTCP:
      s := 'TCP';
    pcpPRN:
      Begin
        s := 'PRN';
        if PRN1.Opened then
          exit;
        // if foptions.prnGroup.ItemIndex<2 then
        OpenPrinterfile;
        PRN1.Opened := True;
      end;
  End;
  // s:='Open '+s;
  // ODS(S);
end;

procedure TdmCommd.CloseComm(Port: TPCPort);
Var
  s: String;
begin
  Case Port of
    pcpCOM1:
      Begin
        s := 'COM';
        if not Com1.Opened then
          exit;
        Com1.Opened := False;
      end;
    pcpTCP:
      s := 'TCP:';
    pcpPRN:
      Begin
        s := 'PRN';
        if not PRN1.Opened then
          exit;
        PRN1.Opened := False;
        try
          CloseFile(f);
        Except

        end;
      end;
  End;
  s := 'Close ' + s;

  ODS(s);
end;

procedure TdmCommd.SetState(Port: TPCPort; St: TPCState);
Var
  s: String;
begin
  Case Port of
    pcpCOM1:
      Begin
        s := 'COM';
        Com1.State := St;
      end;
    pcpTCP:
      s := 'TCP';
    pcpPRN:
      Begin
        s := 'PRN';
        if not PRN1.Opened then
          exit;
        PRN1.State := St;
      end;
  End;

  Case St of
    pcsNone:
      s := s + ' None';
    pcsTransmit:
      s := s + ' Transmit';
    pcsReceive:
      s := s + ' Receive';
  End;

  s := 'State ' + s;
  // ODS(S);
end;

var
  bt: Byte = 255;

function TdmCommd.ReadFromComm: Byte;
begin

  if (cnt = 0) or (cnt = 1) then
  Begin
    if cnt = 0 then // get the byte from pccomm
    Begin
      if PCCom.CharReady then
        bt := Byte(PCCom.getchar);
    End;
    result := 0;
    // outputdebugString(Pchar('bit X:'+inttostr(byte(cnt))+' -->'+inttostr(result) ));
  End
  Else // Data bits
  Begin
    result := 0;
    if testbit(bt, Byte(cnt - 2)) then
      result := 1;
    // outputdebugString(Pchar('bit:'+inttostr(byte(cnt-2))+' -->'+inttostr(result) ));
  End;

  if cnt >= 9 then // stop bit??
  Begin
    cnt := 0;
    recv := False;
    dec(bt);
    // outputdebugString('=================');
  End
  else
    inc(cnt);
end;

function TdmCommd.CanReadFromCom: Boolean;
begin
  result := recv and (PCCom.CharReady or (cnt <> 0));
  // true mean we have something to send
end;

procedure TdmCommd.readytoreceive(fl: Boolean = True);
begin
  recv := fl;
  if fl then
    cnt := 0;
end;

procedure TdmCommd.DataModuleCreate(Sender: TObject);
begin
  cnt := 0;
end;

procedure TdmCommd.PrinterSend(B: Byte);
begin
  try
    OpenComm(pcpPRN);
    // if foptions.prnGroup.ItemIndex<2 then
    Write(f, Char(B));
    Flush(f);
  Except
  End;
end;

Var
  WeAreIn: Boolean = False;

Procedure TdmCommd.OpenPrinterfile;
var
  fn: String;
  fmode: Integer;
Begin
  if PRN1.Opened or WeAreIn then
    exit;
  WeAreIn := True;
  try

    case foptions.prnGroup.ItemIndex of
      0:
        Begin
          fn := 'PrinterNew.Prn';
          fmode := 2;
        End;
      1, 2:
        Begin
          fn := foptions.prnGroup.items[foptions.prnGroup.ItemIndex];
          fmode := 1;
        End;
      3:
        Begin
          AssignPrn(f);
          ReWrite(f);
          exit;
        end;
    end;

    try
      AssignFile(f, fn);
      FileMode := fmode;
      if fileexists(fn) then
        Append(f)
      else
        ReWrite(f);
    Except
      fnewbrain.Suspendemul;
      ShowMessage(fn + ' is invalid try change options!!!');
      Application.Terminate;
    end;
    FileMode := 2;
    if foptions.prnGroup.ItemIndex = 0 then
    Begin
      Writeln(f, '=====================');
      Writeln(f, 'Newbrain Printer File');
      Writeln(f, DateTimeToStr(Now));
      Writeln(f, '=====================');
    End;

  finally
    WeAreIn := False;
  end;
End;

procedure TdmCommd.DataModuleDestroy(Sender: TObject);
begin
  if PRN1.Opened then
  Begin
    try
      CloseFile(f);
    Except
    End;
    PRN1.Opened := False;
  End;
end;

end.
