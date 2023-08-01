unit fraTable_u;

{$I IBUtils.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  StdCtrls, ExtCtrls, Model, ScrollListBox,
  IniFiles, Menus, ComCtrls, fraMain_u, Mask;

const
  sLoading = 'Loading model ...';
  sLoadingTables = 'Loading tables ...   ';
  sLoadingRelations = 'Loading relations ...   ';
  sTableRefresh = 'Refreshing table: ';
  
type
  TfraTable = class(TfraMain)
    popTable: TPopupMenu;
    mniColor: TMenuItem;
    mniRefresh: TMenuItem;
    mniDeleteTable: TMenuItem;
    mniTypes: TMenuItem;
    mniDomains: TMenuItem;
    N1: TMenuItem;
    mniIcons: TMenuItem;
    mniRequired: TMenuItem;
    mniKeysOnly: TMenuItem;
    mniTitleOnly: TMenuItem;
    mniComputedBy: TMenuItem;
    mniHeader: TMenuItem;
    Header: THeaderControl;
    lbFields: TScrollListBox;
    lblTableName: TLabel;
    N2: TMenuItem;
    mniDropField: TMenuItem;
    mniCreateField: TMenuItem;
    N3: TMenuItem;
    mniMoveUp: TMenuItem;
    mniMoveDown: TMenuItem;
    mniBrowse: TMenuItem;
    mniIndexCount: TMenuItem;
    mniIndexes: TMenuItem;
    mniCreateIndex: TMenuItem;
    popHeader: TPopupMenu;
    mniAdjustCurrent: TMenuItem;
    mniAdjustAll: TMenuItem;
    mniArrange: TMenuItem;
    mniArrange2: TMenuItem;
    N4: TMenuItem;
    mniAdjustAll2: TMenuItem;
    mniAdjustCurrent2: TMenuItem;
    N5: TMenuItem;
    procedure lblTableNameMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure lblTableNameMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure lblTableNameMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure lbFieldsScroll(Sender: TObject);
    procedure mniRefreshClick(Sender: TObject);
    procedure lbFieldsDrawItem(Control: TWinControl; Index: Integer; ARect: TRect; State: TOwnerDrawState);
    procedure lbFieldsMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure lbFieldsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure lbFieldsMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure mniNamesClick(Sender: TObject);
    procedure popTablePopup(Sender: TObject);
    procedure HeaderSectionResize(HeaderControl: THeaderControl; Section: THeaderSection);
    procedure lbFieldsClick(Sender: TObject);
    procedure mniCreateFieldClick(Sender: TObject);
    procedure mniDropFieldClick(Sender: TObject);
    procedure lbFieldsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lbFieldsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lbFieldsStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure mniMoveUpClick(Sender: TObject);
    procedure mniMoveDownClick(Sender: TObject);
    procedure btCompileClick(Sender: TObject);
    procedure lbFieldsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mniBrowseClick(Sender: TObject);
    procedure mniIndexesClick(Sender: TObject);
    procedure mniCreateIndexClick(Sender: TObject);
    procedure lblTableNameDblClick(Sender: TObject);
    procedure lbFieldsDblClick(Sender: TObject);
    procedure mniAdjustCurrentClick(Sender: TObject);
    procedure mniAdjustAllClick(Sender: TObject);
    procedure HeaderMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure popHeaderPopup(Sender: TObject);
    procedure mniArrangeClick(Sender: TObject);
  private
    SectionsWidths, OrigSectionsWidths: array[0..4] of integer;       //array to save widths of header sections
    hdrName, hdrType, hdrDomain, hdrComputedBy, hdrIndexCount: THeaderSection;
    FTableDesc: string;
    btCompile: TButton;
    FCurrentHeaderSection: integer;
    function GetTableName: string;
    procedure SetTableName(ATableName: string);
    procedure RefreshFields;
    function PreviousHeaderSection(ASection: THeaderSection): THeaderSection;
    function GetFieldVerticalPosition(sFieldName: string): integer;
    procedure ExchangeFields(i, j: integer);
    procedure CreateCompileButton;
    procedure CompileButtonScale;
    procedure CompileReorderChanges;
    procedure SetAdjustMenuCaptions;
    procedure SetCurrentHeaderSection(AX: integer);
  protected
    procedure AddRelations; override;
    procedure SaveToIniFile(Ini: TIniFile); override;
    procedure LoadFromIniFile(Ini: TIniFile); override;
    function GetLeftJoin(sFieldName: string): TPoint; override;
    function GetRightJoin(sFieldName: string): TPoint; override;
  public
    property CurrentHeaderSection: integer read FCurrentHeaderSection write FCurrentHeaderSection;
    property TableDesc: string read FTableDesc write FTableDesc;
    property TableName: string read GetTableName write SetTableName;
    constructor Create(AOwner: TModel); override;
    constructor CreateByName(AOwner: TModel; sTableName: string); override;
    destructor Destroy; override;
    procedure SetHeaderSectionSize(ASectionNumber: integer = -1);
    procedure KeyPress(var Key: Char); override;
    procedure RefreshRelations; override;
    procedure Refresh; override;
    procedure Paint; override;
    procedure ChangeScale(M, D: Integer); override;
    procedure RecreateHeaderSections;
    procedure SaveCoordToOrig; override;
    procedure LoadCoordFromOrig; override;
    procedure Arrange;
    procedure InitializeHeader;
    procedure CreateIndexes;
  end;


implementation

uses MAIN, Dialogs, ImgList, IB_Components, Progress, CreateTable, IB_Script,
  Browse, Math, Indexes, Description;

{$R *.dfm}


{ TfraTable }

function TfraTable.GetTableName: string;
begin
  Result := FrameName;
end;
//=============================================================================

procedure TfraTable.SetTableName(ATableName: string);
begin
  FrameName := ATableName;
  lblTableName.Caption := FrameName;
end;
//=============================================================================

constructor TfraTable.Create(AOwner: TModel);
begin
  inherited Create(AOwner);
  ShowOptions := AOwner.DefaultShowOptions;       //[soName, soType, soDomain, soRequired, soIcons, soIndexCount];
  SectionsWidths[Ord(soName)] := 130;
  SectionsWidths[Ord(soType)] := 130;
  SectionsWidths[Ord(soDomain)] := 130;
  SectionsWidths[Ord(soComputedBy)] := 130;
  SectionsWidths[Ord(soIndexCount)] := 130;
//  lbFields.ExtendedSelect := false;
  //  Visible := true;
end;
//=============================================================================

constructor TfraTable.CreateByName(AOwner: TModel; sTableName: string);
begin
  Create(AOwner);
  TableName := sTableName;
  //SaveCoordToOrig; //todo2 je to tady nutne??, vola se to pak znovu az se tbl priradi k modelu, viz TModel.AddFrame
end;
//=============================================================================

destructor TfraTable.Destroy;
begin

  inherited;
end;
//=============================================================================

procedure TfraTable.AddRelations;
var
  PK_Frame: TfraMain;
  Relation: TRelation;
  i: integer;
begin
  with Model.ModelForm.qrRelations do
  begin
    ParamByName('TABLE_NAME').AsString := TableName;
    if not Active then
      Open;
    //delete all outgoing relations
    for i := RelationCount - 1 downto 0 do
    begin
      if Relations[i].AFrame = Self then          //if it is outgoing relation
        Relations[i].Free
    end;
    //recreate
    while not Eof do
    begin
      PK_Frame := Model.FrameByName(FieldByName('PK_TABLE').AsString);
      if Assigned(PK_Frame) then
      begin
        Relation := TRelation.Create(Model);
        Relation.AFrame := Self;
        Relation.BFrame := PK_Frame;
        Relation.Name := '$' + FieldByName('FK_NAME').AsString + '_' + FieldByName('PK_FIELD_NAME').AsString;
        Relation.DBName := FieldByName('FK_NAME').AsString;
        Relation.PrimaryKey := FieldByName('PK_FIELD_NAME').AsString;
        Relation.ForeignKey := FieldByName('FK_FIELD_NAME').AsString;
        Relation.NotNull := (FieldByName('NULL_FLAG').AsInteger = 1);
        AddRelation(Relation);
        if PK_Frame <> Self then                  //add only if the FK does not point to the same table
          PK_Frame.AddRelation(Relation);
        Relation.SetPosition;
        //Relation.Paint;
      end;
      Next;
    end;
  end;
  inherited;
end;
//=============================================================================

procedure TfraTable.RefreshRelations;
var
  PK_Frame: TfraMain;
  Relation: TRelation;
  i, j, k: integer;
  fldPkTable, fldFkName, fldPkFieldName, fldFkFieldName, fldNullFlag: TIB_Column;
  sNodeList: TStringList;
  P: PPoint;
  Nodes: string;
  Ini: TIniFile;
  bFound: boolean;
begin
  with Model.ModelForm.qrRelations do
  begin
    ParamByName('TABLE_NAME').AsString := TableName;
    if not Active then
      Open;

    fldPkTable := FieldByName('PK_TABLE');
    fldFkName := FieldByName('FK_NAME');
    fldPkFieldName := FieldByName('PK_FIELD_NAME');
    fldFkFieldName := FieldByName('FK_FIELD_NAME');
    fldNullFlag := FieldByName('NULL_FLAG');

    //refresh existing or delete nonexisting
    for i := RelationCount - 1 downto 0 do
    begin
      Relation := Relations[i];
      if Relation.AFrame = Self then              //outgoing relation
      begin
//        if Locate('FK_NAME', Copy(Relation.Name, 2, Length(Relation.Name)) , []) then
        bFound := false;
        First;
        while not Eof do
        begin
          bFound := Relation.Name = '$' + fldFkName.AsString + '_' + fldPkFieldName.AsString;
          if not bFound then
            Next
          else
            Break;
        end;
        if bFound then
        begin
          PK_Frame := Model.FrameByName(fldPkTable.AsString);
          if Assigned(PK_Frame) then
          begin
            Relation.AFrame := Self;
            Relation.BFrame := PK_Frame;
            Relation.Name := '$' + fldFkName.AsString + '_' + fldPkFieldName.AsString;
            Relation.DBName := fldFkName.AsString;
            Relation.PrimaryKey := fldPkFieldName.AsString;
            Relation.ForeignKey := fldFkFieldName.AsString;
            Relation.NotNull := fldNullFlag.AsInteger = 1;
            Relation.SetPosition;
          end;
        end
        else                                      //Locate = false
          if not Relation.IsCustomRelation then
            Relation.Free;
      end;
    end;

    //add new relations which were added to DB from the last refresh
    with Model.ModelForm.qrRelations do
    begin
      First;
      while not Eof do
      begin
        Relation := Model.RelationByName('$' + fldFkName.AsString + '_' + fldPkFieldName.AsString);
        if not Assigned(Relation) then
        begin
          PK_Frame := Model.FrameByName(FieldByName('PK_TABLE').AsString);
          if Assigned(PK_Frame) then
          begin
            Relation := TRelation.Create(Model);
            Relation.AFrame := Self;
            Relation.BFrame := PK_Frame;
            Relation.Name := '$' + fldFkName.AsString + '_' + fldPkFieldName.AsString;
            Relation.DBName := fldFkName.AsString;
            Relation.PrimaryKey := fldPkFieldName.AsString;
            Relation.ForeignKey := fldFkFieldName.AsString;
            Relation.NotNull := fldNullFlag.AsInteger = 1;
            AddRelation(Relation);
            if PK_Frame <> Self then              //add only if the FK does not point to the same table
              PK_Frame.AddRelation(Relation);
            Relation.SetPosition;
          end;
        end;
        Next;
      end;
    end;

    //refresh nodes
//    Ini := TIniFile.Create(ChangeFileExt(Model.Filename, '.tbl'));
//    try
//      for i := 0 to Self.RelationCount-1  do
//      begin
//        Relation := Relations[i];
//        if Relation.IsCustomRelation  then
//          Continue;
//        if Relation.AFrame = Self then  //outgoing
//        begin
//          Relation.LoadNodesFromIni(Ini);
//        end;
//      end;
//    finally
//      Ini.Free;
//    end;

  end;
  inherited;
end;
//=============================================================================

procedure TfraTable.lblTableNameMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  pnlMainMouseDown(Sender, Button, Shift, X + lblTableName.Left, Y + lblTableName.Top);
end;
//=============================================================================

procedure TfraTable.lblTableNameMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  pnlMainMouseMove(Sender, Shift, X + lblTableName.Left, Y + lblTableName.Top);;
end;
//=============================================================================

procedure TfraTable.lblTableNameMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  pnlMainMouseUp(Sender, Button, Shift, X + lblTableName.Left, Y + lblTableName.Top);
end;
//=============================================================================

procedure TfraTable.Refresh;
begin
  inherited;
  with Model.ModelForm do
  begin
    //refresh fields
    qrTableFields.ParamByName('TABLE_NAME').AsString := TableName;
    qrTableFields.Open;
    RefreshFields;
    RecreateHeaderSections;
    qrTables.Filter := 'UPPER(RDB$RELATION_NAME) = ''' + UpperCase(TableName) + '''';
    qrTables.Filtered := true;
    if qrTables.Active then
      qrTables.Refresh
    else
      qrTables.Open;
    TableDesc := qrTables.FieldByName('DESCRIPTION').AsString;
    lblTableName.Hint := TableDesc;
  end;
end;
//=============================================================================

procedure TfraTable.RefreshFields;
var
  FieldType, Domain: string;
begin
  lbFields.Clear;
  with Model.ModelForm do
  begin
    while not qrTableFields.Eof do
    begin
      if (soKeysOnly in ShowOptions)
        and qrTableFields.FieldByName('FK_NAME').IsNull
        and qrTableFields.FieldByName('PK_NAME').IsNull
        and (qrTableFields.FieldByName('UNIQUE_INDEX_COUNT').AsInteger=0) then
      begin
        qrTableFields.Next;
        Continue;
      end;

      if TModel(Model).CombinedTypeDomain and (Pos('RDB$', qrTableFields.FieldByName('FIELD_SOURCE').AsString) = 0) then
        FieldType := qrTableFields.FieldByName('FIELD_SOURCE').AsString
      else
      begin
        if qrTableFields.FieldByName('TYPE_NAME').AsString = 'VARYING' then
          FieldType := 'VARCHAR'
        else if qrTableFields.FieldByName('TYPE_NAME').AsString = 'TEXT' then
          FieldType := 'CHAR'
        else if qrTableFields.FieldByName('TYPE_NAME').AsString = 'LONG' then
          FieldType := 'INTEGER'
        else if qrTableFields.FieldByName('TYPE_NAME').AsString = 'SHORT' then
          FieldType := 'SMALLINT'
        else if qrTableFields.FieldByName('FIELD_TYPE').AsInteger = 16 then  //numeric, decimal nebo bigint
        begin
          if qrTableFields.FieldByName('FIELD_SUB_TYPE').AsInteger = 1 then
            FieldType := Format('NUMERIC(%d,%d)', [qrTableFields.FieldByName('FIELD_PRECISION').AsInteger, qrTableFields.FieldByName('FIELD_SCALE').AsInteger * -1])
          else
          if qrTableFields.FieldByName('FIELD_SUB_TYPE').AsInteger = 2 then
            FieldType := Format('DECIMAL(%d,%d)', [qrTableFields.FieldByName('FIELD_PRECISION').AsInteger, qrTableFields.FieldByName('FIELD_SCALE').AsInteger * -1])
          else
            FieldType := 'BIGINT';
        end
        else
          FieldType := qrTableFields.FieldByName('TYPE_NAME').AsString;

        if qrTableFields.FieldByName('CHR_LENGTH').IsNotNull then
          FieldType := FieldType + ' (' + qrTableFields.FieldByName('CHR_LENGTH').AsString + ')';
      end;

      if TModel(Model).ShowSystemDomains or (Pos('RDB$', qrTableFields.FieldByName('FIELD_SOURCE').AsString) = 0) then
        Domain := qrTableFields.FieldByName('FIELD_SOURCE').AsString
      else
        Domain := '';

      lbFields.AddField(qrTableFields.FieldByName('FIELD_NAME').AsString,
        qrTableFields.FieldByName('DESCRIPTION').AsString,
        FieldType,
        Domain,
        qrTableFields.FieldByName('COMPUTED_SOURCE').AsString,
        qrTableFields.FieldByName('NULL_FLAG').AsBoolean
        or qrTableFields.FieldByName('NULL_FLAG_DM').AsBoolean,
        qrTableFields.FieldByName('FK_NAME').IsNotNull,
        qrTableFields.FieldByName('PK_NAME').IsNotNull,
        qrTableFields.FieldByName('INDEX_COUNT').AsInteger,
        qrTableFields.FieldByName('UNIQUE_INDEX_COUNT').AsInteger);
      qrTableFields.Next;
    end;
  end;
end;
//============================================================================

procedure TfraTable.lbFieldsScroll(Sender: TObject);
var
  i: integer;
begin
  //attention, this event is triggered twice and I do not know why!!
  for i := 0 to RelationCount - 1 do
    Relations[i].SetPosition;

  Model.Invalidate;
  //  FModel.ResizeModel;
end;
//=============================================================================

procedure TfraTable.mniRefreshClick(Sender: TObject);
var
  i: integer;
  fra: TfraMain;
begin
  try
    fmProgress := TfmProgress.Create(Application);
    fmProgress.Progress.Max := Model.SelectedFrameCount - 1;
    fmProgress.Show;

    for i := 0 to Model.SelectedFrameCount - 1 do
    begin
      fra := Model.SelectedFrames[i];
      fmProgress.lbl.Caption := Format(sTableRefresh + ' %d. %s', [i + 1, fra.FrameName]);
      fmProgress.Progress.StepIt;
      fra.Refresh;
      fra.RefreshRelations;
    end;
    Model.Invalidate;
  finally
    fmProgress.Free;
    fmProgress := nil;
  end;
end;
//=============================================================================

procedure TfraTable.Paint;
var
  nBorder: integer;
begin
  inherited;
  if Visible then
  begin
    nBorder := (Model.CurrentScale div 30) + 2;
    with lblTableName do
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

    with Header do
    begin
      Visible := (soHeader in ShowOptions) and not (soTitleOnly in ShowOptions);
      if Visible then
      begin
        Left := nBorder;
        Width := pnlMain.Width - (2 * nBorder);
        //Height := 17;
        Top := lblTableName.Top + lblTableName.Height;
      end;
    end;

    with lbFields do
    begin
      Left := nBorder;
      Width := pnlMain.Width - (2 * nBorder);
      if Header.Visible then
        Top := Header.Height + lblTableName.Top + lblTableName.Height - 1
      else
        Top := + lblTableName.Top + lblTableName.Height;
      Height := pnlMain.Height - Top - nBorder;
    end;

    if soTitleOnly in ShowOptions then
    begin
      Height := lblTableName.Top + lblTableName.Height + nBorder;
    end; {else
    Height := Round(OrigHeight * FModel.CurrentScale/100); }

    CompileButtonScale;
    
    pnlMain.Invalidate;
  end;
end;
//=============================================================================

procedure TfraTable.ChangeScale(M, D: Integer);
var
  n: integer;
begin
  inherited;
  n := Round(13 * M/D) + 2;
  lbFields.ItemHeight := n;
  lbFields.Font.Height := n;
  lblTableName.Font.Height := n;
  Constraints.MinHeight := n;
  Constraints.MinWidth := 40;
  Header.Height := n + 1;
  Header.Font.Height := n;
  SectionsWidths[0] := Round(OrigSectionsWidths[0] * Model.CurrentScale / 100);
  SectionsWidths[1] := Round(OrigSectionsWidths[1] * Model.CurrentScale / 100);
  SectionsWidths[2] := Round(OrigSectionsWidths[2] * Model.CurrentScale / 100);
  SectionsWidths[3] := Round(OrigSectionsWidths[3] * Model.CurrentScale / 100);
  RecreateHeaderSections;
end;
//=============================================================================

procedure TfraTable.lbFieldsDrawItem(Control: TWinControl; Index: Integer;
  ARect: TRect; State: TOwnerDrawState);
var
  IsFK, IsPK: boolean;
  nLeft, nIconX: integer;
  ABkColor: TColor;
begin
  if lbFields.FieldCount = 0 then
    Exit;
    
  if soIcons in ShowOptions then
    nIconX := 15
  else
    nIconX := 2;
  nLeft := ARect.Left + nIconX;
  with lbFields do
  begin
    IsFK := false;
    IsPK := false;
    ABkColor := Canvas.Brush.Color;
    Canvas.FillRect(ARect);
    if Fields[Index]^.IsFK then
    begin
      IsFK := true;
      if soIcons in ShowOptions then
      begin
        fmMain.ilMain.BkColor := ABkColor;
        fmMain.ilMain.Draw(Canvas, ARect.Left + 1, ARect.Top, 24, dsTransparent{dsNormal}, itImage);
      end;
    end;
    if Fields[Index]^.IsPK then
    begin
      IsPK := true;
      if soIcons in ShowOptions then
      begin
        fmMain.ilMain.BkColor := ABkColor;
        if IsFK then
          fmMain.ilMain.Draw(Canvas, ARect.Left + 4, ARect.Top, 23, dsTransparent, itImage) //Canvas.Draw(ARect.Left + 4, ARect.Top , ic)
        else
          fmMain.ilMain.Draw(Canvas, ARect.Left + 1, ARect.Top, 23, dsTransparent, itImage); //Canvas.Draw(ARect.Left + 1, ARect.Top , ic);
      end;
    end;
    if (Fields[Index]^.UniqueIndexCount > 0) and not IsPK then //u primárního klíèe nemalovat ikonu unikátního indexu, je to tam vždy
    begin
      if soIcons in ShowOptions then
      begin
        fmMain.ilMain.BkColor := ABkColor;
        if IsFK then
          fmMain.ilMain.Draw(Canvas, ARect.Left + 4, ARect.Top, 39, dsTransparent, itImage)
        else
          fmMain.ilMain.Draw(Canvas, ARect.Left + 1, ARect.Top, 39, dsTransparent, itImage);
      end;
    end;
    if (soRequired in ShowOptions) and Fields[Index]^.NotNull then
    begin
      Canvas.Font.Style := [fsBold];
    end;
    if (soComputedBy in ShowOptions) and (Length(Fields[Index]^.ComputedBy) > 0) then
    begin
      Canvas.Font.Color := clRed;
    end;
    ARect.Left := nLeft;
    ARect.Right := ARect.Left + SectionsWidths[Ord(soName)] - 5 - nIconX;
    Canvas.TextRect(ARect, nLeft, ARect.Top, Fields[Index]^.Name); //bylo tady Items[Index]
    Dec(nLeft, nIconX);                           //because the width of hdrName contains the Icon´s width too
    Canvas.Font.Style := [];
    if soType in ShowOptions then
    begin
      nLeft := nLeft + PreviousHeaderSection(hdrType).Width;
      ARect.Left := nLeft;
      ARect.Right := ARect.Left + SectionsWidths[Ord(soType)] - 5;
      Canvas.TextRect(ARect, nLeft, ARect.Top, Fields[Index]^.FieldType);
    end;
    if soDomain in ShowOptions then
    begin
      nLeft := nLeft + PreviousHeaderSection(hdrDomain).Width;
      ARect.Left := nLeft;
      ARect.Right := ARect.Left + SectionsWidths[Ord(soDomain)] - 5;
      Canvas.TextRect(ARect, nLeft, ARect.Top, Fields[Index]^.Domain);
    end;
    if soComputedBy in ShowOptions then
    begin
      nLeft := nLeft + PreviousHeaderSection(hdrComputedBy).Width;
      ARect.Left := nLeft;
      ARect.Right := ARect.Left + SectionsWidths[Ord(soComputedBy)];
      Canvas.TextRect(ARect, nLeft, ARect.Top, Fields[Index]^.ComputedBy);
    end;
    if soIndexCount in ShowOptions then
    begin
      nLeft := nLeft + PreviousHeaderSection(hdrIndexCount).Width;
      ARect.Left := nLeft;
      ARect.Right := ARect.Left + SectionsWidths[Ord(soIndexCount)];
      Canvas.TextRect(ARect, nLeft, ARect.Top, IntToStr(Fields[Index]^.IndexCount));
    end;
  end;
end;
//=============================================================================

procedure TfraTable.lbFieldsMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  i: integer;
  fra: TfraMain;
begin
  i := lbFields.ItemAtPos(Point(X, Y), true);
  if i <> -1 then
    with lbFields do
    begin
      Hint := Fields[i]^.FieldType + '     ' + Fields[i]^.Domain;
      if Length(Fields[i]^.Description) > 0 then
        Hint := Hint + #13#10 + Fields[i]^.Description;
      Application.ActivateHint(Point(Mouse.CursorPos.X + 20, Mouse.CursorPos.Y));
    end
  else
    Hint := '';

  if (ssLeft in Shift) and bDown {and (i <> lbFields.ItemIndex) and (lbFields.ItemIndex <> -1)} then
  begin
    for i := 0 to Model.FrameCount-1 do
    begin
      fra := Model.Frames[i];
      if (fra is TfraTable) and (fra <> Self) then
      begin
        TfraTable(Model.Frames[i]).lbFields.Multiselect := false;
        TfraTable(Model.Frames[i]).lbFields.ClearSelection;
      end;
    end;
    if not Model.AddingCustomRelation and not Model.AddingRelation then
      lbFields.BeginDrag(false, 5);
  end;
  //  pnlMainMouseMove(Sender, Shift, X + lbFields.Left, Y + lbFields.Top);
end;
//=============================================================================

procedure TfraTable.mniNamesClick(Sender: TObject);
var
  i, j: integer;
  tbl: TfraMain;
  bSet: boolean;

  procedure DoClick(tbl: TfraMain; Sender: TObject; ASet: boolean);
  var
    j: integer;
  begin
    //tbl := Model.SelectedFrames[i] as TfraTable;
//    if (Sender as TMenuItem).Checked then
//      tbl.ShowOptions := tbl.ShowOptions + [TShowOption((Sender as TMenuItem).Tag)]
//    else
//      tbl.ShowOptions := tbl.ShowOptions - [TShowOption((Sender as TMenuItem).Tag)];

//    if (TShowOption((Sender as TMenuItem).Tag) in tbl.ShowOptions) then
    if ASet then
      tbl.ShowOptions := tbl.ShowOptions - [TShowOption((Sender as TMenuItem).Tag)]
    else
      tbl.ShowOptions := tbl.ShowOptions + [TShowOption((Sender as TMenuItem).Tag)];


    if tbl is TfraTable then
    begin
      //TfraTable(tbl).lbFields.RefreshFields;  -- toto je asi zbytecne ?!? misto toho refreshnu celou fraTable
      //TfraTable(tbl).RecreateHeaderSections;
      TfraTable(tbl).Refresh;
    end;

    if (Sender as TMenuItem).Name = 'mniTitleOnly' then
    begin
      tbl.Paint;
      if not (soTitleOnly in tbl.ShowOptions) then
        tbl.Height := Round(tbl.OrigHeight * Model.CurrentScale / 100);
      {for j := 0 to tbl.RelationCount - 1 do
      begin
        tbl.Relations[j].SetPosition;
      end;}
      tbl.ReDrawRelations;
    end;

    if (Sender as TMenuItem).Name = 'mniHeader' then
      tbl.Paint;
  end;

begin
  if Sender is TMenuItem then
  begin
    //(Sender as TMenuItem).Checked := not (Sender as TMenuItem).Checked;
    bSet := TShowOption((Sender as TMenuItem).Tag) in Self.ShowOptions;

    if Screen.ActiveControl is TScrollBox then
      DoClick(Self, Sender, bSet)
    else
      for i := 0 to Model.SelectedFrameCount - 1 do
      begin
        tbl := Model.SelectedFrames[i];
        DoClick(tbl, Sender, bSet);
      end;

    Model.Invalidate;
    Model.Modified := true;
    Model.ModelForm.CheckConnected;
  end;
end;
//=============================================================================

procedure TfraTable.popTablePopup(Sender: TObject);
begin
  mniTypes.Checked := soType in ShowOptions;
  mniDomains.Checked := soDomain in ShowOptions;
  mniRequired.Checked := soRequired in ShowOptions;
  mniIcons.Checked := soIcons in ShowOptions;
  mniKeysOnly.Checked := soKeysOnly in ShowOptions;
  mniTitleOnly.Checked := soTitleOnly in ShowOptions;
  mniComputedBy.Checked := soComputedBy in ShowOptions;
  mniIndexCount.Checked := soIndexCount in ShowOptions;
  mniHeader.Checked := soHeader in ShowOptions;
  mniDropField.Enabled := lbFields.ItemIndex > -1;
  mniMoveUp.Enabled := lbFields.ItemIndex > 0;
  mniMoveDown.Enabled := lbFields.ItemIndex < lbFields.Items.Count-1;
  SetAdjustMenuCaptions;  
end;
//=============================================================================

procedure TfraTable.lbFieldsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  n: integer;
begin
  SetCurrentHeaderSection(X);
  pnlMainMouseDown(Sender, Button, Shift, X + lbFields.Left, Y + lbFields.Top);
  if Button = mbLeft then
  begin
    if not Model.AddingCustomRelation and not Model.AddingRelation then
    begin
      if not lbFields.Multiselect then
        lbFields.Multiselect := true;
      n := lbFields.ItemAtPos(Point(X, Y), true);
      if (n > -1) and not lbFields.Selected[n] and (lbFields.SelCount = 0) then
        lbFields.Selected[n] := true;
    end;
  end;
end;
//=============================================================================

procedure TfraTable.lbFieldsMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  pnlMainMouseUp(Sender, Button, Shift, X + lbFields.Left, Y + lbFields.Top);
end;
//============================================================================

procedure TfraTable.RecreateHeaderSections;
begin
  with Header.Sections do
  begin
    Clear;

    if soName in ShowOptions then
    begin
      hdrName := Add;
      hdrName.AllowClick := false;
      hdrName.Text := 'Name';
      hdrName.Width := SectionsWidths[Ord(soName)];
    end
    else
      hdrName := nil;

    if soType in ShowOptions then
    begin
      hdrType := Add;
      hdrType.AllowClick := false;
      if TModel(Model).CombinedTypeDomain then
        hdrType.Text := 'Type/Domain'
      else
        hdrType.Text := 'Type';
      hdrType.Width := SectionsWidths[Ord(soType)];
    end
    else
      hdrType := nil;

    if soDomain in ShowOptions then
    begin
      hdrDomain := Add;
      hdrDomain.AllowClick := false;
      hdrDomain.Text := 'Domain';
      hdrDomain.Width := SectionsWidths[Ord(soDomain)];
    end
    else
      hdrDomain := nil;

    if soComputedBy in ShowOptions then
    begin
      hdrComputedBy := Add;
      hdrComputedBy.AllowClick := false;
      hdrComputedBy.Text := 'Computed by';
      hdrComputedBy.Width := SectionsWidths[Ord(soComputedBy)];
    end
    else
      hdrComputedBy := nil;

    if soIndexCount in ShowOptions then
    begin
      hdrIndexCount := Add;
      hdrIndexCount.AllowClick := false;
      hdrIndexCount.Text := 'Index count';
      hdrIndexCount.Width := SectionsWidths[Ord(soIndexCount)];
    end
    else
      hdrIndexCount := nil;

    with Add do
      Width := 2000;                              //add another section to the end
  end;
end;
//============================================================================

procedure TfraTable.HeaderSectionResize(HeaderControl: THeaderControl;
  Section: THeaderSection);
begin
  if Assigned(hdrName) and (soName in ShowOptions) then
    SectionsWidths[Ord(soName)] := hdrName.Width;
  if Assigned(hdrType) and (soType in ShowOptions) then
    SectionsWidths[Ord(soType)] := hdrType.Width;
  if Assigned(hdrDomain) and (soDomain in ShowOptions) then
    SectionsWidths[Ord(soDomain)] := hdrDomain.Width;
  if Assigned(hdrComputedBy) and (soComputedBy in ShowOptions) then
    SectionsWidths[Ord(soComputedBy)] := hdrComputedBy.Width;
  if Assigned(hdrIndexCount) and (soIndexCount in ShowOptions) then
    SectionsWidths[Ord(soIndexCount)] := hdrIndexCount.Width;
  lbFields.RefreshFields;
  Model.Modified := true;
  SaveCoordToOrig;
end;
//============================================================================

function TfraTable.PreviousHeaderSection(ASection: THeaderSection): THeaderSection;
begin
  if Assigned(ASection) and (ASection.Index > 0) then
    Result := Header.Sections[ASection.Index - 1]
  else
    Result := Header.Sections[0];
end;
//============================================================================

procedure TfraTable.SaveToIniFile(Ini: TIniFile);
begin
  inherited;
  with Ini do
  begin
    WriteInteger(TableName, 'Left', OrigLeft);
    WriteInteger(TableName, 'Top', OrigTop);
    WriteInteger(TableName, 'Width', OrigWidth);
    WriteInteger(TableName, 'Height', OrigHeight);
    WriteString(TableName, 'Color', ColorToString(pnlMain.Color));
    WriteBool(TableName, 'soTypes', soType in ShowOptions);
    WriteBool(TableName, 'soDomain', soDomain in ShowOptions);
    WriteBool(TableName, 'soRequired', soRequired in ShowOptions);
    WriteBool(TableName, 'soKeysOnly', soKeysOnly in ShowOptions);
    WriteBool(TableName, 'soIcons', soIcons in ShowOptions);
    WriteBool(TableName, 'soTitleOnly', soTitleOnly in ShowOptions);
    WriteBool(TableName, 'soComputedBy', soComputedBy in ShowOptions);
    WriteBool(TableName, 'soIndexCount', soIndexCount in ShowOptions);
    WriteBool(TableName, 'soHeader', soHeader in ShowOptions);
    WriteInteger(TableName, 'HdrNameWidth', OrigSectionsWidths[Ord(soName)]);
    WriteInteger(TableName, 'HdrTypeWidth', OrigSectionsWidths[Ord(soType)]);
    WriteInteger(TableName, 'HdrDomainWidth', OrigSectionsWidths[Ord(soDomain)]);
    WriteInteger(TableName, 'HdrComputedByWidth', OrigSectionsWidths[Ord(soComputedBy)]);
    WriteInteger(TableName, 'HdrIndexCountWidth', OrigSectionsWidths[Ord(soIndexCount)]);
  end;
end;
//=============================================================================

procedure TfraTable.LoadFromIniFile(Ini: TIniFile);
begin
  inherited;
  with Ini do
  begin
    SectionsWidths[Ord(soName)] := ReadInteger(TableName, 'HdrNameWidth', 130);
    SectionsWidths[Ord(soType)] := ReadInteger(TableName, 'HdrTypeWidth', 130);
    SectionsWidths[Ord(soDomain)] := ReadInteger(TableName, 'HdrDomainWidth', 130);
    SectionsWidths[Ord(soComputedBy)] := ReadInteger(TableName, 'HdrComputedByWidth', 130);
    SectionsWidths[Ord(soIndexCount)] := ReadInteger(TableName, 'HdrIndexCountWidth', 130);

    pnlMain.Color := StringToColor(ReadString(TableName, 'Color', 'clBtnFace'));
    ShowOptions := [soName];
    if ReadBool(TableName, 'soTypes', true) then
      ShowOptions := ShowOptions + [soType];
    if ReadBool(TableName, 'soDomain', true) then
      ShowOptions := ShowOptions + [soDomain];
    if ReadBool(TableName, 'soRequired', true) then
      ShowOptions := ShowOptions + [soRequired];
    if ReadBool(TableName, 'soIcons', true) then
      ShowOptions := ShowOptions + [soIcons];
    if ReadBool(TableName, 'soKeysOnly', false) then
      ShowOptions := ShowOptions + [soKeysOnly];
    if ReadBool(TableName, 'soTitleOnly', false) then
      ShowOptions := ShowOptions + [soTitleOnly];
    if ReadBool(TableName, 'soComputedBy', false) then
      ShowOptions := ShowOptions + [soComputedBy];
    if ReadBool(TableName, 'soIndexCount', false) then
      ShowOptions := ShowOptions + [soIndexCount];
    if ReadBool(TableName, 'soHeader', false) then
      ShowOptions := ShowOptions + [soHeader];
    Header.Visible := soHeader in ShowOptions;
  end;
  SaveCoordToOrig;
end;
//=============================================================================

function TfraTable.GetLeftJoin(sFieldName: string): TPoint;
begin
  if soTitleOnly in ShowOptions then
    Result := Point(Left - TModel(Model).RelPointer, Self.Top + lblTableName.Top + (lblTableName.Height div 2))
  else
    Result := Point(Left - TModel(Model).RelPointer, GetFieldVerticalPosition(sFieldName));
end;
//=============================================================================

function TfraTable.GetRightJoin(sFieldName: string): TPoint;
begin
  if soTitleOnly in ShowOptions then
    Result := Point(Left + Width + TModel(Model).RelPointer, Self.Top + lblTableName.Top + (lblTableName.Height div 2))
  else
    Result := Point(Left + Width + TModel(Model).RelPointer, GetFieldVerticalPosition(sFieldName));
end;
//=============================================================================

function TfraTable.GetFieldVerticalPosition(sFieldName: string): integer;
begin
  with lbFields do
  begin
    Result := ItemRect(Items.IndexOf(sFieldName)).Top + (ItemHeight div 2);
    if Result > lbFields.Height then
      Result := lbFields.Height + 2
    else if Result < 0 then
      Result := -4;
    Result := Result + lbFields.Top + Self.Top + 2;
  end;
end;
//=============================================================================

procedure TfraTable.KeyPress(var Key: Char);
begin
  inherited;
  if UpperCase(Key) = 'T' then
    mniTypes.Click
  else if UpperCase(Key) = 'D' then
    mniDomains.Click
  else if UpperCase(Key) = 'B' then
    mniComputedBy.Click
  else if UpperCase(Key) = 'R' then
    mniRequired.Click
  else if UpperCase(Key) = 'I' then
    mniIndexCount.Click
  else if UpperCase(Key) = 'K' then
    mniKeysOnly.Click
  else if UpperCase(Key) = 'L' then
    mniTitleOnly.Click
  else if UpperCase(Key) = 'H' then
    mniHeader.Click;
end;
//=============================================================================

procedure TfraTable.lbFieldsClick(Sender: TObject);
var
  fm: TfmCreateTable;
begin
  inherited;
  if Model.AddingCustomRelation then
  begin
//    if Model.SelectedFrameCount = 0 then
    if (Model.CustomRelationAFrame = '')
      and (Model.CustomRelationBFrame = '') then
    begin
      Screen.Cursor := crCustomLinkTo;
      //Model.AddSelectedFrame(Self, false);
      Model.CustomRelationAFrame := FrameName;
      Model.CustomRelationAField := lbFields.Fields[lbFields.ItemIndex].Name;
    end
    else
    begin
      Screen.Cursor := crDefault;
      Self.FrameMouseUp(Self, mbLeft, [], 0, 0); //aby se premaloval ramecek
      Model.CustomRelationBFrame := FrameName;
      Model.CustomRelationBField := lbFields.Fields[lbFields.ItemIndex].Name;
      //Model.AddSelectedFrame(Self, true);
      Model.CreateCustomRelation;
      Model.ModelForm.actModelAddCustomRelation.Checked := false;
      Model.AddingCustomRelation := false;
    end
  end
  else if Model.AddingRelation then
  begin
    //if Model.SelectedFrameCount = 0 then
    if (Model.CustomRelationAFrame = '')
      and (Model.CustomRelationBFrame = '') then
    begin
      Screen.Cursor := crCustomLinkTo;
      //Model.AddSelectedFrame(Self, false);
      Model.CustomRelationAFrame := FrameName;
      Model.CustomRelationAField := lbFields.Fields[lbFields.ItemIndex].Name;
    end
    else
    begin
      Screen.Cursor := crDefault;
      Self.FrameMouseUp(Self, mbLeft, [], 0, 0); //aby se premaloval ramecek
      Model.CustomRelationBFrame := FrameName;
      Model.CustomRelationBField := lbFields.Fields[lbFields.ItemIndex].Name;
      //Model.AddSelectedFrame(Self, true);

      Model.ModelForm.actModelCreateRelation.Checked := false;

      fm := TfmCreateTable.Create(Application);
      fm.FaceCreateRelation;
      //fm.BehaveAsModal := true;
      fm.Model := Model;
      fm.pgMain.ActivePage := fm.tsCreateRelation;
      fm.edRelTableName.Text := Model.CustomRelationAFrame;
      fm.edRelFieldName.Text := Model.CustomRelationAField;
      fm.edRelFkTableName.Text := Model.CustomRelationBFrame;
      fm.edRelFkFieldName.Text := Model.CustomRelationBField;
      Model.CustomRelationAFrame := '';
      Model.CustomRelationBFrame := '';
      Model.CustomRelationAField := '';
      Model.CustomRelationBField := '';
      Model.AddingRelation := false;

      fm.btCreateScript.Click;
      fm.EnableButtons;
      fm.Script.IB_Connection := Model.ModelForm.cnModel;
      fm.RunScript.IB_Connection := Model.ModelForm.cnModel;
      //fm.trCreateTable.IB_Connection := Model.ModelForm.cnModel;
      fm.ShowModal;

//      with fm.cnCreateTable do
//      begin
//        Username := model.ModelForm.cnModel.Username;
//        Password := model.ModelForm.cnModel.Password;
//        Path := model.ModelForm.cnModel.Path;
//        FieldsCharCase.Clear;
//        FieldsCharCase.Add(model.ModelForm.cnModel.FieldsCharCase.Strings[0]);
//        LoginPrompt := false;
//        Connect;
//        if Connected then
//          fm.Show
//        else
//          fm.Free;
//      end;
    end;
  end;
end;
//=============================================================================

procedure TfraTable.LoadCoordFromOrig;
begin
  inherited;
  SectionsWidths[0] := OrigSectionsWidths[0];
  SectionsWidths[1] := OrigSectionsWidths[1];
  SectionsWidths[2] := OrigSectionsWidths[2];
  SectionsWidths[3] := OrigSectionsWidths[3];
end;
//=============================================================================

procedure TfraTable.SaveCoordToOrig;
begin
  inherited;
  OrigSectionsWidths[0] := Round(SectionsWidths[0] / (Model.CurrentScale / 100));
  OrigSectionsWidths[1] := Round(SectionsWidths[1] / (Model.CurrentScale / 100));
  OrigSectionsWidths[2] := Round(SectionsWidths[2] / (Model.CurrentScale / 100));
  OrigSectionsWidths[3] := Round(SectionsWidths[3] / (Model.CurrentScale / 100));
end;
//=============================================================================

procedure TfraTable.mniCreateFieldClick(Sender: TObject);
var
  fm: TfmCreateTable;
  sSql: string;
  n: integer;
begin
  inherited;
  fm := TfmCreateTable.Create(Application);
  fm.FaceCreateField;
  //fm.BehaveAsModal := true;
  fm.Model := Model;
  fm.EnableButtons;
  fm.Script.IB_Connection := Model.ModelForm.cnModel;
  fm.RunScript.IB_Connection := Model.ModelForm.cnModel;
  sSql := Format('ALTER TABLE %s ADD ;', [Self.TableName]);
  sSql := Format('/*Script generated by IBUtils  %s */' + #13#10#13#10 + sSql, [FormatDateTime('dd.mm.yyyy hh:mm', Now)]);
  n := Length(sSql) - 1;
//  sSql := sSql + #13#10#13#10 + 'COMMIT WORK;';
  fm.meScript.Lines.Text := sSql;
  fm.meScript.SelStart := n;
  fm.ShowModal;
end;
//=============================================================================

procedure TfraTable.mniDropFieldClick(Sender: TObject);
var
  Script: TIB_Script;
  FieldName, sSql: string;
begin
  if lbFields.ItemIndex > -1 then
  begin
    FieldName := lbFields.Fields[lbFields.ItemIndex].Name;
    if MessageDlg(Format('Do you want to drop the field %s from table %s?', [FieldName, TableName]), mtConfirmation, [mbYes,mbNo], 0) = mrYes then
    begin
      sSql := Format('ALTER TABLE %s DROP %s;' + #13#10{#13#10 + 'COMMIT WORK;'}, [TableName, FieldName]);
      sSql := Format(#13#10 + '/*Script generated by IBUtils  %s */' + #13#10#13#10 + sSql, [FormatDateTime('dd.mm.yyyy hh:mm', Now)]);
      Script := TIB_Script.Create(Self);
      Script.IB_Connection := TModel(Model).ModelForm.cnModel;
      try
        if not Script.IB_Connection.Connected then
          Script.IB_Connection.Connect;
        Script.SQL.Text := sSql;
        Script.Execute;
        mniRefreshClick(nil);
        TimeMessage('Field was successfully dropped.', 500);
        MakeLogDef(Script.IB_Connection, sSql);
      finally
        Script.Free;
        Model.ModelForm.CheckConnected;
      end;
    end;
  end;
end;
//=============================================================================

procedure TfraTable.lbFieldsDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  i: integer;
begin
  inherited;
  Accept := (Source is TScrollListBox);
  if Accept then
  begin
    lbFields.ItemIndex := lbFields.ItemAtPos(Point(X, Y), true);
    Accept := lbFields.ItemIndex <> -1;
  end;
end;
//=============================================================================

procedure TfraTable.lbFieldsDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  fm: TfmCreateTable;
  SourceFrame: TfraTable;
  n: integer;
begin
  inherited;
  if Source is TScrollListBox then
  begin
    SourceFrame := (TScrollListBox(Source).Owner as TfraTable);
    fm := TfmCreateTable.Create(Application);
    fm.FaceCreateRelation;
    fm.Model := Model;
    fm.pgMain.ActivePage := fm.tsCreateRelation;
    fm.edRelTableName.Text := SourceFrame.FrameName;
    n := 0;
    while (n < SourceFrame.lbFields.Count) and not SourceFrame.lbFields.Selected[n] do
      Inc(n);
    fm.edRelFieldName.Text := SourceFrame.lbFields.Fields[n].Name;
    fm.edRelFkTableName.Text := FrameName;
    fm.edRelFkFieldName.Text := lbFields.Fields[lbFields.ItemIndex].Name;

    fm.btCreateScript.Click;
    fm.EnableButtons;
    fm.Script.IB_Connection := Model.ModelForm.cnModel;
    fm.RunScript.IB_Connection := Model.ModelForm.cnModel;
    fm.ShowModal;
  end;
end;
//=============================================================================

procedure TfraTable.lbFieldsStartDrag(Sender: TObject; var DragObject: TDragObject);
var
  i: integer;
  fra: TfraMain;
begin
  inherited;
//  if not Model.AddingCustomRelation and not Model.AddingRelation then
  begin
//    for i := 0 to Model.FrameCount-1 do
//    begin
//      fra := Model.Frames[i];
//      if (fra is TfraTable) and (fra <> Self) then
//      begin
//        TfraTable(Model.Frames[i]).lbFields.Multiselect := false;
//        TfraTable(Model.Frames[i]).lbFields.ClearSelection;
//      end;
//    end;
  end;
end;
//=============================================================================

procedure TfraTable.mniMoveUpClick(Sender: TObject);
begin
  inherited;
  if lbFields.ItemIndex > 0 then
  begin
    ExchangeFields(lbFields.ItemIndex, lbFields.ItemIndex-1);
    lbFields.Invalidate;
    lbFields.ItemIndex := lbFields.ItemIndex - 1;
    lbFields.Selected[lbFields.ItemIndex] := true;
    lbFields.Selected[lbFields.ItemIndex+1] := false;
    CreateCompileButton;
  end;
end;
//=============================================================================

procedure TfraTable.mniMoveDownClick(Sender: TObject);
begin
  inherited;
  if lbFields.ItemIndex < lbFields.Items.Count-1 then
  begin
    ExchangeFields(lbFields.ItemIndex, lbFields.ItemIndex+1);
    lbFields.Invalidate;
    lbFields.ItemIndex := lbFields.ItemIndex + 1;
    lbFields.Selected[lbFields.ItemIndex] := true;
    lbFields.Selected[lbFields.ItemIndex-1] := false;
    CreateCompileButton;
  end;
end;
//=============================================================================

procedure TfraTable.ExchangeFields(i, j: integer);
var
  tmp: PFieldRec;
begin
  tmp := lbFields.Fields[i];
  lbFields.Fields[i] := lbFields.Fields[j];
  lbFields.Fields[j] := tmp;
end;
//=============================================================================

procedure TfraTable.btCompileClick(Sender: TObject);
begin
  inherited;
  PostMessage(lbFields.Handle, WM_KEYDOWN, VK_F9, 0);
  //CompileReorderChanges;
end;
//=============================================================================

procedure TfraTable.CompileReorderChanges;
var
  i: integer;
  Script: TIB_Script;
begin
  Script := TIB_Script.Create(Self);
  Script.IB_Connection := TModel(Model).ModelForm.cnModel;
  try
    Script.SQL.Add('');
    Script.SQL.Add(Format('/*Script generated by IBUtils  %s */', [FormatDateTime('dd.mm.yyyy hh:mm', Now)]));
    for i := 0 to lbFields.Count-1 do
      Script.SQL.Add(Format('ALTER TABLE %s ALTER COLUMN %s POSITION %d;', [TableName, lbFields.Fields[i].Name, i+1]));
    Script.SQL.Add('COMMIT WORK;');
    Script.SQL.Add('');
    Script.Execute;
    MakeLogDef(Script.IB_Connection, Script.SQL.Text);

     mniRefreshClick(nil);
  finally
    Script.Free;
  end;
end;
//=============================================================================

procedure TfraTable.CreateCompileButton;
begin
  if not Assigned(btCompile) then
  begin
    btCompile := TButton.Create(pnlMain);
    btCompile.Parent := pnlMain;
    btCompile.Hint := 'Compile the reorder fields changes. (F9)';
    btCompile.Caption := 'Compile (F9)';
    btCompile.OnClick := btCompileClick;
    CompileButtonScale;
    btCompile.Visible := true;
  end;
end;
//=============================================================================

procedure TfraTable.CompileButtonScale;
begin
  if Assigned(btCompile) then
  begin
    btCompile.Height := lblTableName.Height;
    btCompile.Top := lblTableName.Top;
    btCompile.Font := lblTableName.Font;
    btCompile.Width := lblTableName.Canvas.TextWidth(btCompile.Caption) + 8;
    btCompile.Left := pnlMain.Width - btCompile.Width - lblTableName.Left;
  end;
end;
//=============================================================================

procedure TfraTable.lbFieldsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  case Key of
    VK_F9:
      if Assigned(btCompile) then
      begin
        CompileReorderChanges;
        btCompile.Free;
        btCompile := nil;
      end;
  end;
end;
//=============================================================================

procedure TfraTable.mniBrowseClick(Sender: TObject);
var
  fm: TfmBrowse;
  i: integer;
  FieldName: string;
  //dt: TIB_Date;
begin
  inherited;
  fm := TfmBrowse.Create(Application);
  fm.ModelForm := Model.ModelForm;
  fm.TableName := TableName;
  Model.ModelForm.BrowseList.Add(fm);
  fm.Caption := Format('%s - %s (%s)', [fm.Caption, TableName, ExtractFileName(Model.Filename)]);
  fm.StatusBar.Panels[1].Text := Model.ModelForm.cnModel.Database;
  with fm.qrBrowse do
  begin
    IB_Connection := Model.ModelForm.cnModel;
    SQL.Text := Format('SELECT * FROM %s FOR UPDATE', [TableName]);
    Prepare;
    for i := 0 to FieldCount-1 do
    begin
      FieldName := Fields[i].FieldName;
      OrderingItems.Add(Format('%s=%s;%s DESC', [FieldName, FieldName, FieldName]));
      OrderingLinks.Add(Format('%s=ITEM=%d', [FieldName, i+1]));
      if Fields[i].IsDateTime then
      begin
//        dt := TIB_Date.Create(fm.grBrowse);
//        dt.Parent := fm.grBrowse;
//        dt.DataSource := fm.dsBrowse;
//        dt.DataField := FieldName;
      end;
    end;
    Open;
    fm.StatusBar.Panels[0].Text := Format('Records count: %d', [RecordCount]);
  end;
end;
//=============================================================================

procedure TfraTable.Arrange;
var
  n, iWidth, iHeight: integer;
begin
  iWidth := 2*lbFields.Left + SectionsWidths[Ord(soName)] + 4;

  n := 0;
  if (soType in Model.DefaultShowOptions) and (Model.DefColCount >= 2 ) then
    iWidth := iWidth + SectionsWidths[Ord(soType)]
  else
    Inc(n);

  if (soDomain in Model.DefaultShowOptions) and (Model.DefColCount >= (3-n) ) then
    iWidth := iWidth + SectionsWidths[Ord(soType)]
  else
    Inc(n);

  if (soComputedBy in Model.DefaultShowOptions) and (Model.DefColCount >= (4-n) ) then
    iWidth := iWidth + SectionsWidths[Ord(soComputedBy)]
  else
    Inc(n);

  if (soIndexCount in Model.DefaultShowOptions) and (Model.DefColCount >= (5-n) ) then
    iWidth := iWidth + SectionsWidths[Ord(soIndexCount)];

  iHeight := Height - lbFields.Height + (lbFields.Count * lbFields.ItemHeight) + 6;
  SetBounds(Left, Top, iWidth, iHeight);
end;
//=============================================================================

procedure TfraTable.SetHeaderSectionSize(ASectionNumber: integer = -1); //-1 znamená všechny
var
  i, wName, wType, wDomain , wComputedBy, wIndexCount, iWidth: integer;
begin
  wName := Header.Canvas.TextWidth('Name') + 4;
  wType := Header.Canvas.TextWidth('Type') + 4;
  wDomain := Header.Canvas.TextWidth('Domain') + 4;
  wComputedBy := Header.Canvas.TextWidth('Computed By') + 4;
  wIndexCount := Header.Canvas.TextWidth('Index count') + 4;

  for i := 0 to lbFields.Count-1 do
  begin
    wName := Max(wName, lbFields.Canvas.TextWidth(lbFields.Fields[i]^.Name) + 5);
    wType := Max(wType, lbFields.Canvas.TextWidth(lbFields.Fields[i]^.FieldType) + 7);
    wDomain := Max(wDomain, lbFields.Canvas.TextWidth(lbFields.Fields[i]^.Domain) + 7);
    wComputedBy := Max(wComputedBy, lbFields.Canvas.TextWidth(lbFields.Fields[i]^.ComputedBy) + 7);
    wIndexCount := Max(wIndexCount, lbFields.Canvas.TextWidth(IntToStr(lbFields.Fields[i]^.IndexCount)) + 7);
  end;

  if soIcons in ShowOptions then
    Inc(wName, 15)
  else
    Inc(wName, 2);

  if (ASectionNumber = - 1) or (ASectionNumber = 0) then
    SectionsWidths[Ord(soName)] := wName;
  if (ASectionNumber = - 1) or (ASectionNumber = 1) then
    SectionsWidths[Ord(soType)] := wType;
  if (ASectionNumber = - 1) or (ASectionNumber = 2) then
    SectionsWidths[Ord(soDomain)] := wDomain;
  if (ASectionNumber = - 1) or (ASectionNumber = 3) then
    SectionsWidths[Ord(soComputedBy)] := wComputedBy;
  if (ASectionNumber = - 1) or (ASectionNumber = 4) then
    SectionsWidths[Ord(soIndexCount)] := wIndexCount;
end;
//=============================================================================

procedure TfraTable.InitializeHeader;
begin
  lbFields.Canvas.Font.Size := 10;
  SetHeaderSectionSize;
end;
//=============================================================================

procedure TfraTable.mniIndexesClick(Sender: TObject);
var
  fm: TfmIndexes;
begin
  inherited;
  fm := TfmIndexes.Create(Application);
  fm.lblTitle.Caption := Format('  Indices for table %s', [Self.FrameName]);
  fm.Table := Self;

  fm.qrIndexes.IB_Connection := Model.ModelForm.cnModel;
  fm.qrIndexes.Prepare;
  fm.qrIndexes.ParamByName('TABLE_NAME').AsString := Self.FrameName;
  fm.qrIndexes.Open;

  fm.qrIndexSeg.IB_Connection := Model.ModelForm.cnModel;
  fm.qrIndexSeg.Prepare;

  fm.ShowModal;
  Model.ModelForm.CheckConnected;
end;
//=============================================================================

procedure TfraTable.CreateIndexes;
var
  fm: TfmCreateTable;
  n: integer;
  sFields: string;
begin
  fm := TfmCreateTable.Create(Application);
  fm.FaceCreateIndex;
  fm.Model := Model;
  fm.pgMain.ActivePage := fm.tsCreateIndex;
  fm.edIndTableName.Text := Self.FrameName;
  sFields := '';
  n := 0;
  while (n < Self.lbFields.Count) do
  begin
    if Self.lbFields.Selected[n] then
    begin
      if sFields <> '' then
        sFields := sFields + ', ';
      sFields := sFields + Self.lbFields.Fields[n]^.Name;
    end;
    Inc(n);
  end;
  fm.edIndFieldsList.Text := sFields;

  fm.Script.IB_Connection := Model.ModelForm.cnModel;
  fm.RunScript.IB_Connection := Model.ModelForm.cnModel;
  fm.btCreateScript.Click;
  fm.EnableButtons;
  fm.ShowModal;
end;
//=============================================================================

procedure TfraTable.mniCreateIndexClick(Sender: TObject);
begin
  inherited;
  CreateIndexes;
end;
//=============================================================================

procedure TfraTable.lblTableNameDblClick(Sender: TObject);
var
  fm: TfmDescription;
  qr: TIB_Query;
begin
  inherited;
  bWasDblClick := true;
  fm := TfmDescription.Create(nil);
  try
    fm.lblTitle.Caption := Format('Description of %s', [TableName]);
    fm.meDesc.Lines.Text := lblTableName.Hint;
    if fm.ShowModal = mrOk then
    begin
      qr := TIB_Query.Create(nil);
      try
        qr.IB_Connection := Model.ModelForm.cnModel;
        qr.Sql.Text := Format('UPDATE RDB$RELATIONS SET RDB$DESCRIPTION=''%s'' WHERE RDB$RELATION_NAME=''%s''', [fm.meDesc.Lines.Text, TableName]);
        qr.ExecSql;
        lblTableName.Hint := fm.meDesc.Lines.Text;
      finally
        qr.Free;
      end;
    end;
  finally
    fm.Free;
  end;
