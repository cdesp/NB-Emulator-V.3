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
