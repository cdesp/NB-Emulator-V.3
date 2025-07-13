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
unit frmDisassembly;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ExtDlgs, Buttons, Tabs, DockTabSet,
  OoMisc, AdPort, ADTrmEmu, Vcl.Samples.Spin, Vcl.Mask;

Const
  cLnSpace=0;
  unitname='NEWBRAIN INTERNAL ASSEMBLER / DISASSEMBLER';

type

  TInstr=Record
     Addr:Integer;
     Nob:SmallInt; //no of bytes 1,2,3
     Bytes:Array[1..4] of byte;
     Instr:String[16];
     Comments:String[128];
     CommentsPre:String[9];
  end;
  PInstr=^TInstr;

  TInstrList=Class(TList)
  private
     Procedure New;
  protected
     function GetInstr(Index: Integer): pInstr;
     procedure PutInstr(Index: Integer; Item: PInstr);
  public
     procedure Clear; override;
     Function GetInstrIdxFromAddr(Addr:Integer):Integer;
     property Instr[Index: Integer]: pInstr read GetInstr write PutInstr; default;

  end;


  Tfrmdis = class(TForm)
    PageControl1: TPageControl;
    TSDis: TTabSheet;
    Panel2: TPanel;
    pbShow: TPaintBox;
    ScrollBar1: TScrollBar;
    TSAsm: TTabSheet;
    Panel4: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    OpenTextFileDialog1: TOpenTextFileDialog;
    SaveTextFileDialog1: TSaveTextFileDialog;
    SpeedButton3: TSpeedButton;
    PageControl2: TPageControl;
    TSSource: TTabSheet;
    asmText: TMemo;
    TSBinary: TTabSheet;
    BinText: TMemo;
    TSSymbols: TTabSheet;
    memLabels: TMemo;
    TSMessages: TTabSheet;
    memMessages: TMemo;
    StatusBar1: TStatusBar;
    Panel3: TPanel;
    PbData: TPaintBox;
    ScrollBar2: TScrollBar;
    Splitter1: TSplitter;
    Panel1: TPanel;
    Label6: TLabel;
    lblCombo: TComboBox;
    lblEdit: TEdit;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    TSErrors: TTabSheet;
    memErrors: TMemo;
    SaveBinFileDialog: TSaveTextFileDialog;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Panel5: TPanel;
    Label4: TLabel;
    Edit3: TEdit;
    Label5: TLabel;
    Edit4: TEdit;
    Panel6: TPanel;
    Label3: TLabel;
    cbpAGES: TComboBox;
    Label1: TLabel;
    edStAddr: TEdit;
    Label2: TLabel;
    edLines: TEdit;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    Label7: TLabel;
    edPgLen: TEdit;
    DockTabSet1: TDockTabSet;
    DockPanel: TPanel;
    TSGlob: TTabSheet;
    GlobLabels: TMemo;
    TSProj: TTabSheet;
    ProjText: TMemo;
    Bevel3: TBevel;
    SpeedButton10: TSpeedButton;
    CheckBox1: TCheckBox;
    TabSheet1: TTabSheet;
    AdTerminal1: TAdTerminal;
    ApdComPort1: TApdComPort;
    Button1: TButton;
    ProgressBar1: TProgressBar;
    Edit1: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    Button2: TButton;
    Edit2: TEdit;
    Button3: TButton;
    cominfolabel: TLabel;
    TrackBar1: TTrackBar;
    Edit5: TEdit;
    Button4: TButton;
    CheckBox2: TCheckBox;
    Button5: TButton;
    OpenTextFileDialog2: TOpenTextFileDialog;
    Label10: TLabel;
    Label11: TLabel;
    Button6: TButton;
    ListBox1: TListBox;
    SpeedButton11: TSpeedButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Shape1: TShape;
    Shape2: TShape;
    Timer1: TTimer;
    Label12: TLabel;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Edit6: TEdit;
    Edit7: TEdit;
    Panel7: TPanel;
    PaintBox1: TPaintBox;
    LabeledEdit1: TLabeledEdit;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    Label13: TLabel;
    Label14: TLabel;
    Button14: TButton;
    procedure asmTextKeyPress(Sender: TObject; var Key: Char);
    procedure asmTextMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure BinTextKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbpAGESChange(Sender: TObject);
    procedure DockPanelDockDrop(Sender: TObject; Source: TDragDockObject; X, Y:
        Integer);
    procedure DockPanelUnDock(Sender: TObject; Client: TControl; NewTarget:
        TWinControl; var Allow: Boolean);
    procedure DockTabSet1DockOver(Sender: TObject; Source: TDragDockObject; X, Y:
        Integer; State: TDragState; var Accept: Boolean);
    procedure DoDisassembly;
    procedure DoDisAsmPrint;
    procedure DoDisasmData;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta:
        Integer; MousePos: TPoint; var Handled: Boolean);
    procedure lblComboChange(Sender: TObject);
    procedure PageControl2Change(Sender: TObject);
    procedure PbDataMouseDown(Sender: TObject; Button: TMouseButton; Shift:
        TShiftState; X, Y: Integer);
    procedure PbDataPaint(Sender: TObject);
    procedure pbShowClick(Sender: TObject);
    procedure pbShowDblClick(Sender: TObject);
    procedure pbShowMouseDown(Sender: TObject; Button: TMouseButton; Shift:
        TShiftState; X, Y: Integer);
    procedure pbShowPaint(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure ScrollBar2Change(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure StatusBar1DblClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure ApdComPort1TriggerAvail(CP: TObject; Count: Word);
    procedure SpeedButton11Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure ApdComPort1TriggerModemStatus(Sender: TObject);
    procedure ApdComPort1TriggerStatus(CP: TObject; TriggerHandle: Word);
    procedure ApdComPort1TriggerTimer(CP: TObject; TriggerHandle: Word);
    procedure ApdComPort1PortOpen(Sender: TObject);
    procedure ApdComPort1PortClose(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    cx,cy:Integer;
    ActMem:TMemo;
    ChrX: Integer;
    ChrY: Integer;
    CommentsChanged: Boolean;
    CurFile: string;
    DatAddr: Integer;
    DataLineBytes: Integer;
    DataTopMargin: Integer;
    DataVisLines: Integer;
    DataWidthBytes: Integer;
    DatLen: Integer;
    DatPage: Integer;
    DatWid: Integer;
    Errors: Integer;
    fisNewfile: Boolean;
    { Private declarations }
    PageNo: Integer;
    nLen:Integer;
    TotalInstr:Integer;
    SelectedLine:Integer;
    SelPage: Integer;
    CurPC:Integer;
    procedure DoAftCompile(Sender: TObject; Fname: String);
    procedure DoBefCompile(Sender: TObject; Fname: String);
    procedure CalcDataVals;
    procedure CheckBreak(const pc: Word);
    procedure PaintBreakPoints;
    procedure AddRemoveBreakPoint(Addr: Integer);
    procedure ShowCompErrors;
    procedure SetSrcCurrentLine;
    procedure DoCompMes(Sender: TObject; msg: String);
    procedure ShowCompiledCode;
    procedure DoData(Pg, Addr, Leng:Integer);
    procedure SetPreComment(com: String);
    procedure SetComment(com: String);
    function GetDefaultName: String;
    procedure PaintInstructions;
    procedure Disassembly(PGn, Start, nLength: Integer);
    function GetCompleteInstruction(no: Integer): String;
    procedure LoadComments(CmnF: TFileName = ''; DestSl: TStringList=Nil);
    function LS: Integer;
    function PGETYFromLine(L: Integer): Integer;
    function PTextHeight: Integer;
    function PVisibleLines: Integer;
    procedure SaveComments(CmnF: TFileName = '');
    function SendChar(c: AnsiChar):boolean;
    procedure DoDisAsmPrintToFile;
    procedure checkModemStatus;
    function DsrReady: boolean;


  public
    procedure SetPC(PC: Integer);
    procedure AddBreakPoint(Addr: String); overload;
    procedure AddBreakPoint(Addr: Integer); overload;
    procedure RemoveBreakPoint(Addr: String); overload;
    procedure RemoveBreakPoint(Addr: Integer); overload;
    function IsProject: Boolean;
    { Public declarations }
  end;

  TBreakPointList=Class(TstringList);

Procedure   ShowDisassembler;

var
  frmdis: Tfrmdis = nil;
  Instructions:TInstrList;
  BreakPList:TBreakPointList;

implementation
uses unbMemory,ustrings,uDisAsm,math,Printers,uAsm,uNBTypes, New, frmCPUWin,
  frmOSWin,uAsmPrj, frmNewDebug;

{$R *.dfm}

Procedure   ShowDisassembler;
Begin
  if not assigned(frmdis) then
  begin
    frmdis:= Tfrmdis.create(nil);
    frmdis.Show;
  end;
end;


procedure Tfrmdis.ApdComPort1PortClose(Sender: TObject);
begin
 checkModemStatus;
end;

procedure Tfrmdis.checkModemStatus;
begin
if ApdComPort1.DTR then
  SHAPE1.Brush.Color:=clGreen
 else
  SHAPE1.Brush.Color:=clRed;
 if ApdComPort1.DSR then
  SHAPE2.Brush.Color:=clGreen
 else
  SHAPE2.Brush.Color:=clRed;
End;

procedure Tfrmdis.ApdComPort1PortOpen(Sender: TObject);
begin
 checkModemStatus

end;

procedure Tfrmdis.ApdComPort1TriggerAvail(CP: TObject; Count: Word);
VAR C:ansiCHAR;
    k:integer;
begin
  if button11.Tag=1 then exit;
  if count=0 then exit;
  try
   c:= ApdComPort1.PeekChar(1);
   k:=ord(c);
   listbox1.Items.Add(inttostr(k))
  except

  end;
end;

procedure Tfrmdis.ApdComPort1TriggerModemStatus(Sender: TObject);
begin
  checkModemStatus
end;

procedure Tfrmdis.ApdComPort1TriggerStatus(CP: TObject; TriggerHandle: Word);
begin
  checkModemStatus
end;

procedure Tfrmdis.ApdComPort1TriggerTimer(CP: TObject; TriggerHandle: Word);
begin
  checkModemStatus
end;

procedure Tfrmdis.asmTextKeyPress(Sender: TObject; var Key: Char);
begin
  SetSrcCurrentLine;
end;

procedure Tfrmdis.asmTextMouseMove(Sender: TObject; Shift: TShiftState; X, Y:
    Integer);
begin
  SetSrcCurrentLine;
end;

Procedure Tfrmdis.Disassembly(PGn,Start,nLength:Integer);
const
  aBit: array[1..4] of byte = ($80, $40, $20, $10);
Var Inst:Array[1..4] of byte;
    CurAddr:Integer;
    NewInstr:String;

   Procedure Fill4;
   Begin
      if pgn<0 then
      Begin
       Inst[1]:=nbmem.GetRom(CurAddr);
       Inst[2]:=nbmem.GetRom(CurAddr+1);
       Inst[3]:=nbmem.GetRom(CurAddr+2);
       Inst[4]:=nbmem.GetRom(CurAddr+3);
      End
      Else
      Begin
       Inst[1]:=nbmem.GetDirectMem(Pgn,CurAddr);
       Inst[2]:=nbmem.GetDirectMem(Pgn,CurAddr+1);
       Inst[3]:=nbmem.GetDirectMem(Pgn,CurAddr+2);
       Inst[4]:=nbmem.GetDirectMem(Pgn,CurAddr+3);
      End;
   End;

   Function GetCurrentInstr:Integer;//returns Inst Length
   Var lFound:Boolean;
       i,j,nIndex,npos:Integer;
       cAux:String;
   Begin

      //Find Instruction
      cAux := '';
      for i := 1 to MAX_Z80_INSTR do
      begin
        with aZ80Instr[i] do
        begin
          lFound := true;
          for j := 1 to nMask and $0F do
            if (nMask and aBit[j])<>0 then
            begin
              if Inst[j]<>aInstr[j-1] then lFound := false;
            end
            else
            begin
              cAux := IntToHex(Inst[j], 2)+cAux;  //New Byte Add
            end; //if end
          nIndex := i;
          if lFound then
          begin
            break;
          end;//if end

        end;//with end
      end;//for end

      //Return Full Instruction
       NewInstr:=aZ80Instr[nIndex].cInstr;

       nPos := Pos('##', NewInstr);   //Is there an address or number
       if nPos<>0 then
       begin
          NewInstr[nPos+0] := cAux[1];
          NewInstr[nPos+1] := cAux[2];
          Delete(cAux, 1, 2);

          nPos := Pos('##', NewInstr);
          if nPos<>0 then
          begin
            NewInstr[nPos+0] := cAux[1];
            NewInstr[nPos+1] := cAux[2];
          end;//if end
       end;//if end

       Result:=(aZ80Instr[nIndex].nMask and $0F);

   End; //Function End

Var nbt,i:Integer;

Begin

 CurAddr:=Start;
 TotalInstr:=1;
 Repeat
   //Get 4 bytes
   Fill4;
   nbt:=GetCurrentInstr;
   Instructions.New;
   Instructions.Instr[TotalInstr].Addr:=CurAddr;
   Instructions.Instr[TotalInstr].Nob:=nbt;
   for i := 1 to nbt  do
      Instructions.Instr[TotalInstr].Bytes[i]:=Inst[i];
   Instructions.Instr[TotalInstr].Instr:=NewInstr;
   CurAddr:=CurAddr+nbt;
   if (CurAddr-Start)>nLength then Break;
   if curaddr>65535 then Break;
   
   Inc(TotalInstr);
 until False;



end;

function Tfrmdis.GetCompleteInstruction(no:Integer):String;
Var i:Integer;
Begin
  //Addr
  Result:=InttoHex(Instructions[no].Addr,4)+' ';
  //Bytes
  for i := 1 to Instructions[no].Nob  do
    Result:=Result+inttohex(Instructions[no].Bytes[i],2)+' ';
  for i := Instructions[no].Nob to 5 do
    Result:=Result+'   ';
  //Characters
  for i := 1 to Instructions[no].Nob  do
    if Instructions[no].Bytes[i]>31 then
      Result:=Result+chr(Instructions[no].Bytes[i])
    Else
      Result:=Result+'.';
  for i := Instructions[no].Nob to 5 do
    Result:=Result+' ';
  // Labels
  Result:=Result+Instructions[no].CommentsPre;
  for i := Length(Instructions[no].CommentsPre) to 9 do
   Result:=Result+' ';
  //Instruction
  Result:=Result+' ';
  Result:=Result+Instructions[no].Instr;
  for i := Length(Instructions[no].Instr) to 20 do
    Result:=Result+' ';
  //Comments
  Result:=Result+'; ';
  Result:=Result+Instructions[no].Comments;
end;

procedure Tfrmdis.DoDisassembly;
Var stad,le:integer;
Begin
  if CommentsChanged then
    SaveComments;

  Instructions.Clear;TotalInstr:=0;
  if not GetValidInteger(edStAddr.text,stad) then
    GetValidInteger(edStAddr.text+'H',stad);
  if not GetValidInteger(edLines.text,le) then
    GetValidInteger(edLines.text+'H',le);
 // if SelPage=-1 then
//   le:=65535-stad
//  Else
//   le:=nbmem.GetPageLength(SelPage)-stad;

  Disassembly(SelPage,stad,le);
  Scrollbar1.SetParams(1,1,TotalInstr-PVisibleLines+5);
  LoadComments;
  pbShow.Repaint;
end;

procedure Tfrmdis.Edit1Change(Sender: TObject);
begin
 edit1.Hint:=inttohex(strtoint(edit1.Text),4)+'h';
end;

procedure Tfrmdis.DoDisAsmPrint;
Var i:Integer;
    MAxy,y,spc:Integer;
    lh:Integer;
    Header:String;
    TopMargin:Integer;
    TotalLines:Integer;

    Procedure SetBW;
    Begin
      printer.Canvas.Brush.Color:=clWhite;
      printer.Canvas.Font.Color:=clBlack;
    End;

    Procedure SetWB;
    Begin
       printer.Canvas.Brush.Color:=clBlack;
       printer.Canvas.Font.Color:=clWhite;
    End;
begin
  header:='ADDR   BYTES         ASCII    LABELS    ASM                   COMMENTS                                                  ';
  try
   MAxy:=strtoint(edit3.text);
  Except
   Maxy:=70;
  End;
  try
   spc:=strtoint(edit4.text);
  Except
   spc:=15;
  End;

  TopMargin:=40;
  y:=1;
  Printer.Canvas.Font.Name:='Courier New';
  lh:=Printer.canvas.TextHeight('oOoO');
  TotalLines:=(Printer.PageHeight-TopMargin) div (lh+spc);
  TotalLines:=TotalLines-1;

  MaxY:=Min(MAxY,  TotalLines);
  Edit3.Text:=inttostr(MaxY);
  Printer.Title:=unitname+' '+ DateTimeToStr(Now);
  Printer.BeginDoc;
  printer.Canvas.TextOut(40,TopMargin+y*(lh+spc),Printer.Title);
  inc(y);
  inc(y);
  If Pageno<>-1 then
  Begin
   printer.Canvas.TextOut(40,TopMargin+y*(lh+spc),'Page NO:'+inttostr(Pageno));
   inc(y);
  End
  Else
  Begin
   printer.Canvas.TextOut(40,TopMargin+y*(lh+spc),'Starting Address : $'+EdStAddr.text+'  ('+Inttostr(HexToInt(EdStAddr.text))+')');
   inc(y);
   printer.Canvas.TextOut(40,TopMargin+y*(lh+spc),'Length Instruct. : $'+InttoHex(TotalInstr,4)+'  ('+Inttostr(TotalInstr)+')');
   inc(y);
   printer.Canvas.TextOut(40,TopMargin+y*(lh+spc),'Length Bytes     : $'+InttoHex(Strtoint(edLines.text),4)+'  ('+edLines.Text+')');
   inc(y);
  End;
  inc(y);
  SetWB;
  printer.Canvas.TextOut(40,TopMargin+y*(lh+spc),Header);
  SetBW;
  inc(y);
  For i:=1 to TotalInstr do
  Begin
   printer.Canvas.TextOut(40,TopMargin+y*(lh+spc),{inttostr(Y)+'. '+}GetCompleteInstruction(i));
   if y>=maxy then
   Begin
    Printer.NewPage;
    y:=1;
    SetWB;
    printer.Canvas.TextOut(40,TopMargin+y*(lh+spc),Header);
    SetBW;
   End;
   inc(y);
  End;
  Printer.enddoc;
end;


procedure Tfrmdis.DoDisAsmPrintToFile;
Var i:Integer;
    y:Integer;
    Header:String;
    f:TextFile;
    fname:string;
begin
  header:='ADDR   BYTES         ASCII    LABELS    ASM                   COMMENTS                                                  ';
  fname:='DisAsmPrint.txt';
  assignFile(f,fname);
  if fileexists(fname) then
    ShowMessage('File '+fname+' will be rewritten.');
  Rewrite(f);
  WriteLn(f,DateTimeToStr(Now));
  WriteLn(f,'');
  WriteLn(f,'Starting Address : $'+EdStAddr.text+'  ('+Inttostr(HexToInt(EdStAddr.text))+')');
  WriteLn(f,'Length Instruct. : $'+InttoHex(TotalInstr,4)+'  ('+Inttostr(TotalInstr)+')');
  WriteLn(f,'Length Bytes     : $'+InttoHex(Strtoint(edLines.text),4)+'  ('+edLines.Text+')');
  WriteLn(f,'');
  WriteLn(f,Header);
  WriteLn(f,'');
  y:=1;
  For i:=1 to TotalInstr do
  Begin
   WriteLn(f,GetCompleteInstruction(i));
   if y>=40 then
   Begin
    y:=0;
    WriteLn(f,'');
    WriteLn(f,'');
    WriteLn(f,Header);
    WriteLn(f,'');
   End;
   inc(y);
  End;
  Closefile(f);
end;

procedure Tfrmdis.DoData(Pg,Addr,Leng:Integer);
Begin
  DatPage:=Pg;
  DatAddr:=Addr;
  if SelPage=-1 then
   DatLen:=65535-Addr
  Else
   DatLen:=nbmem.GetPageLength(SelPage)-Addr;
end;

procedure Tfrmdis.DoDisasmData;
Var stad,le:Integer;
begin
  if not getValidInteger(edStAddr.text,stad) then
   getValidInteger(edStAddr.text+'H',stad);
  if not getValidInteger(edLines.text,le)then
   getValidInteger(edLines.text+'H',le);
  DoData(SelPage,stad,le);
  if DatLen<=0 then
   begin
    showmessage('Error in offset please retry');
    exit;
   end;
  try
    Scrollbar2.SetParams(1,1,DatLen);
  except
   Scrollbar2.SetParams(1,1,1000);
  end;
  pbData.Repaint;
end;

procedure Tfrmdis.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if CommentsChanged then
    SaveComments;
  fnewbrain.SaveFormPos(self);
  fCPUWin.Tag:=9;
  fCPUWin.Close;
  fCPUWin.free;
  fCPUWin:=nil;
  ApdComPort1.Open:=false;
  frmdis:=nil;
end;

procedure Tfrmdis.FormCreate(Sender: TObject);
Var i:integer;
begin
  AdTerminal1.ScrollbackRows:=2000;
  label9.Font.Color:=clBlue;
  PageNo:=-1;
  nLen := 0;
  DatPage:=-2;
  cbpages.items.Clear;
  cbpages.items.Add('-1_NoPaging');
  for i:=0 to 255 do
   if nbmem.NBPages[i]<>nil then
    cbpages.items.Add(Inttostr(nbmem.NBPages[i]^.Page)+'_'+nbmem.NBPages[i]^.Name);
  cbpages.ItemIndex:=0;
  cbPagesChange(nil);
  CommentsChanged:=False;
  DoubleBuffered:=true;
  PageControl1.DoubleBuffered:=true;
  PageControl2.DoubleBuffered:=true;
  panel2.DoubleBuffered:=True;
  panel3.DoubleBuffered:=True;
  PageControl1.ActivePage:=TSDis;
  PageControl2.ActivePage:=TSSource;
  PageControl2Change(nil);
  if not assigned(fCPUWin) then
    fCPUWin:= TfCPUWin.create(nil);
  fCPUWin.Show;
  fCPUWin.Dock(DockTabSet1,Rect(0,0,10,10));
  DockPanel.Width:=0;
  if not assigned(fOSWin) then
    fOSWin:= TfOSWin.create(nil);
  fOSWin.show;
  fOSWin.Dock(DockTabSet1,Rect(0,0,10,10));
   try
    ApdComPort1.Open:=true;
   except
      //may be same port opened by the emulator
   end;
   fNewbrain.LoadFormPos(self);
end;

procedure Tfrmdis.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if assigned(NewDebug) then
    NewDebug.FormKeyUp(Sender, key, shift);
end;

procedure Tfrmdis.FormMouseWheel(Sender: TObject; Shift: TShiftState;
    WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
Var mp:TPoint;
begin
 mp:=screentoclient(MousePos);
 if PageControl1.ActivePage=TSDis then
 Begin
  if MP.X<Panel3.Left then
  Begin
    if wheeldelta<0 then
      Scrollbar1.Position:=Scrollbar1.Position+1;
    if wheeldelta>0 then
      Scrollbar1.Position:=Scrollbar1.Position-1;
    pbShow.Repaint;
    Handled:=true;
  end
  Else
  Begin
   if wheeldelta<0 then
     Scrollbar2.Position:=Scrollbar2.Position+DatWid;
   if wheeldelta>0 then
     Scrollbar2.Position:=Scrollbar2.Position-DatWid;
   pbData.Repaint;
   Handled:=true;
  end;
 end;
end;

procedure Tfrmdis.FormShow(Sender: TObject);
begin
  SpeedButton7Click(nil);
  SpeedButton8Click(nil);
end;

Function Tfrmdis.GetDefaultName:String;
Begin
   Result:='';
   if SelPage<>-1 then
     Result:=Result+'PG_'+inttostr(SelPage)+'.dbg'
   Else
    Result:=Result+'NoPaging.dbg';
end;

procedure Tfrmdis.ListBox1DblClick(Sender: TObject);
begin
 listbox1.Clear;
end;

procedure Tfrmdis.SetPC(PC:Integer);
begin
  CurPC:=pc;
  if fnewbrain.Debugging then
   pbshow.Repaint;
end;

procedure Tfrmdis.LoadComments(CmnF: TFileName = ''; DestSl: TStringList=Nil);
Var cf:TStringList;
    i:Integer;
    s,s1:String;
Begin
   if CmnF='' then
      CmnF:=GetDefaultName ;

   if Not FileExists(AppPath+CmnF) and not assigned(DestSl) then
   Begin
     ShowMessage('Debug File '+AppPath+cmnf+' does not exists');
     Exit;
   end;

   cf:=TStringList.Create;
   try
     cf.LoadFromFile(AppPath+Cmnf);
     if Assigned(DestSl) then
       Destsl.Assign(cf)
     Else
     For i:=1 to TotalInstr do
     Begin
       s:=cf.Values[Inttostr(Instructions[i].Addr)];
       if s<>'' then
         Instructions[i].Comments:=s;
       s1:=cf.Values[Inttostr(Instructions[i].Addr)+'_LB'];
       if s1<>'' then
         Instructions[i].CommentsPre:=s1;
     end;
   finally
     cf.free;
   end;
   if not assigned(Destsl) then
     pbshow.Refresh;
end;

procedure Tfrmdis.PaintInstructions;
Const BackColor:TColor=clBlack;
      FontColor:TColor=clWhite;
      SelectColor:TColor=clMaroon;
      CurPCColor:TColor=clGreen;
      RTNColor:TColor=clAqua;
Var i,j:Integer;
    s:String;
    th:Integer;
    TLn:Integer;
    PS:Integer;
    X,Y:Integer;
    Canv:TCanvas;
    OldColor:integer;


    Procedure SetStyle(no:Byte);
    Begin
     pbShow.Canvas.Font.Style := [fsBold];
     pbShow.Canvas.Font.Color:=RTNColor;
    End;

    Procedure ResetStyle;
    Begin
      with pbShow.Canvas do begin
        Brush.Style := BSSOLID;
        Brush.Color := FontColor;

        Font.Name := 'COURIER NEW';
        Font.Style := [];
        Font.Size := 8;
        Font.Color:= clWhite;

        Brush.Style := BSCLEAR;
        Brush.Color := oldcolor;
      End;
    End;


Var st,header:String;
Begin
  for i := 0 to 200 do
    st:=st+' ';


  header:='BP   ADDR   BYTES        ASCII  LABELS    ASM              COMMENTS                                                  ';
  OldColor:=BackColor;
  ResetStyle;
  Canv:=pbShow.Canvas;
  Canv.FillRect(pbShow.ClientRect);


  th:=  pTextHeight;
  TLn:=PVisibleLines;
  PS:=Scrollbar1.Position;  //According to Scrollbar

  TLn:=Min(TLn,TotalInstr-PS);

  Canv.Brush.Color := clGreen;
  Canv.Font.color:= clYellow;
  Canv.Font.Style:=[fsBold];
  Canv.TextOut(0,0,header);

  ResetStyle;
  for i := PS to PS+TLn do
  Begin

    if SelectedLine=i then
      Canv.Brush.Color := SelectColor
    Else
     if Instructions[i].Addr=CurPC then
      Canv.Brush.Color := CurPCColor
     Else
      Canv.Brush.Color := BackColor;//CLWHITE;

    OldColor:=Canv.Brush.Color;

   // Y:=LS+(i-PS)*(th+cLnSpace);

    y:=PGETYFromLine(i);
    Canv.TextOut(0,Y,st);

    //paint PC
    if Instructions[i].Addr=CurPC then
    begin
      X:=20;
      canv.Brush.Style := BSSOLID;
      Canv.TextOut(X,Y,'»');
      Brush.Style := BSCLEAR;
    end;

    X:=30;
//    s:=GetCompleteInstruction(i);
    s:=InttoHex(Instructions[i].Addr,4);
    Canv.TextOut(X,Y,s);

    X:=X+50;
    s:='';
    for j := 1 to Instructions[i].Nob  do
      s:=s+inttohex(Instructions[i].Bytes[j],2)+' ';
    Canv.TextOut(X,Y,s);

    X:=X+90;
    s:='';
    for j := 1 to Instructions[i].Nob  do
      if Instructions[i].Bytes[j]>31 then
        s:=s+chr(Instructions[i].Bytes[j])
      Else
        s:=s+'.';
    Canv.TextOut(X,Y,s);

    X:=X+40;
    s:=Instructions[i].CommentsPre;
    if pos(':',s)>0 then
      SetStyle(1);
    Canv.TextOut(X,Y,s);

    ResetStyle;

    X:=X+70;
    s:=Instructions[i].Instr;
    Canv.TextOut(X,Y,s);

    X:=X+100;
    s:='; '+Instructions[i].Comments;
    Canv.TextOut(X,Y,s);
  end;
end;

procedure Tfrmdis.PbDataMouseDown(Sender: TObject; Button: TMouseButton; Shift:
    TShiftState; X, Y: Integer);
begin
  ChrX:=X;ChrY:=Y;
  pbData.Refresh;
end;

procedure Tfrmdis.CalcDataVals;
Var th,tw:Integer;
    Canv:TCanvas;

Begin
 Canv:=pbData.canvas;
 Canv.Font.Name:='Courier';
 Canv.Font.Height:=10;
 th:=  Canv.TextHeight('HWQ');
 tw:=  Canv.TextWidth('W');
 DataVisLines:=pbData.Height div th;
 DataWidthBytes:=pbData.Width div tw - 2;
 DataLineBytes:=DataWidthBytes Div 3;   //3 chars per byte
 try
   Scrollbar2.Max:=Round(DatLen /  DataLineBytes) - Round(DataVisLines / 2)+2;
 except
  Scrollbar2.Max:=1000;
 end;
end;

procedure Tfrmdis.PbDataPaint(Sender: TObject);
Var th,tw:Integer;
    Canv:TCanvas;
    i,j:Integer;
    b:Byte;
    bs,bchrs:AnsiString;
    Bytes: TBytes;
    MyAddr:Integer;
    LnVisDat:Integer;
    LnChrSt:Integer;
    Selected:Integer;
begin
 if DatPage=-2 then
   Exit;
   SetLength(Bytes, 0);
 Canv:=pbData.canvas;
 CalcDataVals;
 Canv.Font.Color:=clLime;
 Canv.Brush.Color:=clBlack;
 canv.font.Pitch:=TFontPitch.fpFixed;
 pbData.Color:=clBlack;


 th:=  Canv.TextHeight('HWQ');
 tw:=  Canv.TextWidth('W');
 DataTopMargin:=1;

 LnVisDat:=(DataVisLines - DataTopMargin) div 2;
 LnChrSt:= LnVisDat * (th);
 //MyAddr:=DatAddr+ScrollBar2.Position-1;
 MyAddr:=DatAddr+(ScrollBar2.Position-1)*DataLineBytes;
 DatWid:= 3;  // for scrollbar2     Scroll 3 lines
 Selected:=ChrY Div th-DataTopMargin;
 if Selected>=LnVisDat then
  Selected:=Selected-LnVisDat;
 bs:='ADDR 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F';
 bs:=Copy(bs,1,5+DataLineBytes*3);
 Canv.Brush.Color := clGreen;
 Canv.Font.color:= clYellow;
 Canv.TextOut(2,0,bs);
 Canv.Brush.Color := clWhite;
 for j := 0 to LnVisDat - 1 do
 Begin
  bs:=inttohex(MyAddr,4)+' ';bchrs:=AnsiString(inttohex(MyAddr,4)+' ');
  for i := 0 to DataLineBytes - 1 do
  Begin
     if DatPage=-1 then
        b:=NbMem.GetRom(MyAddr)
     Else
        b:=NBMem.GetDirectMem(DatPage,MyAddr);
     bs:=bs+InttoHex(b,2)+' ';
     if (b>=32) and  not ( b in [152,$81,$8c,$88,$8a,$8d,$8e,$8f,$90,$9a,$9c,$9d,$9e,$9f,$d2]) then
       bchrs:=bchrs+AnsiChar(b)+AnsiChar(32)+AnsiChar(32)
     Else
       bchrs:=bchrs+AnsiChar(32)+AnsiChar(32)+AnsiChar(32);
     MyAddr:=MyAddr+1;
     if myaddr>$FFFF then
      Break;
  end; //End i

  if J=Selected then
    Canv.Brush.Color:=clRed
  Else
    Canv.Brush.Color:=clBlack;
  Canv.Font.Color:=clAqua;
  Canv.TextOut(2,(DataTopMargin+j)*th,bs);
  Canv.Font.Color:=clLime;
  Canv.TextOut(2,LnChrSt+(DataTopMargin+j)*th,bchrs);     //
 end;// End j
end;

procedure Tfrmdis.SetComment(com:String);
Begin
   Instructions[SelectedLine].Comments:=Com;
   CommentsChanged:=True;
end;

procedure Tfrmdis.SetPreComment(com:String);
Begin
   Instructions[SelectedLine].CommentsPre:=Com;
   CommentsChanged:=True;
end;

procedure Tfrmdis.CheckBreak(Const pc:Word);
Begin
 if fnewbrain.debugging then exit;
 if not visible then exit;
 if BreakPList.Count=0 then exit;
 If (BreakPList.indexof(inttohex(pc,4))>-1) and (not fnewbrain.debugging) then
 Begin
  fnewbrain.debugging:=true;
  ods('BreakPoint Reached at PC :'+inttostr(pc)+' '+inttohex(PC,4));
 End;
end;


procedure Tfrmdis.AddRemoveBreakPoint(Addr:Integer);
Var k:Integer;
Begin
   k:=BreakPList.IndexOf(inttohex(addr,4));
   if k>=0 then //exists so remove it
   begin
     BreakPList.Delete(k);
     if assigned(NewDebug) and NewDebug.Visible then
       newdebug.RemoveBP(inttohex(addr,4),false); //don't send it back
   end
   else //doesnot exist so add ed
   begin
     BreakPList.Add(inttohex(addr,4));
     if assigned(NewDebug) and NewDebug.Visible then
       newdebug.AddBP(inttohex(addr,4),false); //don't send it back
   end;
   pbshow.Repaint;
end;



procedure Tfrmdis.pbShowDblClick(Sender: TObject);
Var CurComment,CurLabel:String;
begin
  CurComment:=Instructions[SelectedLine].Comments;
  CurLabel:=Instructions[SelectedLine].CommentsPre;
  if (CX<50) then //breakpoint
  Begin
    //AddRemoveBreakPoint(Instructions[SelectedLine].Addr);
  end
  Else
  if (Cx<300) and (Cx>100) then
  Begin
    if InputQuery('New Label','Label',CurLabel) then
      SetPreComment(CurLabel)
  end
  Else
   if CX>300 then
    if InputQuery('New Comment','Comment Line',CurComment) then
      SetComment(CurComment);
  Repaint;
end;

procedure Tfrmdis.pbShowMouseDown(Sender: TObject; Button: TMouseButton; Shift:
    TShiftState; X, Y: Integer);
Var th:Integer;
begin
  cx:=x;cy:=y;
  th:=  pbShow.Canvas.TextHeight('HHH');

  SelectedLine:=(y-15) Div (th+cLnSpace)+Scrollbar1.Position;
  pbShow.Repaint;
end;

procedure Tfrmdis.PaintBreakPoints;
Var i:Integer;
    ad,TLn:Integer;
    PS,PSEnd:integer;
    x,y:integer;
    BPLine:Integer;
    OldColor,oldback:Integer;

Begin
   OldColor:=pbshow.Canvas.Pen.Color;
   oldback:=pbshow.Canvas.Brush.Color;
   TLn:=Min(PVisibleLines,TotalInstr-PS);
   PS:=Scrollbar1.Position;
   PSend:=PS+TLn;
   for i := 0 to BreakPList.Count - 1 do
   Begin
      ad:=HexToInt(BreakPList[i]);
      BPLine:=Instructions.GetInstrIdxFromAddr(ad)+1;
      if (BPLine>=PS) And (BPLine<=PSEnd) then
      Begin //it is visible;
         //CaLc Y Pos
         Y:=PGETYFromLine(BPLine);
         pbshow.Canvas.Pen.Color:=clRed;
         if ad=Curpc then
          pbshow.Canvas.Brush.Color:=clRed
         else
           pbshow.Canvas.Brush.Color:=oldback;
         pbshow.Canvas.Ellipse(2,y,15,y+13);
      end;
   end;
   pbshow.Canvas.Pen.Color:=OldColor;
   pbshow.Canvas.Brush.Color:=oldback;
end;

procedure Tfrmdis.pbShowPaint(Sender: TObject);
begin
  if TotalInstr>5 then
  Begin
    PaintInstructions;
    PaintBreakPoints;
  end;
end;

procedure Tfrmdis.SaveComments(CmnF: TFileName = '');
Var cf:TStringList;
    i:Integer;
Begin
   if CmnF='' then
      CmnF:=GetDefaultName;

  { if FileExists(CmnF) and CommentsChanged then
     If MessageDlg('Overwrite?',mtConfirmation ,[mbYes,mbNo], 0,mbYes)=mrNo then
      Exit;}

   cf:=TStringList.Create;
   LoadComments(CmnF,cf);  //Load All Comments
   For i:=1 to TotalInstr do
   Begin
     cf.Values[Inttostr(Instructions[i].Addr)]:=Instructions[i].Comments;
     if Instructions[i].CommentsPre<>'' then
      cf.Values[Inttostr(Instructions[i].Addr)+'_LB']:=Instructions[i].CommentsPre;
   end;

   try
     cf.SaveToFile(Cmnf);
   finally
     cf.free;
   end;



end;

procedure Tfrmdis.ScrollBar1Change(Sender: TObject);
begin
   pbShow.Repaint;
end;

procedure Tfrmdis.ScrollBar2Change(Sender: TObject);
begin
 pbData.Repaint;
end;

//Create Patch File to be used with the rom burner
procedure Tfrmdis.SpeedButton10Click(Sender: TObject);
Var sts,ses:String;
    st,se:Integer;
    sf:TFileStream;
    b,i:Integer;
    F:TextFile;

    j:Integer;
    p:PCmpInst;
    addr:Integer;
    RomWriteable:Boolean;
    TotBytes:Integer;
    FileByte:Integer;
    sl:tstringlist;
begin
 if not Assigned(Compiler) then Exit;
 //Put Compiled Object in a Patch File
 if Compiler.ERRORSFOUND then
 Begin
   ShowMessage('Errors were found!!');
   Exit;
 end;
 fnewbrain.Suspendemul;
 try
  sl:=tstringlist.create;
 TotBytes:=0;
 FileByte:=0;
 for i := 0 to Compiler.Count-1 do
 Begin
   p:=Compiler.Items[i];
   addr:=p.Addr;
   for j:=1 to p.ByteCnt do
   Begin
      b:=p.bytes[j];
      sl.values[tohex(addr+j-1,4)]:=tohex(b,2);
      inc(TotBytes);  //Only compiled data
   end;
  end;
   sl.SaveToFile('PATCH.txt');
 finally
   sl.Free;
   fnewbrain.ResumeEmul;
 end;
 Showmessage('PATCH FILE CREATED!!!');
end;

procedure Tfrmdis.SpeedButton11Click(Sender: TObject);
begin
 DoDisAsmPrintToFile;
end;

//Load Assembly File
procedure Tfrmdis.SpeedButton1Click(Sender: TObject);
var f1,f2:string;
begin
 if pagecontrol2.ActivePageIndex<>0 then
 Begin
  OpenTextFileDialog1.InitialDir:=AppPath+DefaultAsmDir;
  if OpenTextFileDialog1.Execute then
  Begin
   asmText.Lines.LoadFromFile(OpenTextFileDialog1.FileName);
   ProjText.Lines.clear;
   SaveTextFileDialog1.FileName:=OpenTextFileDialog1.FileName;
   SaveBinFileDialog.FileName:=changefileext(OpenTextFileDialog1.FileName,'.bin');
  end;
  PageControl2.ActivePage:= TSSource
 end
 else
 Begin //load project
  f1:=OpenTextFileDialog1.filter;
  f2:=OpenTextFileDialog1.title;
  OpenTextFileDialog1.filter:='*.PRJ|*.prj';
  OpenTextFileDialog1.InitialDir:=AppPath+DefaultAsmDir;
  if OpenTextFileDialog1.Execute then
   ProjText.Lines.LoadFromFile(OpenTextFileDialog1.FileName);
  OpenTextFileDialog1.filter:=f1;
  OpenTextFileDialog1.title:=f2;

 end;
 statusbar1.panels[2].text:=SaveTextFileDialog1.FileName;
end;

//Save Assembly File
procedure Tfrmdis.SpeedButton2Click(Sender: TObject);
var f1,f2:string;
begin
 if pagecontrol2.ActivePageIndex<>0 then
 Begin
  SaveTextFileDialog1.InitialDir:=AppPath+DefaultAsmDir;
  if (SaveTextFileDialog1.FileName<>'') or SaveTextFileDialog1.Execute then
   asmText.Lines.SaveToFile(SaveTextFileDialog1.FileName);
 end
 else
 Begin //load project
  f1:=SaveTextFileDialog1.filter;
  f2:=SaveTextFileDialog1.title;
  SaveTextFileDialog1.filter:='*.PRJ|*.prj';
  SaveTextFileDialog1.InitialDir:=AppPath+DefaultAsmDir;
  if SaveTextFileDialog1.Execute then
   ProjText.Lines.SaveToFile(SaveTextFileDialog1.FileName);
  SaveTextFileDialog1.filter:=f1;
  SaveTextFileDialog1.title:=f2;
 end;
end;

//Compile Source Code
procedure Tfrmdis.SpeedButton3Click(Sender: TObject);
Var i:integer;
    errs:String;
begin
Errors:=0;
if not isproject then
Begin
 memMessages.Lines.Clear;
 memErrors.Lines.Clear;
 PageControl2.ActivePage:= TSMessages;
 if assigned(Compiler) then
   try
    Compiler.Free;
   except
   end;
 Compiler:=TCompiledList.create;
// Compiler.Compile(asmtext.Text);
// ShowCompiledCode;
 Compiler.OnCompileMessage:= DoCompMes;
 Compiler.MakeAbsolute(0); //needed to init dollar label
 Compiler.Compile2(asmtext.Text);
 memLabels.Text:=asmLabels.Text;
 GlobLabels.Text:=GlobalLabels.Text;
 ShowCompiledCode;
 Errors:=Compiler.Errors;
 if Errors>0 then
   PageControl2.ActivePage:= TSErrors
 Else
  PageControl2.ActivePage:= TSBinary;
 PageControl2Change(nil);


 lblcombo.Items.Clear;
 for I := 0 to asmlabels.Count - 1 do
  lblcombo.Items.Add(asmLabels.Names[i]);
 ShowCompErrors;
end
else
Begin
 memMessages.Lines.Clear;
 memErrors.Lines.Clear;
 ProjectLinker.OnBeforeCompile:=DoBefCompile;
 ProjectLinker.OnAfterCompile:=DoAftCompile;
 ProjectLinker.DoLink(projtext.Lines.CommaText,ExtractFilePath(OpenTextFileDialog1.FileName));
 GlobLabels.Text:=GlobalLabels.Text;
 errs:=ProjectLinker.GetLinkResult;
 MemErrors.Lines.Add('');
 MemErrors.Lines.Add('');
 MemErrors.Lines.Add('--------------------------');
 MemErrors.Lines.Add('PASS 3 WARNINGS - LINKING');
 MemErrors.Lines.Add('--------------------------');
 MemErrors.Lines.Add('');
 MemErrors.Lines.CommaText:=MemErrors.Lines.CommaText+ProjectLinker.GetLinkResult;
 Errors:=Compiler.Errors;

 if Errors=0 then 
   Statusbar1.Panels[2].Text:='Project Link Has Ended !!! '
  Else
   Statusbar1.Panels[2].Text:='ERRORS DETECTED !!! ';
 ShowCompiledCode;

 if Errors>0 then
   PageControl2.ActivePage:= TSErrors
 Else
  PageControl2.ActivePage:= TSBinary;
 PageControl2Change(nil);

 lblcombo.Items.Clear;
 for I := 0 to Globallabels.Count - 1 do
  lblcombo.Items.Add(Globallabels.Names[i]);


end;


End;

procedure Tfrmdis.DoBefCompile(Sender:TObject;Fname:String);
Begin
   Statusbar1.Panels[2].Text:='Now Compiling file '+Fname;
   Statusbar1.Repaint;
   Application.ProcessMessages;
   PageControl2.ActivePage:= TSMessages;
   curfile:=fname;
   fisnewfile:=true;
   TAsmFile(Sender).Compiler.OnCompileMessage:=DoCompMes;
//   TAsmFile(Sender).Compiler.OnCompileProgress

end;

procedure Tfrmdis.DoAftCompile(Sender:TObject;Fname:String);
Begin
 Errors:=Errors+TAsmFile(Sender).Compiler.Errors;

end;


procedure Tfrmdis.ShowCompErrors;
Begin
 StatusBar1.Panels[3].Text:='ERRORS:'+inttostr(Errors);

end;

Type Tmemohack=Class(TMemo);

procedure Tfrmdis.BinTextKeyDown(Sender: TObject; var Key: Word; Shift:
    TShiftState);
begin
SetSrcCurrentLine;
end;

//Abort sending
procedure Tfrmdis.Button10Click(Sender: TObject);
begin
 button10.Tag:=1;
end;

//Test Serial Communication with NB Laptop
procedure Tfrmdis.Button11Click(Sender: TObject);
var
  I: Integer;
  c:ansichar;
  errors:integer;
    S:TSTRINGLIST;
begin
  listbox1.Clear;
   button11.Tag:=1;
   adterminal1.Active:=false;
   errors:=0;
  SendChar('Y');
    S:=TSTRINGLIST.Create;

  for I := 0 to 255 do
  Begin
   SendChar(ansichar(ord(i)));
   if i<255 then
   Begin
     while not apdcomport1.CharReady do
     Begin
      application.ProcessMessages;
      sleep(2);
     End;
    try
     c:=apdcomport1.GetChar;
     if i<>ord(c) then begin
       inc(errors);
       s.Values[inttostr(i)]:=inttostr(ord(c));
     end;

     listbox1.items.Add(inttostr(ord(c)));
    except

    end;
   End;
  end;
  listbox1.Items.Add('Errors:'+inttostr(errors));
  button11.Tag:=0;
  adterminal1.Active:=true;
  s.SaveToFile('Xmiterrors.txt');
  s.Free;
end;

//Test Serial Communication with NB Laptop
procedure Tfrmdis.Button12Click(Sender: TObject);
var
  I: Integer;
  c:ansichar;
  errors:integer;
    S:TSTRINGLIST;
begin
  listbox1.Clear;
   button12.Tag:=1;
   adterminal1.Active:=false;
   errors:=0;
   SendChar('H');
    S:=TSTRINGLIST.Create;

  for I := 255 downto 0 do
  Begin

   if i>0 then
   Begin
     while not apdcomport1.CharReady do
     Begin
      application.ProcessMessages;
      sleep(2);
     End;
    try
     c:=apdcomport1.GetChar;
     if i<>ord(c) then begin
       inc(errors);
       s.Values[inttostr(i)]:=inttostr(ord(c));
     end;

     listbox1.items.Add(inttostr(ord(c)));
    except

    end;
   End;
  end;
  listbox1.Items.Add('Errors:'+inttostr(errors));
  button12.Tag:=0;
  adterminal1.Active:=true;
  s.SaveToFile('Recverrors.txt');
  s.Free;
end;

//Get Data from NB Laptop Memory to a file
procedure Tfrmdis.Button13Click(Sender: TObject);
VAR HL,BC:INTEGER;
    H,L,B,C:Byte;
    s:tstringlist;
    i:integer;
    q:ansichar;
begin
  adterminal1.Active:=false;
  BUTTON11.Tag:=1;
  HL:=strtoint(edit6.Text);
  BC:=strtoint(edit7.Text);
  H:=HL DIV 256;
  L:=HL-(H*256);
  B:=BC DIV 256;
  C:=BC-(H*256);
  s:=tstringlist.Create;
  if BC>0 then
  Begin
   SendChar('J');
   Sleep(5);
   SendChar(ANSICHAR(L));
   Sleep(5);
   SendChar(ANSICHAR(H));
   Sleep(5);
   SendChar(ANSICHAR(C));
   Sleep(5);
   SendChar(ANSICHAR(B));
   Sleep(5);
    for i := 0 to BC-1 do
    Begin
     while not apdcomport1.CharReady do
     Begin
      application.ProcessMessages;
      sleep(2);
     End;
     try
      q:=apdcomport1.GetChar;
     except

     end;
     s.Values[inttostr(HL+i)]:=inttostr(ord(q));
    End;
  End;
  s.SaveToFile('NBLapMemDump.txt');
  s.Free;
   adterminal1.Active:=true;
   BUTTON11.Tag:=0;
end;

procedure Tfrmdis.Button14Click(Sender: TObject);
begin
paintbox1.Refresh;
end;

//Send a Program through RS232 to NBLaptop
procedure Tfrmdis.Button1Click(Sender: TObject);
Var HL,BC:Integer;
    H,L,B,C:Byte;
    i:Integer;
    o:AnsiChar;
    siz:integer;

    j:Integer;
    p:PCmpInst;
    addr:Integer;
    RomWriteable:Boolean;
    TotBytes:Integer;
    FileByte:Integer;
    sf:TMemoryStream;

begin

 if not Assigned(Compiler) then Exit;

 //Put Compiled Object in a File
 if Compiler.ERRORSFOUND then
 Begin
   ShowMessage('Errors were found!!');
   Exit;
 end;
 fnewbrain.Suspendemul;
 try

  sf:=TMemoryStream.create;
 TotBytes:=0;
 FileByte:=0;

 for i := 0 to Compiler.Count-1 do
 Begin

   p:=Compiler.Items[i];
   if sametext(p.Instruct,'DEFS') or sametext(p.Instruct,'DS')
        then continue;   //do not write DEFS OR DS

   addr:=p.Addr;

 {  if checkbox1.checked and (sf.Position<p.Addr) then
    begin
     sf.Size:=p.addr;
     if sf.position<>(p.addr) then
      sf.Seek(p.addr,soFromBeginning);
    end;}

    for j:=1 to p.ByteCnt do
    Begin
       b:=p.bytes[j];
       sf.Write(b,1);
       Inc(FileByte);  //All data written
       inc(TotBytes);  //Only compiled data
    end;
 End;
 b:=0;
 sf.Write(b,1);sf.Write(b,1);sf.Write(b,1);sf.Write(b,1);
 sf.Position:=0;


   //sent data to rs232
   label9.Font.Color:=clBlue;

  HL:=strtoint(edit1.Text);
  siz:=sf.Size-1;

  BC:=siz;
  H:=HL DIV 256;
  L:=HL-(H*256);
  B:=BC DIV 256;
  C:=BC-(H*256);
  progressbar1.Min:=0;
  progressbar1.Max:=BC;
  progressbar1.Position:=0;
  if BC>0 then
  Begin
   SendChar('U');
   Sleep(500);
   SendChar(ANSICHAR(L));
   Sleep(5);
   SendChar(ANSICHAR(H));
   Sleep(5);
   SendChar(ANSICHAR(C));
   Sleep(5);
   SendChar(ANSICHAR(B));
   Sleep(5);
    for i := 0 to siz do
    Begin
       sf.Read(o,1);
       if not SendChar(o) then break;
       if CheckBox1.Checked then
         progressbar1.Position:=sf.Position-HL
       else
         progressbar1.Position:=sf.Position;
       label9.Caption:=inttostr(progressbar1.Position)+'/'+inttostr(siz);
       Application.ProcessMessages;
       if application.Terminated then
        break;
    End;

  End;
  progressbar1.Position:=0;
  Finally
      sf.Free;
  end;
end;

//Execute the program previously sent to NB Laptop
procedure Tfrmdis.Button2Click(Sender: TObject);
begin
 ApdComPort1.PutChar('X');
end;

//Send a single byte to the specified address on NB Laptop
procedure Tfrmdis.Button3Click(Sender: TObject);
var HL,BC:Integer;
    H,L,B,C:Byte;
    o:AnsiChar;
begin
  o:=AnsiChar(strtoint(edit2.Text));
  HL:=strtoint(edit1.Text);
  BC:=1;
  H:=HL DIV 256;
  L:=HL-(H*256);
  B:=BC DIV 256;
  C:=BC-(H*256);

  SendChar('U');
  SendChar(ANSICHAR(L));
  SendChar(ANSICHAR(H));
  SendChar(ANSICHAR(C));
  SendChar(ANSICHAR(B));
  SendChar(o);
end;

//Send the chars on edit box to NB Laptop
procedure Tfrmdis.Button4Click(Sender: TObject);
VAR O:ANSICHAR;
    i:integer;
    s:String;
begin
try
   apdcomport1.Open:=true;
 except

 end;
  s:=edit5.Text;

  for i:=1  to length(s) do
  Begin
    o:=AnsiChar(s[i]);
    if not  SendChar(o) then break;
    Label12.Caption:=inttostr(i)+'/'+inttostr(length(s));
    Label12.Repaint;
    //sleep(trackbar1.Position*10);
  End;
  if checkbox2.Checked then
   SendChar(#13);

end;

function Tfrmdis.DsrReady:boolean;
Begin
    result:=true;
    if apdcomport1.HWFlowOptions=[] then exit;

    While not apdcomport1.DSR and (button10.tag=0) do
    Begin
      APPLICATION.ProcessMessages;
      sleep(5);
    End;
    result:=button10.tag=0;
    button10.tag:=0;
End;

//Send a Disk basic file through RS232
procedure Tfrmdis.Button5Click(Sender: TObject);
var sf:TFileStream;
    c:Ansichar;
    nmd:boolean;
begin
 try
   apdcomport1.Open:=true;
 except
 end;
  if OpenTextFileDialog2.Execute then
  Begin
     sf:=TFileStream.create(OpenTextFileDialog2.FileName,fmOpenRead);
     label11.Caption:=inttostr(sf.Size);
     repeat
       nmd:=sf.Read(c,1)=0;
       if not nmd then
       Begin
        try
         SendChar(c);
        except
           break;
        end;
         sleep(trackbar1.Position*10);
         label10.Caption:=inttostr(sf.position);
         application.ProcessMessages;
       End;
     until nmd;
     sf.Free;
     showmessage('File Sent');
  End;
end;

//Stop transmitting
procedure Tfrmdis.Button6Click(Sender: TObject);
begin
try
 apdcomport1.Open:=false;
 application.ProcessMessages;
finally
end;
end;

//Set up Com Port
procedure Tfrmdis.Button7Click(Sender: TObject);
begin
  try
  ApdComPort1.Open:=false;
  ApdComPort1.ComNumber:=0;
  ApdComPort1.PromptForPort:=true;
  finally
   try
    ApdComPort1.Open:=true;
    cominfolabel.Caption:='COM Port '+inttostr(ApdComPort1.ComNumber)+' at 9600,N,8,1';
   except
     on e:exception do
      showmessage(e.Message);
   end;
  end;
end;

//Set hardware Flow control
procedure Tfrmdis.Button8Click(Sender: TObject);
begin
  ApdComPort1.Open:=false;
  ApdComPort1.HWFlowOptions:=[hwfUseDTR,hwfRequireDSR];
   try
    ApdComPort1.Open:=true;
    cominfolabel.Caption:='COM Port '+inttostr(ApdComPort1.ComNumber)+' at 9600,N,8,1 HW';
   except
     on e:exception do
      showmessage(e.Message);
   end;

end;

//remove hardware Flow control
procedure Tfrmdis.Button9Click(Sender: TObject);
begin
  ApdComPort1.Open:=false;
  ApdComPort1.HWFlowOptions:=[];
   try
    ApdComPort1.Open:=true;
    cominfolabel.Caption:='COM Port '+inttostr(ApdComPort1.ComNumber)+' at 9600,N,8,1 SW';
   except
     on e:exception do
      showmessage(e.Message);
   end;
end;

procedure Tfrmdis.cbPagesChange(Sender: TObject);
Var tx,s:String;
begin
  s:= cbPages.Text;
  GetFirstPart(s,tx,'_');
  SelPage:=Strtoint(tx);
  edPgLen.text:=inttostr(nbmem.GetPageLength(SelPage));
end;

procedure Tfrmdis.DockPanelDockDrop(Sender: TObject; Source: TDragDockObject;
    X, Y: Integer);
begin
 DockPanel.Width:=Source.Control.UndockWidth;
 if DockPanel.Width=0 then
   DockPanel.Width:=Source.Control.Constraints.MinWidth;
end;

procedure Tfrmdis.DockPanelUnDock(Sender: TObject; Client: TControl; NewTarget:
    TWinControl; var Allow: Boolean);
begin
 if DockPanel.ControlCount=1 then
    DockPanel.Width:=0;
  Allow:=true;
end;

procedure Tfrmdis.DockTabSet1DockOver(Sender: TObject; Source: TDragDockObject;
    X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept:= (Source.Control is TfCPUWin) or (Source.Control is TfOSWin);
end;

procedure Tfrmdis.DoCompMes(Sender:TObject;msg:String);
Var i:integer;
    IsInfoOnly:Boolean;
     p:PCmpInst;
Begin
 try
   if TCompiledList(Sender).Count=1 then
   Begin
     p:=TCompiledList(Sender).Items[TCompiledList(Sender).Count-1];
     edit1.text:=inttostr(p.addr);
     edit1.hint:=inttohex(p.Addr,4)+'h';
   End;

 except

 end;
   if Copy(msg,1,3)=#9#9#9 then
   Begin
      IsInfoOnly:=True;
      msg:=copy(msg,2,Length(msg));
   end;
   if IsProject then
   Begin
     if fisnewfile then
     Begin
       MemMessages.Lines.add(''); MemMessages.Lines.add(''); MemMessages.Lines.add('');
       MemMessages.Lines.add('-------------------------------------------');
       MemMessages.Lines.add('               '+CurFile+'                 ');
       MemMessages.Lines.add('-------------------------------------------');
       MemMessages.Lines.add('');
       fisnewfile:=false;
     end;
     if not IsInfoOnly then
       msg:=msg+'   ['+CurFile+']';
   end;
   MemMessages.Lines.add(msg);
   if Compiler.ISError then
    memErrors.Lines.add(msg);
 //  Tmemohack(MemMessages).SetCaretPos(Point(5,MemMessages.Lines.Count-1));
 //  Application.ProcessMessages;
   SetSrcCurrentLine;
   ShowCompErrors;
   Statusbar1.Refresh;
   //MemMessages.RePaint;
//   Application.ProcessMessages;
end;

function Tfrmdis.IsProject: Boolean;
begin
  Result := projtext.Lines.Count>1;
end;

procedure Tfrmdis.lblComboChange(Sender: TObject);
Var txt:String;
    k:Integer;
    w:word;
begin
  txt:=lblCombo.Text;
  if  Isproject then
   k:=GlobalLabels.GetLabel(txt)
  Else
   k:=asmLabels.GetLabel(txt);
  w:=Word(k);
  lblEdit.Text:=Inttostr(w)+' ('+Inttohex(w,4)+'h)';
end;

function Tfrmdis.LS: Integer;
begin
  //top and bottom margin for instructions
  Result :=   15;
end;

procedure Tfrmdis.PageControl2Change(Sender: TObject);
begin
   case PageControl2.tabIndex Of
     0:ActMem:=projText;
     1:ActMem:=asmText;
     2:ActMem:=BinText;
     3:ActMem:=memLabels;
     4:ActMem:=GlobLabels;
     5:ActMem:=memMessages;
     6:ActMem:=memErrors;
   end;
   SetSrcCurrentLine;
end;

procedure Tfrmdis.PaintBox1Paint(Sender: TObject);
var canv:TCanvas;
    px,py,psz:integer;
    x,y,nx,ny:integer;
    lspc,tspc,bspc:integer;
    myaddr,newaddr:integer;
    col,cidx:integer;
    bt:byte;
begin
   lspc:=5;tspc:=5;bspc:=2;
   psz:=4;
   paintbox1.Color:=clRed;
   canv:=paintbox1.Canvas;

   canv.Brush.Color:=clWhite;
   canv.FillRect(RECT(0,0,paintbox1.Width,paintbox1.Height));

   if not GetValidInteger(LabeledEdit1.text,myaddr) then
    GetValidInteger(LabeledEdit1.text+'H',myaddr);
   for y := 0 to SpinEdit2.Value-1 do
    for x := 0 to SpinEdit1.Value-1 do
    Begin
      newaddr:=myaddr+(x div 8)+y*(SpinEdit1.Value div 8);
      bt:=nbmem.rom[newaddr];
      cidx:=x mod 8; //0-7
      col:=trunc(power(2,7-cidx));
      if bt and col = col  then
      Begin
        //canv.Pen.Color:=clBlack;
        canv.Brush.Color:=clBlack;
      End
      else
      Begin
       // canv.Pen.Color:=clWhite;
        canv.Brush.Color:=clwhite;
      End;
      nx:=x*(psz+bspc);
      ny:=y*(psz+bspc);
      canv.Fillrect(RECT(lspc+nx,tspc+ny,lspc+nx+psz,tspc+ny+psz));
    End;
end;

procedure Tfrmdis.pbShowClick(Sender: TObject);
begin
  if (CX<15) then //breakpoint
  Begin
    AddRemoveBreakPoint(Instructions[SelectedLine].Addr);
  end;
end;


procedure Tfrmdis.AddBreakPoint(Addr:Integer);
var i:integer;
Begin

  BreakPList.Add(inttohex(addr,4));
  pbshow.Refresh;

End;

procedure Tfrmdis.AddBreakPoint(Addr:String);
Var v:Integer;
begin
  if GetValidInteger('$'+Addr,v) then
    AddBreakPoint(v);
End;


function Tfrmdis.PGETYFromLine(L: Integer): Integer;
begin
  Result := LS+(L-Scrollbar1.Position)*(PTextHeight+cLnSpace);
end;

function Tfrmdis.PTextHeight: Integer;
begin       //Disasm test height
  Result := pbShow.Canvas.TextHeight('HHH');
end;

function Tfrmdis.PVisibleLines: Integer;
begin    //visible instruction lines
  Result := (pbshow.Height-ls-ls) div (PTextHeight+cLnSpace);
end;

procedure Tfrmdis.RemoveBreakPoint(Addr: String);
var v:integer;
Begin
  if GetValidInteger('$'+Addr,v) then
    RemoveBreakPoint(v);
End;

procedure Tfrmdis.RemoveBreakPoint(Addr: Integer);
var i:integer;
begin
  i:=BreakPList.IndexOf(inttohex(addr,4));
  if i>=0 then
    BreakPList.Delete(i);
end;

procedure Tfrmdis.SetSrcCurrentLine;
Begin
//todo:Find the current line other way caretpos is a byte
  StatusBar1.Panels[1].Text:=Format('%5d / %5d',[ActMem.CaretPos.Y+1,ActMem.Lines.Count+1]);
end;

procedure Tfrmdis.ShowCompiledCode;
Begin
   bintext.text:=Compiler.getcompilationastext
end;

//Print to Default Windows Printer
procedure Tfrmdis.SpeedButton4Click(Sender: TObject);
Var f:textFile;
    i:Integer;
begin
 //Print Active Memo
 if ActMem<>nil then
Begin
  AssignPrn(F);
  Rewrite(F);
  WriteLn(f,'-----------------------------------------------------------');
  WriteLn(f,'      '+unitname);
  WriteLn(f,'              '+PageControl2.ActivePage.Caption);
  WriteLn(f,'-----------------------------------------------------------');
  WriteLn(f,'');
  for i := 0 to ActMem.Lines.Count - 1 do
   WriteLn(f,Actmem.Lines[i]);
  CloseFile(f);
 end;
end;

//put object code to memory
procedure Tfrmdis.SpeedButton5Click(Sender: TObject);
Var i,j:Integer;
    p:PCmpInst;
    addr:Integer;
    RomWriteable:Boolean;
    TotBytes:Integer;
begin
 //Put Compiled Object in memory;
 if not Assigned(Compiler) then Exit;
 if Compiler.ERRORSFOUND then
 Begin
   ShowMessage('Errors were found!!');
   Exit;
 end;
 //What About Rom ??
 RomWriteable:=true;
 fnewbrain.Suspendemul;
 try
 TotBytes:=0;
 for i := 0 to Compiler.Count-1 do
 Begin

   p:=Compiler.Items[i];
   addr:=p.Addr;
   if addr<$300 then continue;

   if (addr>=$A000) And (not RomWriteable) then continue;
    for j:=1 to p.ByteCnt do
    Begin
       nbmem.Rom[addr]:=p.bytes[j];
       addr:=addr+1;
       inc(TotBytes);
    end;

 end;
 Showmessage(inttostr(totbytes)+' bytes put in memory!!!');
 finally
   fnewbrain.ResumeEmul;
 end;
end;

//put object code to file
procedure Tfrmdis.SpeedButton6Click(Sender: TObject);
Var sts,ses:String;
    st,se:Integer;
    sf:TFileStream;
    b,i:Integer;
    F:TextFile;
    j:Integer;
    p:PCmpInst;
    addr:Integer;
    RomWriteable:Boolean;
    TotBytes:Integer;
    FileByte:Integer;
    sl:tstringlist;
    si:integer;
    dataline:integer;
    line:string;
    staddr:integer;

    procedure makeloader(adr,tot:integer);
    Begin
      sl.Insert(0,'10 Reserve top-'+inttostr(adr));
      sl.Insert(1,'20 For i=0 to '+inttostr(tot-1));
      sl.Insert(2,'30 Read a:poke '+inttostr(adr)+'+i,a');
      sl.Insert(3,'40 next i');
      sl.Insert(4,'50 ?"type CALL TOP to run your code."');
      sl.Insert(5,'100 END');
    End;

begin
 if not Assigned(Compiler) then Exit;
 //Put Compiled Object in a File
 if Compiler.ERRORSFOUND then
 Begin
   ShowMessage('Errors were found!!');
   Exit;
 end;
 if (SaveBinFileDialog.FileName<>'') or  SaveBinFileDialog.Execute then
 Begin
 fnewbrain.Suspendemul;
 try
  sf:=TFileStream.Create(SaveBinFileDialog.FileName,fmCreate);
  sl:=tstringlist.create;
 TotBytes:=0;
 FileByte:=0;
 dataline:=10000;
 line:=inttostr(dataline)+' DATA ';
 si:=0;
 for i := 0 to Compiler.Count-1 do
 Begin
   p:=Compiler.Items[i];
   addr:=p.Addr;
   if i=0 then staddr:=addr;
    if checkbox1.checked and (sf.Position<p.Addr) then
    begin
     sf.Size:=p.addr;
     if sf.position<>(p.addr) then
      sf.Seek(p.addr,soFromBeginning);
    end;
    for j:=1 to p.ByteCnt do
    Begin
       b:=p.bytes[j];
       sf.Write(b,1);
       Inc(FileByte);  //All data written
       inc(TotBytes);  //Only compiled data
       line:=line+inttostr(b);
       inc(si);if si>9 then Begin si:=0;inc(dataline,10);end
        else begin line:=line+',';end;
       if si=0 then
       Begin
            sl.Add(line);
            line:=inttostr(dataline)+' DATA ';
       End;
    end;
 end; //end save bytes
  makeloader(staddr,totbytes);
  sl.SaveToFile(ChangeFileEXt(SaveBinFileDialog.FileName,'.txt'));
    //Save Global Symbol Table
  GlobLabels.Lines.SaveToFile(ChangeFileEXt(SaveBinFileDialog.FileName,'.GSYM'));
    //Save Binary Listing
  BinText.Lines.SaveToFile(ChangeFileEXt(SaveBinFileDialog.FileName,'.BLST'));
  if memErrors.Lines.Count>0 then
     memErrors.Lines.SaveToFile(ChangeFileEXt(SaveBinFileDialog.FileName,'.ERR'));
 finally
   sl.Free;
   sf.Free;
   fnewbrain.ResumeEmul;
 end;
  Showmessage(inttostr(totbytes)+' bytes put in file!!!');
 End;
end;

procedure Tfrmdis.SpeedButton7Click(Sender: TObject);
begin
 DoDisassembly;
end;

procedure Tfrmdis.SpeedButton8Click(Sender: TObject);
begin
 DoDisasmData;
end;

procedure Tfrmdis.SpeedButton9Click(Sender: TObject);
begin
 DoDisAsmPrint;
end;

procedure Tfrmdis.StatusBar1DblClick(Sender: TObject);
begin
 //  OpenTextFileDialog1.FileName:='';
   SaveTextFileDialog1.FileName:='';
   SaveBinFileDialog.FileName:='';
   statusbar1.Panels[2].Text:='<no filename>';
end;


procedure Tfrmdis.Timer1Timer(Sender: TObject);
begin
checkModemStatus;
end;

procedure Tfrmdis.TrackBar1Change(Sender: TObject);
begin
 TRACKBAR1.Hint:='Delay:'+inttostr(trackbar1.position);
end;

function Tfrmdis.SendChar(c:AnsiChar):boolean;
Begin
  result:=DsrReady AND (BUTTON10.TAG=0);
  if not result then exit;
  ApdComPort1.PutChar(c);
  Sleep(trackbar1.position);
End;


procedure TInstrList.Clear;
Var i:Integer;
begin
  for i := 1 to Count  do
     Freemem(Instr[i]);
  Inherited;
end;

function TInstrList.GetInstr(Index: Integer): pInstr;
begin
  Result :=  PInstr(Get(Index-1));
end;

function TInstrList.GetInstrIdxFromAddr(Addr: Integer): Integer;
var
  I: Integer;
begin
   Result:=-1;
   for I := 0 to Count - 1 do
   Begin
      if PInstr(Get(i)).Addr=addr then
      Begin
        Result:=i;
        Break;
      end;
   end;
end;

{ TInstrList }

procedure TInstrList.New;
Var p:PInstr;
begin
  System.New(p);
  Add(p);
  p.Addr:=0;
  p.Nob:=0;
  p.Bytes[1]:=0;  p.Bytes[2]:=0;  p.Bytes[3]:=0;  p.Bytes[4]:=0;
  p.Instr:='';
  p.Comments:='';
  p.CommentsPre:='';
end;

procedure TInstrList.PutInstr(Index: Integer; Item: PInstr);
begin
  Put(Index-1,Item);
end;


Initialization
 Instructions:=TInstrList.create;
 BreakPList:=TBreakPointList.create;
 Instructions.Clear;
 if not DirectoryExists(AppPath+DefaultAsmDir) then
    CreateDir(AppPath+DefaultAsmDir);

Finalization
 Instructions.Free;
 BreakPList.free;

end.
