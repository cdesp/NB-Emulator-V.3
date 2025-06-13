object foptions: Tfoptions
  Left = 284
  Top = 127
  BorderIcons = [biSystemMenu]
  Caption = 'Newbrain Options'
  ClientHeight = 429
  ClientWidth = 589
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 589
    Height = 388
    Align = alClient
    TabOrder = 0
    object ComGroup: TRadioGroup
      Left = 16
      Top = 24
      Width = 185
      Height = 97
      Caption = 'Com Port'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'Com1'
        'Com2'
        'Com3'
        'Com4'
        'No COM')
      TabOrder = 0
    end
    object BaudGroup: TRadioGroup
      Left = 16
      Top = 127
      Width = 185
      Height = 141
      Caption = 'Baud Rate'
      Columns = 2
      ItemIndex = 4
      Items.Strings = (
        '1200'
        '2400'
        '4800'
        '9600'
        '19200'
        '38400'
        '57600'
        '115200')
      TabOrder = 1
    end
    object prnGroup: TRadioGroup
      Left = 207
      Top = 226
      Width = 137
      Height = 145
      Caption = 'Printer'
      ItemIndex = 0
      Items.Strings = (
        'File'
        'LPT1'
        'LPT2'
        'WIN PRN')
      TabOrder = 2
    end
    object GroupBox1: TGroupBox
      Left = 208
      Top = 27
      Width = 137
      Height = 88
      Caption = 'General Com Options'
      TabOrder = 3
      object Label1: TLabel
        Left = 8
        Top = 24
        Width = 42
        Height = 13
        Caption = 'Stop Bits'
      end
      object Label2: TLabel
        Left = 8
        Top = 56
        Width = 43
        Height = 13
        Caption = 'Data Bits'
      end
      object edstop: TEdit
        Left = 61
        Top = 21
        Width = 68
        Height = 21
        TabOrder = 0
        Text = '2'
      end
      object edDatab: TEdit
        Left = 60
        Top = 52
        Width = 68
        Height = 21
        TabOrder = 1
        Text = '8'
      end
    end
    object parity: TRadioGroup
      Left = 208
      Top = 130
      Width = 138
      Height = 89
      Caption = 'Parity'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'None'
        'Odd'
        'Even'
        'Mark'
        'Space')
      TabOrder = 4
    end
    object GroupBox2: TGroupBox
      Left = 352
      Top = 27
      Width = 225
      Height = 241
      Caption = 'TCP/IP (Untested)'
      TabOrder = 5
      object Label3: TLabel
        Left = 8
        Top = 43
        Width = 38
        Height = 13
        Caption = 'Address'
      end
      object Label4: TLabel
        Left = 9
        Top = 68
        Width = 19
        Height = 13
        Caption = 'Port'
      end
      object Label5: TLabel
        Left = 8
        Top = 168
        Width = 44
        Height = 13
        Caption = 'Bound IP'
      end
      object Label6: TLabel
        Left = 8
        Top = 188
        Width = 204
        Height = 48
        AutoSize = False
        Caption = 
          'Be sure the computer you are connecting  "Acts As a Server" if y' +
          'ou "Act As a Client" and vice versa'
        WordWrap = True
      end
      object chkEnabled: TCheckBox
        Left = 11
        Top = 19
        Width = 97
        Height = 17
        Caption = 'Enabled'
        TabOrder = 0
        OnClick = chkEnabledClick
      end
      object edAddress: TEdit
        Left = 56
        Top = 40
        Width = 153
        Height = 21
        TabOrder = 1
      end
      object edPort: TEdit
        Left = 56
        Top = 64
        Width = 41
        Height = 21
        TabOrder = 2
        Text = '9437'
      end
      object RGGroup: TRadioGroup
        Left = 3
        Top = 91
        Width = 209
        Height = 65
        ItemIndex = 0
        Items.Strings = (
          'Act As Client'
          'Act As Server')
        TabOrder = 3
      end
      object cmbLocalAddr: TComboBox
        Left = 69
        Top = 164
        Width = 145
        Height = 21
        TabOrder = 4
        Text = '127.0.0.1'
      end
    end
    object GroupBox3: TGroupBox
      Left = 352
      Top = 274
      Width = 225
      Height = 97
      Caption = 'Color'
      TabOrder = 6
      object Label7: TLabel
        Left = 11
        Top = 27
        Width = 27
        Height = 13
        Caption = 'Fore :'
      end
      object Label8: TLabel
        Left = 7
        Top = 61
        Width = 31
        Height = 13
        Caption = 'Back :'
      end
      object Fore: TColorBox
        Left = 56
        Top = 24
        Width = 153
        Height = 22
        DefaultColorColor = clGreen
        Selected = clGreen
        Style = [cbStandardColors]
        TabOrder = 0
      end
      object Back: TColorBox
        Left = 56
        Top = 58
        Width = 153
        Height = 22
        Style = [cbStandardColors]
        TabOrder = 1
      end
    end
    object GroupBox4: TGroupBox
      Left = 16
      Top = 332
      Width = 185
      Height = 39
      Caption = 'Keyboard'
      TabOrder = 7
      object cbEnglish: TCheckBox
        Left = 16
        Top = 19
        Width = 121
        Height = 17
        Caption = 'English Keyboard'
        TabOrder = 0
      end
    end
    object rgFlow: TRadioGroup
      Left = 16
      Top = 268
      Width = 185
      Height = 58
      Caption = 'Flow Control'
      Columns = 2
      ItemIndex = 2
      Items.Strings = (
        'CTS'
        'DSR'
        'None')
      TabOrder = 8
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 388
    Width = 589
    Height = 41
    Align = alBottom
    TabOrder = 1
    object Button1: TButton
      Left = 40
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 136
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      OnClick = Button2Click
    end
  end
end
