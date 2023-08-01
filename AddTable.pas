unit AddTable;

{$I IBUtils.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, IB_Components, StdCtrls, Grids, IB_Grid, AKLabel, fraTable_u, fraMain_u,
  Placemnt, ExtCtrls, Buttons, ComCtrls, ToolWin, ActnList;

type
  TfmAddTable = class(TForm)
    dsTables: TIB_DataSource;
    qrTables: TIB_Query;
    grTables: TIB_Grid;
    lblList: TAKLabel;
    lblSearch: TAKLabel;
    Panel1: TPanel;
    btAdd: TButton;
    btAddAll: TButton;
    btClose: TButton;
    lblFilter: TAKLabel;
    pnlFilter: TPanel;
    cmbFilter: TComboBox;
    FormStorage: TFormStorage;
    tlbFilter: TToolBar;
    ToolButton2: TToolButton;
    alAddTable: TActionList;
    actClearFilter: TAction;
    ToolButton1: TToolButton;
    actPermanentFilter: TAction;
    procedure FormShow(Sender: TObject);
    procedure btAddClick(Sender: TObject);
    procedure qrTablesPrepareSQL(Sender: TIB_Statement);
    procedure btAddAllClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure grTablesDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmbFilterKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grTablesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grTablesKeyPress(Sender: TObject; var Key: Char);
    procedure grTablesEnter(Sender: TObject);
    procedure cmbFilterEnter(Sender: TObject);
    procedure cmbFilterExit(Sender: TObject);
    procedure grTablesExit(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure actClearFilterExecute(Sender: TObject);
    procedure actPermanentFilterExecute(Sender: TObject);
  private
    nAddedTables: integer;
    bMustRefresh, bWasSpace: boolean;
    procedure UpdateIncSearchLabel;
    function BuildFilter: string;
  public
    Model: TModel;
    AddX, AddY: integer;
  end;

var
  fmAddTable: TfmAddTable;

implementation

uses MAIN;

{$R *.dfm}

procedure TfmAddTable.FormShow(Sender: TObject);
begin
  actPermanentFilter.Enabled := Model.AddTablesFilter <> '';
  actPermanentFilter.Checked := Model.AddTablesFilter <> '';
  if Model.AddTablesFilter <> '' then
    actPermanentFilter.Hint := actPermanentFilter.Hint + #13#10 + Model.AddTablesFilter;
  qrTables.Filter := BuildFilter;
  qrTables.Filtered := true;
  qrTables.Open;
  btAdd.Enabled := (qrTables.RecordCount > 0);
  btAddAll.Enabled := btAdd.Enabled;
  bMustRefresh := false;
  grTables.SetFocus;
end;
//=============================================================================

procedure TfmAddTable.btAddClick(Sender: TObject);
var
  i: integer;
  sBookmarks: TStringList;
  tbl: TfraTable;
begin
  sBookmarks := TStringList.Create;
  with qrTables do
  begin
    bMustRefresh := true;
    SelectedBookmarks(sBookmarks);
    if sBookmarks.Count = 0 then
    begin
      //tbl := Model.AddTable(FieldByName('TABLE_NAME').AsString); //dbg
      tbl := TfraTable.CreateByName(Model, FieldByName('TABLE_NAME').AsString);
      Model.AddFrame(tbl);
      tbl.Left := AddX + (nAddedTables * (tbl.lblTableName.Height + tbl.lblTableName.Top)); //Model.RelPointer
      tbl.Top := AddY + (nAddedTables * (tbl.lblTableName.Height + tbl.lblTableName.Top));    
      tbl.SaveCoordToOrig;
      Inc(nAddedTables);
      tbl.Visible := true;
      tbl.Refresh;
      tbl.Arrange;
      tbl.RefreshRelations;
    end
    else
      for i := 0 to sBookmarks.Count - 1 do
      begin
        Bookmark := sBookmarks[i];
//        tbl := Model.AddTable(FieldByName('TABLE_NAME').AsString);
        tbl := TfraTable.CreateByName(Model, FieldByName('TABLE_NAME').AsString);
        Model.AddFrame(tbl);
        tbl.Left := AddX + (nAddedTables * (tbl.lblTableName.Height + tbl.lblTableName.Top)); //Model.RelPointer
        tbl.Top := AddY + (nAddedTables * (tbl.lblTableName.Height + tbl.lblTableName.Top));
        tbl.SaveCoordToOrig;
        Inc(nAddedTables);
        tbl.Visible := true;
        tbl.Refresh;
        tbl.Arrange;
        tbl.RefreshRelations;
        BookmarkSelected[sBookmarks[i]] := false;
      end;
    sBookmarks.Free;
    //Unprepare;
    //Open;
    qrTables.Filter := BuildFilter;
    Refresh;
    ClearIncSearchString;
    UpdateIncSearchLabel;
  end;
end;
//=============================================================================

procedure TfmAddTable.btAddAllClick(Sender: TObject);
var
  tbl: TfraTable;
begin
  with qrTables do
  begin
    bMustRefresh := true;
    First;
    while not Eof do
    begin
//      tbl := Model.AddTable(FieldByName('TABLE_NAME').AsString);
      tbl := TfraTable.CreateByName(Model, FieldByName('TABLE_NAME').AsString);
      Model.AddFrame(tbl);
      tbl.Left := AddX + (nAddedTables * Model.RelPointer);
      tbl.Top := AddY + (nAddedTables * Model.RelPointer);
      tbl.SaveCoordToOrig;
      tbl.Visible := true;
      Inc(nAddedTables);
      Next;
    end;
  end;
  Close;
end;
//=============================================================================

procedure TfmAddTable.qrTablesPrepareSQL(Sender: TIB_Statement);
begin
  //  if Model.AddTablesFilter <> '' then
  //    qrTables.SQLWhereItems.Add(Model.AddTablesFilter);
end;
//=============================================================================

procedure TfmAddTable.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if bMustRefresh then
    Model.Refresh;
  Action := caFree;
end;
//=============================================================================

procedure TfmAddTable.grTablesDblClick(Sender: TObject);
begin
  btAdd.Click();
end;
//=============================================================================

procedure TfmAddTable.FormCreate(Sender: TObject);
begin
  nAddedTables := 0;
  AddX := 10;
  AddY := 10;
  FormStorage.IniFileName := ExtractFilePath(Application.ExeName) + 'ibutils.ini';
end;
//=============================================================================

procedure TfmAddTable.UpdateIncSearchLabel;
begin
  lblSearch.Caption := '   Incremental Search: ' + qrTables.IncSearchKeyString;
end;
//============================================================================

function TfmAddTable.BuildFilter: string;
var
  sFilter: string;
begin
  Result := ' (RDB$RELATION_NAME NOT IN (' + Model.ListOfTables + ') ) ';

  if cmbFilter.Text <> '' then
  begin
    sFilter := StringReplace(cmbFilter.Text, '*', '%', [rfReplaceAll]);
    Result := Result + ' AND (RDB$RELATION_NAME CONTAINING ''' + sFilter + ''')';
    actClearFilter.Enabled := true;
  end;

  if actPermanentFilter.Checked then
    Result := Result + ' AND (' + Model.AddTablesFilter + ')';
end;
//============================================================================

procedure TfmAddTable.cmbFilterKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      begin
        with cmbFilter do
        begin
          if Items.IndexOf(Text) = -1 then
            Items.Add(Text);
        end;
        qrTables.Filter := BuildFilter;
      end;
  end;
end;
//============================================================================

procedure TfmAddTable.grTablesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and (Key = VK_SPACE) then
  begin
    bWasSpace := true;
    qrTables.ClearIncSearchString;
    UpdateIncSearchLabel;
  end;
  if Key = VK_RETURN then
  begin
    btAdd.Click;
  end;
end;
//============================================================================

procedure TfmAddTable.grTablesKeyPress(Sender: TObject; var Key: Char);
begin
  if not bWasSpace then
  begin
    qrTables.IncSearchKey(Key, true, true, true);
    UpdateIncSearchLabel;
  end
  else
    bWasSpace := false;
end;
//============================================================================

procedure TfmAddTable.grTablesEnter(Sender: TObject);
begin
  lblList.Font.Style := [fsBold];
end;
//============================================================================

procedure TfmAddTable.cmbFilterEnter(Sender: TObject);
begin
  lblFilter.Font.Style := [fsBold];
end;
//============================================================================

procedure TfmAddTable.cmbFilterExit(Sender: TObject);
begin
  lblFilter.Font.Style := [];
end;
//============================================================================

procedure TfmAddTable.grTablesExit(Sender: TObject);
begin
  lblList.Font.Style := [];
end;
//============================================================================

procedure TfmAddTable.FormResize(Sender: TObject);
const
  Space = 10;
begin
  tlbFilter.Left := pnlFilter.Width - tlbFilter.Width;
  cmbFilter.Width := pnlFilter.Width - tlbFilter.Width - Space;
end;
//============================================================================

procedure TfmAddTable.actClearFilterExecute(Sender: TObject);
begin
  cmbFilter.Text := '';
  qrTables.Filter := BuildFilter;
  actClearFilter.Enabled := false;
end;
//============================================================================

procedure TfmAddTable.actPermanentFilterExecute(Sender: TObject);
begin
  qrTables.Filter := BuildFilter;
end;
//============================================================================

end.

