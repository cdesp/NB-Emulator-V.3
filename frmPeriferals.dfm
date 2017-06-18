object frmPerif: TfrmPerif
  Left = 44
  Top = 140
  AlphaBlend = True
  AlphaBlendValue = 240
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Peripheral Interfaces Setup'
  ClientHeight = 341
  ClientWidth = 734
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GB_DP: TGroupBox
    Left = 8
    Top = 8
    Width = 353
    Height = 249
    Caption = 'DATAPACK Interface Module'
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 16
      Top = 72
      Width = 32
      Height = 32
      Caption = 'RAM'
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 54
      Top = 72
      Width = 32
      Height = 32
      Caption = 'ROM'
      OnClick = SpeedButton2Click
    end
    object CB_DP: TCheckBox
      Left = 16
      Top = 24
      Width = 73
      Height = 17
      Caption = 'ENABLED'
      TabOrder = 0
      OnClick = CB_DPClick
    end
    object DPGRID: TStringGrid
      Left = 2
      Top = 112
      Width = 349
      Height = 135
      Align = alBottom
      ColCount = 3
      FixedCols = 0
      TabOrder = 1
      ColWidths = (
        76
        67
        186)
    end
  end
  object GroupBox1: TGroupBox
    Left = 367
    Top = 8
    Width = 353
    Height = 247
    Caption = 'MICROPAGE Interface Module'
    TabOrder = 1
    object SpeedButton3: TSpeedButton
      Left = 16
      Top = 72
      Width = 32
      Height = 32
      Caption = 'RAM'
      OnClick = SpeedButton1Click
    end
    object SpeedButton4: TSpeedButton
      Left = 54
      Top = 72
      Width = 32
      Height = 32
      Caption = 'ROM'
      OnClick = SpeedButton2Click
    end
    object CB_MP: TCheckBox
      Left = 16
      Top = 24
      Width = 73
      Height = 17
      Caption = 'ENABLED'
      TabOrder = 0
      OnClick = CB_MPClick
    end
    object MPGrid: TStringGrid
      Left = 2
      Top = 110
      Width = 349
      Height = 135
      Align = alBottom
      ColCount = 3
      FixedCols = 0
      TabOrder = 1
      ColWidths = (
        76
        67
        186)
    end
  end
  object Button1: TButton
    Left = 24
    Top = 288
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 112
    Top = 288
    Width = 75
    Height = 25
    Caption = 'CANCEL'
    ModalResult = 2
    TabOrder = 3
  end
  object Button3: TButton
    Left = 461
    Top = 288
    Width = 75
    Height = 25
    Caption = 'DEFAULT'
    TabOrder = 4
    OnClick = Button3Click
  end
  object SAVE: TButton
    Left = 366
    Top = 288
    Width = 75
    Height = 25
    Caption = 'SAVE'
    TabOrder = 5
    OnClick = SAVEClick
  end
  object OpenDialog1: TOpenDialog
    Filter = 'ROM FILES (8K or 16K)|*.ROM|All Files|*.*'
    Options = [ofHideReadOnly, ofNoChangeDir, ofFileMustExist, ofNoNetworkButton, ofEnableSizing]
    OptionsEx = [ofExNoPlacesBar]
    Title = 'Open Rom File'
    OnFolderChange = OpenDialog1FolderChange
    Left = 240
    Top = 16
  end
end
