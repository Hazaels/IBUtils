unit Options;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AKLabel, Placemnt;

type
  TfmOptions = class(TForm)
    AKLabel1: TAKLabel;
    btCancel: TButton;
    btOk: TButton;
    FormStorage: TFormStorage;
    GroupBox1: TGroupBox;
    chkLoadLastOpened: TCheckBox;
    chkKeepConnection: TCheckBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmOptions: TfmOptions;

implementation

{$R *.dfm}

procedure TfmOptions.FormCreate(Sender: TObject);
begin
  FormStorage.IniFileName := ExtractFilePath(Application.ExeName) + 'ibutils.ini';
end;

end.

