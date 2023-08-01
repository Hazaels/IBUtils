object fmProgress: TfmProgress
  Left = 241
  Top = 230
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'fmProgress'
  ClientHeight = 54
  ClientWidth = 359
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    359
    54)
  PixelsPerInch = 96
  TextHeight = 13
  object lbl: TLabel
    Left = 6
    Top = 7
    Width = 3
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    Caption = ' '
  end
  object Progress: TProgressBar
    Left = 6
    Top = 30
    Width = 347
    Height = 16
    Anchors = [akLeft, akTop, akRight]
    Min = 0
    Max = 100
    Step = 1
    TabOrder = 0
  end
end
