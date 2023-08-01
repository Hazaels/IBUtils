unit fraMain_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Model, Progress, IniFiles;

const
  REL_POINTER = 15;

type
  TShowOption = (soName, soType, soDomain, soComputedBy, soIndexCount, soRequired, soIcons, soKeysOnly, soTitleOnly, soHeader);
  TShowOptions = set of TShowOption;

  TfraMain = class;                              //forward declaration
  TModel = class;

  PPoint = ^TPoint;
  PHRGN = ^HRGN;

  { TRelation }
  TRelation = class(TObject)
    constructor Create(AOwner: TModel);
    destructor Destroy; override;
  private
    FSelected, FFocused: boolean;
    FAPos, FBPos: TPoint;
    //    FIsOut: boolean;
    FAFrame, FBFrame: TfraMain;
    FModel: TModel;
    Rgn: HRGN;
    RgnArr: array[1..4] of TPoint;
    RgnList: TList;
    OrigNodeList: TList;
    FFocusedNode: integer;                        //node number in the NodeList
    procedure SetAPos(pt: TPoint);
    procedure SetBPos(pt: TPoint);
    procedure SetSelected(Value: boolean);
    procedure Click(X, Y: integer);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X,
      Y: integer);
    procedure MouseMove(Shift: TShiftState; X, Y: integer);
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X,
      Y: integer);
    procedure SetFocused(const Value: boolean);
    function NodeRect(n: integer): TRect;
    procedure LoadCoordFromOrig;
    procedure SaveCoordToOrig;
    procedure ChangeScale(M, D: integer);
    function GetRect: TRect;
  public
    AToLeft, BToLeft: boolean;
    Name, DBName, PrimaryKey, ForeignKey: string;
    NotNull: boolean;
    NodeList: TList;
    IsCustomRelation: boolean;
    property APos: TPoint read FAPos write SetAPos;
    property BPos: TPoint read FBPos write SetBPos;
    property AFrame: TfraMain read FAFrame write FAFrame;
    property BFrame: TfraMain read FBFrame write FBFrame;
    property Selected: boolean read FSelected write SetSelected;
    property Focused: boolean read FFocused write SetFocused;
    property FocusedNode: integer read FFocusedNode;
    procedure Paint;
    procedure SetPosition;
    procedure DeleteNode(i: integer);
    procedure LoadNodesFromIni(Ini: TIniFile);
  end;

  { TModel }
  TModel = class(TPanel)
  private
    FFrames, FRelations, FSelectedFrames, FSelectedNodes: TList;
    nFrameCounter, mx, my: integer;
    FModified: boolean;
    bDown, bDraggingNode: boolean;
    FFocusedRelation: TRelation;
    function GetFrame(i: integer): TfraMain;
    function GetFrameCount: integer;
    function GetRelation(i: integer): TRelation;
    function GetRelationCount: integer;
    procedure SetModified(Value: boolean);
    function GetSelectedFrame(i: integer): TfraMain;
    function GetSelectedFrameCount: integer;
    procedure DrawRectangle(ALeft, ATop, AWidth, AHeight: integer);
  public
    bx, by: integer;
    ModelForm: TfmModel;
    Filename: string;
    FileHandle: integer;
    ReadOnly: boolean;
    CurrentScale: integer;
    Title, AddTablesFilter: string;
    fmProgress: TfmProgress;
    DefaultShowOptions: TShowOptions;
    DefColCount: integer;
    SnapToGrid, SnapRelToGrid, ShowGrid: boolean;
    GridX, GridY: integer;
    ShowSystemDomains, CombinedTypeDomain: boolean;
    AddingCustomRelation, AddingRelation: boolean;
    CustomRelationAFrame, CustomRelationBFrame, CustomRelationAField, CustomRelationBField: string;
    LinkColorDefault, LinkColorSelected, LinkColorFocused, LinkColorCustom: TColor;
    RelPointer: integer;
    Password, Username: string;
    //nNoteCounter: integer;
    property Modified: boolean read FModified write SetModified;
    property SelectedFrames[i: integer]: TfraMain read GetSelectedFrame;
    property SelectedFrameCount: integer read GetSelectedFrameCount;
    property Frames[i: integer]: TfraMain read GetFrame;
    property FrameCount: integer read GetFrameCount;
    property Relations[i: integer]: TRelation read GetRelation;
    property FocusedRelation: TRelation read FFocusedRelation write FFocusedRelation;
    property RelationCount: integer read GetRelationCount;
    procedure AddSelectedFrame(AFrame: TfraMain; MultiSelected: boolean);
    procedure DeselectFrames;
    procedure AddRelation(ARelation: TRelation);
    procedure DeleteRelation(ARelation: TRelation);
    procedure AddFrame(AFrame: TfraMain); overload;
    function AddFrame(sFrameName: string): TfraMain; overload;
    procedure DeleteFrame(AFrame: TfraMain);
    function FrameByName(sFrameName: string): TfraMain;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function FrameByTag(nTag: integer): TfraMain;
    procedure Paint; override;
    function RelationByName(AName: string): TRelation;
    procedure ResizeModel;
    function ListOfTables: string;
    procedure Refresh;
    procedure Save;
    procedure SaveAs;
    procedure Open(sFilename: string; AUserName: string = ''; APassword: string = '');
    procedure ImportTables(AFilename: string; APoint: TPoint; ASelect: boolean = false);
    procedure Scale(Percent: integer);
    procedure MyClick(Sender: TObject);
    procedure MyMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MyMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure MyMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure WndProc(var Message: TMessage); override;
    procedure CreateCustomRelation;
  end;

  TfraMain = class(TFrame)
    pnlMain: TPanel;
    procedure pnlMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlMainMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pnlMainMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FrameMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FrameMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FrameMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FModel: TModel;
    bx, by: integer;                              //begin x, begin y
    _LeftTop, LeftTop: TPoint;
    bMoving: boolean;
    bResizingT, bResizingL, bResizingR, bResizingB: boolean;
    bResizingTL, bResizingTR, bResizingBL, bResizingBR: boolean;
    FRelations: TList;
    FSelected: boolean;
    FFrameName: string;
    pnlMainOriginalWndProc: TWndMethod;
    FInternalName: string;
    procedure SetSelected(Value: boolean);
    function GetRelation(i: integer): TRelation;
    procedure DrawRectangle(ALeft, ATop, AWidth, AHeight: integer);
    function GetRelationCount: integer;
  protected
    bWasDblClick, bDown: boolean;
    procedure AddRelations; virtual;
    procedure SaveToIniFile(Ini: TIniFile); virtual;
    procedure LoadFromIniFile(Ini: TIniFile); virtual;
    function GetLeftJoin(sFieldName: string): TPoint; virtual;
    function GetRightJoin(sFieldName: string): TPoint; virtual;
  public
    OrigHeight, OrigWidth, OrigLeft, OrigTop: integer;
    bFirstMove: boolean;
    ShowOptions: TShowOptions;
    property Selected: boolean read FSelected write SetSelected;
    property Relations[i: integer]: TRelation read GetRelation;
    property RelationCount: integer read GetRelationCount;
    property Model: TModel read FModel write FModel;
    property FrameName: string read FFrameName write FFrameName;
    property InternalName: string read FInternalName write FInternalName;
    constructor Create(AOwner: TModel); virtual;
    constructor CreateByName(AOwner: TModel; sTableName: string); virtual;
    destructor Destroy; override;
    procedure pnlMainWndProc(var Message: TMessage);
    procedure KeyPress(var Key: Char); override;
    procedure AddRelation(ARelation: TRelation);
    procedure DeleteRelation(ARelation: TRelation);
    procedure RefreshRelations; virtual;
    procedure ReDrawRelations;
    procedure Refresh; virtual;
    procedure Paint; virtual;
    procedure SaveCoordToOrig; virtual;
    procedure LoadCoordFromOrig; virtual;
    procedure ChangeScale(M, D: Integer); override;
  end;

implementation

uses MAIN, Math, fraTable_u, fraNote_u, ComCtrls, IB_Utils;

var
  TempCursor: TCursor;

{$R *.dfm}

procedure GetRegionArray(a, b: TPoint; var Result: array of TPoint);
const
  d = 5;
begin

  if ((a.x < b.x) and (a.y < b.y))
    or ((a.x > b.x) and (a.y > b.y)) then         // \
  begin
    Result[0].X := a.X + d;
    Result[0].Y := a.Y - d;
    Result[1].X := a.X - d;
    Result[1].Y := a.Y + d;
    Result[2].X := b.X - d;
    Result[2].Y := b.Y + d;
    Result[3].X := b.X + d;
    Result[3].Y := b.Y - d;
  end
  else if ((a.x = b.x) and (a.y < b.y))
    or ((a.x = b.x) and (a.y > b.y)) then         // |
  begin
    Result[0].X := a.X + d;
    Result[0].Y := a.Y;
    Result[1].X := a.X - d;
    Result[1].Y := a.Y;
    Result[2].X := b.X - d;
    Result[2].Y := b.Y;
    Result[3].X := b.X + d;
    Result[3].Y := b.Y;
  end
  else if ((a.x > b.x) and (a.y < b.y))
    or ((a.x < b.x) and (a.y > b.y)) then         // /
  begin
    Result[0].X := a.X + d;
    Result[0].Y := a.Y + d;
    Result[1].X := a.X - d;
    Result[1].Y := a.Y - d;
    Result[2].X := b.X - d;
    Result[2].Y := b.Y - d;
    Result[3].X := b.X + d;
    Result[3].Y := b.Y + d;
  end
  else if ((a.x < b.x) and (a.y = b.y))
    or ((a.x > b.x) and (a.y = b.y)) then         // -
  begin
    Result[0].X := a.X;
    Result[0].Y := a.Y + d;
    Result[1].X := a.X;
    Result[1].Y := a.Y - d;
    Result[2].X := b.X;
    Result[2].Y := b.Y - d;
    Result[3].X := b.X;
    Result[3].Y := b.Y + d;
  end;
