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

unit frmOptions;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  Tfoptions = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    ComGroup: TRadioGroup;
    BaudGroup: TRadioGroup;
    prnGroup: TRadioGroup;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edstop: TEdit;
    parity: TRadioGroup;
    Label2: TLabel;
    edDatab: TEdit;
    GroupBox2: TGroupBox;
    chkEnabled: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    edPort: TEdit;
    RGGroup: TRadioGroup;
    cmbLocalAddr: TComboBox;
    Label5: TLabel;
    Label6: TLabel;
    edAddress: TEdit;
    GroupBox3: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Fore: TColorBox;
    Back: TColorBox;
    GroupBox4: TGroupBox;
    cbEnglish: TCheckBox;
    rgFlow: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure chkEnabledClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadOptions;
    procedure SaveOptions;

  end;

var
  foptions: Tfoptions;

implementation
uses inifiles, uPCComms;

{$R *.DFM}

procedure Tfoptions.FormCreate(Sender: TObject);
begin
  LoadOptions;
end;

procedure Tfoptions.FormShow(Sender: TObject);
begin
 cmblocaladdr.items.assign(dmCommd.PCCom.WsLocalAddresses);
 chkEnabledClick(nil);
 LoadOptions;
end;

procedure Tfoptions.LoadOptions;
Var Inif:TIniFile;
    pth:String;
begin
  pth:=ExtractFilePath(Application.Exename);

  Inif:=TIniFile.create(pth+'Config.Ini');
  try
   comgroup.itemindex:=inif.ReadInteger('ComPorts','Port',comgroup.itemindex);
   Baudgroup.itemindex:=inif.ReadInteger('ComPorts','Baud',Baudgroup.itemindex);
   Parity.itemindex:=inif.ReadInteger('ComPorts','Parity',Parity.itemindex);
   edstop.text:=inif.ReadString('ComPorts','Stop',edstop.text);
   edDataB.text:=inif.ReadString('ComPorts','DataBits',edDataB.text);
   rgFlow.ItemIndex:=inif.ReadInteger('ComPorts','FlowControl',rgFlow.itemindex);

   PrnGroup.itemindex:=inif.ReadInteger('Printer','Printer',PrnGroup.itemindex);

   chkEnabled.checked:=inif.ReadBool('TCPIP','ISEnabled',chkEnabled.checked);
   edAddress.text:=inif.ReadString('TCPIP','Address',edAddress.text);
   edPort.text:=inif.ReadString('TCPIP','Port',edPort.text);
   rgGroup.ItemIndex:=inif.ReadInteger('TCPIP','ClnSrv',rgGroup.itemindex);
   cmbLocalAddr.ItemIndex:=inif.ReadInteger('TCPIP','LocalIP',cmbLocalAddr.ItemIndex);

  Fore.Selected:= inif.ReadInteger('Colors','Foreground',clWhite);
  Back.Selected:= inif.readInteger('Colors','Background',clBlack);

  cbEnglish.Checked:=   inif.ReadBool('Keyboard','English',False);
  Finally
     inif.free;
  End;
end;

procedure Tfoptions.SaveOptions;
Var Inif:TIniFile;
    pth:String;
begin
  pth:=ExtractFilePath(Application.Exename);

  Inif:=TIniFile.create(pth+'Config.Ini');
  try
   inif.WriteInteger('ComPorts','Port',comgroup.itemindex);
   inif.WriteInteger('ComPorts','Baud',Baudgroup.itemindex);
   inif.WriteInteger('ComPorts','Parity',Parity.itemindex);
   inif.WriteString('ComPorts','Stop',edstop.text);
   inif.WriteString('ComPorts','DataBits',edDataB.text);
   inif.WriteInteger('ComPorts','FlowControl',rgFlow.itemindex);

   inif.WriteInteger('Printer','Printer',PrnGroup.itemindex);

   inif.WriteBool('TCPIP','ISEnabled',chkEnabled.checked);
   inif.WriteString('TCPIP','Address',edAddress.text);
   inif.WriteString('TCPIP','Port',edPort.text);
   inif.WriteInteger('TCPIP','ClnSrv',rgGroup.itemindex);
   inif.WriteInteger('TCPIP','LocalIP',cmbLocalAddr.ItemIndex);

   inif.WriteInteger('Colors','Foreground',Fore.Selected);
   inif.WriteInteger('Colors','Background',Back.Selected);
   inif.WriteBool('Keyboard','English',cbEnglish.Checked);

  Finally
     inif.free;
  End;

end;

procedure Tfoptions.Button1Click(Sender: TObject);
begin
  SaveOptions;
end;

procedure Tfoptions.Button2Click(Sender: TObject);
begin
 LoadOptions;
end;

procedure Tfoptions.chkEnabledClick(Sender: TObject);
Var f:Boolean;
begin
 f:=chkenabled.Checked;
 edAddress.enabled:=f;
 edPort.Enabled:=f;
 RGGroup.Enabled:=f;
 cmbLocalAddr.Enabled:=f;
end;

end.
