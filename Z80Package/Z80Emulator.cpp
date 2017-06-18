//---------------------------------------------------------------------------

#include <System.hpp>

#pragma hdrstop
#include "Z80Emulator.hpp"
#include "z80emu.cpp"
#include "z80Intf.hpp"



#pragma package(smart_init)


//---------------------------------------------------------------------------

//   Package source.
//---------------------------------------------------------------------------


//#pragma argsused
extern "C" int _libmain(unsigned long reason)
{
	return 1;
}




__fastcall TZ80Class::TZ80Class() :
		   TZ80Interface()     //Create
{

}

__fastcall TZ80Class::~TZ80Class()    //Destroy
{

}

int __fastcall TZ80Class::Z_Emulate(int cycles)
{
  return Z80Emulate(&zstate,cycles,NULL);
}


void __fastcall TZ80Class::Z_Reset(void)
{
  Z80Reset(&zstate);
}

int __fastcall TZ80Class::Z_Interrupt(void)
{
   return Z80Interrupt(&zstate,0,NULL);
}

int __fastcall TZ80Class::Z_Get_Reg(z80_register Reg)
{
  switch(Reg)
  {
	case Z80_REG_AF:return zstate.registers.word[Z80_AF];
	case Z80_REG_BC:return zstate.registers.word[Z80_BC];
	case Z80_REG_DE:return zstate.registers.word[Z80_DE];
	case Z80_REG_HL:return zstate.registers.word[Z80_HL];
	case Z80_REG_IX:return zstate.registers.word[Z80_IX];
	case Z80_REG_IY:return zstate.registers.word[Z80_IY];
	case Z80_REG_SP:return zstate.registers.word[Z80_SP];
	case Z80_REG_PC:return zstate.pc;
	case Z80_REG_AF2:return zstate.alternates[Z80_AF];
	case Z80_REG_BC2:return zstate.alternates[Z80_BC];
	case Z80_REG_DE2:return zstate.alternates[Z80_DE];
	case Z80_REG_HL2:return zstate.alternates[Z80_HL];
	case Z80_REG_IFF1:return zstate.iff1;
	case Z80_REG_IFF2:return zstate.iff2;
	case Z80_REG_IR:return (zstate.i << 8) & zstate.r;
	case Z80_REG_IM:return zstate.im;
	case Z80_REG_IRQVector:return 0;
	case Z80_REG_IRQLine:return 0;
	case Z80_REG_Halted:return zstate.status & Z80_STATUS_FLAG_HALT == 0;


   /*	case Z80_C:return zstate.registers.byte[Z80_C];
	case Z80_B:return zstate.registers.byte[Z80_B];
	case Z80_E:return zstate.registers.byte[Z80_E];
	case Z80_D:return zstate.registers.byte[Z80_D];
	case Z80_L:return zstate.registers.byte[Z80_L];
	case Z80_H:return zstate.registers.byte[Z80_H];
	case Z80_F:return zstate.registers.byte[Z80_F];
	case Z80_A:return zstate.registers.byte[Z80_A];
	case Z80_IXL:return zstate.registers.byte[Z80_IXL];
	case Z80_IXH:return zstate.registers.byte[Z80_IXH];
	case Z80_IYL:return zstate.registers.byte[Z80_IYL];
	case Z80_IYH:return zstate.registers.byte[Z80_IYH];*/
	default: return 0;
  }
}

void __fastcall TZ80Class::Z_Set_Reg(z80_register Reg, int value)
{
  switch(Reg)
  {
	case Z80_REG_AF:zstate.registers.word[Z80_AF]=value;
	case Z80_REG_BC:zstate.registers.word[Z80_BC]=value;
	case Z80_REG_DE:zstate.registers.word[Z80_DE]=value;
	case Z80_REG_HL:zstate.registers.word[Z80_HL]=value;
	case Z80_REG_IX:zstate.registers.word[Z80_IX]=value;
	case Z80_REG_IY:zstate.registers.word[Z80_IY]=value;
	case Z80_REG_SP:zstate.registers.word[Z80_SP]=value;
	case Z80_REG_PC:zstate.pc=value;
	case Z80_REG_AF2:zstate.alternates[Z80_AF]=value;
	case Z80_REG_BC2:zstate.alternates[Z80_BC]=value;
	case Z80_REG_DE2:zstate.alternates[Z80_DE]=value;
	case Z80_REG_HL2:zstate.alternates[Z80_HL]=value;
	case Z80_REG_IFF1:zstate.iff1=value;
	case Z80_REG_IFF2:zstate.iff2=value;


   /*	case Z80_C:zstate.registers.byte[Z80_C]=value & 0xff;break;
	case Z80_B:zstate.registers.byte[Z80_B]=value & 0xff;break;
	case Z80_E:zstate.registers.byte[Z80_E]=value & 0xff;break;
	case Z80_D:zstate.registers.byte[Z80_D]=value & 0xff;break;
	case Z80_L:zstate.registers.byte[Z80_L]=value & 0xff;break;
	case Z80_H:zstate.registers.byte[Z80_H]=value & 0xff;break;
	case Z80_F:zstate.registers.byte[Z80_F]=value & 0xff;break;
	case Z80_A:zstate.registers.byte[Z80_A]=value & 0xff;break;
	case Z80_IXL:zstate.registers.byte[Z80_IXL]=value & 0xff;break;
	case Z80_IXH:zstate.registers.byte[Z80_IXH]=value & 0xff;break;
	case Z80_IYL:zstate.registers.byte[Z80_IYL]=value & 0xff;break;
	case Z80_IYH:zstate.registers.byte[Z80_IYH]=value & 0xff;break;*/
  }

}


void __fastcall TZ80Class::setZ80_getByte(Z80intf::TGetByteFunc f)
{
  Z80_getByte = f;
}

void __fastcall TZ80Class::setZ80_SetByte(Z80intf::TSetByteProc f)
{
 Z80_SetByte = f;
}

void __fastcall TZ80Class::setZ80_InB(Z80intf::TInByteFunc f)
{
 Z80_InB = f;
}

void __fastcall TZ80Class::setZ80_OutB(Z80intf::TOutByteProc f)
{
 Z80_OutB = f;
}

void __fastcall TZ80Class::setZ80_GetInterrupt(Z80intf::TGetInterrupt f)
{
 Z80_GetInterrupt =f;
}

extern "C" __declspec(dllexport) TZ80Interface* __stdcall CreateCPPDescClass()
{
	MyZ80 = new  TZ80Class();
	return MyZ80;
}


//---------------------------------------------------------------------------