end;
//============================================================================


{TRelation}

constructor TRelation.Create(AOwner: TModel);
begin
  inherited Create;
  FModel := AOwner;
  RgnList := TList.Create;
  Rgn := CreateRectRgn(0, 0, 0, 0);
  NodeList := TList.Create;
  OrigNodeList := TList.Create;
  FFocusedNode := -1;                             //none is focused

  FModel.AddRelation(Self);                       //add the pointer to list
end;
//=============================================================================

destructor TRelation.Destroy;
var
  i: integer;
begin
  if BFrame <> nil then
    BFrame.DeleteRelation(Self);                  //this only removes the pointer to this relation
  if (AFrame <> nil) and (AFrame <> BFrame) then  //do not delete if the FK points to the same table because it was not added in  RefreshRelations or AddRelations
    AFrame.DeleteRelation(Self);                  //this only removes the pointer to this relation
  FModel.DeleteRelation(Self);                    //this only removes the pointer to this relation

  DeleteObject(Rgn);

  for i := 0 to RgnList.Count - 1 do
    DeleteObject(HRGN(RgnList[i]));
  RgnList.Free;

  for i := 0 to NodeList.Count - 1 do
    Dispose(PPoint(NodeList[i]));
  NodeList.Free;

  for i := 0 to OrigNodeList.Count - 1 do
    Dispose(PPoint(OrigNodeList[i]));             //??
  OrigNodeList.Free;

  inherited;
end;
//=============================================================================

procedure TRelation.Paint;
const
  bDrawEdges = false;                             //auxiliary debugging const, when true then lines are drawn by the region edges
var
  arr: array[0..2] of TPoint;
  ex, ey, i: integer;
  ArrCnt {, PolyCount}: integer;
  PRgn: PHRGN;
  NodeRgn: HRGN;
  R: integer;                                          //not null circle radius = 4
  RelPointerHalfHeight: integer;

  procedure DrawRegion(aArr: array of TPoint);
  var
    os: TBrushStyle;
  begin
    with FModel.Canvas do
    begin
      Pen.Color := clRed;
      os := Brush.Style;
      Brush.Style := bsClear;
      Polygon(RgnArr);
      Brush.Style := os;
    end;
  end;

begin
  R := Round (FModel.CurrentScale * 3 / 100) + 1;
  RelPointerHalfHeight := Round(FModel.RelPointer div 5) + 1;
  with FModel.Canvas do
  begin
    if FFocused then
      Pen.Color := FModel.LinkColorFocused
    else if FSelected then
      Pen.Color := FModel.LinkColorSelected//StringToColor('$000000DD')
    else if IsCustomRelation then
      Pen.Color := FModel.LinkColorCustom
    else
      Pen.Color := FModel.LinkColorDefault;


    //draw horizontal line
    if AToLeft then
    begin
      ex := FAPos.X - TModel(FModel).RelPointer + RelPointerHalfHeight;
      ey := FAPos.Y;
      MoveTo(FAPos.X - TModel(FModel).RelPointer, FAPos.Y);
      LineTo(FAPos.X, FAPos.Y);
    end
    else
    begin
      ex := FAPos.X + TModel(FModel).RelPointer - RelPointerHalfHeight;
      ey := FAPos.Y;
      MoveTo(FAPos.X + TModel(FModel).RelPointer, FAPos.Y);
      LineTo(FAPos.X, FAPos.Y);
    end;

    //draw circle
    if NotNull then
      Brush.Color := clBlack
    else
      Brush.Color := clWhite;
    Ellipse(ex - R, ey - R, ex + R, ey + R);

    for i := 0 to NodeList.Count - 1 do
      LineTo(PPoint(NodeList[i])^.X, PPoint(NodeList[i])^.Y);

    //connect to table B
    LineTo(FBPos.X, FBPos.Y);

    Brush.Color := clBlack;
    //draw arrow
    if BToLeft then
    begin
      arr[0] := Point(FBPos.X - TModel(FModel).RelPointer, FBPos.Y);
      arr[1] := Point(FBPos.X, FBPos.Y - RelPointerHalfHeight);
      arr[2] := Point(FBPos.X, FBPos.Y + RelPointerHalfHeight);
    end
    else
    begin
      arr[0] := Point(FBPos.X + TModel(FModel).RelPointer, FBPos.Y);
      arr[1] := Point(FBPos.X, FBPos.Y - RelPointerHalfHeight);
      arr[2] := Point(FBPos.X, FBPos.Y + RelPointerHalfHeight);
    end;
    Polygon(arr);
  end;

  if NodeList.Count = 0 then                      //simple rectangle region
  begin
    DeleteObject(Rgn);
    GetRegionArray(FAPos, FBPos, RgnArr);
    ArrCnt := 4;
    Rgn := CreatePolygonRgn(RgnArr, ArrCnt, ALTERNATE);
  end
  else                                            //NodeList.Count > 0
  begin
    DeleteObject(Rgn);
    //delete old regions for every abscissa
    for i := 0 to RgnList.Count - 1 do
    begin
      DeleteObject(HRGN(RgnList[i]^));
      Dispose(RgnList[i]);
    end;
    RgnList.Clear;

    GetRegionArray(FAPos, PPoint(NodeList[0])^, RgnArr); //first abscissa
    if bDrawEdges then
      DrawRegion(RgnArr);
    New(PRgn);
    PRgn^ := CreatePolygonRgn(RgnArr, 4, ALTERNATE);
    RgnList.Add(PRgn);

    for i := 0 to NodeList.Count - 2 do
    begin
      GetRegionArray(PPoint(NodeList[i])^, PPoint(NodeList[i + 1])^, RgnArr); //middle abscisses
      if bDrawEdges then
        DrawRegion(RgnArr);
      New(PRgn);
      PRgn^ := CreatePolygonRgn(RgnArr, 4, ALTERNATE);
      RgnList.Add(PRgn);
    end;

    GetRegionArray(PPoint(NodeList[NodeList.Count - 1])^, FBPos, RgnArr); //last abscissa
    if bDrawEdges then
      DrawRegion(RgnArr);
    New(PRgn);
    PRgn^ := CreatePolygonRgn(RgnArr, 4, ALTERNATE);
    RgnList.Add(PRgn);

    Rgn := CreateRectRgn(0, 0, 0, 0);
    for i := 0 to RgnList.Count - 1 do
      CombineRgn(Rgn, Rgn, HRGN(RgnList[i]^), RGN_OR);

    for i := 0 to NodeList.Count - 1 do
    begin                                         //the points regions to make the turn points rounded
      NodeRgn := CreateEllipticRgnIndirect(NodeRect(i));
      CombineRgn(Rgn, Rgn, NodeRgn, RGN_OR);
      DeleteObject(NodeRgn);
      if bDrawEdges then
        FModel.Canvas.Ellipse(NodeRect(i));
    end;
  end;
end;
//=============================================================================

function TRelation.NodeRect(n: integer): TRect;
const
  d = 8;
var
  aX, aY: integer;
begin
  aX := PPoint(NodeList[n])^.X;
  aY := PPoint(NodeList[n])^.Y;
  Result.TopLeft := Point(aX - d, aY - d);
  Result.BottomRight := Point(aX + d, aY + d);
end;
//============================================================================

function TRelation.GetRect: TRect;
var
  i, l, t, b, r: integer;
  N: TPoint;
begin
  l := FModel.Width;
  t := FModel.Height;
  b := 0;
  r := 0;
  for i := 0 to NodeList.Count - 1 do
  begin
    N := PPoint(NodeList[i])^;
    l := min(l, N.X);
    t := min(t, N.Y);
    b := max(b, N.Y);
    r := max(r, N.X);
  end;
  l := min(l, APos.X);
  t := min(t, APos.Y);
  b := max(b, APos.Y);
  r := max(r, APos.X);

  l := min(l, BPos.X);
  t := min(t, BPos.Y);
  b := max(b, BPos.Y);
  r := max(r, BPos.X);

  l := l - max(AFrame.Width, BFrame.Width);
  r := r + max(AFrame.Width, BFrame.Width);

  Result := Rect(l, t, r, b);
  InflateRect(Result, 20, 20);
end;
//============================================================================

procedure TRelation.Click(X, Y: integer);
//var
//  pnt: TPoint;
begin
  //  MessageDlg('Click', mtInformation, [mbOK], 0);
  //  pnt.X:=X;
  //  pnt.Y:=Y;
  //  pnt:=ClientToScreen(pnt);
  //  PopMenu.Popup(pnt.X,pnt.Y);
end;
//============================================================================

procedure TRelation.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  Focused := true;
end;
//============================================================================

procedure TRelation.MouseMove(Shift: TShiftState; X, Y: integer);
var
  i, l, t: integer;
  R: TRect;
  P: PPoint;
  bInserted: boolean;
