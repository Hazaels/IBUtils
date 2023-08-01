unit ShowOptions;

{$I IBUtils.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AKLabel, ComCtrls, ExtCtrls, Mask, ToolEdit;

type
  TfmShowOptions = class(TForm)
    btCancel: TButton;
    btOk: TButton;
    pgMain: TPageControl;
    tsGeneral: TTabSheet;
    gbShowOptions: TGroupBox;
    chkTypes: TCheckBox;
    chkDomains: TCheckBox;
    chkRequired: TCheckBox;
    chkIcons: TCheckBox;
    chkKeysOnly: TCheckBox;
    chkComputedBy: TCheckBox;
    AKLabel1: TAKLabel;
    edModelTitle: TEdit;
    tsAddTable: TTabSheet;
    AKLabel2: TAKLabel;
    Label1: TLabel;
    chkHeader: TCheckBox;
    moTablesFilter: TMemo;
    Label6: TLabel;
    edDatabase: TFilenameEdit;
    edDefColCount: TEdit;
    Label7: TLabel;
    udDefColCount: TUpDown;
    edPassword: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    edUsername: TEdit;
    chkIndexCount: TCheckBox;
    tsColors: TTabSheet;
    AKLabel3: TAKLabel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    cmbLinkColorSelected: TColorBox;
    cmbLinkColorDefault: TColorBox;
    cmbLinkColorFocused: TColorBox;
    cmbLinkColorCustom: TColorBox;
    AKLabel4: TAKLabel;
    gbGrid: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    chkSnapToGrid: TCheckBox;
    edGridX: TEdit;
    edGridY: TEdit;
    udGridX: TUpDown;
    udGridY: TUpDown;
    chkSnapRelToGrid: TCheckBox;
    chkShowGrid: TCheckBox;
    chkShowSystemDomains: TCheckBox;
    chkCombinedTypeDomain: TCheckBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmShowOptions: TfmShowOptions;

implementation

{$R *.dfm}

procedure TfmShowOptions.FormCreate(Sender: TObject);
begin
  pgMain.ActivePageIndex := 0;
end;

end.
