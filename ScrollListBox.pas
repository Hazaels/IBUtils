unit ScrollListBox;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, StdCtrls;

type
  PFieldRec = ^FieldRec;
  FieldRec = record
    NotNull, IsFK, IsPK: boolean;
    Name, Description, FieldType, Domain, ComputedBy: string;
    IndexCount, UniqueIndexCount: integer;
  end;

type
  TScrollListBox = class(TListBox)
  private
    FOnScroll: TNotifyEvent;
    FFields: TList;
    function GetFieldRec(i: integer): PFieldRec;
    procedure SetFieldRec(i: integer; const Value: PFieldRec);
    function GetFieldCount: integer;
  protected
    { Protected declarations }
  public
    property Fields[i: integer]: PFieldRec read GetFieldRec write SetFieldRec;
    property FieldCount: integer read GetFieldCount;
    procedure WndProc(var Message: TMessage); override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear; override;
    procedure RefreshFields;
  published
    property OnScroll: TNotifyEvent read FOnScroll write FOnScroll;
    procedure AddField(AName, ADescription, AFieldType, ADomain, AComputedBy: string; ANotNull, AIsFK, AIsPK: boolean; AIndexCount, AUniqueIndexCount: integer);
  end;

procedure Register;

implementation

//=============================================================================
procedure Register;
begin
  RegisterComponents('Infis', [TScrollListBox]);
end;
//=============================================================================

procedure TScrollListBox.AddField(AName, ADescription, AFieldType, ADomain, AComputedBy: string;
  ANotNull, AIsFK, AIsPK: boolean; AIndexCount, AUniqueIndexCount: integer);
var
  rec: PFieldRec;
begin
  Items.Add(AName);
  New(rec);
  rec^.Name := AName;
  rec^.Description := ADescription;
  rec^.FieldType := AFieldType;
  rec^.Domain := ADomain;
  rec^.NotNull := ANotNull;
  rec^.IsFK := AIsFK;
  rec^.IsPK := AIsPK;
  rec^.ComputedBy := AComputedBy;
  rec^.IndexCount := AIndexCount;
  rec^.UniqueIndexCount := AUniqueIndexCount;
  FFields.Add(rec);
end;
//=============================================================================

procedure TScrollListBox.RefreshFields;
var
  i: integer;
begin
  inherited Clear;
  for i := 0 to FFields.Count-1 do
    Items.Add(PFieldRec(FFields[i]).Name);
end;
//============================================================================

procedure TScrollListBox.Clear;
var
  i: integer;
begin
  inherited;
  for i := FFields.Count-1 downto 0 do begin
    Dispose(Fields[i]);
  end;
  FFields.Clear;
end;
//=============================================================================

constructor TScrollListBox.Create(AOwner: TComponent);
begin
  inherited;
  FFields := TList.Create;
end;
//=============================================================================

destructor TScrollListBox.Destroy;
var
  i: integer;
begin
  for i := FFields.Count-1 downto 0 do begin
    Dispose(Fields[i]);
  end;
  FFields.Free;
  inherited;
end;
//=============================================================================

function TScrollListBox.GetFieldRec(i: integer): PFieldRec;
begin
  Result := PFieldRec(FFields[i]);
end;
//=============================================================================

procedure TScrollListBox.WndProc(var Message: TMessage);
begin
  if Message.Msg = WM_VSCROLL then begin
    if Assigned(FOnScroll) then
      FOnScroll(Self);
    Message.Result := 9;
  end;
  inherited WndProc(Message);
end;
//=============================================================================

procedure TScrollListBox.SetFieldRec(i: integer; const Value: PFieldRec);
begin
  FFields[i] := Value;
end;
//=============================================================================

function TScrollListBox.GetFieldCount: integer;
begin
  Result := FFields.Count;
end;
//=============================================================================

end.
