object frmAbout: TfrmAbout
  Left = 0
  Top = 0
  AlphaBlend = True
  AlphaBlendValue = 220
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
  ClientHeight = 218
  ClientWidth = 345
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  GlassFrame.Enabled = True
  GlassFrame.SheetOfGlass = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 282
    Height = 28
    Caption = 'Android Repo Downloader v0.1.0.15'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    GlowSize = 5
    ParentFont = False
  end
  object Label2: TLabel
    Left = 16
    Top = 48
    Width = 321
    Height = 57
    AutoSize = False
    Caption = 
      'Developed by mPolr.'#13#10'Freeware and AS IS'#13#10#13#10'Thanks to site 4pda.r' +
      'u :)'
    GlowSize = 2
  end
  object lblIconAuthorURL: TLabel
    Left = 8
    Top = 197
    Width = 97
    Height = 13
    Cursor = crHandPoint
    Hint = #1055#1086#1089#1077#1090#1080#1090#1100' http://benrulz.com/'
    Caption = #1048#1082#1086#1085#1082#1072' '#1087#1088#1086#1075#1088#1072#1084#1084#1099': Benrulz'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHotLight
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    GlowSize = 3
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = lblIconAuthorURLClick
  end
  object lblAppTopicURL: TLabel
    Left = 8
    Top = 182
    Width = 93
    Height = 19
    Cursor = crHandPoint
    Hint = #1055#1086#1089#1077#1090#1080#1090#1100' '#1092#1086#1088#1091#1084' 4pda.ru'
    Caption = #1058#1086#1087#1080#1082' '#1085#1072' '#1092#1086#1088#1091#1084#1077
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHotLight
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    GlowSize = 3
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = lblAppTopicURLClick
  end
  object cmdClose: TBitBtn
    Left = 263
    Top = 185
    Width = 75
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 0
    OnClick = cmdCloseClick
  end
end
