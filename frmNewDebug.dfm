object NewDebug: TNewDebug
  Left = 347
  Top = 178
  Caption = 'NewDebug'
  ClientHeight = 585
  ClientWidth = 697
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 49
    Height = 445
    Align = alNone
  end
  object debugscr: TDXDraw
    Left = 0
    Top = 100
    Width = 697
    Height = 392
    AutoInitialize = True
    AutoSize = True
    Color = clBtnFace
    Display.FixedBitCount = True
    Display.FixedRatio = True
    Display.FixedSize = False
    Options = [doAllowReboot, doWaitVBlank, doSystemMemory, doFlip, doSelectDriver]
    SurfaceHeight = 392
    SurfaceWidth = 697
    Align = alClient
    TabOrder = 0
    Traces = <>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 697
    Height = 100
    Align = alTop
    TabOrder = 1
    object SpeedButton2: TSpeedButton
      Left = 536
      Top = 72
      Width = 23
      Height = 22
      Hint = 'Continue'
      Caption = 'C'
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton2Click
    end
    object SpeedButton1: TSpeedButton
      Left = 512
      Top = 72
      Width = 23
      Height = 22
      Hint = 'Debug'
      Caption = 'D'
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton1Click
    end
    object SpeedButton3: TSpeedButton
      Left = 576
      Top = 72
      Width = 23
      Height = 22
      Hint = 'Single Step'
      Caption = 'S'
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton3Click
    end
    object SpeedButton4: TSpeedButton
      Left = 626
      Top = 72
      Width = 23
      Height = 22
      Hint = 'Step Run'
      GroupIndex = 1
      Caption = 'R'
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton4Click
    end
    object Label1: TLabel
      Left = 16
      Top = 49
      Width = 228
      Height = 13
      Caption = 'Comma Seperated for bytes (no hex) or plain text'
    end
    object SpeedButton5: TSpeedButton
      Left = 658
      Top = 72
      Width = 23
      Height = 22
      Hint = 'MARK ODS'
      Caption = 'M'
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton5Click
    end
    object CheckBox1: TCheckBox
      Left = 296
      Top = 2
      Width = 97
      Height = 19
      TabStop = False
      Caption = 'Debug Info'
      TabOrder = 0
    end
    object Button3: TButton
      Left = 8
      Top = 8
      Width = 25
      Height = 25
      Caption = '+'
      TabOrder = 1
      OnClick = Button3Click
    end
    object bpnts: TComboBox
      Left = 40
      Top = 8
      Width = 97
      Height = 21
      TabOrder = 2
    end
    object Button4: TButton
      Left = 144
      Top = 8
      Width = 25
      Height = 25
      Caption = '-'
      TabOrder = 3
      OnClick = Button4Click
    end
    object Offset: TEdit
      Left = 448
      Top = 8
      Width = 49
      Height = 21
      TabOrder = 4
      Text = '2048'
      Visible = False
    end
    object Button5: TButton
      Left = 496
      Top = 8
      Width = 25
      Height = 25
      TabOrder = 5
      Visible = False
      OnClick = Button5Click
    end
    object CheckBox2: TCheckBox
      Left = 296
      Top = 21
      Width = 97
      Height = 17
      Caption = 'Stepped'
      TabOrder = 6
    end
    object Streams: TButton
      Left = 384
      Top = 3
      Width = 57
      Height = 33
      Caption = 'Streams'
      TabOrder = 7
      OnClick = StreamsClick
    end
    object Search: TButton
      Left = 320
      Top = 62
      Width = 75
      Height = 25
      Caption = 'Search'
      TabOrder = 8
      OnClick = SearchClick
    end
    object edSrch: TEdit
      Left = 16
      Top = 64
      Width = 297
      Height = 21
      TabOrder = 9
    end
    object Edit1: TEdit
      Left = 552
      Top = 8
      Width = 73
      Height = 21
      TabOrder = 10
      Text = '-1'
      TextHint = 'Override Dev33 Page'
      Visible = False
      OnKeyUp = Edit1KeyUp
    end
    object Edit2: TEdit
      Left = 552
      Top = 32
      Width = 73
      Height = 21
      TabOrder = 11
      Text = '-1'
      TextHint = 'Override Dev33 Page'
      Visible = False
      OnKeyUp = Edit2KeyUp
    end
    object Edit3: TEdit
      Left = 473
      Top = 39
      Width = 73
      Height = 21
      TabOrder = 12
      Text = '-1'
      TextHint = 'Override Video Page'
      Visible = False
      OnKeyUp = Edit3KeyUp
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 492
    Width = 697
    Height = 93
    Align = alBottom
    Lines.Strings = (
      'Memo1')
    TabOrder = 2
  end
end
