{
    <Grundy NewBrain Emulator Pro Made by Despsoft>
    Copyright (C) 2004  <Despinidis Chris>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit uz80dsm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons;

type
  TString16 = String[50];
  AString16 = array[1..1] of TString16;
  PString16 = ^AString16;
  TfrmDisasm = class(TForm)
    Panel1: TPanel;
    pnlShow: TPanel;
    pbShow: TPaintBox;
    Panel3: TPanel;
    sbShow: TScrollBar;
    Panel4: TPanel;
    bbHide: TBitBtn;
    Edit1: TEdit;
    Button1: TButton;
    Edit2: TEdit;
    cbpAGES: TComboBox;
    Button2: TButton;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit4: TEdit;
    procedure bbHideClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pbShowPaint(Sender: TObject);
    procedure sbShowChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure cbpAGESChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    nCabe: Integer;
    PageNo: Integer;
  public
    { Public declarations }
    oStrings: PString16;
    nTotInstr: Integer;
    procedure ClearStruct;
    procedure Disasm(P: Pointer;Start, nMaxROM: Integer);
    procedure SetPos(nX, nY, nW, nH: Integer);
    function IsCleared: Boolean;
  end;

var
  frmDisasm: TfrmDisasm;

implementation

uses
  UDisasm, uprogr,ustrings,new,unbMemory,Printers;

{$R *.DFM}

procedure TfrmDisasm.bbHideClick(Sender: TObject);
begin
  Visible := false;
end;

procedure TfrmDisasm.FormCreate(Sender: TObject);
Var i:integer;
begin
  PageNo:=-1;
  oStrings := nil;
  nTotInstr := 0;

  nCabe := pbShow.Height div 12;
  sbShow.LargeChange := nCabe;
  cbpages.items.Clear;
  for i:=0 to 255 do
   if nbmem.NBPages[i]<>nil then
    cbpages.items.Add(Inttostr(nbmem.NBPages[i]^.Page));
end;

procedure TfrmDisasm.ClearStruct;
begin
  if oStrings<>nil then begin
    FreeMem(oStrings, nTotInstr*SizeOf(TString16));
  end;
  oStrings := nil;
  nTotInstr := 0;
end;

procedure TfrmDisasm.Disasm(P: Pointer;Start, nMaxROM: Integer);
const
  aBit: array[1..4] of byte = ($80, $40, $20, $10);
var
  nTInstr, nAddr: Integer;
  aROMInstr: array[0..3] of Byte;
  nPos, nIndex, I, J, K: Integer;
  lFound, lLixo: Boolean;
  cAux: String;
  nPorc, nOldPorc: Real;
  ss,ss1,ss2:String;
  SS3:STRING;
  tbt,nn:Integer;
begin
  if p=nil then exit;
  If visible then
  Begin
   frmProgress.Show;
   frmProgress.gProgress.Visible := true;
   frmProgress.gProgress.MinValue := 0;
   frmProgress.gProgress.MaxValue := 100;
   frmProgress.gProgress.Progress := 0;
  End;
  nOldPorc := -1;

  for k := 1 to 2 do begin
    nAddr := start;
    if k=1 then begin
      nTInstr := 0
    end
    else begin
      nTotInstr := 0;
      GetMem(oStrings, nTInstr*SizeOf(TString16));
    end;

    nTotInstr := 0;
    while nAddr<=nMaxROM do begin //nMaxROM

      nPorc := k*nAddr/nMaxROM /2*100; //nMaxRom
      if nPorc>nOldPorc then begin
        nOldPorc := nPorc+5;

        If visible then
        Begin
         frmProgress.gProgress.Progress := Round(nPorc);
         frmProgress.gProgress.Refresh;
        End; 
        {Application.ProcessMessages;}
      end;



      aROMInstr[0] := Byte(PByte(P)[nAddr+0]);
      aROMInstr[1] := Byte(PByte(P)[nAddr+1]);
      aROMInstr[2] := Byte(PByte(P)[nAddr+2]);
      aROMInstr[3] := Byte(PByte(P)[nAddr+3]);
     // lFound := false;
      cAux := '';
      for i := 1 to MAX_Z80_INSTR do begin
        with aZ80Instr[i] do begin
          lFound := true;
          for j := 1 to nMask and $0F do
            if (nMask and aBit[j])<>0 then begin
              if aROMInstr[j-1]<>aInstr[j-1] then lFound := false;
            end
            else begin
              cAux := IntToHex(aROMInstr[j-1], 2)+cAux;
            end;
          nIndex := i;
          if lFound then begin
            lLixo := true;
            break;
          end;
        end;
      end;

      if k=1 then
        Inc(nTInstr)
      else begin
        Inc(nTotInstr);

        oStrings^[nTotInstr] := IntToHex(nAddr, 4)+aZ80Instr[nIndex].cInstr;
        nPos := Pos('##', oStrings^[nTotInstr]);

        if nPos<>0 then begin
          oStrings^[nTotInstr][nPos+0] := Ansichar(cAux[1]);
          oStrings^[nTotInstr][nPos+1] := Ansichar(cAux[2]);
          Delete(cAux, 1, 2);

          nPos := Pos('##', oStrings^[nTotInstr]);
          if nPos<>0 then begin
            oStrings^[nTotInstr][nPos+0] := Ansichar(cAux[1]);
            oStrings^[nTotInstr][nPos+1] := Ansichar(cAux[2]);
          end;
        end;
      end;

      tbt:=1;

      if lFound or lLixo then
       tbt:= (aZ80Instr[nIndex].nMask and $0F);
      ss:=' ';
      ss3:='';
      For nn:=0 to tbt-1 do
      bEGIN
      try
       ss:=ss+Inttohex(aROMInstr[nn],2)+' ';
      Except
      End;
      try
       if aROMInstr[nn]>31 then
        ss3:=ss3+Chr(aROMInstr[nn])
       Else
        ss3:=ss3+'.'; 
      Except
      End; 

      eND;
      For nn:=tbt to 4 do
      Begin
       ss:=ss+'   ';
       ss3:=ss3+' ';
      End;

      if assigned(oStrings) then
      Begin
       ss1:=Copy(oStrings^[nTotInstr],1,4);
       ss2:=Copy(oStrings^[nTotInstr],5,Maxint);
       oStrings^[nTotInstr]:=ss1+ss+ss3+ss2
      End;
      Inc(nAddr,tbt);
    end;
  end;
  sbShow.Min := 0;
  if nTotInstr-nCabe>0 then
   sbShow.Max := nTotInstr-nCabe;
  If visible then
  Begin
   frmProgress.gProgress.Visible := false;
   frmProgress.Hide;
   formresize(nil);
   pbshow.Invalidate;
  End; 
end;

procedure TfrmDisasm.pbShowPaint(Sender: TObject);
var
  I: Integer;
begin
  if oStrings=nil then exit;

  with pbShow.Canvas do begin
    Brush.Style := BSSOLID;
    Brush.Color := CLWHITE;
    FillRect(pbShow.ClientRect);

    Font.Name := 'COURIER NEW';
    Font.Style := [];
    Font.Size := 8;

    Brush.Style := BSCLEAR;
    for i := 1 to nCabe do begin
      if (sbShow.Position+i)<=nTotInstr then begin
        Font.Style := [FSBOLD];
        TextOut(004, 12*(i-1), Copy(oStrings^[sbShow.Position+i], 1, 4));

        Font.Style := [];
        TextOut(040, 12*(i-1), Copy(oStrings^[sbShow.Position+i], 5, 16));
        TextOut(140, 12*(i-1), Copy(oStrings^[sbShow.Position+i], 21, 4));
        TextOut(180, 12*(i-1), Copy(oStrings^[sbShow.Position+i], 25, 200));
      end;
    end;
  end;
end;

procedure TfrmDisasm.SetPos(nX, nY, nW, nH: Integer);
begin
  if nX>=0 then Left := nX;
  if nY>=0 then Top := nY;
  if nW>=0 then Width := nW;
  if nH>=0 then Height := nH;
end;

procedure TfrmDisasm.sbShowChange(Sender: TObject);
begin
  pbShow.Refresh;
end;

procedure TfrmDisasm.FormResize(Sender: TObject);
begin
  if ntotinstr=0 then exit;
  sbShow.Height := Panel3.Height-8;
  nCabe := pbShow.Height div 12;
  sbShow.LargeChange := nCabe;

   sbShow.Max := nTotInstr-nCabe;
end;

function TfrmDisasm.IsCleared: Boolean;
begin
  IsCleared := oStrings = nil;
end;

procedure TfrmDisasm.Button1Click(Sender: TObject);
Var addr:Integer;
    len1:integer;
    s:String;
    slt:Integer;
begin
 PageNo:=-1;
 ClearStruct;
 s:=edit1.text;
 if s[1]='$' then
  addr:=HexToInt(s)
 Else
  addr:=strtoint(s);
 s:=edit2.text;
 if s[1]='$' then
  len1:=HexToInt(s)
 Else
  len1:=strtoint(s);

 Slt:=Addr div $2000;
 Addr:=Addr mod $2000;

 Disasm(@( NBMEm.MainSlots[Slt].Memory),Addr,addr+len1)
end;

procedure TfrmDisasm.cbpAGESChange(Sender: TObject);
VAr pg:Integer;
begin
  if cbpages.ItemIndex=-1 then exit;

  pg:= strtoint(cbpages.items[cbpages.ItemIndex]);
  if NBMEm.nbpages[pg]=nil then
   ShowMessage('Not available')
  Else
  try
   PageNo:=pg;
   fNewbrain.Suspend1Click(nil);
   Hide;
   ClearStruct;
   Disasm(@( NBMEm.nbpages[pg]^.Memory),0,$2000);
   Show;
   fNewbrain.Suspend1Click(nil);
  Except
  End;
end;

procedure TfrmDisasm.Button2Click(Sender: TObject);
Var i:Integer;
    MAxy,y,spc:Integer;
    lh:Integer;
begin
  try
   MAxy:=strtoint(edit3.text);
  Except
   Maxy:=75;
  End;
  try
   spc:=strtoint(edit4.text);
  Except
   spc:=15;
  End;

  y:=1;
  lh:=Printer.canvas.TextHeight('oOoO');
  Printer.Canvas.Font.Name:='Courier New';
  Printer.Title:='NewBrain Internal Disassembler';
  Printer.BeginDoc;
  printer.Canvas.TextOut(40,40+y*(lh+spc),Printer.Title);
  inc(y);
  inc(y);
  If Pageno<>-1 then
  Begin
   printer.Canvas.TextOut(40,40+y*(lh+spc),'Page NO:'+inttostr(Pageno));
   inc(y);
  End
  Else
  Begin
   printer.Canvas.TextOut(40,40+y*(lh+spc),'Starting Address : '+Edit1.text);
   inc(y);
   printer.Canvas.TextOut(40,40+y*(lh+spc),'Length           : $'+inttohex(strtoint(Edit2.text),4));
   inc(y);
  End;
  inc(y);


  For i:=1 to NtotInstr do
  Begin
   printer.Canvas.TextOut(40,40+y*(lh+spc),ostrings[i]);
   if y>maxy then
   Begin
    Printer.NewPage;
    y:=1;
   End;
   inc(y);
  End;
  Printer.enddoc;
end;

end.
