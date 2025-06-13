program NewBrain;

uses
  Vcl.Forms,
  debug in 'debug.pas' {Form2},
  frmAbout in 'frmAbout.pas' {fAbout},
  frmChrDsgn in 'frmChrDsgn.pas' {fchrdsgn},
  frmCPUWin in 'frmCPUWin.pas' {fCPUWin},
  frmDisassembly in 'frmDisassembly.pas' {frmdis},
  frmDiskMgmt in 'frmDiskMgmt.pas' {fDiskMgmt},
  frmDrvInfo in 'frmDrvInfo.pas' {fDrvInfo},
  frmInstructions in 'frmInstructions.pas' {fInstructions},
  frmNewDebug in 'frmNewDebug.pas' {NewDebug},
  frmOptions in 'frmOptions.pas' {foptions},
  frmOSWin in 'frmOSWin.pas' {fOSWin},
  frmPeriferals in 'frmPeriferals.pas' {frmPerif},
  frmRomVersion in 'frmRomVersion.pas' {fRomVersion},
  frmSplash in 'frmSplash.pas' {fsplash},
  frmTapeMgmt in 'frmTapeMgmt.pas' {fTapeMgmt},
  New in 'New.pas' {fNewBrain},
  SendKey in 'SendKey.pas',
  strings in 'strings.pas',
  uAsm in 'uAsm.pas',
  uAsmPrj in 'uAsmPrj.pas',
  UDISASM in 'UDISASM.PAS',
  uNBCop in 'uNBCop.pas',
  uNBCPM in 'uNBCPM.pas',
  uNBIO in 'uNBIO.pas',
  uNBKeyboard in 'uNBKeyboard.pas',
  uNBKeyboard2 in 'uNBKeyboard2.pas',
  uNBMemory in 'uNBMemory.pas',
  uNBParser in 'uNBParser.pas',
  uNBScreen in 'uNBScreen.pas',
  uNBStream in 'uNBStream.pas',
  uNBTapes in 'uNBTapes.pas',
  uNBTypes in 'uNBTypes.pas',
  uPCComms in 'uPCComms.pas' {dmCommd: TDataModule},
  uprogr in 'uprogr.pas' {frmProgress},
  Ustopwatch in 'Ustopwatch.pas',
  ustrings in 'ustrings.pas',
  uUpdate in 'uUpdate.pas' {frmUpdate},
  uz80dsm in 'uz80dsm.pas' {frmDisasm},
  Z80Intf in 'Z80Intf.pas',
  Z80BaseClass in 'Z80Package\Z80BaseClass.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfNewBrain, fNewBrain);
  Application.CreateForm(TdmCommd, dmCommd);
  Application.Title := 'Newbrain Emulator PRO';
//  TStyleManager.TrySetStyle('Sky');
  Application.CreateForm(TdmCommd, dmCommd);
  Application.CreateForm(TfrmProgress, frmProgress);
  Application.CreateForm(TfDrvInfo, fDrvInfo);
  Application.CreateForm(TNewDebug, NewDebug);
  Application.CreateForm(TfTapeMgmt, fTapeMgmt);
  Application.CreateForm(TfDiskMgmt, fDiskMgmt);
  Application.CreateForm(Tfoptions, foptions);
  Application.CreateForm(TfrmPerif, frmPerif);
  Application.CreateForm(Tfsplash, fsplash);
  Application.CreateForm(TfrmUpdate, frmUpdate);
  Application.Run;
end.
