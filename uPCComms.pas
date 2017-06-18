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

unit uPCComms;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AdPort, OoMisc, AdWnPort,AdSocket;

type
  TPCPort=(pcpNone,pcpCOM1,pcpTCP,pcpPRN);
  TPCState=(pcsNone,pcsTransmit,pcsReceive);

  TPCDevice=Record
     Opened:Boolean;
     BaudRate:Integer;
     StopBits:Byte;
     Parity:Char;
     State:TPCState;
  End;

  TdmCommd = class(TDataModule)
    PCCom: TApdWinsockPort;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    Com1:TPCDevice;
    TCP1:TPCDevice;
    PRN1:TPCDevice;
    cnt: Integer;
    B: Byte;
    f: textfile;
    procedure OpenPrinterfile;
    { Private declarations }
  public
    recv: Boolean;
    procedure SendToComm(VAr Port:TPCPort;bt:Byte);
    procedure OpenComm(Port:TPCPort);
    procedure CloseComm(Port: TPCPort);
    procedure SetState(Port:TPCPort;St:TPCState);
    function ReadFromComm: byte;
    function CanReadFromCom: Boolean;
    procedure readytoreceive(fl:Boolean=True);
    procedure PrinterSend(b:Byte);
    { Public declarations }
  end;

var
  dmCommd: TdmCommd;

implementation
uses new,jcllogic, frmOptions,printers;

{$R *.DFM}

procedure TdmCommd.SendToComm(VAr Port:TPCPort;bt:Byte);
Var s:String;

begin
   if not Com1.Opened and
        not Prn1.Opened then exit;

  if cnt=0 then b:=0;

  if cnt=1 then
  Begin
    if testbit(bt,7) then
     port:=PcpCom1;
    if testbit(bt,5) then
     port:=PcpPRN;
  End;

  Case port of
   pcpCOM1:Begin
            if not com1.Opened then exit;
            
            s:='COM:';
            If (cnt>=2) And (cnt<=9) and testbit(bt,5) then
              b:=Setbit(b,Byte(cnt-2));
            inc(cnt);
            if cnt=12 then
            Begin
              port:=pcpNone;
              cnt:=0;
              ODS('Byte to Com Send:'+inttostr(b));
              if PCCom.OutBuffFree >= 1 then
              While true do
               if pccom.OutBuffUsed=0 then
               Begin
                 PCCom.PutChar(AnsiChar(b));
                 Break;
               End
               Else
                PCCom.ProcessCommunications;
             // slpv:=strtoint(foptions.edDelay.text);
             // if slpv>0 then
             //  sleep(slpv);

              //OutputDebugString(Pchar(String(chr(b))))
            End;
           End;
   pcpTCP:s:='TCP:';
   pcpPRN:Begin
           s:='PRN:';
           If (cnt>=2) And (cnt<=9) and testbit(bt,7) then
              b:=Setbit(b,Byte(cnt-2));
           Inc(Cnt);
            if cnt=12 then
            Begin
              port:=pcpNone;
              cnt:=0;
              ODS('Byte to PRN Send:'+inttostr(b));
              PrinterSend(b);
             // OutputDebugString(Pchar(String(chr(b))))
            End;
          End;
  End;
end;

procedure TdmCommd.OpenComm(Port:TPCPort);
Var s:String;
begin
  Case port of
   pcpCOM1:Begin
             s:='COM';
             if  com1.opened then exit;
             if foptions.ComGroup.ItemIndex=4 then exit;//no com port available
             
             Com1.Opened:=true;
             pcCom.ComNumber:=  foptions.ComGroup.ItemIndex+1;
             try
              pcCom.Baud:= strtoint(foptions.BaudGroup.items[foptions.BaudGroup.ItemIndex]);
             Except

             End;

             pccom.Parity:=tparity(foptions.parity.ItemIndex);
             try
               pccom.StopBits:=strtoint(foptions.edstop.text);
             except
               pccom.StopBits:=1;
             end;
             try
              pccom.DataBits:=strtoint(foptions.eddatab.text);
             Except
                  pccom.DataBits:=8;
             end;

             case foptions.rgFlow.ItemIndex of
               0:Begin    //RTS/CTS
                   pccom.HWFlowOptions:=[hwfUseRTS,hwfRequireCTS];
                 End;
               1:Begin    //DTR/DSR
                   pccom.HWFlowOptions:=[hwfUseDTR,hwfRequireDSR];
                 End;
               2:Begin    //None
                   pccom.HWFlowOptions:=[];
                 End;
             end;

             if foptions.chkEnabled.Checked then
             Begin
               pccom.DeviceLayer:=dlWinsock;
               pccom.WsAddress:=foptions.edAddress.text;
               pccom.WsLocalAddressIndex:=foptions.cmbLocalAddr.ItemIndex;
               if foptions.RGGroup.ItemIndex=0 then
                pccom.WsMode:=wsClient
              else
                pccom.WsMode:=wsServer;

               pccom.WsPort:=foptions.edPort.text;
             End
             Else
               pccom.DeviceLayer:=dlWin32;
             try
               pcCom.Open:=true;
             except
               on e:exception do
               Begin
                  LastError:=e.message+#13+'Goto General Options and select a valid com port.'#13'You may need to restart the emulator.'#13+
                   'ALSO you might have the dissassembly window open which uses COM1, so close it';
               End;
             end;
           end;
   pcpTCP:s:='TCP';
   pcpPRN:Begin
             s:='PRN';
             if PRN1.opened then exit;
           //  if foptions.prnGroup.ItemIndex<2 then
              openPrinterFile;
             PRN1.Opened:=true;
           end;
  End;
 // s:='Open '+s;
