unit PrinterSetup;

{$I IBUtils.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, fraTable_u, RxCombos, Placemnt, fraMain_u;

type
  TfmPrinterSetup = class(TForm)
    cmbPrinters: TComboBox;
    btCancel: TButton;
    GroupBox1: TGroupBox;
    edLeft: TEdit;
    edRight: TEdit;
    edTop: TEdit;
    edBottom: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    GroupBox2: TGroupBox;
    edWidth: TEdit;
    edHeight: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    btPreview: TButton;
    Label8: TLabel;
    GroupBox3: TGroupBox;
    chkPrintTitle: TCheckBox;
    cmbFont: TFontComboBox;
    cmbFontSize: TComboBox;
    chkBold: TCheckBox;
    chkItalic: TCheckBox;
    chkUnderline: TCheckBox;
    GroupBox4: TGroupBox;
    chkPrintBorder: TCheckBox;
    chkPrintDifferentBgColor: TCheckBox;
    edCopies: TEdit;
    chkStretchToPage: TCheckBox;
    PreviewFormStorage: TFormStorage;
    cmbBorderColor: TColorBox;
    cmbBgColor: TColorBox;
    cmbFontColor: TColorBox;
    rgOrientation: TRadioGroup;
    procedure btPreviewClick(Sender: TObject);
    procedure btSwapClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cmbPrintersChange(Sender: TObject);
    procedure edLeftClick(Sender: TObject);
    procedure chkPrintTitleClick(Sender: TObject);
    procedure chkPrintBorderClick(Sender: TObject);
    procedure chkPrintDifferentBgColorClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rgOrientationClick(Sender: TObject);
    procedure edWidthChange(Sender: TObject);
  private
    { Private declarations }
  public
    Model: TModel;
  end;

var
  fmPrinterSetup: TfmPrinterSetup;

implementation

{$R *.dfm}

uses Printers, Preview_u, Preview, Math;

procedure TfmPrinterSetup.btPreviewClick(Sender: TObject);
var
  fmPreview: TfmPreview;
  bmp, bmpPage: TBitmap;
  img: TImage;
  w, h, nx, ny, wPage, hPage, wSource, hSource, wDest, hDest: Integer;
  i, j: Integer;
  nLeft, nTop, nRight, nBottom, nTitleSpace: integer;
  SavedColor: TColor;
begin
  fmPreview := TfmPreview.Create(Application);
  bmp := TBitmap.Create;
  bmpPage := TBitmap.Create;
  nTitleSpace := 0;                               //initialize only
  with fmPreview.PrintPreview do
  begin
    Printer.Copies := StrToIntDef(fmPrinterSetup.edCopies.Text, 1);
    Orientation := TPrinterOrientation(fmPrinterSetup.rgOrientation.ItemIndex);
    nLeft := StrToIntDef(fmPrinterSetup.edLeft.Text, 10) * 100;
    nRight := StrToIntDef(fmPrinterSetup.edRight.Text, 10) * 100;
    nTop := StrToIntDef(fmPrinterSetup.edTop.Text, 10) * 100;
    nBottom := StrToIntDef(fmPrinterSetup.edBottom.Text, 10) * 100;

    if chkPrintTitle.Checked and (Model.Title <> '') then
    begin
      nTitleSpace := ConvertUnit(StrToIntDef(cmbFontSize.Text, 12) + 20, mmPixel, mmHiMetric);
      nTop := nTop + nTitleSpace;                 //make space for title
    end;

    Units := mmHiMetric;

    PaperWidth := StrToIntDef(fmPrinterSetup.edWidth.Text, 210) * 100;
    PaperHeight := StrToIntDef(fmPrinterSetup.edHeight.Text, 297) * 100;

    wPage := PaperWidth - nLeft - nRight;
    hPage := PaperHeight - nTop - nBottom;
    Units := mmPixel;

    wPage := ConvertUnit(wPage, mmHiMetric, mmPixel);
    hPage := ConvertUnit(hPage, mmHiMetric, mmPixel);

    BeginDoc;
    w := Model.Width;
    h := Model.Height;
    bmp.Width := w;
    bmp.Height := h;
    bmpPage.Width := wPage;
    bmpPage.Height := hPage;
    if chkStretchToPage.Checked then
    begin
      nx := 1;               //horizontal screens count
      ny := 1;               //vertical screens count
      wSource := w;
      hSource := h;
      if (wSource/wPage) > (hSource/hPage) then  //adjust to width
      begin
        wDest := wPage;
        hDest := Round(hSource * (wPage/wSource));
      end
      else                                      //adjust to height
      begin
        wDest := Round(wSource * (hPage/hSource));
        hDest := hPage;
      end;
    end
    else
    begin
      nx := Round((w / wPage) + 0.5);               //horizontal screens count
      ny := Round((h / hPage) + 0.5);               //vertical screens count
      wSource := wPage;
      hSource := hPage;
      wDest := wPage;
      hDest := hPage;
    end;

    try
      SavedColor := TModel(Model).Color;
      if chkPrintDifferentBgColor.Checked then
        TModel(Model).Color := cmbBgColor.Selected;
      TModel(Model).PaintTo(bmp.Canvas, 0, 0);
    finally
      TModel(Model).Color := SavedColor;
    end;

    if chkPrintBorder.Checked then
    begin
      with bmp.Canvas do
      begin
        Brush.Color := cmbBorderColor.Selected;
        Brush.Style := bsSolid;
        FrameRect(ClipRect);
      end;
    end;

    for i := 0 to nx - 1 do
    begin
      for j := 0 to ny - 1 do
      begin
        StretchBlt(bmpPage.Canvas.Handle, 0, 0, wDest, hDest,
          bmp.Canvas.Handle, i * wPage, j * hPage, wSource + 1, hSource + 1, SRCCOPY); //draw to aux. bitmap
        Canvas.Draw(ConvertUnit(nLeft, mmHiMetric, mmPixel),
          ConvertUnit(nTop, mmHiMetric, mmPixel),   bmpPage);              //draw to preview canvas
        if (i = 0) and (j = 0) and chkPrintTitle.Checked then
        begin
          Canvas.Font.Name := cmbFont.FontName;
          Canvas.Font.Size := StrToIntDef(cmbFontSize.Text, 12);
          Canvas.Font.Color := cmbFontColor.Selected;
          Canvas.Font.Style := [];
          if chkBold.Checked then
            Canvas.Font.Style := Canvas.Font.Style + [fsBold];
          if chkItalic.Checked then
            Canvas.Font.Style := Canvas.Font.Style + [fsItalic];
          if chkUnderline.Checked then
            Canvas.Font.Style := Canvas.Font.Style + [fsUnderline];
          Canvas.TextOut(ConvertUnit(nLeft, mmHiMetric, mmPixel),
            ConvertUnit(nTop - nTitleSpace, mmHiMetric, mmPixel),
            Model.Title);
        end;
        NewPage;
        with bmpPage.Canvas do
        begin
          Brush.Color := clWhite;
          Brush.Style := bsSolid;
          FillRect(ClipRect);
        end;
      end;
    end;
    fmPreview.udPageNo.Max := TotalPages;
    fmPreview.lblTotalPages.Caption := IntToStr(TotalPages);
    EndDoc;
  end;
  bmp.Free;
  bmpPage.Free;
  fmPreview.ShowModal;
end;
//============================================================================

procedure TfmPrinterSetup.btSwapClick(Sender: TObject);
var
  s: string;
begin
  s := edHeight.Text;
  edHeight.Text := edWidth.Text;
  edWidth.Text := s;
end;
//============================================================================

procedure TfmPrinterSetup.FormShow(Sender: TObject);
var
  sPrinter: string;
  i: integer;
begin
  sPrinter := cmbPrinters.Text;
  cmbPrinters.Style := csDropDownList;
  cmbPrinters.Items.Assign(Printer.Printers);
  i := cmbPrinters.Items.IndexOf(sPrinter); //find the remembered Printer name
  if i >= 0 then
  begin
    cmbPrinters.ItemIndex := i;
    Printer.PrinterIndex := i;
  end
  else
    cmbPrinters.ItemIndex := Printer.PrinterIndex;
end;
//============================================================================

procedure TfmPrinterSetup.cmbPrintersChange(Sender: TObject);
begin
  Printer.PrinterIndex := cmbPrinters.ItemIndex;
end;
//============================================================================

procedure TfmPrinterSetup.edLeftClick(Sender: TObject);
begin
  (Sender as TEdit).SelectAll;
end;
//============================================================================

procedure TfmPrinterSetup.chkPrintTitleClick(Sender: TObject);
begin
  cmbFont.Enabled := chkPrintTitle.Checked;
  cmbFontSize.Enabled := chkPrintTitle.Checked;
  cmbFontColor.Enabled := chkPrintTitle.Checked;
  chkBold.Enabled := chkPrintTitle.Checked;
  chkItalic.Enabled := chkPrintTitle.Checked;
  chkUnderline.Enabled := chkPrintTitle.Checked;
end;
//============================================================================

procedure TfmPrinterSetup.chkPrintBorderClick(Sender: TObject);
begin
  cmbBorderColor.Enabled := chkPrintBorder.Checked;
end;
//=============================================================================

procedure TfmPrinterSetup.chkPrintDifferentBgColorClick(Sender: TObject);
begin
  cmbBgColor.Enabled := chkPrintDifferentBgColor.Checked;
end;
//=============================================================================

procedure TfmPrinterSetup.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FileClose(Model.FileHandle);
  PreviewFormStorage.SaveFormPlacement;
  Model.FileHandle := FileOpen(Model.Filename, fmOpenReadWrite);
end;
//=============================================================================

procedure TfmPrinterSetup.rgOrientationClick(Sender: TObject);
var
  nMax, nMin: integer;
begin
  nMax := Max(StrToIntDef(edWidth.Text, 210), StrToIntDef(edHeight.Text, 297));
  nMin := Min(StrToIntDef(edWidth.Text, 210), StrToIntDef(edHeight.Text, 297));
  case rgOrientation.ItemIndex of
    0:
    begin
      edWidth.Text := IntToStr(nMin);
      edHeight.Text := IntToStr(nMax);
    end;
    1:
    begin
      edHeight.Text := IntToStr(nMin);
      edWidth.Text := IntToStr(nMax);
    end;
  end;
end;
//=============================================================================

procedure TfmPrinterSetup.edWidthChange(Sender: TObject);
var
  w, h: integer;
begin
  w := StrToIntDef(edWidth.Text, 210);
  h := StrToIntDef(edHeight.Text, 297);
  if w < h then
    rgOrientation.ItemIndex := 0
  else if w > h then
    rgOrientation.ItemIndex := 1;
end;
//=============================================================================

end.
