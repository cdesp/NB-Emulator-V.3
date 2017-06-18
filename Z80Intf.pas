unit Z80Intf;

interface

type
  TGetByteFunc=function(addr:integer):integer;
  TSetByteProc=Procedure(addr:integer;NewByte:integer);
  TInByteFunc=function(port:integer):integer;
  TOutByteProc=Procedure(Port:integer;NewByte:integer);
  TGetInterrupt=function:Boolean;
  TStepProc=procedure (Const pc: word);


var
 Z80_getByte:TGetByteFunc=nil;
 Z80_SetByte:TSetByteProc=nil;
 Z80_InB:TInByteFunc=nil;
 Z80_OutB:TOutByteProc=nil;
 Z80_GetInterrupt:TGetInterrupt=nil;
 Z80_StepProc:TStepProc=nil;
 BreakEmulation:Boolean=false;
 Z80Steping:boolean=false;


implementation

end.
