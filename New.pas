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

unit New;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, AppEvnts, ExtCtrls,
  ComCtrls, JDLed, uNBTypes, Vcl.ToolWin, Vcl.ImgList, System.Actions,
  Vcl.ActnList, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage {, JvRegAuto}
    , IdBaseComponent, DXClass, System.ImageList, DXDraws, Z80BaseClass;
{$I 'dsp.inc'}

type

  TfNewBrain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Start1: TMenuItem;
    N2: TMenuItem;
    Exit1: TMenuItem;
    SaveDialog1: TSaveDialog;
    Debug1: TMenuItem;
    Debug2: TMenuItem;
    Suspend1: TMenuItem;
    terminate1: TMenuItem;
    SetMHz1: TMenuItem;
    SetBasicFile1: TMenuItem;
    OpenDialog1: TOpenDialog;
    StatusBar1: TStatusBar;
    N4: TMenuItem;
    LoadTextFile1: TMenuItem;
    N5: TMenuItem;
    DesignChars1: TMenuItem;
    Tools1: TMenuItem;
    N6: TMenuItem;
    About1: TMenuItem;
    TapeManagement1: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    WithExpansion1: TMenuItem;
    WithCPM1: TMenuItem;
    DiskManagement1: TMenuItem;
    SaveMemoryMap1: TMenuItem;
    Storage1: TMenuItem;
    Options1: TMenuItem;
    VFDisplayUp1: TMenuItem;
    Help1: TMenuItem;
    Help2: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    NBDigitizer1: TMenuItem;
    CheckRoms1: TMenuItem;
    ShowDriveContents1: TMenuItem;
    E1: TMenuItem;
    KeyboardMapping1: TMenuItem;
    Restart1: TMenuItem;
    FullScreen1: TMenuItem;
    SaveNewSystem1: TMenuItem;
    Disassembly1: TMenuItem;
    SelectRomVersion1: TMenuItem;
    LoadBinaryFileInMemory1: TMenuItem;
    OpenDialog2: TOpenDialog;
    SaveDisckNOW1: TMenuItem;
    WithPibox: TMenuItem;
    N9: TMenuItem;
    PeripheralSetup1: TMenuItem;
    Options2: TMenuItem;
    ShowInstructions1: TMenuItem;
    CaptureRawScreen1: TMenuItem;
    ape1: TMenuItem;
    SaveMemorytoDisk1: TMenuItem;
    Setup1: TMenuItem;
    N3: TMenuItem;
    N1: TMenuItem;
    N10: TMenuItem;
    Reset1: TMenuItem;
    aclist: TActionList;
    acStEmul: TAction;
    acRomSel: TAction;
    ImageList1: TImageList;
    acReset: TAction;
    acGenOptions: TAction;
    acTapeSelect: TAction;
    acTapeManagement: TAction;
    acDiskManagement: TAction;
    Action1: TAction;
    UpdateCheck1: TMenuItem;
    Panel4: TPanel;
    Panel3: TPanel;
    Panel1: TPanel;
    LedDisp: TJDLed;
    Panel5: TPanel;
    Panel2: TPanel;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton7: TToolButton;
    ToolButton3: TToolButton;
    ToolButton9: TToolButton;
    ToolButton8: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    Image1: TImage;
    Panel6: TPanel;
    newscr: TDXDraw;
    thrEmulate: TDXTimer;
    NBDigitizerv31: TMenuItem;
    Timer1: TTimer;
    acTapeSelect2: TAction;
    acTapeManagement2: TAction;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    Panel7: TPanel;
    Panel8: TPanel;
    Label1: TLabel;
    lblTape1Info: TLabel;
    lblTape1Info2: TLabel;
    Panel9: TPanel;
    Label2: TLabel;
    lblTape2Info: TLabel;
    lblTape2Info2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Start1Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Debug2Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Suspend1Click(Sender: TObject);
    procedure terminate1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SetMHz1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SetBasicFile1Click(Sender: TObject);
    procedure LoadTextFile1Click(Sender: TObject);
    procedure DesignChars1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure About1Click(Sender: TObject);
    procedure SaveCharMap1Click(Sender: TObject);
    procedure TapeManagement1Click(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
    procedure WithExpansion1Click(Sender: TObject);
    procedure WithCPM1Click(Sender: TObject);
    procedure DiskManagement1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SaveMemoryMap1Click(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure VFDisplayUp1Click(Sender: TObject);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure Help2Click(Sender: TObject);
    procedure NBDigitizer1Click(Sender: TObject);
    procedure CheckRoms1Click(Sender: TObject);
    procedure Disassembly1Click(Sender: TObject);
    procedure ShowDriveContents1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
      var Resize: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure KeyboardMapping1Click(Sender: TObject);
    procedure Restart1Click(Sender: TObject);
    procedure FullScreen1Click(Sender: TObject);
    procedure LoadBinaryFileInMemory1Click(Sender: TObject);
    procedure PeripheralSetup1Click(Sender: TObject);
    procedure WithPiboxClick(Sender: TObject);
    procedure SaveDisckNOW1Click(Sender: TObject);
    procedure SaveNewSystem1Click(Sender: TObject);
    procedure SelectRomVersion1Click(Sender: TObject);
    procedure ShowInstructions1Click(Sender: TObject);
    procedure CaptureRawScreen1Click(Sender: TObject);
    procedure SaveMemorytoDisk1Click(Sender: TObject);
    procedure Reset1Click(Sender: TObject);
    procedure UpdateCheck1Click(Sender: TObject);
    procedure thrEmulateTimer(Sender: TObject; LagCount: Integer);
    procedure NBDigitizerv31Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure lblTape1Info2Click(Sender: TObject);
    procedure lblTape2Info2Click(Sender: TObject);

  private
    { Private declarations }
    Halted: Boolean;
    IsSuspended: Boolean;
    bDebugging: Boolean;
    procedure HideInstructions;
    procedure ShowInstructions;
    function GetNewbrainDescr: String;
    procedure RefreshRomVer;
    procedure WriteP3(s: String);
    procedure LoadOptions;
    procedure SaveOptions;

    procedure SetParams;
    procedure DoEmulation;
    function GetRoot: string;
    function CreateOpenDialog: TOpenDialog;
    procedure tpbtnClick(Sender: TObject);
    function GetOLDOS: Byte;
    procedure OpenFile(Fname: String);
    function GetColor(cl: TColor): TColor;
    procedure DoOnidle(Sender: TObject; var Done: Boolean);
    function getDebugging: Boolean;
    procedure setDebugging(const Value: Boolean);
    procedure MakeTapeButtons(parent: TWinControl; tgSt: Integer = 0);
    function GetScreenRatio: single;

  public
    { Public declarations }
    keybFileinp: Boolean;
    bootok: Boolean;
    Emuls: Real;
    MHz: Real;
    cVers: String;

    DoOne: Boolean;
    Constructor Create(Aowner: TComponent); Override;
    function ScrNormalize(t: Integer): Integer;
    procedure LoadFormPos(frm: TForm);
    procedure SaveFormPos(frm: TForm);
    procedure StartEmulation;
    procedure SuspendEmul;
    procedure ResumeEmul;
    procedure StartEmul;
    procedure WriteP1(s: String);
    procedure SaveCharMap;
    procedure LoadCharMap;
    procedure SetLed(Sender: TObject);
    procedure WriteP2(s: String);
    procedure Step;
    procedure ShowSplash(DoShow: Boolean = true);
    property Root: string read GetRoot;
    property OLDOS: Byte read GetOLDOS;
    property Suspended: Boolean read IsSuspended;
    property Debugging: Boolean read getDebugging write setDebugging;
    property screenratio: single read GetScreenRatio;
  end;

  TEmulationJob = class(TThread)
  protected
    procedure Execute; override;
  end;

function GetFiles(Wld: AnsiString; ODirs: Boolean): TStrings;

procedure ODS(s: String);

// z80 commands
function z80_emulate(cycles: Integer): Integer;
function z80_get_reg(reg: z80_register): Word;
procedure z80_set_reg(reg: z80_register; Value: Word);
procedure z80_stop_emulating;

var
  fNewBrain: TfNewBrain;
  EmulationJob: TEmulationJob;
  LASTPC: Word; // last pc for debugging
  InterruptServed: Boolean = true;
  NBDel: Integer = 30; // Emulation Delay
  fl: String;
  pclist: Tlist = nil;
  SPlist: Tlist = nil;
  Stopped: Boolean = false;
  LastIN: Byte;
  LastOut: Byte;
  LastError: string = '';
  AppCaption: String = '';
  Prepc: Word;

implementation

uses uz80dsm, math, frmNewDebug, jcllogic, frmChrDsgn, frmAbout, frmTapeMgmt,
  uNBMemory, uNBCOP, uNBIO, uNBCPM, uNBScreen, uNBTapes, uNBKeyboard2,
  frmDiskMgmt, mmsystem, frmOptions, shellapi, frmDrvInfo, SendKey,
  frmSplash, frmDisassembly, inifiles, frmRomVersion, ustrings, frmPeriferals,
  frmInstructions, uUpdate, uStopwatch, z80intf, uNBCassette, PB.Winset;

Var
  dbgsl: TStringlist = nil;
  stopwatch: TStopWatch;
  stopwatch2: TStopWatch;
  MyZ80: TZ80Interface;

{$R *.DFM}
  // z80 commands




  // Z80 main functions

function z80_emulate(cycles: Integer): Integer;
Begin
  result := MyZ80.Z_Emulate(cycles);
End;

// Z80 context functions
function z80_get_reg(reg: z80_register): Word;
Begin
  result := MyZ80.Z_Get_Reg(reg);
End;

procedure z80_set_reg(reg: z80_register; Value: Word);
Begin
  MyZ80.Z_Set_Reg(reg, Value);
End;

// Z80 cycle functions
// function z80_get_cycles_elapsed: integer; cdecl; external 'raze.dll' name '_z80_get_cycles_elapsed';
procedure z80_stop_emulating;
Begin
End;






// z80 commands

// Delay procedure in secs and millisecs
Procedure Delay(s, ms: Word);
VAr
  totdel: Word;
  Lasttick: Cardinal;
Begin
  totdel := s * 1000 + ms;
  Lasttick := Gettickcount;
  While (Gettickcount - Lasttick) < totdel do
  Begin
    application.processmessages;
  End;
End;

// Get Directories or .Bin and .bas Files
Function GetFiles(Wld: AnsiString; ODirs: Boolean): TStrings;
Var
  pth: AnsiString;
  pfnddat: _Win32_Find_DataA;
  h: THandle;

  FUnction ISValid: Boolean;
  Begin
    if sametext(pfnddat.cFileName, '.') or sametext(pfnddat.cFileName, '..')
    then
    Begin
      result := false;
      exit;
    End;
    if ODirs then
    Begin
      if pfnddat.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY = FILE_ATTRIBUTE_DIRECTORY
      then
        result := true
      else
        result := false;
    End
    Else
    Begin
      if pfnddat.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY = FILE_ATTRIBUTE_DIRECTORY
      then
        result := false
      else
        result := true;
      if result then
        if (pos('.bin', LOWERCASE(pfnddat.cFileName)) = 0) and
          (pos('.bas', LOWERCASE(pfnddat.cFileName)) = 0) then
          result := false;
    End;
  End;

Begin
  pth := ExtractFilepath(application.exename);
  result := TStringlist.Create;
  h := FindFirstFileA(PAnsiChar(pth + Wld), pfnddat);
  if h > 0 then
  Begin
    if ISValid then
      result.Add(pfnddat.cFileName);
    While FindNextFileA(h, pfnddat) do
    Begin
      if ISValid then
        result.Add(pfnddat.cFileName);
    End;
  End;
End;

Procedure ODS(s: String);
Var
  a: Word;
Begin
  a := z80_get_reg(Z80_REG_PC);
  LASTPC := a;
  if dbgsl = nil then
    dbgsl := TStringlist.Create;
{$IFNDEF NBDEBUG}
  exit;
{$ENDIF}
  a := Prepc;
  if s <> '' then
    s := Timetostr(now) + 'PC: ' + inttohex(a, 4) + ',' +
      inttohex(LASTPC, 4) + ' ' + s
  else
    s := ' ';
  OutputDebugString(pchar(s));
  try
    dbgsl.Add(s);
  Except
    on E: Exception do
      OutputDebugString(pchar(E.message));
  End;
  // NewDebug.dbg.items.insert(0,s);
  LASTPC := a;
End;

// Call back from emulator DLL
Function READBYTE(ADDR: Integer): Integer;
Var
  a: Word;
Begin
  // a:=z80_get_reg(Z80_REG_PC);   //not used
  result := nbmem.ROM[ADDR];
  exit; // cdespNEW
  { if  fnewbrain.bootok then
    Begin
    {  if nbio.kbint and (addr=$3d) then
    nbio.kbint:=false; }
  { if Cop420.CheckReady(addr) then
    result:=nbmem.ROM[ADDR];
    end; }
End;

Procedure WRITEBYTE(ADDR: Integer; B: Integer);
Var
  a: Word;
Begin
  // a:=z80_get_reg(Z80_REG_PC);
  { if not fnewbrain.bootok then
    if addr>=$8000 then exit
    else
    if addr>=$A000 then exit; }
  nbmem.ROM[ADDR] := B;
  if ADDR = $3D then
    cop420.rom3d := B;
End;

Function GetCommentOnPort(prt: Integer): String;
Var
  s: String;
Begin
  s := '';
  Case prt of
    1:
      s := 'Load En Reg 2';
    2:
      s := 'Load Page Registers';
    3:
      s := 'Centronics Printer Port';
    4:
      s := 'Reset Clock Interrupt';
    5:
      s := 'Load DAC';
    6:
      s := 'Communicate With COP420';
    7:
      s := 'Load Enable Register 1';
    8, 10:
      s := 'Set 9th bit of Video Addr';
    9, 11:
      s := 'Load First 8 bit of Video Addr';
    12, 13, 14, 15:
      s := 'Load Video Control Register';
    16:
      s := 'Anin0 - Conversion channel 0,4';
    17:
      s := 'Anin1 - Conversion channel 1,5';
    18:
      s := 'Anin2 - Conversion channel 1,5';
    19:
      s := 'Anin3 - Conversion channel 1,5';
    20:
      s := 'Read Status Reg 1';
    21:
      s := 'Read Status Reg 2';
    22:
      s := 'Data Input Reg 1';
    23:
      s := 'User Data Bus';
    24:
      s := 'Control Reg ACIA';
    25:
      s := 'Receive Data Reg ACIA';
    26, 27:
      s := 'Unused';
    28:
      s := 'Ch 0 of CTC';
    29:
      s := 'Ch 1 of CTC';
    30:
      s := 'Ch 2 of CTC';
    31:
      s := 'Ch 3 of CTC';
    200:
      s := 'PIBOX ACIA';
    204:
      s := 'PIBOX PAGING STATUS';
    205:
      s := 'PIBOX PAGING STATUS';
    206:
      s := 'PIBOX PAGING STATUS';
    207:
      s := 'PIBOX PAGING STATUS';
    255:
      s := 'Load Page Status Reg';
  End;

  result := s;
End;

Const
  ReversePorts = true;

function NewIn(port: Integer): Integer;
{$IFDEF NBOutDEBUG}
var
  a: Word;
{$ENDIF}
  Function PortValid: Boolean;
  Begin
    Case port And $FF of
      // 2,255,9,12,4,6,20:result:=false;
      128:
        result := false; // SCREEN IO
    Else
      result := true;
    End;
    if ReversePorts then
      result := not result;
  End;

Begin
  // Result := $FF;
{$IFDEF NBOutDEBUG}
  a := z80_get_reg(Z80_REG_PC);
  LASTPC := a;
{$ENDIF}
  LastIN := (port and $FF);
  result := NbIO.NBIN(LastIN);
{$IFDEF NBOutDEBUG}
  if PortValid then
    ODS(' Port IN ' + inttostr(LastIN) + ' ' + inttostr((port and $F000)
      div 256) + ' : ' + inttostr(result) + '  -  ' + GetCommentOnPort(LastIN));
{$ENDIF}
End;

procedure NewOut(port: Integer; Value: Integer);
Var
  ch: Char;

  Function PortValid: Boolean;
  Begin
    Case port And $FF of
      // 7:result:=false;
      // 2,255,9,12,4,6,7:result:=false;
      128:
        result := false; // SCREEN IO
    Else
      result := true;
    End;
    if ReversePorts then
      result := not result;
  End;

Begin
  LastOut := port and $FF;
{$IFDEF NBOutDEBUG}
  ch := ' ';
  If Value > 32 then
    ch := chr(Value);
  if PortValid then
    ODS(' Port OUT ' + inttostr(LastOut) + ' ' + inttostr((port and $F000)
      div 256) + ' : ' + inttostr(Value) + '[' + ch + ']  -  ' +
      GetCommentOnPort(LastOut));
{$ENDIF}
  NbIO.NBOut(LastOut, Value);
End;

Function Getint: Boolean;
Begin
  result := NbIO.ClockInt or NbIO.CopInt;
End;

{
  Procedure RETI;cdecl;
  Begin
  exit;
  End;
}
Const
  MAxHist = 50;

Var
  NTI: Integer = 0;

function StepProc(ADDR: Integer): Boolean;
var
  sp: Word;
  IF1: Word;
  pc, af: Word;
  s: String;
Begin
  pc := ADDR;
  // fnewbrain.thrEmulate.enabled:=false;
{$IFDEF NBDEBUG}
  sp := z80_get_reg(Z80_REG_SP);
  if pclist = nil then
  Begin
    pclist := Tlist.Create;
    SPlist := Tlist.Create;
    pclist.Capacity := MAxHist;
    SPlist.Capacity := MAxHist;
  End;
  if NTI > 10 then
  Begin
    NTI := 0;
    if SPlist.count > MAxHist then
    Begin
      SPlist.delete(0);
      SPlist.Add(Pointer(sp));
    End
    Else
      SPlist.Add(Pointer(sp));
    if pclist.count > MAxHist then
    Begin
      pclist.delete(0);
      pclist.Add(Pointer(pc));
    End
    Else
      pclist.Add(Pointer(pc));
  End
  Else
    inc(NTI);
{$ENDIF}
  result := newdebug.checkbreak(pc);
  Prepc := pc;
  {
    af:=  z80_get_reg(Z80_REG_AF);
    s:=inttohex(af shr 8 ,2);
    if cop420.Loading then
    begin
    if prepc=$e229 then begin ODS('*****COP IS ***** a='+s+' HL='+inttohex(NBmem.GetRom($3b) ,4));ODS('');end;
    if prepc=$E233 then begin ODS('*****JR C R ***** a='+s);ODS('');end;
    if prepc=$E298 then begin ODS('*****REGINT ***** a='+s);ODS('');end;
    //  if prepc=$E29B then begin ODS('*****OR (HL)***** a='+s);ODS('');end;
    if prepc=$E2A7 then begin ODS('*****CP DISP***** a='+s);ODS('');end;
    if prepc=$E2c4 then begin ODS('*****OUT 18 ***** a='+s);ODS('');end;

    if prepc=$ef23 then begin ODS('*****LSB    ***** a='+s);ODS('');end;
    if prepc=$ef25 then begin ODS('*****MSB    ***** a='+s);ODS('');end;
    if prepc=$ef3d then begin ODS('*****TYPE   ***** a='+s);ODS('');end;
    if prepc=$ef42 then begin ODS('*****LSB CHK***** a='+s);ODS('');end;
    if prepc=$ef46 then begin ODS('*****MSB CHK***** a='+s);ODS('');end;
    if prepc=$ef53 then begin ODS('*****CASSON ***** a='+s);ODS('');end;
    end; }
  // IF1:=z80_get_reg(Z80_REG_IFF1);
  if fNewBrain.Debugging AND NOT Stopped then
  Begin
    result := true;
    z80_stop_emulating;
    Stopped := true;
  End;
  // fnewbrain.thrEmulate.enabled:=true;
End;

// interface with emulation DLL
procedure TfNewBrain.SetParams;
Begin

  Z80_getByte := READBYTE;
  Z80_SetByte := WRITEBYTE;
  Z80_InB := NewIn;
  Z80_OutB := NewOut;
  Z80_GetInterrupt := Getint;
  z80_Step := StepProc;
  MyZ80.setZ80_getByte(READBYTE);
  MyZ80.setZ80_SetByte(WRITEBYTE);
  MyZ80.setZ80_InB(NewIn);
  MyZ80.setZ80_OutB(NewOut);
  MyZ80.setZ80_GetInterrupt(Getint);
  MyZ80.setZ80_Step(StepProc);
  // z80_set_reti(@RETI);
End;

procedure TfNewBrain.Button1Click(Sender: TObject);
begin
  DoEmulation;
end;

constructor TfNewBrain.Create(Aowner: TComponent);
begin
  inherited;
  acTapeSelect.enabled := false;
  acTapeSelect2.enabled := false;
  acTapeManagement.enabled := false;
  acTapeManagement2.enabled := false;
  acDiskManagement.enabled := false;
  acReset.enabled := false;
  acStEmul.enabled := true;
  acRomSel.enabled := true;
end;

procedure TfNewBrain.Start1Click(Sender: TObject);
begin
  // Set Title
  if Start1.Tag = 0 then
  begin
    AppCaption := caption;
    caption := AppCaption + ' ~ [ ' + GetNewbrainDescr + ' ]';
    Start1.Tag := 1;
  end;
  // CREATE CLASSES
  acStEmul.enabled := false;
  acReset.enabled := true;
  WithExpansion1.enabled := false;
  WithCPM1.enabled := false;
  acTapeSelect.enabled := true;
  acTapeSelect2.enabled := true;
  acTapeManagement.enabled := true;
  acTapeManagement2.enabled := true;
  acDiskManagement.enabled := true;
  acRomSel.enabled := false;
  ShowDriveContents1.enabled := true;
  SaveNewSystem1.enabled := true;
  LoadBinaryFileInMemory1.enabled := true;
  LoadTextFile1.enabled := true;
  Restart1.enabled := true;
  Disassembly1.enabled := true;
  Panel8.enabled := true;
  Panel9.enabled := true;;
  // Start Emulation
  bootok := false;
  try
    freeandnil(cop420);
    freeandnil(NbIO);
    freeandnil(nbmem);
    freeandnil(nbscreen);
  except

  end;
  NbIO := TNBInoutSupport.Create;
  cop420 := TCOP420.Create;
  nbmem := TNBMemory.Create;
  nbscreen := TNbScreen.Create;
  nbscreen.whitecolor := GetColor(foptions.Fore.Selected);
  nbscreen.Blackcolor := GetColor(foptions.Back.Selected);
  nbscreen.newscr := newscr;
  Halted := false;

  // ---- Z80 Engine interface
  nbmem.Fpath := Root + '\roms\';
  if not nbmem.LoadMem then
    nbmem.init
  else
    WriteP1('Ram/Rom Setup from .ini');
  // todo:print to info panel the loaded rom version

  { For j:=0 to $1fff do
    nbmem.Rom[j]:=nbmem.rom[$e000+j]; }
  SetParams; // Add Handlers
  MyZ80.Z_Reset; // reset the CPU */
  // ---- Z80 Engine interface

  LoadCharset('CharSet2.chr');
  // newdebug.bpnts.items.add('B785');
  // newdebug.bpnts.items.add('E162');
  // newdebug.bpnts.items.add('E17c');
  // newdebug.bpnts.items.add('E17B');
  // bpnts.items.add('E025');
  // bpnts.items.add('E039');
  // newdebug.bpnts.items.add('6039');
  // newdebug.bpnts.items.add('0000');
  // newdebug.bpnts.items.add('0001');
  FullScreen1.Checked := Not FullScreen1.Checked;
  FullScreen1Click(nil);
  if ShowDriveContents1.Checked and WithCPM1.Checked then
    ShowDriveContents1Click(nil);
  if not WithCPM1.Checked then
  Begin
    acDiskManagement.enabled := false;
    ShowDriveContents1.enabled := false;
    SaveDisckNOW1.enabled := false;
  End;

  application.processmessages;

  SetFocus;
  ResumeEmul;

end;

procedure TfNewBrain.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If Key = vk_f7 then
  Begin
    if maxpn > 1 then
      dec(maxpn);
    exit;
  End;
  If Key = vk_f8 then
  Begin
    inc(maxpn);
    exit;
  End;
  If Key = vk_f9 then
  Begin
    if NBDel > 1 then
      dec(NBDel);
    exit;
  End;
  If Key = vk_f10 then
  Begin
    inc(NBDel);
    exit;
  End;
  nbkeyboard.PCKeyUp(Key, Shift);
end;

function TfNewBrain.GetScreenRatio: single;
begin
  result := screen.PixelsPerInch / screen.DefaultPixelsPerInch;
end;

function TfNewBrain.ScrNormalize(t: Integer): Integer;
begin
  result := trunc(t * screenratio);
end;

procedure TfNewBrain.MakeTapeButtons(parent: TWinControl; tgSt: Integer = 0);
Var
  btn: TButton;
  bw, bh: Integer;
  tp, lf: Integer;
Begin
  bw := ScrNormalize(20);
  bh := ScrNormalize(20);
  tp := ScrNormalize(16);
  lf := ScrNormalize(90);

  btn := TButton.Create(self);
  btn.parent := parent;
  btn.left := lf;
  btn.top := tp;
  btn.width := bw;
  btn.height := bh;
  btn.font.Size := 6;
  btn.caption := '<<';
  btn.Tag := tgSt + 1;
  btn.onClick := tpbtnClick;
  btn.Hint := 'First file on tape';
  btn.ShowHint := true;
  btn.TabStop := false;

  btn := TButton.Create(self);
  btn.parent := parent;
  btn.left := lf + bw + 1;
  btn.top := tp;
  btn.width := bw;
  btn.height := bh;
  btn.font.Size := 6;
  btn.caption := '<';
  btn.Tag := tgSt + 2;
  btn.onClick := tpbtnClick;
  btn.Hint := 'Previous file on tape';
  btn.ShowHint := true;
  btn.TabStop := false;

  btn := TButton.Create(self);
  btn.parent := parent;
  btn.left := lf + 2 * (bw + 1);
  btn.top := tp;
  btn.width := bw;
  btn.height := bh;
  btn.font.Size := 6;
  btn.caption := '>';
  btn.Tag := tgSt + 3;
  btn.onClick := tpbtnClick;
  btn.Hint := 'Next file on tape';
  btn.ShowHint := true;
  btn.TabStop := false;

  btn := TButton.Create(self);
  btn.parent := parent;
  btn.left := lf + 3 * (bw + 1);
  btn.top := tp;
  btn.width := bw;
  btn.height := bh;
  btn.font.Size := 6;
  btn.caption := '>>';
  btn.Tag := tgSt + 4;
  btn.onClick := tpbtnClick;
  btn.Hint := 'Last file on tape';
  btn.ShowHint := true;
  btn.TabStop := false;

  btn := TButton.Create(self);
  btn.parent := parent;
  btn.left := lf + 4 * (bw + 1);
  btn.top := tp;
  btn.width := bw;
  btn.height := bh;
  btn.font.Size := 6;
  btn.caption := '^';
  btn.Tag := tgSt + 5;
  btn.onClick := tpbtnClick;
  btn.Hint := 'Eject tape';
  btn.ShowHint := true;
  btn.TabStop := false;

End;

procedure TfNewBrain.tpbtnClick(Sender: TObject);
Var
  btn: TButton;
  Tapeinfo: TTapeInfo;
  lbl: TLabel;
  tg: Integer;
Begin
  // done:select tape

  self.activecontrol := nil;
  if not(Sender is TButton) then
    exit;
  btn := TButton(Sender);

  if btn.Tag < 10 then
  begin
    Tapeinfo := cop420.Cass1.Tapeinfo;
    lbl := lblTape1Info;
    tg := btn.Tag;
  end
  else
  begin
    Tapeinfo := cop420.Cass2.Tapeinfo;
    lbl := lblTape2Info;
    tg := btn.Tag - 10;
  end;

  if not Tapeinfo.TapeLoaded then
  Begin
    ShowMessage('Load A Tape First');
    exit;
  End;

  Case tg of
    1:
      Tapeinfo.FirstFile;
    2:
      Tapeinfo.PrevFile;
    3:
      Tapeinfo.NextFile;
    4:
      Tapeinfo.LastFile;
    5:
      Tapeinfo.Eject;
  End;
  lbl.caption := Tapeinfo.GetNextFileName;
End;

procedure TfNewBrain.UpdateCheck1Click(Sender: TObject);
begin
  frmUpdate.show;
end;

procedure TfNewBrain.LoadFormPos(frm: TForm);
var
  inif: TIniFile;
begin
  // load form position
  if fileexists(AppPath + 'NBPos.ini') then
  begin
    inif := TIniFile.Create(AppPath + 'NBPos.ini');
    try
      RestoreWindowstate(inif, frm, false);
    finally
      inif.free;
    end;
  end;
end;

procedure TfNewBrain.FormCreate(Sender: TObject);
begin
  // thremulate:=nil;
  EmulationJob := TEmulationJob.Create(true);
  cVers := LedDisp.Text;
  timeBeginPeriod(1);
  SaveDialog1.initialdir := Root + 'Progs\';
  MHz := 1; // 4
  StatusBar1.TabStop := false;
  // statusbar1.onkeydown:=FormKeyDown;
  // statusbar1.onkeyup:=FormKeyUp;
  if fileexists(ExtractFilepath(application.exename) + 'charmap0.cmp') then
    LoadCharMap
  else
    FillCharArray;
  LoadFormPos(self);
end;

Var
  Pretick: Cardinal = 0;
  ems: Cardinal = 0;

  Doesc: Boolean = true;

  // 1.000.000 States is 1Mhz
  // 13000 States is 13ms in 1MHz Clock
  // 13000*4=52000 States is 13ms in 4Mhz Clock

  CopStates: Integer = 52000; // 13ms @ 4mhz
  ClkStates: Integer = 80000; // 20ms @ 4Mhz
  CopInt: Integer = 0;
  ClkInt: Integer = 0;

  // EMULATION IS FASTER BECAUSE WE 'REFRESH' THE SCREEN FASTER
  // SHOULD FIND OUT HOW MANY ms NEWBRAIN NEEDS TO REFRESH THE SCREEN
  // AND DELAY AS MUCH

  cEmuls: Integer = 0;
  sle: TStringlist = nil;
  St: Integer = 0;
  emuled: Integer = 0;
  CopTime: Cardinal = 0;
  CLKTime: Cardinal = 0;
  EMUTime: Cardinal = 0;
  EMUReal: Cardinal = 0;
  EMUDif: Cardinal = 0;
  CpTm: Cardinal = 0;
  CkTm: Cardinal = 0;
  cpcnt, ckcnt: Integer;
  emudel: Integer = 1;
  CPUStates: longint = 4000000;

var
  copcnt: Cardinal = 0;
  clkcnt: Cardinal = 0;
  emulating: Boolean = false;
  tm: Cardinal = 0;
  s1: string;

procedure TfNewBrain.thrEmulateTimer(Sender: TObject; LagCount: Integer);
begin
  thrEmulate.enabled := false;
  try
    StartEmulation;
  finally
    thrEmulate.enabled := true;
  end;
end;

procedure TfNewBrain.Timer1Timer(Sender: TObject);
begin
  if Debug2.Checked then
    nbscreen.paintDebug;

end;

var
  nextcopclkint: Integer = 0;

procedure TfNewBrain.DoEmulation;

// calculation of newbrain interrupts
// cop interrupt every 13 ms
// clk interrupt every 20 ms
  Function GetNextIntStates: Integer;
  Var
    a, B: Integer;
  Begin
    a := CopStates - CopInt;
    B := ClkStates - ClkInt;

    if a < B then
    Begin
      result := a;
      CopInt := 0;
      ClkInt := ClkInt + a;
      NbIO.CopInt := true;
      inc(cpcnt);
      // While (GetTickCount-CopTime)<(13/4) do
      // sleep(1);
      // outputdebugstring(Pchar(inttostr(GetTickCount-CopTime)+' '+inttostr(a)+' '+inttostr(b)));
      CpTm := Gettickcount - CopTime;
      CopTime := Gettickcount;
      fl := 'Cop';
    End
    Else If a > B then
    Begin
      result := B;
      CopInt := CopInt + B;
      ClkInt := 0;
      NbIO.ClockInt := true;
      inc(ckcnt);
      // While (GetTickCount-CLKTime)<(20/4) do
      // sleep(1);
      CkTm := Gettickcount - CLKTime;
      CLKTime := Gettickcount;
      fl := 'Clock';
    End
    Else
    Begin
      result := a;
      CopInt := 0;
      ClkInt := 0;
      NbIO.CopInt := true;
      NbIO.ClockInt := true;
      inc(ckcnt);
      inc(cpcnt);
      nbscreen.CpTm := cpcnt;
      nbscreen.CkTm := ckcnt;
      ckcnt := 0;
      cpcnt := 0;
      // outputdebugstring(pchar(inttostr(cpcnt)+' '+inttostr(ckcnt)));

      // While (GetTickCount-CopTime)<(13/4) do
      // sleep(1);
      // While (GetTickCount-CLKTime)<(20/4) do
      // sleep(1);
      CpTm := Gettickcount - CopTime;
      CkTm := Gettickcount - CLKTime;
      CopTime := Gettickcount;
      CLKTime := Gettickcount;
      fl := 'Both';
    End;
  End;

var
  dif, tr: Real;
  idif, tmdif: Integer;
  Pretick2: Cardinal;
Begin
  if sle = nil then
    sle := TStringlist.Create;
  if bootok and ((NBkey = $80) or (NBkey = 0)) and cop420.KBEnabled then
    CheckKeyBoard;
  If Debugging then
  Begin
    if emuled >= St then
    Begin
      St := GetNextIntStates;
      if InterruptServed then
      Begin
        emuled := 0;
        InterruptServed := false;
      End;
    End;
    Stopped := false;
    emuled := emuled + z80_emulate(St - emuled);
  End
  Else
  Begin
    emuled := 0;
    if nextcopclkint <= 0 then
    Begin
      St := GetNextIntStates;
      nextcopclkint := St;
    end
    else
      St := nextcopclkint;
    if InterruptServed then
    Begin
      InterruptServed := false;
    End;
    // EMUReal:=emureal+(st*1000) div 4000000; //time to process st Tstates @ 4Mhz
    EMUReal := EMUReal + St div trunc((CPUStates * MHz));
    // time to process st Tstates @ 4Mhz
    St := z80_emulate(St);
    nextcopclkint := nextcopclkint - St;
    // EMUDif:=Stopwatch.ElapsedMilliseconds-EMUTime;

  End;
  if Getint then // check if there is an interrupt
    St := St + MyZ80.Z_Interrupt;
  { Inc(cEmuls);
    if cemuls<2000 then
    sle.add(inttostr(st)+'  '+fl)
    else
    Begin
    sle.savetofile('c:\emuls.txt');
    suspend1click(nil);
    End;
  }
  ems := ems + St; // Tstates

  If Gettickcount - Pretick2 >= 100 then
  Begin
    Pretick2 := Gettickcount;
    // how many tstates should have done
    EMUReal := trunc((Gettickcount - Pretick) * (CPUStates * MHz) / 1000);
    idif := ems - EMUReal;
    if idif > 0 then
    begin
      tr := idif * 1000 / (CPUStates * MHz);
      if (tr < 100) and (tr > 0) then
        sleep(trunc(tr));
    end;

  end;

  { if ems>4000000 then
    Begin
    tr:=GetTickCount-Pretick;
    delay(0,trunc(tr));
    //    sleep(trunc(tr));

    end; }

  If Gettickcount - Pretick >= 1000 then
  Begin

    // cpcnt:=0;
    // ckcnt:=0;
    Emuls := ems / 4000000; // 4Mhz
    dif := MHz - Emuls;

    stopwatch.Stop;
    EMUTime := stopwatch.ElapsedMilliseconds;
    if (EMUReal > 1000) and (EMUTime < 1100) then
    Begin
      // delay(0,(emureal-emutime) );
    End;

    // While EMUTime<1000 do
    // Begin
    // Stopwatch.Start;
    // sleep(1);
    // application.ProcessMessages;
    // Stopwatch.Stop;
    // Emutime:=Emutime+Stopwatch.ElapsedMilliseconds
    // end;
    EMUReal := 0;
    stopwatch.Start;

    if abs(dif) > 0.09 then
    Begin
      if nbscreen.Lastfps > 50 then
      begin
        inc(NBDel);
      end
      else if nbscreen.Lastfps < 50 then
        if NBDel > 1 then
          dec(NBDel);
    end;
    // idif:=Abs(Trunc(Dif*10) div 2);
    // if idif=0 then idif:=1;
    // if (nbdel=0) and (idif>1) then
    // Begin
    // Inc(maxpn);
    // inc(nbdel,3);
    // End;
    // if abs(dif)>0.09 then //check how precise we want the emulation to be
    // Begin
    // if emuls<Mhz then
    // Begin
    // if (nbdel-idif)>0 then Dec(NBDel,idif)
    // else
    // if nbdel>0 then dec(nbdel);
    // End
    // Else
    // if emuls>Mhz then Inc(NBDel,idif);
    // End;//if abs
    ems := 0;
    Pretick := Gettickcount;
  End; // gettickcount
End;

procedure TfNewBrain.Button3Click(Sender: TObject);
Var
  ADDR: String;
  k: Integer;
begin
  if InputQuery('ADDRESS', 'Prompt', ADDR) then
  BEgin
    k := newdebug.bpnts.items.indexof(ADDR);
    if k = -1 then
      newdebug.bpnts.items.Add(ADDR);
  End;
end;

procedure TfNewBrain.Button4Click(Sender: TObject);
begin
  if newdebug.bpnts.ItemIndex > -1 then
    newdebug.bpnts.items.delete(newdebug.bpnts.ItemIndex);
end;

procedure TfNewBrain.Exit1Click(Sender: TObject);
begin
  Close;
end;

function TfNewBrain.GetRoot: string;
begin
  result := ExtractFilepath(application.exename);
end;

procedure TfNewBrain.Debug2Click(Sender: TObject);
begin
  Debug2.Checked := not Debug2.Checked;
  newdebug.Visible := Debug2.Checked;
end;

Function TfNewBrain.CreateOpenDialog: TOpenDialog;
Begin
  result := TOpenDialog.Create(self);
  result.Options := [ofHideReadOnly, ofEnableSizing];
  result.filter := 'NewBrain Files|*.sav';
  result.DefaultExt := '*.sav';
  result.initialdir := Root + 'Progs\';
  result.FilterIndex := 1;
End;

procedure TfNewBrain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
Var
  AShift: TShiftState;
begin
  AShift := [];
  if getasynckeystate(VK_RShift) <> 0 then
    RShift := true // send it in nbkeyboard
  else
    RShift := false;
  if getasynckeystate(VK_RShift) <> 0 then
    AShift := AShift + [ssShift];
  if getasynckeystate(VK_LShift) <> 0 then
    AShift := AShift + [ssShift];
  if getasynckeystate(VK_LControl) <> 0 then
    AShift := AShift + [ssCtrl];
  if getasynckeystate(VK_RControl) <> 0 then
    AShift := AShift + [ssAlt];
  nbkeyboard.PCKeyDown(Key, AShift);
end;

Function ReverseBits(b1: Byte): Byte;
Begin
  Asm
    push ax
    push bx
    mov al,b1
    mov bl,0
    mov bh,8
  @@ee: rcr al,1
    rcl bl,1
    dec bh
    jnz @@ee
    mov Result,bl
    pop bx
    pop ax
  End;
End;

var
  eer: Integer = 0;

procedure TfNewBrain.SuspendEmul;
begin
  IsSuspended := true;
  thrEmulate.enabled := false;
  // EmulationJob.Suspend;
end;

procedure TfNewBrain.ResumeEmul;
begin
  IsSuspended := false;
  thrEmulate.enabled := true;
  // EmulationJob.Start;
end;

procedure TfNewBrain.Suspend1Click(Sender: TObject);
begin
  Suspend1.Checked := not Suspend1.Checked;
  if Suspend1.Checked then
    SuspendEmul
  else
    ResumeEmul;
end;

procedure TfNewBrain.StartEmul;
begin
  IsSuspended := false;
end;

procedure TfNewBrain.terminate1Click(Sender: TObject);
begin
  // FPS Check Menu
  terminate1.Checked := not terminate1.Checked;
  if Assigned(nbscreen) then
    nbscreen.ShowFps := terminate1.Checked;
end;

procedure TfNewBrain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  freeandnil(cop420);
  SaveOptions;
end;

procedure TfNewBrain.SetMHz1Click(Sender: TObject);
var
  m: String;
begin
  m := floattostr(MHz);
  if InputQuery('Input Cpu Multiplier ', 'Value (Real) (NB~0.6)', m) then
  Begin
    try
      MHz := strtofloat(m);
    Except
      if pos(',', m) > 0 then
        m := stringreplace(m, ',', '.', [])
      else
        m := stringreplace(m, '.', ',', []);
      try
        MHz := strtofloat(m);
      Except
        MHz := 1;
      End;
    End;
  End;
end;

procedure TfNewBrain.FormShow(Sender: TObject);
var
  fRomVersion: TfRomVersion;
begin
  fRomVersion := TfRomVersion.Create(nil);
  try
    fRomVersion.getRomVersion(Vers, sVers);
    RefreshRomVer;
  finally
    fRomVersion.free;
  end;
  MakeTapeButtons(Panel8); // Tape1
  MakeTapeButtons(Panel9, 10); // Tape2
  Debug2Click(Sender);
  newscr.width := ScrNormalize(640);
  newscr.height := ScrNormalize(500);
  newscr.SurfaceHeight := newscr.height;
  newscr.SurfaceWidth := newscr.width;
end;

procedure TfNewBrain.SetBasicFile1Click(Sender: TObject);
var
  cass: TNBCassette;
begin
  // done:pick a file for each tape
  if Sender = acTapeSelect then
    cass := cop420.Cass1
  else
    cass := cop420.Cass2;
  OpenDialog1.initialdir := cass.Root;
  if OpenDialog1.Execute then
  Begin
    if sametext(extractfileext(OpenDialog1.FileName), '.bin') then
      cass.FileIsBinary := true
    else
      cass.FileIsBinary := false;
    // BinaryFile1.checked:=cop420.FileIsBinary;
    cass.FileName := Extractfilename(OpenDialog1.FileName);
    cass.FileName := ChangeFileExt(cass.FileName, '');
    Delay(1, 0);
    kbuf := 'LOAD';
    cass.DoResetTape;

    // nbkeyboard.import(kbuf);
  End;

end;

procedure TfNewBrain.setDebugging(const Value: Boolean);
begin
  bDebugging := Value;
  Z80Steping := Value;
end;

procedure TfNewBrain.WriteP1(s: String);
begin
  fNewBrain.StatusBar1.Panels[0].Text := s;
end;

procedure TfNewBrain.WriteP2(s: String);
begin
  fNewBrain.StatusBar1.Panels[1].Text := s;
end;

procedure TfNewBrain.WriteP3(s: String);
begin
  fNewBrain.StatusBar1.Panels[3].Text := s;
end;

procedure TfNewBrain.LoadTextFile1Click(Sender: TObject);
Var
  sl: TStringlist;
  Fpath: String;
  opdlg: TOpenDialog;
begin
  Fpath := ExtractFilepath(application.exename);
  opdlg := TOpenDialog.Create(nil);
  try
    opdlg.initialdir := Fpath;
    if opdlg.Execute then
    Begin
      sl := TStringlist.Create;
      try
        sl.loadfromfile(opdlg.FileName);
        kbuf := #13#10 + 'Open#0,0,"l200"' + #13#10 + #13#10 + sl.Text + #13#10
          + 'Importing Finished...';
      finally
        sl.free;
      end;
      kbufc := 1;
      nbkeyboard.import(kbuf);
      // keybFileinp:=true;
      // doImport;
      // ShowMessage('Import Finished');
    End;
  Finally
    opdlg.free;
  End;
end;

procedure TfNewBrain.DesignChars1Click(Sender: TObject);
begin
  // Suspendemul;
  fchrdsgn := Tfchrdsgn.Create(nil);
  fchrdsgn.show;
end;

procedure TfNewBrain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  s: String;
  i: Integer;
begin
  try
    if Assigned(nbdiscctrl) then
    Begin
      nbdiscctrl.dir1 := '';
      nbdiscctrl.dir2 := '';
    End;
  Except
  End;
  IsSuspended := true;
  // sleep(1000);
  try
    if Assigned(dbgsl) then
    Begin
      if pclist <> nil then
      Begin
        dbgsl.Add('------END-----');
        dbgsl.Add('PC,SP HISTORY');
        For i := 0 to pclist.count - 1 do
        Begin
          s := format('PC: %d - SP: %d', [Integer(pclist[i]),
            Integer(SPlist[i])]);
          dbgsl.Add(s);
        end;
      End;
      dbgsl.SaveToFile(AppPath + 'ODS2.txt');
    End;
  Except
  End;
  if Assigned(newdebug) then
    newdebug.Close;
  if Assigned(frmdis) then
    frmdis.Close;

end;

procedure TfNewBrain.About1Click(Sender: TObject);
begin
  Fabout := Tfabout.Create(self);
  Fabout.showmodal;
  freeandnil(Fabout);
end;

procedure TfNewBrain.SetLed(Sender: TObject);
BEgin
  LedDisp.Text := nbscreen.ledtext;
End;

// Keyboard Mappings
procedure TfNewBrain.SaveCharMap;
Var
  i: Integer;
  sl: TStringlist;
begin
  sl := TStringlist.Create;
  try
    For i := 1 to 255 do
      sl.values['PC_' + inttostr(i)] := inttostr(a[0, i]);
    sl.SaveToFile(ExtractFilepath(application.exename) + 'charmap0.cmp');
    sl.clear;
    For i := 1 to 255 do
      sl.values['PC_' + inttostr(i)] := inttostr(a[1, i]);
    sl.SaveToFile(ExtractFilepath(application.exename) + 'charmap1.cmp');
  Finally
    sl.free;
  End;
end;

// Keyboard Mappings
procedure TfNewBrain.LoadCharMap;
Var
  i: Integer;
  sl: TStringlist;
begin
  sl := TStringlist.Create;
  try
    sl.loadfromfile(ExtractFilepath(application.exename) + 'charmap0.cmp');
    For i := 1 to 255 do
      a[0, i] := strtoint(sl.values['PC_' + inttostr(i)]);
    sl.clear;
    sl.loadfromfile(ExtractFilepath(application.exename) + 'charmap1.cmp');
    For i := 1 to 255 do
      a[1, i] := strtoint(sl.values['PC_' + inttostr(i)]);
  Finally
    sl.free;
  End;
end;

procedure TfNewBrain.SaveCharMap1Click(Sender: TObject);
begin
  SaveCharMap;
end;

procedure TfNewBrain.TapeManagement1Click(Sender: TObject);
var
  Tapeinfo: TTapeInfo;
begin
  if Sender = acTapeManagement then
    Tapeinfo := cop420.Cass1.Tapeinfo
  else
    Tapeinfo := cop420.Cass2.Tapeinfo;

  fTapeMgmt := TfTapeMgmt.Create(self);
  try
    if fTapeMgmt.showmodal = MROk then
      if fTapeMgmt.Selected <> '' then
        Tapeinfo.LoadTape(fTapeMgmt.Selected);
  Finally
    fTapeMgmt.free;
  End;
  // Seldir.InitialDir:=extractfilepath(Application.exename)+'\Basic\';
  // if seldir.Execute then
  // tapeinfo.LoadTape(extractfilename(seldir.Directory));
end;

procedure TfNewBrain.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
begin
  exit;
  case Msg.message of
    WM_KEYFIRST .. WM_KEYLAST:
      ShowMessage('hi');
  End;
  Handled := false;
end;

procedure TfNewBrain.WithExpansion1Click(Sender: TObject);
begin
  WithExpansion1.Checked := not WithExpansion1.Checked;
end;

procedure TfNewBrain.WithCPM1Click(Sender: TObject);
begin
  WithCPM1.Checked := not WithCPM1.Checked;
end;

procedure TfNewBrain.WithPiboxClick(Sender: TObject);
begin
  WithPibox.Checked := not WithPibox.Checked;
  if WithPibox.Checked then
  Begin
    WithExpansion1.Checked := false;
    // WithCPM1.Checked:=false;
    WithExpansion1.enabled := false;
    // WithCPM1.Enabled:=false;
  end
  else
  begin
    WithExpansion1.enabled := true;
    // WithCPM1.Enabled:=true;
    WriteP2('');
  end;
end;

function TfNewBrain.GetOLDOS: Byte;
begin
  result := nbmem.ROM[$AD];
end;

procedure TfNewBrain.DiskManagement1Click(Sender: TObject);
Var
  dir1, dir2: String;
  t: Integer;
begin
  dir1 := nbdiscctrl.dir1;
  dir2 := nbdiscctrl.dir2;
  t := fDiskMgmt.lb1.items.indexof(dir1);
  fDiskMgmt.lb1.ItemIndex := t;
  if t = -1 then
    dir1 := '';
  t := fDiskMgmt.lb2.items.indexof(dir2);
  fDiskMgmt.lb2.ItemIndex := t;
  if t = -1 then
    dir2 := '';
  if fDiskMgmt.showmodal = MROk then
  Begin
    if fDiskMgmt.lb1.ItemIndex > -1 then
      dir1 := fDiskMgmt.lb1.items[fDiskMgmt.lb1.ItemIndex]
    Else
      dir1 := '';
    if fDiskMgmt.lb2.ItemIndex > -1 then
      dir2 := fDiskMgmt.lb2.items[fDiskMgmt.lb2.ItemIndex]
    Else
      dir2 := '';
    nbdiscctrl.dir1 := dir1;
    nbdiscctrl.dir2 := dir2;
    ShowDriveContents1Click(nil);
  End;
end;

procedure TfNewBrain.SaveFormPos(frm: TForm);
var
  inif: TIniFile;
Begin
  // save form position
  inif := TIniFile.Create(AppPath + 'NBPos.ini');
  try
    SaveWindowstate(inif, frm, false);
  finally
    inif.free;
  end;
end;

procedure TfNewBrain.FormDestroy(Sender: TObject);
begin
  SaveFormPos(self);
  timeEndPeriod(1);
end;

procedure TfNewBrain.SaveMemoryMap1Click(Sender: TObject);
Var
  m: TNBMemory;
begin
  m := TNBMemory.Create;
  m.SaveMem;
  m.free;
end;

procedure TfNewBrain.SaveMemorytoDisk1Click(Sender: TObject);
var
  stmem, bytelen: Integer;
  f: TFilestream;
  nbb: Byte;
  i: Integer;
begin
  if Start1.enabled then
    exit;
  stmem := 642; // nb screen start
  bytelen := 11000;
  f := TFilestream.Create(AppPath + 'nbscreen.bin', fmCreate);
  for i := stmem to stmem + bytelen - 1 do
  Begin
    nbb := nbmem.ROM[i];
    f.Write(nbb, 1);
  end;
  f.Destroy;
end;

procedure TfNewBrain.Step;
begin
  DoOne := true;
end;

Type
  tcolrec = record
    r: Byte;
    g: Byte;
    B: Byte;
  End;

  pColRec = ^tcolrec;

Function TfNewBrain.GetColor(cl: TColor): TColor;
Var
  pc: pColRec;
  t: Byte;
Begin
  pc := @cl;
  t := pc.r;
  pc.r := pc.B;
  pc.B := t;
  result := cl;
End;

function TfNewBrain.getDebugging: Boolean;
begin
  result := bDebugging;
end;

procedure TfNewBrain.Options1Click(Sender: TObject);
begin
  if foptions.showmodal = MROk then
  Begin
    if Assigned(nbscreen) then
    Begin
      nbscreen.whitecolor := GetColor(foptions.Fore.Selected);
      nbscreen.Blackcolor := GetColor(foptions.Back.Selected);
    End;
  End;
end;

procedure TfNewBrain.VFDisplayUp1Click(Sender: TObject);
begin
  VFDisplayUp1.Checked := not VFDisplayUp1.Checked;
  if VFDisplayUp1.Checked then
    Panel1.align := altop
  else
    Panel1.align := albottom;
end;

procedure TfNewBrain.ApplicationEvents1Exception(Sender: TObject; E: Exception);
begin
  ShowMessage(E.message + #13#10 + 'Emulator will be terminated');
  ExitProcess(0);
  Halt(0);
end;

procedure TfNewBrain.Help2Click(Sender: TObject);
// Var pth:String;
begin
  // pth:=ExtractFilePath(Application.exename);
  // ShowText('',pth+'help.txt','Newbrain Help');
  // Shellexecute(Handle,'open',Pchar('newbrain.hlp'),nil,Pchar(Root),SW_SHOW);
  Shellexecute(Handle, 'open', pchar('https://newbrainemu.eu/NBHelp/'), nil,
    nil, SW_SHOW);
end;

procedure TfNewBrain.OpenFile(Fname: String);
Begin
  Shellexecute(Handle, 'open', pchar(Fname), nil, pchar(ExtractFilepath(Fname)
    ), SW_SHOW);
End;

procedure TfNewBrain.NBDigitizer1Click(Sender: TObject);
begin
  If fileexists(Root + 'tools\NBDigit2.exe') then
    OpenFile(Root + 'tools\NBDigit2.exe')
  Else
    MessageDlg('Place NbDigit2.exe in the tools subdir.', mtWarning, [mbOK], 0);
end;

procedure TfNewBrain.NBDigitizerv31Click(Sender: TObject);
begin
  If fileexists(Root + 'tools\NBDigit3.exe') then
    OpenFile(Root + 'tools\NBDigit3.exe')
  Else
    MessageDlg('Place NbDigit3.exe in the tools subdir.', mtWarning, [mbOK], 0);
end;

procedure TfNewBrain.CaptureRawScreen1Click(Sender: TObject);
begin
  if Assigned(nbscreen) then
  Begin
    nbscreen.capturetodisk;
    nbscreen.TakeScreenShot;
    application.MessageBox('RAW Screen saved as [ScrRaw.bin]'#10#13 +
      'Original Screen saved as [NbScreen_Orig.DIB]'#10#13 +
      'Scaled Screen saved as [NbScreen_Scaled.DIB]', 'Message');
  End;
end;

procedure TfNewBrain.CheckRoms1Click(Sender: TObject);
begin
  if fileexists(Root + 'tools\CRoms.exe') then
    OpenFile(Root + 'tools\CRoms.exe')
  else
    MessageDlg('Place CRoms.exe in the tools subdir.', mtWarning, [mbOK], 0);
end;

procedure TfNewBrain.Disassembly1Click(Sender: TObject);
begin
  ShowDisassembler;
end;

procedure TfNewBrain.ShowDriveContents1Click(Sender: TObject);
begin
  if Sender <> nil then
    ShowDriveContents1.Checked := not ShowDriveContents1.Checked;
  if fDrvInfo = nil then
    fDrvInfo := TfDrvInfo.Create(self);
  fDrvInfo.Visible := ShowDriveContents1.Checked;
  fDrvInfo.FillInfo(-1);
end;

procedure TfNewBrain.FormResize(Sender: TObject);
begin
  if Assigned(fDrvInfo) and fDrvInfo.Visible then
    fDrvInfo.DoResize1;
end;

procedure TfNewBrain.FormCanResize(Sender: TObject;
  var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
  if Assigned(fDrvInfo) and fDrvInfo.Visible then
    fDrvInfo.DoResize1;
end;

procedure TfNewBrain.ShowSplash(DoShow: Boolean = true);
begin
  If DoShow then
  Begin
    fsplash := TFSplash.Create(self);
    fsplash.show;
  End
  Else
    fsplash.free;
end;

procedure TfNewBrain.FormActivate(Sender: TObject);
var
  s: string;
begin
  OnActivate := nil;
  // ShowSplash(True);
  LoadOptions;
  RefreshRomVer;
  // Delay(1,500);
  // ShowSplash(False);
  ShowInstructions1Click(nil);
  if frmUpdate.CheckVersion(s) then
    WriteP2('New Version exist!!! Please update.');

end;

procedure TfNewBrain.KeyboardMapping1Click(Sender: TObject);
begin
  if fileexists(Root + 'tools\NBMapKeyb.exe') then
    OpenFile(Root + 'tools\NBMapKeyb.exe')
  else
    MessageDlg('Place NBMapKeyb.exe in the tools subdir.', mtWarning,
      [mbOK], 0);
end;

procedure TfNewBrain.lblTape1Info2Click(Sender: TObject);
begin
  acTapeManagement.Execute;
end;

procedure TfNewBrain.lblTape2Info2Click(Sender: TObject);
begin
  acTapeManagement2.Execute;
end;

procedure TfNewBrain.Reset1Click(Sender: TObject);
begin
  SuspendEmul;
  fNewBrain.bootok := false;
  Start1.enabled := true;
  Start1Click(nil);
end;

procedure TfNewBrain.Restart1Click(Sender: TObject);
Var
  fn: String;
begin
  fn := application.exename;
  Shellexecute(0, 'OPEN', pchar(fn), nil, pchar(ExtractFilepath(fn)), SW_SHOW);
  Close;
end;

procedure TfNewBrain.FullScreen1Click(Sender: TObject);
begin
  FullScreen1.Checked := not FullScreen1.Checked;
  if Start1.enabled then
    exit;
  If FullScreen1.Checked then
  Begin
    newscr.Options := newscr.Options + [doFullScreen];
    Debug2.enabled := false;
    LedDisp.Visible := false;
  End
  else
  Begin
    newscr.Options := newscr.Options - [doFullScreen];
    Debug2.enabled := true;
    LedDisp.Visible := true;
  End;
  newscr.Initialize;
end;

// Load a .LDR and the correspondin bin file to memory
procedure TfNewBrain.LoadBinaryFileInMemory1Click(Sender: TObject);
var
  sl: TStringlist;
  sts, ses: String;
  St, se, i: Integer;
  sf: TFilestream;
  B: Byte;
begin
  if OpenDialog2.Execute then
  Begin
    sl := TStringlist.Create;
    try
      sl.loadfromfile(OpenDialog2.FileName);
      sts := sl.values['ADDRESS'];
      ses := sl.values['LENGTH'];
      If GetValidInteger(sts, St) and GetValidInteger(ses, se) then
      Begin
        sf := TFilestream.Create(ChangeFileExt(OpenDialog2.FileName, '.BIN'),
          fmOpenRead);
        try
          for i := 0 to se - 1 do
          Begin
            sf.Read(B, 1);
            nbmem.SetRom(St + i, B);
          end;
          ShowMessage('File Loaded at Address:' + sts + ' [' + ses + ' bytes]');
        finally
          sf.free;
        end;
      end;
    finally
      sl.free;
    end;
  end;
end;

procedure TfNewBrain.SaveNewSystem1Click(Sender: TObject);
Var
  NewSysNm: String;
begin
  NewSysNm := 'System1.dsk';
  If InputQuery('Sys File Name', 'Prompt', NewSysNm) then
    nbdiscctrl.SaveNewSystem(NewSysNm);
end;

Var
  DebugTimer: Integer;

procedure TfNewBrain.StartEmulation;
begin

  if LastError <> '' then
  Begin
    try
      ShowMessage(LastError);
      LastError := '';
    finally
    end;
  End;
  if not IsSuspended then
  Begin
    if Debugging then
    Begin
      if DoOne then
      Begin
        DoOne := false;
        DoEmulation;
      End;
      sleep(1);
    End
    else
      DoEmulation;
  End;

  IF Debug2.Checked then
  Begin
    if DebugTimer > 10 then
    Begin
      nbscreen.paintDebug;
      DebugTimer := 0
    end
    Else
      inc(DebugTimer);
  end;
end;

procedure TfNewBrain.PeripheralSetup1Click(Sender: TObject);
begin
  if frmPerif.showmodal = MROk then
  Begin
    if withMicropage or withdatapack or uNBTypes.WithPibox then
    Begin
      WithExpansion1.Checked := false;
      WithCPM1.Checked := false;
      WithExpansion1.enabled := false;
      WithCPM1.enabled := false;
      if withdatapack then
        WriteP2('Type "OPEN#0,10" for Datapack MENU')
      Else
        WriteP2('');
      PeripheralSetup1.Checked := true;
    end
    else
    Begin
      WithExpansion1.enabled := false;
      WithCPM1.enabled := false;
      PeripheralSetup1.Checked := false;
    end;
  End;
end;

Function TfNewBrain.GetNewbrainDescr: String;
Var
  v: String;
Begin
  v := 'AD Ver.';
  v := v + inttostr(Vers) + '.' + inttostr(sVers);
  if WithCPM1.Checked then
    v := v + ' - CPM';
  if WithExpansion1.Checked then
    v := v + ' - EIM';
  if withMicropage then
    v := v + ' - MP';
  if withdatapack then
    v := v + ' - DP';
  if uNBTypes.WithPibox then
    v := v + ' - PIBOX';
  result := v;
end;

procedure TfNewBrain.LoadOptions;
Var
  inif: TIniFile;
  pth: String;
begin
  pth := ExtractFilepath(application.exename);
  inif := TIniFile.Create(pth + 'Config.Ini');
  try
    VFDisplayUp1.Checked := inif.ReadBool('FILE', 'VFDisp',
      VFDisplayUp1.Checked);
    WithExpansion1.Checked := inif.ReadBool('FILE', 'withExp',
      WithExpansion1.Checked);
    WithCPM1.Checked := inif.ReadBool('FILE', 'withCPM', WithCPM1.Checked);
    ShowInstructions1.Checked := inif.ReadBool('OPTIONS', 'ShowInst',
      ShowInstructions1.Checked);
    ShowDriveContents1.Checked := inif.ReadBool('DISK', 'ShowDriveCont',
      ShowDriveContents1.Checked);
  Finally
    inif.free;
  End;
end;

procedure TfNewBrain.SaveOptions;
Var
  inif: TIniFile;
  pth: String;
begin
  pth := ExtractFilepath(application.exename);
  inif := TIniFile.Create(pth + 'Config.Ini');
  try
    inif.WriteBool('FILE', 'VFDisp', VFDisplayUp1.Checked);
    inif.WriteBool('FILE', 'withExp', WithExpansion1.Checked);
    inif.WriteBool('FILE', 'withCPM', WithCPM1.Checked);
    inif.WriteBool('OPTIONS', 'ShowInst', ShowInstructions1.Checked);
    inif.WriteBool('DISK', 'ShowDriveCont', ShowDriveContents1.Checked);
  Finally
    inif.free;
  End;
end;

procedure TfNewBrain.RefreshRomVer;
Var
  s: String;
Begin
  s := inttostr(Vers) + '.' + inttostr(sVers);
  WriteP3(s);
end;

procedure TfNewBrain.SaveDisckNOW1Click(Sender: TObject);
begin
  nbdiscctrl.WriteDisk('temp.dsk');
end;

procedure TfNewBrain.SelectRomVersion1Click(Sender: TObject);
begin
  fRomVersion := TfRomVersion.Create(nil);
  try
    If fRomVersion.showmodal = MROk then
    Begin
      Vers := fRomVersion.MjVersion;
      sVers := fRomVersion.MnVersion;
      RefreshRomVer;
    end;
  finally
    fRomVersion.free;
  end;
end;

procedure TfNewBrain.ShowInstructions1Click(Sender: TObject);
begin
  if Sender <> nil then
    ShowInstructions1.Checked := Not ShowInstructions1.Checked;
  if ShowInstructions1.Checked then
    ShowInstructions
  Else
    HideInstructions;
end;

procedure TfNewBrain.ShowInstructions;
Begin
  if Assigned(fInstructions) then
  Begin
    fInstructions.Bringtofront;
    fInstructions.show;
    exit;
  end;
  fInstructions := TfInstructions.Create(self);
  fInstructions.show;
end;

procedure TfNewBrain.HideInstructions;
Begin
  fInstructions.free;
  fInstructions := nil;
end;

procedure TfNewBrain.DoOnidle(Sender: TObject; var Done: Boolean);
Begin
  // StartEmulation;
End;

{ TEmulationJob }

procedure TEmulationJob.Execute;
begin
  inherited;
  while not Terminated do
  begin
    fNewBrain.StartEmulation;
    sleep(1);
  end;
end;

Initialization

registerclass(TButton);
AppPath := ExtractFilepath(application.exename);
stopwatch := TStopWatch.Create;
stopwatch2 := TStopWatch.Create;
MyZ80 := CreateCPPDescClass;

Finalization

end.
