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
unit uNBParser;

interface
uses classes,FatExpression;


Type


 TNBParser = class(TFatExpression)
  private
    function CharBetweenDelims(CharPos: Integer; s, Delims: String;Var DelimEnd:Integer): Boolean;
    procedure FindOktValues(var expr: string);
    procedure FindBinValues(var expr: string);
    procedure FindHexValues(var expr: string);
    Procedure DoOnGetFunction(Sender: TObject; Eval: string; Args: array of Double;
      ArgCount: Integer; var Value: Double; var Done: Boolean);
    Procedure DoOnGetVar(Sender: TObject; Variable: string; var Value: Double; var Done: Boolean);
    procedure FindCharValues(var expr: string);
  protected
   constructor Create(AOwner: TComponent); override;
  public
    function Evaluate(Expr: String; var Value: Integer): Boolean;
  end;


Var NBPars:TNBParser;

implementation
uses sysutils,uasm,ustrings;



constructor TNBParser.Create(AOwner: TComponent);
begin
  inherited;
  OnVariable:=DoOnGetVar;
  OnEvaluate:= DoOnGetFunction;
end;

procedure TNBParser.DoOnGetFunction(Sender: TObject; Eval: string; Args: array of Double;
    ArgCount: Integer; var Value: Double; var Done: Boolean);
Var func:String;
    arg1,arg2:extended;

begin
    func:=Eval;
    if argCount>0 then
     arg1:=args[0];
{    if SameText(Eval,'.MOD.') then
     if argCount=2 then
     begin
      Value:= args[0] / args[1];
      Done:=true;
     end;}

  if not done then //check for labels
  Begin
    done:= AsmLabels.LabelExists(eval) ;
    if Done then
        Value:= AsmLabels.GetLabel(Eval);
  end;

  Evaluated:=Evaluated and done;
end;

procedure TNBParser.DoOnGetVar(Sender: TObject; Variable: string;
  var Value: Double; var Done: Boolean);
begin
  done:= AsmLabels.LabelExists(Variable) ;
  if done then 
   Value:= AsmLabels.GetLabel(Variable);
end;

procedure TNBParser.FindHexValues(var expr:string);
Var s,s1,st:String;
    i,p:Integer;
    hasop:boolean;
    res:string;

    Function Hexit(hx:string):string;
    Var l:Integer;
        s2:String;
    Begin
      Result:=hx;
      l:=Length(hx);
      if l<=2 then exit; //AT LEAST TWO NUMS 0FH NOT FH

      if (hx[l]='h') or (hx[l]='H') then
      Begin

        if isvalidhex(hx) then
        begin
         s2:=copy(hx,1,Length(hx)-1);
         Result:=inttostr(hextoint(s2));
        end;
      End;
    End;

Begin
  hasop:=false;
  s:='';

  for i := 1 to Length(expr) do
  Begin
    p:=pos(expr[i],STR_OPERATION);
    hasop:=hasop or (p>0);
    if p>0 then
       s:=s+STR_OPERATION[p];
  end;


  if not hasop  then exit;

  st:=expr;
  res:='';
  for i := 1 to Length(s) do
  Begin
    p:=pos(s[i],st);
    s1:=copy(st,1,p-1);
    s1:=Hexit(s1); //convert if it is hex
    res:=res+s1+s[i];
    st:=copy(st,p+1,maxint);
  end;
  if st<>'' then
  Begin
    s1:=hexit(st);
    res:=res+s1
  end;
  expr:=res;
end;

procedure TNBParser.FindBinValues(var expr:string);
Var s,s1,st:String;
    i,p:Integer;
    hasop:boolean;
    res:string;

    Function Binit(bn:string):string;
    Var l:Integer;
        s2:String;
    Begin
      Result:=bn;
      l:=Length(bn);
      if l<=1 then exit;

      if (bn[l]='b') or (bn[l]='B') then
      Begin

        if isvalidBin(bn) then
        begin
         s2:=copy(bn,1,l-1);
         Result:=inttostr(Bintoint(s2));
        end;
      End;
    End;

Begin
  hasop:=false;
  s:='';

  for i := 1 to Length(expr) do
  Begin
    p:=pos(expr[i],STR_OPERATION);
    hasop:=hasop or (p>0);
    if p>0 then
       s:=s+STR_OPERATION[p];
  end;


  if not hasop  then exit;

  st:=expr;
  res:='';
  for i := 1 to Length(s) do
  Begin
    p:=pos(s[i],st);
    s1:=copy(st,1,p-1);
    s1:=Binit(s1); //convert if it is bin
    res:=res+s1+s[i];
    st:=copy(st,p+1,maxint);
  end;
  if st<>'' then
  Begin
    s1:=Binit(st);
    res:=res+s1
  end;
  expr:=res;
end;

procedure TNBParser.FindOktValues(var expr:string);
Var s,s1,st:String;
    i,p:Integer;
    hasop:boolean;
    res:string;

    Function Oktit(bn:string):string;
    Var l:Integer;
        s2:String;
    Begin
      Result:=bn;
      l:=Length(bn);
      if l<=1 then exit;

      if (bn[l]='q') or (bn[l]='Q') then
      Begin

        if isvalidOkt(bn) then
        begin
         s2:=copy(bn,1,l-1);
         Result:=inttostr(Okttoint(s2));
        end;
      End;
    End;

