object fmPreview: TfmPreview
  Left = 191
  Top = 241
  Width = 600
  Height = 452
  Caption = 'Print Preview'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object PrintPreview: TPrintPreview
    Left = 0
    Top = 26
    Width = 592
    Height = 399
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 0
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnMouseWheelDown = PrintPreviewMouseWheelDown
    OnMouseWheelUp = PrintPreviewMouseWheelUp
    Units = mmPixel
    PaperView.ShadowWidth = 4
    ZoomState = zsZoomOther
    OnChange = PrintPreviewChange
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 592
    Height = 26
    Align = alTop
    BevelOuter = bvNone
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 1
    object ToolBar1: TToolBar
      Left = 0
      Top = 0
      Width = 592
      Height = 26
      Align = alClient
      BorderWidth = 1
      Caption = 'ToolBar1'
      EdgeBorders = []
      Flat = True
      Images = fmMain.ilMain
      Indent = 5
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      object Label1: TLabel
        Left = 5
        Top = 0
        Width = 42
        Height = 22
        Caption = '  Zoom:  '
        Layout = tlCenter
      end
      object cmbZoom: TComboBox
        Left = 47
        Top = 0
        Width = 105
        Height = 21
        ItemHeight = 13
        TabOrder = 0
        Text = '100'
        OnClick = cmbZoomClick
        OnKeyDown = cmbZoomKeyDown
        Items.Strings = (
          '50'
          '75'
          '100'
          '125'
          '150')
      end
      object Label2: TLabel
        Left = 152
        Top = 0
        Width = 14
        Height = 22
        Caption = ' % '
        Layout = tlCenter
      end
      object Label3: TLabel
        Left = 166
        Top = 0
        Width = 63
        Height = 22
        Caption = '     Page No: '
        Layout = tlCenter
      end
      object edPageNo: TEdit
        Left = 229
        Top = 0
        Width = 30
        Height = 22
        TabOrder = 1
        Text = '1'
        OnClick = edPageNoClick
        OnKeyDown = edPageNoKeyDown
      end
      object udPageNo: TUpDown
        Left = 259
        Top = 0
        Width = 16
        Height = 22
        Associate = edPageNo
        Min = 1
        Position = 1
        TabOrder = 2
        OnClick = udPageNoClick
      end
      object Label4: TLabel
        Left = 275
        Top = 0
        Width = 15
        Height = 22
        Caption = ' of '
        Layout = tlCenter
      end
      object lblTotalPages: TLabel
        Left = 290
        Top = 0
        Width = 11
        Height = 22
        Caption = ' x '
        Layout = tlCenter
      end
      object Label5: TLabel
        Left = 301
        Top = 0
        Width = 18
        Height = 22
        Caption = '      '
      end
      object tbPrint: TToolButton
        Left = 319
        Top = 0
        Hint = 'Print (P, Ctrl+P]'
        Caption = 'Print'
        ImageIndex = 14
        OnClick = tbPrintClick
      end
      object ToolButton2: TToolButton
        Left = 342
        Top = 0
        Width = 8
        Caption = 'ToolButton2'
        ImageIndex = 16
        Style = tbsSeparator
      end
      object tbExportToWMF: TToolButton
        Left = 350
        Top = 0
        Hint = 'Save current page as WMF (S, Ctrl+S)'
        Caption = 'tbExportToWMF'
        ImageIndex = 8
        OnClick = tbExportToWMFClick
      end
    end
  end
end
