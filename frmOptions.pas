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
