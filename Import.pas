unit Import;

{$I IBUtils.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IB_Import, StdCtrls, IB_Components;

type
  TfmImport = class(TForm)
    Import: TIB_Import;
    btStart: TButton;
    cnImport: TIB_Connection;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btStartClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmImport: TfmImport;

implementation

uses MAIN;

{$R *.dfm}

procedure TfmImport.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;
//============================================================================

procedure TfmImport.btStartClick(Sender: TObject);
begin
  Import.Execute;
end;
//============================================================================

end.
