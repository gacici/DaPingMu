unit uFrmAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ActnList, jpeg;

type
  TfrmAbout = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    lblVersion: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    btnClose: TSpeedButton;
    ActionList1: TActionList;
    actEsc: TAction;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure actEscExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class procedure ShowAbout();
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.dfm}
//获取版本号
function GetBuildInfo: string;
var
  verinfosize : DWORD;
  verinfo : pointer;
  vervaluesize : dword;
  vervalue : pvsfixedfileinfo;
  dummy : dword;
  v1,v2,v3,v4 : word;
begin
  verinfosize := getfileversioninfosize(pchar(paramstr(0)),dummy);
  if verinfosize = 0 then
  begin
    dummy := getlasterror;
    result := '0.0.0.0';
  end;
  getmem(verinfo,verinfosize);
  getfileversioninfo(pchar(paramstr(0)),0,verinfosize,verinfo);
  verqueryvalue(verinfo,'\',pointer(vervalue),vervaluesize);
  with vervalue^ do
  begin
    v1 := dwfileversionms shr 16;
    v2 := dwfileversionms and $ffff;
    v3 := dwfileversionls shr 16;
    v4 := dwfileversionls and $ffff;
  end;
  result := inttostr(v1) + '.' + inttostr(v2) + '.' + inttostr(v3) + '.' + inttostr(v4);
  freemem(verinfo,verinfosize);
end;
procedure TfrmAbout.actEscExecute(Sender: TObject);
begin
  btnClose.Click;
end;

procedure TfrmAbout.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  lblVersion.Caption := Format('版本号：%s',[GetBuildInfo]);
end;

class procedure TfrmAbout.ShowAbout;
var
  frmAbout : TfrmAbout;
begin
  frmAbout := TfrmAbout.Create(nil);
  try
    frmAbout.ShowModal ;  
  finally
    frmAbout.Free;
  end;

end;

end.