begin
  FModel.ModelForm.scbModel.Hint := DBName;
  //Application.ActivateHint(Mouse.CursorPos);
  Application.ActivateHint(Point(Mouse.CursorPos.X + 20, Mouse.CursorPos.Y));

  if FModel.bDown then
  begin
    if (FFocusedNode = -1) then                   //node is not selected, is Down
    begin
      if (FModel.bx <> X) or (FModel.by <> Y) then //was moved - create node
      begin
        FModel.Modified := true;
        FModel.Cursor := crCross;
        FModel.bDraggingNode := true;
        New(P);
        P^.X := X;
        P^.Y := Y;
        bInserted := false;
        for i := 0 to RgnList.Count - 1 do
        begin
          if PtInRegion(HRGN(RgnList[i]^), X, Y) then
          begin
            NodeList.Insert(i, P);
            FFocusedNode := i;
            bInserted := true;
            Break;
          end;
        end;
        if not bInserted then
          FFocusedNode := NodeList.Add(P);
        FModel.FSelectedNodes.Add(P);
      end;
    end
    else                                          //some node is focused
    begin
      FModel.Cursor := crCross;
      //TempCursor := crCross;
      if (FModel.bx <> X) or (FModel.by <> Y) then //was moved - move the node
      begin
        FModel.Modified := true;
        FModel.bDraggingNode := true;
        l := X;
        t := Y;
        if FModel.SnapRelToGrid then
        begin
          l := Round((l div FModel.GridX) * FModel.GridX);
          t := Round((t div FModel.GridY) * FModel.GridY);
        end;
        PPoint(NodeList[FFocusedNode])^.X := l;
        PPoint(NodeList[FFocusedNode])^.Y := t;
        SetPosition;
        //FModel.Invalidate;
        R := GetRect;
        InflateRect(R, 50, 50);
        InvalidateRect(FModel.Handle, @R, true);
      end;
    end;
  end
  else                                            //not bDown
  begin
    //FModel.Cursor := crHandPoint;
    TempCursor := crHandPoint;
//    Application.Hint := Self.DBName;
//    Application.ActivateHint(Mouse.CursorPos);
    FFocusedNode := -1;
    for i := 0 to NodeList.Count - 1 do
    begin
      if PtInRect(NodeRect(i), Point(X, Y)) then
      begin
        FFocusedNode := i;
        Break;
      end;
    end;
  end;
end;
//============================================================================

procedure TRelation.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  if Button = mbRight then
  begin
//    if FFocusedNode <> -1 then
//      FModel.ModelForm.popNode.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y)
//    else                                          //no node is focused
      FModel.ModelForm.popRelation.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
  end
  else                                            //mbLeft ...
  begin
    SaveCoordToOrig;
    FModel.bDraggingNode := false;
  end;
  FModel.Invalidate;
end;
//============================================================================

procedure TRelation.SetAPos(pt: TPoint);
begin
  FAPos := pt;
end;
//=============================================================================

procedure TRelation.SetBPos(pt: TPoint);
begin
  FBPos := pt;
end;
//=============================================================================

procedure TRelation.SetPosition;
var
  ANode, BNode: TPoint;
begin
  if NodeList.Count = 0 then
  begin
    if AFrame.Left < BFrame.Left then
    begin
      APos := AFrame.GetRightJoin(ForeignKey);
      AToLeft := true;
      if (AFrame.Left + AFrame.Width + TModel(FModel).RelPointer) < BFrame.Left then
      begin
        BPos := BFrame.GetLeftJoin(PrimaryKey);
        BToLeft := false;
      end
      else
      begin
        BPos := BFrame.GetRightJoin(PrimaryKey);
        BToLeft := true;
      end;
    end
    else
    begin
      BPos := BFrame.GetRightJoin(PrimaryKey);
      BToLeft := true;
      if (BFrame.Left + BFrame.Width + TModel(FModel).RelPointer) < AFrame.Left then
      begin
        APos := AFrame.GetLeftJoin(ForeignKey);
        AToLeft := false;
      end
      else
      begin
        APos := AFrame.GetRightJoin(ForeignKey);
        AToLeft := true;
      end;
    end;
  end
  else                                            //NodeList.Count > 0
  begin
    ANode := PPoint(NodeList[0])^;                //first node
    BNode := PPoint(NodeList[NodeList.Count - 1])^; //last node
    if ANode.X > AFrame.Left + (AFrame.Width div 2) then
    begin
      APos := AFrame.GetRightJoin(ForeignKey);
      AToLeft := true;
    end
    else
    begin
      APos := AFrame.GetLeftJoin(ForeignKey);
      AToLeft := false;
    end;
    if BNode.X > BFrame.Left + (BFrame.Width div 2) then
    begin
      BPos := BFrame.GetRightJoin(PrimaryKey);
      BToLeft := true;
    end
    else
    begin
      BPos := BFrame.GetLeftJoin(PrimaryKey);
      BToLeft := false;
    end;
  end;
end;
//=============================================================================

procedure TRelation.SetSelected(Value: boolean);
begin
  FSelected := Value;
end;
//============================================================================

procedure TRelation.SetFocused(const Value: boolean);
begin
  FFocused := Value;
end;
//============================================================================

procedure TRelation.ChangeScale(M, D: integer);
var
  i: integer;
begin
  for i := 0 to NodeList.Count - 1 do
  begin
    PPoint(NodeList[i])^.X := MulDiv(PPoint(NodeList[i])^.X, M, D);
    PPoint(NodeList[i])^.Y := MulDiv(PPoint(NodeList[i])^.Y, M, D);
  end;
  SaveCoordToOrig;
end;
//============================================================================

procedure TRelation.DeleteNode(i: integer);
begin
  if (i <> -1) and (i < NodeList.Count) then
  begin
    //if the node is selected, delete it from the list of selected nodes
    if FModel.FSelectedNodes.IndexOf(NodeList[i]) >= 0 then
      FModel.FSelectedNodes.Delete(FModel.FSelectedNodes.IndexOf(NodeList[i]));
    //free TPoint
    Dispose(PPoint(NodeList[i]));
    Dispose(PPoint(OrigNodeList[i]));
    //delete pointers to TPoint
    NodeList.Delete(i);
    OrigNodeList.Delete(i);
  end;
end;
//============================================================================

procedure TRelation.SaveCoordToOrig;
var
  i: integer;
  P: PPoint;
begin
  for i := 0 to OrigNodeList.Count - 1 do         //delete old nodes
    Dispose(PPoint(OrigNodeList[i]));
  OrigNodeList.Clear;

  for i := 0 to NodeList.Count - 1 do
  begin                                           //save new nodes
    New(P);
    P^.X := Round(PPoint(NodeList[i])^.X / (FModel.CurrentScale / 100));
    P^.Y := Round(PPoint(NodeList[i])^.Y / (FModel.CurrentScale / 100));
    OrigNodeList.Add(P);
  end;
end;
//=============================================================================

procedure TRelation.LoadCoordFromOrig;
var
  i: integer;
begin
  for i := 0 to OrigNodeList.Count - 1 do
  begin
    PPoint(NodeList[i])^.X := PPoint(OrigNodeList[i])^.X;
    PPoint(NodeList[i])^.Y := PPoint(OrigNodeList[i])^.Y;
  end;
end;
//=============================================================================


procedure TRelation.LoadNodesFromIni(Ini: TIniFile);
var
  j, k: integer;
  sNodeList: TStringList;
  P: PPoint;
  Nodes: string;
begin
//  if Name[2] = '$' then //custom relation
//    rel := RelationByName(Copy(RelName, 3, Length(RelName)))  //without the $$ prefix
//  else
//    rel := RelationByName(Copy(RelName, 2, Length(RelName))); //without the $ char
//  if rel <> nil then
//  begin
    Nodes := Ini.ReadString(Name, 'Nodes', '');
    if Nodes <> '' then
    begin
      sNodeList := TStringList.Create;
      try
        sNodeList.Delimiter := ';';
        sNodeList.DelimitedText := Nodes;   //parse the semicolon separated list of coordinates
        for j := 0 to sNodeList.Count - 1 do
        begin
          k := Pos(',', sNodeList[j]);
          New(P);                           //new Point
          P^.X := StrToIntDef(Copy(sNodeList[j], 1, k - 1), 0);
          P^.Y := StrToIntDef(Copy(sNodeList[j], k + 1, 10), 0);
          NodeList.Add(P);
        end;
        SaveCoordToOrig;
      finally
        sNodeList.Free;
      end;
    end;
//  end;
end;

{TModel}

procedure TModel.MyMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i, j: integer;
  rel: TRelation;
begin
  bDown := true;
  bx := X;
  by := Y;
  mx := X;
  my := Y;

  if Assigned(FFocusedRelation) then
  begin
    FFocusedRelation.Focused := false;
    FFocusedRelation := nil;
  end;

  FSelectedNodes.Clear;

  for i := 0 to FRelations.Count - 1 do
  begin
    rel := TRelation(FRelations[i]);
    if PtInRegion(rel.Rgn, X, Y) then
    begin
      rel.MouseDown(Button, Shift, X, Y);
      FFocusedRelation := rel;
      for j := 0 to rel.NodeList.Count - 1 do
        FSelectedNodes.Add(rel.NodeList[j]);
      Break;
    end;
  end;

  if not bDraggingNode then
    DrawRectangle(bx, by, mx - bx, my - by);
end;
//=============================================================================

procedure TModel.MyMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  i, j: integer;
  rel: TRelation;
  bWasCursorSet, bWasRelMouseMove: boolean;
