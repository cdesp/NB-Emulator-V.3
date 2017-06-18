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

unit uAsm;

interface
Uses math,Classes;


Const delims:String=', :';
      ASMNOTFOUND=-99999;
      UseSixLetter=True;
      MaxOps=17;
Var
      ValidOps:array[0..maxops-1]of string=
                ('.SHL.','.SHR.','.MOD.','.LT.','.GT.','.GE.','.LE.',
                 '.NOT.','.AND.','.OR.','.XOR.','.LOW.','.HIGH.',
                 '*','/','+','-');

Type

   TCStatus=(csNew,csCMDONLY,csCMDPASS2,csCMDOK,csCMDERROR);

   TCmpInst=Record    //Compiled instruction record
      OrigCmd:String;
      OrigLine:Integer;
      CMDIDX:Integer;
      Instruct:String;
      Addr:Integer;
      AddrHex:String;
      ByteCnt:Integer;
      Bytes:Array[1..4] of Byte;
      Label1Exp:String;
      Label2Exp:String;
      HasLabel:Boolean;
      Comments:String;
      Status:TCStatus;
   End;
   PCmpInst=^TCmpInst;

   TDSAsmLabels=Class(TStringlist)
  private
    function FixLbs(s: String): String;
  protected
   Public
     Constructor Create;
     procedure AddLabel(Lbs: String; Value: Integer=ASMNOTFOUND);
     function GetLabel(LBS: String): Integer;
     function GetLabelStr(LBS:String): String;
     function LabelExists(Lbs:String):Boolean;
   end;

   TOnCompileMessage=Procedure (Sender:TObject;Mes:String) of Object;
   TOnCompileProgress=Procedure (Sender:TObject;Pass:Integer;Position:Integer;MaxPos:Integer) of Object;

   TCompiledList=Class(Tlist)
   private
     CheckAtPass2: Boolean;
     CMDIDX: Integer;
     CurLine: Integer;
     CurText: string;
     FErrorsFound: Boolean;
     FDollar: Integer;
     FErrors: Integer;
     FISError: Boolean;
     FOnCompileMessage: TOnCompileMessage;
     FOnCompileProgress: TOnCompileProgress;
     LastDollar: Integer;
     PartArg1: string;
     PartArg2: string;
     PartCMD: string;
     PartCnt: Integer;
     PartCOM: string;
     PartLBL: string;
     Parts: Array[0..4] of String;
     PartsExcess: Array[0..10] of String;
     SourceList: TStringList;
     zPartCMD: string;
     zPartArg1: string;
     zPartArg2: string;
    function ReplaceIntCharToString(var S: String): Boolean;
    procedure IncludeFile(fn: String);
    Class function DelimIsBetween(s: String; p: Integer; Delims: String;
      var Lastp: Integer): Boolean;
    procedure GotoLastDollar;
    procedure ClearItems;
    function IsGlobalLabel(Lbl: String): Boolean;
    procedure AddLabel(Lbs: String; Value: Integer=ASMNOTFOUND);
    function GetLabelStr(Lbl: String): string;
    function GetLabel(Lbl: String): Integer;
    function IsSpecialKeyword(Cmd: String): Boolean;
    function ContainsIX(Arg: String; var p1, p2: String): Boolean;
    function ContainsIY(Arg: String; var p1, p2: String): Boolean;
    function FindCommand(CMDName: String; var Startat: Integer): Boolean;
    procedure addByte(Var p: PCmpInst; b: Byte; opIdx: Integer=-1);
    procedure EvaluateLater(Var p: PCmpInst; ByteCnt: Integer;Eval:String;opIdx:Integer=-1);
    function Arg2IsString: Boolean;
    function GetValidLabel(p: PCmpInst; var Lbl: String): Boolean;
    procedure Command2Bytes(p: PCmpInst);
    function IsValidInt(var s: String): Boolean;
    function IsValidHex(var s: String): Boolean;
    function GetInteger(S: String; var res: Integer): Boolean;
    function SplitArg(const Arg: String; var P1, P2: String): Boolean;
    function ContainsIXIY(Arg: String;Var p1,p2:String): Boolean;
    function RemoveBrackets(Const Arg:string;Brc:String='()'): String;
    function IsRegister(Arg: String): Boolean;
    function IsPseudoOp(Cmd: String; Const OpToCheck: Integer=-1): Boolean;
    function zHasANumber(s: String): Boolean;
    function InBetween(s:String;chs:String='()'): Boolean;
    function InBrackets(s: String): Boolean;
    procedure ADDLog(e: String;Addline:boolean=True);
    class procedure Cnv2Bytes(N: Word; var BL, BH: Byte); static;
    procedure splitZ80Command(s: string);
    function CheckCommand: Boolean;
    function CheckPseudoOps: Boolean;
    procedure ADDError(e: String);
    procedure NbParsEval1GetValue(Sender: TObject; Identifier: string;
      var Value: Extended; var Undefined: Boolean);
     Function NewCmd:PCmpInst;
     function Arg1IsString: Boolean;
     function GetDollar: Integer;
     class function GetFirstPart(var S, part1: String; Delimeters: string; const
         AsWord: Boolean = False;WasString:Boolean=False): Boolean;
     function ISCmdRelative: Boolean;
     function LabelExists(Lbl:String): Boolean;
     procedure SetDollar(const Value: Integer);
     function SplitCommand(const Txt: string): Boolean;
   protected
     procedure DoOnCompileMessage(const MSG: string); virtual;
     procedure DoOnCompileProgress(const Pass, cPos, PosMax: Integer); virtual;
   Public
     IsProject: Boolean;
     IsRelative: Boolean;
     Destructor Destroy;Override;
     Constructor Create;Virtual;
     procedure Compile2(Txt: string);
    procedure DoPass2(IsLinking: Boolean = False);
    function getcompilationastext: String;
     function ISKeyword(Cmd: String): Boolean;
     procedure MakeAbsolute(NewDollar: Integer);
     property Dollar: Integer read GetDollar write SetDollar;
   published
     property Errors: Integer read FErrors write FErrors;
     property ErrorsFound: Boolean read FErrorsFound write FErrorsFound;
     property ISError: Boolean read FISError write FISError;
     property OnCompileMessage: TOnCompileMessage read FOnCompileMessage write
         FOnCompileMessage;
     property OnCompileProgress: TOnCompileProgress read FOnCompileProgress write
         FOnCompileProgress;
   end;

Var
    Compiler:TCompiledList=nil;
    AsmLabels:TDSAsmLabels;
    GlobalLabels:TDSAsmLabels;
    ExternLabels:TDSAsmLabels;

implementation
uses udisasm,sysutils,uStrings,windows,uNBParser,uNBTypes, FatExpression;

Const MaxKW=15;
      MaxSpecialKW=4;
      opOrg=0;
      opEQU=8;
      MaxReg=25;
      MaxRelCMDs=2;
Var
    SpecialKW:Array[0..MaxSpecialKW] of String=('JR','JP','CALL','DJNZ','RST');
    PseudoKW:Array[0..MaxKW] of String=('ORG','DEFB','DEFW','DEFM','DB','DS','DEFS','DW','EQU','PSECT','GLOBAL','NAME','EJECT','DM','TITLE','INCLUDE');
    Registers:Array[1..MaxReg] of String=('A','B','C','D','E','F','H','L','I','R',
                                      'AF','BC','DE','HL','IR','IX','IY','SP',
                                      'Z','NZ','NC','PO','PE','P','M');
    RelativeCommands:Array[1..MaxRelCmds] of string=('JR','DJNZ');

Procedure TCompiledList.IncludeFile(fn:String);
Var sl:Tstringlist;
    i:Integer;
Begin
  sl:=Tstringlist.create;
  TRy
    sl.LoadFromFile(AppPath+DefaultAsmDir+fn);
    for i := 0 to sl.Count - 1 do
      SourceList.Insert(Curline+i,sl[i]);
   // SourceList.Savetofile('h:\test.txt');
  finally
    sl.free;
  end;
