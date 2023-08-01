unit Databases;

{$I IBUtils.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, AKLabel, ComCtrls, IniFiles, IB_Components,
  ToolEdit;

type
  TfmDatabases = class(TForm)
    lvDatabases: TListView;
    AKLabel1: TAKLabel;
    edDatabase: TFilenameEdit;
    edAlias: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edUser: TEdit;
    Label3: TLabel;
    btReplace: TButton;
    btAdd: TButton;
    btDelete: TButton;
    btClose: TButton;
    btConnect: TButton;
    btMoreLess: TButton;
    edMetadataLog: TFilenameEdit;
    Label4: TLabel;
    procedure edAliasChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btAddClick(Sender: TObject);
    procedure btReplaceClick(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
    procedure lvDatabasesClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btMoreLessClick(Sender: TObject);
    procedure btConnectClick(Sender: TObject);
    procedure lvDatabasesDblClick(Sender: TObject);
    procedure lvDatabasesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    IsMore: boolean;
    Connection: TIB_Connection;
    procedure UpdateTextControls;
    procedure UpdateButtons;
  end;

var
  fmDatabases: TfmDatabases;

implementation

{$R *.dfm}

procedure TfmDatabases.edAliasChange(Sender: TObject);
begin
  UpdateButtons;
end;
//=============================================================================

procedure TfmDatabases.FormCreate(Sender: TObject);
begin
  IsMore := true;
  Connection := nil;
end;
//=============================================================================

procedure TfmDatabases.btAddClick(Sender: TObject);
var
  it: TListItem;
begin
  it := lvDatabases.Items.Add;
  it.Caption := edAlias.Text;
  it.SubItems.Add(edDatabase.Text);
  it.SubItems.Add(edUser.Text);
  it.SubItems.Add(edMetadataLog.Text);
  lvDatabases.Selected := it;
  UpdateButtons;
end;
//=============================================================================

procedure TfmDatabases.btReplaceClick(Sender: TObject);
var
  it: TListItem;
begin
  it := lvDatabases.Selected;
  if it <> nil then
  begin
    it.Caption := edAlias.Text;
    it.SubItems[0] := edDatabase.Text;
    it.SubItems[1] := edUser.Text;
    it.SubItems[2] := edMetadataLog.Text;
  end;
  lvDatabasesClick(Sender);
  //UpdateButtons;  volá se to už v lvDatabasesClick
end;
//=============================================================================

procedure TfmDatabases.btDeleteClick(Sender: TObject);
begin
  with lvDatabases.Items do
    Delete(IndexOf(lvDatabases.Selected));
  if lvDatabases.Items.Count > 0 then
    lvDatabases.Selected := lvDatabases.Items[0];
  UpdateTextControls;
  UpdateButtons;
end;
//=============================================================================

procedure TfmDatabases.UpdateButtons;
begin
  btAdd.Enabled := (edAlias.Text <> '') and (edDatabase.Text <> '') and (edUser.Text <> '');
  btReplace.Enabled := btAdd.Enabled and (lvDatabases.Items.Count > 0) and (lvDatabases.Selected <> nil);
  btDelete.Enabled := (lvDatabases.Items.Count > 0) and (lvDatabases.Selected <> nil);
  btConnect.Enabled := btDelete.Enabled and btAdd.Enabled and (Connection <> nil);
end;
//=============================================================================

procedure TfmDatabases.UpdateTextControls;
var
  it: TListItem;
begin
  it := lvDatabases.Selected;
  if it <> nil then
  begin
    edAlias.Text := it.Caption;
    edDatabase.Text := it.SubItems[0];
    edUser.Text := it.SubItems[1];
    edMetadataLog.Text := it.SubItems[2];
  end
  else
  begin
    edAlias.Text := '';
    edDatabase.Text := '';
    edUser.Text := '';
    edMetadataLog.Text := '';
    btAdd.Enabled := false;
    btReplace.Enabled := false;
  end;
end;
//=============================================================================

procedure TfmDatabases.lvDatabasesClick(Sender: TObject);
begin
  UpdateTextControls;
  UpdateButtons;
  if lvDatabases.Selected <> nil then
  begin
    if Connection <> nil then
    begin
      if Connection.Connected then
        Connection.Disconnect;
      Connection.Database := edDatabase.Text;
      Connection.DatabaseName := edDatabase.Text;
      Connection.Username := edUser.Text;
    end;
  end;
end;
//=============================================================================

procedure TfmDatabases.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
begin
  with TIniFile.Create(ExtractFilePath(Application.ExeName) + 'ibutils.ini') do
  begin
    if SectionExists('Aliases') then
      EraseSection('Aliases');
    if SectionExists('Databases') then
      EraseSection('Databases');
    if SectionExists('Users') then
      EraseSection('Users');
    if SectionExists('MetadataLogs') then
      EraseSection('MetadataLogs');
    with lvDatabases do
    begin
      for i := 0 to Items.Count - 1 do
      begin
        WriteString('Aliases', 'I' + IntToStr(i), Items[i].Caption);
        WriteString('Databases', 'I' + IntToStr(i), Items[i].SubItems[0]);
        WriteString('Users', 'I' + IntToStr(i), Items[i].SubItems[1]);
        WriteString('MetadataLogs', 'I' + IntToStr(i), Items[i].SubItems[2]);
      end;
    end;
    Free;
  end;
  Action := caFree;
end;
//=============================================================================

procedure TfmDatabases.FormShow(Sender: TObject);
var
  sAliases, sDatabases, sUsers, sMetadataLogs: TStringList;
  i: integer;
  it: TListItem;
begin
  sAliases := TStringList.Create;
  sDatabases := TStringList.Create;
  sUsers := TStringList.Create;
  sMetadataLogs := TStringList.Create;
  with TIniFile.Create(ExtractFilePath(Application.ExeName) + 'ibutils.ini') do
  begin
    ReadSectionValues('Aliases', sAliases);
    ReadSectionValues('Databases', sDatabases);
    ReadSectionValues('Users', sUsers);
    ReadSectionValues('MetadataLogs', sMetadataLogs);
    Free;
  end;
  with lvDatabases do
  begin
    Items.Clear;
    edAlias.Clear;
    edDatabase.Clear;
    edUser.Clear;
    edMetadataLog.Clear;
    for i := 0 to sAliases.Count - 1 do
    begin
      it := Items.Add;
      it.Caption := sAliases.Values['I' + IntToStr(i)];
      it.SubItems.Add(sDatabases.Values['I' + IntToStr(i)]);
      it.SubItems.Add(sUsers.Values['I' + IntToStr(i)]);
      it.SubItems.Add(sMetadataLogs.Values['I' + IntToStr(i)]);
    end;
    if Items.Count > 0 then
    begin
      Selected := Items[0];
      lvDatabases.OnClick(nil);
      lvDatabases.SetFocus;
    end;
  end;
  sAliases.Free;
  sDatabases.Free;
  sUsers.Free;
  sMetadataLogs.Free;
  UpdateButtons;
end;
//=============================================================================

procedure TfmDatabases.btMoreLessClick(Sender: TObject);
begin
  if IsMore then
  begin
    IsMore := false;
    ClientHeight := 210;
    //Height := Height - 150;
    btMoreLess.Caption := '&More >>';
  end
  else
  begin
    IsMore := true;
    Height := 350;
    btMoreLess.Caption := '<< &Less';
  end;
  ActiveControl := lvDatabases;
end;
//=============================================================================

procedure TfmDatabases.btConnectClick(Sender: TObject);
begin
  if lvDatabases.Selected <> nil then
    with Connection do
    begin
      Connect;
      FieldsCharCase.Clear;
      FieldsCharCase.Add(edMetadataLog.Text);
    end;
end;
//=============================================================================

procedure TfmDatabases.lvDatabasesDblClick(Sender: TObject);
begin
  if (lvDatabases.Selected <> nil) and btConnect.Enabled then
    btConnect.Click;
end;
//============================================================================

procedure TfmDatabases.lvDatabasesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN: lvDatabases.OnDblClick(Sender);
  end;
end;
//============================================================================

end.