begin
  bWasCursorSet := false;
  bWasRelMouseMove := false;
  if Assigned(FFocusedRelation) then
  begin
    if bDown or PtInRegion(FFocusedRelation.Rgn, X, Y) then   //kdyz je bDown - posunuje se Node, musi se delat MouseMove vzdycky, jinak pouze kdyz je Mouse v regionu Relation
    begin
      FFocusedRelation.MouseMove(Shift, X, Y);
      bWasRelMouseMove := true;
    end;
  end
  else if bDown then
  begin
    if not bDraggingNode then
    begin
      DrawRectangle(bx, by, mx - bx, my - by);
      DrawRectangle(bx, by, X - bx, Y - by);
      mx := X;
      my := Y;
    end
    else if bDraggingNode then
    begin
      bDraggingNode := false;
      Invalidate;
    end;
  end;

  if not bDown then
  begin                                           //set Relation Cursor to crHandPoint
    for i := 0 to FRelations.Count - 1 do
    begin
      rel := TRelation(FRelations[i]);
      rel.FFocusedNode := -1;
      if PtInRegion(rel.Rgn, X, Y) then
      begin
        if rel <> FFocusedRelation then  //protože FFocusedRelation.MouseMove už bylo na zaèátku viz. výše
        begin
          rel.MouseMove(Shift, X, Y);
          bWasRelMouseMove := true;
        end;
        for j := 0 to rel.NodeList.Count - 1 do
        begin
          if PtInRect(rel.NodeRect(j), Point(X, Y)) then
          begin
            rel.FFocusedNode := j;
            TempCursor := crCross;
            bWasCursorSet := true;
            Break;
          end;
        end;
        if not bWasCursorSet then
        begin
          TempCursor := crHandPoint;
          bWasCursorSet := true;
        end;
        Break;
      end;
    end;
    //todo2 zakomentovano, aby se neztratil focus na Note.Memo
    //Self.SetFocus;
  end;

  if not bWasRelMouseMove then
  begin
    ModelForm.scbModel.Hint := '';
    Application.ActivateHint(Mouse.CursorPos);
  end;
  
  if not bWasCursorSet then
    TempCursor := crDefault;
  Self.Cursor := TempCursor;
end;
//=============================================================================

procedure TModel.MyMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Region: HRGN;
  i, j, w, h: integer;
  R: TRect;
  tbl: TfraMain;
  rel: TRelation;
begin
  if bDown then
  begin
    bDown := false;
    if not bDraggingNode then
    begin
      DrawRectangle(bx, by, mx - bx, my - by);
      Region := CreateRectRgn(bx, by, mx, my);
      for i := 0 to FFrames.Count - 1 do
      begin
        tbl := Frames[i];
        R := tbl.ClientRect;
        w := R.Right - R.Left;
        h := R.Bottom - R.Top;
        R.TopLeft := tbl.ClientToParent(R.TopLeft);
        R.Top := R.Top + ModelForm.scbModel.VertScrollBar.Position;
        R.Left := R.Left + ModelForm.scbModel.HorzScrollBar.Position;
        R.Bottom := R.Top + h;
        R.Right := R.Left + w;
        if RectInRegion(Region, R) then
        begin
          tbl.Selected := true;
          AddSelectedFrame(tbl, true);
          tbl.Paint;
        end;
      end;

      if (bx <> mx) or (by <> my) then            //selection was made
      begin
        FSelectedNodes.Clear;
        for i := 0 to FRelations.Count - 1 do
        begin
          rel := TRelation(FRelations[i]);
          for j := 0 to rel.NodeList.Count - 1 do
          begin
            if PtInRegion(Region, PPoint(rel.NodeList[j])^.X, PPoint(rel.NodeList[j])^.Y) then
              FSelectedNodes.Add(rel.NodeList[j]);
          end;
        end;
      end;

      DeleteObject(Region);
      Invalidate;
    end;
  end;
  if Assigned(FFocusedRelation) then
    FFocusedRelation.MouseUp(Button, Shift, X, Y)
  else if Button = mbRight then
    ModelForm.popModel.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;
//=============================================================================

procedure TModel.AddFrame(AFrame: TfraMain);
begin
  AFrame.SaveCoordToOrig; //todo2 je to tady nutne, vola se to jiz v konstruktoru AFrame
  Inc(nFrameCounter);
  AFrame.Name := 'fraMain' + IntToStr(nFrameCounter);
  AFrame.Tag := nFrameCounter;
  FFrames.Add(AFrame);
  AFrame.Refresh;
  AFrame.AddRelations;

  if AFrame is TfraTable then
    TfraTable(AFrame).InitializeHeader;
      
  AFrame.ChangeScale(CurrentScale, 100);
  //todo2 toto je slabe misto
  if AFrame is TfraTable then
    with AFrame as TfraTable do
    begin
      mniColor.Action := ModelForm.actModelTableColor;
      mniDeleteTable.Action := ModelForm.actModelDeleteTable;
      CurrentHeaderSection := 0;
      SetHeaderSectionSize(0);
      RecreateHeaderSections;
      lbFields.RefreshFields;
      //Arrange;
    end
  else
  if AFrame is TfraNote then
    with AFrame as TfraNote do
    begin
      mniColor.Action := ModelForm.actModelTableColor;
      mniDeleteTable.Action := ModelForm.actModelDeleteTable;
    end;
  Modified := true;
  Invalidate;
  ResizeModel;
end;
//=============================================================================

function TModel.AddFrame(sFrameName: string): TfraMain;    //deprecated
var
  fra: TfraMain;
begin
  raise Exception.Create('dbg: pouzij druhou metodu AddFrame');
  fra := TfraMain.CreateByName(Self, sFrameName);
  AddFrame(fra);
  fra.SaveCoordToOrig;
  Result := fra;
end;
//=============================================================================

procedure TModel.AddRelation(ARelation: TRelation);
begin
  {only pointer is added, this is different from AddFrame}
  FRelations.Add(ARelation);
end;
//=============================================================================

constructor TModel.Create(AOwner: TComponent);
begin
  inherited;
  Parent := TWinControl(AOwner);
  ModelForm := TfmModel(TScrollBox(AOwner).Parent);
  LinkColorDefault := clBlack;
  LinkColorSelected := clRed;
  LinkColorFocused := clBlue;
  LinkColorCustom := clGreen;
  Visible := true;
  FFrames := TList.Create;
  FRelations := TList.Create;
  FSelectedFrames := TList.Create;
  FSelectedNodes := TList.Create;
  Color := clSilver;
  Filename := 'Untitled';
  Modified := false;
  DefaultShowOptions := [soName, soType, soDomain, soComputedBy, soRequired, soIcons, soIndexCount];
  OnClick := MyClick;
  OnMouseDown := MyMouseDown;
  OnMouseMove := MyMouseMove;
  OnMouseUp := MyMouseUp;
  ModelScreenDC := GetDC(0);
  bDown := false;
  CurrentScale := 100;
  RelPointer := 15;
  DefColCount := 1;
  SnapToGrid := true;
  SnapRelToGrid := true;
  ShowGrid := false;
  GridX := 8;
  GridY := 8;
  //nNoteCounter := 0;
end;
//=============================================================================

procedure TModel.DeleteRelation(ARelation: TRelation);
var
  i: integer;
begin
  i := FRelations.IndexOf(ARelation);
  if i >= 0 then                                  //TODO2  check destroying of the relations 
    FRelations.Delete(i);
end;
//=============================================================================

procedure TModel.DeleteFrame(AFrame: TfraMain);
begin
  if AFrame.Selected then
    FSelectedFrames.Delete(FSelectedFrames.IndexOf(AFrame));
  FFrames.Delete(FFrames.IndexOf(AFrame));        //delete from the Model Frames list
end;
//=============================================================================

destructor TModel.Destroy;
begin
  inherited;
  FileClose(FileHandle);
  FFrames.Free;
  FRelations.Free;
  FSelectedFrames.Free;
  FSelectedNodes.Free;
  ReleaseDC(0, ModelScreenDC);
end;
//=============================================================================

function TModel.GetRelation(i: integer): TRelation;
begin
  Result := TRelation(FRelations[i]);
end;
//=============================================================================

function TModel.GetRelationCount: integer;
begin
  Result := FRelations.Count;
end;
//=============================================================================

function TModel.GetFrame(i: integer): TfraMain;
begin
  Result := TfraMain(FFrames[i]);
end;
//=============================================================================

function TModel.GetFrameCount: integer;
begin
  Result := FFrames.Count;
end;
//=============================================================================

procedure TModel.Paint;
const
  d = 4;
var
  i, j, k, l: integer;
  N: TPoint;
begin
  //inherited;
  with Canvas do
  begin
    Brush.Color := Color;
    FillRect(GetClientRect);
    Brush.Style := bsClear;

    if ShowGrid then//paint the grid
    begin
      k := Height div GridX;
      l := Width div GridY;
      for i := 1 to k do
        for j := 1 to l do
          Pixels[j * GridY, i * GridX] := clBlack;
      Pen.Style := psSolid;
    end;
    Pen.Color := clBlack;
  end;


  for i := 0 to FFrames.Count - 1 do
    Frames[i].Paint;

  for i := 0 to RelationCount - 1 do
    Relations[i].Paint;

  for i := 0 to FSelectedNodes.Count - 1 do
  begin
    N := PPoint(FSelectedNodes[i])^;
    Canvas.Rectangle(N.X - d, N.Y - d, N.X + d, N.Y + d);
  end;
end;
//=============================================================================

function TModel.FrameByName(sFrameName: string): TfraMain;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FrameCount - 1 do
  begin
    if Frames[i].FrameName = sFrameName then
    begin
      Result := Frames[i];
      Exit;
    end;
  end;
end;
//=============================================================================

function TModel.FrameByTag(nTag: integer): TfraMain;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to FrameCount - 1 do
  begin
    if Frames[i].Tag = nTag then
    begin
      Result := Frames[i];
      Exit;
    end;
  end;
end;
//=============================================================================

procedure TModel.ResizeModel;
var
  i, x, y: integer;
  tbl: TfraMain;
begin
  x := Parent.ClientWidth;
  y := Parent.ClientHeight;
  for i := 0 to FrameCount - 1 do
  begin
    tbl := Frames[i];
    x := max(x, tbl.Left + tbl.Width);
    y := max(y, tbl.Top + tbl.Height);
  end;
  Width := x + 40;
  Height := y + 40;
  TScrollBox(Owner).HorzScrollBar.Visible := x > TScrollBox(Owner).ClientWidth;
  TScrollBox(Owner).VertScrollBar.Visible := y > TScrollBox(Owner).ClientHeight;
