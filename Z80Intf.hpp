﻿// CodeGear C++Builder
// Copyright (c) 1995, 2025 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Z80Intf.pas' rev: 36.00 (Windows)

#ifndef Z80IntfHPP
#define Z80IntfHPP

#pragma delphiheader begin
#pragma option push
#if defined(__BORLANDC__) && !defined(__clang__)
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#endif
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>

//-- user supplied -----------------------------------------------------------

namespace Z80intf
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
typedef int __fastcall (*TGetByteFunc)(int addr);

typedef void __fastcall (*TSetByteProc)(int addr, int NewByte);

typedef int __fastcall (*TInByteFunc)(int port);

typedef void __fastcall (*TOutByteProc)(int Port, int NewByte);

typedef bool __fastcall (*TGetInterrupt)();

typedef bool __fastcall (*TStepFunc)(int addr);

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TGetByteFunc Z80_getByte;
extern DELPHI_PACKAGE TSetByteProc Z80_SetByte;
extern DELPHI_PACKAGE TInByteFunc Z80_InB;
extern DELPHI_PACKAGE TOutByteProc Z80_OutB;
extern DELPHI_PACKAGE TGetInterrupt Z80_GetInterrupt;
extern DELPHI_PACKAGE TStepFunc Z80_step;
extern DELPHI_PACKAGE bool BreakEmulation;
extern DELPHI_PACKAGE bool Z80Steping;
}	/* namespace Z80intf */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_Z80INTF)
using namespace Z80intf;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Z80IntfHPP
