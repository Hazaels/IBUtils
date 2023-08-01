unit fraNote_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fraMain_u, ExtCtrls, StdCtrls, IniFiles, Menus;

type
  TfraNote = class(TfraMain)
    Memo: TMemo;
    lblNoteName: TLabel;
    popTable: TPopupMenu;
    mniTitleOnly: TMenuItem;
    N1: TMenuItem;
    mniColor: TMenuItem;
    mniDeleteTable: TMenuItem;
    procedure lblNoteNameMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lblNoteNameMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lblNoteNameMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MemoChange(Sender: TObject);
    procedure MemoMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pnlMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lblNoteNameDblClick(Sender: TObject);
    procedure MemoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MemoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mniTitleOnlyClick(Sender: TObject);
    procedure popTablePopup(Sender: TObject);
  private
    FTitle: string;
    procedure Paint; override;
    procedure SetTitle(const Value: string);
    function GetFieldVerticalPosition(sFieldName: string): integer;
  protected
    procedure SaveToIniFile(Ini: TIniFile); override;
    procedure LoadFromIniFile(Ini: TIniFile); override;
    function GetLeftJoin(sFieldName: string): TPoint; override;
    function GetRightJoin(sFieldName: string): TPoint; override;
  public
    constructor Create(AOwner: TModel); virtual;
    property Title: string read FTitle write SetTitle;
    procedure KeyPress(var Key: Char); override;
    procedure ChangeScale(M, D: Integer); override;
  end;

var
  fraNote: TfraNote;

implementation

uses MAIN;

{$R *.dfm}

constructor TfraNote.Create(AOwner: TModel);
begin
  inherited;
  //Title := 'Note';
  //lblNoteName.Caption := 'Note';
end;
//=============================================================================

procedure TfraNote.Paint;
var
  nBorder: integer;
begin
  inherited;
  if Visible then
  begin
    nBorder := (Model.CurrentScale div 30) + 2;
    with lblNoteName do
    begin
      Left := nBorder;
      Width := pnlMain.Width - (2 * nBorder);
      Top := nBorder;
      Height := Font.Height + 1;

      if Selected then
      begin
        Color := clBlack;
        Font.Color := clWhite;
        Transparent := false;
      end
      else
      begin
        Font.Color := clWindowText;
        Transparent := true;
      end;
    end;

    with Memo do
    begin
      Left := nBorder;
      Width := pnlMain.Width - (2 * nBorder);
      Top := + lblNoteName.Top + lblNoteName.Height;
      Height := pnlMain.Height - Top - nBorder;
    end;

    if soTitleOnly in ShowOptions then
    begin
      Height := lblNoteName.Top + lblNoteName.Height + nBorder;
    end; {else
      Height := Round(OrigHeight * Model.CurrentScale/100); }


    pnlMain.Invalidate;
  end;
end;
//=============================================================================

procedure TfraNote.lblNoteNameMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  pnlMainMouseDown(Sender, Button, Shift, X + lblNoteName.Left, Y + lblNoteName.Top);
  pnlMain.SetFocus;//aby nebyl focus na TMemo a mohly se pouzit keypress zkratky
end;
//=============================================================================

procedure TfraNote.lblNoteNameMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  pnlMainMouseMove(Sender, Shift, X + lblNoteName.Left, Y + lblNoteName.Top);;
end;
//=============================================================================

procedure TfraNote.lblNoteNameMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  pnlMainMouseUp(Sender, Button, Shift, X + lblNoteName.Left, Y + lblNoteName.Top);
end;
//=============================================================================

procedure TfraNote.SaveToIniFile(Ini: TIniFile);
var
  i, n: integer;
  S: TStringlist;
  stream: TMemoryStream;
