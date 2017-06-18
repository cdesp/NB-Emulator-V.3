
(* Misc collection of string routines from all over the place... *)

UNIT Strings;


INTERFACE

{$DEFINE DELPHI}

{$IFDEF DELPHI}
uses sysutils;
{$ENDIF}

TYPE
   TDir = (L,R);
   tCharSet = set of char;

FUNCTION  Str2Int(Str: String; (* Converts String to Integer *)
                  VAR Code: Integer): Integer;
FUNCTION  Int2Str(I: Integer): String; (* Converts Integer to String *)

FUNCTION  StripSlash(Str: String): String; (* Strip trailing '\' *)
FUNCTION  AddSlash(Str: String): String; (* Add trailing '\' *)
FUNCTION  PadStr(Str: String; (* Pad String with characters *)
                 Ch: Char; (* Character to pad with *)
                 Num: Byte; (* Number of places to pad to *)
                 Dir: TDir): String; (* Direction to pad in (L,R)*)
FUNCTION  UpCaseStr(Str: String): String; (* Convert string to uppercase *)
FUNCTION  LowCaseStr(Str: String): String; (* Convert string to lowercase *)
FUNCTION  NameForm(Str: String): String; (* Convert string to Name format *)
FUNCTION  StripExt(Str: String): String; (* Strip Extension from filename *)
FUNCTION  AddExt(Str,Ext: String): String; (* Add Extension to filename *)
function BackwardPos (const SubString, Data : string; (* Searches backward, returns position *)
                      StartPosition : byte) : byte;
function CountPos (var SubString, Data : string; (* Returns the position of a numbered substring*)
                   Count : byte) : byte;
function ForwardPos (var SubString, Data : string; (* Searches forward, returns position *)
                     StartPosition : byte) : byte;
function IsCharactersInString (Chars : tCharSet; Data : string) : boolean;
function IsInString (SubString : string; Data : string) : boolean;
function Occurrence (var SubString, Data : string) : byte;
function Replace (var Data, SubString1, SubString2 : string) : string;
function SearchPos (var SubString, Data : string; StartPosition : byte) : byte;
function StringBackwardPos (SubString, Data : string; StartPosition : byte) : byte;
function StringCentered (Data : string) : string;
function StringCountPos (SubString, Data : string; Count : byte) : byte;
function StringDoubled (Data : string) : string;
function StringFill (Count : byte; (* Returns string consisting of Count copies of substring *)
         SubString : string) : string;
function StringFixed (Data : string; FixedLength : byte) : string;
function StringFixedCentered (Data : string; FixedLength : byte) : string;
function StringFixedRight (Data : string; FixedLength : byte) : string;
function StringForwardPos (SubString, Data : string; StartPosition : byte) : byte;
function StringOccurrence (SubString, Data : string) : byte;
function StringReplace1 (Data, SubString1, SubString2 : string) : string;  (* Replaces all occurances of substring *)
function StringSearchPos (SubString, Data : string; StartPosition : byte) : byte;
function StringSpace (Count : byte) : string;
function StringStripped (Data : string) : string;
function StringZeroStripped (Data : string) : string;
procedure Fill (var Data : string; Count : byte; SubString : string);
procedure StringRemoveLead (var Data : string;  Character : char); (* Left Trim of specified Char *)
procedure StringRemoveTrail (var Data : string; Character : char); (* Right trim of specified char *)
function StripChar(var Data : string; (* Removes all instances of Char from string *)
         OneChar : Char) : string;
Function sLeft(cString : String; iChars : Integer) : string;
Function sRight(cString : String; iChars : Integer) : string;
FUNCTION ParseCount( cString: STRING; cChar: CHAR ): INTEGER;
FUNCTION Parse( cString: STRING; nIndex: INTEGER; cChar: CHAR ): STRING;
FUNCTION LastCharPos(tStr : string; tChar : char) : integer;
function Encrypt(const S: String; Key: Word): String;
function Decrypt(const S: String; Key: Word): String;
Function StrReverse(Const astr : string) : string;

IMPLEMENTATION


function Encrypt(const S: String; Key: Word): String;
var
  I: byte;
const
  C1 = 52845;
  C2 = 22719;
begin
  //Result[0] := S[0];
  setlength(result,length(s));
  for I := 1 to Length(S) do begin
    Result[I] := char(byte(S[I]) xor (Key shr 8));
    Key := (byte(result[I]) + Key) * C1 + C2;
  end;

end;

function Decrypt(const S: String; Key: Word): String;
var
  I: byte;
const
  C1 = 52845;
  C2 = 22719;
begin
  //Result[0] := S[0];
  setlength(result,length(s));
  for I := 1 to Length(S) do begin
    Result[I] := char(byte(S[I]) xor (Key shr 8));
    Key := (byte(S[I]) + Key) * C1 + C2;
  end;
  //setlength(result,length(s));
end;

FUNCTION  Str2Int(Str: String;
                  VAR Code: Integer): Integer;
VAR I: Integer;

BEGIN
   VAL(Str,I,Code);
   Str2Int := I;
END;


FUNCTION  Int2Str(I: Integer): String;
VAR S: String;

BEGIN
   STR(I,S);
   Int2Str := S;
END;


FUNCTION  StripSlash(Str: String): String;

BEGIN
   IF Str[Length(Str)] = '\' THEN
    StripSlash := COPY(Str,1,Length(Str)-1);
END;


FUNCTION  AddSlash(Str: String): String;

BEGIN
   IF Str[Length(Str)] <> '\' THEN
    AddSlash := Str + '\';
END;


FUNCTION  PadStr(Str: String;
                 Ch: Char;
                 Num: Byte;
                 Dir: TDir): String;
VAR
   TempStr: String;
   {$IFDEF DELPHI}
   B: Longint;
   {$ELSE}
   B:Byte;
   {$ENDIF}
BEGIN
   TempStr := '';
   IF Length(Str) < Num THEN
    BEGIN
       FOR B := Length(Str) TO Num DO TempStr := TempStr + Ch;
       CASE Dir OF
          L: PadStr := TempStr + Str;
          R: PadStr := Str + TempStr;
       END;
    END
   ELSE
    BEGIN
       FOR B := 1 TO Num DO TempStr := TempStr + Str[B];
       PadStr := TempStr;
    END;
END;


FUNCTION  UpCaseStr(Str: String): String;
VAR
   TempStr: String;
   {$IFDEF DELPHI}
   B: Longint;
   {$ELSE}
   B:Byte;
   {$ENDIF}

BEGIN
   TempStr := Str;
   FOR B := 1 TO Length(Str) DO TempStr[B] := UpCase(TempStr[B]);
   UpCaseStr := TempStr;
END;


FUNCTION  LowCaseStr(Str: String): String;
VAR
   TempStr: String;
   {$IFDEF DELPHI}
   B: Longint;
   {$ELSE}
   B:Byte;
   {$ENDIF}

BEGIN
   TempStr := Str;
   FOR B := 1 TO Length(Str) DO IF TempStr[B] IN ['A'..'Z'] THEN
    TempStr[B] := CHR(ORD(TempStr[B])+32);
   LowCaseStr := TempStr;
END;


FUNCTION  NameForm(Str: String): String;
VAR
   TempStr: String;
   {$IFDEF DELPHI}
   Pos: Longint;
   {$ELSE}
   Pos:Byte;
   {$ENDIF}
BEGIN
   TempStr := lowercase(Str); // lowercase the entire thing to begin
   TempStr[1] := UpCase(TempStr[1]); // Upper the first one
   FOR Pos := 2 TO Length(TempStr) DO
    IF TempStr[Pos] = ' ' THEN
      TempStr[Pos+1] := UpCase(TempStr[Pos+1]);
    {
    ELSE
     IF TempStr[Pos] IN ['A'..'Z'] THEN
      TempStr[Pos] := CHR(ORD(TempStr[Pos])+32);
    }
   NameForm := TempStr;
END;


FUNCTION  StripExt(Str: String): String;
VAR DotPos: Byte;

BEGIN
   DotPos := POS('.',Str);
   IF DotPos > 1 THEN StripExt := COPY(Str,1,DotPos-1)
   ELSE StripExt := Str;
END;


FUNCTION  AddExt(Str,Ext: String): String;
VAR DotPos: Byte;

BEGIN
   DotPos := POS('.',Str);
   IF (DotPos > 1) AND (DotPos < 10) THEN AddExt := COPY(Str,1,DotPos) + Ext
   ELSE IF DotPos = 0 THEN AddExt := Str + '.' + Ext;
END;

{ *****************************************
  *             Procedures                *
  ***************************************** }


{ Returns the position of a substring, beginning at specified position and
  searching forward }
function ForwardPos (var SubString, Data : string; StartPosition : byte) : byte;
var Position : integer;
begin
     if StartPosition < 1 then StartPosition := 1;
     Position := Pos (SubString, Copy (Data, StartPosition, Length(Data) - StartPosition + 1));
     if Position > 0 then ForwardPos := Pred(Position + StartPosition)
        else ForwardPos := 0; { Not found }
end;

{ Returns the position of a substring, beginning at specified position and
  searching forward }
function StringForwardPos (SubString, Data : string; StartPosition : byte) : byte;
begin
     StringForwardPos := ForwardPos (SubString, Data, StartPosition);
end;

{ Returns the position of a substring, beginning at specified position and
  searching backward }
function BackwardPos (const SubString, Data : string; StartPosition : byte) : byte;
begin
     if StartPosition > Length(Data) then StartPosition := Length(Data);
     BackwardPos := Pos (SubString, Copy (Data, 1, StartPosition));
end;

{ Returns the position of a substring, beginning at specified position and
  searching backward }
function StringBackwardPos (SubString, Data : string; StartPosition : byte) : byte;
begin
     StringBackwardPos := BackwardPos (SubString, Data, StartPosition);
end;

{ Returns the position of a character closests to a certain position }
function SearchPos (var SubString, Data : string; StartPosition : byte) : byte;
var ForwardIndex, BackwardIndex : byte;
begin
     ForwardIndex  := ForwardPos  (SubString, Data, StartPosition);
     BackwardIndex := BackwardPos (SubString, Data, StartPosition);
     { Return the position to the closest found substring }
     if StartPosition-ForwardIndex >= BackwardIndex-StartPosition then
        SearchPos := ForwardIndex else SearchPos := BackwardIndex;
end;

{ Returns the position of a character closest to a certain position }
function StringSearchPos (SubString, Data : string; StartPosition : byte) : byte;
begin
     StringSearchPos := SearchPos (SubString, Data, StartPosition);
end;

{ Returns the position of a numbered substring in a string (for example,
  if Count is set to two, the position of the second location of the substring
  is returned). }
function CountPos (var SubString, Data : string; Count : byte) : byte;
var Index : integer; Position : byte;
begin
     Position := 0; { Reset search position }
     for Index := 1 to Count do
         Position := ForwardPos (SubString, Data, Succ(Position));
     CountPos := Position; { Zero if not found }
end;

{ Returns the position of a numbered substring in a string (for example,
  if Count is set to two, the position of the second location of the substring
  is returned). }
function StringCountPos (SubString, Data : string; Count : byte) : byte;
begin
     StringCountPos := CountPos (SubString, Data, Count);
end;

{ Returns the number of occurrences of a substring inside a string }
function Occurrence (var SubString, Data : string) : byte;
var Count, Position : integer;
begin
     { Reset position and counter }
     Position := 0; Count    := 0;
     { Search for substring and go forward if one is found }
     repeat
           Position := ForwardPos (SubString, Data, Succ(Position));
           if Position <> 0 then Inc (Count);
     until (Position = 0);
     Occurrence := Count; { Return number of occurrences }
end;

{ Returns the number of occurrences of a substring inside a string }
function StringOccurrence (SubString, Data : string) : byte;
begin
     StringOccurrence := Occurrence (SubString, Data);
end;

{ Returns TRUE if substring is found inside string }
function IsInString (SubString : string; Data : string) : boolean;
begin
     IsInString := (Pos (SubString, Data) <> 0);
end;

{ Returns TRUE if any character in specified set is found inside string }
function IsCharactersInString (Chars : tCharSet; Data : string) : boolean;
var Index : integer;
begin
     IsCharactersInString := FALSE; { Assume that no character is found }
     for Index := 1 to Length(Data) do
         if Data[Index] in Chars then begin
            { Character in set found - break }
            IsCharactersInString := TRUE;
            Exit;
         end;
end;

{ Replaces a sub-string in a string with another sub-string }
function Replace (var Data, SubString1, SubString2 : string) : string;
var Index, Position : integer; TempString : string;
begin
     { Reset index variable and clear temporary string }
     Index := 0; TempString := '';
     while Index < Length(Data) do begin
           Inc (Index); { Go forward one step }
           Position := ForwardPos (SubString1, Data, Index);
           { Copy data if not search string found }
           if Index <> Position then TempString := TempString + Data[Index]
              else begin
                   { Replace SubString1 with SubString2 }
                   TempString := TempString + SubString2;
                   Index := Position + Pred(Length (SubString1));
              end;
     end;

     Replace := TempString; { Return replaced string }
end;

{ Replaces a sub-string in a string with another sub-string }
function StringReplace1 (Data, SubString1, SubString2 : string) : string;
begin
     StringReplace1 := Replace (Data, SubString1, SubString2);
end;


{ Generates a string filled with specified number of copies of the
  specified substring. }
procedure Fill (var Data : string; Count : byte; SubString : string);
var Index : byte;
begin
     Data := ''; { Clear data string }
     if Length(SubString) = 1 then begin
        { Use memory filling if data is a character }
        if Count > 0 then FillChar (Data[1], Count, Ord(SubString[1]));
        {$IFDEF DELPHI}
        setlength(Data,Count); { Set string length }
        {$ELSE}
        data[0] := chr(count);
        {$ENDIF}
     end else for Index := 1 to Count do Data := Data + SubString;
end;

{ Generates a string filled with specified number of copies of the
  specified substring. }
function StringFill (Count : byte; SubString : string) : string;
var TempString : string;
begin
     { Avoid overlap of filling - use temporary string for filling }
     Fill (TempString, Count, SubString);
     StringFill := TempString;
end;

{ Generates a string containing specified number of blank spaces }
function StringSpace (Count : byte) : string;
begin
     StringSpace := StringFill (Count, #32);
end;

{ Removes all leading characters in string }
procedure StringRemoveLead (var Data : string; Character : char);
var Length : byte absolute Data;
begin
     { Delete all leading characters }
     while (Data[1] = Character) and (Length > 1) do Delete (Data, 1, 1);
end;

{ Removes all trailing characters in string }
procedure StringRemoveTrail (var Data : string; Character : char);
var Length : byte absolute Data;
begin
     { Delete all trailing characters }
     while (Data[Length] = Character) and (Length > 1) do Dec (Length);
end;

{ Removes blank spaces before and after text inside a string }
(*  NOTE:  USE TRIM! *)
function StringStripped (Data : string) : string;
begin
     { Delete all leading and trailing spaces }
     StringRemoveLead (Data, #32);
     StringRemoveTrail (Data, #32);
     { Return stripped string }
     StringStripped := Data;
end;


{ Removes leading and trailing zeroes from a text string }
function StringZeroStripped (Data : string) : string;
begin
     { Delete all leading and trailing zeroes }
     StringRemoveLead (Data, '0');
     StringRemoveTrail (Data, '0');
     { Remove comma signs or add one leading zero if comma first in string }
     if (Data[Length(Data)] = '.') then Delete (Data, Length(Data), 1); { Delete last character }
     if (Data[1] = '.') then Data := '0' + Data;
     StringZeroStripped := Data;
end;

{ Centers text inside a string }
function StringCentered (Data : string) : string;
var FixSpace, StrippedStr : string; StartLength : byte;
begin
     {$IFDEF DELPHI}
     StrippedStr := Trim(Data); { Removes leading and trailing spaces }
     {$ELSE}
     StrippedStr := stringstripped(Data);
     {$ENDIF}
     { Calculate number of spaces available for centering }
     FixSpace    := StringSpace((Length(Data) - Length(StrippedStr)) div 2);
     StartLength := Length(Data);
     Data        := FixSpace + StrippedStr + FixSpace;
     if Length(Data) <  StartLength then Data := Chr(32) + Data;
     StringCentered := Data;
end;

{ Fixes the length of a string by inserting spaces or removing characters }
function StringFixed (Data : string; FixedLength : byte) : string;
var Length : byte absolute Data;
begin
     if (Data <> '') then Data := Copy (Data, 1, FixedLength);
     while (Length < FixedLength) do Insert (#32, Data, Succ(Length));
     StringFixed := Data;
end;

{ Centers and fixes the length of a string }
function StringFixedCentered (Data : string; FixedLength : byte) : string;
begin
     StringFixedCentered := StringCentered(StringFixed(Data, FixedLength));
end;

{ Right justifies and fixes the length of a string }
function StringFixedRight (Data : string; FixedLength : byte) : string;
begin
     if FixedLength >= Length(Data) then
        StringFixedRight := StringSpace (FixedLength - Length(Data)) + Data
     else StringFixedRight := StringFixed (Data, FixedLength);
end;

{ Inserts one blank space between each character inside string }
function StringDoubled (Data : string) : string;
var Index : byte; TempString : string;
begin
     TempString := '';
     for Index := 1 to Length(Data) do TempString := TempString + Data[Index] + #32;
     StringDoubled := Copy (TempString, 1, Pred(Length(TempString)));
end;


function StripChar(var Data : string; OneChar : Char) : string;
begin
   repeat
     delete(data,pos(Onechar,data),1);
   until pos(Onechar,data) = 0;
   StripChar := Data;
end;

Function sLeft(cString : String; iChars : Integer) : string;
begin
     sLeft := copy(cString,1,iChars);
end;

Function sRight(cString : String; iChars : Integer) : string;
begin
     sright := copy(cString,Length(cString)-ichars+1,iChars);
end;

{*****************************************************************************
 * Function ...... ParseCount()
 * Purpose ....... To count the number of tokens in a string
 * Parameters .... cString      String to count tokens in
 *                 cChar        Token separator
 * Returns ....... Number of tokens in <cString>
 * Notes ......... Uses function StripChar
 *****************************************************************************}
FUNCTION ParseCount( cString: STRING; cChar: CHAR ): INTEGER;
var oldlen,newlen : integer;
BEGIN
     oldlen := length(cString);
     newlen := length(stripchar(cString,cChar));
     ParseCount := oldlen - newlen;
END;

{*****************************************************************************
 * Function ...... Parse()
 * Purpose ....... To parse out tokens from a string
 * Parameters .... cString      String to parse
 *                 nIndex       Token number to return
 *                 cChar        Token separator
 * Returns ....... Token <nIndex> extracted from <cString>
 * Notes ......... If <nIndex> is greater than the number of tokens in
 *                 <cString> then a null string is returned.
 *               . Uses function sLeft, sRight, and ParseCount
 * Author ........ Martin Richardson
 * Date .......... September 30, 1992
 *****************************************************************************}
FUNCTION Parse( cString: STRING; nIndex: INTEGER; cChar: CHAR ): STRING;
VAR
   i: INTEGER;
   cResult: STRING;
BEGIN
     cString := cString + cChar;
     IF nIndex > (ParseCount( cString, cChar )) THEN
        cResult := ''
     ELSE BEGIN
          FOR i := 1 TO nIndex DO BEGIN
              cResult := sLeft( cString, POS( cChar, cString ) - 1 );
              cString := sRight(cString, LENGTH(cString) - POS(cChar, cString));
          END { Next I };
     END { IF };
     Parse := cResult;
END;

{**************************************************************}
{* LastCharPos returns the last occurance of tChar in tStr    *}
{* 4/23/98 JDG                                                *}
{**************************************************************}
FUNCTION LastCharPos(tStr : string;
                     tChar : char) : integer;
var count :integer;
begin
     // Author's note: would be more efficient to start at the end of the string
     // and work your way to the beginning, stopping after you find the first
     // occurance of tChar, which would be the last occurance in the string.

     count := length(tstr)+1;
     repeat
      dec(count)
     until (tStr[count] = tChar) or (count =1);
     if tchar = tstr[count] then LastCharPos := count
     else count := 0;  // return 0 if not found
END; {LastCharPos}

{**************************************************************}
{* StrReverse returns the reverse of a string                 *}
{* 9/06/98 DG                                                *}
{**************************************************************}
Function StrReverse(Const astr : string) : string;
// Reverses a string
var x,y : integer;
begin
    y := length(astr);
    setlength(result,y);
    for x := 1 to y do
     begin
       result[y-(x-1)] := astr[x];
     end;
end;

BEGIN
END.
