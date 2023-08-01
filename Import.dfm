object fmImport: TfmImport
  Left = 335
  Top = 229
  BorderStyle = bsDialog
  Caption = 'Import'
  ClientHeight = 52
  ClientWidth = 373
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object btStart: TButton
    Left = 264
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = btStartClick
  end
  object Import: TIB_Import
    IB_Connection = cnImport
    AsciiFile = 'C:\telefony\vysledek\telefon1.TXT'
    FieldsFirst = True
    FieldDelimiter = #9
    StringSeparat = #0
    SkipFieldMarker = 'SKIP'
    ProcessMessages = True
    ImportMode = mCopy
    DestTable = 'TEL_CONTACT'
    FieldList.Strings = (
      'ID'
      'CON_VALUE')
    Left = 112
    Top = 8
  end
  object cnImport: TIB_Connection
    LoginPrompt = True
    Left = 56
    Top = 8
  end
end
