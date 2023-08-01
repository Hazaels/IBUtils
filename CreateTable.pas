unit CreateTable;

{$I IBUtils.inc}

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls, IB_Components,
  IB_Process, IB_Script, Mask, ToolEdit, Placemnt, SysUtils, IB_Parse,
  ExtCtrls, ComCtrls, AKLabel, Buttons, fraMain_u, SynEditHighlighter,
  SynHighlighterSQL, SynEdit, ToolWin, ActnList;

type
  TfmCreateTable = class(TForm)
    Script: TIB_Script;
    fsCreateTable: TFormStorage;
    RunScript: TIB_Script;
    trCreateTable: TIB_Transaction;
    pgMain: TPageControl;
    tsScript: TTabSheet;
    tsCreateTable: TTabSheet;
    tsCreateRelation: TTabSheet;
    pnlCreateTable: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    edTableName: TEdit;
    edPK_Name: TEdit;
    pnlCreateRelation: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    edRelTableName: TEdit;
    edRelFieldName: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    edRelFkTableName: TEdit;
    edRelFkFieldName: TEdit;
    AKLabel1: TAKLabel;
    AKLabel2: TAKLabel;
    lblTableTemplate: TAKLabel;
    lblRelationTemplate: TAKLabel;
    AKLabel5: TAKLabel;
    cmbUpdateRule: TComboBox;
    cmbDeleteRule: TComboBox;
    Label3: TLabel;
    Label6: TLabel;
    meScript: TSynEdit;
    SynSQLSyn: TSynSQLSyn;
    meTableTemplate: TSynEdit;
    meRelationTemplate: TSynEdit;
    ToolBar1: TToolBar;
    btCreateScript: TToolButton;
    btRunScript: TToolButton;
    ActionList: TActionList;
    actCreateScript: TAction;
    actRunScript: TAction;
    ToolButton1: TToolButton;
    actSave: TAction;
    ToolButton2: TToolButton;
    actCommit: TAction;
    actRollback: TAction;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    actOpen: TAction;
    ToolButton6: TToolButton;
    StatusBar: TStatusBar;
    tsCreateIndex: TTabSheet;
    Panel1: TPanel;
    Label9: TLabel;
    Label10: TLabel;
    AKLabel3: TAKLabel;
    edIndTableName: TEdit;
    edIndFieldsList: TEdit;
    AKLabel4: TAKLabel;
    meIndexTemplate: TSynEdit;
    chkIndUnique: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ScriptMacroSubstitute(Sender: TIB_Component;
      const ATextBlock: string; var ATextResult: string);
    procedure FormCreate(Sender: TObject);
    procedure CreateScript;
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pgMainChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actCreateScriptExecute(Sender: TObject);
    procedure actRunScriptExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actCommitExecute(Sender: TObject);
    procedure actRollbackExecute(Sender: TObject);
    procedure actOpenExecute(Sender: TObject);
    procedure actCommitUpdate(Sender: TObject);
  private
    bCreatingTable: boolean; //false = CreateRelation
    function MySubstituteMacros(const ATextBlock: string): string;
  public
    //BehaveAsModal: boolean;
    Model: TModel;
    AddX, AddY: integer;
    AddToModel: boolean;
    bRunScript: boolean;
    procedure FaceCreateTable;
    procedure FaceRunScript;
    procedure FaceCreateRelation;
    procedure FaceCreateIndex;
    procedure FaceCreateField;
    procedure EnableButtons;
    procedure SetSaveCaptions;
    procedure Loaded; override;
  end;

implementation

uses MAIN, Dialogs, fraTable_u;

var
  TableTemplateFilename, RelationTemplateFilename, IndexTemplateFilename: string;

{$R *.dfm}

procedure TfmCreateTable.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;
//=============================================================================

procedure TfmCreateTable.ScriptMacroSubstitute(Sender: TIB_Component;
  const ATextBlock: string; var ATextResult: string);
