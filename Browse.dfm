object fmBrowse: TfmBrowse
  Left = 438
  Top = 193
  Width = 375
  Height = 325
  Caption = 'Browse'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = False
  Position = poDefault
  ShowHint = True
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 279
    Width = 367
    Height = 19
    Panels = <
      item
        Width = 160
      end
      item
        Width = 300
      end>
  end
  object grBrowse: TAIB_Grid
    Left = 0
    Top = 30
    Width = 367
    Height = 249
    Hint = 'F6 - incremental search for text columns'
    TreeOptions.NodeIndent = 25
    CustomGlyphsSupplied = []
    DataSource = dsBrowse
    Align = alClient
    TabOrder = 1
    IncSearchHotKey = 117
    SeekNearest = True
    DrawFocusSelected = True
    DrawCellTextOptions = [gdtShowTextBlob]
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 367
    Height = 30
    ButtonHeight = 25
    Caption = 'ToolBar1'
    Flat = True
    Images = fmMain.ilMain
    TabOrder = 2
    object UpdateBar: TIB_UpdateBar
      Left = 0
      Top = 0
      Width = 151
      Height = 25
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
      DataSource = dsBrowse
      ReceiveFocus = False
      CustomGlyphsSupplied = []
      VisibleButtons = [ubEdit, ubInsert, ubDelete, ubPost, ubCancel, ubRefreshAll]
    end
    object ToolButton2: TToolButton
      Left = 151
      Top = 0
      Width = 8
      Caption = 'ToolButton2'
      ImageIndex = 1
      Style = tbsSeparator
    end
    object tbExport: TToolButton
      Left = 159
      Top = 0
      Hint = 'Export'
      Caption = 'Export'
      ImageIndex = 25
      OnClick = tbExportClick
    end
  end
  object qrBrowse: TAIB_Query
    CheckRequired = False
    ConfirmDeletePrompt.Strings = (
      'Delete this record?')
    MasterSearchFlags = [msfOpenMasterOnOpen, msfSearchAppliesToMasterOnly]
    PreparedEdits = False
    PreparedInserts = False
    RefreshAction = raKeepDataPos
    RequestLive = True
    FetchWholeRows = True
    IsTree = False
    Left = 70
    Top = 56
  end
  object dsBrowse: TAIB_DataSource
    Dataset = qrBrowse
    Left = 104
    Top = 57
  end
  object FormStorage: TFormStorage
    IniSection = 'Browse'
    Options = [fpPosition]
    StoredValues = <>
    Left = 152
    Top = 56
  end
  object ExportDialog: TIB_QExportDialog
    DataSet = qrBrowse
    DBGrid = grBrowse
    Formats.DateTimeFormat = 'dd.MM.yyyy h:mm'
    Formats.IntegerFormat = '#,###,##0'
    Formats.CurrencyFormat = '00,00K'#269
    Formats.FloatFormat = '#,###,##0.00'
    Formats.DateFormat = 'dd.MM.yyyy'
    Formats.TimeFormat = 'h:mm'
    Formats.BooleanTrue = 'true'
    Formats.BooleanFalse = 'false'
    Formats.NullString = 'null'
    Left = 192
    Top = 54
  end
end
