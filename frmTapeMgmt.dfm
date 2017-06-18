object fTapeMgmt: TfTapeMgmt
  Left = 177
  Top = 123
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'NewBrain Tape Management'
  ClientHeight = 442
  ClientWidth = 241
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 241
    Height = 401
    Align = alLeft
    TabOrder = 0
    object Label1: TLabel
      Left = 80
      Top = 8
      Width = 68
      Height = 24
      Caption = 'TAPES'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ListBox1: TListBox
      Left = 1
      Top = 40
      Width = 239
      Height = 360
      Align = alBottom
      ItemHeight = 13
      TabOrder = 0
      OnClick = ListBox1Click
      OnDblClick = ListBox1DblClick
      OnKeyPress = ListBox1KeyPress
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 401
    Width = 241
    Height = 41
    Align = alBottom
    TabOrder = 1
    ExplicitWidth = 242
    object Label4: TLabel
      Left = 352
      Top = 1
      Width = 344
      Height = 39
      Alignment = taCenter
      Caption = 
        'Move AVAILABLE FILES to Tape CONTENT.'#13#10'You can move CONTENT file' +
        's up or down to change their order on tape.'#13#10'When you are done p' +
        'ress Save.'
    end
    object Button1: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Select'
      ModalResult = 1
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 96
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object Button10: TButton
      Left = 178
      Top = 8
      Width = 59
      Height = 25
      Caption = 'MGMT -->'
      TabOrder = 2
      OnClick = Button10Click
    end
  end
  object Panel3: TPanel
    Left = 241
    Top = 0
    Width = 0
    Height = 401
    Align = alClient
    TabOrder = 2
    ExplicitWidth = 1
    object Label2: TLabel
      Left = 56
      Top = 8
      Width = 101
      Height = 24
      Caption = 'CONTENT'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 352
      Top = 8
      Width = 173
      Height = 24
      Caption = 'AVAILABLE FILES'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ListBox2: TListBox
      Left = 3
      Top = 40
      Width = 228
      Height = 359
      ItemHeight = 13
      TabOrder = 0
    end
    object Button3: TButton
      Left = 237
      Top = 48
      Width = 75
      Height = 25
      Caption = 'Move Up'
      TabOrder = 1
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 237
      Top = 72
      Width = 75
      Height = 25
      Caption = 'Move Down'
      TabOrder = 2
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 237
      Top = 96
      Width = 75
      Height = 25
      Caption = 'Save'
      TabOrder = 3
      OnClick = Button5Click
    end
    object ListBox3: TListBox
      Left = 319
      Top = 40
      Width = 230
      Height = 359
      ItemHeight = 13
      TabOrder = 4
    end
    object Button6: TButton
      Left = 260
      Top = 183
      Width = 25
      Height = 25
      Caption = '<'
      TabOrder = 5
      OnClick = Button6Click
    end
    object Button7: TButton
      Left = 260
      Top = 215
      Width = 25
      Height = 25
      Caption = '>'
      TabOrder = 6
      OnClick = Button7Click
    end
    object Button8: TButton
      Left = 260
      Top = 151
      Width = 25
      Height = 25
      Caption = '<<'
      TabOrder = 7
      OnClick = Button8Click
    end
    object Button9: TButton
      Left = 260
      Top = 247
      Width = 25
      Height = 25
      Caption = '>>'
      TabOrder = 8
      OnClick = Button9Click
    end
  end
end
