unit About;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfmAbout = class(TForm)
    btOk: TButton;
    Label1: TLabel;
    lblVerzeAplikace: TLabel;
    Label3: TLabel;
    lblMail: TLabel;
    lblWeb: TLabel;
    Bevel1: TBevel;
    Image1: TImage;
    Label4: TLabel;
    Label5: TLabel;
    procedure lblMailClick(Sender: TObject);
    procedure lblWebClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Label5Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    procedure GetVersion;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmAbout: TfmAbout;

implementation

{$R *.dfm}

uses ShellApi;

procedure TfmAbout.lblMailClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', 'mailto:akahanek@seznam.cz', '', '', SW_NORMAL);
end;
//============================================================================

procedure TfmAbout.lblWebClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', 'http://www.riverdata.cz/ibutils/ibutils.htm', '', '', SW_NORMAL);
end;
//============================================================================

procedure TfmAbout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;
//============================================================================

procedure TfmAbout.Label5Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', 'mailto:kambiz@delphiarea.com', '', '', SW_NORMAL);
end;
//============================================================================

procedure TfmAbout.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;
//============================================================================

procedure TfmAbout.GetVersion;
const
  InfoNum = 1;
  InfoStr: array[1..InfoNum] of string = ('FileVersion');
var
  S, A: string;
  n, Len, i: DWORD;
  Buf: PChar;
  Value: PChar;
begin
  S := Application.ExeName;
  n := GetFileVersionInfoSize(PChar(S), n);
  if n > 0 then
  begin
    Buf := AllocMem(n);
    GetFileVersionInfo(PChar(S), 0, n, Buf);
    for i := 1 to InfoNum do
      if VerQueryValue(Buf, PChar('StringFileInfo\040504E2\' + InfoStr[i]), Pointer(Value), Len) then
    FreeMem(Buf, n);
  end;
  lblVerzeAplikace.Caption := StrPas(Value);
end;
//=============================================================================

procedure TfmAbout.FormCreate(Sender: TObject);
begin
  GetVersion;
end;
//=============================================================================

end.