//  ODS(S);
end;

procedure TdmCommd.CloseComm(Port:TPCPort);
Var s:String;
begin
  Case port of
   pcpCOM1:Begin
             s:='COM';
             if not com1.opened then exit;
             Com1.Opened:=False;
           end;
   pcpTCP:s:='TCP:';
   pcpPRN:Begin
             s:='PRN';
             if not PRN1.opened then exit;
             PRN1.Opened:=False;
             try
              CloseFile(f);
             Except

             end;
           end;
  End;
  s:='Close '+s;

  ODS(S);
end;

procedure TdmCommd.SetState(Port:TPCPort;St:TPCState);
Var s:String;
begin
  Case port of
   pcpCOM1:Begin
             s:='COM';
             Com1.State:=st;
           end;
   pcpTCP:s:='TCP';
   pcpPRN:Begin
             s:='PRN';
             if not PRN1.opened then exit;
             PRN1.State:=st;
           end;
  End;

  Case st of
   pcsNone:S:=S+' None';
   pcsTransmit:S:=S+' Transmit';
   pcsReceive:S:=S+' Receive';
  End;

  s:='State '+s;
 // ODS(S);
end;

var bt:Byte=255;

function TdmCommd.ReadFromComm:byte;
begin

  if (cnt=0) or (cnt=1) then
  Begin
   if cnt=0 then //get the byte from pccomm
   Begin
    if pccom.CharReady then
     bt:=Byte(pccom.getchar);
   End;
   result:=0;
//   outputdebugString(Pchar('bit X:'+inttostr(byte(cnt))+' -->'+inttostr(result) ));
  End
  Else //Data bits
  Begin
    Result:=0;
    if testbit(bt,byte(cnt-2)) then
     Result:=1;
//   outputdebugString(Pchar('bit:'+inttostr(byte(cnt-2))+' -->'+inttostr(result) ));
  End;

  if cnt>=9 then //stop bit??
  Begin
   cnt:=0;
   recv:=false;
   dec(bt);
//   outputdebugString('=================');
  End
  else
   inc(cnt);
end;

function TdmCommd.CanReadFromCom: Boolean;
begin
  Result := recv and (pccom.CharReady or (Cnt<>0));//true mean we have something to send
end;

procedure TdmCommd.ReadyToReceive(fl:Boolean=True);
begin
  Recv:=fl;
  if fl then
   Cnt:=0;
end;

procedure TdmCommd.DataModuleCreate(Sender: TObject);
begin
  Cnt:=0;
end;

procedure TdmCommd.PrinterSend(b:Byte);
begin
 try
  OpenComm(pcpPrn);
 // if foptions.prnGroup.ItemIndex<2 then
   Write(f,char(b));
   Flush(f);
  Except
  End; 
end;

Var WeAreIn:Boolean=false;

Procedure TdmCommd.OpenPrinterfile;
var fn:String;
      fmode:integer;
Begin
    if prn1.Opened or WeAreIn then exit;
    WeAreIn:=True;
   try

    case foptions.prnGroup.ItemIndex of
      0:
        Begin
         fn:='PrinterNew.Prn';
         fmode:=2;
        End;
    1,2:
        Begin
          fn:=foptions.prnGroup.Items[foptions.prnGroup.ItemIndex];
          fmode:=1;
        End;
      3:Begin
          AssignPrn(F);
          ReWrite(F);
          Exit;
        end;
    end;

   try
    AssignFile(f,fn);
    FileMode := fmode;
    if fileexists(fn) then
     Append(f)
    else
     Rewrite(f);
   Except
     fnewbrain.Suspendemul;
     ShowMessage(fn +' is invalid try change options!!!');
     Application.Terminate;
   end;
    FileMode := 2;
    if foptions.prnGroup.ItemIndex=0 then
    Begin
     Writeln(f,'=====================');
     Writeln(f,'Newbrain Printer File');
     WriteLn(f,DateTimeToStr(Now));
     Writeln(f,'=====================');
    End;


   finally
     WeAreIn:=False;
   end;
End;

procedure TdmCommd.DataModuleDestroy(Sender: TObject);
begin
 if prn1.Opened then
 Begin
  try
   closefile(f);
  Except
  End;
  prn1.Opened:=false;
 End;
end;

end.
