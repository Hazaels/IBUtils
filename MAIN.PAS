unit MAIN;


{$I IBUtils.inc}

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, ActnList, ImgList,
  IB_Components, Placemnt, MRUList, StdActns, Math, Printers, AppEvnts, IB_Session,
  IniFiles;

const
  crCustomLinkFrom = 1000;
  crCustomLinkTo   = 1001;

type
  TfmMain = class(TForm)
    mnMain: TMainMenu;
    Window1: TMenuItem;
    WindowCascadeItem: TMenuItem;
    WindowTileItem: TMenuItem;
    WindowArrangeItem: TMenuItem;
    ODlg: TOpenDialog;
    WindowMinimizeItem: TMenuItem;
    StatusBar: TStatusBar;
    ActionList1: TActionList;
    WindowCascade1: TWindowCascade;
    WindowTileHorizontal1: TWindowTileHorizontal;
    WindowArrangeAll1: TWindowArrange;
    WindowMinimizeAll1: TWindowMinimizeAll;
    actHelpAbout: TAction;
    WindowTileVertical1: TWindowTileVertical;
    WindowTileItem2: TMenuItem;
    ilMain: TImageList;
    cnMain: TIB_Connection;
    mniUtils: TMenuItem;
    actModelNew: TAction;
    Model1: TMenuItem;
    actModelOpen: TAction;
    OpenModel1: TMenuItem;
    mniFile: TMenuItem;
    MRUModel: TMRUManager;
    fsMain: TFormStorage;
    mniReopen: TMenuItem;
    actRegisterDatabases: TAction;
    Databases1: TMenuItem;
    actConnect: TAction;
    mniClearList: TMenuItem;
    N2: TMenuItem;
    actImport: TAction;
    mniImport: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    actPrinterSetup: TAction;
    ApplicationEvents: TApplicationEvents;
    N3: TMenuItem;
    N1: TMenuItem;
    mniExit: TMenuItem;
    actOptions: TAction;
    N4: TMenuItem;
    mniOptions: TMenuItem;
    procedure actModelNewExecute(Sender: TObject);
    procedure actModelOpenExecute(Sender: TObject);
    procedure MRUModelClick(Sender: TObject; const RecentName,
      Caption: string; UserData: Integer);
    procedure actRegisterDatabasesExecute(Sender: TObject);
    procedure actConnectExecute(Sender: TObject);
    procedure cnMainAfterConnect(Sender: TIB_Connection);
    procedure mniClearListClick(Sender: TObject);
    procedure actImportExecute(Sender: TObject);
    procedure actHelpAboutExecute(Sender: TObject);
    procedure actPrinterSetupExecute(Sender: TObject);
    procedure ApplicationEventsMessage(var Msg: tagMSG;
      var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEventsActionExecute(Action: TBasicAction;
      var Handled: Boolean);
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
    procedure FormShow(Sender: TObject);
    procedure mniExitClick(Sender: TObject);
    procedure actOptionsExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    function IsModelOpened(sFilename: string): boolean;
    procedure OpenModelParams(AFilename, AUser, APassword: string);
  public
    bLoadLastOpened: boolean;
    function Connect(var AConnection: TIB_Connection): Boolean;
    procedure ToFront;
  end;


  procedure MakeLog(Filename, Text: string);
  procedure MakeLogDef(IB_Connection: TIB_Connection; Text: string);
  procedure TimeMessage(AText: string; ATime: Cardinal = 1000);
  function GetCommandLineParam(ASwitch: string): string;

var
  fmMain: TfmMain;
  ScreenDC, ModelScreenDC: HDC;
  sAppIni: string;
  bKeepConnection: boolean;

implementation

{$R *.dfm}
{$R kursory.RES}

uses InstanceManager, CreateTable, Model, fraTable_u, Databases, Import, About,
  PrinterSetup, fraMain_u, MessageForm, Options;

//============================================================================

procedure TfmMain.actModelNewExecute(Sender: TObject);
var
  fm: TfmModel;
begin
  fm := TfmModel.Create(Application);
  TModel(fm.Model).AddTablesFilter := 'RDB$RELATION_NAME NOT CONTAINING ''$''';
  if Connect(fm.cnModel) then
    fm.Show
  else
    fm.Free;
end;
//=============================================================================

procedure TfmMain.actModelOpenExecute(Sender: TObject);
var
  fm: TfmModel;
begin
  if ODlg.Execute then
  begin
    //check duplicates
    if MRUModel.Strings.IndexOf(ODlg.Filename) = -1 then
      MRUModel.Add(ODlg.Filename, 0);

    if IsModelOpened(ODlg.FileName) then
    begin
      MessageDlg('Model ' + ODlg.FileName + ' is already opened.', mtWarning, [mbOK], 0);
      Exit;
    end;

    //if not already opened, then create and show
    fm := TfmModel.Create(Application);
    TModel(fm.Model).Open(ODlg.Filename);
    fm.CheckConnected;
    //if not fm.cnModel.Connected then
      //fm.cnModel.Connect;
    TModel(fm.Model).Show;
  end;
end;
//=============================================================================

procedure TfmMain.MRUModelClick(Sender: TObject; const RecentName,
  Caption: string; UserData: Integer);
var
  fm: TfmModel;
begin
  if not IsModelOpened(RecentName) then
  begin
    fm := TfmModel.Create(Application);
    TModel(fm.Model).Filename := RecentName;
    TModel(fm.Model).Open(RecentName);
  end;
end;
//=============================================================================

function TfmMain.IsModelOpened(sFilename: string): boolean;
var
  i: integer;
begin
  Result := false;
  for i := 0 to MDIChildCount - 1 do
  begin
    if (MDIChildren[i] is TfmModel) then
    begin
      if TModel((MDIChildren[i] as TfmModel).Model).Filename = sFileName then
      begin
        Result := true;
        MDIChildren[i].BringToFront;
        Exit;
      end;
    end;
  end;
end;
//=============================================================================

procedure TfmMain.actRegisterDatabasesExecute(Sender: TObject);
begin
  TfmDatabases.Create(Application).ShowModal;
end;
//=============================================================================

function TfmMain.Connect(var AConnection: TIB_Connection): boolean;
begin
  Result := false;
  with TfmDatabases.Create(Application) do
  begin
    btMoreLessClick(nil);                         //make it 'less'
    Connection := AConnection;
    Connection.LoginPrompt := true;
    if (ShowModal = mrOk) and AConnection.Connected then
    begin
      Result := true;
      StatusBar.Panels.Items[1].Text := 'Database: ' + AConnection.Database
    end
    else
      StatusBar.Panels.Items[1].Text := '';
  end;
end;
//=============================================================================

procedure TfmMain.actConnectExecute(Sender: TObject);
begin
  //  Connect(cnMain);
  //  if cnMain.Connected then
  //    fmMain.StatusBar.Panels.Items[1].Text := 'Database: ' + cnMain.Database
  //  else
  //    fmMain.StatusBar.Panels.Items[1].Text := '';
end;
//=============================================================================

procedure TfmMain.cnMainAfterConnect(Sender: TIB_Connection);
begin
  //   if cnMain.Connected then
  //    fmMain.StatusBar.Panels.Items[1].Text := 'Database: ' + cnMain.Database
  //  else
  //    fmMain.StatusBar.Panels.Items[1].Text := '';
end;
//=============================================================================

procedure TfmMain.mniClearListClick(Sender: TObject);
begin
  MRUModel.Clear;
end;
//=============================================================================

procedure TfmMain.actImportExecute(Sender: TObject);
var
  fm: TfmImport;
begin
  fm := TfmImport.Create(Application);
  if Connect(fm.cnImport) then
    fm.Show
  else
    fm.Free;
end;
//============================================================================

procedure TfmMain.actHelpAboutExecute(Sender: TObject);
begin
  TfmAbout.Create(Application).ShowModal;
end;
//============================================================================

procedure TfmMain.actPrinterSetupExecute(Sender: TObject);
begin
  fmPrinterSetup.ShowModal;
end;
//============================================================================

procedure TfmMain.ApplicationEventsMessage(var Msg: tagMSG;
  var Handled: Boolean);
begin
  if (Msg.message = WM_KEYDOWN) then
  begin
    if Assigned(Screen.ActiveControl) and (Screen.ActiveControl.ClassType = TScrollBox) then
    begin
      case Msg.wParam of
        VK_RIGHT: SendMessage(Screen.ActiveControl.Handle, WM_HSCROLL, SB_LINERIGHT, 0);
        VK_DOWN: SendMessage(Screen.ActiveControl.Handle, WM_VSCROLL, SB_LINEDOWN, 0);
        VK_LEFT: SendMessage(Screen.ActiveControl.Handle, WM_HSCROLL, SB_LINELEFT, 0);
        VK_UP: SendMessage(Screen.ActiveControl.Handle, WM_VSCROLL, SB_LINEUP, 0);
      end;
    end;
  end;
end;
//============================================================================

procedure TfmMain.FormCreate(Sender: TObject);
var
  sWinDir, sWinIni: string;
  pWinDir: PChar;
begin
  InstanceManager.triggerProc:=ToFront;
  Screen.Cursors[crCustomLinkFrom] := LoadCursor(HInstance, 'CUSTOM_LINK_FROM');
  Screen.Cursors[crCustomLinkTo] := LoadCursor(HInstance, 'CUSTOM_LINK_TO');
{$IFDEF ALIKIWI}
//  mniCreateTable.Visible := true;
  mniImport.Visible := true;
{$ELSE}
//  mniCreateTable.Visible := false;
  mniImport.Visible := false;
{$ENDIF}

  //pøesunout ini z windows do adresáøe applikace
  GetMem(PWinDir, 255);
  GetWindowsDirectory(PWinDir, 255);
  sWindir := StrPas(PWinDir);
  FreeMem(PWinDir);
  sWinIni := IncludeTrailingBackSlash(sWinDir) + 'ibutils.ini';
  sAppIni := ExtractFilePath(Application.ExeName) + 'ibutils.ini';
  if FileExists( sWinIni ) then
  begin
    CopyFile(PChar(sWinIni), PChar(sAppIni), false);
    DeleteFile(sWinIni);
  end;

  fsMain.IniFileName := sAppIni;
end;
//============================================================================

procedure TfmMain.ApplicationEventsActionExecute(Action: TBasicAction;
  var Handled: Boolean);
begin
//  if Screen.ActiveControl is TMemo then
//    Handled := true;
end;
//=============================================================================

procedure TfmMain.ApplicationEventsException(Sender: TObject;
  E: Exception);
begin
  Screen.Cursor := crDefault;
  
  if E is EIB_ISCError then
    (E as EIB_ISCError).ShowDialog
//  else
//    raise E;
end;
//=============================================================================

procedure MakeLog(Filename, Text: string);
var
  Log: TStringList;
begin
  Log := TStringList.Create;
  try
    Log.LoadFromFile(Filename);
//    Log.Append(#13#10);
//    Log.AddStrings(Lines);
    Log.Add(Text);
    //Log.Append(#13#10);
    Log.SaveToFile(Filename);
  finally
    Log.Free;
  end;
end;
//=============================================================================

procedure TfmMain.ToFront;
var
  AFilename, AUser, APassword, tmpSwitch: string;

  function GetParam(ASwitch: string): string;
  var
    n: integer;
    tmp: string;
  begin
    Result := '';
    tmpSwitch := AnsiUpperCase('-' + ASwitch);
    n := Pos(tmpSwitch, AnsiUpperCase(InstanceManager.rcvStr));
    if n = 0 then
    begin
      tmpSwitch := AnsiUpperCase('/' + ASwitch);
      n := Pos(tmpSwitch, AnsiUpperCase(InstanceManager.rcvStr));
    end;
    if n > 0 then
    begin
      tmp := Trim(Copy(InstanceManager.rcvStr, n + Length(tmpSwitch)+1, Length(InstanceManager.rcvStr)));
      n := Pos(' ', tmp);
      if n = 0 then
        Result := tmp
      else
        Result := Trim(Copy(tmp, 1, n));
    end;
  end;

begin
  Application.Restore;
  Application.BringToFront;
  AFilename := GetParam('filename');
  AUser := GetParam('user');
  APassword := GetParam('password');
  if (AFilename <> '') {and (AUser <> '') and (APassword <> '')} then
    OpenModelParams(AFilename, AUser, APassword);
end;
//=============================================================================

procedure TfmMain.OpenModelParams(AFilename, AUser, APassword: string);
var
  fm: TfmModel;
begin
  //check duplicates
  if MRUModel.Strings.IndexOf(AFilename) = -1 then
    MRUModel.Add(AFilename, 0);

  if IsModelOpened(AFileName) then
  begin
    MessageDlg('Model ' + AFileName + ' is already opened.', mtWarning, [mbOK], 0);
    Exit;
  end;

  //if not already opened, then create and show
  fm := TfmModel.Create(Application);
  try
    TModel(fm.Model).Open(AFilename, AUser, APassword);
    TModel(fm.Model).Show;
  except
    fm.Free;
  end;
end;
//=============================================================================

procedure MakeLogDef(IB_Connection: TIB_Connection; Text: string);
begin
  if (IB_Connection.FieldsCharCase.Count > 0)
    and (IB_Connection.FieldsCharCase.Strings[0] <> '') then
      MakeLog(IB_Connection.FieldsCharCase.Strings[0], Text);
end;
//=============================================================================

procedure TimeMessage(AText: string; ATime: Cardinal = 1000);
var
  fm: TfmMessage;
begin
  fm := TfmMessage.Create(Application);
  with fm do
  begin
    Panel.Caption := AText;
    fm.Width := fm.Canvas.TextWidth(AText) + 40;
    Show;
    Panel.Update;
    Application.ProcessMessages;
    Sleep(ATime);
    Free;
  end;
end;
//=============================================================================

function GetCommandLineParam(ASwitch: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to ParamCount do begin
    if (UpperCase(ParamStr(i)) = UpperCase('-' + ASwitch)) or (UpperCase(ParamStr(i)) = UpperCase('/' + ASwitch)) then
    begin
      if (i+1) <= ParamCount then begin
        Result := Trim(ParamStr(i+1));
        Exit;
      end;
    end;
  end;
end;
//=============================================================================

procedure TfmMain.FormShow(Sender: TObject);
var
  sFilename, sUser, sPassword: string;
  Ini: TIniFile;
  i, iFileCount: integer;
  fm: TfmModel;
begin
  if ParamCount > 1 then
  begin
    sFilename := GetCommandLineParam('filename');
    sUser := GetCommandLineParam('user');
    sPassword := GetCommandLineParam('password');
    if (sFilename <> '') {and (sUser <> '') and (sPassword <> '')} then
      OpenModelParams(sFilename, sUser, sPassword);
  end
  else
  begin
    Ini := TIniFile.Create(sAppIni);
    try
      bLoadLastOpened := Ini.ReadBool('Options', 'LoadLastOpened', false);
      bKeepConnection := Ini.ReadBool('Options', 'KeepConnection', true);
      if bLoadLastOpened then
      begin
        iFileCount := Ini.ReadInteger('LastOpenedFiles', 'FileCount', 0);
        for i := 1 to iFileCount do
        begin
          sFilename := Ini.ReadString('LastOpenedFiles', Format('I%d', [i]), '');
          if (sFilename <> '') and not IsModelOpened(sFilename) then
          begin
            fm := TfmModel.Create(Application);
            try
              TModel(fm.Model).Open(sFilename);
              TModel(fm.Model).Show;
              fm.CheckConnected;
            except
              fm.Free;
            end;
          end;
        end;
      end;
    finally
      Ini.Free;
    end;
  end;
end;
//=============================================================================

procedure TfmMain.mniExitClick(Sender: TObject);
begin
  Close;
end;
//=============================================================================

procedure TfmMain.actOptionsExecute(Sender: TObject);
var
  fm: TfmOptions;
  Ini: TIniFile;
begin
  fm := TfmOptions.Create(nil);
  try
    fm.chkLoadLastOpened.Checked := bLoadLastOpened;
    fm.chkKeepConnection.Checked := bKeepConnection;
    if fm.ShowModal = mrOk then
    begin
      Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'ibutils.ini');
      try
        bLoadLastOpened := fm.chkLoadLastOpened.Checked;
        bKeepConnection := fm.chkKeepConnection.Checked;
        Ini.WriteBool('Options', 'LoadLastOpened', bLoadLastOpened);
        Ini.WriteBool('Options', 'KeepConnection', bKeepConnection);
      finally
        Ini.Free;
      end;
    end;
  finally
    fm.Free;
  end;
end;
//=============================================================================

procedure TfmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  i, iCounter: integer;
  Ini: TIniFile;
begin
  if bLoadLastOpened then
  begin
    iCounter := 0;
    Ini := TIniFile.Create(sAppIni);
    try
      Ini.EraseSection('LastOpenedFiles');
      for i := 0 to MDIChildCount - 1 do
      begin
        if (MDIChildren[i] is TfmModel) then
        begin
          Inc(iCounter);
          Ini.WriteString('LastOpenedFiles', Format('I%d', [iCounter]), TModel((MDIChildren[i] as TfmModel).Model).Filename);
        end;
      end;
      Ini.WriteInteger('LastOpenedFiles', 'FileCount', iCounter);
    finally
      Ini.Free;
    end;
  end;
end;
//=============================================================================

end.

