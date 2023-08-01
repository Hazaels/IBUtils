inherited fraNote: TfraNote
  inherited pnlMain: TPanel
    PopupMenu = popTable
    DesignSize = (
      142
      178)
    object lblNoteName: TLabel
      Left = 5
      Top = 5
      Width = 131
      Height = 13
      Hint = 'Dbl Click to change title'
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'lblNoteName'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      PopupMenu = popTable
      ShowHint = True
      OnDblClick = lblNoteNameDblClick
      OnMouseDown = lblNoteNameMouseDown
      OnMouseMove = lblNoteNameMouseMove
      OnMouseUp = lblNoteNameMouseUp
    end
    object Memo: TMemo
      Left = 5
      Top = 21
      Width = 132
      Height = 152
      Anchors = [akLeft, akTop, akRight, akBottom]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnChange = MemoChange
      OnMouseDown = MemoMouseDown
      OnMouseMove = MemoMouseMove
      OnMouseUp = MemoMouseUp
    end
  end
  object popTable: TPopupMenu
    OnPopup = popTablePopup
    Left = 72
    Top = 56
    object mniTitleOnly: TMenuItem
      Tag = 7
      Caption = 'Title Only'
      OnClick = mniTitleOnlyClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mniColor: TMenuItem
      Caption = 'Color'
      Hint = 'Set tables color'
    end
    object mniDeleteTable: TMenuItem
      Caption = 'Delete Object'
      Hint = 'Delete object(s) from model'
      ImageIndex = 5
      ShortCut = 46
    end
  end
end
