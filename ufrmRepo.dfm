object frmRepo: TfrmRepo
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'Manage repo'
  ClientHeight = 369
  ClientWidth = 498
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object cmdAddURL: TBitBtn
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Add'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 0
    OnClick = cmdAddURLClick
  end
  object cmdDelURL: TBitBtn
    Left = 8
    Top = 39
    Width = 75
    Height = 25
    Caption = 'Delete'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 1
    OnClick = cmdDelURLClick
  end
  object lstRepos: TListBox
    Left = 89
    Top = 39
    Width = 401
    Height = 234
    ItemHeight = 13
    TabOrder = 2
  end
  object txtAddURL: TEdit
    Left = 89
    Top = 8
    Width = 401
    Height = 21
    TabOrder = 3
  end
  object cmdSave: TButton
    Left = 415
    Top = 336
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 4
    OnClick = cmdSaveClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 273
    Width = 482
    Height = 57
    Caption = 'Proxy'
    TabOrder = 5
    object Label1: TLabel
      Left = 136
      Top = 24
      Width = 26
      Height = 13
      Caption = 'Host:'
    end
    object Label2: TLabel
      Left = 296
      Top = 24
      Width = 24
      Height = 13
      Caption = 'Port:'
    end
    object chkProxy: TCheckBox
      Left = 16
      Top = 24
      Width = 97
      Height = 17
      Caption = 'Enable proxy'
      TabOrder = 0
    end
    object txtProxyHost: TEdit
      Left = 168
      Top = 21
      Width = 113
      Height = 21
      TabOrder = 1
      Text = '192.168.1.1'
    end
    object txtProxyPort: TEdit
      Left = 328
      Top = 21
      Width = 41
      Height = 21
      MaxLength = 5
      TabOrder = 2
      Text = '8080'
    end
  end
end
