object fDrvInfo: TfDrvInfo
  Left = 631
  Top = 105
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'Drive Information'
  ClientHeight = 555
  ClientWidth = 183
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OnShow = FormShow
  DesignSize = (
    183
    555)
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 16
    Top = 8
    Width = 65
    Height = 23
    GroupIndex = 1
    Down = True
    Caption = 'Drive A'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 96
    Top = 8
    Width = 71
    Height = 23
    GroupIndex = 1
    Caption = 'Drive B'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = SpeedButton2Click
  end
  object Label1: TLabel
    Left = 16
    Top = 40
    Width = 151
    Height = 20
    Cursor = crHandPoint
    Hint = 'Click to select contents'
    AutoSize = False
    Caption = 'Label1'
    Color = clGreen
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    Transparent = False
    OnClick = Label1Click
  end
  object ListBox1: TListBox
    Left = 4
    Top = 64
    Width = 173
    Height = 485
    Hint = 'Dbl Click to Load BASIC Program'
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnDblClick = ListBox1DblClick
  end
end