begin
  inherited;
  with Ini do
  begin
    WriteInteger(InternalName, 'Left', OrigLeft);
    WriteInteger(InternalName, 'Top', OrigTop);
    WriteInteger(InternalName, 'Width', OrigWidth);
    WriteInteger(InternalName, 'Height', OrigHeight);
    WriteString(InternalName, 'Color', ColorToString(pnlMain.Color));
    WriteString(InternalName, 'Title', Title);
    WriteBool(InternalName, 'soTitleOnly', soTitleOnly in ShowOptions);

    n := ReadInteger(InternalName, 'LineCount', 0);

    S := TStringlist.Create;
    stream := TMemoryStream.Create;
    try
      //this is done to avoid TMemo's added soft returns to wrapped lines
      //when saving, the soft returns are not saved
      Memo.Lines.SaveToStream(stream);
      stream.Position := 0;
      S.LoadFromStream(stream);
        //first delete old lines
      for i := 0 to n-1 do
        DeleteKey(InternalName, 'L' + IntToStr(i));

      WriteInteger(InternalName, 'LineCount', S.Count);
      //write new lines
      for i := 0 to S.Count-1 do
        WriteString(InternalName, 'L' + IntToStr(i), S[i]);
    finally
      stream.Free;
      S.Free;
    end;
  end;
end;
//=============================================================================

procedure TfraNote.LoadFromIniFile(Ini: TIniFile);
var
  i, n: integer;
begin
  inherited;
  with Ini do
  begin
    pnlMain.Color := StringToColor(ReadString(InternalName, 'Color', 'clBtnFace'));
    ShowOptions := [];
    if ReadBool(InternalName, 'soTitleOnly', false) then
      ShowOptions := ShowOptions + [soTitleOnly];
    Title := ReadString(InternalName, 'Title', 'Untitled');
    //read lines to memo
    n := ReadInteger(InternalName, 'LineCount', 0);
    for i := 0 to n-1 do
      Memo.Lines.Add(ReadString(InternalName, 'L' + IntToStr(i), ''));
  end;
  SaveCoordToOrig;
end;
//=============================================================================

procedure TfraNote.SetTitle(const Value: string);
begin
  FTitle := Value;
  lblNoteName.Caption := FTitle;
end;
//=============================================================================

procedure TfraNote.MemoChange(Sender: TObject);
begin
  inherited;
  Model.Modified := true;
end;
//=============================================================================

procedure TfraNote.MemoMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
//  if not Memo.Focused then
//  begin
//    Selected := true;
//    Model.AddSelectedFrame(Self, false);
//    Memo.SetFocus;
//  end;
end;
//=============================================================================

procedure TfraNote.KeyPress(var Key: Char);
begin
  inherited;
  if not Memo.Focused then
    if UpperCase(Key) = 'L' then
      mniTitleOnly.Click;
end;
//=============================================================================

function TfraNote.GetLeftJoin(sFieldName: string): TPoint;
begin
//  if soTitleOnly in ShowOptions then
    Result := Point(Left - TModel(Model).RelPointer, Self.Top + lblNoteName.Top + (lblNoteName.Height div 2))
//  else
//    Result := Point(Left - TModel(Model).RelPointer, GetFieldVerticalPosition(sFieldName));
end;
//=============================================================================

function TfraNote.GetRightJoin(sFieldName: string): TPoint;
begin
//  if soTitleOnly in ShowOptions then
    Result := Point(Left + Width + TModel(Model).RelPointer, Self.Top + lblNoteName.Top + (lblNoteName.Height div 2))
//  else
//    Result := Point(Left + Width + TModel(Model).RelPointer, GetFieldVerticalPosition(sFieldName));
end;
//=============================================================================

function TfraNote.GetFieldVerticalPosition(sFieldName: string): integer;
begin
  Result := -4;
end;
//=============================================================================

procedure TfraNote.pnlMainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Model.AddingCustomRelation then
  begin
    if Model.SelectedFrameCount = 0 then
    begin
      Screen.Cursor := crCustomLinkTo;
      Model.AddSelectedFrame(Self, false);
      Model.CustomRelationAFrame := FrameName;
