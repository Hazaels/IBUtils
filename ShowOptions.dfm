object fmShowOptions: TfmShowOptions
  Left = 131
  Top = 112
  BorderStyle = bsDialog
  BorderWidth = 4
  Caption = 'Model options'
  ClientHeight = 432
  ClientWidth = 387
  Color = clBtnFace
  Constraints.MinHeight = 273
  Constraints.MinWidth = 347
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnCreate = FormCreate
  DesignSize = (
    387
    432)
  PixelsPerInch = 96
  TextHeight = 13
  object btCancel: TButton
    Left = 310
    Top = 405
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 0
  end
  object btOk: TButton
    Left = 227
    Top = 405
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object pgMain: TPageControl
    Left = 0
    Top = 0
    Width = 387
    Height = 399
    ActivePage = tsGeneral
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 2
    object tsGeneral: TTabSheet
      Caption = '&General'
      DesignSize = (
        379
        371)
      object AKLabel1: TAKLabel
        Left = 0
        Top = 229
        Width = 379
        Height = 18
        Hint = 'These option are considered when adding new tables'
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = '  Default Show Options:'
        Color = clAppWorkSpace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clHighlightText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Layout = tlCenter
      end
      object Label1: TLabel
        Left = 8
        Top = 17
        Width = 47
        Height = 13
        Caption = 'Pr&int Title:'
      end
      object Label6: TLabel
        Left = 8
        Top = 40
        Width = 49
        Height = 13
        Caption = 'Data&base:'
      end
      object Label10: TLabel
        Left = 192
        Top = 66
        Width = 49
        Height = 13
        Caption = 'Pass&word:'
        FocusControl = edPassword
      end
      object Label11: TLabel
        Left = 8
        Top = 65
        Width = 51
        Height = 13
        Caption = '&Username:'
        FocusControl = edUsername
      end
      object AKLabel4: TAKLabel
        Left = 0
        Top = 118
        Width = 379
        Height = 18
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = '  Grid options:'
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
      object gbShowOptions: TGroupBox
        Left = 0
        Top = 247
        Width = 377
        Height = 123
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 5
        object Label7: TLabel
          Left = 16
          Top = 92
          Width = 109
          Height = 13
          Caption = 'Default columns &count:'
          FocusControl = edDefColCount
        end
        object chkTypes: TCheckBox
          Tag = 1
          Left = 16
          Top = 16
          Width = 97
          Height = 17
          Caption = 'Field &Types'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object chkDomains: TCheckBox
          Tag = 2
          Left = 16
          Top = 37
          Width = 97
          Height = 17
          Caption = 'Field &Domains'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object chkRequired: TCheckBox
          Tag = 5
          Left = 136
          Top = 16
          Width = 113
          Height = 17
          Caption = '&Required Fields'
          Checked = True
          State = cbChecked
          TabOrder = 3
        end
        object chkIcons: TCheckBox
          Tag = 6
          Left = 136
          Top = 37
          Width = 97
          Height = 17
          Caption = 'Show &Icons'
          Checked = True
          State = cbChecked
          TabOrder = 4
        end
        object chkKeysOnly: TCheckBox
          Tag = 7
          Left = 136
          Top = 58
          Width = 97
          Height = 17
          Caption = '&Key fields only'
          TabOrder = 5
        end
        object chkComputedBy: TCheckBox
          Tag = 3
          Left = 16
          Top = 58
          Width = 97
          Height = 17
          Caption = 'Computed &By'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object chkHeader: TCheckBox
          Tag = 8
          Left = 256
          Top = 37
          Width = 65
          Height = 17
          Caption = '&Header'
          TabOrder = 7
        end
        object edDefColCount: TEdit
          Left = 136
          Top = 88
          Width = 41
          Height = 21
          Hint = 
            'Width of new table added to model will be adjusted to display 1,' +
            '2,3 or 4 columns. Depends also on other Default show options.'
          TabOrder = 8
          Text = '1'
        end
        object udDefColCount: TUpDown
          Left = 177
          Top = 88
          Width = 15
          Height = 21
          Associate = edDefColCount
          Min = 1
          Max = 4
          Position = 1
          TabOrder = 9
        end
        object chkIndexCount: TCheckBox
          Tag = 4
          Left = 256
          Top = 16
          Width = 97
          Height = 17
          Caption = 'Index Count'
          Checked = True
          State = cbChecked
          TabOrder = 6
        end
      end
      object edModelTitle: TEdit
        Left = 64
        Top = 13
        Width = 305
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
      end
      object edDatabase: TFilenameEdit
        Left = 64
        Top = 38
        Width = 305
        Height = 21
        Hint = 
          'This database is filled in the Connect dialog. User name and met' +
          'adata log file is used according to the registered database name' +
          '.'
        NumGlyphs = 1
        TabOrder = 1
      end
      object edPassword: TEdit
        Left = 248
        Top = 62
        Width = 121
        Height = 21
        PasswordChar = '*'
        TabOrder = 3
      end
      object edUsername: TEdit
        Left = 64
        Top = 62
        Width = 121
        Height = 21
        TabOrder = 2
      end
      object gbGrid: TGroupBox
        Left = 0
        Top = 136
        Width = 377
        Height = 82
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 4
        object Label8: TLabel
          Left = 237
          Top = 21
          Width = 10
          Height = 13
          Caption = '&X:'
        end
        object Label9: TLabel
          Left = 305
          Top = 21
          Width = 10
          Height = 13
          Caption = '&Y:'
        end
        object chkSnapToGrid: TCheckBox
          Left = 16
          Top = 35
          Width = 140
          Height = 17
          Caption = 'Sna&p tables to grid'
          TabOrder = 0
        end
        object edGridX: TEdit
          Left = 251
          Top = 19
          Width = 30
          Height = 21
          TabOrder = 1
          Text = '8'
        end
        object edGridY: TEdit
          Left = 318
          Top = 19
          Width = 30
          Height = 21
          TabOrder = 2
          Text = '8'
        end
        object udGridX: TUpDown
          Left = 281
          Top = 19
          Width = 15
          Height = 21
          Associate = edGridX
          Min = 1
          Position = 8
          TabOrder = 3
        end
        object udGridY: TUpDown
          Left = 348
          Top = 19
          Width = 15
          Height = 21
          Associate = edGridY
          Min = 1
          Position = 8
          TabOrder = 4
        end
        object chkSnapRelToGrid: TCheckBox
          Left = 16
          Top = 54
          Width = 123
          Height = 17
          Caption = 'Snap relation&s to grid'
          TabOrder = 5
        end
        object chkShowGrid: TCheckBox
          Left = 16
          Top = 16
          Width = 97
          Height = 17
          Caption = 'Sho&w grid'
          TabOrder = 6
        end
      end
      object chkShowSystemDomains: TCheckBox
        Left = 64
        Top = 91
        Width = 153
        Height = 17
        Caption = 'Show System Domains'
        TabOrder = 6
      end
      object chkCombinedTypeDomain: TCheckBox
        Left = 227
        Top = 91
        Width = 145
        Height = 17
        Caption = 'Combined Type/Domains'
        TabOrder = 7
      end
    end
    object tsColors: TTabSheet
      Caption = 'Colors'
      ImageIndex = 2
      object AKLabel3: TAKLabel
        Left = 0
        Top = 0
        Width = 379
        Height = 18
        Hint = 'These option are considered when adding new tables'
        Align = alTop
        AutoSize = False
        Caption = '  Link colors:'
        Color = clAppWorkSpace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clHighlightText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Layout = tlCenter
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 18
        Width = 379
        Height = 132
        Align = alTop
        TabOrder = 0
        object Label2: TLabel
          Left = 16
          Top = 24
          Width = 37
          Height = 13
          Caption = 'Default:'
        end
        object Label3: TLabel
          Left = 16
          Top = 48
          Width = 45
          Height = 13
          Caption = 'Selected:'
        end
        object Label4: TLabel
          Left = 16
          Top = 72
          Width = 44
          Height = 13
          Caption = 'Focused:'
        end
        object Label5: TLabel
          Left = 16
          Top = 96
          Width = 57
          Height = 13
          Caption = 'Custom link:'
        end
        object cmbLinkColorSelected: TColorBox
          Left = 116
          Top = 44
          Width = 145
          Height = 22
          Selected = clRed
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
          ItemHeight = 16
          TabOrder = 0
        end
        object cmbLinkColorDefault: TColorBox
          Left = 116
          Top = 20
          Width = 145
          Height = 22
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
          ItemHeight = 16
          TabOrder = 1
        end
        object cmbLinkColorFocused: TColorBox
          Left = 116
          Top = 68
          Width = 145
          Height = 22
          Selected = clBlue
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
          ItemHeight = 16
          TabOrder = 2
        end
        object cmbLinkColorCustom: TColorBox
          Left = 116
          Top = 92
          Width = 145
          Height = 22
          Selected = clGreen
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
          ItemHeight = 16
          TabOrder = 3
        end
      end
    end
    object tsAddTable: TTabSheet
      Caption = '&Add Table'
      ImageIndex = 1
      object AKLabel2: TAKLabel
        Left = 0
        Top = 0
        Width = 379
        Height = 18
        Align = alTop
        AutoSize = False
        Caption = '   Permanent filter:'
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
      object moTablesFilter: TMemo
        Left = 0
        Top = 18
        Width = 379
        Height = 353
        Hint = 
          'Hint: the table list is retrieved by the following query:'#13#10'SELEC' +
          'T RDB$RELATION_NAME AS TABLE_NAME'#13#10'FROM RDB$RELATIONS'#13#10'WHERE (RD' +
          'B$SYSTEM_FLAG <> 1) '#13#10'ORDER BY RDB$RELATION_NAME'#13#10'You can specif' +
          'y additional filter, for example'#13#10'RDB$RELATION_NAME NOT CONTAINI' +
          'NG '#39'$'#39#13#10'AND RDB$RELATION_NAME LIKE '#39'MYTABLE%'#39
        Align = alClient
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        WantReturns = False
      end
    end
  end
end
