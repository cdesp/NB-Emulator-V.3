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

unit uNBKeyboard2;

interface
uses classes;

Type
     TNbKeyBoard=Class
     private
       FNBSHIFTED: Boolean;
       procedure Init;
       procedure FillNBkeys;
     Protected
       AKey: string;
       AShift: TShiftState;
       AKeyInt: Word;
       keymap:Array[0..1] of TStringlist;
       NBKeys:Array[0..70] of Integer;
       Pressed:Array[0..5] of smallint;
       NBkeyList:TStringlist;
     public
       function TranslateChar(c:Char): Boolean;
       procedure PCKeyDown(var Key: Word; Shift: TShiftState);
       procedure PCKeyUp(var Key: Word; Shift: TShiftState);
       procedure NBAddKey;
       function NBGetKey: Byte;
       constructor Create; virtual;
       destructor Destroy; override;
       procedure Import(s:String);
       function GetPCKeyID: String;
       property NBSHIFTED: Boolean read FNBSHIFTED write FNBSHIFTED;
     End;


procedure CheckKeyBoard;

procedure FillCharArray;

const
  NB_1 = 9;
  NB_2 = 8;
  NB_3 = 7;
  NB_4 = 6;
  NB_5 = 5;
  NB_6 = 4;
  NB_7 = 3;
  NB_8 = 19;
  NB_9 = 20;
  NB_0 = 21;
  NB_A = 46;
  NB_B = 56;
  NB_C = 58;
  NB_D = 44;
  NB_E = 12;
  NB_F = 43;
  NB_G = 42;
  NB_H = 41;
  NB_I = 36;
  NB_J = 51;
  NB_K = 62;
  NB_L = 39;
  NB_M = 53;
  NB_N = 52;
  NB_O = 38;
  NB_P = 26;
  NB_Q = 14;
  NB_R = 11;
  NB_S = 45;
  NB_T = 10;
  NB_U = 35;
  NB_V = 57;
  NB_W = 13;
  NB_X = 59;
  NB_Y = 37;
  NB_Z = 60;

  NB_DOT = 55; // '.'
  NB_EQU = 27; // '='
  NB_NLN = 30; // <New Line>
  NB_SPC = 15; // <Space>
  NB_PLS = 29; // '+'
  NB_LPR = 22; // '('
  NB_RPR = 23; // ')'
  NB_COM = 40; // ';'
  NB_SLS = 47; // '/'
  NB_HOM = 63; // or 50 <Home> cursor at 0,0
  NB_BSP = 64; // or 65 <BackSpace>
  NB_BSL = 92; // backslash
  NB_GCM = 54; // ','
  NB_MIN = 28; // '-'
  NB_AFT =NB_2 or $40; // '"'
  NB_INS = 61;
  NB_ESC = 31;
  NB_VID = 0; // VIDEO TEXT ???

  NB_SHFT=-1;
  NB_CTRL=-2;
  NB_GRPH=-3;
  NB_STOP=-4;
  NB_REPT=-5;

Const NON=0;
      SHF=1;
      GRF=2;
      CTR=4;

Var
  A:Array[0..1,1..255] of byte;//keyb mapping
  b:Array[0..20] of byte; //buffer
  kcnt:Integer=0;
  AkeyList:TStringlist;
  AKey,prevkey: Word;
  NBkey:Byte;
  AShift: TShiftState;
  doclear:boolean=false;
  t22:integer=1;
  rm:Integer=642;
  cmd:Boolean=false;
  Kbuf:String;
  kbufc:Integer;
  RShift: Boolean;
  NBKeyBoard:TNbKeyBoard;



implementation
uses windows,sysutils,
     New,uNbscreen,uNbMemory,uNBCop,forms,
     uNBIO,frmOptions;

Var Kmap:TKeyBoardState;

