unit Progress;

{$I IBUtils.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TfmProgress = class(TForm)
    Progress: TProgressBar;
    lbl: TLabel;
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public

  end;

var
  fmProgress: TfmProgress;

implementation

{$R *.dfm}

procedure TfmProgress.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := Params.ExStyle + WS_EX_TOPMOST;
  Params.Style := Params.Style - WS_CAPTION;
end;

end.