end;
//=============================================================================

procedure TfraTable.lbFieldsDblClick(Sender: TObject);
var
  fm: TfmDescription;
  qr: TIB_Query;
begin
  inherited;
  bWasDblClick := true;
  fm := TfmDescription.Create(nil);
  try
    fm.lblTitle.Caption := Format('Description of %s', [lbFields.Fields[lbFields.ItemIndex].Name]);
    fm.meDesc.Lines.Text := lbFields.Fields[lbFields.ItemIndex].Description;
    if fm.ShowModal = mrOk then
    begin
      qr := TIB_Query.Create(nil);
      try
        qr.IB_Connection := Model.ModelForm.cnModel;
        qr.Sql.Text := Format('UPDATE RDB$RELATION_FIELDS SET RDB$DESCRIPTION=''%s'' WHERE RDB$FIELD_NAME=''%s'' AND RDB$RELATION_NAME=''%s''', [fm.meDesc.Lines.Text, lbFields.Fields[lbFields.ItemIndex].Name, TableName]);
        qr.ExecSql;
        lbFields.Fields[lbFields.ItemIndex].Description := fm.meDesc.Lines.Text;
      finally
        qr.Free;
      end;
    end;
  finally
    fm.Free;
  end;
end;
//=============================================================================

procedure TfraTable.mniAdjustCurrentClick(Sender: TObject);
var
  i: integer;
  fra: TfraMain;
