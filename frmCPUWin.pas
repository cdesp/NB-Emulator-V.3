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
unit frmCPUWin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,Math;

type


  TfCPUWin = class(TForm)
    FlagBox: TGroupBox;
    FL1: TLabel;
    FL2: TLabel;
    FL3: TLabel;
    FL4: TLabel;
    FL5: TLabel;
    FL6: TLabel;
    FL7: TLabel;
    FL8: TLabel;
    GroupBox1: TGroupBox;
    LAF: TLabel;
    LBC: TLabel;
    LDE: TLabel;
    LHL: TLabel;
    LIX: TLabel;
    LIY: TLabel;
    LIR: TLabel;
    LSP: TLabel;
    LPC: TLabel;
    EDAF: TEdit;
    EDBC: TEdit;
    EDDE: TEdit;
    EDHL: TEdit;
    EDIX: TEdit;
    EDIY: TEdit;
    EDIR: TEdit;
    EDSP: TEdit;
    EDPC: TEdit;
    EDAF2: TEdit;
    EDBC2: TEdit;
    EDDE2: TEdit;
    EDHL2: TEdit;
    Timer1: TTimer;
    Label1: TLabel;
    EdIF1: TEdit;
    EdIF2: TEdit;
    Label2: TLabel;
    EdIRQV: TEdit;
    EdIRQL: TEdit;
    Label3: TLabel;
    EdHLT: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FLClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Timer1Timer(Sender: TObject);
  private
    AF: WORD;
    BC: WORD;
    DE: WORD;
    HL: WORD;
    AF2: WORD;
    BC2: WORD;
    DE2: WORD;
    HL2: WORD;
    IX: WORD;
    IY: WORD;
    IR: WORD;
    SP: WORD;
    PC: WORD;
    IF1: WORD;
    IF2: WORD;
    IRQV: WORD;
    IRQL: WORD;
    HLT: WORD;
    procedure ShowFlag;
    procedure ShowRegisters;

    function GetFLAG: Byte;
    { Private declarations }
  public
    procedure GetRegisters;
    property FLAG: Byte read GetFLAG;
    { Public declarations }
  end;

var
  fCPUWin: TfCPUWin;

implementation
USES z80baseclass,unbmemory,jclLogic,new;

{$R *.dfm}

Function NBLow(W:Word):Byte;
Begin
 Result:=W Mod 256;
end;

Function NBHigh(W:Word):Byte;
Begin
 Result:= W div 256;
end;

procedure TfCPUWin.FormCreate(Sender: TObject);
begin
  Application.HintHidePause:=6500;
  Left:=10;
  Top:=10;
end;

procedure TfCPUWin.FLClick(Sender: TObject);
CONST MYUPPER=['C','N','P','X','H','Z','S'];
Var lx:String;
    b:Byte;
begin
  lx:=(Sender as TLabel).Caption;
  if lx[1] in MYUPPER then
    SetBit(GetFlag,Byte((Sender as TLabel).Tag))
  Else
    ClearBit(GetFlag,Byte((Sender as TLabel).Tag));

end;

procedure TfCPUWin.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 canclose:=tag>0;
 Timer1.Enabled:=not canclose;
end;

function TfCPUWin.GetFLAG: Byte;
begin
  AF := z80_get_reg(Z80_REG_AF);
  Result:=NBLow(AF);
end;

procedure TfCPUWin.GetRegisters;
begin
  AF := z80_get_reg(Z80_REG_AF);
  BC := z80_get_reg(Z80_REG_BC);
  DE := z80_get_reg(Z80_REG_DE);
  HL := z80_get_reg(Z80_REG_HL);
  AF2 := z80_get_reg(Z80_REG_AF2);
  BC2 := z80_get_reg(Z80_REG_BC2);
  DE2 := z80_get_reg(Z80_REG_DE2);
  HL2 := z80_get_reg(Z80_REG_HL2);
  IX := z80_get_reg(Z80_REG_IX);
  IY := z80_get_reg(Z80_REG_IY);
  IR := z80_get_reg(Z80_REG_IR);
  SP := z80_get_reg(Z80_REG_SP);
  PC := z80_get_reg(Z80_REG_PC);
  IF1 := z80_get_reg(Z80_REG_IFF1);
  IF2 := z80_get_reg(Z80_REG_IFF2);
  IRQV := z80_get_reg(Z80_REG_IRQVector);
  IRQL := z80_get_reg(Z80_REG_IRQLine);
  HLT := z80_get_reg(Z80_REG_HALTED);
end;

procedure TfCPUWin.ShowFlag;
Var f:Byte;
Begin
  f:=GetFLAG;
  if TestBit(f,0) then
   FL1.Caption:='C'
  Else
   FL1.Caption:='c';

  if TestBit(f,1) then
   FL2.Caption:='N'
  Else
   FL2.Caption:='n';

  if TestBit(f,2) then
   FL3.Caption:='P'
  Else
   FL3.Caption:='p';

  if TestBit(f,3) then
   FL4.Caption:='X'
  Else
   FL4.Caption:='x';

  if TestBit(f,4) then
   FL5.Caption:='H'
  Else
   FL5.Caption:='h';

  if TestBit(f,5) then
   FL6.Caption:='X'
  Else
   FL6.Caption:='x';

  if TestBit(f,6) then
   FL7.Caption:='Z'
  Else
   FL7.Caption:='z';

  if TestBit(f,7) then
   FL8.Caption:='S'
  Else
   FL8.Caption:='s';
end;

procedure TfCPUWin.ShowRegisters;
    Procedure ShowRegister(Txt:TEdit;v:Word);
    Begin
      Txt.Text:=inttohex(v,4);
      Txt.Hint:=Format('%d (Hi:%d,Lo:%d)',[v,NBHigh(v),NBLow(v)]);
      Txt.ShowHint:=True;
    End;
Begin
  ShowRegister(EDAF,AF);
  ShowRegister(EDBC,BC);
  ShowRegister(EDDE,DE);
  ShowRegister(EDHL,HL);
  ShowRegister(EDAF2,AF2);
  ShowRegister(EDBC2,BC2);
  ShowRegister(EDDE2,DE2);
  ShowRegister(EDHL2,HL2);
  ShowRegister(EDIX,IX);
  ShowRegister(EDIY,IY);
  ShowRegister(EDIR,IR);
  ShowRegister(EDSP,SP);
  ShowRegister(EDPC,PC);
  ShowRegister(EDIF1,IF1);
  ShowRegister(EDIF2,IF2);
  ShowRegister(EDIRQV,IRQV);
  ShowRegister(EDIRQL,IRQL);
  ShowRegister(EDHLT,HLT);
end;

procedure TfCPUWin.Timer1Timer(Sender: TObject);
begin
 GetRegisters;
 ShowRegisters;
 ShowFlag;
end;

end.
