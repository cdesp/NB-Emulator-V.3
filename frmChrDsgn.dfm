object fchrdsgn: Tfchrdsgn
  Left = 210
  Top = 115
  BorderIcons = [biSystemMenu]
  Caption = 'Rom Character Designer'
  ClientHeight = 436
  ClientWidth = 688
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 688
    Height = 41
    Align = alTop
    TabOrder = 0
    object Button1: TButton
      Left = 32
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Set From Rom'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 120
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Load'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 200
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Save'
      TabOrder = 2
      OnClick = Button3Click
    end
    object cbten: TCheckBox
      Left = 392
      Top = 16
      Width = 97
      Height = 17
      Caption = '10 Pixels'
      TabOrder = 3
    end
  end
  object chrscr: TDXDraw
    Left = 0
    Top = 41
    Width = 464
    Height = 395
    AutoInitialize = True
    AutoSize = True
    Color = clBtnFace
    Display.FixedBitCount = True
    Display.FixedRatio = True
    Display.FixedSize = False
    Options = [doSystemMemory, doFlip, doDirectX7Mode, doHardware, doSelectDriver]
    SurfaceHeight = 395
    SurfaceWidth = 464
    Align = alClient
    TabOrder = 1
    Traces = <>
    OnMouseDown = chrscrMouseDown
  end
  object Panel2: TPanel
    Left = 464
    Top = 41
    Width = 224
    Height = 395
    Align = alRight
    TabOrder = 2
    object PaintBox1: TPaintBox
      Left = 1
      Top = 120
      Width = 222
      Height = 274
      Align = alClient
      Color = clHighlight
      ParentColor = False
      OnMouseDown = PaintBox1MouseDown
      OnPaint = PaintBox1Paint
      ExplicitHeight = 280
    end
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 222
      Height = 119
      Align = alTop
      TabOrder = 0
      object Button4: TButton
        Left = 24
        Top = 2
        Width = 75
        Height = 25
        Caption = 'Reverse'
        TabOrder = 0
        OnClick = Button4Click
      end
      object Button5: TButton
        Left = 24
        Top = 32
        Width = 75
        Height = 25
        Caption = 'Exchange'
        TabOrder = 1
        OnClick = Button5Click
      end
      object Button6: TButton
        Left = 112
        Top = 3
        Width = 75
        Height = 25
        Caption = 'Clear'
        TabOrder = 2
        OnClick = Button6Click
      end
      object Button7: TButton
        Left = 112
        Top = 32
        Width = 75
        Height = 25
        Caption = 'Save'
        TabOrder = 3
        OnClick = Button7Click
      end
      object Button8: TButton
        Left = 24
        Top = 64
        Width = 75
        Height = 25
        Caption = 'Transfer'
        Enabled = False
        TabOrder = 4
        OnClick = Button8Click
      end
      object Button9: TButton
        Left = 112
        Top = 64
        Width = 75
        Height = 25
        Caption = 'MoveUp 1 row'
        TabOrder = 5
        OnClick = Button9Click
      end
      object Button10: TButton
        Left = 112
        Top = 90
        Width = 75
        Height = 25
        Caption = 'MoveDn 1 row'
        TabOrder = 6
        OnClick = Button10Click
      end
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '.chr'
    Filter = 'Char Files|*.chr'
    Title = 'Load Character Set'
    Left = 56
    Top = 56
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '.chr'
    Filter = 'Char Files|*.chr'
    Title = 'Save Character Set'
    Left = 104
    Top = 56
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = Timer1Timer
    Left = 320
    Top = 8
  end
end