begin
  inherited;
  for i := 0 to Model.SelectedFrameCount-1 do
  begin
    fra := Model.SelectedFrames[i];
    if (fra <> Self) and (fra is TfraTable) then  //nemusí být vybraná a kliklo se na ni, udìlá se nakonec
    begin
      with TfraTable(fra) do
      begin
        CurrentHeaderSection := FCurrentHeaderSection;
        SetHeaderSectionSize(FCurrentHeaderSection);
        RecreateHeaderSections;
        lbFields.RefreshFields;
      end;
    end;
  end;

  //totéž pro aktuální tabulku (to proto, že nemusí být vybraná a kliklo se na ni
  SetHeaderSectionSize(FCurrentHeaderSection);
  RecreateHeaderSections;
  lbFields.RefreshFields;
end;
//=============================================================================

procedure TfraTable.mniAdjustAllClick(Sender: TObject);
var
  i: integer;
  fra: TfraMain;
begin
  inherited;
  for i := 0 to Model.SelectedFrameCount-1 do
  begin
    fra := Model.SelectedFrames[i];
    if (fra <> Self) and (fra is TfraTable) then  //nemusí být vybraná a kliklo se na ni, udìlá se nakonec
    begin
      with TfraTable(fra) do
      begin
        CurrentHeaderSection := FCurrentHeaderSection;
        SetHeaderSectionSize(-1);
        RecreateHeaderSections;
        lbFields.RefreshFields;
      end;
    end;
  end;

  //totéž pro aktuální tabulku (to proto, že nemusí být vybraná a kliklo se na ni
  SetHeaderSectionSize(-1);
  RecreateHeaderSections;
  lbFields.RefreshFields;