//Delay milliseconds
Procedure Delay(n:Cardinal);
Var lst:Cardinal;
Begin
   lst:=Gettickcount;
   While Gettickcount-lst<n do
    Application.processmessages;
End;

Procedure FillCharArray;
Var
    i,j:Integer;
Begin
 for j:=0 to 1 do
  For i:=1 to 255 do
   A[j,i]:=0;

  A[0,8]:=NB_BSP;
  A[0,13]:=NB_NLN;
  A[0,27]:=nb_ESC;
  A[0,32]:=nb_SPC;
  A[0,33]:=0;//!
  A[0,34]:=NB_AFT;
  A[0,35]:=NB_3 or $40;
  A[0,36]:=NB_HOM;
  A[0,37]:=2;
  A[0,38]:=50;
  A[0,39]:=18;
  A[0,40]:=34;
  A[0,41]:=NB_RPR;
  A[0,42]:=0;//'*'
  A[0,43]:=NB_PLS;
  A[0,44]:=NB_GCM;
  A[0,45]:=NB_INS;//'-'
  A[0,46]:=18 or $40; //del --> shift + r cursor
  A[0,47]:=NB_SLS;
  A[0,48]:=NB_0;
  A[0,49]:=NB_1;
  A[0,50]:=NB_2;
  A[0,51]:=NB_3;
  A[0,52]:=NB_4;
  A[0,53]:=NB_5;
  A[0,54]:=NB_6;
  A[0,55]:=NB_7;
  A[0,56]:=NB_8;
  A[0,57]:=NB_9;
  A[0,58]:=NB_COM or $40;//':'
  A[0,59]:=NB_COM;
  A[0,60]:=0;//<
  A[0,61]:=NB_EQU;
  A[0,62]:=0;//>
  A[0,63]:=0;//?
  A[0,64]:=0;//@
  A[0,65]:=NB_A;
  A[0,66]:=NB_B;
  A[0,67]:=NB_C ;
  A[0,68]:=NB_D ;
  A[0,69]:=NB_E ;
  A[0,70]:=NB_F ;
  A[0,71]:=NB_G ;
  A[0,72]:=NB_H ;
  A[0,73]:=NB_I ;
  A[0,74]:=NB_J ;
  A[0,75]:=NB_K ;
  A[0,76]:=NB_L ;
  A[0,77]:=NB_M ;
  A[0,78]:=NB_N ;
  A[0,79]:=NB_O ;
  A[0,80]:=NB_P ;
  A[0,81]:=NB_Q ;
  A[0,82]:=NB_R ;
  A[0,83]:=NB_S ;
  A[0,84]:=NB_T ;
  A[0,85]:=NB_U ;
  A[0,86]:=NB_V ;
  A[0,87]:=NB_W ;
  A[0,88]:=NB_X ;
  A[0,89]:=NB_Y ;
  A[0,90]:=NB_Z ;

  A[0,96]:=NB_0 ;
  A[0,97]:=NB_1 ;
  A[0,98]:=NB_2 ;
  A[0,99]:=NB_3 ;
  A[0,100]:=NB_4 ;
  A[0,101]:=NB_5 ;
  A[0,102]:=NB_6 ;
  A[0,103]:=NB_7 ;
  A[0,104]:=NB_8 ;
  A[0,105]:=NB_9 ;
  A[0,106]:=NB_EQU-3 ; //*
  A[0,107]:=NB_EQU+2 ; //-
  A[0,109]:= NB_MIN;//+
  A[0,110]:= NB_DOT;// .
  A[0,111]:= NB_SLS;// /
  A[0,191]:= NB_SLS;// /

  A[0,186]:=NB_COM ; //;
  A[0,187]:=NB_EQU ; //=
  A[0,188]:=54 ; //,
  A[0,189]:=NB_EQU+1 ;//-
  A[0,190]:=55 ;//.
  A[0,219]:=22 or $40 ;//[
  A[0,220]:=NB_BSL ;//\
  A[0,221]:=23 or $40 ;//]
  A[0,222]:=NB_EQU+2 ;//+

  //for right shift we change the mappings
  //mainly for use of the PC buttons instead of
  //newbrain i.e. R-Shft-9 gives '(' instead of ')'
  For i:=1 to 255 do
   A[1,i]:=a[0,i] or $40;

  A[1,37]:=2 or $40;
  A[1,38]:=50 or $40;
  A[1,39]:=18 or $40;
  A[1,40]:=34 or $40;
  A[1,48]:=NB_9 or $40; // )
  A[1,49]:=NB_1 or $40;
  A[1,50]:=NB_EQU or $40;
  A[1,51]:=NB_3 or $40;
  A[1,52]:=NB_4 or $40;
  A[1,53]:=NB_5 or $40;
  A[1,54]:=0;   //^
  A[1,55]:=NB_6 or $40;  // &
  A[1,56]:=NB_EQU-3 ; //*
  A[1,57]:=NB_8 or $40;   //(

  A[1,65]:=NB_A or $40;
  A[1,66]:=NB_B or $40;
  A[1,67]:=NB_C or $40;
  A[1,68]:=NB_D or $40;
  A[1,69]:=NB_E or $40;
  A[1,70]:=NB_F or $40;
  A[1,71]:=NB_G or $40;
  A[1,72]:=NB_H or $40;
  A[1,73]:=NB_I or $40;
  A[1,74]:=NB_J or $40;
  A[1,75]:=NB_K or $40;
  A[1,76]:=NB_L or $40;
  A[1,77]:=NB_M or $40;
  A[1,78]:=NB_N or $40;
  A[1,79]:=NB_O or $40;
  A[1,80]:=NB_P or $40;
  A[1,81]:=NB_Q or $40;
  A[1,82]:=NB_R or $40;
  A[1,83]:=NB_S or $40;
  A[1,84]:=NB_T or $40;
  A[1,85]:=NB_U or $40;
  A[1,86]:=NB_V or $40;
  A[1,87]:=NB_W or $40;
  A[1,88]:=NB_X or $40;
  A[1,89]:=NB_Y or $40;
  A[1,90]:=NB_Z or $40;
