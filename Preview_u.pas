unit Preview_u;

{$I IBUtils.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Preview, StdCtrls, ExtCtrls, ComCtrls, ToolWin;

type
  TfmPreview = class(TForm)
    PrintPreview: TPrintPreview;
    Panel1: TPanel;
    ToolBar1: TToolBar;
    cmbZoom: TComboBox;
    edPageNo: TEdit;
    udPageNo: TUpDown;
    tbPrint: TToolButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblTotalPages: TLabel;
    Label5: TLabel;
    tbExportToWMF: TToolButton;
    ToolButton2: TToolButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure PrintPreviewChange(Sender: TObject);
    procedure udPageNoClick(Sender: TObject; Button: TUDBtnType);
    procedure FormCreate(Sender: TObject);
    procedure cmbZoomClick(Sender: TObject);
    procedure cmbZoomKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tbPrintClick(Sender: TObject);
    procedure PrintPreviewMouseWheelDown(Sender: TObject;
      Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure PrintPreviewMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure edPageNoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edPageNoClick(Sender: TObject);
    procedure tbExportToWMFClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  sZoomToWidth = 'To Page Width (W)';
  sZoomToHeight = 'To Page Height (H)';
  sZoomToFit = 'Whole Page (F4)';

var
  fmPreview: TfmPreview;

implementation

uses PrinterSetup, CommDlg, Printers;

{$R *.dfm}

procedure TfmPreview.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfmPreview.Button1Click(Sender: TObject);
begin

end;
//============================================================================

procedure TfmPreview.PrintPreviewChange(Sender: TObject);
begin
  udPageNo.Position := PrintPreview.CurrentPage;
end;
//============================================================================

procedure TfmPreview.udPageNoClick(Sender: TObject; Button: TUDBtnType);
begin
  PrintPreview.CurrentPage := udPageNo.Position;
end;
//============================================================================

procedure TfmPreview.FormCreate(Sender: TObject);
begin
  cmbZoom.Items.Add(sZoomToWidth);
  cmbZoom.Items.Add(sZoomToHeight);
  cmbZoom.Items.Add(sZoomToFit);
end;
//============================================================================

procedure TfmPreview.cmbZoomClick(Sender: TObject);
begin
  if cmbZoom.Text = sZoomToFit then
    PrintPreview.ZoomState := zsZoomToFit
  else if cmbZoom.Text = sZoomToWidth then
    PrintPreview.ZoomState := zsZoomToWidth
  else if cmbZoom.Text = sZoomToHeight then
    PrintPreview.ZoomState := zsZoomToHeight
  else
  begin
    PrintPreview.ZoomState := zsZoomOther;
    PrintPreview.Zoom := StrToIntDef(cmbZoom.Text, 100);
    cmbZoom.Text := IntToStr(PrintPreview.Zoom);
  end;
end;
//============================================================================

procedure TfmPreview.cmbZoomKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN: cmbZoom.OnClick(cmbZoom);
  end;
end;
//============================================================================

procedure TfmPreview.tbPrintClick(Sender: TObject);
begin
  PrintPreview.Print;
end;
//============================================================================

procedure TfmPreview.PrintPreviewMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if Shift = [ssCtrl] then
  begin
    PrintPreview.Zoom := PrintPreview.Zoom + 10;
    cmbZoom.Text := IntToStr(PrintPreview.Zoom);
    Handled := true;
  end
  else if Shift = [ssShift] then
  begin
    Handled := true;
    SendMessage(PrintPreview.Handle, WM_HSCROLL, SB_LINERIGHT, 0);
    SendMessage(PrintPreview.Handle, WM_HSCROLL, SB_LINERIGHT, 0);
    SendMessage(PrintPreview.Handle, WM_HSCROLL, SB_LINERIGHT, 0);
    SendMessage(PrintPreview.Handle, WM_HSCROLL, SB_LINERIGHT, 0);
  end
  else
  begin
    Handled := true;
    SendMessage(PrintPreview.Handle, WM_VSCROLL, SB_LINEDOWN, 0);
    SendMessage(PrintPreview.Handle, WM_VSCROLL, SB_LINEDOWN, 0);
    SendMessage(PrintPreview.Handle, WM_VSCROLL, SB_LINEDOWN, 0);
    SendMessage(PrintPreview.Handle, WM_VSCROLL, SB_LINEDOWN, 0);
  end;
end;
//============================================================================

procedure TfmPreview.PrintPreviewMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if Shift = [ssCtrl] then
  begin
    PrintPreview.Zoom := PrintPreview.Zoom - 10;
    cmbZoom.Text := IntToStr(PrintPreview.Zoom);
    Handled := true;
  end
  else if Shift = [ssShift] then
  begin
    Handled := true;
    SendMessage(PrintPreview.Handle, WM_HSCROLL, SB_LINELEFT, 0);
    SendMessage(PrintPreview.Handle, WM_HSCROLL, SB_LINELEFT, 0);
    SendMessage(PrintPreview.Handle, WM_HSCROLL, SB_LINELEFT, 0);
    SendMessage(PrintPreview.Handle, WM_HSCROLL, SB_LINELEFT, 0);
  end
  else
  begin
    Handled := true;
    SendMessage(PrintPreview.Handle, WM_VSCROLL, SB_LINEUP, 0);
    SendMessage(PrintPreview.Handle, WM_VSCROLL, SB_LINEUP, 0);
    SendMessage(PrintPreview.Handle, WM_VSCROLL, SB_LINEUP, 0);
    SendMessage(PrintPreview.Handle, WM_VSCROLL, SB_LINEUP, 0);
  end;
end;
//============================================================================

procedure TfmPreview.edPageNoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  i: integer;
begin
  case Key of
    VK_RETURN:
      begin
        i := StrToIntDef(edPageNo.Text, 1);
        if i <= PrintPreview.TotalPages then
          PrintPreview.CurrentPage := i
        else
          PrintPreview.CurrentPage := udPageNo.Max;
        udPageNo.Position := PrintPreview.CurrentPage;
        edPageNo.SelectAll;
      end;
  end;
end;
//============================================================================

procedure TfmPreview.edPageNoClick(Sender: TObject);
begin
  edPageNo.SelectAll;
end;
//============================================================================

procedure TfmPreview.tbExportToWMFClick(Sender: TObject);
var
  SDlg: TSaveDialog;
begin
  SDlg := TSaveDialog.Create(Application);
  SDlg.Title := 'Export preview page to file';
  SDlg.Filter := 'Windows Metafile (WMF)|*.wmf';
  SDlg.FilterIndex := 1;
  SDlg.DefaultExt := 'wmf';
  SDlg.Options := SDlg.Options + [ofOverwritePrompt];
  try
    if SDlg.Execute then
      PrintPreview.Pages[PrintPreview.CurrentPage].SaveToFile(SDlg.FileName);
  finally
    SDlg.Free;
  end;
end;
//============================================================================

procedure TfmPreview.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE: Close;
    VK_F4:
    begin
      cmbZoom.Text := sZoomToFit;
      cmbZoom.OnClick(cmbZoom);
    end;
  end;
end;
//=============================================================================

procedure TfmPreview.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (UpperCase(Key) = 'P') or (Key = ^P) then
    tbPrintClick(tbPrint)
  else
  if (UpperCase(Key) = 'S') or (Key = ^S) then
    tbExportToWMFClick(tbExportToWMF)
  else
  if Key = '+' then
  begin
    cmbZoom.Text := IntToStr(PrintPreview.Zoom + 10);
    cmbZoom.OnClick(cmbZoom);
  end
  else
  if Key = '-' then
  begin
    cmbZoom.Text := IntToStr(PrintPreview.Zoom - 10);
    cmbZoom.OnClick(cmbZoom);
  end
  else
  if UpperCase(Key) = 'W' then
  begin
    cmbZoom.Text := sZoomToWidth;
    cmbZoom.OnClick(cmbZoom);
  end
  else
  if UpperCase(Key) = 'H' then
  begin
    cmbZoom.Text := sZoomToHeight;
    cmbZoom.OnClick(cmbZoom);
  end
end;
//=============================================================================

end.
