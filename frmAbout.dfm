object fAbout: TfAbout
  Left = 331
  Top = 119
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'About NewBrain Emulator'
  ClientHeight = 389
  ClientWidth = 515
  Color = clSkyBlue
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 333
    Height = 29
    Caption = 'NEWBRAIN EMULATOR Pro'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 120
    Top = 88
    Width = 275
    Height = 20
    Caption = 'Programming By Despoinidis Chris'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 50
    Top = 114
    Width = 410
    Height = 20
    Caption = 'Testing && Newbrain Knowledge By Despoinidis Nick'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 76
    Top = 140
    Width = 356
    Height = 48
    Alignment = taCenter
    Caption = 
      'Many thanks goes to Newbrain Users Group site '#13#10'that gave me the' +
      ' idea of creating this emulator plus '#13#10'the useful information an' +
      'd newbrain programs '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Label4: TLabel
    Left = 321
    Top = 298
    Width = 174
    Height = 16
    Caption = 'e-mail : cdesp72@gmail.com'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 7
    Top = 298
    Width = 88
    Height = 16
    Caption = 'Emulator Site : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 64
    Top = 194
    Width = 396
    Height = 32
    Alignment = taCenter
    Caption = 
      'Special Thanks to Colin Appleby and Albert Stuurman for informat' +
      'ion, material and testing.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Label8: TLabel
    Left = 101
    Top = 298
    Width = 160
    Height = 16
    Cursor = crHandPoint
    Caption = 'http://www.newbrainemu.eu'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = Label8Click
  end
  object Label9: TLabel
    Left = 409
    Top = 51
    Width = 73
    Height = 24
    Alignment = taRightJustify
    Caption = 'Version'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 426506
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label10: TLabel
    Left = 3
    Top = 320
    Width = 92
    Height = 16
    Caption = 'Newbrain Site : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label11: TLabel
    Left = 101
    Top = 320
    Width = 107
    Height = 16
    Cursor = crHandPoint
    Caption = 'https://retro.hcc.nl/'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = Label8Click
  end
  object Label12: TLabel
    Left = 26
    Top = 240
    Width = 469
    Height = 32
    Alignment = taCenter
    AutoSize = False
    Caption = 
      'Z80 Emulator Engine provided by Lin Ke-Fong (https://github.com/' +
      'anotherlin/z80emu)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clOlive
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Button1: TButton
    Left = 224
    Top = 352
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
end
