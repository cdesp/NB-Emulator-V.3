{
 *********************************************************************
 *    Unidade Strings                                                *
 *    ---------------                                                *
 *                                                                   *
 *    Autor : Paulo Sergio Cardoso                                   *
 *    Data  : 03-11-1991                                             *
 *                                                                   *
 *    Contem rotinas gerais de transformacao de numeros reias em     *
 * cadeias string, alem de rotinas gerais de manipulacao de strings. *
 *                                                                   *
 *    Alteracoes                                                     *
 *    ------------------------------------------                     *
 *    Alteracao                                                      *
 *    Autor                                                          *
 *    Data                                                           *
 *    ------------------------------------------                     *
 *                                                                   *
 *********************************************************************



}
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

Unit
  UStrings;

Interface


Function NumToStr (X:Real;N:Byte):String;
Function Replicate (C:Char;N:Byte):String;
Function Space (N:Byte):String;
Function RealToStr   (X:Real;N:Byte;M:Byte):String;
Function ScientToStr (X:Real;N:Byte):String;
Function sStr   (X:LongInt; N:Byte):String;
Function sStrZero  (X:LongInt; N:Byte):String;
Function AllTrim (S:String):String;
Function Fixa (Frase:String;Qtd:Byte):String;
Function Upper (S:String):String;
Function XorText (Frase:String; XorByte:Byte):String;
Function XorNumeroSerie (Frase:String):String;
function ValNum (cStr:String; var nError: Integer):LongInt;
Function ValReal (cStr:String):Real;
Function TodaysDate:String;
Function TodaysDateTime:String;
Function FormatDate (S:String):String;
Function UnFormatDate (S:String):String;
Function FormatTime (S:String):String;
Procedure CalculaDiaSemana (nDia,nMes,nAno:Integer; Var nDiaS,nTotDias:Integer);
Function CompDateTime (S1,S2:String):Integer;
Function ExtractDate (S:String):String;
Function ExtractTime (S:String):String;
Function ComputeDTime (Date,Time:String):String;
function HexToInt(S: String): LongInt;
function ToHex(nNumber, nSize: LongInt): String;

function IsValidHex(Var s:String): Boolean;

function InBetween(s:String;chs:String='()'): Boolean;

function IsValidBin(Var s:String): Boolean;

function IsValidOkt(Var s:String): Boolean;

function BinToInt(s:String): Longint;

function OktToInt(s:String): Longint;

function IsValidInt(var s: String): Boolean;

function GetValidInteger(S:String;Var res:Integer): Boolean;

function GetFirstPart(var S, part1: String; Delimeters: string; const AsWord:
    Boolean = False): Boolean;

Implementation
uses sysutils,classes;
{
 ***************************************************************************
 *          Funcao NumToStr                                                *
 *          ---------------                                                *
 *          Entradas : X - Numero Real                                     *
 *                     N - Tamanho da String de Saida                      *
 *          A funcao devolve uma string contendo o numero X convertido.    *
 *          Se for um numero inteiro, devolve a string sem valores apos    *
 *          a virgula. Se for menor que 1e-5 devolve em notacao cientifica.*
 ***************************************************************************
}
Function NumToStr (X:Real;N:Byte):String;
Var
  S:String;
Begin

If X=0 then Begin
            Str (0:N,S);
            NumToStr := S
            End;

If (Frac(X)<1e-6) and (Int(X)<>0)
   then Begin
        Str (X:N:0,S);
        NumToStr := S;
        Exit;
        End;
If (Abs(X)>1e-3) and (Abs(X)<1e+3)
   then Begin
        Str (X:N:5,S);
        NumToStr := S;
        Exit
        End;

Str (X:N,S);
NumToStr := S
End;


{
 ********************************************************************
 * Funcao Replicate                                                 *
 * ----------------                                                 *
 * Entradas : C - Caractere                                         *
 *            N - Byte                                              *
 * Devolve um string contendo N caracteres, todos eles iguais a C.  *
 ********************************************************************
}
Function Replicate;
Var
  S : String;
  I : Byte;
Begin
S := '';
For I := 1 to N do
    S := S + C;
Replicate := S
End;

Function Space(N:Byte):String;
Begin
Space := Replicate (' ',N);
End;


