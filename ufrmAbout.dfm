object frmAbout: TfrmAbout
  Left = 0
  Top = 0
  AlphaBlend = True
  AlphaBlendValue = 220
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'About'
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
    Caption = 'Android Repo Downloader v0.1.0.24'
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
    Width = 103
    Height = 19
    Cursor = crHandPoint
    Hint = 'Visit http://benrulz.com/'
    Caption = 'Main icon by Benrulz'
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
    Hint = 'Visit forum 4pda.ru'
    Caption = 'App topic in forum'
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
    Caption = 'Close'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 0
    OnClick = cmdCloseClick
  end
end