begin
  if (ATextBlock = 'TABLE_NAME') and (pgMain.ActivePage = tsCreateTable ) then
    ATextResult := edTableName.Text
  else if (ATextBlock = 'TABLE_NAME') and (pgMain.ActivePage = tsCreateRelation ) then
    ATextResult := edRelTableName.Text
  else if (ATextBlock = 'TABLE_NAME') and (pgMain.ActivePage = tsCreateIndex ) then
    ATextResult := edIndTableName.Text
  else if ATextBlock = 'FIELD_NAME' then
    ATextResult := edRelFieldName.Text
  else if ATextBlock = 'FIELD_NAMES' then
  begin
    ATextResult := StringReplace(Trim(edIndFieldsList.Text), ',', '_', [rfReplaceAll]); //Ë·rky nahradit _
    ATextResult := StringReplace(ATextResult, ' ', '', [rfReplaceAll]); //zruöit mezery
  end
  else if ATextBlock = 'FIELDS_LIST' then
    ATextResult := edIndFieldsList.Text
  else if ATextBlock = 'UNIQUE_STATUS' then
  begin
    if chkIndUnique.Checked then
      ATextResult := 'UNIQUE'
    else
      ATextResult := '';
  end
  else if ATextBlock = 'FK_TABLE_NAME' then
    ATextResult := edRelFkTableName.Text
  else if ATextBlock = 'FK_FIELD_NAME' then
    ATextResult := edRelFkFieldName.Text
  else if ATextBlock = 'PK_NAME' then
    ATextResult := edPK_Name.Text
  else if ATextBlock = 'DATETIME' then
    ATextResult := FormatDateTime('dd.mm.yyyy hh:nn:ss', Now)
  else if ATextBlock = 'UPDATE_RULE' then
  begin
    if cmbUpdateRule.Text = 'NO ACTION' then
      ATextResult := ''
    else
      ATextResult := 'ON UPDATE ' + cmbUpdateRule.Text;
  end
  else if ATextBlock = 'DELETE_RULE' then
  begin
    if cmbDeleteRule.Text = 'NO ACTION' then
      ATextResult := ''
    else
      ATextResult := 'ON DELETE ' + cmbDeleteRule.Text;
  end
end;
//=============================================================================

procedure TfmCreateTable.FormCreate(Sender: TObject);
begin
  bRunScript := false;
  AddToModel := false;
  AddX := 0;
  AddY := 0;
  fsCreateTable.IniFileName := ExtractFilePath(Application.ExeName) + 'ibutils.ini';
end;
//=============================================================================

function TfmCreateTable.MySubstituteMacros(const ATextBlock: string): string;
begin
  Result := Script.MacroBegin + Script.MacroBegin + ATextBlock + Script.MacroEnd + Script.MacroEnd;
  ScriptMacroSubstitute(Script, ATextBlock, Result);
  if Result = Script.MacroBegin + Script.MacroBegin + ATextBlock + Script.MacroEnd + Script.MacroEnd then
    Result := Script.MacroBegin + ATextBlock + Script.MacroEnd;
end;
//============================================================================

procedure TfmCreateTable.CreateScript;
var
  SQLText: string;
  FCurrentSQL, FSetItem, FSetValue, TermKeyWord, OldTermKeyWord, Statement: string;
  FBeginPos, FEndPos: integer;
  SL: TStringList;
