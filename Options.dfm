object fmOptions: TfmOptions
  Left = 330
  Top = 211
  ActiveControl = btOk
  BorderStyle = bsDialog
  BorderWidth = 4
  Caption = 'Options'
  ClientHeight = 138
  ClientWidth = 314
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    314
    138)
  PixelsPerInch = 96
  TextHeight = 13
  object AKLabel1: TAKLabel
    Left = 0
    Top = 0
    Width = 314
    Height = 18
    Align = alTop
    AutoSize = False
    Caption = ' General options:'
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
  object btCancel: TButton
    Left = 236
    Top = 109
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 0
  end
  object btOk: TButton
    Left = 156
    Top = 109
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 20
    Width = 313
    Height = 77
    TabOrder = 2
    object chkLoadLastOpened: TCheckBox
      Left = 12
      Top = 21
      Width = 209
      Height = 17
      Caption = 'Load Last Opened Models After Start'
      TabOrder = 0
    end
    object chkKeepConnection: TCheckBox
      Left = 12
      Top = 45
      Width = 209
      Height = 17
      Caption = 'Keep database connection'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
  end
  object FormStorage: TFormStorage
    IniSection = 'Options'
    StoredValues = <>
    Left = 8
    Top = 112
  end
end