End;

Procedure CheckKeyBoard;
var
  t,tt:byte;
begin
  if nbio.KeyPressed<>$80 then
   exit;

  //New routine

  nbKey:=nbKeyboard.NBGetKey;
  if nbKey<>$80 then
  Begin
    NBIO.CopInt:=true;
    //caps lock
    tt:= GetKeyState( VK_CAPITAL ) and $1; //1 capson 0 capsoff
    t:=nbmem.rom[$2b];
    if t<>tt then
    Begin //set bit 0 of $2b to tt
      t:=t and $fe;
      t:=t OR tt;
     nbmem.rom[$2b]:=t
    End;
    if nbkey=252 then //Break Key Pressed
    Begin
     nbio.brkpressed:=true;
     NBKey:=25;//VD
    End;
    nbio.KeyPressed:=NbKey;
    nbio.kbint:=true;

  End;
  nbKey:=0;
end;

function TNbKeyBoard.TranslateChar(c:Char): Boolean;
Var w:Word;
    h,l:Byte;
begin
  result:=false;
  if c=#10 then exit;
  
  w:=VKKeyScan(c);
  h:=HiByte(w);
  l:=LoByte(w);
  if (h=-1) and (l=-1) then //Always false
  Begin
   AkeyInt:=0;
   AShift:=[];
   Exit;
  End;

  AkeyInt:=l;

  Ashift:=[];
  if h and 1=1 then
   Ashift:=Ashift+[ssShift];
  if h and 2=2 then
   Ashift:=Ashift+[ssCTRL];
  if h and 1=4 then
   Ashift:=Ashift+[ssAlt];

  result:=true;
end;

