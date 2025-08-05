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

unit uNBTypes;

interface

Const
   NBSLen=6;

{.$Define NBDebug}

Type

  TPair = record
    case byte of
      0: (l, h: byte);
      1: (w: Word);
  end;


  TZ80ASMRegs = record
    AF,BC,DE,HL,IX,IY,PC,SP: TPair;
    AF1,BC1,DE1,HL1: TPair;
    IFF1, IFF2: Byte;
    IR: TPAIR;
    IM:Byte;
    IRQV:Byte;
    IRQL:Byte;
  end;

TPerif=(pNone,MicroPage,DataPack,PIBOX);

function GetBinaryFromByte(b:Byte): String;

function GetBinaryFromByteReverse(b:Byte): String;

Procedure SetPeripheral(perif:TPerif);

var Breaked:boolean;
    rom3d:Integer;
    AppPath:String='';
    vers:integer=1;      //Major Rom Version
    svers:integer=91;    //Minor Rom Version
    DefaultAsmDir:String='ASM\';

    WithMicroPage:Boolean=false;
    WithDataPack:Boolean=false;
    WithPIBOX:boolean=false;

implementation

Procedure SetPeripheral(perif:TPerif);
Begin           
  WithMicroPage:=false;
  WithDataPack:=false;
  WithPIBOX:=false;
  case Perif of
     MicroPage:WithMicroPage:=true;
     DataPack:WithDataPack:=true;
     PIBOX:WithPIBOX:=true;
  end;
end;

//convert a byte to binary string
function GetBinaryFromByte(b:Byte): String;
Begin
  result:='00000000';
  if b and 128 = 128 then result[1]:='1';
  if b and 64 = 64 then result[2]:='1';
  if b and 32 = 32 then result[3]:='1';
  if b and 16 = 16 then result[4]:='1';
  if b and 8 = 8 then result[5]:='1';
  if b and 4 = 4 then result[6]:='1';
  if b and 2 = 2 then result[7]:='1';
  if b and 1 = 1 then result[8]:='1';
End;

//convert a byte to binary string reversed
function GetBinaryFromByteReverse(b:Byte): String;
Begin
  result:='00000000';
  if b and 128 = 128 then result[8]:='1';
  if b and 64 = 64 then result[7]:='1';
  if b and 32 = 32 then result[6]:='1';
  if b and 16 = 16 then result[5]:='1';
  if b and 8 = 8 then result[4]:='1';
  if b and 4 = 4 then result[3]:='1';
  if b and 2 = 2 then result[2]:='1';
  if b and 1 = 1 then result[1]:='1';
End;


end.
