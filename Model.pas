unit Model;

//#todo3 nastavit u komponenty cnModel.LoginPromt = true

{$I IBUtils.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Main, IB_Components,
  ExtCtrls, ActnList, Menus, Placemnt, StdCtrls, ToolWin, IB_SessionProps,
  Printers, Jpeg;

type
  TfmModel = class(TForm)
    ToolBar1: TToolBar;
    qrTables: TIB_Query;
    scbModel: TScrollBox;
    qrTableFields: TIB_Query;
    qrRelations: TIB_Query;
    ToolButton3: TToolButton;
    ActionList: TActionList;
    actModelAddTable: TAction;
    ToolButton4: TToolButton;
    actModelRefresh: TAction;
    mnModel: TMainMenu;
    mniModel: TMenuItem;
    mniAddTable: TMenuItem;
    mniRefreshModel: TMenuItem;
    N1: TMenuItem;
    mniModelNew: TMenuItem;
    actModelSave: TAction;
    actModelSaveAs: TAction;
    mniSave: TMenuItem;
    mniSaveAs: TMenuItem;
    OpenModel1: TMenuItem;
    ToolButton6: TToolButton;
    actModelFindTable: TAction;
    ToolButton1: TToolButton;
    cmbScale: TComboBox;
    actModelDeleteTable: TAction;
    DeleteTable1: TMenuItem;
    popModel: TPopupMenu;
    actModelAddTableXY: TAction;
    aa1: TMenuItem;
    ToolButton2: TToolButton;
    ToolButton5: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    actOptions: TAction;
    ShowTypes1: TMenuItem;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    cnModel: TIB_Connection;
    N2: TMenuItem;
    FindTable1: TMenuItem;
    actModelColor: TAction;
    Color1: TMenuItem;
    actModelTableColor: TAction;
    actModelSelectAll: TAction;
    SelectAll1: TMenuItem;
    IB_SessionProps1: TIB_SessionProps;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    actModelPrint: TAction;
    Print1: TMenuItem;
    N3: TMenuItem;
    actCopyToClipboard: TAction;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    CopyToClipboard1: TMenuItem;
    actExportToFile: TAction;
    ExportToFile1: TMenuItem;
    ToolButton17: TToolButton;
    N4: TMenuItem;
    CopyToClipboard2: TMenuItem;
    ExportToFile2: TMenuItem;
    ToolButton18: TToolButton;
    ToolButton19: TToolButton;
    ToolButton20: TToolButton;
    ToolButton21: TToolButton;
    popNode: TPopupMenu;
    mniDeleteNode2: TMenuItem;
    mniDeleteAllNodes: TMenuItem;
    popRelation: TPopupMenu;
    mniDeleteAllNodes2: TMenuItem;
    actModelAddNoteXY: TAction;
    AddNote1: TMenuItem;
    actModelAddCustomRelation: TAction;
    ToolButton22: TToolButton;
    mniDeleteCustomRelation: TMenuItem;
    mniDeleteCustomRelation2: TMenuItem;
    mniDeleteNode: TMenuItem;
    actModelCreateRelation: TAction;
    ToolButton23: TToolButton;
    mniDropRelation: TMenuItem;
    actModelCreateTableXY: TAction;
    CreateTable1: TMenuItem;
    ToolButton24: TToolButton;
    ToolButton25: TToolButton;
    actSnapToGrid: TAction;
    actRunScript: TAction;
    ToolButton26: TToolButton;
    actSnapRelToGrid: TAction;
    actShowGrid: TAction;
    ToolButton27: TToolButton;
    ToolButton28: TToolButton;
    actImportModel: TAction;
    mniImportModel: TMenuItem;
    actNewModelFromSelected: TAction;
    N5: TMenuItem;
    NewModelFromSelected1: TMenuItem;
    NewModelFromSelected2: TMenuItem;
    mniOptions: TMenuItem;
    ToolButton29: TToolButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure actModelAddTableExecute(Sender: TObject);
    procedure actModelRefreshExecute(Sender: TObject);
    procedure actModelSaveExecute(Sender: TObject);
    procedure actModelSaveAsExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actModelFindTableExecute(Sender: TObject);
    procedure cmbScaleKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cmbScaleClick(Sender: TObject);
    procedure cmbScaleKeyPress(Sender: TObject; var Key: Char);
    procedure scbModelMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure scbModelMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure actModelDeleteTableExecute(Sender: TObject);
    procedure actModelAddTableXYExecute(Sender: TObject);
    procedure actOptionsExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure cnModelAfterConnect(Sender: TIB_Connection);
    procedure actModelColorExecute(Sender: TObject);
    procedure actModelTableColorExecute(Sender: TObject);
    procedure actModelSelectAllExecute(Sender: TObject);
    procedure actModelPrintExecute(Sender: TObject);
    procedure actCopyToClipboardExecute(Sender: TObject);
    procedure actExportToFileExecute(Sender: TObject);
    procedure mniDeleteNode2Click(Sender: TObject);
    procedure mniDeleteAllNodesClick(Sender: TObject);
    procedure mniDeleteAllNodes2Click(Sender: TObject);
    procedure actModelSaveUpdate(Sender: TObject);
    procedure actModelDeleteTableUpdate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure actModelAddNoteXYExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actModelAddCustomRelationExecute(Sender: TObject);
    procedure mniDeleteCustomRelationClick(Sender: TObject);
    procedure popRelationPopup(Sender: TObject);
    procedure popNodePopup(Sender: TObject);
    procedure mniDeleteNodeClick(Sender: TObject);
    procedure actModelCreateRelationExecute(Sender: TObject);
    procedure mniDropRelationClick(Sender: TObject);
    procedure actModelCreateTableXYExecute(Sender: TObject);
    procedure actSnapToGridExecute(Sender: TObject);
    procedure actRunScriptExecute(Sender: TObject);
    procedure actSnapRelToGridExecute(Sender: TObject);
    procedure actShowGridExecute(Sender: TObject);
    procedure actImportModelExecute(Sender: TObject);
    procedure actNewModelFromSelectedExecute(Sender: TObject);
    procedure ToolButton29Click(Sender: TObject);
  private
    FBrowseList: TList;
  public
    Model: TPanel;
    property BrowseList: TList read FBrowseList;
    function SetFocusedControl(Control: TWinControl): Boolean; override;
    destructor Destroy; override;
    procedure CheckConnected(AConnection: TIB_Connection = nil);
    procedure SetDatabaseStatus(AConnection: TIB_Connection = nil);
  end;

var
  fmModel: TfmModel;

implementation

uses fraTable_u, AddTable, FindTable, ShowOptions, Preview_u,
  Preview, PrinterSetup, ClipBrd, Progress, fraMain_u, fraNote_u, IB_Script,
  CreateTable, Browse, Math, ScrollListBox;

{$R *.dfm}

//=============================================================================

procedure TfmModel.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;
//=============================================================================

procedure TfmModel.FormCreate(Sender: TObject);
begin
  Model := TModel.Create(scbModel);
  TModel(Model).ResizeModel;
  FBrowseList := TList.Create;
end;
//=============================================================================

procedure TfmModel.FormResize(Sender: TObject);
begin
  TModel(Model).ResizeModel;
end;
//=============================================================================

procedure TfmModel.actModelAddTableExecute(Sender: TObject);
var
  fm: TfmAddTable;
begin
  fm := TfmAddTable.Create(Application);
  fm.qrTables.IB_Connection := cnModel;
  fm.Model := TModel(Model);
  fm.ShowModal;
  CheckConnected;
end;
//=============================================================================

procedure TfmModel.actModelRefreshExecute(Sender: TObject);
begin
  TModel(Model).Refresh;
  SetDatabaseStatus;
end;
//=============================================================================

procedure TfmModel.actModelSaveExecute(Sender: TObject);
begin
  if TModel(Model).Filename = 'Untitled' then
    TModel(Model).SaveAs
  else
    TModel(Model).Save;
end;
//=============================================================================

procedure TfmModel.actModelSaveAsExecute(Sender: TObject);
begin
  TModel(Model).SaveAs;
end;
//=============================================================================

procedure TfmModel.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  res: TModalResult;
begin
  if Assigned(TModel(Model).fmProgress) then
  begin
    CanClose := false;
    Exit;
  end;

  if TModel(Model).Modified then
  begin
    res := MessageDlg('Save changes?', mtConfirmation, [mbYes, mbNo, mbCancel], 0);
    case res of
      mrYes:
        begin
          TModel(Model).Save;
          CanClose := true;
        end;
      mrNo: CanClose := true;
      mrCancel: CanClose := false;
    end;
  end
  else
    CanClose := true;
end;
//=============================================================================

procedure TfmModel.actModelFindTableExecute(Sender: TObject);
begin
  fmFindTable.ModelForm := Self;
  fmFindTable.ShowModal;
end;
//=============================================================================

procedure TfmModel.cmbScaleKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    TModel(Model).Scale(StrToInt(cmbScale.Text));
end;
//=============================================================================

procedure TfmModel.cmbScaleClick(Sender: TObject);
begin
  TModel(Model).Scale(StrToInt(cmbScale.Text));
end;
//=============================================================================

procedure TfmModel.cmbScaleKeyPress(Sender: TObject; var Key: Char);
begin
  if not ((Key in ['0'..'9']) or (Key = #8)) then
  begin
    Key := #0;
    MessageBeep(MB_OK);
  end
  else
  inherited KeyPress(Key);
end;
//=============================================================================

procedure TfmModel.scbModelMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if Shift = [ssCtrl] then
  begin
    TModel(Model).Scale(TModel(Model).CurrentScale - 5);
    Handled := true;
  end
  else if Shift = [ssShift] then
  begin
    //    scbModel.HorzScrollBar.Position := scbModel.HorzScrollBar.Position - 20;
    Handled := true;
    SendMessage(scbModel.Handle, WM_HSCROLL, SB_LINELEFT, 0);
  end
  else
  begin
    //scbModel.VertScrollBar.Position := scbModel.VertScrollBar.Position - 20;
    Handled := true;
    SendMessage(scbModel.Handle, WM_VSCROLL, SB_LINEUP, 0);
  end;
end;
//=============================================================================

procedure TfmModel.scbModelMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if Shift = [ssCtrl] then
  begin
    TModel(Model).Scale(TModel(Model).CurrentScale + 5);
    Handled := true;
  end
  else if Shift = [ssShift] then
  begin
    Handled := true;
    SendMessage(scbModel.Handle, WM_HSCROLL, SB_LINERIGHT, 0);
  end
  else
  begin
    Handled := true;
    SendMessage(scbModel.Handle, WM_VSCROLL, SB_LINEDOWN, 0);
  end;
end;
//=============================================================================

function TfmModel.SetFocusedControl(Control: TWinControl): Boolean;
{var
  TempControl: TWinControl;
  IsScrolling: boolean;}
begin
  { Result := False;
   IsScrolling := false;
   TempControl := Control.Parent;
   while TempControl <> nil do
   begin
     if TempControl is TScrollingWinControl then
       IsScrolling := true;
     TempControl := TempControl.Parent;
   end;
   if not IsScrolling then}
  Result := inherited SetFocusedControl(Control);
end;
//============================================================================

procedure TfmModel.actModelDeleteTableExecute(Sender: TObject);
var
  i, nCount: integer;
begin
  nCount := TModel(Model).SelectedFrameCount;
  if nCount = 0 then
  begin
    MessageDlg('No object is selected.', mtWarning, [mbOK], 0);
    Exit;
  end
  else if MessageDlg('Delete selected object(s) from model?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    for i := nCount - 1 downto 0 do
    begin
      TModel(Model).SelectedFrames[i].Free;
    end;
    TModel(Model).Invalidate;
    TModel(Model).Modified := true;
  end;
end;
//=============================================================================

procedure TfmModel.actModelAddTableXYExecute(Sender: TObject);
var
  fm: TfmAddTable;
begin
  fm := TfmAddTable.Create(Application);
  fm.qrTables.IB_Connection := cnModel;
  fm.Model := TModel(Model);
  fm.AddX := fm.Model.ScreenToClient(popModel.PopupPoint).X; //fm.Model.ScreenToClient(Mouse.CursorPos).X;
  fm.AddY := fm.Model.ScreenToClient(popModel.PopupPoint).Y; //fm.Model.ScreenToClient(Mouse.CursorPos).Y;
  fm.ShowModal;
  CheckConnected;
end;
//=============================================================================

procedure TfmModel.actOptionsExecute(Sender: TObject);
var
  i: integer;
  SO: TShowOptions;
  mdl: TModel;
  bRefresh, bInvalidate: boolean;
begin
  bRefresh := false;
  bInvalidate := false;
  mdl := TModel(Model);
  with fmShowOptions do
  begin
    edModelTitle.Text := mdl.Title;
    moTablesFilter.Lines.Text := mdl.AddTablesFilter;

    chkTypes.Checked := soType in mdl.DefaultShowOptions;
    chkDomains.Checked := soDomain in mdl.DefaultShowOptions;
    chkComputedBy.Checked := soComputedBy in mdl.DefaultShowOptions;
    chkIndexCount.Checked := soIndexCount in mdl.DefaultShowOptions;
    chkRequired.Checked := soRequired in mdl.DefaultShowOptions;
    chkIcons.Checked := soIcons in mdl.DefaultShowOptions;
    chkKeysOnly.Checked := soKeysOnly in mdl.DefaultShowOptions;
    chkHeader.Checked := soHeader in mdl.DefaultShowOptions;

    cmbLinkColorDefault.Selected := mdl.LinkColorDefault;
    cmbLinkColorSelected.Selected := mdl.LinkColorSelected;
    cmbLinkColorFocused.Selected := mdl.LinkColorFocused;
    cmbLinkColorCustom.Selected := mdl.LinkColorCustom;
    udDefColCount.Position := mdl.DefColCount;

    edDatabase.Text := cnModel.Database;
    chkSnapToGrid.Checked := mdl.SnapToGrid;
    chkSnapRelToGrid.Checked := mdl.SnapRelToGrid;
    chkShowGrid.Checked := mdl.ShowGrid;
    udGridX.Position := mdl.GridX;
    udGridY.Position := mdl.GridY;
    edPassword.Text := mdl.Password;
    edUsername.Text := mdl.Username;
    chkShowSystemDomains.Checked := mdl.ShowSystemDomains;
    chkCombinedTypeDomain.Checked := mdl.CombinedTypeDomain;

    if ShowModal = mrOk then
    begin
      if mdl.Title <> edModelTitle.Text then
      begin
        mdl.Title := edModelTitle.Text;
        mdl.Modified := True;
      end;

      if mdl.AddTablesFilter <> moTablesFilter.Lines.Text then
      begin
        mdl.AddTablesFilter := moTablesFilter.Lines.Text;
        mdl.Modified := True;
      end;

      if cnModel.Database <> edDatabase.Text then
      begin
        bRefresh := true;
        cnModel.Disconnect;
        cnModel.Database := edDatabase.Text;
        mdl.Modified := True;
        cnModel.Connect;
      end;

      if (chkTypes.Checked <> (soType in mdl.DefaultShowOptions)) or
        (chkDomains.Checked <> (soDomain in mdl.DefaultShowOptions)) or
        (chkComputedBy.Checked <> (soComputedBy in mdl.DefaultShowOptions)) or
        (chkIndexCount.Checked <> (soIndexCount in mdl.DefaultShowOptions)) or
        (chkRequired.Checked <> (soRequired in mdl.DefaultShowOptions)) or
        (chkIcons.Checked <> (soIcons in mdl.DefaultShowOptions)) or
        (chkKeysOnly.Checked <> (soKeysOnly in mdl.DefaultShowOptions)) or
        (chkHeader.Checked <> (soHeader in mdl.DefaultShowOptions)) then
      begin
        SO := [soName];
        for i := 0 to gbShowOptions.ControlCount - 1 do
        begin
          if gbShowOptions.Controls[i] is TCheckBox then
          begin
            if (gbShowOptions.Controls[i] as TCheckBox).Checked then
              SO := SO + [TShowOption((gbShowOptions.Controls[i] as TCheckBox).Tag)];
          end;
        end;

        mdl.DefaultShowOptions := SO;
        mdl.Modified := True;
      end;

      if udDefColCount.Position <> mdl.DefColCount then
      begin
        mdl.DefColCount := udDefColCount.Position;
        mdl.Modified := True;
      end;

      if (chkSnapToGrid.Checked <> mdl.SnapToGrid) or
         (chkSnapRelToGrid.Checked <> mdl.SnapRelToGrid) or
         (chkShowGrid.Checked <> mdl.ShowGrid) or
         (udGridX.Position <> mdl.GridX) or
         (udGridY.Position <> mdl.GridY) then
      begin
        mdl.SnapToGrid := chkSnapToGrid.Checked;
        mdl.SnapRelToGrid := chkSnapRelToGrid.Checked;
        mdl.ShowGrid := chkShowGrid.Checked;
        mdl.GridX := udGridX.Position;
        mdl.GridY := udGridY.Position;
        mdl.Modified := true;
        bInvalidate := true;
      end;

      if (cmbLinkColorDefault.Selected <> mdl.LinkColorDefault) or
        (cmbLinkColorSelected.Selected <> mdl.LinkColorSelected) or
        (cmbLinkColorFocused.Selected <> mdl.LinkColorFocused) or
        (cmbLinkColorCustom.Selected <> mdl.LinkColorCustom) then
      begin
        mdl.LinkColorDefault := cmbLinkColorDefault.Selected;
        mdl.LinkColorSelected := cmbLinkColorSelected.Selected;
        mdl.LinkColorFocused := cmbLinkColorFocused.Selected;
        mdl.LinkColorCustom := cmbLinkColorCustom.Selected;
        mdl.Modified := True;
        mdl.Invalidate;
      end;

      if (edPassword.Text <> mdl.Password)
        or (edUsername.Text <> mdl.Username) then
      begin
        mdl.Password := edPassword.Text;
        mdl.Username := edUsername.Text;
        mdl.Modified := true;
      end;

      if (chkShowSystemDomains.Checked <> mdl.ShowSystemDomains)
        or (chkCombinedTypeDomain.Checked <> mdl.CombinedTypeDomain) then
      begin
        mdl.ShowSystemDomains := chkShowSystemDomains.Checked;
        mdl.CombinedTypeDomain := chkCombinedTypeDomain.Checked;
        mdl.Modified := true;
        bRefresh := true;
      end;

      if bRefresh then
        mdl.Refresh
      else if bInvalidate then
        mdl.Invalidate;
    end;
  end;
end;
//=============================================================================

procedure TfmModel.FormActivate(Sender: TObject);
begin
  SetDatabaseStatus;
end;
//=============================================================================

procedure TfmModel.FormDeactivate(Sender: TObject);
begin
  fmMain.StatusBar.Panels.Items[1].Text := '';
end;
//=============================================================================

procedure TfmModel.cnModelAfterConnect(Sender: TIB_Connection);
begin
  SetDatabaseStatus;
end;
//=============================================================================

procedure TfmModel.actModelColorExecute(Sender: TObject);
begin
  with TColorDialog.Create(Application) do
  begin
    Options := Options + [cdFullOpen];
    Color := TModel(Model).Color;
    if Execute then
    begin
      TModel(Model).Color := Color;
      TModel(Model).Modified := true;
    end;
    Free;
  end;
end;
//=============================================================================

procedure TfmModel.actModelTableColorExecute(Sender: TObject);
var
  i, nCount: integer;
begin
  nCount := TModel(Model).SelectedFrameCount;
  if nCount = 0 then
  begin
    MessageDlg('No table is selected.', mtWarning, [mbOK], 0);
    Exit;
  end
  else
    with TColorDialog.Create(Application) do
    begin
      if Execute then
      begin
        for i := 0 to nCount - 1 do
        begin
          TModel(Model).SelectedFrames[i].pnlMain.Color := Color;
        end;
        TModel(Model).Invalidate;
        TModel(Model).Modified := true;
      end;
      Free;
    end;
end;
//=============================================================================

procedure TfmModel.actModelSelectAllExecute(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to TModel(Model).FrameCount - 1 do
  begin
    TModel(Model).AddSelectedFrame(TModel(Model).Frames[i], true);
    TModel(Model).Frames[i].Selected := true;
    TModel(Model).Frames[i].Paint;
  end;
end;
//=============================================================================

procedure TfmModel.actModelPrintExecute(Sender: TObject);
begin
  with fmPrinterSetup do
  begin
    Model := TModel(Self.Model);
    FileClose(Model.FileHandle);
    PreviewFormStorage.IniFileName := Model.Filename;
    PreviewFormStorage.RestoreFormPlacement;
    Model.FileHandle := FileOpen(Model.Filename, fmOpenReadWrite);
    ShowModal;
  end;
end;
//============================================================================

procedure TfmModel.actCopyToClipboardExecute(Sender: TObject);
var
  bmp: TBitmap;
begin
  bmp := TBitmap.Create;
  try
    bmp.Width := TModel(Model).Width;
    bmp.Height := TModel(Model).Height;
    TModel(Model).PaintTo(bmp.Canvas, 0, 0);
    Clipboard.Assign(bmp);
  finally
    bmp.Free;
  end;
end;
//============================================================================

procedure TfmModel.actExportToFileExecute(Sender: TObject);
var
  bmp: TBitmap;
  jpg: TJPEGImage;
  SDlg: TSaveDialog;
  nQuality: integer;
  sQuality: string;
begin
  bmp := TBitmap.Create;
  SDlg := TSaveDialog.Create(Application);
  SDlg.Title := 'Export model to file';
  SDlg.Filter := 'JPG files|*.jpg|Bitmap files|*.bmp';
  SDlg.FilterIndex := 1;
  SDlg.DefaultExt := 'jpg';
  SDlg.Options := SDlg.Options + [ofOverwritePrompt];
  try
    bmp.Width := TModel(Model).Width;
    bmp.Height := TModel(Model).Height;
    if SDlg.Execute then
    begin
      TModel(Model).PaintTo(bmp.Canvas, 0, 0);
      //if UpperCase(ExtractFileExt(SDlg.FileName)) = '.JPG' then
      if SDlg.FilterIndex = 1 then                //jpg file
      begin
        jpg := TJPEGImage.Create;
        try
          jpg.Assign(bmp);
          nQuality := jpg.CompressionQuality;
          sQuality := InputBox('Specify JPG Compression Quality', '100 ... best quality, 1 ... low quality', IntToStr(nQuality));
          jpg.CompressionQuality := StrToIntDef(sQuality, nQuality);
          jpg.SaveToFile(SDlg.Filename);
        finally
          jpg.Free;
        end;
      end
      else
        bmp.SaveToFile(SDlg.Filename);
    end;
  finally
    bmp.Free;
    SDlg.Free;
  end;
end;
//============================================================================

procedure TfmModel.mniDeleteNode2Click(Sender: TObject);
begin
  if TModel(Model).FocusedRelation <> nil then
  begin
    TModel(Model).FocusedRelation.DeleteNode(TModel(Model).FocusedRelation.FocusedNode);
    TModel(Model).Invalidate;
  end;
end;
//============================================================================

procedure TfmModel.mniDeleteAllNodesClick(Sender: TObject);
var
  i: integer;
begin
  if TModel(Model).FocusedRelation <> nil then
  begin
    for i := TModel(Model).FocusedRelation.NodeList.Count - 1 downto 0 do
    begin
      TModel(Model).FocusedRelation.DeleteNode(i);
      TModel(Model).Invalidate;
    end;
  end;
end;
//============================================================================

procedure TfmModel.mniDeleteAllNodes2Click(Sender: TObject);
var
  i: integer;
begin
  if TModel(Model).FocusedRelation <> nil then
  begin
    for i := TModel(Model).FocusedRelation.NodeList.Count - 1 downto 0 do
    begin
      TModel(Model).FocusedRelation.DeleteNode(i);
      TModel(Model).Invalidate;
    end;
  end;
end;
//============================================================================

procedure TfmModel.actModelSaveUpdate(Sender: TObject);
begin
  actModelSave.Enabled := TModel(Model).Modified;
end;
//============================================================================

procedure TfmModel.actModelDeleteTableUpdate(Sender: TObject);
begin
  actModelDeleteTable.Enabled := TModel(Model).SelectedFrameCount > 0;
end;
//============================================================================

procedure TfmModel.FormKeyPress(Sender: TObject; var Key: Char);
var
  i: integer;
begin
  with TModel(Model) do
  begin
    if (SelectedFrameCount = 1) and (Copy(SelectedFrames[0].InternalName, 1, 3) = 'NT$') then
      (SelectedFrames[0] as TfraNote).Memo.SetFocus;
  end;

  if not(Screen.ActiveControl is TMemo) then
    case Key of
      'A', 'a': actModelAddTable.Execute;
      'S', 's': actModelSave.Execute;
      'U', 'u': actOptions.Execute;
      'C', 'c': actModelTableColor.Execute;
      'P', 'p': actModelPrint.Execute;
      'E', 'e': actExportToFile.Execute;
      'F', 'f': actModelFindTable.Execute
    else
      //#todo1 tady se vola keypress pro kazdou table a kazda table to vola pro vsechny selected, takze je to volane mockrat!!!
      for i := 0 to TModel(Model).SelectedFrameCount-1 do
        TModel(Model).SelectedFrames[i].KeyPress(Key);
      //if TModel(Model).SelectedFrameCount > 0 then
//        TModel(Model).SelectedFrames[0].KeyPress(Key);
    end
  else
  if TModel(Model).SelectedFrameCount > 0 then
    TModel(Model).SelectedFrames[0].KeyPress(Key);
end;
//============================================================================

procedure TfmModel.actModelAddNoteXYExecute(Sender: TObject);
var
  note: TfraNote;
  G: TGUID;
  S: string;
begin
  CreateGUID(G);
  S := GuidToString(G);
  S := 'NT$' + Copy(S, 2, Length(S) - 2); // delete beginning and ending braces {}
  note := TfraNote.CreateByName(TModel(Model), S);//'NT$Note' + IntToStr(TModel(Model).nNoteCounter + 1));
  TModel(Model).AddFrame(note);
  note.Left := Model.ScreenToClient(popModel.PopupPoint).X;
  note.Top := Model.ScreenToClient(popModel.PopupPoint).Y;
  note.SaveCoordToOrig;
  note.Title := 'Note'; //+ IntToStr(TModel(Model).nNoteCounter); //nNoteCounter is incremented in the AddFrame above
  note.Visible := true;
end;
//=============================================================================

procedure TfmModel.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_DELETE:
      if not(Screen.ActiveControl is TMemo) and not(Screen.ActiveControl is TScrollListBox) then
        actModelDeleteTable.Execute;

    VK_F2:
       TModel(Model).Scale(TModel(Model).CurrentScale + 10);
    VK_F3:
       TModel(Model).Scale(TModel(Model).CurrentScale - 10);
    VK_F4:
       TModel(Model).Scale(100);
  end;
end;
//=============================================================================

procedure TfmModel.actModelAddCustomRelationExecute(Sender: TObject);
begin
  with TModel(Model) do
  begin
    if actModelAddCustomRelation.Checked then
    begin
      Screen.Cursor := crCustomLinkTo;
      //OnClick(Sender); //deselects all
      TModel(Model).CustomRelationAFrame := '';
      TModel(Model).CustomRelationBFrame := '';
      AddingCustomRelation := true;
    end
    else
    begin
      Screen.Cursor := crDefault;
      AddingCustomRelation := false;
    end;
  end;
end;
//=============================================================================

procedure TfmModel.mniDeleteCustomRelationClick(Sender: TObject);
begin
  if TModel(Model).FocusedRelation <> nil then
  begin
    TModel(Model).FocusedRelation.Free;
    TModel(Model).Modified := true;
    TModel(Model).Invalidate;
  end;
end;
//=============================================================================

procedure TfmModel.popRelationPopup(Sender: TObject);
begin
  mniDeleteCustomRelation.Enabled := (TModel(Model).FocusedRelation <> nil) and (TModel(Model).FocusedRelation.IsCustomRelation);
  mniDeleteNode.Enabled := (TModel(Model).FocusedRelation <> nil) and (TModel(Model).FocusedRelation.FocusedNode <> -1);
  mniDropRelation.Enabled := (TModel(Model).FocusedRelation <> nil) and not (TModel(Model).FocusedRelation.IsCustomRelation);
end;
//=============================================================================

procedure TfmModel.popNodePopup(Sender: TObject);
begin
  mniDeleteCustomRelation2.Enabled := (TModel(Model).FocusedRelation <> nil) and (TModel(Model).FocusedRelation.IsCustomRelation);
end;
//=============================================================================

procedure TfmModel.mniDeleteNodeClick(Sender: TObject);
begin
  if TModel(Model).FocusedRelation <> nil then
  begin
    TModel(Model).FocusedRelation.DeleteNode(TModel(Model).FocusedRelation.FocusedNode);
    TModel(Model).Invalidate;
  end;
end;
//=============================================================================

procedure TfmModel.actModelCreateRelationExecute(Sender: TObject);
begin
  with TModel(Model) do
  begin
    if actModelCreateRelation.Checked then
    begin
      Screen.Cursor := crCustomLinkTo;
      //OnClick(Sender); //deselects all
      TModel(Model).CustomRelationAFrame := '';
      TModel(Model).CustomRelationBFrame := '';
      AddingRelation := true;
    end
    else
    begin
      Screen.Cursor := crDefault;
      AddingRelation := false;
    end;
  end;
end;
//=============================================================================

procedure TfmModel.mniDropRelationClick(Sender: TObject);
var
  sSql, relname: string;
  Script: TIB_Script;
begin
  if TModel(Model).FocusedRelation <> nil then
  begin
    relname := TModel(Model).FocusedRelation.DBName;
    if MessageDlg(Format('Do you want to drop the relation %s from database?', [relname]), mtConfirmation, [mbYes,mbNo], 0) = mrYes then
    begin
      sSql := Format('ALTER TABLE %s DROP CONSTRAINT %s;' + #13#10#13#10 + 'COMMIT WORK;', [TModel(Model).FocusedRelation.AFrame.FrameName, relname]);
      sSql := Format('/*Script generated by IBUtils  %s */' + #13#10#13#10 + sSql, [FormatDateTime('dd.mm.yyyy hh:mm', Now)]);
      Script := TIB_Script.Create(Self);
      Script.IB_Connection := TModel(Model).ModelForm.cnModel;
      try
        Script.SQL.Text := sSql;
        Script.Execute;
        TModel(Model).FocusedRelation.Free;
        TModel(Model).FocusedRelation := nil;
        TModel(Model).Modified := true;
        TModel(Model).Refresh;
        TModel(Model).Invalidate;
        TimeMessage('Relation was successfully dropped.', 500);
        //MessageDlg(Format('The relation %s was successfully dropped from database.', [relname]), mtInformation, [mbOK], 0);

         MakeLogDef(Script.IB_Connection, sSql);
      finally
        Script.Free;
      end;
    end;
  end;
end;
//=============================================================================

procedure TfmModel.actModelCreateTableXYExecute(Sender: TObject);
var
  fm: TfmCreateTable;
begin
  fm := TfmCreateTable.Create(Application);
  fm.FaceCreateTable;
  //fm.BehaveAsModal := true;
  fm.Model := TModel(Model);
  fm.pgMain.ActivePage := fm.tsCreateTable;
  fm.EnableButtons;
  fm.Script.IB_Connection := TModel(Model).ModelForm.cnModel;
  fm.RunScript.IB_Connection := TModel(Model).ModelForm.cnModel;
  fm.AddX := fm.Model.ScreenToClient(popModel.PopupPoint).X; //fm.Model.ScreenToClient(Mouse.CursorPos).X;
  fm.AddY := fm.Model.ScreenToClient(popModel.PopupPoint).Y; //fm.Model.ScreenToClient(Mouse.CursorPos).Y;
  fm.ShowModal;
end;
//=============================================================================

destructor TfmModel.Destroy;
var
  i: integer;
begin
  for i := FBrowseList.Count-1 downto 0 do
    TfmBrowse(FBrowseList[i]).Free;
  FBrowseList.Free;
  inherited;
end;
//=============================================================================

procedure TfmModel.actRunScriptExecute(Sender: TObject);
var
  fm: TfmCreateTable;
begin
  fm := TfmCreateTable.Create(Application);
  with fm do
  begin
    Script.IB_Connection := cnModel;
    RunScript.IB_Connection := cnModel;
    if not cnModel.Connected then
      cnModel.Connect;
    //FormStyle := fsMDIChild;
    FaceRunScript;
    fm.Caption := fm.Caption + ' - ' + cnModel.Database + ' (' + ExtractFileName(TModel(Self.Model).Filename) + ')';
    ShowModal;
  end;
  CheckConnected;
end;
//=============================================================================

procedure TfmModel.actSnapToGridExecute(Sender: TObject);
begin
  TModel(Model).SnapToGrid := actSnapToGrid.Checked;
  TModel(Model).Modified := true;
end;
//=============================================================================

procedure TfmModel.actSnapRelToGridExecute(Sender: TObject);
begin
  TModel(Model).SnapRelToGrid := actSnapRelToGrid.Checked;
  TModel(Model).Modified := true;
end;
//=============================================================================

procedure TfmModel.actShowGridExecute(Sender: TObject);
begin
  TModel(Model).ShowGrid := actShowGrid.Checked;
  TModel(Model).Invalidate;
  TModel(Model).Modified := true;
end;
//=============================================================================

procedure TfmModel.actImportModelExecute(Sender: TObject);
var
  x, y, tmpScale: integer;
  mdl: TModel;
begin
  if fmMain.ODlg.Execute then
  begin
    mdl:= TModel(Model);
    mdl.DeselectFrames;
    x := mdl.bx;
    y := mdl.by;
    x := Round(x * 100 / mdl.CurrentScale);
    y := Round(y * 100 / mdl.CurrentScale);

    tmpScale := mdl.CurrentScale;
    mdl.Visible := false;
    try
      mdl.Scale(100);
      mdl.ImportTables(ChangeFileExt(fmMain.ODlg.Filename, '.tbl'), Point(x, y), true);
      mdl.Scale(tmpScale);
    finally
      mdl.Visible := true;
    end;
//    mdl.Invalidate;
  end;
end;
//=============================================================================

procedure TfmModel.actNewModelFromSelectedExecute(Sender: TObject);
var
  CurrentModel, NewModel: TModel;
  fm: TfmModel;
  i, minx, miny: integer;
  fra, tbl: TfraTable;
  tmp: TfraMain;
begin
  Screen.Cursor := crHourGlass;
  try
    CurrentModel := TModel(Model);
    fm := TfmModel.Create(Application);
    NewModel := TModel(fm.Model);
    NewModel.Visible := false;
    NewModel.AddTablesFilter := 'RDB$RELATION_NAME NOT CONTAINING ''$''';

    NewModel.DefaultShowOptions := CurrentModel.DefaultShowOptions;
    NewModel.LinkColorDefault := CurrentModel.LinkColorDefault;
    NewModel.LinkColorSelected := CurrentModel.LinkColorSelected;
    NewModel.LinkColorFocused := CurrentModel.LinkColorFocused;
    NewModel.LinkColorCustom := CurrentModel.LinkColorCustom;
    NewModel.DefColCount := CurrentModel.DefColCount;
    NewModel.SnapToGrid := CurrentModel.SnapToGrid;
    NewModel.SnapRelToGrid := CurrentModel.SnapRelToGrid;
    NewModel.ShowGrid := CurrentModel.ShowGrid;
    NewModel.GridX := CurrentModel.GridX;
    NewModel.GridY := CurrentModel.GridY;
    NewModel.Password := CurrentModel.Password;
    NewModel.Username := CurrentModel.Username;
    NewModel.ShowSystemDomains := CurrentModel.ShowSystemDomains;
    NewModel.CombinedTypeDomain := CurrentModel.CombinedTypeDomain;

    fm.cnModel.Database := cnModel.Database;
    fm.cnModel.Path := cnModel.Path;
    fm.cnModel.Server := cnModel.Server;
    fm.cnModel.UserName := cnModel.UserName;
    fm.cnModel.Password := cnModel.Password;
    fm.cnModel.FieldsCharCase.Text := cnModel.FieldsCharCase.Text;
    fm.cnModel.LoginPrompt := false;
    fm.cnModel.Connect;

    for i := 0 to CurrentModel.SelectedFrameCount-1 do
    begin
      if CurrentModel.SelectedFrames[i] is TfraTable then
      begin
        fra := TfraTable(CurrentModel.SelectedFrames[i]);
        tbl := TfraTable.CreateByName(NewModel, fra.TableName);
        NewModel.AddFrame(tbl);
        tbl.Left := fra.OrigLeft;
        tbl.Top := fra.OrigTop;
        tbl.Width := fra.OrigWidth;
        tbl.Height := fra.OrigHeight;
        tbl.ShowOptions := fra.ShowOptions;
      end;
    end;

    //zjisti minimální hodnoty souøadnic
    minx := MaxInt;
    miny := MaxInt;
    for i := 0 to NewModel.FrameCount-1 do
    begin
      tmp := NewModel.Frames[i];
      minx := Min(minx, tmp.Left);
      miny := Min(miny, tmp.Top);
    end;
    minx := minx - 10;
    miny := miny - 10;
    //posunout všechny tabulky doleva a nahoru
    for i := 0 to NewModel.FrameCount-1 do
    begin
      tmp := NewModel.Frames[i];
      tmp.SetBounds(tmp.Left - minx, tmp.Top - miny, tmp.Width, tmp.Height);
      tmp.SaveCoordToOrig;
      tbl.Refresh;
      tbl.RefreshRelations;
    end;

    NewModel.Refresh;
    NewModel.Visible := true;
    fm.Show;
  finally
    Screen.Cursor := crDefault;
  end;
end;
//=============================================================================

procedure TfmModel.ToolButton29Click(Sender: TObject);
begin
  MessageDlg(IntToStr(Integer(cnModel.Connected)), mtWarning, [mbOK], 0);
end;
//============================================================================

procedure TfmModel.CheckConnected(AConnection: TIB_Connection = nil);
begin
  if AConnection = nil then
    AConnection := cnModel;
  if not bKeepConnection then
    AConnection.Disconnect;
  SetDatabaseStatus(AConnection);
end;
//============================================================================

procedure TfmModel.SetDatabaseStatus(AConnection: TIB_Connection = nil);
var
  sText: string;
begin
  if AConnection = nil then
    AConnection := cnModel;
  sText := 'Database: ' + AConnection.Database;
  if AConnection.Connected then
    sText := sText + '    Connected'
  else
    sText := sText + '    Disconnected';
  fmMain.StatusBar.Panels.Items[1].Text := sText;
end;
//============================================================================

end.