procedure TNbKeyBoard.Init;
Begin
 keymap[0]:=TStringlist.create;
 keymap[1]:=TStringlist.create;

 if fileexists('Keymap.txt') then
  keymap[0].loadfromfile('Keymap.txt');
 if fileexists('Keymap1.txt') then
  keymap[1].loadfromfile('Keymap1.txt');

 
 FillNBkeys;

 NBkeyList:=TStringlist.create;

End;

procedure TNbKeyBoard.FillNBkeys;
Begin
 { NBNormal0='1234567890()*'
  +'qwertyuiop=-/ESC/'
  +'/CTRL/asdfghjkl;+/NL/'
  +'/SHFT/zxcvbnm,.///SHFT//VID/'
  +'/GRPH//REPT//HOME//INS//SPC/'+
     '/CURL//CURU//CURD//CURR//STOP/';}

  //1st ROW
  NBKeys[0]:=NB_1;
  NBKeys[1]:=NB_2;
  NBKeys[2]:=NB_3;
  NBKeys[3]:=NB_4;
  NBKeys[4]:=NB_5;
  NBKeys[5]:=NB_6;
  NBKeys[6]:=NB_7;
  NBKeys[7]:=NB_8;
  NBKeys[8]:=NB_9;
  NBKeys[9]:=NB_0;
  NBKeys[10]:=NB_LPR;
  NBKeys[11]:=NB_RPR;
  NBKeys[12]:=NB_EQU-3 ; //*;

  //2nd ROW
  NBKeys[13]:=NB_Q;
  NBKeys[14]:=NB_W;
  NBKeys[15]:=NB_E;
  NBKeys[16]:=NB_R;
  NBKeys[17]:=NB_T;
  NBKeys[18]:=NB_Y;
  NBKeys[19]:=NB_U;
  NBKeys[20]:=NB_I;
  NBKeys[21]:=NB_O;
  NBKeys[22]:=NB_P;
  NBKeys[23]:=NB_EQU;//=
  NBKeys[24]:=NB_EQU+1 ;//-
  NBKeys[25]:=NB_ESC;

  //3rd ROW
  NBKeys[26]:=NB_CTRL;
  NBKeys[27]:=NB_A;
  NBKeys[28]:=NB_S;
  NBKeys[29]:=NB_D;
  NBKeys[30]:=NB_F;
  NBKeys[31]:=NB_G;
  NBKeys[32]:=NB_H;
  NBKeys[33]:=NB_J;
  NBKeys[34]:=NB_K;
  NBKeys[35]:=NB_L;
  NBKeys[36]:=NB_COM;//;
  NBKeys[37]:=NB_EQU+2 ;//+
  NBKeys[38]:=NB_NLN; //NL

  //4th ROW
  NBKeys[39]:=NB_SHFT;
  NBKeys[40]:=NB_Z;
  NBKeys[41]:=NB_X;
  NBKeys[42]:=NB_C;
  NBKeys[43]:=NB_V;
  NBKeys[44]:=NB_B;
  NBKeys[45]:=NB_N;
  NBKeys[46]:=NB_M;
  NBKeys[47]:=54;// ,
  NBKeys[48]:=NB_DOT; // .
  NBKeys[49]:=NB_SLS;// /
  NBKeys[50]:=NB_SHFT ;// Shift
  NBKeys[51]:=NB_VID; // Video

  //5th ROW
  NBKeys[52]:=NB_GRPH;
  NBKeys[53]:=NB_REPT;
  NBKeys[54]:=NB_HOM;
  NBKeys[55]:=NB_INS;
  NBKeys[56]:=NB_SPC;
  NBKeys[57]:=NB_SPC;
  NBKeys[58]:=NB_SPC;
  NBKeys[59]:=NB_SPC;
  NBKeys[60]:=2;// <-
  NBKeys[61]:=50; // ^
  NBKeys[62]:=34;// kato
  NBKeys[63]:=18 ;// ->
  NBKeys[64]:=NB_STOP; // Stop