begin
  //meScript.Lines.Text := meTableTemplate.Lines.Text;
  //exit;
  FBeginPos := ParseLineInvalid;
  FEndPos := ParseLineEnd;
  OldTermKeyWord := ';';
  TermKeyWord := '';
  FCurrentSQL := '';
  SQLText := Script.SQL.Text;
  SL := TStringList.Create;
  try
    with SL do
    begin
      Clear;
      while GetNextScriptStatement(SQLText,
        FCurrentSQL, FSetItem, FSetValue,
        FBeginPos,
        FEndPos,
        TermKeyWord) do
      begin
        Statement := IB_Parse.SubstMacros(FCurrentSQL,
          MySubstituteMacros,
          Script.MacroBegin,
          Script.MacroEnd);

        if OldTermKeyWord <> TermKeyWord then
        begin
          Add('SET TERM ' + TermKeyWord + OldTermKeyWord + #13#10);
          OldTermKeyWord := TermKeyWord;
        end;

        Add(Statement + TermKeyWord + #13#10);
        FCurrentSQL := '';
      end;

      if OldTermKeyWord <> TermKeyWord then
      begin
        Add('SET TERM ' + TermKeyWord + OldTermKeyWord + #13#10);
        OldTermKeyWord := TermKeyWord;
      end;
    end;
    meScript.Lines.Text := SL.Text;
  finally
    SL.Free;
  end;
end;
//============================================================================

procedure TfmCreateTable.FormActivate(Sender: TObject);
begin
  {if cnCreateTable.Connected then
    fmMain.StatusBar.Panels.Items[1].Text := 'Database: ' + cnCreateTable.Database
  else
    fmMain.StatusBar.Panels.Items[1].Text := '';}
  //Model.ModelForm.CheckConnected;
end;
//============================================================================

procedure TfmCreateTable.FormDeactivate(Sender: TObject);
begin
  //Model.ModelForm.CheckConnected;
  //fmMain.StatusBar.Panels.Items[1].Text := '';
end;
//============================================================================

procedure TfmCreateTable.FormShow(Sender: TObject);
{const
  Space = 30;}
begin
//  TableTemplateFilename := ExtractFilePath(Application.ExeName) + 'CreateTableTemplate.txt';
//  if FileExists(TableTemplateFilename) then
//  begin
//    meTableTemplate.Lines.Clear;
//    meTableTemplate.Lines.LoadFromFile(TableTemplateFilename);
//  end;
//
//  RelationTemplateFilename := ExtractFilePath(Application.ExeName) + 'CreateRelationTemplate.txt';
//  if FileExists(RelationTemplateFilename) then
//  begin
//    meRelationTemplate.Lines.Clear;
//    meRelationTemplate.Lines.LoadFromFile(RelationTemplateFilename);
//  end;
//
//  lblTableTemplate.Caption := ' Script template (' + TableTemplateFilename + ')';
//  lblRelationTemplate.Caption := ' Script template (' + RelationTemplateFilename + ')';
end;
//============================================================================

procedure TfmCreateTable.FaceCreateTable;
begin
  pgMain.ActivePage := tsCreateTable;
  bCreatingTable := true;
  tsCreateTable.TabVisible := true;
  tsCreateRelation.TabVisible := false;
  tsCreateIndex.TabVisible := false;
  actCommit.Visible := false;
  actRollback.Visible := false;
  Caption := 'Create Table';
  EnableButtons;
  SetSaveCaptions;
  ActiveControl := edTableName;
end;
//=============================================================================

procedure TfmCreateTable.FaceCreateRelation;
begin
  pgMain.ActivePage := tsCreateRelation;
  bCreatingTable := false;
  tsCreateTable.TabVisible := false;
  tsCreateRelation.TabVisible := true;
  tsCreateIndex.TabVisible := false;
  actCommit.Visible := false;
  actRollback.Visible := false;
  Caption := 'Create Relation';
  EnableButtons;
  SetSaveCaptions;
end;
//=============================================================================

procedure TfmCreateTable.FaceCreateIndex;
begin
  pgMain.ActivePage := tsCreateIndex;
  bCreatingTable := false;
  tsCreateTable.TabVisible := false;
  tsCreateRelation.TabVisible := false;
  tsCreateIndex.TabVisible := true;
  actCommit.Visible := false;
  actRollback.Visible := false;
  Caption := 'Create Index';
  EnableButtons;
  SetSaveCaptions;
end;
//=============================================================================

procedure TfmCreateTable.FaceCreateField;
begin
  bCreatingTable := false;
  tsCreateTable.TabVisible := false;
  tsCreateRelation.TabVisible := false;
  tsCreateIndex.TabVisible := false;
  actCommit.Visible := false;
  actRollback.Visible := false;
  Caption := 'Create Field';
  pgMain.ActivePageIndex := 0;
  //meScript.SetFocus;
  EnableButtons;
  SetSaveCaptions;
  ActiveControl := meScript;
end;
//=============================================================================

procedure TfmCreateTable.FaceRunScript;
begin
  bRunScript := true;
  pgMain.ActivePage := tsScript;
  tsCreateTable.TabVisible := false;
  tsCreateRelation.TabVisible := false;
  tsCreateIndex.TabVisible := false;
  actCommit.Visible := true;
  actRollback.Visible := true;
  Caption := 'Run script';
  EnableButtons;
  SetSaveCaptions;
  //meScript.Visible := true;
  //meScript.Enabled := true;
//  ActiveControl := meScript;
end;
//=============================================================================

procedure TfmCreateTable.pgMainChange(Sender: TObject);
begin
  EnableButtons;
  SetSaveCaptions;
end;
//=============================================================================

procedure TfmCreateTable.EnableButtons;
begin
  actCreateScript.Enabled := (pgMain.ActivePage = tsCreateTable) or (pgMain.ActivePage = tsCreateRelation) or (pgMain.ActivePage = tsCreateIndex);
  actRunScript.Enabled := pgMain.ActivePage = tsScript;
  actOpen.Enabled := pgMain.ActivePage = tsScript;
end;
//=============================================================================

procedure TfmCreateTable.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE: ModalResult := mrCancel;
  end;
end;
//=============================================================================

procedure TfmCreateTable.Loaded;
begin
  inherited;
  TableTemplateFilename := ExtractFilePath(Application.ExeName) + 'CreateTableTemplate.txt';
  if FileExists(TableTemplateFilename) then
  begin
    meTableTemplate.Lines.Clear;
    meTableTemplate.Lines.LoadFromFile(TableTemplateFilename);
  end;

  RelationTemplateFilename := ExtractFilePath(Application.ExeName) + 'CreateRelationTemplate.txt';
  if FileExists(RelationTemplateFilename) then
  begin
    meRelationTemplate.Lines.Clear;
    meRelationTemplate.Lines.LoadFromFile(RelationTemplateFilename);
  end;

  IndexTemplateFilename := ExtractFilePath(Application.ExeName) + 'CreateIndexTemplate.txt';
  if FileExists(IndexTemplateFilename) then
  begin
    meIndexTemplate.Lines.Clear;
    meIndexTemplate.Lines.LoadFromFile(IndexTemplateFilename);
  end;

  lblTableTemplate.Caption := ' Script template (' + TableTemplateFilename + ')';
  lblRelationTemplate.Caption := ' Script template (' + RelationTemplateFilename + ')';
  lblRelationTemplate.Caption := ' Script template (' + IndexTemplateFilename + ')';
end;
//=============================================================================

procedure TfmCreateTable.actCreateScriptExecute(Sender: TObject);
begin
  tsScript.TabVisible := true;
  if pgMain.ActivePage = tsCreateTable then
  begin
    if Trim(edTableName.Text) = '' then
    begin
      MessageDlg('Table name is empty!', mtWarning, [mbOK], 0);
      Exit;
    end;
    if Trim(edPK_Name.Text) = '' then
    begin
      MessageDlg('Primary key is empty!', mtWarning, [mbOK], 0);
      Exit;
    end;
    Script.SQL.Assign(meTableTemplate.Lines)
  end
  else if pgMain.ActivePage = tsCreateRelation then
  begin
    if Trim(edRelTableName.Text) = '' then
    begin
      MessageDlg('Table name is empty!', mtWarning, [mbOK], 0);
      Exit;
    end;
    if Trim(edRelFieldName.Text) = '' then
    begin
      MessageDlg('Field name is empty!', mtWarning, [mbOK], 0);
      Exit;
    end;
    if Trim(edRelFkTableName.Text) = '' then
    begin
      MessageDlg('Foreign key table name is empty!', mtWarning, [mbOK], 0);
      Exit;
    end;
    if Trim(edRelFkFieldName.Text) = '' then
    begin
      MessageDlg('Foreign key field name is empty!', mtWarning, [mbOK], 0);
      Exit;
    end;
    Script.SQL.Assign(meRelationTemplate.Lines);
  end
  else if pgMain.ActivePage = tsCreateIndex then
  begin
    if Trim(edIndTableName.Text) = '' then
    begin
      MessageDlg('Table name is empty!', mtWarning, [mbOK], 0);
      Exit;
    end;
    if Trim(edIndFieldsList.Text) = '' then
    begin
      MessageDlg('Fields list is empty!', mtWarning, [mbOK], 0);
      Exit;
    end;
    Script.SQL.Assign(meIndexTemplate.Lines);
  end;

  CreateScript;
  pgMain.ActivePage := tsScript;
  EnableButtons;
  SetSaveCaptions;
end;
//=============================================================================

procedure TfmCreateTable.actRunScriptExecute(Sender: TObject);
var
  tbl: TfraTable;
begin
  if not RunScript.IB_Connection.Connected then
    RunScript.IB_Connection.Connect;
  if meScript.Lines.Text <> '' then
  begin
    StatusBar.SimpleText := '';
    if meScript.SelLength > 0 then
      RunScript.SQL.Text := meScript.SelText
    else
      RunScript.SQL.Assign(meScript.Lines);
    if not RunScript.IB_Transaction.InTransaction then
      RunScript.IB_Transaction.StartTransaction;
    try
      RunScript.Execute;
      if bRunScript then
      begin
        StatusBar.SimpleText := 'The script has been executed successfully.';
        TimeMessage('The script has been executed successfully.', 350);
      end
      else
      begin
        RunScript.IB_Transaction.Commit;
        TimeMessage('The script has been executed successfully.', 500);
        //MessageDlg('The script has been executed successfully.', mtInformation, [mbOK], 0);
      end;
    except
      //RunScript.IB_Transaction.Rollback;
      StatusBar.SimpleText := 'The script raised an exception.';
      raise;
    end;

    MakeLogDef(RunScript.IB_Connection, meScript.Lines.Text);
  end
  else
    MessageDlg('The script memo contains no script!', mtWarning, [mbOK], 0);

  if not bRunScript then
  begin
    if bCreatingTable then
    begin
      tbl := TfraTable.CreateByName(Model, edTableName.Text);
      Model.AddFrame(tbl);
      tbl.Left := AddX;
      tbl.Top := AddY;
      tbl.SaveCoordToOrig;
      tbl.Visible := true;
      tbl.Refresh;
      tbl.RefreshRelations;
    end
    else //creating relation
    begin
      Model.Refresh;
      Model.Invalidate;
    end;

    ModalResult := mrOk;
  end;
end;
//=============================================================================

procedure TfmCreateTable.actSaveExecute(Sender: TObject);
var
  dlg: TSaveDialog;
begin
  if pgMain.ActivePage = tsScript then
  begin
    dlg := TSaveDialog.Create(Self);
    if dlg.Execute then
      meScript.Lines.SaveToFile(dlg.FileName);
  end
  else
  if pgMain.ActivePage = tsCreateTable then
  begin
    if FileExists(TableTemplateFilename) and (MessageDlg('File already exists. Do you want to replace it?', mtConfirmation, [mbYes,mbNo], 0) = mrNo) then
      Exit;
    meTableTemplate.Lines.SaveToFile(TableTemplateFilename);
  end
  else
  if pgMain.ActivePage = tsCreateRelation then
  begin
    if FileExists(RelationTemplateFilename) and (MessageDlg('File already exists. Do you want to replace it?', mtConfirmation, [mbYes,mbNo], 0) = mrNo) then
      Exit;
    meRelationTemplate.Lines.SaveToFile(RelationTemplateFilename);
  end
  else
  if pgMain.ActivePage = tsCreateIndex then
  begin
    if FileExists(IndexTemplateFilename) and (MessageDlg('File already exists. Do you want to replace it?', mtConfirmation, [mbYes,mbNo], 0) = mrNo) then
      Exit;
    meIndexTemplate.Lines.SaveToFile(IndexTemplateFilename);
  end;
end;
//=============================================================================

procedure TfmCreateTable.SetSaveCaptions;
begin
if pgMain.ActivePage = tsScript then
    actSave.Caption := 'Save script'
  else
  if pgMain.ActivePage = tsCreateTable then
    actSave.Caption := 'Save table template'
  else
  if pgMain.ActivePage = tsCreateRelation then
    actSave.Caption := 'Save relation template'
  else
  if pgMain.ActivePage = tsCreateIndex then
    actSave.Caption := 'Save index template';
  actSave.Hint := actSave.Caption;
end;
//=============================================================================

procedure TfmCreateTable.actCommitExecute(Sender: TObject);
begin
  RunScript.IB_Transaction.Commit;
  StatusBar.SimpleText := '';
  MakeLogDef(RunScript.IB_Connection, 'COMMIT WORK;');
end;
//=============================================================================

procedure TfmCreateTable.actRollbackExecute(Sender: TObject);
begin
  RunScript.IB_Transaction.Rollback;
  StatusBar.SimpleText := '';
  MakeLogDef(RunScript.IB_Connection, 'ROLLBACK WORK;');
end;
//=============================================================================

procedure TfmCreateTable.actOpenExecute(Sender: TObject);
var
  ODlg: TOpenDialog;
begin
  if pgMain.ActivePage = tsScript then
  begin
    ODlg := TOpenDialog.Create(Self);
    ODlg.Title := 'Open script';
    ODlg.Filter := 'Script files(*.sql)|*.sql';
    ODlg.DefaultExt := 'sql';

    if ODlg.Execute then
      meScript.Lines.LoadFromFile(ODlg.FileName);
  end;
end;
//=============================================================================

procedure TfmCreateTable.actCommitUpdate(Sender: TObject);
begin
  actCommit.Enabled := RunScript.IB_Transaction.InTransaction;
  actRollback.Enabled := RunScript.IB_Transaction.InTransaction;
end;
//=============================================================================

end.

