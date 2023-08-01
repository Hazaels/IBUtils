unit AHeaderControl;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ComCtrls;

type
  TAHeaderControl = class(Theadercontrol)
  private
    { Private declarations }
  protected
    //procedure Paint; override;
  public
    { Public declarations }
  published
    property Color;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TAHeaderControl]);
end;

{ TAHeaderControl }

//procedure TAHeaderControl.Paint;
//begin
//  inherited;
//  Color := clRed;
//end;

end.