end;
//=============================================================================

procedure TfraTable.HeaderMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SetCurrentHeaderSection(X);
end;
//=============================================================================

procedure TfraTable.SetCurrentHeaderSection(AX: integer);
var
  i, iWidth: integer;
begin
  inherited;
  iWidth := 0;
  FCurrentHeaderSection := -1;
  for i := 0 to 4 do
  begin
    Inc(iWidth, SectionsWidths[i]);
    if AX < iWidth then
    begin
      FCurrentHeaderSection := i;
      Exit;
    end;
  end;
end;
//=============================================================================

procedure TfraTable.popHeaderPopup(Sender: TObject);
begin
  inherited;
  SetAdjustMenuCaptions;
end;
//=============================================================================

procedure TfraTable.SetAdjustMenuCaptions;
begin
  if FCurrentHeaderSection > -1 then
    mniAdjustCurrent.Caption := Format('Adjust Width of ''%s''', [Header.Sections.Items[FCurrentHeaderSection].Text])
  else
    mniAdjustCurrent.Caption := 'Adjust Current Width';
  mniAdjustCurrent2.Caption := mniAdjustCurrent.Caption;
end;
//=============================================================================

procedure TfraTable.mniArrangeClick(Sender: TObject);
var
  i: integer;
  fra: TfraMain;
begin
  inherited;
  for i := 0 to Model.SelectedFrameCount-1 do
  begin
    fra := Model.SelectedFrames[i];
    if (fra <> Self) and (fra is TfraTable) then  //nemusí být vybraná a kliklo se na ni, udìlá se nakonec
      with TfraTable(fra) do
      begin
        //nastavit šíøku pole "Name"
        CurrentHeaderSection := 0;
        SetHeaderSectionSize(0);
        RecreateHeaderSections;
        lbFields.RefreshFields;
        //nastavit velikost
        Arrange;
        SaveCoordToOrig;
        RefreshRelations;
      end;
  end;

  //totéž pro aktuální tabulku (to proto, že nemusí být vybraná a kliklo se na ni
  //nastavit šíøku pole "Name"
  CurrentHeaderSection := 0;
  SetHeaderSectionSize(0);
  RecreateHeaderSections;
  lbFields.RefreshFields;
  //nastavit velikost
  Arrange;
  SaveCoordToOrig;
  RefreshRelations;
  Model.Invalidate;
end;                                                                
//=============================================================================

end.

