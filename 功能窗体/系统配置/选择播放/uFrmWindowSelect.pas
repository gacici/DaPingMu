unit uFrmWindowSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,uPlayConfig;

type
  TFrmWindowSelect = class(TForm)
    GroupBox1: TGroupBox;
    rbOne: TRadioButton;
    rbTwo: TRadioButton;
    rbFour: TRadioButton;
    rbSix: TRadioButton;
    rbUser: TRadioButton;
    btnOk: TButton;
    btnCancel: TButton;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    {获取结果}
    function GetData():TPlayWindowType;
    {检查输入条件}
    function CheckInput():Boolean;
  public
    { Public declarations }
    class function GetWindowSel(var AType:TPlayWindowType):Boolean;
  end;

var
  FrmWindowSelect: TFrmWindowSelect;

implementation

{$R *.dfm}

procedure TFrmWindowSelect.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel ;
end;

procedure TFrmWindowSelect.btnOkClick(Sender: TObject);
begin
  if not CheckInput then
    exit ;
  ModalResult := mrOk ;
end;

function TFrmWindowSelect.CheckInput: Boolean;
begin
  Result := False ;
  Result := True ;
end;

procedure TFrmWindowSelect.FormCreate(Sender: TObject);
begin
  rbUser.Checked := True ;
end;

function TFrmWindowSelect.GetData: TPlayWindowType;
begin
  if rbOne.Checked then
  begin
    Result := pwOne ;
    Exit;
  end;

  if rbTwo.Checked then
  begin
    Result := pwTwo ;
    Exit;
  end;

  if rbFour.Checked then
  begin
    Result := pwFour ;
    Exit;
  end;

  if rbSix.Checked then
  begin
    Result := pwSix ;
    Exit;
  end;

  if rbUser.Checked then
  begin
    Result := pwUser ;
    Exit;
  end;
end;

class function TFrmWindowSelect.GetWindowSel(
  var AType: TPlayWindowType): Boolean;
var
  frm : TFrmWindowSelect ;
begin
  frm := TFrmWindowSelect.Create(nil);
  try
    if frm.ShowModal = mrOk then
    begin
      AType := frm.GetData;
      Result := True ;
    end;
  finally
    frm.Free;
  end;
end;

end.