End;

procedure TNbKeyBoard.PCKeyDown(var Key: Word; Shift: TShiftState);
Var
   i,k:Integer;
   s:String;
begin
 GetKeyboardState(Kmap);
 k:=0;
 For i:=0 to 255 do
  if Kmap[i]>127 then
  Begin
   Pressed[k]:=i;
   Inc(k);
  End;
 Pressed[k]:=255;



 Akey:=GETPCKeyID;
 if akey='K#113' then//F2=break
  akey:='BREAK';
 s:=Akey;
 try
   NBAddKey;
 except

 end;
// ScrollOn:=GetKeyState(VK_Scroll) and 1=1;

// If (key in [37,38,39,40]) or ScrollOn then NBAddKey;
end;

procedure TNbKeyBoard.PCKeyUp(var Key: Word; Shift: TShiftState);
Var ScrollOn:Boolean;
begin
 Exit;
 //  CTRL        Shift       TAB         Alt
 if (key=17) or (key=16) or (key=9) or (key=18) then exit;

 ScrollOn:=GetKeyState(VK_Scroll) and 1=1;

 If (key in [37,38,39,40]) or scrollOn then exit;

 if Key<>0 then
  NBAddKey;
end;

procedure TNbKeyBoard.NBAddKey;
begin
 if NBkeyList.count>10 then exit;
 If Akey='' then exit;
 try
   NBkeyList.Add(AKey);
 except

 end;
 Akey:='';
 AShift:=[];
end;

function TNbKeyBoard.NBGetKey: Byte;
Var
    Sft:Integer;
    k,s,Org:String;
    t:Integer;
    NBKeyID:Integer;
    Shifted:String;
    sr:Integer;


    Function GetLastPart:String;
    var r:Integer;
        s:String;
    Begin
       s:=k;
       sr:=0;
       r:=pos('_',s);
       sr:=r;
       While r>0 do
       Begin
         s:=Copy(s,r+1,maxint);
         r:=pos('_',s);
         sr:=sr+r;
       End;
       Result:=s;
    End;

Begin
 result:=$80;//no Key pressed
 if NBkeyList.count=0 then exit;
 k:=NBkeyList[0];
 org:=k;
 NBkeyList.Delete(0);

 If Pos('SHFT',k)>0 then
  sft:=1
 else
  sft:=0; 

  t:=pos('_K#',k);
  if t>0 then
  Begin
    Shifted:=copy(k,1,t-1);
//    k:=copy(k,t+1,maxint);
  End
  Else shifted:='';

  k:=GetLastPart;
  if shifted='' then
   Shifted:=copy(k,1,sr-1);

 s:=KeyMap[sft].values[org];
 if s='' then
 Begin
  if sft=1 then sft:=0
    Else sft:=1;
  s:=KeyMap[sft].values[org];
 End;
 nbShifted:= (sft=1) and (s<>'');

 If s='' then
 Begin
  s:=KeyMap[0].values[k];
  nbShifted:=Pos('SHFT',Shifted)>0;
 End;

 try
  if s<>'' then
   NBKeyid:=strtoint(s)
  else
   NBKeyid:=-1;
 Except
  NBKeyid:=-1;
 End;

 If nbkeyid=-1 then exit;

 Result:=NBKEYs[nbkeyid];

 if nbshifted then
   Result:=Result Or $40;   //Shifted
 //CTRL
 If Pos('CTRL',Shifted)>0 then
   Result:=Result Or $80;   //Shifted
 //Graph
 If Pos('ALT',Shifted)>0 then
   Result:=Result Or $C0;   //Shifted
end;

constructor TNbKeyBoard.Create;
begin
 Init;
end;

destructor TNbKeyBoard.Destroy;
begin
  inherited;
end;