end;
//=============================================================================

function TModel.ListOfTables: string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to FFrames.Count - 1 do
  begin
    if Length(Result) > 0 then
      Result := Result + ',';
    Result := Result + #39 + Frames[i].FrameName + #39;
  end;
  if Result = '' then
    Result := '''''';
end;
//=============================================================================

procedure TModel.Refresh;
var
  i: integer;
  tbl: TfraMain;
begin
  if FFrames.Count = 0 then
    Exit;

  Screen.Cursor := crHourGlass;
  try
    fmProgress := TfmProgress.Create(Application);
    fmProgress.Progress.Max := FFrames.Count - 1;
    fmProgress.Show;
    for i := 0 to FFrames.Count - 1 do
    begin
      tbl := Frames[i];
      fmProgress.lbl.Caption := Format(sTableRefresh + ' %d. %s', [i + 1, tbl.FrameName]);
      fmProgress.Progress.StepIt;
      //fmMain.StatusBar.Panels[0].Text := sTableRefresh + tbl.TableName;
      tbl.Refresh;
      tbl.RefreshRelations;
    end;
    Invalidate;
  finally
    fmMain.StatusBar.Panels[0].Text := '';
    Screen.Cursor := crDefault;
    fmProgress.Free;
    fmProgress := nil;
    ModelForm.CheckConnected;
  end;
end;
//=============================================================================

procedure TModel.Save;
var
  i, j: integer;
  tbl: TfraMain;
  tblFilename, bakFilename, RelName, Nodes: string;
  MainF: TfmMain;
  rel: TRelation;
  Ini: TIniFile;
