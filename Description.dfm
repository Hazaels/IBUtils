object fmDescription: TfmDescription
  Left = 393
  Top = 173
  Width = 345
  Height = 278
  BorderWidth = 4
  Caption = 'Description'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnKeyDown = FormKeyDown
  DesignSize = (
    329
    243)
  PixelsPerInch = 96
  TextHeight = 13
  object lblTitle: TAKLabel
    Left = 0
    Top = 0
    Width = 329
    Height = 18
    Align = alTop
    AutoSize = False
    Caption = '  Description of '
    Color = clAppWorkSpace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlightText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Layout = tlCenter
  end
  object meDesc: TMemo
    Left = 0
    Top = 18
    Width = 329
    Height = 191
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
  end
  object btOk: TButton
    Left = 170
    Top = 216
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
  end
  object btCancel: TButton
    Left = 252
    Top = 216
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object FormStorage: TFormStorage
    IniSection = 'Description'
    StoredValues = <>
    Left = 112
    Top = 72
  end
end
