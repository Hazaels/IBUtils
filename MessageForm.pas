unit MessageForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TfmMessage = class(TForm)
    Panel: TPanel;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;

var
  fmMessage: TfmMessage;

implementation

procedure TfmMessage.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := Params.ExStyle + WS_EX_TOPMOST;
  Params.Style := Params.Style - WS_CAPTION;
end;

{$R *.dfm}

end.
