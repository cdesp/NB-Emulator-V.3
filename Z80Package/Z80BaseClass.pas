unit Z80BaseClass;

interface
uses Z80Intf;

Type

    // Z80 registers
    z80_register = (
        Z80_REG_AF,
        Z80_REG_BC,
        Z80_REG_DE,
        Z80_REG_HL,
        Z80_REG_IX,
        Z80_REG_IY,
        Z80_REG_PC,
        Z80_REG_SP,
        Z80_REG_AF2,
        Z80_REG_BC2,
        Z80_REG_DE2,
        Z80_REG_HL2,
        Z80_REG_IFF1,        // boolean - 1 or 0
        Z80_REG_IFF2,        // boolean - 1 or 0
        Z80_REG_IR,
        Z80_REG_IM,          // 0, 1, or 2
        Z80_REG_IRQVector,   // 0x00 to 0xff
        Z80_REG_IRQLine,      // boolean - 1 or 0
        Z80_REG_Halted       // boolean - 1 or 0
    );

    TRegister=z80_register;


  TZ80Interface=Class
       Z80_getByte:TGetByteFunc;
       Z80_SetByte:TSetByteProc;
       Z80_InB:TInByteFunc;
       Z80_OutB:TOutByteProc;
       Z80_GetInterrupt:TGetInterrupt;
       Z80_step:TStepFunc;
    Protected
    Public
      //implemented in Delphi
      Function Z_GetByte(Addr:Integer):Integer;
      Procedure Z_SetByte(Addr:Integer;b:Integer);
      Function Z_InB(port: Integer):Integer;
      Procedure Z_OutB(port:Integer;b:Integer);
      Function Z_GetInterrupt:boolean;
      function Z_Step(Addr:Integer):boolean;
     //implemented in C++
      Function Z_Emulate(cycles: integer): integer;Virtual;Abstract;
      Procedure Z_Reset;Virtual;Abstract;
      Function Z_Interrupt:integer;Virtual;Abstract;
      Function Z_Get_Reg(Reg: TRegister): integer;Virtual;Abstract;
      Procedure Z_Set_Reg(Reg: TRegister; value: Integer);Virtual;Abstract;
      procedure setZ80_getByte(f:TGetByteFunc);Virtual;Abstract;
      procedure setZ80_SetByte(f:TSetByteProc); Virtual;Abstract;
      procedure setZ80_InB(f:TInByteFunc); Virtual;Abstract;
      procedure setZ80_OutB(f:TOutByteProc); Virtual;Abstract;
      procedure setZ80_GetInterrupt(f:TGetInterrupt); Virtual;Abstract;
      procedure setZ80_Step(f:TStepFunc); Virtual;Abstract;
  End;

  function CreateCPPDescClass:TZ80Interface; external 'Z80Emulator.bpl';

implementation



{ TZ80Interface }

function TZ80Interface.Z_GetByte(Addr: Integer): Integer;
begin
   result:= Z80_getByte(Addr);
end;

function TZ80Interface.Z_GetInterrupt: boolean;
begin
  result:=Z80_GetInterrupt;
end;

function TZ80Interface.Z_InB(port: Integer): Integer;
begin
  result:=Z80_InB(port);
end;

procedure TZ80Interface.Z_OutB(port: Integer; b: Integer);
begin
  Z80_OutB(port,b);
end;

procedure TZ80Interface.Z_SetByte(Addr: Integer; b: Integer);
begin
  Z80_SetByte(Addr,b);
end;

function TZ80Interface.Z_Step(Addr:Integer):boolean;
begin
  result:=  Z80_step(addr);
end;

end.
