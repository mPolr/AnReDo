object frmRepo: TfrmRepo
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1088#1077#1087#1086#1079#1080#1090#1086#1088#1080#1103#1084#1080
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
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
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
    Caption = #1059#1076#1072#1083#1080#1090#1100
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 1
    OnClick = cmdDelURLClick
  end
  object lstRepos: TListBox
    Left = 89
    Top = 39
    Width = 401
    Height = 282
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
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 4
    OnClick = cmdSaveClick
  end
end