end;

Procedure TCompiledList.NbParsEval1GetValue(Sender: TObject;
  Identifier: string; var Value: Extended; var Undefined: Boolean);
begin
   Value:=GetLabel(Identifier);
   Undefined := Value=ASMNOTFOUND;
end;

Procedure TCompiledList.ClearItems;
Var i:Integer;
begin
   for i := Count - 1 Downto 0 do
   Begin
     FreeMem(Items[i]);
   end;
end;

destructor TCompiledList.Destroy;
begin
  ClearItems;
  inherited;
end;

Class Procedure TCompiledList.Cnv2Bytes(N:Word;Var BL,BH:Byte);
Begin
        BH:=N div 256;
        BL:=N-(bH*256);
End;

Function TCompiledList.IsValidHex(Var s:String):Boolean;
Const ValidHex=['0'..'9','A'..'F'];
Var l,i:Integer;

Begin
   s:=Uppercase(s);
   Result:=False;
   if pos('+',s)>0  then exit;
   l:=Length(s);
   if (l>1)  then
   Begin
     if (s[1]='$') and (S[2] in ValidHex) then
      s:=Copy(s,2,maxint)+'h';
     if  (s[l]='h') or (s[l]='H') then
     Begin
       Result:=True;
       for i := 1 to l-1 do
        Result:=Result and (s[i] in ValidHex) ;
     end;
   end;
end;

Function TCompiledList.IsValidInt(Var s:String):Boolean;
Const ValidInt=['0'..'9'];
Var l,i:Integer;
    k:Integer;
Begin
   Result:=False;
   l:=Length(s);
   if (l>=1)  then
   Begin
     Result:=True;
     if (s[1]='+') or (s[1]='-') then
       k:=2
     Else
       k:=1;  
     for i := k to l do
        Result:=Result and (s[i] in ValidInt) ;
   end;
end;

procedure TCompiledList.AddLabel(Lbs: String; Value: Integer=ASMNOTFOUND);
Begin
   //we put it here even if it is global cause sometimes global declaration is after
   AsmLabels.AddLabel(Lbs,Value);
   if GlobalLabels.LabelExists(lbs) then
    GlobalLabels.AddLabel(lbs,Value);
end;

function TCompiledList.IsGlobalLabel(Lbl:String): Boolean;
Begin
  Result:=GlobalLabels.LabelExists(lbl);
end;

function TCompiledList.LabelExists(Lbl:String): Boolean;
Begin
   Result:=AsmLabels.LabelExists(Lbl) or
            GlobalLabels.LabelExists(Lbl)
            or ExternLabels.LabelExists(Lbl);
end;

Function TCompiledList.GetLabel(Lbl:String):Integer;
Begin
   Result:=AsmLabels.GetLabel(Lbl);
   if Result=ASMNOTFOUND then
      Result:=GlobalLabels.GetLabel(Lbl);
     if Result=ASMNOTFOUND then
       Result:=ExternLabels.GetLabel(Lbl);
end;

function TCompiledList.GetLabelStr(Lbl: String): string;
var k:integer;
Begin
   k:=GetLabel(Lbl);
   if k<>ASMNOTFOUND then
      Result:=InttoHex(k,4)
   else
     Result:='';   
end;

Function TCompiledList.ReplaceIntCharToString(Var S:String):Boolean;
Var i,k:Integer;           //One Replacement only
    s1,s2,s3,st:String;
    res:string;