Begin
  hasop:=false;
  s:='';

  for i := 1 to Length(expr) do
  Begin
    p:=pos(expr[i],STR_OPERATION);
    hasop:=hasop or (p>0);
    if p>0 then
       s:=s+STR_OPERATION[p];
  end;
  if not hasop  then exit;
  st:=expr;
  res:='';
  for i := 1 to Length(s) do
  Begin
    p:=pos(s[i],st);
    s1:=copy(st,1,p-1);
    s1:=Oktit(s1); //convert if it is Okt
    res:=res+s1+s[i];
    st:=copy(st,p+1,maxint);
  end;
  if st<>'' then
  Begin
    s1:=Oktit(st);
    res:=res+s1
  end;
  expr:=res;
end;

function TNBParser.Evaluate(Expr: String; var Value: integer): Boolean;
begin
  Result:=False;
//±=SHL
//£=SHR
//¥=MOD
//<=.LT.
//>=.GT.
//«=.GE.
//¬=.LE.
//¦=.NOT.
//\=.AND.
//|=.OR.
//§=.XOR.
//{=.LOW.
//}=.HIGH.
//~=


  Expr:=Stringreplace(Expr,'.SHL.' ,'±',[rfreplaceall]);
  Expr:=Stringreplace(Expr,'.SHR.' ,'£',[rfreplaceall]);
  Expr:=Stringreplace(Expr,'.MOD.' ,'¥',[rfreplaceall]);
  Expr:=Stringreplace(Expr,'.LT.'  ,'<',[rfreplaceall]);
  Expr:=Stringreplace(Expr,'.GT.'  ,'>',[rfreplaceall]);
  Expr:=Stringreplace(Expr,'.GE.'  ,'«',[rfreplaceall]);
  Expr:=Stringreplace(Expr,'.LE.'  ,'¬',[rfreplaceall]);
  Expr:=Stringreplace(Expr,'.NOT.' ,'¦',[rfreplaceall]);
  Expr:=Stringreplace(Expr,'.AND.' ,'\',[rfreplaceall]);
  Expr:=Stringreplace(Expr,'.OR.'  ,'|',[rfreplaceall]);
  Expr:=Stringreplace(Expr,'.XOR.' ,'§',[rfreplaceall]);
  Expr:=Stringreplace(Expr,'.LOW.' ,'{',[rfreplaceall]);
  Expr:=Stringreplace(Expr,'.HIGH.','}',[rfreplaceall]);
  Expr:=Stringreplace(Expr,'.RES.','~',[rfreplaceall]); //NEW 6/6/2016

  FindHexValues(expr);
  FindBinValues(expr);
  FindOktValues(expr);
  FindCharValues(expr);
  //FIND CHARS I.E. ')' AND REPLACE WITH THE ORDINAL
  nbPars.Text:=expr;
  try
   Value:=Trunc(nbpars.value);
   Result:=Found;
  Except
     result:=false;
  end;
end;

Function TNBParser.CharBetweenDelims(CharPos:Integer;s,Delims:String;Var DelimEnd:Integer):Boolean;
Var k1,k2,t:Integer;
    st:string;
    i:Integer;
    delim:String;
Begin
  Result:=False;DelimEnd:=0;
  for i := 1 to Length(Delims) - 1 do
  Begin
    Delim:=Delims[i];

    //Check if ; is inbetween '' or " "
    k1:=Pos(Delim,s);
    t:=CharPos;//;Pos(';',s);
    st:=copy(s,k1+1,999);
    k2:=Pos(delim,st);
    if (k1>0) and (k2>0) then
    Begin
      k2:=k1+k2;
      if (k1<t) and (t<k2) then
      Begin //is between '' or ""
        result:=true;
        DelimEnd:=k2+1;
      end;
    End;
  end;
End;

procedure TNBParser.FindCharValues(var expr:string);
Var s,s1,st,s2:String;
    i,p:Integer;
    hasop:boolean;
    res:string;

    Function Charit(hx:string):string;
    Var l:Integer;
        s2:String;
    Begin
      Result:=hx;
      l:=Length(hx);
      if l<=1 then exit;

      if InBetween(hx,'''''') then
      Begin
        hx:=copy(hx,2,l-2);
        if Length(hx)=1 then
         Result:=inttostr(Ord(hx[1]));
        if Length(hx)=2 then
         Result:=inttostr(Ord(hx[1])+Ord(hx[2])*256) ;

      End;
    End;
Var t:Integer;

Begin
  hasop:=false;
  s:='';
  for i := 1 to Length(expr) do
  Begin
    p:=pos(expr[i],STR_OPERATION);
    hasop:=hasop or (p>0);
    if (p>0) and Not CharBetweenDelims(i,expr,'''"',t) then
       s:=s+STR_OPERATION[p];
  end;
  if not hasop  then exit;
  st:=expr;
  res:='';
  for i := 1 to Length(s) do
  Begin
    p:=pos(s[i],st);
    if CharBetweenDelims(p,st,'''"',t) then
    Begin
      s1:=copy(st,1,t-1);
      s2:=copy(st,t,999);
      p:=pos(s[i],s2);
      if p=0 then
        continue;
      p:=t-1+p;
    end;
    s1:=copy(st,1,p-1);
    s1:=Charit(s1); //convert if it is hex
    res:=res+s1+s[i];
    st:=copy(st,p+1,maxint);
  end;
  if st<>'' then
  Begin
    s1:=Charit(st);
    res:=res+s1
  end;
  expr:=res;
end;

initialization
 NBPars:=TNBParser.create(nil);

Finalization
 NBPars.free;

end.
