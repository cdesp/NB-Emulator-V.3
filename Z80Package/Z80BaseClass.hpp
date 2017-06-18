// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Z80BaseClass.pas' rev: 32.00 (Windows)

#ifndef Z80baseclassHPP
#define Z80baseclassHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Z80Intf.hpp>

//-- user supplied -----------------------------------------------------------

namespace Z80baseclass
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TZ80Interface;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM z80_register : unsigned char { Z80_REG_AF, Z80_REG_BC, Z80_REG_DE, Z80_REG_HL, Z80_REG_IX, Z80_REG_IY, Z80_REG_PC, Z80_REG_SP, Z80_REG_AF2, Z80_REG_BC2, Z80_REG_DE2, Z80_REG_HL2, Z80_REG_IFF1, Z80_REG_IFF2, Z80_REG_IR, Z80_REG_IM, Z80_REG_IRQVector, Z80_REG_IRQLine, Z80_REG_Halted };

typedef z80_register TRegister;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TZ80Interface : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	Z80intf::TGetByteFunc Z80_getByte;
	Z80intf::TSetByteProc Z80_SetByte;
	Z80intf::TInByteFunc Z80_InB;
	Z80intf::TOutByteProc Z80_OutB;
	Z80intf::TGetInterrupt Z80_GetInterrupt;
	int __fastcall Z_GetByte(int Addr);
	void __fastcall Z_SetByte(int Addr, int b);
	int __fastcall Z_InB(int port);
	void __fastcall Z_OutB(int port, int b);
	bool __fastcall Z_GetInterrupt(void);
	void __fastcall Z_StepProc(void);
	virtual int __fastcall Z_Emulate(int cycles) = 0 ;
	virtual void __fastcall Z_Reset(void) = 0 ;
	virtual int __fastcall Z_Interrupt(void) = 0 ;
	virtual int __fastcall Z_Get_Reg(z80_register Reg) = 0 ;
	virtual void __fastcall Z_Set_Reg(z80_register Reg, int value) = 0 ;
	virtual void __fastcall setZ80_getByte(Z80intf::TGetByteFunc f) = 0 ;
	virtual void __fastcall setZ80_SetByte(Z80intf::TSetByteProc f) = 0 ;
	virtual void __fastcall setZ80_InB(Z80intf::TInByteFunc f) = 0 ;
	virtual void __fastcall setZ80_OutB(Z80intf::TOutByteProc f) = 0 ;
	virtual void __fastcall setZ80_GetInterrupt(Z80intf::TGetInterrupt f) = 0 ;
public:
	/* TObject.Create */ inline __fastcall TZ80Interface(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TZ80Interface(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern "C" TZ80Interface* __fastcall CreateCPPDescClass(void);
}	/* namespace Z80baseclass */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_Z80BASECLASS)
using namespace Z80baseclass;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Z80baseclassHPP
