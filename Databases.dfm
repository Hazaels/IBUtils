object fmDatabases: TfmDatabases
  Left = 311
  Top = 203
  ActiveControl = lvDatabases
  BorderStyle = bsToolWindow
  BorderWidth = 4
  Caption = 'Registered Databases'
  ClientHeight = 315
  ClientWidth = 526
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    526
    315)
  PixelsPerInch = 96
  TextHeight = 13
  object AKLabel1: TAKLabel
    Left = 0
    Top = 0
    Width = 526
    Height = 18
    Align = alTop
    AutoSize = False
    Caption = '   List of registered databases:'
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
  object Label1: TLabel
    Left = 2
    Top = 215
    Width = 31
    Height = 13
    Caption = 'Name:'
  end
  object Label2: TLabel
    Left = 2
    Top = 240
    Width = 86
    Height = 13
    Caption = 'Database or Alias:'
  end
  object Label3: TLabel
    Left = 293
    Top = 215
    Width = 25
    Height = 13
    Caption = 'User:'
  end
  object Label4: TLabel
    Left = 2
    Top = 264
    Width = 65
    Height = 13
    Caption = 'Metadata log:'
  end
  object lvDatabases: TListView
    Left = 0
    Top = 23
    Width = 526
    Height = 148
    Anchors = [akLeft, akTop, akRight]
    Columns = <
      item
        Caption = 'Name'
        Width = 100
      end
      item
        Caption = 'Database or Alias'
        Width = 300
      end
      item
        Caption = 'User'
        Width = 80
      end
      item
        Caption = 'Metadata Log'
        Width = 200
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnClick = lvDatabasesClick
    OnDblClick = lvDatabasesDblClick
    OnKeyDown = lvDatabasesKeyDown
  end
  object edDatabase: TFilenameEdit
    Left = 96
    Top = 236
    Width = 427
    Height = 21
    Hint = 'Full path to database or Alias from the aliases.conf file'
    NumGlyphs = 1
    TabOrder = 5
    OnChange = edAliasChange
  end
  object edAlias: TEdit
    Left = 96
    Top = 212
    Width = 177
    Height = 21
    TabOrder = 3
    OnChange = edAliasChange
  end
  object edUser: TEdit
    Left = 324
    Top = 212
    Width = 199
    Height = 21
    Hint = 'This user name is filled in the connect dialog'
    TabOrder = 4
    OnChange = edAliasChange
  end
  object btReplace: TButton
    Left = 207
    Top = 290
    Width = 75
    Height = 25
    Caption = '&Replace'
    Enabled = False
    TabOrder = 6
    OnClick = btReplaceClick
  end
  object btAdd: TButton
    Left = 287
    Top = 290
    Width = 75
    Height = 25
    Caption = '&Add'
    Enabled = False
    TabOrder = 7
    OnClick = btAddClick
  end
  object btDelete: TButton
    Left = 367
    Top = 290
    Width = 75
    Height = 25
    Caption = '&Delete'
    TabOrder = 8
    OnClick = btDeleteClick
  end
  object btClose: TButton
    Left = 447
    Top = 290
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Close'
    ModalResult = 2
    TabOrder = 9
  end
  object btConnect: TButton
    Left = 448
    Top = 180
    Width = 75
    Height = 25
    Caption = 'Connec&t'
    Default = True
    ModalResult = 1
    TabOrder = 2
    OnClick = btConnectClick
  end
  object btMoreLess: TButton
    Left = 368
    Top = 180
    Width = 75
    Height = 25
    Caption = '<< Le&ss'
    TabOrder = 1
    OnClick = btMoreLessClick
  end
  object edMetadataLog: TFilenameEdit
    Left = 96
    Top = 260
    Width = 427
    Height = 21
    Hint = 
      'Every change to the model is logged into this file (as SQL scrip' +
      't with DDL commands)'
    NumGlyphs = 1
    TabOrder = 10
    OnChange = edAliasChange
  end
end
