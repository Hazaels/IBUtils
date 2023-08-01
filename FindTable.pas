unit FindTable;

{$I IBUtils.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IB_Components, Model;

type
  TfmFindTable = class(TForm)
    btFind: TButton;
    btCancel: TButton;
    Label1: TLabel;
    cmbTableName: TComboBox;
    chkUpperCase: TCheckBox;
    qrFindTables: TIB_Query;
    procedure chkUpperCaseClick(Sender: TObject);
    procedure cmbTableNameChange(Sender: TObject);
    procedure qrFindTablesPrepareSQL(Sender: TIB_Statement);
    procedure btFindClick(Sender: TObject);
  private
    bFindFirst: boolean;
  public
    ModelForm: TfmModel;
  end;

var
  fmFindTable: TfmFindTable;

implementation

uses fraTable_u, fraMain_u;

{$R *.dfm}

procedure TfmFindTable.chkUpperCaseClick(Sender: TObject);
begin
  if chkUpperCase.Checked then
    cmbTableName.CharCase := ecUpperCase
  else
    cmbTableName.CharCase := ecNormal;
end;
//=============================================================================

procedure TfmFindTable.cmbTableNameChange(Sender: TObject);
begin
  bFindFirst := true;
  btFind.Enabled := (Length(cmbTableName.Text) > 0);
end;
//=============================================================================

procedure TfmFindTable.qrFindTablesPrepareSQL(Sender: TIB_Statement);
begin
  qrFindTables.SQLWhereItems.Add(Format('RDB$RELATION_NAME LIKE ''%s''', ['%' + cmbTableName.Text + '%']));
  qrFindTables.SQLWhereItems.Add('RDB$RELATION_NAME IN (' + TModel(ModelForm.Model).ListOfTables + ')');
end;
//=============================================================================

procedure TfmFindTable.btFindClick(Sender: TObject);
var
  fra: TfraMain;
  rgn: HRGN;
  tl, br: TPoint;
  SelfRect: TRect;
begin
  qrFindTables.IB_Connection := ModelForm.cnModel;
  //find first table
  if bFindFirst then
  begin
    bFindFirst := false;
    with cmbTableName do
    begin
      if Items.IndexOf(Text) = -1 then
        Items.Add(Text);
    end;
    qrFindTables.Unprepare;
    qrFindTables.Open;
    if qrFindTables.RecordCount = 0 then
    begin
      MessageDlg('Table not found in model.', mtWarning, [mbOK], 0);
      Exit;
    end;
  end
  else
  begin                                           //find next
    qrFindTables.Next;
    if qrFindTables.Eof then
      qrFindTables.First
  end;

  fra := TModel(ModelForm.Model).FrameByName(qrFindTables.FieldByName('TABLE_NAME').AsString);
  fra.Selected := true;
  TModel(ModelForm.Model).AddSelectedFrame(fra, false);
  ModelForm.scbModel.ScrollInView(fra);
  //if the find dialog is over the table, move the dialog
  tl := TModel(ModelForm.Model).ClientToScreen(Point(fra.Left, fra.Top));
  br := TModel(ModelForm.Model).ClientToScreen(Point(fra.Left + fra.Width, fra.Top + fra.Height));
  rgn := CreateRectRgn(tl.X, tl.Y, br.X, br.Y);
  SelfRect.TopLeft := Point(Left, Top);
  SelfRect.BottomRight := Point(Left + Width, Top + Height);
  if RectInRegion(rgn, SelfRect) then
  begin
    if tl.Y + fra.Height + Self.Height + 10 < Screen.WorkAreaHeight then
      Self.Top := tl.Y + fra.Height + 10
    else if (tl.Y - Self.Height - 10 > 0) and (tl.X - 10 > Self.Height) then
      Self.Top := tl.Y - Self.Height - 10;
  end;
  DeleteObject(rgn);
  fra.Paint;
end;
//=============================================================================

end.
