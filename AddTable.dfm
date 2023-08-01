object fmAddTable: TfmAddTable
  Left = 123
  Top = 228
  Width = 295
  Height = 277
  ActiveControl = grTables
  BorderWidth = 4
  Caption = 'Add Table'
  Color = clBtnFace
  Constraints.MinHeight = 250
  Constraints.MinWidth = 265
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblList: TAKLabel
    Left = 0
    Top = 49
    Width = 279
    Height = 18
    Align = alTop
    AutoSize = False
    Caption = '   List of tables currently not in model:'
    Color = clAppWorkSpace
    FocusControl = grTables
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlightText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Layout = tlCenter
  end
  object lblSearch: TAKLabel
    Left = 0
    Top = 191
    Width = 279
    Height = 18
    Align = alBottom
    AutoSize = False
    Caption = '   Incremental Search:'
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
  object lblFilter: TAKLabel
    Left = 0
    Top = 0
    Width = 279
    Height = 18
    Align = alTop
    AutoSize = False
    Caption = '   Immediate Filter:'
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
  object grTables: TIB_Grid
    Left = 0
    Top = 67
    Width = 279
    Height = 124
    Hint = 
      'Use incremental search and Ctrl+Space for multiselect, then Ente' +
      'r'
    CustomGlyphsSupplied = []
    DataSource = dsTables
    Align = alClient
    ParentShowHint = False
    ShowHint = True
    OnDblClick = grTablesDblClick
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 0
    OnEnter = grTablesEnter
    OnExit = grTablesExit
    OnKeyDown = grTablesKeyDown
    OnKeyPress = grTablesKeyPress
    DefaultRowHeight = 15
    AllowIncSearch = True
    SearchKeyByKey = True
    SeekNearest = True
    RowSelect = True
    ThumbTracking = True
    TrackGridRow = True
    ListBoxStyle = True
    GridLinks.Strings = (
      'TABLE_NAME')
    GridLineWidth = 0
    RowLines = False
    IndicateOrdering = False
    IndicateRow = False
    IndicateHighlight = False
    IndicateTitles = False
    Ctl3DShallow = True
    NavigateOptions = [gnBrowseAlwaysNavigate]
    TabMovesOut = True
  end
  object Panel1: TPanel
    Left = 0
    Top = 209
    Width = 279
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btAdd: TButton
      Left = 4
      Top = 6
      Width = 75
      Height = 25
      Caption = 'A&dd'
      TabOrder = 0
      OnClick = btAddClick
    end
    object btAddAll: TButton
      Left = 88
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Add &All'
      TabOrder = 1
      OnClick = btAddAllClick
    end
    object btClose: TButton
      Left = 173
      Top = 6
      Width = 75
      Height = 25
      Cancel = True
      Caption = '&Close'
      ModalResult = 2
      TabOrder = 2
    end
  end
  object pnlFilter: TPanel
    Left = 0
    Top = 18
    Width = 279
    Height = 31
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      279
      31)
    object cmbFilter: TComboBox
      Left = 2
      Top = 5
      Width = 221
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 0
      OnEnter = cmbFilterEnter
      OnExit = cmbFilterExit
      OnKeyDown = cmbFilterKeyDown
    end
    object tlbFilter: TToolBar
      Left = 230
      Top = 3
      Width = 47
      Height = 25
      Align = alNone
      Anchors = [akTop, akRight]
      Caption = 'tlbFilter'
      EdgeBorders = []
      Flat = True
      Images = fmMain.ilMain
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      object ToolButton2: TToolButton
        Left = 0
        Top = 0
        Action = actClearFilter
      end
      object ToolButton1: TToolButton
        Left = 23
        Top = 0
        Action = actPermanentFilter
      end
    end
  end
  object dsTables: TIB_DataSource
    Dataset = qrTables
    Left = 64
    Top = 80
  end
  object qrTables: TIB_Query
    DatabaseName = 'c:\delphi\infis\data\infis_cz.gdb'
    SQL.Strings = (
      'SELECT RDB$RELATION_NAME AS TABLE_NAME'
      'FROM RDB$RELATIONS'
      'WHERE (RDB$SYSTEM_FLAG <> 1) '
      'ORDER BY RDB$RELATION_NAME')
    OnPrepareSQL = qrTablesPrepareSQL
    AutoFetchAll = True
    ColorScheme = False
    MasterSearchFlags = [msfOpenMasterOnOpen, msfSearchAppliesToMasterOnly]
    OrderingItemNo = 1
    OrderingItems.Strings = (
      'Table Name=RDB$RELATION_NAME ASC')
    OrderingLinks.Strings = (
      'RDB$RELATION_NAME=Item=1')
    ReadOnly = True
    BufferSynchroFlags = []
    FetchWholeRows = True
    IsTree = False
    Left = 56
    Top = 72
    ParamValues = (
      'TABLE_LIST='#39'PERSON'#39','#39'COMPANY'#39'             ')
  end
  object FormStorage: TFormStorage
    IniSection = 'AddTable'
    StoredValues = <>
    Left = 112
    Top = 72
  end
  object alAddTable: TActionList
    Images = fmMain.ilMain
    Left = 160
    Top = 72
    object actClearFilter: TAction
      Caption = 'Clear Immediate Filter'
      Enabled = False
      Hint = 'Clear Immediate Filter'
      ImageIndex = 27
      ShortCut = 32835
      OnExecute = actClearFilterExecute
    end
    object actPermanentFilter: TAction
      AutoCheck = True
      Caption = 'Toggle Permanent Filter'
      Hint = 'Toggle Permanent Filter'
      ImageIndex = 28
      ShortCut = 32848
      OnExecute = actPermanentFilterExecute
    end
  end
end