{
 *********************************************************************
 * Funcao Fixa                                                       *
 * -----------                                                       *
 * Entradas : Frase - String                                         *
 *            Qtd   - Byte                                           *
 * Devolve uma string que contem a Frase truncada em Qtd caracteres. *
 *********************************************************************
}
Function Fixa (Frase:String;Qtd:Byte):String;
Var
  Aux : String;
Begin
Aux := Frase;
While Length(Aux)<Qtd do
      Aux := #32+Aux;
Fixa := Aux
End;


{
 **************************************************************************
 * Funcao RealToStr                                                       *
 * ----------------                                                       *
 * Entradas : X   - Real                                                  *
 *            N,M - Byte                                                  *
 * Devolve uma string contendo a transformacao do numero X em um string.  *
 * A string contera o numero com N caracteres, com M bytes decimais (con- *
 * tando o ponto flutuante).                                              *
 **************************************************************************
}
Function RealToStr (X:Real;N:Byte;M:Byte):String;
Var
  Aux : String;
Begin
Str (X:N:M,Aux);
RealToStr := Aux
End;


{
 **********************************************************************
 *  Funcao ScientToStr                                                *
 *  ------------------                                                *
 *  Entradas : X - Numero Real                                        *
 *             N - Byte                                               *
 *  Devolve uma string de N caracteres contendo o numero X em notacao *
 *  cientifica (9.999E-99).                                           *
 **********************************************************************
}
Function ScientToStr (X:Real;N:Byte):String;
Var
  Aux : String;
Begin
Str (X:N,Aux);
ScientToStr := Aux
End;


{
  *************************************************************
  *  Funcao sStr                                         *
  *  ----------------                                         *
  *  Entradas : X - Inteiro Longo (32 bits)                   *
  *             N - Byte                                      *
  *  Devolve uma string de N bytes contendo o numero X        *
  *************************************************************
}
Function sStr (X:LongInt;N:Byte):String;
Var
  Aux : String;
Begin
Str (X:N,Aux);
sStr := Aux
End;


{
  *************************************************************
  *  Funcao sStrZero                                        *
  *  -----------------                                        *
  *  Entradas : X - Inteiro Longo (32 bits)                   *
  *             N - Byte                                      *
  *  Devolve uma string de N bytes contendo o numero X, colo- *
  *  cando zeros a esquerda se n for maior que o numero de    *
  *  digitos do numero inteiro X                              *
  *************************************************************
}
Function sStrZero (X:LongInt;N:Byte):String;
Var
  Aux : String;
  I   : Byte;
Begin
Str (X:N,Aux);
For i := 1 to Length(Aux) do
    If Aux[i]=' ' then Aux[i] := '0';
sStrZero := Aux
End;

{
 *****************************************************************
 * Funcao AllTrim                                                *
 * --------------                                                *
 * Entradas : S - String                                         *
 * Devolve a String S, retirando todos os espacos a esquerda e a *
 * direita.                                                      *
 *****************************************************************
}
Function AllTrim (S:String):String;
Var
  I : Byte;
