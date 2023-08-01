object fmFindTable: TfmFindTable
  Left = 378
  Top = 287
  ActiveControl = cmbTableName
  BorderStyle = bsToolWindow
  Caption = 'Find Table'
  ClientHeight = 72
  ClientWidth = 387
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    387
    72)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 12
    Width = 30
    Height = 13
    Caption = 'Table:'
  end
  object btFind: TButton
    Left = 308
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&Find'
    Default = True
    TabOrder = 0
    OnClick = btFindClick
  end
  object btCancel: TButton
    Left = 308
    Top = 37
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object cmbTableName: TComboBox
    Left = 48
    Top = 8
    Width = 246
    Height = 21
    CharCase = ecUpperCase
    ItemHeight = 13
    TabOrder = 2
    OnChange = cmbTableNameChange
  end
  object chkUpperCase: TCheckBox
    Left = 48
    Top = 40
    Width = 97
    Height = 17
    Caption = '&Upper Case'
    Checked = True
    State = cbChecked
    TabOrder = 3
    OnClick = chkUpperCaseClick
  end
  object qrFindTables: TIB_Query
    DatabaseName = 'c:\delphi\infis\data\infis_cz.gdb'
    SQL.Strings = (
      'SELECT RDB$RELATION_NAME AS TABLE_NAME'
      'FROM RDB$RELATIONS'
      'WHERE RDB$SYSTEM_FLAG <> 1')
    OnPrepareSQL = qrFindTablesPrepareSQL
    AutoFetchAll = True
    ColorScheme = False
    MasterSearchFlags = [msfOpenMasterOnOpen, msfSearchAppliesToMasterOnly]
    BufferSynchroFlags = []
    FetchWholeRows = True
    Left = 192
    Top = 32
  end
end
