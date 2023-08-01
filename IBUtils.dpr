program IBUtils;

{$I IBUtils.inc}

{%File 'IBUtils.inc'}
{%File 'defaults.txt'}

uses
  InstanceManager in 'InstanceManager.pas',
  Forms,
  MAIN in 'MAIN.PAS' {fmMain},
  CreateTable in 'CreateTable.pas' {fmCreateTable},
  fraTable_u in 'fraTable_u.pas' {fraTable: TFrame},
  Model in 'Model.pas' {fmModel},
  AddTable in 'AddTable.pas' {fmAddTable},
  FindTable in 'FindTable.pas' {fmFindTable},
  ShowOptions in 'ShowOptions.pas' {fmShowOptions},
  Databases in 'Databases.pas' {fmDatabases},
  Import in 'Import.pas' {fmImport},
  About in 'About.pas' {fmAbout},
  Preview_u in 'Preview_u.pas' {fmPreview},
  PrinterSetup in 'PrinterSetup.pas' {fmPrinterSetup},
  Progress in 'Progress.pas' {fmProgress},
  fraMain_u in 'fraMain_u.pas' {fraMain: TFrame},
  fraNote_u in 'fraNote_u.pas' {fraNote: TFrame},
  Browse in 'Browse.pas' {fmBrowse},
  MessageForm in 'MessageForm.pas' {fmMessage},
  Indexes in 'Indexes.pas' {fmIndexes},
  Description in 'Description.pas' {fmDescription},
  Options in 'Options.pas' {fmOptions};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'IBUtils';
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TfmFindTable, fmFindTable);
  Application.CreateForm(TfmShowOptions, fmShowOptions);
  Application.CreateForm(TfmPrinterSetup, fmPrinterSetup);
  Application.HintPause := 150;
  Application.HintHidePause := 6000;
  Application.OnHint(nil);
//  Application.HintColor := clYellow;
  Application.Run;
end.

