unit Browse;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IB_UpdateBar, ExtCtrls, Grids, IB_Grid, IB_Components, ComCtrls,
  StdCtrls, Mask, IB_Controls, AIB_Grid, AIB_Query, AIB_DataSource, Model,
  ToolWin, Placemnt, IB_QExportDialog;

type
  TfmBrowse = class(TForm)
    StatusBar: TStatusBar;
    grBrowse: TAIB_Grid;
    qrBrowse: TAIB_Query;
    dsBrowse: TAIB_DataSource;
    ToolBar1: TToolBar;
    UpdateBar: TIB_UpdateBar;
    FormStorage: TFormStorage;
    ExportDialog: TIB_QExportDialog;
    tbExport: TToolButton;
    ToolButton2: TToolButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure tbExportClick(Sender: TObject);
  private
    { Private declarations }
  public
    ModelForm: TfmModel;
    TableName: string;
    destructor Destroy; override;
  end;

var
  fmBrowse: TfmBrowse;

implementation

uses MAIN, ShFolder, ShlObj;


{$R *.dfm}


destructor TfmBrowse.Destroy;
begin
  ModelForm.BrowseList.Remove(Self);
  inherited;
end;
//=============================================================================

procedure TfmBrowse.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;
//=============================================================================

procedure TfmBrowse.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_INSERT:
    begin
      qrBrowse.Insert;
      Key := 0;
    end;

    VK_F2:
    begin
      qrBrowse.Edit;
      Key := 0;
    end;

    VK_DELETE:
    begin
      if Shift = [ssCtrl] then
      begin
        qrBrowse.Delete;
        Key := 0;
      end;
    end;

    VK_F5:
    begin
      qrBrowse.Refresh;
      Key := 0;
    end;
  end;
end;
//=============================================================================

procedure TfmBrowse.FormCreate(Sender: TObject);
begin
  FormStorage.IniFileName := ExtractFilePath(Application.ExeName) + 'ibutils.ini';
end;
//=============================================================================

procedure TfmBrowse.tbExportClick(Sender: TObject);
var
  sFilename: string;
  pFolder: PChar;
begin
  with ExportDialog do
  begin
    GetMem(pFolder, 255);
    SHGetFolderPath(0, CSIDL_DESKTOPDIRECTORY, 0, 0, pFolder);
    sFilename := StrPas(pFolder);
    FreeMem(pFolder);
    if sFilename <> '' then
      FileName := sFilename + '\' + TableName + '.xls';
    Execute;
  end;
end;
//=============================================================================

end.