Begin
  s:=StringReplace(s,'''''''''',inttostr(ord('''')),[]);
  s:=StringReplace(s,'''''''''',inttostr(ord('''')),[]);

  Result:=false;
  k:=pos('''',s);
  if k=0 then exit;
  s1:=Copy(s,1,k-1);//before string
  s2:=Copy(s,k+1,999);//Rest string

  k:=pos('''',s2);
  if k=0 then exit;
  s3:=copy(s2,k+1,999); //Last Part
  s2:=copy(s2,1,k-1);//Our String

  //Now lets check if we can convert it
  if Length(s2)>2 then exit;

  if Length(s2)=1 then
   Res:=inttostr(Ord(s2[1]))
  Else
  if Length(s2)=2 then
    Res:=inttostr(Ord(s2[1])+Ord(s2[2])*256) ;

  S:=s1+Res+s3;
  result:=true;

End;

Function TCompiledList.GetInteger(S:String;Var res:Integer):Boolean;
var p,lp:integer;
Begin
  Result:=False;
  while ReplaceIntCharToString(S) do;
{  if InBetween(s,'''''') or  InBetween(s,'""') then
  Begin
     s:=copy(s,2,Length(s)-2);
     if Length(s)=2 then
       if (s[1]='''') and (s[1]=s[2]) then
         s:='''';


     if Length(s)=1 then //just a char
     Begin
        Res:=Ord(s[1]);
        Result:=True;
     end
     Else ;//A string
  end
  Else}
  if IsValidHex(s) then
  Begin
   Res:=HexToInt(s);
   result:=True;
  end
  Else
  if IsValidBin(s) then
  Begin
   Res:=BinToInt(s);
   result:=True;
  end
  else
  if IsValidOkt(s) then
  Begin
   Res:=OktToInt(s);
   result:=True;
  end
  Else
  if IsValidInt(s) then
  Begin
   Res:=Strtoint(s);
   result:=True;
  end
  Else
  if LabelExists(s) then
  Begin
   Res:=GetLabel(s);
   result:=True;
  end
  Else
  Begin //check for $ dollar = Current PC
    //do not replace if $ is in quotes i.e. '$'
    p:=pos('$',s);
    if (p>0) and          //todo: make a function to support all $s
       not DelimIsBetween(s,p,'''"',lp) then
         s:= StringReplace(s,'$','DOLLAR',[rfReplaceAll]);
    //check the label or evaluate
    if LabelExists(s) then
    Begin
      Res:=GetLabel(s);
      result:=True;
    end
    Else
     Result:= nbpars.Evaluate(s,res);
  end;
  result:= result and (res<>ASMNOTFOUND);
end;

Procedure TCompiledList.addByte(Var p:PCmpInst;b:Byte;opIdx:Integer=-1);
Begin
      if (p=nil) or (p.ByteCnt=4) or (p.Status=csCMDPASS2) then
        p:=newcmd;
      p.OrigLine:=CurLine;
      p.ByteCnt:=p.ByteCnt+1;
      if p.ByteCnt=1 then
      Begin
       p.Comments:=PartCom;
       p.Addr:=Dollar;
       p.AddrHex:=inttohex(p.Addr,4);
       p.Instruct:=PartCMD;
       p.Label1Exp:=PartArg1;
       p.Label2Exp:=PartArg2;
       if (OpIdx<>-1) and (p.cmdidx=-1) then
         p.CMDIDX:=OpIdx; //pseudo op
       p.OrigCmd:=CurText;
      End;
      p.Bytes[p.ByteCnt]:=b;
      Dollar:=Dollar+1;
      p.Status:=csCMDOK;
End;

Procedure TCompiledList.EvaluateLater(Var p:PCmpInst;ByteCnt:Integer;Eval:String;opIdx:Integer=-1);
var i:integer;
Begin
    for i := 1 to ByteCnt do
     Addbyte(p,0,opidx);
    p.Status:=csCMDPASS2;
    p.Label1Exp:=Eval;//to be evaluated;
    p.Label2Exp:='';
End;

Function TCompiledList.CheckPseudoOps:Boolean;
Var OpIdx:Integer;
    p:PCmpInst;

    Procedure FindOp;
    Begin
       if Sametext(PartCMD,'DM') or Sametext(PartCMD,'DEFM') then
          opidx:=0
       Else
       if Sametext(PartCMD,'DB') or Sametext(PartCMD,'DEFB') then
          opidx:=1
       Else
       if Sametext(PartCMD,'DS') or Sametext(PartCMD,'DEFS') then
          opidx:=2
       Else
       if Sametext(PartCMD,'DW') or Sametext(PartCMD,'DEFW') then
          opidx:=3
       Else
       if Sametext(PartCMD,'EQU') then
          opidx:=4
       Else
       if Sametext(PartCMD,'ORG') then
          opidx:=5
       Else
       if Sametext(PartCMD,'PSECT') then
          opidx:=6
       Else
       if Sametext(PartCMD,'GLOBAL') then
          opidx:=7
       Else
       if Sametext(PartCMD,'EJECT') then
          opidx:=8
       Else
       if Sametext(PartCMD,'NAME') then
          opidx:=9
       Else
       if Sametext(PartCMD,'TITLE') then
          opidx:=10
       Else
       if Sametext(PartCMD,'INCLUDE') then
          opidx:=11;
    End;

    Procedure ADDBYTES;
    Var s,s1:String;
        k:Integer;
    Begin
     S:=PartArg1;
     if PartArg2<>'' then
       s:=s+','+PartArg2;
     Repeat
        If not GetFirstPart(s,s1,delims) then
        Begin
          s1:=s;
          s:='';
        End;
        if GetInteger(s1,k) then
          Addbyte(p,Byte(k),opidx)
        Else
        Begin
         //ADDError('Byte Convert Error');
         //Set Pass2
         //Always a new CMD
         EvaluateLater(p,1,s1,OpIdx);
        End;
     Until s='';
    End;

    Procedure ADDWords;
    Var s,s1:String;
        k:Integer;
        BLO,BHI:BYTE;
    Begin
     S:=PartArg1;
     if PartArg2<>'' then
       s:=s+','+PartArg2;
     Repeat
        If not GetFirstPart(s,s1,delims) then
        Begin
          s1:=s;
          s:='';
        End;
        if GetInteger(s1,k) then
        Begin
          Cnv2Bytes(WORD(K),BLO,BHI);
          Addbyte(p,BLO,opidx);
          Addbyte(p,BHI,opidx);
        End
        Else
        Begin
         //ADDError('Byte Convert Error');
         //Set Pass2
         //Always a new CMD
         EvaluateLater(p,2,s1,OpIdx);
        End;
     Until s='';
    End;

    Procedure ADDMessage;
    Var s,s1:String;
        B:BYTE;
        i:integer;
    Begin
     if not (InBetween(PartArg1,'""') or InBetween(PartArg1,'''''')) then
     Begin
       ADDError('Error DEFM Arg1 Not in ""');
       Exit;
     End;

     S:=RemoveBrackets(PartArg1,'""');
     S:=RemoveBrackets(s,'''''');

     if PartArg2<>'' then
     Begin
       if not (InBetween(PartArg2,'""') or InBetween(PartArg2,'''''')) then
       Begin
         ADDError('Error DEFM Arg2 Not in ""');
         Exit;
       End;
       S1:=RemoveBrackets(PartArg2,'""');
       S1:=RemoveBrackets(s1,'''''');

       s:=s+#15+s1;
     End;
     s1:='';
     Repeat
        If not GetFirstPart(s,s1,#15,false,true) then
        Begin
          s1:=s;
          s:='';
        End;
        for i := 1 to Length(s1) do
        Begin
         b:=Ord(s1[i]);
         AddByte(p,b,opidx);
        End;
     Until s='';
    End;

    Procedure CheckLabel;
    Begin
      if PartCMD=Parts[1] then
      Begin
        PartLBL:=PartArg1;
        PartArg1:=PartArg2;
        PartArg2:='';
      End;
     if PartLbl<>'' then
       AddLabel(PartLbl,Dollar);
    End;

    Procedure OnlyOneArg;
    Var s,s1,s2:String;
        p,lp:Integer;
    Begin
      s:= StringReplace(CurText,#9,'',[rfreplaceall]);
      //s:= StringReplace(s,'  ',' ',[rfreplaceall]);
      p:=pos(';',s);
      s2:='';
      if delimisbetween(s,p,'''"',lp ) then
      Begin
        s2:=copy(s,1,lp);
        s:=copy(s,lp+1,999);
      End;
      If  GetFirstPart(s,s1,';')  then
        s:=s1;
      s:=s2+s;
      If not GetFirstPart(s,s1,PartCmd,true) then
        s:=s1;
      PartArg1:=trim(s);
      PartArg2:='';
    End;

Var k,i:integer;
    ct:String;
Begin
   p:=nil;
   Result:=False;
   OpIdx:=-1;
   FindOp;
   if OpIdx<0 then
     Exit;

   ct:=#9+ CurText;

   if PartLbl<>'' then
     AddLabel(PartLbl,Dollar);
   case OpIdx of
      0: //DEFM
        Begin
           AddLog('Pseudo OPC [DEFM] '+ct);
           CheckLabel;
           OnlyOneArg;
           //todo:Add All Messages divided by comma 
           ADDMessage;
        end;
      1: //DB
        Begin
           AddLog('Pseudo OPC [DB]   '+ct);
           CheckLabel;
           OnlyOneArg;
           ADDBYTES;
        end;
      2: //DS
        Begin
          AddLog('Pseudo OPC [DS]    '+ct);
          CheckLabel;
          if GetInteger(PartArg1,k) then
          Begin
            for i := 1 to k do
             AddByte(p,0);
          end
          Else
           AddError('AddStorage Value Error');
        end;
      3: //DW
        Begin
          AddLog('Pseudo OPC [DW]    '+ct);
          CheckLabel;
          OnlyOneArg;
          ADDWords;
        end;
      4: //EQU
        Begin
          AddLog('Pseudo OPC [EQU]  '+ct);
          If GetInteger(PartArg2,k) then
           AddLabel(PartArg1,k)
          Else
          Begin
           EvaluateLater(p,2,PartArg2,Opidx);
           p.Label2Exp:=PartArg1;
          end;
        end;
      5: //ORG
        Begin
          AddLog('Pseudo OPC [ORG]   '+ct);
          CheckLabel;
          If GetInteger(PartArg1,k) then
           DOLLAR:=k
          Else
           AddError('ORG Value Error');
        end;
      6: //PSECT
        Begin
          AddLog('Pseudo OPC [PSECT] '+ct);
          if sametext(Partarg1,'abs') then
          Begin
            IsRelative:=false;
            FDollar:=-2; //we need an org
          end;
        end;
      7: //GLOBAL
        Begin
          AddLog('Pseudo OPC [GLOBAL]'+ct);
          if not Globallabels.LabelExists(PartArg1) then
          Begin
            k:=asmLabels.GetLabel(PartArg1);
            GlobalLabels.AddLabel(PartArg1,k);
          end;
        end;
      8: //EJECT
        Begin
          AddLog('Pseudo OPC [EJECT] '+ct);
        end;
      9: //NAME
        Begin
          AddLog('Pseudo OPC [NAME]  '+ct);
        end;
      10://TITLE
        Begin
          AddLog('Pseudo OPC [TITLE]  '+ct);
        end;
      11://Include
        Begin
          AddLog('Pseudo OPC [INCLUDE]  '+ct);
          IncludeFile(PartArg1);
        end;

   end;

   Result:=True;
end;

procedure TCompiledList.splitZ80Command(s: string);
Begin
   zPartCmd:='';zPartArg1:='';zPartArg2:='';
   s:=StringReplace(s,'  ',' ',[rfReplaceAll]);
   s:=StringReplace(s,'  ',' ',[rfReplaceAll]);
   If getFirstPart(S,zPartCMD,delims) then
   Begin
     If getFirstPart(S,zPartArg1,delims) then
      zPartArg2:=s
     Else
      zPartArg1:=s;
   end
   Else
     zPartCmd:=s;
end;

Function TCompiledList.InBetween(s:String;chs:String='()'):Boolean;
Begin
  Result:=False;
  s:=Trim(s);
  if Length(s)<2 then
   Exit;
  Result:= (s[1]=chs[1]) and (s[Length(s)]=chs[2]) ;
end;

Function TCompiledList.InBrackets(s:String):Boolean;
Begin
  Result:= InBetween(s) ;
end;

Function TCompiledList.zHasANumber(s:String):Boolean;
Begin
  Result:=Pos('##',s)>0;
  if Not Result then //Check commands like BIT 0,A SET RES
  Begin

  end;
end;

Function TCompiledList.RemoveBrackets(Const Arg:string;Brc:String='()'):String;
Begin
  if InBetween(Arg,brc) then
  Begin
    Result:=Copy(arg,2,Length(arg)-2);
  end
  Else
   Result:=Arg;
End;

Function TCompiledList.IsRegister(Arg:String):Boolean;
Var  i:Integer;
Begin
  Arg:=RemoveBrackets(Arg);
  Result:=False;
  for i := 1 to MaxReg do
  Begin
    Result:=Result Or SameText(Arg,Registers[i]);
    if result then break;
  end;
end;

Function TCompiledList.SplitArg(Const Arg:String;Var P1,P2:String):Boolean;
Var  i:Integer;
     s:String;
Begin
  s:=RemoveBrackets(Arg);
  Result:=False;
  if s='' then
     Exit;

  p2:='';
  If not GetFirstPart(s,p1,'+') then //IX+####
   p1:=s
  Else
   p2:=s;
  Result:=True;
end;

Function TCompiledList.ContainsIXIY(Arg:String;Var p1,p2:String):Boolean;
Var s:String;
Begin
  s:=RemoveBrackets(Arg);
  Result:=False;
  if s='' then
     Exit;

  if SplitArg(s,p1,p2) then
     Result:= SameText(p1,'IX') or SameText(p1,'IY') ;
end;

Function TCompiledList.ContainsIX(Arg:String;Var p1,p2:String):Boolean;
Var s:String;

Begin
  s:=RemoveBrackets(Arg);
  Result:=False;
  if s='' then
     Exit;

  if SplitArg(s,p1,p2) then
     Result:= SameText(p1,'IX') or SameText(p1,'IY') ;
end;

Function TCompiledList.ContainsIY(Arg:String;Var p1,p2:String):Boolean;
Var s:String;
Begin
  s:=RemoveBrackets(Arg);
  Result:=False;
  if s='' then
     Exit;

  if SplitArg(s,p1,p2) then
     Result:= SameText(p1,'IX') or SameText(p1,'IY') ;
end;


constructor TCompiledList.Create;
begin
  IsProject:=false;
  FDollar:=-1;
  IsRelative:=true;
  LastDollar:=-1;
end;

Function TCompiledList.CheckCommand:Boolean;
Var i:Integer;
    Arg1HasParam:Boolean;
    Arg2HasParam:Boolean;

    Function ArgIsParam(Arg:String):Boolean;
    Var Inv:Boolean;
    Begin
       Arg:=RemoveBrackets(Arg);
       Inv:={IsKeyword(Arg) or} IsRegister(Arg);//5-8-08
       Result:=not inv;
    End;

    Function IsArgumentValid(Arg,zArg:String;Var ArgHasParam:Boolean):Boolean;
    Var zArgHasParam:Boolean;
        p1,p2:String;
        zp1,zp2:String;
    Begin
         Result:=SameText(Arg,zArg);
         if Not Result then
         Begin  //Could be a param
           zArgHasParam:=zHasANumber(zArg);
           if zArgHasParam and ArgIsParam(Arg) then
           Begin

             //Check Brackets
             Result:=(InBrackets(Arg) and InBrackets(zArg)) or
                     (Not InBrackets(Arg) and Not InBrackets(zArg));
             //Check IX+##
             if Result and ContainsIXIY(Arg,p1,p2) then
             Begin
               SplitArg(zArg,zp1,zp2);
               Result:= SameText(p1,zp1);
             End;

             if result  then
              ArgHasParam:=zArgHasParam;
           End;// if end
         End; //End Arg Check
    End;

    Function ArgsAreEqual:Boolean;
    Var ar,zar:Integer;
    Begin
       ar:=0;zar:=0;
       if PartArg1<>''  then
        Inc(ar);
       if PartArg2<>''  then
        Inc(ar);
       if zPartArg1<>''  then
        Inc(zar);
       if zPartArg2<>''  then
        Inc(zar);

       Result:= ar=zar;
    End;

    Function IsTheCommand:Boolean;
    Var t:Boolean;
        k,zk:Integer;

    Begin

       Arg1HasParam:=False;
       Arg2HasParam:=False;
       Result:= SameText(PartCMD,zPartCMD);
       Result:= Result and ArgsAreEqual;
       if Result and (zPartarg1<>'') then
       Begin //Check Arguments
         //Check Arg1
         if SameText(PARTCMD,'RST')  then  //check if arg is decimal
           if not IsValidHex(PartArg1) then
           Begin
              if IsValidInt(PartArg1) then
              Begin
                 k:=strtoint(PartArg1);
                 PartArg1:=inttohex(k,2)+'H';
              End
              else
              if LabelExists(PartArg1) then
              Begin
                 k:=GetLabel(PartArg1);
                 PartArg1:=inttohex(k,2)+'H';
              End;
           End;

         Result:=IsArgumentValid(PartArg1,zPartArg1,Arg1HasParam);

         if Result and (zPartArg2<>'') then //So Far so Good
         Begin
          //Check Arg1
          Result:=IsArgumentValid(PartArg2,zPartArg2,Arg2HasParam);
         End;

         //Check BIT BIT0,A
         if not Result  then
         Begin
          t:=Sametext(PARTCMD,'BIT') or Sametext(PARTCMD,'RES') or Sametext(PARTCMD,'SET');
          //Check Param2
          Result:=t and IsArgumentValid(PartArg2,zPartArg2,Arg2HasParam)
                    and ArgIsParam(PartArg1);
          if Result then //Could be it but we need arg1 to know
          Begin                           //Set lbl1 (IX+Lbl2)

           //  k:=GetLabel(PartArg1);
//             if LabelExists(PartArg1) then
             if getinteger(PartArg1,k) then
             Begin
              Try
               zk:=Strtoint(zPartArg1);
              Except
                zk:=-1; //should not come here ever
              End;
              Result:=k=zk;
             End
             Else
               CheckAtPass2:=true;
          End;//If Result

         End; //End Check Args
       End;//End cmd


    End;


Var tt:String;
    tx:String;
Begin
   CMDIDX:=-1;
   CheckAtPass2:=False;
   for i := 1 to MAX_Z80_INSTR do
   Begin
     SplitZ80Command(aZ80Instr[i].cinstr);
     if IsTheCommand then
     Begin
       CMDIDX:=i;
       tt:=#9;
       if Length(aZ80Instr[i].cinstr)<7 then
          tt:=tt+#9;
        tx:=Format('[%s] %s=%s',[aZ80Instr[i].cinstr,tt,#9+Trim(curText)]);
       if CheckAtPass2 then
        tx:=tx+' [**PASS2**]';
       ADDLog(tx);
       Break;
     end;
   end;
   Result:=CMDIDX>0;
   if not Result then
     ADDError('Command Not Found --> '+curText);
end;

Function TCompiledList.GetValidLabel(p: PCmpInst;Var Lbl:String):Boolean;
Var p1,p2:String;
    l1,l2:String;
Begin
      l1:=p.Label1Exp;
      l2:=p.Label2Exp;

      if ContainsIXIY(l1,p1,p2)  then
      Begin
        if p2<>'' then
          l1:=p2
        Else
          l1:=p1;
      End;
      if ContainsIXIY(l2,p1,p2) then
      Begin
        if p2<>'' then
          l2:=p2
        Else
          l2:=p1;
      End;
      Lbl:=l1;//Default;
      if IsRegister(l1) and Not IsRegister(l2) then
       Lbl:=l2;
      if IsRegister(l2) and Not IsRegister(l1) then
       Lbl:=l1;
        //LD (IY+##),## //TODO: LD (IY+##),##
      if SameText(p.instruct,'SET') or SameText(p.instruct,'BIT') or
            SameText(p.instruct,'RES') then
           lbl:=l2; //cause l1 is already used
      if InBrackets(Lbl) then
         Lbl:= RemoveBrackets(Lbl);

    Result:=Lbl<>'';
end;

procedure TCompiledList.Command2Bytes(p: PCmpInst);
Var AllOk:Boolean;
    k:Integer;
    BL,BH:Byte;
    VLBL:String;
Begin
    AllOk:=False;
    Case aZ80Instr[p.CMDIDX].nMask of
       $81: //No parameter
           Begin
             p.ByteCnt:=1;
             p.Bytes[1]:=aZ80Instr[p.CMDIDX].ainstr[0];
             AllOk:=True;
           end;
       $82://One Byte Param     ##
           Begin
             p.ByteCnt:=2;
             p.Bytes[1]:=aZ80Instr[p.CMDIDX].ainstr[0];
             GetValidLabel(p,VLBL);
             AllOk:= GetInteger(VLBL,k);
             if AllOk then
             Begin
                //Check FOR Relative Commands
                if not ISCmdRelative then
                  p.Bytes[2]:=Byte(k)
                Else
                Begin //JR ##, DJNZ ##
                   if IsValidInt(VLBL) or IsValidHex(VLBL) then
                    p.Bytes[2]:=Byte(k)-2 //DSP check???
                   Else //It was A Label
                   Begin
                   //  if pos('$',VLBL)=0 then
                       k:=k-Dollar-2;  //e-2
                   //  Else
                   //    k:=k;//or k-2
                     if (k>129) or (k<-126) then
                     begin
                       ADDLog('ERROR Relative Command Out Of Range [-126..129]');
                       p.Label1Exp:=VLBL;
                       p.Label2Exp:='';
                       AllOk:=False;
                     end
                     Else
                      p.Bytes[2]:=Byte(k);
                   end;
                end;//Else Cmd Is Relative
             end;//Allok
           end;
       $83://Two Bytes Param    ####
           Begin
             p.ByteCnt:=3;
             p.Bytes[1]:=aZ80Instr[p.CMDIDX].ainstr[0];
             GetValidLabel(p,VLBL);
             AllOk:= GetInteger(VLBL,k);
             if AllOk then
             Begin
                Cnv2Bytes(k,BL,BH);
                p.Bytes[2]:=BL;
                p.Bytes[3]:=BH;
             End;
           end;
       $C2://Two Bytes Command
           Begin
             p.ByteCnt:=2;
             p.Bytes[1]:=aZ80Instr[p.CMDIDX].ainstr[0];
             p.Bytes[2]:=aZ80Instr[p.CMDIDX].ainstr[1];
             AllOk:=True;
           end;
       $C3://Two Bytes Command and One Byte Param ##
           Begin
             p.ByteCnt:=3;
             p.Bytes[1]:=aZ80Instr[p.CMDIDX].ainstr[0];
             p.Bytes[2]:=aZ80Instr[p.CMDIDX].ainstr[1];
             GetValidLabel(p,VLBL);
             AllOk:= GetInteger(VLBL,k);
             if AllOk then
                p.Bytes[3]:=Byte(k);
           end;
       $C4://Two Bytes Command and Two Byte Param ####
           Begin                    //Special is LD (IY+##),##
             p.ByteCnt:=4;
             p.Bytes[1]:=aZ80Instr[p.CMDIDX].ainstr[0];
             p.Bytes[2]:=aZ80Instr[p.CMDIDX].ainstr[1];
             AllOk:= GetValidLabel(p,VLBL) and GetInteger(VLBL,k);
             if AllOk then
             Begin
                Cnv2Bytes(k,BL,BH);
                p.Bytes[3]:=BL;
                p.Bytes[4]:=BH;
                if (p.Bytes[1]=$FD) and (p.Bytes[2]=$36) then
                Begin //LD (IY+##),##
                  GetInteger(PARTARG2,k);
                  Cnv2Bytes(k,BL,BH);
                  p.Bytes[4]:=BL;
                end;
                if (p.Bytes[1]=$DD) and (p.Bytes[2]=$36) then
                Begin //LD (IX+##),##
                  GetInteger(PARTARG2,k);
                  Cnv2Bytes(k,BL,BH);
                  p.Bytes[4]:=BL;
                end;

             End;
           end;
       $D4://Three Bytes Command and One Byte Param ## in byte 3
           Begin
             p.ByteCnt:=4;
             p.Bytes[1]:=aZ80Instr[p.CMDIDX].ainstr[0];
             p.Bytes[2]:=aZ80Instr[p.CMDIDX].ainstr[1];
             p.Bytes[4]:=aZ80Instr[p.CMDIDX].ainstr[3];
             GetValidLabel(p,VLBL);
             AllOk:= GetInteger(VLBL,k);
             if AllOk then
                p.Bytes[3]:=Byte(k);
           end;
        Else
         Outputdebugstring(pchar('Unknown:'+inttostr(aZ80Instr[cmdidx].nMask)));
    end;//end case
    if AllOk then
      p.Status:=csCMDOK
    Else
      p.Status:=csCMDONLY;  
end;

Function TCompiledList.FindCommand(CMDName:String;var Startat:Integer):Boolean;
Var i:Integer;
Begin
   Result:=False;
   for i :=Startat  to MAX_Z80_INSTR do
   Begin
      splitZ80Command(aZ80Instr[i].cInstr);
      Result:=SameText(CMDName,zPartCmd);
      if result  then break;
   end;
   if result then
    cmdidx:=i
   else
    cmdidx:=-1; 
end;

procedure TCompiledList.DoPass2(IsLinking: Boolean = False);
Var i:integer;
    p:PCmpInst;
    BH,BL:Byte;
    k,t:Integer;
    lbl:String;

         Function EvaluateExpression:Boolean;
         Begin
            Result:=False;
            if GetValidLabel(p,lbl) then
            Begin
              Result:= GetInteger(LBL,k);
              Cnv2Bytes(k,BL,BH);
            End;
         End;


        Var fnd:Boolean;
        st:integer;
        p1,p2,zp1,zp2:string;

        Procedure Check(CMD:String);
        Begin
         fnd:=false;
                            if SameText(partcmd,CMD) then //same RES
                            Begin
                              if EvaluateExpression then
                              Begin
                                // k has the bit
                                PartArg1:=inttostr(k);
                                st:=1;
                                While FindCommand(CMD,st) do
                                Begin
                                   st:=st+1;
                                   //Partarg1 has the bit no
                                   //partarg2 has either a register r or ix+## or iy+##
                                   fnd:=Sametext(partarg1,zpartarg1);
                                   if not fnd then continue;

                                   fnd:= Sametext(partarg2,zpartarg2);
                                   if not fnd then
                                   Begin
                                      fnd:=containsixiy(partarg2,p1,p2) and containsixiy(zpartarg2,zp1,zp2)
                                       and sametext(p1,zp1);
                                   End;
                                   if fnd then break;

                                End;
                                if fnd then
                                Begin
                                  p.Bytes[1]:=aZ80Instr[cmdidx].aInstr[0];
                                  p.Bytes[2]:=aZ80Instr[cmdidx].aInstr[1];
                                  if containsixiy(partarg2,p1,p2) then
                                   if getinteger(p2,k) then
                                   Begin
                                     p.Bytes[3]:=Byte(k);
                                     p.Bytes[4]:=aZ80Instr[cmdidx].aInstr[3];
                                   End
                                   else
                                   begin
                                    adderror('Error : Cant evaluate :'+p.OrigCmd);
                                    fnd:=false;
                                   end;
                                End
                                Else
                                 AddError('Error: '+cmd+' CMD not found --> '+p.OrigCmd);

                              End; //end evaluate
                            End; //end sametext
           if fnd then
            p.status:=csCMDOK;
        End;

Var PassStr:String;
Begin
  if IsLinking then
   PassStr:='PASS 3 [LINKING]'
  Else
   PassStr:='PASS 2';

  ADDLOG('---------------------------------------------------------',False);
  ADDLOG('',False);
  ADDLOG('                 '+Passstr,False);
  ADDLOG('',False);
  ADDLOG('---------------------------------------------------------',False);
  ADDLOG('',False);


  for i := 0 to Count-1  do
  Begin
    p:=PCmpInst(Get(i));
    CurLine:=p.OrigLine;
    if p.Status=csCMDOk then Continue;

    PartCMD:=p.Instruct;
    PartArg1:=p.Label1Exp;
    PartArg2:=p.Label2Exp;
    Dollar:=p.Addr;


         case p.Status of
             csCMDONLY:Begin
                        ADDLog(PassStr+': Get Command Variable --> '+p.OrigCmd);
                        if EvaluateExpression then
                        Begin
                          case az80Instr[p.CMDIDX].nMask of
                          //on jr we should do the math
                          $82:begin
                              //Check FOR Relative Commands
                              if not ISCmdRelative then
                                 p.Bytes[2]:=BL     //b2
                              Else
                              Begin //JR ##, DJNZ ##
                                 if IsValidInt(LBL) or IsValidHex(LBL) then
                                    p.Bytes[2]:=BL-2 //DSP ??? to be checked
                                 Else //It was A Label
                                 Begin
                                   if pos('-$',lbl)=0 then //is The sub is already done
                                   Begin
                                     if k<=Dollar then //  NO
                                       t:=k-Dollar //Backwards
                                     Else
                                       t:=k-Dollar-2; //Forwards
                                   End
                                   Else
                                     t:=k-2; //YES
                                   if (t>129) or (t<-126) then
                                   begin
                                      ADDError('ERROR Relative Command Out Of Range [-126..129]');
                                      continue;
                                   end
                                   Else
                                      p.Bytes[2]:=Byte(t);
                                 end;
                               end;//Else Cmd Is Relative


                              End;
                          $83:Begin
                                p.Bytes[2]:=BL     ;//b2,b3
                                p.Bytes[3]:=BH;
                              End;
                          $C3:p.Bytes[3]:=BL     ;//b3
                          $C4:Begin    //could have two diferrent params
                                p.Bytes[3]:=BL     ;//b2,b3
                                p.Bytes[4]:=BH;
                              End;
                          $D4:p.Bytes[3]:=BL     ;//b3
                          end; //Case
                          p.Status:=csCMDOK;
                        End //If
                         Else  //if k=-99999 then PASS3
                         Begin
                            if isLinking then
                               AddError(PassStr+':Expression ['+lbl+'] not found!!!!')
                            Else
                            Begin
                              if IsProject then
                                 AddLog(PassStr+':Expression ['+lbl+'] not found. Check again in PASS 3???')
                              Else
                                AddError(PassStr+':Expression ['+lbl+'] not found!!!!')
                            end;
                         end;
                      End;
             csCMDPASS2:Begin
                           ADDLog(PassStr+': Replace Variable --> '+p.OrigCmd);


                          if IsPseudoOp(p.Instruct) then
                          Begin
                           if GetInteger(p.Label1Exp,k) then
                           Begin
                            Cnv2Bytes(WORD(K),BL,BH);
                            case p.CMDIDX of
                              1:// DEFB
                                Begin
                                // p.ByteCnt:=p.ByteCnt+1;
                                 p.Bytes[1]:=BL;
                                 p.Status:=csCMDOK;
                                End;
                              3://DEFW
                                Begin
                                // p.ByteCnt:=p.ByteCnt+1;
                                 p.Bytes[1]:=BL;
                                 p.Bytes[2]:=BH;
                                 p.Status:=csCMDOK;
                                End;
                              4://EQU
                                Begin
                                 AddLabel(p.Label2Exp,k);
                                 p.Status:=csCMDOK;
                                 p.ByteCnt:=0;
                                End;
                            end
                           End// End this time ok
                           Else  //if k=-99999 then PASS3
                            if k=ASMNOTFOUND then
                            Begin
                              if isLinking then
                               AddError(PassStr+':Expression ['+p.Label1Exp+'] not found!!!!.')
                              Else
                              Begin
                               if IsProject then
                                 AddLog(PassStr+':Expression ['+p.Label1Exp+'] not found. Check again in PASS 3 ???')
                               Else
                                 AddError(PassStr+':Expression ['+p.Label1Exp+'] not found!!!!.')
                              end;
                            end
                            else
                             AddError(PassStr+':Expression ['+p.Label1Exp+'] is invalid. OPIDX='+inttostr(p.CMDIDX));


                          End//End Pseudo op
                          else
                          if  iskeyword(p.instruct) then
                          Begin
                            Check('BIT');
                            if not fnd then
                              Check('RES');
                            if not fnd then
                              Check('SET');

                          End;//end is keyword

                        End;//End Pass2
         end;//Case

  End;// For

  GotoLastDollar;
End;//Do Pass2  and DoPass3


procedure TCompiledList.GotoLastDollar;
Var    p:PCmpInst;
Begin
  //gotolastDollar
  if count=0 then exit; //no Commands
  
  p:=PCmpInst(Get(Count-1)); //LastCommand
  Dollar:=p.addr+p.ByteCnt;
end;

procedure TCompiledList.Compile2(Txt: string);

     Procedure DoPass1;
     Var lns:String;
         p:PCmpInst;
         OldDollar:Integer;

         Procedure CheckLabel;
         Begin
          if PartLBL<>'' then
           if Not (IsValidInt(PartLBL) or IsValidHex(PartLBL)) then
            if OldDollar=-1 then
              AddLabel(PartLBL,Dollar)
            Else
              AddLabel(PartLBL,OldDollar)
          Else
           ADDError('Invalid Label or Syntax Error');
          PartLbl:='';
         End;

     Begin
       OldDollar:=fDollar;
       lns:=Trim(CurText);
       If SplitCommand(lns) then
       Begin
        if PartCMD<>'' then
        Begin
          If CheckPseudoOps then
          Begin

          end
          Else
          if CheckCommand then
          Begin
             CheckLabel;
             p:=NewCmd;
             p.OrigCmd:=CurText;
             p.OrigLine:=CurLine;
             p.CMDIDX:=CMDIDX;
             p.Instruct:=PartCMD;
             p.Addr:=DOLLAR;
             p.AddrHex:=InttoHEX(p.Addr,4);
             p.Label1Exp:=PartArg1;
             p.Label2Exp:=PartArg2;
             p.Comments:=PartCom;
             Command2Bytes(p);
           //  if p.Status<>csCMDOK then
              if CheckatPass2 then
               p.Status:=csCMDPASS2;

             //Inc Program Counter
             DOLLAR:=DOLLAR+p.ByteCnt;
          end;
        End;

         CheckLabel;
       end; //SplitCommand ok
     End;


Var sl:TStringList;
    i:Integer;
begin
 AsmLabels.Clear; //Clear the labels
 ADDLabel('DOLLAR',Dollar);//Init dollar label
 ErrorsFound:=False;
 FErrors:=0;

 Sourcelist:=TStringList.Create;
 Try
  Sourcelist.Text:=txt;
  ADDLOG('',False);
  ADDLOG('---------------------------------------------------------',False);
  ADDLOG('',False);
  ADDLOG('        NEWBRAIN INTERNAL ASSEMBLER / DISASSEMBLER',False);
  ADDLOG('',False);
  ADDLOG('        '+Datetostr(Now)+'  '+Timetostr(Now),False);
  ADDLOG('',False);
  ADDLOG('---------------------------------------------------------',False);
  ADDLOG('',False);
  ADDLOG('                 PASS 1',False);
  ADDLOG('',False);
  ADDLOG('---------------------------------------------------------',False);
  ADDLOG('',False);
  //1st Pass should Find all Labels and Assign Addresses to them
   i:=0;
   While I <= (Sourcelist.Count - 1) do //not for cause we may add text
   Begin
      Curline:=i+1;
      CurText:=Sourcelist[i];
     try
      DoPass1;
     except
       on e:exception do
        adderror('Exception -->'+e.message);
     end;
      DoOnCompileProgress(1,Curline,Sourcelist.Count);
      inc(i);
   end;

  if not IsRelative then
    DoPass2
  Else
    ADDLOG('****** File is Relative Skipp Pass 2 - Linker needed ******',False);

  ADDLOG('',False);
  ADDLOG('---------------------------------------------------------',False);
  if ErrorsFound then
   ADDLOG('                 COMPILING ENDED WITH '+inttostr(Errors) +' ERRORS',False)
  Else
   ADDLOG('                 COMPILING ENDED OK',False);
  ADDLOG('---------------------------------------------------------',False);

 finally
   Sourcelist.free;
   SourceList:=nil
 end;

 GotoLastDollar;

end;


function TCompiledList.NewCmd: PCmpInst;
Var i:Integer;
begin
 Result:= New(PCmpInst);
 Add(Result);
 for i := 1 to 4 do
   Result.Bytes[i]:=0;
 Result.OrigCmd:='';
 Result.OrigLine:=0;
 Result.Instruct:='';
 Result.Addr:=0;
 Result.AddrHex:='';
 Result.ByteCnt:=0;
 Result.HasLabel:=False;
 Result.Label1Exp:='';
 Result.Label2Exp:='';
 Result.CMDIDX:=-1;
 Result.Comments:='';
 Result.Status:=csNew;
end;

function TCompiledList.getcompilationastext:String;
Var i:Integer;
    p:PCmpInst;
    sl:TStringlist;

    function GetLine:String;
    var i:Integer;
    Begin
       Result:=Format('%3d)   %s ',[p.OrigLine,p.AddrHex]);
       if p.Bytecnt=0 then
          Result:=Result+#9;
       for i := 1 to p.ByteCnt do
         Result:=Result+inttohex(p.bytes[i],2)+' ';
       for I := p.bytecnt+1 to 4 do
         Result:=result+'   ';

       Result:=Result+#9#9+p.OrigCmd+#9';'+p.Comments;  
    End;

begin
  sl:=TStringlist.Create;
  Try

   for i := 0 to Count-1 do
   Begin
    p:=items[i];
    sl.Add(GetLine);
   end;

  finally
    Result:=sl.text;
    sl.free;
  end;
end;

procedure TCompiledList.ADDError(e:String);
Begin
   ErrorsFound:=True;
   fErrors:=fErrors+1;
   e:='('+Inttostr(fErrors)+') '+e+#9#9' at line:'+inttostr(CurLine);
 //  OutputDebugString(Pchar(e));
   IsError:=True;
   DoOnCompileMessage(e);
end;

procedure TCompiledList.ADDLog(e:String;Addline:boolean=True);
Begin
   if Addline then
     e:=#9#9#9+Format('%4d) %s',[CurLine,e])
   else
    e:=#9#9+e;
  // OutputDebugString(Pchar(e));
   IsError:=False;
   DoOnCompileMessage(e);
end;

function TCompiledList.Arg1IsString: Boolean;
begin
  Result := inBetween(PartArg1,'''''') or inBetween(PartArg1,'""') ;
end;

function TCompiledList.Arg2IsString: Boolean;
begin
  Result := inBetween(PartArg2,'''''') or inBetween(PartArg2,'""') ;
end;

procedure TCompiledList.DoOnCompileMessage(const MSG: string);
begin
  if Assigned(fOnCompileMessage) then
    fOnCompileMessage(Self,MSG);
end;

procedure TCompiledList.DoOnCompileProgress(const Pass, cPos, PosMax: Integer);
begin
  if Assigned(fOnCompileProgress) then
     fOnCompileProgress(Self,Pass,cPos,PosMax);
end;

function TCompiledList.GetDollar: Integer;
begin
  if FDollar=-1 then   //That means we compile a relative segment
  Begin
     IsRelative:=True;
     if LastDollar>-1 then //We now can be absolute
     Begin
       Dollar:=LastDollar;
       IsRelative:=False;
     end;
  end;

  if not IsProject then//Only for project files
   if FDollar<0 then
   Begin
     Dollar:=0;
     IsRelative:=false;
   end;
    

  Result := FDollar;
end;

Class Function TCompiledList.DelimIsBetween(s:String;p:Integer;Delims:String;var Lastp:Integer):Boolean;
Var k1,k2,t:Integer;
    st:string;
    i:Integer;
    delim:String;
Begin
  Result:=False;
  for i := 1 to Length(Delims) - 1 do
  Begin
    Delim:=Delims[i];

    //Check if ; is inbetween '' or " "
    k1:=Pos(Delim,s);
    t:=p;//;Pos(';',s);
    st:=copy(s,k1+1,999);
    k2:=Pos(delim,st);
    if (k1>0) and (k2>0) then
    Begin
      k2:=k1+k2;
      if (k1<t) and (t<k2) then
      Begin //is between '' or ""
        result:=true;
        Lastp:=k2+1;
      end;
    End;
  end;
end;

class function TCompiledList.GetFirstPart(var S, part1: String; Delimeters:
    string; const AsWord: Boolean = False;WasString:Boolean=False): Boolean;
Var delims:TStringlist;
    lastp,p,i:Integer;
Begin
   Result:=False;
   Part1:='';
   if not wasString then
     s:=trim(s);

   if Not AsWord then
   Begin
     lastp:=999;
     for i := 1 to Length(Delimeters) do
     Begin
       p:=Pos(Delimeters[i],s);
       if (p>0) and (p<lastp) then
          lastp:=p
     end;

     p:=lastp;
     //Check if delimeter is between '' or ""
     If DelimIsBetween(s,p,'''"',Lastp) Then
         p:=lastp;
   end
   Else
   Begin
     p:=Pos(Delimeters,s);
     if p>0 then
      lastp:=p;
   end;
     p:=lastp;
     if p=999 then Exit; //no delimeter found
     Part1:=Copy(s,1,p-1); //1st part
     if not AsWord then
       s:=Copy(s,p+1,maxint) //Rest of string
     Else
       s:=Copy(s,p+Length(Delimeters),maxint); //Rest of string
     Result:=True;
End;

function TCompiledList.ISCmdRelative: Boolean;
Var i:Integer;
begin
  Result:=False;
  for i := 1 to MaxRelCMDs do
   Result := Result Or SameTExt(RelativeCommands[i],PartCmd);
end;

function TCompiledList.IsPseudoOp(Cmd:String;Const OpToCheck:Integer=-1): Boolean;
Var i:Integer;
    Opidx:Integer;
Begin
     Result:=false;
     for i := 0 to MaxKW do     //pseudo ops
     if Sametext(cmd,PseudoKW[i]) then
     Begin
       OpIdx:=i;
       Result:=True;
       Exit;
     end;
    if OpToCheck>-1 then
     Result:=Result and (OpIdx=OpToCheck);
end;

function TCompiledList.ISKeyword(Cmd:String): Boolean;
Var i:integer;
    iPart1:String;
    s:String;
Begin
   Cmd:=trim(Uppercase(CMD));
   Result:=False;
   if cmd='' then exit;
   
   for i := 1 to MAX_Z80_INSTR do
   Begin
     s:=aZ80Instr[i].cInstr;
     If not GetFirstPart(s,iPart1,delims) then  //i.e. NOP
      iPart1:=s;

     if Sametext(cmd,ipart1) then
     Begin
       Result:=True;
       Exit;
     end;
   end;

   if Not Result then
      Result:=IsPseudoOp(cmd);
end;

function TCompiledList.IsSpecialKeyword(Cmd:String): Boolean;
Var i:Integer;
Begin
     Result:=false;
     for i := 0 to MaxSpecialKW do     //pseudo ops
     if Sametext(cmd,SpecialKW[i]) then
     Begin
       Result:=True;
       Exit;
     end;
end;

procedure TCompiledList.MakeAbsolute(NewDollar: Integer);
begin
//  if not isrelative then
//    Raise exception.Create('Not a Relative Segment!!!!');
//  IsRelative:=False;
  LastDollar:=NewDollar;
//  ClearItems;
end;

procedure TCompiledList.SetDollar(const Value: Integer);
begin
  FDollar := Value;
  AddLabel('DOLLAR',FDollar);
end;

function TCompiledList.SplitCommand(const Txt: string): Boolean;
Var i,J:integer;
    s,s1,s2:String;
    p1,p2:Boolean;
    cmdtype:byte;
    k1,k2,t:integer;
    st:String;
begin
  for i := 0 to 4 do
    Parts[i]:='';

  PartLBL:='';
  PartCMD:='';
  PartArg1:='';
  PartArg2:='';
  PartCom:='';
  Result := False;
  s1:='';
  s2:='';

  s:=txt;

  if (s<>'') and (s[1]='*') then //Comments
  Begin
   PartCom:=s;
   Exit;
  end;

  if GetFirstPart(s,s1,';') then //Comments exist
  Begin
    //Check if ; is inbetween '' or " "
    k1:=Pos('''',txt);
    if k1=0 then
      k1:=Pos('"',txt);
    t:=Pos(';',txt);
    st:=copy(txt,k1+1,999);
    k2:=Pos('''',st);
    if k2=0 then
      k2:=Pos('"',st);
    if (k1>0) and (k2>0) then
    Begin
      k2:=k1+k2;
      if (k1<t) and (t<k2) then
      Begin //is between '' or ""
        s1:=txt;
        s:='';

      end;
    End;

    PartCOM:=s;
    s:=s1;
  end;

  s:=trim(s);
  s:=StringReplace(s,#9,' ',[rfReplaceAll]);
//  s:=StringReplace(s,': ',' ',[rfReplaceAll]);
  s:=StringReplace(s,'  ',' ',[rfReplaceAll]);
  s:=StringReplace(s,'  ',' ',[rfReplaceAll]);
  s:=StringReplace(s,'  ',' ',[rfReplaceAll]);
  s:=StringReplace(s,'  ',' ',[rfReplaceAll]);

  s1:=s;
  GetFirstPart(s,s2,':');
  s:=s1;
  for i := 0 to 4 do
    If not GetFirstPart(s,Parts[i],delims) then break;

  PartCnt:=i;
  if partcnt>4 then
  partcnt:=4;
  Parts[PartCnt]:=Parts[PartCnt]+s;
  if (Parts[2]='''') and (Parts[3]='''') then
   Begin
     Parts[2]:='32';//' ';
     Parts[3]:='';
   end;

   if (s2=parts[0]) AND NOT IsPseudoOp(Parts[1]) then //we have a label
   Begin
     partlbl:=parts[0];
     for J := 0 to 3 do       //shift down
       Parts[J]:=Parts[J+1];
       dec(i);
   end;


  if (i=4) and (s<>'') then //too many parts
  Begin
    if not (IsPseudoOp(Parts[0]) or IsPseudoOp(Parts[1]) ) then
     ADDError('Syntax Error. TOO MANY Parts --> '+curText);
//    Parts[4]:=s;
  end;

  if (i=0) and (partlbl<>'') and (Parts[0]='') then    //cdsp
  Begin
    CMDType:=3;
    Parts[0]:=PartLBL;
  end
  else
  if IsKeyword(Parts[0]) and IsPseudoOp(Parts[1]) then
     CMDType:=1
  else
  if IsPseudoOp(Parts[0]) then
     CMDType:=0
  else
  if iskeyword(Parts[0]) and not IsKeyWord(Parts[1]) then //ld hl,5
     CMDType:=0
  else
  if iskeyword(Parts[0]) and IsKeyWord(Parts[1]) and IsSpecialKeyword(Parts[0]) then
     CMDType:=0
  else
  if IsKeyWord(Parts[1]) then    //LBL INC B    //cc EQU dd
     CMDType:=1
  else
  if IsKeyWord(Parts[2]) then     //LBL cc [EQU] $dd
     CMDType:=2
  else
  if Parts[1]='' then             //LBL
     CMDType:=3
  else
   CMDType:=4;//error


   case CMDType of

  0:
    Begin
      PartCMD:=Parts[0];
      PartArg1:=Parts[1];
      PartArg2:=Parts[2];
    end;
                                 //LBL INC B  , LBL RRCA
  1:                              //LBL DB $34
    Begin
      if not IsPseudoOp(Parts[1],opEQU) then //cc EQU dd
      Begin
       PartLBL:=Parts[0];
                                 //CMD is in Brackets
       PartCMD:=Parts[1];        //LBL [LD] A,B
       PartArg1:=Parts[2];
       PartArg2:=Parts[3];
      end
      Else
      Begin //Pseudo Op EQU
       PartCMD:=Parts[1];        //cc EQU $dd
       PartArg1:=Parts[0];
       PartArg2:=Parts[2];
      end;
    end;
  2:
                            //LBL cc [EQU] $dd
    Begin
       PartLBL:=Parts[0];
       PartCMD:=Parts[2];
       PartArg1:=Parts[1];
       PartArg2:=Parts[3];
    end;
  3:
    Begin
     PartCmd:='';
     PartLBL:=Parts[0];//Should Check Validity
     Result:=True;
     Exit;
    end;
  4:
    AddError('SYNTAX ERROR. No Keyword Found. --> '+curText);
   end;//end case

   if not Arg1IsString  then
     p1:= (Pos('''',PartArg1)>0) or (Pos('"',PartArg1)>0);
   if not Arg2IsString  then
     p2:= (Pos('''',PartArg2)>0) or (Pos('"',PartArg2)>0);
   if p1 and p2 then
   Begin
     s:=txt;
     s1:=PartCMD;
     GetFirstPart(s,s1,delims);   //Check for ' ' or " "

     s:=Trim(s);
     if InBetween(s,'''''') or InBetween(s,'""') then
     Begin
       PartArg1:=s;
       PartArg2:='';
     end;
   end;
  Result:=IsKeyWord(PartCmd);
end;

{ TDSAsmLabels }

procedure TDSAsmLabels.AddLabel(Lbs: String; Value: Integer=ASMNOTFOUND);
begin
  Lbs:=StringReplace(Lbs,':','',[rfReplaceAll]);
  if UseSixLetter then
   Lbs:=FixLbs(Lbs);
  if pos('=',LBS)>0 then
  Begin
   OutputDebugString(Pchar(LBS+' : ERROR'));
   //Error;
  end
  Else
   Values[lbs]:=inttoStr(Value);
end;

constructor TDSAsmLabels.Create;
begin
  inherited;
end;

function TDSAsmLabels.GetLabel(LBS: String): Integer;
Begin
   if UseSixLetter then
    Lbs:=FixLbs(Lbs);

   if Values[lbs]='' then
    Result:=ASMNOTFOUND
   Else
    Result:=StrToInt(Values[lbs]);
end;

Function TDSAsmLabels.GetLabelStr(LBS:String):String;
Begin
  Result:=InttoHex(GetLabel(LBS),4);
  //ToHex(GetLabel(LBS),4);
end;

function TDSAsmLabels.LabelExists(Lbs: String): Boolean;
begin
  if UseSixLetter then
   Lbs:=FixLbs(Lbs);
  Result:=Values[lbs]<>'';
end;

function TDSAsmLabels.FixLbs(s:String):String;
var i:integer;
    optocheck:String;
    needsfixing:Boolean;
Begin
  Result:=s;
  if UseSixLetter then
  Begin
    needsfixing:=true;
    for i:=0 to MaxOps-1 do
    Begin
       optocheck:=Validops[i];
       needsfixing:= needsfixing and (pos(optocheck,s)=0);
    end;
    if needsfixing then
      Result:=copy(s,1,6);
  end;
end;

Initialization
  AsmLabels:=TDSAsmLabels.create;
  GlobalLabels:=TDSAsmLabels.create;
  ExternLabels:=TDSAsmLabels.create;

Finalization
 AsmLabels.Free;
 AsmLabels:=nil;
 GlobalLabels.Free;
 GlobalLabels:=nil;
 ExternLabels.Free;
 ExternLabels:=nil;
end.