//      Model.CustomRelationAField := lbFields.Fields[lbFields.ItemIndex].Name;
    end
    else
    begin
      Screen.Cursor := crDefault;
      Model.CustomRelationBFrame := FrameName;
//      Model.CustomRelationBField := lbFields.Fields[lbFields.ItemIndex].Name;
      Model.AddSelectedFrame(Self, true);
      Model.CreateCustomRelation;
      Model.ModelForm.actModelAddCustomRelation.Checked := false;
      Model.AddingCustomRelation := false;
    end
  end;
  inherited;
end;
//=============================================================================

procedure TfraNote.lblNoteNameDblClick(Sender: TObject);
var
  OldTitle: string;
begin
  inherited;
  bWasDblClick := true;
  OldTitle := Title;
  Title := InputBox('Note title', 'Type note title:', Title);
  if OldTitle <> Title then
    Model.Modified := true;
end;
//=============================================================================

procedure TfraNote.MemoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  pnlMainMouseDown(Sender, Button, Shift, X + lblNoteName.Left, Y + lblNoteName.Top);
end;
//=============================================================================

procedure TfraNote.MemoMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  pnlMainMouseUp(Sender, Button, Shift, X + lblNoteName.Left, Y + lblNoteName.Top);
end;
//=============================================================================

procedure TfraNote.mniTitleOnlyClick(Sender: TObject);
var
  i, j: integer;
  tbl: TfraMain;

  procedure DoClick(fra: TfraMain; Sender: TObject);
  var
    j: integer;
  begin
    //fra := Model.SelectedFrames[i];// as TfraTable;
//    if (Sender as TMenuItem).Checked then
//      fra.ShowOptions := fra.ShowOptions + [TShowOption((Sender as TMenuItem).Tag)]
//    else
//      fra.ShowOptions := fra.ShowOptions - [TShowOption((Sender as TMenuItem).Tag)];
    if (TShowOption((Sender as TMenuItem).Tag) in fra.ShowOptions) then
      fra.ShowOptions := fra.ShowOptions - [TShowOption((Sender as TMenuItem).Tag)]
    else
      fra.ShowOptions := fra.ShowOptions + [TShowOption((Sender as TMenuItem).Tag)];
    //fra.lbFields.RefreshFields;
//        fra.RecreateHeaderSections;

    if (Sender as TMenuItem).Name = 'mniTitleOnly' then
    begin
      fra.Paint;
      if not (soTitleOnly in fra.ShowOptions) then
        fra.Height := Round(fra.OrigHeight * Model.CurrentScale / 100);
      for j := 0 to fra.RelationCount - 1 do
      begin
        fra.Relations[j].SetPosition;
      end;
      fra.ReDrawRelations;
    end;

    if (Sender as TMenuItem).Name = 'mniHeader' then
      fra.Paint;
  end;

begin
  if Sender is TMenuItem then
  begin
    //(Sender as TMenuItem).Checked := not (Sender as TMenuItem).Checked;

    if Screen.ActiveControl is TScrollBox then
      DoClick(Self, Sender)
    else
      for i := 0 to Model.SelectedFrameCount - 1 do
      begin
        tbl := Model.SelectedFrames[i];
        DoClick(tbl, Sender);
      end;

    Model.Invalidate;
    Model.Modified := true;
  end;
end;
//=============================================================================

procedure TfraNote.popTablePopup(Sender: TObject);
begin
  inherited;
  mniTitleOnly.Checked := soTitleOnly in ShowOptions;
end;
//=============================================================================

procedure TfraNote.ChangeScale(M, D: Integer);
var
  n: integer;
begin
  inherited;
  n := Round(13 * M/D) + 2;
  Memo.Font.Height := n;
  lblNoteName.Font.Height := n;
  Constraints.MinHeight := n;
  Constraints.MinWidth := 40;
end;
//=============================================================================


end.