procedure TNbKeyBoard.Import(s:String);
Var k:Integer;
    cnt:Integer;

  function GetPCKeyIDLocal: string;
  Var SKey:String;
  begin

    SKEY:='';
    Result := '';

    if ssShift in AShift then
     Result:=Result+'SHFT_';
    if ssCtrl in AShift then
     Result:=Result+'CTRL_';
    if ssAlt in AShift then
     Result:=Result+'ALT_';

    Case AkeyInt of
      13:Skey:='ENTER';
      27:Skey:='ESC';
      35:Skey:='END';
      33:Skey:='PGUP';
      34:Skey:='PGDN';
      36:Skey:='HOME';
      45:Skey:='INS';
      46:Skey:='DEL';
      19:Skey:='BREAK';
    End;

    //If you have an english keyboard
    if foptions.cbEnglish.Checked then
    Begin
     if (Akeyint=50) and (Result='SHFT_') then begin Akeyint:=192;end
     else
     if (Akeyint=192) and (Result='SHFT_') then begin Akeyint:=50;Result:='SHFT_';end
     else
     if Akeyint=222 then begin Akeyint:=51;Result:='SHFT_';end
     else
     if (Akeyint=51) and (Result='SHFT_') then begin Akeyint:=222;Result:='';end;
    end;

    If skey='' then
     skey:='K#'+inttostr(AKeyInt);

    If SKey='=' then
     SKEY:='EQ';

    Result:=Result+sKey;
  end;

  Procedure EmulateFor(kk:Integer);
  var i:integer;
  Begin
    for I := 0 to kk do
    Begin
     fNewBrain.StartEmulation;
     application.ProcessMessages;
    End; 
  End;



begin
  cnt:=0;
  fNewBrain.thrEmulate.Enabled:=false;
  try
    AShift:=[];
    For k:=1 to length(s) do
    Begin
     If Translatechar(s[k]) then
     Begin
      if cnt=0 then EmulateFor(20);
      inc(cnt);
      Akey:=GETPCKeyIDLocal;//Keydown
      NBAddKey;

   //   PCKeyDOWN(AkeyInt,AShift);
      while NBkeyList.count>0 do
      begin
        EmulateFor(10);
        if application.Terminated then
             break;
      end;

      EmulateFor(5);
      if application.Terminated then
            break;
      if (s[k]=#13) or (s[k]=#10) then
      Begin
        EmulateFor(Trunc(cnt*2)+70);
        cnt:=0;
      End;
     End;
    End;

  finally
      fNewBrain.thrEmulate.Enabled:=true;
  end;
end;

function TNbKeyBoard.GetPCKeyID: String;
Var i:integer;
    pk:Smallint;
    shf:String;
    Skey:String;

    Procedure AddShf(ss:String);
    Begin
     If shf<>'' then
      shf:=shf+'_';
     shf:=shf+ss;
    End;

Begin
 i:=0;
 shf:='';
 Skey:='';
 While (i<5) and (Pressed[i]<>255) do
 Begin
   pk:=Pressed[i];
   case pk of
    16,17:;
    13:Skey:='ENTER';
    27:Skey:='ESC';
    35:Skey:='END';
    33:Skey:='PGUP';
    34:Skey:='PGDN';
    36:Skey:='HOME';
    45:Skey:='INS';
    46:Skey:='DEL';
    19:Skey:='BREAK';
    160:AddShf('SHFT');//LS
    161:AddShf('SHFT');  //RS
    162:AddShf('CTRL');  //LC
    163:AddShf('ALT');  //RC
    Else
    Begin
      skey:='K#'+inttostr(pk);
    End;
   End;//End Case
   Inc(i);
 End; //End While

 If (shf<>'') and (Skey<>'') then
  result:=shf+'_'+Skey
 else
 If shf<>'' then
  result:='' //shf
 else
  Result:=Skey;
End;

Initialization
  NBKeyBoard:=TNbKeyBoard.create;

end.