Begin
While (Length(S)>0) and (S[1]=#32) do
      Delete (S,1,1);
While (Length(S)>0) and (S[Length(S)]=#32) do
      Delete (S,Length(S),1);
AllTrim := S
End;

////
Function Upper (S:String):String;
Var
  X : String;
  I : Byte;
Begin
X := S;
For i := 1 to Length(S) do
    X[i] := UpCase(S[i]);
Upper := X
End;


Function XorText (Frase:String; XorByte:Byte):String;
Var
  I : Byte;
Begin
For i := 1 to Length(Frase) do
  if (i mod 2)=0 then
    Frase[i] := Char(Byte(Frase[i]) xor XorByte)
  else
    Frase[i] := Char(Byte(Frase[i]) xor (XorByte+1));
XorText := Frase
End;


Function XorNumeroSerie (Frase:String):String;
Var
  I : Byte;
Begin
For i := 1 to Length(Frase) do
    Frase[i] := Char(Byte(Frase[i]) xor ($70+i));
XorNumeroSerie := Frase
End;

Function ValNum (cStr:String; var nError: Integer):LongInt;
Var
  nAux : LongInt;
Begin
Val (AllTrim(cStr),nAux,nError);
ValNum := nAux
End;

Function ValReal (cStr:String):Real;
Var
  nError : Integer;
  nAux : Real;
Begin
Val (AllTrim(cStr),nAux,nError);
ValReal := nAux
End;

Function FormatDate (S:String):String;
Begin
FormatDate := Copy(S,7,2)+'/'+Copy(S,5,2)+'/'+Copy(S,1,4);
End;

Function TodaysDate:String;
Var
  nDia,nMes,nAno,nDiaS : Word;
Begin
{GetDate (nAno,nMes,nDia,nDiaS);}
TodaysDate := sStrZero(nDia,2)+'/'+sStrZero(nMes,2)+'/'+sStrZero(nAno,4)
End;

Function TodaysDateTime:String;
Var
  nDia,nMes,nAno,nDiaS    : Word;
  nHora,nMin,nSeg,nSeg100 : Word;
Begin
{
GetDate (nAno,nMes,nDia,nDiaS);
GetTime (nHora,nMin,nSeg,nSeg100);
}
TodaysDateTime := sStrZero(nAno,4)+sStrZero(nMes,2)+sStrZero(nDia,2)+
                  sStrZero(nHora,2)+sStrZero(nMin,2)+sStrZero(nSeg,2);
End;

Function CompDateTime (S1,S2:String):Integer;
Begin
If S1>S2 then CompDateTime := 1
         else If S1<S2 then CompDateTime := -1
                       else CompDateTime := 0;
End;

Function UnFormatDate (S:String):String;
Begin
UnFormatDate := Copy(S,7,4)+Copy(S,4,2)+Copy(S,1,2);
End;

Function FormatTime (S:String):String;
Begin
FormatTime := Copy(S,1,2)+'h'+Copy(S,3,2)+'min'
End;

Procedure CalculaDiaSemana (nDia,nMes,nAno:Integer; Var nDiaS,nTotDias:Integer);
Const
   ZELLER_OFFSET  = -1;
   aMeses : Array [1..12] Of Byte = (31,28,31,30,31,30,31,31,30,31,30,31);
Var
   Yr,Mn,n1,n2 : Integer;
   aMes:Array [1..12] Of Byte;
   i:integer;
Begin
 for i:= 1 to 12 do
   aMes[i]:=Ameses[i];
yr := nAno;
mn := nMes;

If (mn<3) then
   Begin
   Inc (mn,12);
   Dec (yr)
   End;

n1 := (26*(mn + 1)) div 10 ;
n2 := ((125*LongInt(yr)) div 100) ;

nDiaS := ((nDia + n1 + n2 - (yr div 100) + (yr div 400) + ZELLER_OFFSET) mod 7) ;

If ((nAno mod 4)=0) and ((nAno mod 40)<>0) then aMes[2] := 29
                                           else aMes[2] := 28;
nTotDias := aMes[nMes]
End;

Function ExtractDate (S:String):String;
Begin
ExtractDate := Copy(S,7,2)+'/'+Copy(S,5,2)+'/'+Copy(S,1,4);
End;

Function ExtractTime (S:String):String;
Begin
ExtractTime := Copy(S,9,2)+'h'+Copy(S,11,2)+'min'+Copy(S,13,2)+'s';
End;

Function ComputeDTime (Date,Time:String):String;
Begin
ComputeDTime := Copy(Date,7,4)+Copy(Date,4,2)+Copy(Date,1,2)+Copy(Time,1,2)+Copy(Time,4,2)+Copy(Time,9,2);
End;

//// Various functions
function IsValidHex(Var s:String): Boolean;
Const ValidHex=['0'..'9','A'..'F'];
      STR_OPERATION= '+-*/^!@#$<>%&*\|?{}';
Var l,i:Integer;
    r:boolean;
Begin
   s:=Uppercase(s);
   Result:=False;
   r:=false;
   for i := 1 to Length(STR_OPERATION) do
     r:=r or (pos(STR_OPERATION[i],s)>1);//operator not at start i.e. +2000
   if r then exit;


   l:=Length(s);
   if (l>1)  then
   Begin
     if s[1]='$' then
      s:=Copy(s,2,maxint)+'h';

     if  (s[l]='h') or (s[l]='H') then
     Begin
       Result:=True;
       for i := 1 to l-1 do
        Result:=Result and (s[i] in ValidHex) ;

     end;
   end;
end;

function IsValidBin(Var s:String): Boolean;
Const ValidBin=['0','1'];
Var l,i:Integer;
Begin
   s:=Uppercase(s);
   Result:=False;

   l:=Length(s);
   if (l>1)  then
   Begin
     if  (s[l]='b') or (s[l]='B') then
     Begin
       Result:=True;
       for i := 1 to l-1 do
        Result:=Result and (s[i] in ValidBin) ;

     end;
   end;
end;

function IsValidOkt(Var s:String): Boolean;
Const ValidOkt=['0','1','2','3','4','5','6','7'];
Var l,i:Integer;
Begin
   s:=Uppercase(s);
   Result:=False;

   l:=Length(s);
   if (l>1)  then
   Begin
     if  (s[l]='q') or (s[l]='Q') then
     Begin
       Result:=True;
       for i := 1 to l-1 do
        Result:=Result and (s[i] in ValidOkt) ;

     end;
   end;
end;

function HexToInt(S: String): LongInt;
const
   cHexDig: String[16] = '0123456789ABCDEF';
var
   nMult,
   nAux: LongInt;
   I, nPos: Integer;
begin
   S := AllTrim(UPPERCASE(S));
   nAux := 0;
   nMult := 1;
   for i := Length(S) downto 1 do begin
     nPos := Pos(S[i], cHexDig);
     if nPos<>0 then
     begin
       nAux := nAux+(nPos-1)*nMult;
       nMult := nMult*16;
     end;
   end;
   HexToInt := nAux;
end;

Function BinToInt(s:String): Longint;
Const ValidBin=['0','1'];
Var j,pow:Integer;
Begin
    Result:=0;
    pow:=1;
    for j := Length(s) downto 1 do
    Begin
      if S[j] in ValidBin then
      Begin
       if s[j]='1' then
        Result:=Result+Pow;
       Pow:=Pow*2;
      end;
    End;

end;

Function OktToInt(s:String): Longint;
Const ValidOkt=['0','1','2','3','4','5','6','7'];
Var j,pow:Integer;
Begin
    Result:=0;
    pow:=1;
    for j := Length(s) downto 1 do
    Begin
      if S[j] in ValidOkt then
      Begin
        Result:=Result+Pow*strtoint(s[j]);
       Pow:=Pow*8;
      end;
    End;
end;


function ToHex(nNumber, nSize: LongInt): String;
const
   cCharHex: String[16] = '0123456789ABCDEF';
var
   cAux: String;
   I: Integer;
begin
   cAux := '';
   for i := 1 to nSize do begin
     cAux := cCharHex[nNumber mod 16+1]+cAux;
     nNumber := nNumber div 16;
   end;
   ToHex := cAux;
end;

function InBetween(s:String;chs:String='()'): Boolean;
Begin
  Result:=False;
  s:=Trim(s);
  if Length(s)<2 then
   Exit;
  Result:= (s[1]=chs[1]) and (s[Length(s)]=chs[2]) ;
end;

Function GetValidInteger(S:String;Var res:Integer):Boolean;
Begin
  Result:=False;
  if InBetween(s,'''''') or InBetween(s,'''''') then
  Begin
     s:=StringReplace(s,'''','',[rfReplaceAll]);
     s:=StringReplace(s,'"','',[rfReplaceAll]);
     if Length(s)=1 then //just a char
     Begin
        Res:=Ord(s[1]);
        Result:=True;
     end
     Else ;//A string
  end
  Else
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
  Else
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
  end;
end;

function IsValidInt(Var s:String): Boolean;
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

function GetFirstPart(var S, part1: String; Delimeters: string; const AsWord:
    Boolean = False): Boolean;
Var delims:TStringlist;
    lastp,p,i:Integer;
Begin
   Result:=False;
   Part1:='';

   if Not AsWord then
   Begin
     lastp:=999;
     for i := 1 to Length(Delimeters) do
     Begin
       p:=Pos(Delimeters[i],s);
       if (p>0) and (p<lastp) then
          lastp:=p
     end;
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

End.