inherited fraTable: TfraTable
  Width = 162
  Height = 232
  DesignSize = (
    162
    232)
  inherited pnlMain: TPanel
    Width = 162
    Height = 232
    TabOrder = 2
    OnDblClick = lblTableNameDblClick
    DesignSize = (
      162
      232)
    object lblTableName: TLabel
      Left = 4
      Top = 7
      Width = 155
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'lblTableName'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 16
      Font.Name = 'Arial'
      Font.Pitch = fpVariable
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      PopupMenu = popTable
      ShowHint = True
      Layout = tlCenter
      OnDblClick = lblTableNameDblClick
      OnMouseDown = lblTableNameMouseDown
      OnMouseMove = lblTableNameMouseMove
      OnMouseUp = lblTableNameMouseUp
    end
  end
  object Header: THeaderControl
    Left = 3
    Top = 24
    Width = 155
    Height = 17
    Align = alNone
    Anchors = [akLeft, akTop, akRight]
    FullDrag = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Sections = <
      item
        ImageIndex = -1
        Width = 50
      end>
    Style = hsFlat
    OnSectionResize = HeaderSectionResize
    ParentFont = False
    PopupMenu = popHeader
    OnMouseDown = HeaderMouseDown
  end
  object lbFields: TScrollListBox
    Left = 3
    Top = 39
    Width = 155
    Height = 190
    Style = lbOwnerDrawFixed
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 13
    MultiSelect = True
    ParentFont = False
    ParentShowHint = False
    PopupMenu = popTable
    ShowHint = True
    TabOrder = 0
    OnClick = lbFieldsClick
    OnDblClick = lbFieldsDblClick
    OnDragDrop = lbFieldsDragDrop
    OnDragOver = lbFieldsDragOver
    OnDrawItem = lbFieldsDrawItem
    OnKeyDown = lbFieldsKeyDown
    OnMouseDown = lbFieldsMouseDown
    OnMouseMove = lbFieldsMouseMove
    OnMouseUp = lbFieldsMouseUp
    OnStartDrag = lbFieldsStartDrag
    OnScroll = lbFieldsScroll
  end
  object popTable: TPopupMenu
    OnPopup = popTablePopup
    Left = 72
    Top = 56
    object mniTypes: TMenuItem
      Tag = 1
      Caption = 'Types'
      Checked = True
      ShortCut = 84
      OnClick = mniNamesClick
    end
    object mniDomains: TMenuItem
      Tag = 2
      Caption = 'Domains'
      Checked = True
      ShortCut = 68
      OnClick = mniNamesClick
    end
    object mniComputedBy: TMenuItem
      Tag = 3
      Caption = 'Computed By'
      Checked = True
      ShortCut = 66
      OnClick = mniNamesClick
    end
    object mniRequired: TMenuItem
      Tag = 5
      Caption = 'Required'
      Checked = True
      ShortCut = 82
      OnClick = mniNamesClick
    end
    object mniIcons: TMenuItem
      Tag = 6
      Caption = 'Icons'
      Checked = True
      OnClick = mniNamesClick
    end
    object mniIndexCount: TMenuItem
      Tag = 4
      Caption = 'Index Count'
      Checked = True
      ShortCut = 73
      OnClick = mniNamesClick
    end
    object mniKeysOnly: TMenuItem
      Tag = 7
      Caption = 'Keys Only'
      ShortCut = 75
      OnClick = mniNamesClick
    end
    object mniTitleOnly: TMenuItem
      Tag = 8
      Caption = 'Title Only'
      ShortCut = 76
      OnClick = mniNamesClick
    end
    object mniHeader: TMenuItem
      Tag = 9
      Caption = 'Header'
      ShortCut = 72
      OnClick = mniNamesClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mniColor: TMenuItem
      Caption = 'Color'
      Hint = 'Set tables color'
      ShortCut = 67
    end
    object mniDeleteTable: TMenuItem
      Caption = 'Delete Table'
      Hint = 'Delete table(s) from model'
      ImageIndex = 5
      ShortCut = 46
    end
    object mniRefresh: TMenuItem
      Caption = '&Refresh'
      OnClick = mniRefreshClick
    end
    object mniBrowse: TMenuItem
      Caption = 'Browse'
      ShortCut = 115
      OnClick = mniBrowseClick
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object mniAdjustCurrent2: TMenuItem
      Caption = 'Adjust Current Width'
      OnClick = mniAdjustCurrentClick
    end
    object mniAdjustAll2: TMenuItem
      Caption = 'Adjust All Widths'
      OnClick = mniAdjustAllClick
    end
    object mniArrange2: TMenuItem
      Caption = 'Adjust Table Size'
      OnClick = mniArrangeClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object mniCreateField: TMenuItem
      Caption = 'Create Field'
      ShortCut = 16462
      OnClick = mniCreateFieldClick
    end
    object mniDropField: TMenuItem
      Caption = 'Drop Field'
      OnClick = mniDropFieldClick
    end
    object mniIndexes: TMenuItem
      Caption = 'Indices ...'
      ShortCut = 16457
      OnClick = mniIndexesClick
    end
    object mniCreateIndex: TMenuItem
      Caption = 'Create Index'
      ShortCut = 24649
      OnClick = mniCreateIndexClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object mniMoveUp: TMenuItem
      Caption = 'Move Up'
      ShortCut = 16422
      OnClick = mniMoveUpClick
    end
    object mniMoveDown: TMenuItem
      Caption = 'Move Down'
      ShortCut = 16424
      OnClick = mniMoveDownClick
    end
  end
  object popHeader: TPopupMenu
    OnPopup = popHeaderPopup
    Left = 72
    Top = 88
    object mniAdjustCurrent: TMenuItem
      Caption = 'Adjust Current Width'
      OnClick = mniAdjustCurrentClick
    end
    object mniAdjustAll: TMenuItem
      Caption = 'Adjust All Widths'
      OnClick = mniAdjustAllClick
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object mniArrange: TMenuItem
      Caption = 'Adjust Table Size'
      OnClick = mniArrangeClick
    end
  end
end