begin
  if ReadOnly then
    MessageDlg('Model is Read Only. Try SaveAs.', mtError, [mbOK], 0)
  else
  begin
    FileClose(FileHandle);
    with TIniFile.Create(Filename) do
    begin
      WriteString('Model', 'Color', ColorToString(Color));
      WriteString('Model', 'Database', ModelForm.cnModel.Database);
      WriteString('Model', 'Username', Self.Username);
      WriteString('Model', 'Password', JumbleString(Self.Password, 'IBUtilsIBUtils'));
      WriteInteger('Model', 'CurrentScale', CurrentScale);
      WriteString('Model', 'Title', Title);
      WriteString('Model', 'LinkColorDefault', ColorToString(LinkColorDefault));
      WriteString('Model', 'LinkColorSelected', ColorToString(LinkColorSelected));
      WriteString('Model', 'LinkColorFocused', ColorToString(LinkColorFocused));
      WriteString('Model', 'LinkColorCustom', ColorToString(LinkColorCustom));
      WriteString('Model', 'AddTablesFilter', StringReplace(AddTablesFilter, #13#10, ' ', [rfReplaceAll]));
      WriteBool('Model', 'SnapToGrid', SnapToGrid);
      WriteBool('Model', 'SnapRelToGrid', SnapRelToGrid);
      WriteBool('Model', 'ShowGrid', ShowGrid);
      WriteInteger('Model', 'GridX', GridX);
      WriteInteger('Model', 'GridY', GridY);
      WriteBool('Model', 'ShowSystemDomains', ShowSystemDomains);
      WriteBool('Model', 'CombinedTypeDomain', CombinedTypeDomain);

      WriteBool('DefaultShowOptions', 'soType', soType in DefaultShowOptions);
      WriteBool('DefaultShowOptions', 'soDomain', soDomain in DefaultShowOptions);
      WriteBool('DefaultShowOptions', 'soComputedBy', soComputedBy in DefaultShowOptions);
      WriteBool('DefaultShowOptions', 'soIndexCount', soIndexCount in DefaultShowOptions);
      WriteBool('DefaultShowOptions', 'soRequired', soRequired in DefaultShowOptions);
      WriteBool('DefaultShowOptions', 'soIcons', soIcons in DefaultShowOptions);
      WriteBool('DefaultShowOptions', 'soKeysOnly', soKeysOnly in DefaultShowOptions);
      WriteBool('DefaultShowOptions', 'soHeader', soHeader in DefaultShowOptions);
      WriteInteger('DefaultShowOptions', 'DefColCount', DefColCount);
      Free;
    end;

    tblFilename := ChangeFileExt(Filename, '.tbl');
    bakFilename := ChangeFileExt(tblFilename, '.old');
    if FileExists(tblFilename) then
    begin                                         //make backup of current file
      DeleteFile(bakFilename);
      RenameFile(tblFilename, bakFilename);
    end;
    try
      Ini := TIniFile.Create(tblFilename);
      with Ini do
      begin
        for i := 0 to FFrames.Count - 1 do
        begin
          tbl := Frames[i];
          tbl.SaveToIniFile(Ini);
        end;

        for i := 0 to FRelations.Count - 1 do
        begin
          rel := TRelation(FRelations[i]);
          RelName :=  rel.Name;
          EraseSection(RelName);
          Nodes := '';
          for j := 0 to rel.NodeList.Count - 1 do
          begin                                   //semicolon separated list of coordinates
            if Nodes <> '' then
              Nodes := Nodes + ';';
            Nodes := Nodes + Format('%d,%d', [PPoint(rel.OrigNodeList[j])^.X, PPoint(rel.OrigNodeList[j])^.Y]);
          end;
          if Nodes <> '' then
            WriteString(RelName, 'Nodes', Nodes);

          if rel.IsCustomRelation then
          begin
            WriteString(RelName, 'AFrame', rel.AFrame.FrameName);
            WriteString(RelName, 'BFrame', rel.BFrame.FrameName);
            WriteString(RelName, 'AField', rel.ForeignKey);
            WriteString(RelName, 'BField', rel.PrimaryKey);
          end;
        end;

        Free;
      end;
    except
      if FileExists(bakFilename) then
        RenameFile(bakFilename, tblFilename);
      raise;
    end;
    Modified := false;
    FileHandle := FileOpen(Filename, fmOpenReadWrite);

    MainF := TfmMain(Application.MainForm);
    if MainF.MRUModel.Strings.IndexOf(Filename) = -1 then
      MainF.MRUModel.Add(Filename, 0);
  end;
end;
//=============================================================================

procedure TModel.SaveAs;
var
  SDlg: TSaveDialog;
begin
  SDlg := TSaveDialog.Create(Application);
  SDlg.Title := 'Save model';
  SDlg.Filter := 'Model|*.mdl';
  SDlg.DefaultExt := 'mdl';
  SDlg.Options := SDlg.Options + [ofOverwritePrompt];
  try
    if SDlg.Execute then
    begin
      if FileExists(SDlg.Filename) then
      begin
        FileClose(FileHandle);
        FileHandle := FileOpen(SDlg.Filename, fmOpenReadWrite);
        if FileHandle < 0 then
        begin
          ReadOnly := true;
          MessageDlg('File ' + SDlg.Filename + ' is not accesible for writing.', mtWarning, [mbOK], 0);
        end
        else
          ReadOnly := false;
      end
      else
        ReadOnly := false;
      Self.Filename := SDlg.Filename;
      Save;
    end;
  finally
    SDlg.Free;
  end;
end;
//=============================================================================

procedure TModel.Open(sFilename: string; AUserName: string = ''; APassword: string = '');
var
  i, tmpCurrentScale: integer;
  db: string;
  slDatabases: TStringList;
begin
  Screen.Cursor := crHourGlass;
  try
    Visible := false;
    fmMain.StatusBar.Panels[0].Text := sLoading;
    with TIniFile.Create(sFileName) do
    begin
      Color := StringToColor(ReadString('Model', 'Color', 'clSilver'));
      ModelForm.cnModel.Database := ReadString('Model', 'Database', '');
      ModelForm.cnModel.DatabaseName := ModelForm.cnModel.Database;
      Self.Password := UnJumbleString( ReadString('Model', 'Password', ''), 'IBUtilsIBUtils');
      Self.Username := ReadString('Model', 'Username', '');
      if (AUserName = '') then
        AUserName := Self.UserName;
      if (APassword = '') then
        APassword := Self.Password;
      ModelForm.cnModel.Username := 'SYSDBA';

      //najdi nazev souboru metadata log a jmeno uzivatele pro danou databazi
      slDatabases := TStringList.Create;
      with TIniFile.Create(ExtractFilePath(Application.ExeName) + 'ibutils.ini') do
      begin
        ReadSection('Databases', slDatabases);
        for i := 0 to slDatabases.Count-1 do
        begin
          db := ReadString('Databases', 'I' + IntToStr(i), '');
          if UpperCase(db) = UpperCase(ModelForm.cnModel.Database) then
          begin
            if ReadString('MetadataLogs', 'I' + IntToStr(i), '') <> '' then
              ModelForm.cnModel.FieldsCharCase.Add(ReadString('MetadataLogs', 'I' + IntToStr(i), ''));
            if ReadString('Users', 'I' + IntToStr(i), '') <> '' then
              ModelForm.cnModel.Username := ReadString('Users', 'I' + IntToStr(i), '');
          end;
        end;
        Free;
      end;
      slDatabases.Free;

      tmpCurrentScale := ReadInteger('Model', 'CurrentScale', 100);
      Title := ReadString('Model', 'Title', '');
      AddTablesFilter := ReadString('Model', 'AddTablesFilter', '');
      LinkColorDefault := StringToColor(ReadString('Model', 'LinkColorDefault', 'clBlack'));
      LinkColorSelected := StringToColor(ReadString('Model', 'LinkColorSelected', 'clRed'));
      LinkColorFocused := StringToColor(ReadString('Model', 'LinkColorFocused', 'clBlue'));
      LinkColorCustom := StringToColor(ReadString('Model', 'LinkColorCustom', 'clGreen'));
      SnapToGrid := ReadBool('Model', 'SnapToGrid', true);
      SnapRelToGrid := ReadBool('Model', 'SnapRelToGrid', true);
      ShowGrid := ReadBool('Model', 'ShowGrid', false);
      GridX := ReadInteger('Model', 'GridX', 8);
      GridY := ReadInteger('Model', 'GridY', 8);
      ModelForm.actSnapToGrid.Checked := SnapToGrid;
      ModelForm.actSnapRelToGrid.Checked := SnapRelToGrid;
      ModelForm.actShowGrid.Checked := ShowGrid;
      ShowSystemDomains := ReadBool('Model', 'ShowSystemDomains', false);
      CombinedTypeDomain := ReadBool('Model', 'CombinedTypeDomain', false);

      DefaultShowOptions := [soName];
      if ReadBool('DefaultShowOptions', 'soType', true) then
        DefaultShowOptions := DefaultShowOptions + [soType];
      if ReadBool('DefaultShowOptions', 'soDomain', true) then
        DefaultShowOptions := DefaultShowOptions + [soDomain];
      if ReadBool('DefaultShowOptions', 'soComputedBy', true) then
        DefaultShowOptions := DefaultShowOptions + [soComputedBy];
      if ReadBool('DefaultShowOptions', 'soIndexCount', true) then
        DefaultShowOptions := DefaultShowOptions + [soIndexCount];
      if ReadBool('DefaultShowOptions', 'soRequired', true) then
        DefaultShowOptions := DefaultShowOptions + [soRequired];
      if ReadBool('DefaultShowOptions', 'soIcons', true) then
        DefaultShowOptions := DefaultShowOptions + [soIcons];
      if ReadBool('DefaultShowOptions', 'soKeysOnly', false) then
        DefaultShowOptions := DefaultShowOptions + [soKeysOnly];
      if ReadBool('DefaultShowOptions', 'soHeader', false) then
        DefaultShowOptions := DefaultShowOptions + [soHeader];
      DefColCount := ReadInteger('DefaultShowOptions', 'DefColCount', 1);
      Free;
    end;

    FileHandle := FileOpen(sFilename, fmOpenReadWrite);
    if FileHandle < 0 then
      ReadOnly := true
    else
      ReadOnly := false;
    Self.Filename := sFilename;

    if not ModelForm.cnModel.Connected then
    begin
      if (AUserName <> '') and (APassword <> '') then
      begin
        ModelForm.cnModel.UserName := AUserName;
        ModelForm.cnModel.Password := APassword;
        ModelForm.cnModel.LoginPrompt := false;
        ModelForm.cnModel.Connect;
      end
      else
      begin
        ModelForm.cnModel.LoginPrompt := true;
        ModelForm.cnModel.Connect;
      end;
    end;

    ImportTables(ChangeFileExt(Filename, '.tbl'), Point(0, 0));

  finally
    fmMain.StatusBar.Panels[0].Text := '';
    Visible := true;
    Scale(tmpCurrentScale);                       //calls Invalidate too
    Screen.Cursor := crDefault;
    Modified := false;
  end;
end;
//=============================================================================

procedure TModel.ImportTables(AFilename: string; APoint: TPoint; ASelect: boolean = false);
var
  Ini: TIniFile;
  tbl: TfraMain;
  slTables: TStringList;
  i: integer;
  AFrame, BFrame: TfraMain;
  rel: TRelation;
  RelName, sTableName: string;
begin
  Ini := TIniFile.Create(AFilename);
  slTables := TStringList.Create;
  Cursor := crHourGlass;
  if APoint.x = 0 then
    Visible := false;
  try
    with Ini do
    begin
      ReadSections(slTables);
      fmProgress := TfmProgress.Create(Application);
      if slTables.Count > 0 then
      begin
        fmProgress.Progress.Max := slTables.Count - 1;
        fmProgress.Show;
        for i := 0 to slTables.Count - 1 do
        begin
          sTableName := slTables[i];
          if sTableName[1] = '$' then               //names of TRelation begin with $ char
            Continue;
          if FrameByName(sTableName) <> nil then  //do not import table already in model
            Continue;
          if Copy(sTableName, 1, 3) = 'NT$' then             //names of notes begin with NT$
            tbl := TfraNote.CreateByName(Self, sTableName)
          else
            tbl := TfraTable.CreateByName(Self, sTableName);
          tbl.Visible := false;
          tbl.LoadFromIniFile(Ini);
          tbl.SetBounds(tbl.Left + APoint.X, tbl.Top + APoint.Y, tbl.Width, tbl.Height);
          AddFrame(tbl);
          if ASelect then
          begin
            AddSelectedFrame(tbl, true);
            tbl.Selected := true;
          end;
          //tbl := AddFrame(sTableName);
          fmProgress.lbl.Caption := Format(sLoadingTables + ' %d. Table %s', [i + 1, sTableName]);
          fmProgress.Progress.StepIt;
          //tbl.LoadFromIniFile(Ini);
          //tbl.Visible := true;
        end;

        fmProgress.Progress.Position := fmProgress.Progress.Min;
        fmProgress.Progress.Max := FFrames.Count-1;
        for i := 0 to FFrames.Count - 1 do
        begin
          fmProgress.lbl.Caption := Format(sLoadingRelations + ' %d. Table %s', [i + 1, Frames[i].FrameName]);
          fmProgress.Progress.StepIt;
          tbl := Frames[i];
          //tbl.Refresh;  //is this refreshed in the last run ??
          tbl.AddRelations;
        end;

        //custom relations
        for i := 0 to slTables.Count - 1 do
        begin
          RelName := slTables[i];
          if Copy(RelName, 1, 2) = '$$' then
          begin
            AFrame := FrameByName(ReadString(RelName, 'AFrame', ''));
            BFrame := FrameByName(ReadString(RelName, 'BFrame', ''));
            if Assigned(AFrame) and Assigned(BFrame) then
            begin
              rel := TRelation.Create(Self);
              rel.AFrame := AFrame;
              rel.BFrame := BFrame;
              rel.Name := RelName;
              rel.PrimaryKey := ReadString(RelName, 'BField', '');
              rel.ForeignKey := ReadString(RelName, 'AField', '');
              rel.NotNull := false;
              rel.IsCustomRelation := true;
              AFrame.AddRelation(rel);
              BFrame.AddRelation(rel);
              rel.SetPosition;
            end
          end;
        end;

        for i := 0 to slTables.Count - 1 do
        begin
          RelName := slTables[i];
          if RelName[1] <> '$' then                 //names of TRelation begin with $ char
            Continue;
          rel := RelationByName(RelName);
          if rel <> nil then
            rel.LoadNodesFromIni(Ini);
        end;

        for i := 0 to FFrames.Count - 1 do
        begin
          tbl := Frames[i];
          tbl.Visible := true;
          tbl.Paint;
        end;
      end;
    end;                                          //with inifile

  finally
    if APoint.x = 0 then
      Visible := true;
    Cursor := crDefault;
    slTables.Free;
    Ini.Free;
    fmProgress.Free;
    fmProgress := nil;
  end;
end;

procedure TModel.SetModified(Value: boolean);
begin
  FModified := Value;
  ModelForm.Caption := 'Model - ' + Filename;
  if FModified then
    ModelForm.Caption := ModelForm.Caption + '*';
  if ReadOnly then
    ModelForm.Caption := ModelForm.Caption + ' - Read Only';
end;
//=============================================================================

function TModel.GetSelectedFrame(i: integer): TfraMain;
begin
  Result := TfraMain(FSelectedFrames[i]);
end;
//=============================================================================

procedure TModel.AddSelectedFrame(AFrame: TfraMain; MultiSelected: boolean);
var
  i, j: integer;
  tbl: TfraMain;
begin
  if MultiSelected then
  begin
    //add only if AFrame already doesn´t exists in TList
    if FSelectedFrames.IndexOf(AFrame) = -1 then
      FSelectedFrames.Add(AFrame);
  end
  else
  begin
    for i := 0 to FSelectedFrames.Count - 1 do
    begin
      tbl := SelectedFrames[i];
      tbl.Selected := false;
      tbl.Paint;
      for j := 0 to tbl.FRelations.Count - 1 do
      begin
        tbl.Relations[j].Selected := false;
      end;
    end;
    FSelectedFrames.Clear;
    FSelectedFrames.Add(AFrame);
    for i := 0 to AFrame.FRelations.Count - 1 do
    begin
      AFrame.Relations[i].Selected := true;
    end;
  end;
end;
//=============================================================================

procedure TModel.DeselectFrames;
var
  i, j: integer;
  tbl: TfraMain;
begin
  for i := 0 to FSelectedFrames.Count - 1 do
  begin
    tbl := SelectedFrames[i];
    tbl.Selected := false;
    tbl.Paint;
    for j := 0 to tbl.FRelations.Count - 1 do
      tbl.Relations[j].Selected := false;
  end;
  FSelectedFrames.Clear;
end;
//=============================================================================

procedure TModel.MyClick(Sender: TObject);
var
  i: integer;
  rel: TRelation;
  Pos: TPoint;
begin
  DeselectFrames;
  for i := 0 to FRelations.Count - 1 do
  begin
    rel := TRelation(FRelations[i]);
    Pos := Self.ScreenToClient(Mouse.CursorPos);
    if PtInRegion(rel.Rgn, Pos.X, Pos.Y) then
    begin
      rel.Click(Pos.X, Pos.Y);
      Break;
    end;
  end;
  Self.Parent.SetFocus;
end;
//=============================================================================

procedure TModel.DrawRectangle(ALeft, ATop, AWidth, AHeight: integer);
var
  pt: TPoint;
begin
  pt := ClientToScreen(Point(ALeft, ATop));
  PatBlt(ModelScreenDC, pt.X, pt.Y, AWidth, 1, DSTINVERT);
  PatBlt(ModelScreenDC, pt.X + AWidth, pt.Y, 1, AHeight, DSTINVERT);
  PatBlt(ModelScreenDC, pt.X, pt.Y + AHeight, AWidth, 1, DSTINVERT);
  PatBlt(ModelScreenDC, pt.X, pt.Y, 1, AHeight, DSTINVERT);
end;
//=============================================================================

procedure TModel.Scale(Percent: integer);
var
  i, j: integer;
  tbl: TfraMain;
begin
  if Percent >= 30 then
  begin
    CurrentScale := Percent;
    RelPointer := Round(CurrentScale * 15 / 100);
    for i := 0 to FFrames.Count - 1 do
    begin
      tbl := Frames[i];
      tbl.Visible := false;
      tbl.LoadCoordFromOrig;
      tbl.ChangeScale(Percent, 100);
      tbl.Visible := true;
    end;

    for i := 0 to FRelations.Count - 1 do
    begin
      TRelation(FRelations[i]).LoadCoordFromOrig;
      TRelation(FRelations[i]).ChangeScale(Percent, 100);
    end;

    for i := 0 to FFrames.Count - 1 do
    begin
      tbl := Frames[i];
      tbl.Paint;
      tbl.ReDrawRelations;
    end;
    Modified := true;
    ModelForm.cmbScale.Text := IntToStr(CurrentScale);

    ResizeModel;
    Invalidate;
  end;
end;
//=============================================================================

procedure TModel.WndProc(var Message: TMessage);
begin
  if Message.Msg = WM_MOUSEWHEEL then
  begin
    //Message.Result := 9;
    SendMessage(ModelForm.scbModel.Handle, Message.Msg, Message.WParam, Message.LParam);
  end
  else if Message.Msg = WM_SETFOCUS then
  begin
    ModelForm.scbModel.SetFocus;
  end
  else
    inherited;
end;
//=============================================================================

function TModel.GetSelectedFrameCount: integer;
begin
  Result := FSelectedFrames.Count;
end;
//=============================================================================

function TModel.RelationByName(AName: string): TRelation;
var
  i: integer;
begin
  for i := 0 to FRelations.Count - 1 do
  begin
    Result := FRelations[i];
    if Result.Name = AName then
      Exit;
  end;
  Result := nil;
end;
//============================================================================

procedure TModel.CreateCustomRelation;
var
  Relation: TRelation;
begin
  if {(SelectedFrameCount = 2)
    and }(CustomRelationAFrame <> '')
    and (CustomRelationBFrame <> '') then
  begin
    Relation := TRelation.Create(Self);
    Relation.AFrame := FrameByName(CustomRelationAFrame); //  SelectedFrames[0];
    Relation.BFrame := FrameByName(CustomRelationBFrame);  //SelectedFrames[1];
    Relation.Name :=  '$$' + CustomRelationAFrame + '__' + CustomRelationAField + '__' + CustomRelationBFrame + '__' + CustomRelationBField;
    Relation.PrimaryKey := CustomRelationBField;
    Relation.ForeignKey := CustomRelationAField;
    Relation.NotNull := false;  //#todo1 zjistit zda je skutecne not null
    Relation.IsCustomRelation := true;
    Relation.AFrame.AddRelation(Relation);
    Relation.BFrame.AddRelation(Relation);
//    SelectedFrames[0].AddRelation(Relation);
//    SelectedFrames[1].AddRelation(Relation);
    Relation.SetPosition;
    Modified := true;
  end;

  CustomRelationAFrame := '';
  CustomRelationBFrame := '';
  CustomRelationAField := '';
  CustomRelationBField := '';
end;

{TfraMain}

constructor TfraMain.Create(AOwner: TModel);
begin
  inherited Create(TComponent(AOwner));
  FModel := AOwner;
  Parent := TWinControl(AOwner);
  FRelations := TList.Create;
  pnlMainOriginalWndProc := pnlMain.WindowProc;
  pnlMain.WindowProc := pnlMainWndProc;
end;
//=============================================================================

constructor TfraMain.CreateByName(AOwner: TModel; sTableName: string);
begin
  Create(AOwner);
  FrameName := sTableName;
  InternalName := sTableName;
  SaveCoordToOrig;
end;
//=============================================================================

destructor TfraMain.Destroy;
var
  i: integer;
  rel: TRelation;
begin
  FModel.DeleteFrame(Self);
  for i := FRelations.Count - 1 downto 0 do
  begin
    rel := Relations[i];
    //if rel.AFrame = Self then begin //outgoing relation
    rel.Free;
    //end else begin//ingoing relation, I am BFrame, disconnect
      //rel.BFrame := nil;
    //end;
  end;
  FRelations.Free;
  inherited;
end;
//=============================================================================

procedure TfraMain.pnlMainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FrameMouseDown(Sender, Button, Shift, X + pnlMain.Left, Y + pnlMain.Top);
end;
//=============================================================================

procedure TfraMain.pnlMainMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  FrameMouseMove(Sender, Shift, X + pnlMain.Left, Y + pnlMain.Top);
end;
//=============================================================================

procedure TfraMain.pnlMainMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FrameMouseUp(Sender, Button, Shift, X + pnlMain.Left, Y + pnlMain.Top);
end;
//=============================================================================

procedure TfraMain.pnlMainWndProc(var Message: TMessage);
begin
  if Message.Msg = WM_MOUSEWHEEL then
  begin
    //Message.Result := 9;
    SendMessage(FModel.ModelForm.scbModel.Handle, Message.Msg, Message.WParam, Message.LParam);
  end
  else
    pnlMainOriginalWndProc(Message);
end;
//=============================================================================

procedure TfraMain.FrameMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
const
  D = 7;                                          //mouse delta
var
  i: integer;
  tbl: TfraMain;
begin
  if bWasDblClick then
  begin
    bWasDblClick := false;
    Exit;
  end;
  
  SetZOrder(true);
  bDown := true;
  if not Selected then
  begin
    Selected := true;
    FModel.AddSelectedFrame(Self, (Shift = [ssLeft, ssShift]) or (Shift = [ssLeft, ssCtrl]));
    Paint;
  end;
  if Width - X < D then
  begin
    if Y < D then
      bResizingTR := true
    else if Height - Y < D then
      bResizingBR := true
    else
      bResizingR := true;
  end
  else if X < D then
  begin
    if Y < D then
      bResizingTL := true
    else if Height - Y < D then
      bResizingBL := true
    else
      bResizingL := true;
  end
  else if (Height - Y < D) and not (soTitleOnly in ShowOptions) then
    bResizingB := true
  else if Y < D then
    bResizingT := true
  else
  begin
    bMoving := true;
    ScreenDC := GetDC(0);
    bx := X;
    by := Y;
    for i := 0 to FModel.FSelectedFrames.Count - 1 do
    begin
      tbl := FModel.SelectedFrames[i];
      tbl._LeftTop := FModel.ClientToScreen(Point(tbl.Left, tbl.Top));
      tbl.DrawRectangle(tbl._LeftTop.X, tbl._LeftTop.Y, tbl.Width, tbl.Height);
    end;
  end;

  bFirstMove := true;
end;
//=============================================================================

procedure TfraMain.FrameMouseMove(Sender: TObject; Shift: TShiftState; X,  Y: Integer);
const
  D = 7;                                          //mouse delta
var
  tmp, i, l, t: integer;
  tbl: TfraMain;
  ptMouse, ptBox: TPoint;
begin
  //pnlMain.SetFocus;
  if not bDown then
  begin
    if Width - X < D then
    begin
      if Y < D then
        pnlMain.Cursor := crSizeNESW
      else if Height - Y < D then
        pnlMain.Cursor := crSizeNWSE
      else
        pnlMain.Cursor := crSizeWE;
    end
    else if X < D then
    begin
      if Y < D then
        pnlMain.Cursor := crSizeNWSE
      else if Height - Y < D then
        pnlMain.Cursor := crSizeNESW
      else
        pnlMain.Cursor := crSizeWE;
    end
    else if ((Height - Y < D) or (Y < D)) and not (soTitleOnly in ShowOptions) then
      pnlMain.Cursor := crSizeNS
    else
      pnlMain.Cursor := crSizeAll
  end;
  if bMoving then
  begin
    ptMouse := Mouse.CursorPos;
    ptBox := FModel.ModelForm.scbModel.ClientOrigin;
    if (ptMouse.X > ptBox.X) and (ptMouse.Y > ptBox.Y) then
      for i := 0 to FModel.FSelectedFrames.Count - 1 do
      begin
        tbl := FModel.SelectedFrames[i];
        tbl.DrawRectangle(tbl._LeftTop.X, tbl._LeftTop.Y, tbl.Width, tbl.Height);
        l := tbl.Left + (X - bX);
        t := tbl.Top + (Y - bY);
        if Model.SnapToGrid then
        begin
          l := Round((l div Model.GridX) * Model.GridX);
          t := Round((t div Model.GridY) * Model.GridY);
        end;
        tbl.LeftTop := FModel.ClientToScreen(Point(l, t));
        tbl.DrawRectangle(tbl.LeftTop.X, tbl.LeftTop.Y, tbl.Width, tbl.Height);
        tbl._LeftTop.X := tbl.LeftTop.X;
        tbl._LeftTop.Y := tbl.LeftTop.Y;
      end;
  end
  else if not bFirstMove then
  begin
    if Model.SnapToGrid then
    begin
      X := Round((X div Model.GridX) * Model.GridX);
      Y := Round((Y div Model.GridY) * Model.GridY);
    end;
    if bResizingBR then
    begin
      Width := X;
      Height := Y;
    end
    else if bResizingR then
      Width := X
    else if bResizingB then
      Height := Y
    else if bResizingL then
    begin
      tmp := Left;
      Left := ClientToParent(Point(X, Y)).X + FModel.ModelForm.scbModel.HorzScrollBar.Position;
      Width := Width + (tmp - Left);
    end
    else if bResizingT then
    begin
      tmp := Top;
      Top := ClientToParent(Point(X, Y)).Y + FModel.ModelForm.scbModel.VertScrollBar.Position;
      Height := Height + (tmp - Top);
    end
    else if bResizingTR then
    begin
      tmp := Top;
      Top := ClientToParent(Point(X, Y)).Y + FModel.ModelForm.scbModel.VertScrollBar.Position;
      Height := Height + (tmp - Top);
      Width := X;
    end
    else if bResizingTL then
    begin
      tmp := Top;
      Top := ClientToParent(Point(X, Y)).Y + FModel.ModelForm.scbModel.VertScrollBar.Position; //++
      Height := Height + (tmp - Top);
      tmp := Left;
      Left := ClientToParent(Point(X, Y)).X + FModel.ModelForm.scbModel.HorzScrollBar.Position; //++
      Width := Width + (tmp - Left);
    end
    else if bResizingBL then
    begin
      tmp := Left;
      Left := ClientToParent(Point(X, Y)).X + FModel.ModelForm.scbModel.HorzScrollBar.Position;
      Width := Width + (tmp - Left);
      Height := Y;
    end;
  end;
  bFirstMove := false;
end;
//=============================================================================

procedure TfraMain.FrameMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i, j: integer;
  dx, dy: integer;
  tbl: TfraMain;
begin
  bDown := false;
  if bResizingT or bResizingL or bResizingR or bResizingB or bResizingTL or bResizingTR or bResizingBL or bResizingBR then
  begin
    bResizingT := false;
    bResizingL := false;
    bResizingR := false;
    bResizingB := false;
    bResizingTL := false;
    bResizingTR := false;
    bResizingBL := false;
    bResizingBR := false;
    SaveCoordToOrig;
    FModel.Modified := true;
    for j := 0 to FRelations.Count - 1 do
      Relations[j].SetPosition;
  end;

  if (bx <> X) or (by <> Y) then                  //was moved (bMoving is not applicable here, because it is set even if the table is not moved)
    FModel.Modified := true;

  if bMoving then
  begin
    bMoving := false;
    for i := 0 to FModel.FSelectedFrames.Count - 1 do
    begin
      tbl := FModel.SelectedFrames[i];
      tbl.DrawRectangle(tbl._LeftTop.X, tbl._LeftTop.Y, tbl.Width, tbl.Height);
    end;
    //DrawRectangle(_LeftTop.X, _LeftTop.Y, Width, Height);
    ReleaseDC(0, ScreenDC);
    _LeftTop := FModel.ScreenToClient(_LeftTop);
    dx := Left - _LeftTop.X;
    dy := Top - _LeftTop.Y;
    //Left := _LeftTop.X;
    //Top := _LeftTop.Y;
    for i := 0 to FModel.FSelectedFrames.Count - 1 do
    begin
      tbl := FModel.SelectedFrames[i];
      tbl.DrawRectangle(tbl._LeftTop.X, tbl._LeftTop.Y, tbl.Width, tbl.Height);
      tbl.Left := tbl.Left - dx;
      tbl.Top := tbl.Top - dy;
      tbl.Left := max(tbl.Left, 0);
      tbl.Top := max(tbl.Top, 0);
      tbl.SaveCoordToOrig;
      for j := 0 to tbl.FRelations.Count - 1 do
        tbl.Relations[j].SetPosition;
      tbl.Paint;
    end;

    for i := 0 to FModel.FSelectedNodes.Count - 1 do
    begin                                         //move the selected nodes
      PPoint(FModel.FSelectedNodes[i])^.X := PPoint(FModel.FSelectedNodes[i])^.X - dx;
      PPoint(FModel.FSelectedNodes[i])^.Y := PPoint(FModel.FSelectedNodes[i])^.Y - dy;
    end;

    //ReDrawRelations;  //TODO2 : is it necessary to ReDraw here??? 
//    for i := 0 to FRelations.Count - 1 do  //zakomentovano, uz se to dela pro vsechny vybrane (vcetne teto) o par radku nahoru
//      Relations[i].SetPosition;
  end;

  FModel.Invalidate;
  FModel.ResizeModel;
end;
//=============================================================================

procedure TfraMain.SetSelected(Value: boolean);
begin
  FSelected := Value;
end;
//=============================================================================

function TfraMain.GetRelation(i: integer): TRelation;
begin
  Result := TRelation(FRelations[i]);
end;
//=============================================================================

procedure TfraMain.DrawRectangle(ALeft, ATop, AWidth, AHeight: integer);
begin
  PatBlt(ScreenDC, ALeft, ATop, AWidth, 1, DSTINVERT);
  PatBlt(ScreenDC, ALeft + AWidth, ATop, 1, AHeight, DSTINVERT);
  PatBlt(ScreenDC, ALeft, ATop + AHeight, AWidth, 1, DSTINVERT);
  PatBlt(ScreenDC, ALeft, ATop, 1, AHeight, DSTINVERT);
end;
//=============================================================================

function TfraMain.GetLeftJoin(sFieldName: string): TPoint;
begin
  //todo2 implementovat v potomkovi
end;
//=============================================================================

function TfraMain.GetRightJoin(sFieldName: string): TPoint;
begin
  //todo2 implementovat v potomkovi
end;
//=============================================================================

procedure TfraMain.AddRelations;
begin
  //todo2 implementovat v potomkovi
end;
//=============================================================================

procedure TfraMain.AddRelation(ARelation: TRelation);
begin
  FRelations.Add(ARelation);
end;
//=============================================================================

procedure TfraMain.DeleteRelation(ARelation: TRelation);
begin
  FRelations.Delete(FRelations.IndexOf(ARelation));
end;
//=============================================================================

procedure TfraMain.RefreshRelations;
var
  Nodes: string;
  sNodeList: TStringList;
  Ini: TIniFile;
  k: integer;
  P: PPoint;
begin
  //todo2 implementovat v potomkovi
//  with TIniFile.Create(Model.Filename) do
//  begin
//    Nodes := ReadString(RelName, 'Nodes', '');
//    Free;
//  end;
//
//  if Nodes <> '' then
//  begin
//    sNodeList := TStringList.Create;
//    try
//      sNodeList.Delimiter := ';';
//      sNodeList.DelimitedText := Nodes;   //parse the semicolon separated list of coordinates
//      for j := 0 to sNodeList.Count - 1 do
//      begin
//        k := Pos(',', sNodeList[j]);
//        New(P);                           //new Point
//        P^.X := StrToIntDef(Copy(sNodeList[j], 1, k - 1), 0);
//        P^.Y := StrToIntDef(Copy(sNodeList[j], k + 1, 10), 0);
//        rel.NodeList.Add(P);
//      end;
//      rel.SaveCoordToOrig;
//    finally
//      sNodeList.Free;
//    end;
//  end;
end;
//=============================================================================

procedure TfraMain.ReDrawRelations;
var
  i: integer;
  rel: TRelation;
begin
  for i := 0 to FRelations.Count - 1 do
  begin
    rel := Relations[i];
    rel.SetPosition;
    rel.Paint;
  end;
  //FModel.Invalidate;
//    FModel.Repaint;
end;
//=============================================================================

procedure TfraMain.Paint;
begin
  //todo2 implementovat v potomkovi
end;
//=============================================================================

procedure TfraMain.Refresh;
begin
  //todo2 implementovat v potomkovi
end;
//=============================================================================

procedure TfraMain.SaveCoordToOrig;
begin
  OrigLeft  := Round(Left  / (FModel.CurrentScale / 100));
  OrigTop   := Round(Top   / (FModel.CurrentScale / 100));
  OrigWidth := Round(Width / (FModel.CurrentScale / 100));
  if not (soTitleOnly in ShowOptions) then
    OrigHeight := Round(Height / (FModel.CurrentScale / 100));
end;
//=============================================================================

procedure TfraMain.LoadCoordFromOrig;
begin
  Left := OrigLeft;
  Top := OrigTop;
  Width := OrigWidth;
  Height := OrigHeight;
end;
//=============================================================================

procedure TfraMain.ChangeScale(M, D: Integer);
var
  i: integer;
begin
  inherited;

end;
//=============================================================================

function TfraMain.GetRelationCount: integer;
begin
  Result := FRelations.Count;
end;

procedure TfraMain.SaveToIniFile(Ini: TIniFile);
begin
  //todo2 implementovat v potomkovi
end;
//=============================================================================

procedure TfraMain.LoadFromIniFile(Ini: TIniFile);
begin
  with Ini do
  begin
    Left := ReadInteger(FrameName, 'Left', 10);
    Top := ReadInteger(FrameName, 'Top', 10);
    Width := ReadInteger(FrameName, 'Width', 110);
    Height := ReadInteger(FrameName, 'Height', 150);
    //SaveCoordToOrig; //pøesunuto do potomkù
  end;
  //todo2 implementovat v potomkovi
end;
//=============================================================================

procedure TfraMain.KeyPress(var Key: Char);
begin
  inherited;
//
end;

end.
