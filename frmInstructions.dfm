object fInstructions: TfInstructions
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsSizeToolWin
  Caption = 'Quick Instructions'
  ClientHeight = 525
  ClientWidth = 675
  Color = clSkyBlue
  Constraints.MinHeight = 250
  Constraints.MinWidth = 350
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object RichEdit1: TRichEdit
    Left = 0
    Top = 0
    Width = 675
    Height = 457
    TabStop = False
    Align = alClient
    BorderStyle = bsNone
    Color = clInfoBk
    Ctl3D = False
    Font.Charset = GREEK_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    HideScrollBars = False
    Lines.Strings = (
      'RichEdit1')
    ParentCtl3D = False
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 457
    Width = 675
    Height = 68
    Align = alBottom
    BevelOuter = bvNone
    Ctl3D = False
    ParentColor = True
    ParentCtl3D = False
    TabOrder = 1
    DesignSize = (
      675
      68)
    object Hide: TButton
      Left = 24
      Top = 21
      Width = 113
      Height = 36
      Caption = 'Close'
      Default = True
      TabOrder = 0
      OnClick = HideClick
    end
    object Button1: TButton
      Left = 491
      Top = 21
      Width = 169
      Height = 36
      Anchors = [akTop, akRight]
      Caption = 'Do not show again'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
end
