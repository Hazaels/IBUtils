object fmAbout: TfmAbout
  Left = 333
  Top = 264
  BorderStyle = bsDialog
  BorderWidth = 4
  Caption = 'About'
  ClientHeight = 192
  ClientWidth = 309
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  DesignSize = (
    309
    192)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 309
    Height = 161
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
  end
  object Label1: TLabel
    Left = 24
    Top = 20
    Width = 63
    Height = 20
    Caption = 'IB Utils'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblVerzeAplikace: TLabel
    Left = 104
    Top = 25
    Width = 3
    Height = 13
  end
  object Label3: TLabel
    Left = 24
    Top = 56
    Width = 211
    Height = 13
    Caption = 'Free InterBase/Firebird tool by Ales Kahanek'
  end
  object lblMail: TLabel
    Left = 23
    Top = 72
    Width = 109
    Height = 13
    Cursor = crHandPoint
    Caption = 'akahanek@seznam.cz'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblMailClick
  end
  object lblWeb: TLabel
    Left = 24
    Top = 88
    Width = 195
    Height = 13
    Cursor = crHandPoint
    Caption = 'http://www.riverdata.cz/ibutils/ibutils.htm'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblWebClick
  end
  object Image1: TImage
    Left = 200
    Top = 16
    Width = 41
    Height = 38
    Picture.Data = {
      055449636F6E0000010001002020000000000000A80800001600000028000000
      2000000040000000010008000000000080040000000000000000000000010000
      00000000040204000482D4009C9A9C0084E2FC00046AB40004CEFC00FC9E9C00
      44D6FC0054020400FCC2C400A4A2A4000402840064DEFC0004FEFC007C424400
      3C3EB400A4A2FC000402B400A4EAFC00FCB2AC00CCFAFC008482FC0064FAFC00
      0492EC0084F6F40024D2FC0044FAFC004422240024FEFC006C6EFC000476C400
      FCD2D400B4B2B4009492FC006432340004029C000406CC00FCBABC00FCAAAC00
      ACAEF400747AFC0024020400048AE40094E6FC0014CEFC0054DAFC0074E2FC00
      0406C400FCE2E40074F6F40034FEFC00047ECC00FCDAD400FCA6A400ACAAAC00
      14FEFC000406B400A4F6F400FCB6BC008C8AFC00049AFC0094F6F40034D6FC00
      54FAFC00542A2C00BCBABC009C9AFC00743A3C000402AC003C1E1C00FCFEFC00
      0486DC008CE2FC000472BC00FCA29C004CDAFC00FCCECC00040294006CDEFC00
      B4727400ACAAFC00B4EAFC00FCB6B4000496FC007476FC00047AC400FCBEBC00
      B4B2F4007C7AFC001CD2FC00FCEEEC007CFAF4003CFAFC00FCDEDC000482DC00
      9C9E9C00046EB4000CCEFC0044DAFC00FCC6C400A4A6A40004028C000CFEFC00
      84424400A4A6FC000402BC00ACEAFC00FCB2B4008486FC006CFAFC000492F400
      8CF6F4002CD2FC004CFAFC004C2624002CFEFC007472FC00FCD6D400B4B6B400
      9496FC006C3634000402A4000406D400FCAEAC00ACAEFC0034020400048EEC00
      9CE6FC0014D2FC005CDEFC005C2E2C007C3E3C007CE2FC001CFEFC009CF6F400
      3CD6FC005CFAFC0074FAFC003C222400FCE6E400ACAEAC008C8EFC00BCBEBC00
      9C9EFC000406AC008CE6FC006CE2FC007C7EFC003CFEFC00047ED400FCDADC00
      0406BC00FCA2A400047ACC00FCBEC4000000000080820000F100F10012001200
      00000000EB680000BEF00000F81200007700000006D68700BF560100F8F40000
      7777000008BE230006569C0013F400000077000038A020000080F1009CF7ED00
      0077770089000000B8400000E8009C0077000000005820000010E300130A1300
      00AB000018792000F946F90013F4130000770000F49DBA00B77A1900E8E1E200
      777777003C40280000930C009CE60000007700003C827800000001009C001300
      000000003874E80000CCEC009C681300000000000147F0000078EC0000E21300
      00770000503A3800F1040C00123E00000000000050001800FB00F90012001300
      000000005043CC00FB00ED001200120000000000FD016C001300F100EA001200
      77000000A0012000B800F100E800120077000000FF00DB00FF008000FF00FB00
      FF00770038001000BC0003001300F900000077007300FF000000FF004200FF00
      0000FF0038013000BC00F100130012000000000087010400C200AC00E900FC00
      77007700F4000000B7000000E8001300770000001CBC090003F003003E121000
      000000009B9B9B9B9B9B9B9B00008E41209B9B9B9B9B9B9B9B9B00008E8E419B
      9B9B9B9B9B9B9B9B9B9B0000136700208C649B9B9B9B9B9B00008D2400414176
      9B9B9B9B9B9B9B9B0000256B7B676700645F029B9B9B00008F218D2424007620
      8C9B9B9B9B9B000056256B13266767830002020200006810778D6C242469008C
      8C369B9B0000635656526B7B266767438200000027501042213B15692F2F6900
      36640A9B00630956256B1326356783227245002727688F213B15589797693811
      000A0A5F00095625526B7B35356722821B450027508F778D6C93743811381138
      44005F020009563A6B7B263506438272452900111042213B93581D3811384490
      79009B9B005625526B26359806224045457D007979218D1558741D4444444479
      79009B9B0025526B7B26350606401B457D7D00234D0B6C93541D1D7990799079
      23009B9B00526B7B2635985A5A834545087D000B00000B547427507979232323
      23009B9B00526B7B265A5A305D5D43457D0800000C53000F50108F772323234D
      4D009B9B006B7B5A5A30305D96964F0E7D00840C2D3C3C000F8F4277774D4D65
      65299B9B005A5A8B305D5D96964F00002B034E81073C536E000F77218D6C6565
      65009B9B00308B305D5D961F00006A7F032E0C2D873C536E7E000F8D3B6C150B
      65009B9B9B00305D9675751F296A1248840C2D8770536E7E2A01000F6C935828
      0B009B9B9B9B0096751F4C4C00122B034E81073E59537E2A019555000F935800
      009B9B9B9B9B9B001F4C4C4C007F032E814B87192C7E2A5E01991E000F00009B
      9B9B9B9B9B9B9B9B004C4C4C00482E0C2D871980612A4701331E4900009B9B9B
      9B9B9B9B9B9B9B9B9B004C0000844E2D073E5961054701951E4960009B9B9B9B
      9B9B9B9B9B9B9B9B9B9B009B004E814B3E592C14145E951E496060009B9B9B9B
      9B9B9B9B9B9B9B9B9B9B9B9B000C4B8719141439866F551E490404009B9B9B9B
      9B9B9B9B9B9B9B9B9B9B9B9B002D87141439393D6F311660600404009B9B9B9B
      9B9B9B9B9B9B9B9B9B9B9B9B0014143912393D183116715C040404009B9B9B9B
      9B9B9B9B9B9B9B9B9B9B9B9B00393939866F186D88715C1C376004009B9B9B9B
      9B9B9B9B9B9B9B9B9B9B9B9B9B0039866F5B16881A321C370D0D04009B9B9B9B
      9B9B9B9B9B9B9B9B9B9B9B9B9B9B00185B163F1A3285660D0D00009B9B9B9B9B
      9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B00883F5C7337660D00009B9B9B9B9B9B9B
      9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B005C1C850D00009B9B9B9B9B9B9B9B9B
      9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B003700009B9B9B9B9B9B9B9B9B9B9B
      9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B009B9B9B9B9B9B9B9B9B9B9B9B9B
      9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B
      9B9B9B9BFF07FC1FFC03F00FF001C007C0000003000000010000000000000000
      0000000300000003000000030000000300000003000000030000000300000003
      80000003C0000007E000001FF000007FF80000FFFD0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF8000FFFFC001FFFFE007FFFFF01FFFFFF87FFFFFFDFFFF
      FFFFFFFF}
  end
  object Label4: TLabel
    Left = 24
    Top = 120
    Width = 265
    Height = 13
    Caption = 'With help of TPrintPreview v4.0 by Kambiz R. Khojasteh'
  end
  object Label5: TLabel
    Left = 24
    Top = 136
    Width = 116
    Height = 13
    Cursor = crHandPoint
    Caption = 'kambiz@delphiarea.com'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = Label5Click
  end
  object btOk: TButton
    Left = 233
    Top = 167
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 0
  end
end
