unit Indexes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Placemnt, IB_Components, StdCtrls, AKLabel, ExtCtrls, Grids,
  IB_Grid, fraTable_u;

type
  TfmIndexes = class(TForm)
    FormStorage: TFormStorage;
    qrIndexes: TIB_Query;
    qrIndexSeg: TIB_Query;
    dsIndexes: TIB_DataSource;
    Panel1: TPanel;
    lblTitle: TAKLabel;
    grIndexes: TIB_Grid;
    btCancel: TButton;
    btCreate: TButton;
    btDrop: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure qrIndexesCalculateField(Sender: TIB_Statement; ARow: TIB_Row;
      AField: TIB_Column);
    procedure btCreateClick(Sender: TObject);
    procedure btDropClick(Sender: TObject);
  public
    Table: TfraTable;
  end;

var
  fmIndexes: TfmIndexes;

implementation

uses Model, IB_Script, fraMain_u, Main;

{$R *.dfm}

procedure TfmIndexes.FormCreate(Sender: TObject);
begin
  FormStorage.IniFileName := ExtractFilePath(Application.ExeName) + 'ibutils.ini';
end;
//=============================================================================

procedure TfmIndexes.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;
//=============================================================================

procedure TfmIndexes.qrIndexesCalculateField(Sender: TIB_Statement;
  ARow: TIB_Row; AField: TIB_Column);
var
  S: string;
begin
  if AField.FieldName = 'FIELDS_LIST' then
  begin
    with qrIndexSeg do
    begin
      Close;
      Prepare;
      ParamByName('INDEX_NAME').AsString := Trim(ARow.ByName('RDB$INDEX_NAME').AsString);
      Open;
     while not Eof do
     begin
       if S <> '' then
         S := S + ',';
       S := S + FieldByName('RDB$FIELD_NAME').AsString;
       Next;
     end;
     AField.AsString := S;
    end;
  end
  else
  if AField.FieldName = 'INDEX_INACTIVE' then
  begin
    if ARow.ByName('RDB$INDEX_INACTIVE').IsNull then
      AField.AsInteger := 0
    else
      AField.AsInteger := ARow.ByName('RDB$INDEX_INACTIVE').AsInteger;
  end
  else
  if AField.FieldName = 'UNIQUE_FLAG' then
  begin
    if ARow.ByName('RDB$UNIQUE_FLAG').IsNull then
      AField.AsInteger := 0
    else
      AField.AsInteger := ARow.ByName('RDB$UNIQUE_FLAG').AsInteger;
  end;
end;
//=============================================================================

procedure TfmIndexes.btCreateClick(Sender: TObject);
begin
  Table.CreateIndexes;
  qrIndexes.Refresh;
end;
//=============================================================================

procedure TfmIndexes.btDropClick(Sender: TObject);
var
  sSql: string;
  Script: TIB_Script;
  i: integer;
  SL: TStringList;
begin
  if MessageDlg('Do you really want to drop the selected indices?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    SL := TStringList.Create;
    Script := TIB_Script.Create(Self);
    try
      qrIndexes.SelectedBookmarks(SL);
      if SL.Count = 0 then
        SL.Add(qrIndexes.Bookmark);
      for i := 0 to SL.Count-1 do
      begin
        qrIndexes.Bookmark := SL[i];
        sSql := Format('DROP INDEX %s;' + #13#10{#13#10 + 'COMMIT WORK;'}, [qrIndexes.FieldByName('RDB$INDEX_NAME').AsString]);
        sSql := Format('/*Script generated by IBUtils  %s */' + #13#10#13#10 + sSql, [FormatDateTime('dd.mm.yyyy hh:mm', Now)]);
        Script.IB_Connection := TModel(Table.Model).ModelForm.cnModel;
        Script.SQL.Text := sSql;
        Script.Execute;
        MakeLogDef(Script.IB_Connection, sSql);
      end;
      qrIndexes.Refresh;
      Table.mniRefreshClick(nil);
      if SL.Count = 1 then
        TimeMessage('Index was successfully dropped.', 500)
      else
        TimeMessage('Indices were successfully dropped.', 500)
    finally
      Script.Free;
      SL.Free;
    end;
  end;
end;
//=============================================================================

end.
