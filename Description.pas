unit Description;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AKLabel, Placemnt;

type
  TfmDescription = class(TForm)
    lblTitle: TAKLabel;
    meDesc: TMemo;
    btOk: TButton;
    btCancel: TButton;
    FormStorage: TFormStorage;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  fmDescription: TfmDescription;

implementation

{$R *.dfm}

{ TfmDescription }

constructor TfmDescription.Create(AOwner: TComponent);
begin
  inherited;
  FormStorage.IniFileName := ExtractFilePath(Application.ExeName) + 'ibutils.ini';
end;
//=============================================================================

procedure TfmDescription.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE: ModalResult := mrCancel;
  end;
end;
//=============================================================================

end.
