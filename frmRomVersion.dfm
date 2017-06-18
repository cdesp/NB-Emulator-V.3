object fRomVersion: TfRomVersion
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Select Rom Version'
  ClientHeight = 278
  ClientWidth = 272
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 24
    Top = 224
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 168
    Top = 224
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object ListBox1: TListBox
    Left = 24
    Top = 24
    Width = 219
    Height = 161
    ItemHeight = 13
    Items.Strings = (
      'Version 1.4'
      'Version 1.9'
      'Version 1.91'
      'Version 2.00 Original'
      'Version 2.00 No Ram Check'
      'Version 2.00 Compiled by EMULATOR')
    TabOrder = 2
  end
end
