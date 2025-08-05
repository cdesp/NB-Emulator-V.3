object fDiskMgmt: TfDiskMgmt
  Left = 281
  Top = 125
  BorderIcons = [biSystemMenu]
  Caption = 'Disk Management'
  ClientHeight = 470
  ClientWidth = 538
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 384
    Width = 538
    Height = 86
    Align = alBottom
    TabOrder = 0
    object Label3: TLabel
      Left = 208
      Top = 33
      Width = 49
      Height = 13
      Caption = 'Valid Data'
    end
    object Label4: TLabel
      Left = 209
      Top = 54
      Width = 50
      Height = 13
      Caption = 'Strip Bytes'
    end
    object Button1: TButton
      Left = 8
      Top = 56
      Width = 75
      Height = 25
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 96
      Top = 56
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object Button3: TButton
      Left = 392
      Top = 33
      Width = 129
      Height = 48
      Caption = 'Extract from Disk Image'
      TabOrder = 2
      OnClick = Button3Click
    end
    object ComboBox1: TComboBox
      Left = 208
      Top = 6
      Width = 313
      Height = 21
      TabOrder = 3
      Text = 'No Strip'
      OnSelect = ComboBox1Select
      Items.Strings = (
        'No Strip'
        '______80DS  _____________   (Filesize=798KB)'
        '5_25 360Kb DSDD 300 - NB200 (Filesize=380KB)'
        '5_25 320Kb DSDD 300 - NB200 (Filesize=360KB)'
        '5_25 320Kb SSDD 300 - NB400 (Filesize=360KB)')
    end
    object vd: TEdit
      Left = 264
      Top = 33
      Width = 76
      Height = 21
      Alignment = taRightJustify
      TabOrder = 4
      Text = '0'
    end
    object sd: TEdit
      Left = 264
      Top = 52
      Width = 76
      Height = 21
      Alignment = taRightJustify
      TabOrder = 5
      Text = '0'
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 273
    Height = 384
    Align = alLeft
    TabOrder = 1
    object Label1: TLabel
      Left = 1
      Top = 1
      Width = 271
      Height = 37
      Align = alTop
      Alignment = taCenter
      Caption = 'Disk A'
      Color = clTeal
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      OnClick = Label1Click
      ExplicitWidth = 100
    end
    object lb1: TListBox
      Left = 1
      Top = 38
      Width = 271
      Height = 345
      Hint = 'Dbl Click to Select & Close'
      Align = alClient
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnDblClick = lb1DblClick
    end
  end
  object Panel4: TPanel
    Left = 273
    Top = 0
    Width = 273
    Height = 384
    Align = alLeft
    TabOrder = 2
    object Label2: TLabel
      Left = 1
      Top = 1
      Width = 271
      Height = 37
      Align = alTop
      Alignment = taCenter
      Caption = 'Disk B'
      Color = clOlive
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      OnClick = Label2Click
      ExplicitWidth = 99
    end
    object lb2: TListBox
      Left = 1
      Top = 38
      Width = 271
      Height = 345
      Hint = 'Dbl Click to Select & Close'
      Align = alClient
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnDblClick = lb1DblClick
    end
  end
  object CPMdskimage: TOpenDialog
    DefaultExt = '*.img'
    Filter = 'IMG|*.img|DSK|*.dsk'
    Options = [ofHideReadOnly, ofNoChangeDir, ofPathMustExist, ofFileMustExist, ofNoNetworkButton, ofOldStyleDialog, ofEnableSizing]
    Left = 361
    Top = 224
  end
end
