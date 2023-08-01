object fmPrinterSetup: TfmPrinterSetup
  Left = 166
  Top = 127
  ActiveControl = btPreview
  BorderStyle = bsDialog
  Caption = 'Printer Setup'
  ClientHeight = 443
  ClientWidth = 429
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnClose = FormClose
  OnShow = FormShow
  DesignSize = (
    429
    443)
  PixelsPerInch = 96
  TextHeight = 13
  object Label5: TLabel
    Left = 8
    Top = 18
    Width = 33
    Height = 13
    Caption = '&Printer:'
    FocusControl = cmbPrinters
    ParentShowHint = False
    ShowHint = True
  end
  object cmbPrinters: TComboBox
    Left = 48
    Top = 16
    Width = 284
    Height = 21
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnChange = cmbPrintersChange
  end
  object btCancel: TButton
    Left = 347
    Top = 44
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = 'Ca&ncel'
    ModalResult = 2
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 47
    Width = 153
    Height = 147
    Caption = 'Page &Borders:'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    object Label1: TLabel
      Left = 12
      Top = 28
      Width = 21
      Height = 13
      Caption = 'Le&ft:'
      FocusControl = edLeft
    end
    object Label2: TLabel
      Left = 12
      Top = 54
      Width = 28
      Height = 13
      Caption = '&Right:'
      FocusControl = edRight
    end
    object Label3: TLabel
      Left = 12
      Top = 79
      Width = 22
      Height = 13
      Caption = '&Top:'
      FocusControl = edTop
    end
    object Label4: TLabel
      Left = 12
      Top = 105
      Width = 36
      Height = 13
      Caption = '&Bottom:'
      FocusControl = edBottom
    end
    object edLeft: TEdit
      Left = 64
      Top = 25
      Width = 50
      Height = 21
      TabOrder = 0
      Text = '10'
      OnClick = edLeftClick
    end
    object edRight: TEdit
      Left = 64
      Top = 50
      Width = 50
      Height = 21
      TabOrder = 1
      Text = '10'
      OnClick = edLeftClick
    end
    object edTop: TEdit
      Left = 64
      Top = 75
      Width = 50
      Height = 21
      TabOrder = 2
      Text = '10'
      OnClick = edLeftClick
    end
    object edBottom: TEdit
      Left = 64
      Top = 100
      Width = 50
      Height = 21
      TabOrder = 3
      Text = '10'
      OnClick = edLeftClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 168
    Top = 47
    Width = 161
    Height = 186
    Caption = '&Paper'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    object Label6: TLabel
      Left = 12
      Top = 28
      Width = 31
      Height = 13
      Caption = '&Width:'
      FocusControl = edWidth
    end
    object Label7: TLabel
      Left = 12
      Top = 51
      Width = 34
      Height = 13
      Caption = '&Heigth:'
      FocusControl = edHeight
    end
    object Label8: TLabel
      Left = 12
      Top = 157
      Width = 35
      Height = 13
      Caption = '&Copies:'
    end
    object edWidth: TEdit
      Left = 62
      Top = 25
      Width = 50
      Height = 21
      TabOrder = 0
      Text = '210'
      OnChange = edWidthChange
      OnClick = edLeftClick
    end
    object edHeight: TEdit
      Left = 62
      Top = 49
      Width = 50
      Height = 21
      TabOrder = 1
      Text = '297'
      OnChange = edWidthChange
      OnClick = edLeftClick
    end
    object edCopies: TEdit
      Left = 62
      Top = 153
      Width = 50
      Height = 21
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Text = '1'
      OnClick = edLeftClick
    end
    object rgOrientation: TRadioGroup
      Left = 8
      Top = 80
      Width = 113
      Height = 65
      Caption = '&Orientation'
      ItemIndex = 0
      Items.Strings = (
        'Portrait'
        'Landscape')
      TabOrder = 3
      OnClick = rgOrientationClick
    end
  end
  object btPreview: TButton
    Left = 347
    Top = 15
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Pre&view'
    Default = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = btPreviewClick
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 235
    Width = 321
    Height = 108
    Caption = '&Title'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    object chkPrintTitle: TCheckBox
      Left = 12
      Top = 19
      Width = 109
      Height = 17
      Hint = 'Print Model Title'
      Caption = 'Print Model Titl&e'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = chkPrintTitleClick
    end
    object cmbFont: TFontComboBox
      Left = 12
      Top = 44
      Width = 183
      Height = 20
      TabOrder = 1
    end
    object cmbFontSize: TComboBox
      Left = 140
      Top = 71
      Width = 55
      Height = 21
      ItemHeight = 13
      TabOrder = 2
      Text = '12'
      Items.Strings = (
        '8'
        '10'
        '12'
        '14'
        '16'
        '18'
        '20'
        '24'
        '28'
        '36'
        '42'
        '50'
        '64'
        '72')
    end
    object chkBold: TCheckBox
      Left = 221
      Top = 43
      Width = 77
      Height = 17
      Caption = 'Bol&d'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object chkItalic: TCheckBox
      Left = 221
      Top = 59
      Width = 77
      Height = 17
      Caption = '&Italic'
      TabOrder = 4
    end
    object chkUnderline: TCheckBox
      Left = 221
      Top = 75
      Width = 77
      Height = 17
      Caption = '&Underline'
      TabOrder = 5
    end
    object cmbFontColor: TColorBox
      Left = 12
      Top = 71
      Width = 120
      Height = 22
      Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
      ItemHeight = 16
      TabOrder = 6
    end
  end
  object GroupBox4: TGroupBox
    Left = 8
    Top = 347
    Width = 321
    Height = 81
    Caption = 'B&order && Background'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    object chkPrintBorder: TCheckBox
      Left = 12
      Top = 24
      Width = 97
      Height = 17
      Hint = 'Print model border'
      Caption = 'Print B&order'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 0
      OnClick = chkPrintBorderClick
    end
    object chkPrintDifferentBgColor: TCheckBox
      Left = 12
      Top = 48
      Width = 185
      Height = 17
      Hint = 
        'You can set different background color for printing to save your' +
        ' printer ink (set to white color for example)'
      Caption = 'Print Different Background Color'
      TabOrder = 1
      OnClick = chkPrintDifferentBgColorClick
    end
    object cmbBorderColor: TColorBox
      Left = 189
      Top = 21
      Width = 120
      Height = 22
      Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
      ItemHeight = 16
      TabOrder = 2
    end
    object cmbBgColor: TColorBox
      Left = 189
      Top = 46
      Width = 120
      Height = 22
      Selected = clWhite
      Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
      ItemHeight = 16
      TabOrder = 3
    end
  end
  object chkStretchToPage: TCheckBox
    Left = 20
    Top = 211
    Width = 124
    Height = 17
    Hint = 'Stretches the model image to fit to 1 page'
    Caption = 'Stretch To 1 page'
    TabOrder = 7
  end
  object PreviewFormStorage: TFormStorage
    Active = False
    IniSection = 'PrinterSetup'
    StoredProps.Strings = (
      'cmbFont.FontName'
      'cmbFontSize.Text'
      'cmbPrinters.Text'
      'edBottom.Text'
      'edCopies.Text'
      'edHeight.Text'
      'edLeft.Text'
      'edRight.Text'
      'edTop.Text'
      'edWidth.Text'
      'chkBold.Checked'
      'chkItalic.Checked'
      'chkPrintBorder.Checked'
      'chkPrintDifferentBgColor.Checked'
      'chkPrintTitle.Checked'
      'chkStretchToPage.Checked'
      'chkUnderline.Checked'
      'cmbBorderColor.Selected'
      'rgOrientation.ItemIndex')
    StoredValues = <>
    Left = 368
    Top = 168
  end
end
