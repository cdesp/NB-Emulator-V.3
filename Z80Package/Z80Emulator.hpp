#ifdef _WIN32
#include <tchar.h>
#endif


#ifndef __ZEXCPU_INCLUDED__
#define __ZEXCPU_INCLUDED__

#include "Z80BaseClass.hpp";
#include "z80emu.hpp"
#define Z80_CPU_SPEED           4000000   /* In Hz. */
#define CYCLES_PER_STEP         (Z80_CPU_SPEED / 50)

Z80_STATE zstate;

class __declspec(delphiclass) TZ80Class : public TZ80Interface
{
	public:
		__fastcall TZ80Class();          //Create
		__fastcall virtual ~TZ80Class(); //Destroy

		virtual int __fastcall Z_Emulate(int cycles)  ;
		virtual void __fastcall Z_Reset(void)  ;
        virtual int __fastcall Z_Interrupt(void);
		virtual int __fastcall Z_Get_Reg(z80_register Reg)  ;
		virtual void __fastcall Z_Set_Reg(z80_register Reg, int value)  ;
		virtual void __fastcall setZ80_getByte(Z80intf::TGetByteFunc f);
		virtual void __fastcall setZ80_SetByte(Z80intf::TSetByteProc f);
		virtual void __fastcall setZ80_InB(Z80intf::TInByteFunc f);
		virtual void __fastcall setZ80_OutB(Z80intf::TOutByteProc f);
		virtual void __fastcall setZ80_GetInterrupt(Z80intf::TGetInterrupt f);
};

TZ80Interface* MyZ80;

#endif
