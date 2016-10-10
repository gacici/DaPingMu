unit uFrmSyConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, utfSQLConn, AdvSpin, Mask, RzEdit, StdCtrls, AdvEdit, AdvPageControl,
  ComCtrls, ExtCtrls, RzPanel, Menus,uPlayConfig,uPlayConfigOper,uTFSystem,
  ImgList, PngImageList;


const
  INDEX_IMAGE_NORMAL = 0 ;
  INDEX_IMAGE_SELECTED = 1 ;
  IS_NEED_AUTO_SAVE = 1 ;

type
  TFrmSyConfig = class(TForm)
    advpgcntrl1: TAdvPageControl;
    ps1: TAdvTabSheet;
    pnWindow: TRzPanel;
    RzPanel1: TRzPanel;
    tvFrm: TTreeView;
    RzPanel2: TRzPanel;
    pnl1: TRzPanel;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    GroupBox1: TGroupBox;
    edt_B: TAdvEdit;
    lbl4: TLabel;
    edt_R: TAdvEdit;
    lbl3: TLabel;
    lbl1: TLabel;
    edt_x: TAdvEdit;
    lbl2: TLabel;
    edt_y: TAdvEdit;
    GroupBox3: TGroupBox;
    edtInterval: TAdvEdit;
    edtPath: TEdit;
    Label4: TLabel;
    lbl5: TLabel;
    Label3: TLabel;
    N3: TMenuItem;
    btnBrowser: TButton;
    btnXmlSave: TButton;
    chkIsEnable: TCheckBox;
    pngmglst1: TPngImageList;
    btnSystemFangAn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure tvFrmChange(Sender: TObject; Node: TTreeNode);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure btnBrowserClick(Sender: TObject);
    procedure btnXmlSaveClick(Sender: TObject);
    procedure chkIsEnableClick(Sender: TObject);
    procedure btnSystemFangAnClick(Sender: TObject);
  private
    //操作类
    m_PlayConfigOper: TPlayConfigOper ;
  private
    { Private declarations }
    //显示指定的CONFIG
    procedure ShowPlayConfig(PlayConfig : TPlayConfig );
    //初始化
    procedure InitData();
    //刷新界面
    procedure Refresh(Index:Integer);
    //保存
    procedure SaveConfig();
  public
    { Public declarations }
    class function EditConfig():Boolean;
  end;

var
  FrmSyConfig: TFrmSyConfig;

implementation

uses
  uFrmWindowSelect;

{$R *.dfm}



{ TFrmSyConfig }

procedure TFrmSyConfig.btnBrowserClick(Sender: TObject);
begin
  edtPath.Text := BrowseDialog('目录选择','c:\');
  SaveConfig ;
end;

procedure TFrmSyConfig.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel ;
end;

procedure TFrmSyConfig.btnSaveClick(Sender: TObject);
begin
  InitData;
end;

procedure TFrmSyConfig.btnSystemFangAnClick(Sender: TObject);
var
  nType : TPlayWindowType ;
begin
  if not TBox('是否采用系统内置方案,如果已有方案则会被删除') then
    exit ;
  if TFrmWindowSelect.GetWindowSel(nType) then
  begin
    m_PlayConfigOper.InitList(nType);
    InitData;
  end;
end;

procedure TFrmSyConfig.btnXmlSaveClick(Sender: TObject);
var
  PlayConfig : TPlayConfig ;
  index : Integer ;
begin
  index := -1 ;
  if tvFrm.Selected = nil then
  begin
    BoxErr('没有选中要修改的窗口');
    Exit ;
  end;
  PlayConfig := TPlayConfig (tvFrm.Selected.Data ) ;
  index := m_PlayConfigOper.List.IndexOf(PlayConfig) ;
  if index < 0 then
    Exit ;

  if not DirectoryExists(edtPath.Text) then
  begin
    BoxErr('播放路径不能为空');
    edtPath.SetFocus ;
    Exit;
  end;

  if  StrToInt(edtInterval.Text) <= 0 then
  begin
    BoxErr('播放间隔不能小于0');
    edtInterval.SetFocus ;
    Exit ;
  end;

    //获取数据
  with m_PlayConfigOper.List.Items[index] do
  begin
    rectForm.Left := StrToInt(edt_x.Text);
    rectForm.top := StrToInt(edt_y.Text);
    rectForm.Right := StrToInt(edt_R.Text);
    rectForm.Bottom := StrToInt(edt_B.Text);

    Path := edtPath.Text ;

    Interval := StrToInt(edtInterval.Text);
  end;
//保存
  m_PlayConfigOper.SaveToFile ;

  Box('保存成功!');
end;

procedure TFrmSyConfig.chkIsEnableClick(Sender: TObject);
var
  PlayConfig : TPlayConfig ;
  index : Integer ;
begin
  index := -1 ;
  if tvFrm.Selected = nil then
  begin
    BoxErr('没有选中要修改的窗口');
    Exit ;
  end;
  PlayConfig := TPlayConfig (tvFrm.Selected.Data ) ;
  index := m_PlayConfigOper.List.IndexOf(PlayConfig) ;
  if index < 0 then
    Exit ;
  //获取数据
  m_PlayConfigOper.List.Items[index].Enabled := chkIsEnable.Checked ;
  //保存
  m_PlayConfigOper.SaveToFile ;
end;

class function TFrmSyConfig.EditConfig:Boolean;
var
  frm : TFrmSyConfig ;
begin
  Result := False ;
  frm := TFrmSyConfig.Create(nil);
  try
    frm.InitData;
    if frm.ShowModal = mrOk then
    begin
      Result := True ;
    end;
  finally
    frm.Free;
  end;

end;



procedure TFrmSyConfig.FormCreate(Sender: TObject);
begin
  m_PlayConfigOper := TPlayConfigOper.Create(Screen.Width,Screen.Height);
end;

procedure TFrmSyConfig.FormDestroy(Sender: TObject);
begin
  m_PlayConfigOper.Free;
end;

procedure TFrmSyConfig.FormShow(Sender: TObject);
var
  i:Integer;
begin
  for i := 0 to advpgcntrl1.PageCount - 1 do
  begin
    advpgcntrl1.Pages[i].TabVisible := False;
  end;
end;

procedure TFrmSyConfig.InitData();
var
  i : Integer ;
  node : TTreeNode ;
  PlayConfig : TPlayConfig ;
begin
  tvFrm.Items.Clear;
  m_PlayConfigOper.LoadFromFile;

  for I := 0 to m_PlayConfigOper.List.Count - 1 do
  begin
    PlayConfig   := m_PlayConfigOper.List.Items[i];
    node := tvFrm.Items.Add(nil,PlayConfig.Name);
    node.ImageIndex := INDEX_IMAGE_NORMAL ;
    node.SelectedIndex := INDEX_IMAGE_SELECTED ;
    node.Data :=  PlayConfig ;
    if i = 0 then
    begin
      node.Selected := True ;
    end;
  end;
end;

procedure TFrmSyConfig.N1Click(Sender: TObject);
var
  node : TTreeNode ;
  strName : string ;
  PlayConfig : TPlayConfig ;
begin
  if not InputQuery('提示', '请输入窗口名称：', strName) then Exit;

  node := tvFrm.Items.Add(nil,strName);
  PlayConfig :=  TPlayConfig.Create; ;
  PlayConfig.Name := strName ;
  m_PlayConfigOper.List.Add(PlayConfig);
  m_PlayConfigOper.SaveToFile ;
  node.Data := PlayConfig ;
  node.Selected := True;

end;

procedure TFrmSyConfig.N2Click(Sender: TObject);
var
  PlayConfig : TPlayConfig ;
begin
  if tvFrm.Selected = nil then
  begin
    BoxErr('没有选中要删除的窗口');
    Exit ;
  end;
  PlayConfig :=  TPlayConfig (tvFrm.Selected.Data ) ;
  if not TBox('确认删除该窗口吗?') then
    exit ;
  tvFrm.Selected.Delete ;
  m_PlayConfigOper.List.Remove(PlayConfig);
  m_PlayConfigOper.SaveToFile ;

  InitData ;
end;

procedure TFrmSyConfig.N3Click(Sender: TObject);
var
  node : TTreeNode ;
  strName : string ;
  PlayConfig : TPlayConfig ;
begin
  if tvFrm.Selected = nil then
    Exit ;
  PlayConfig :=  TPlayConfig (tvFrm.Selected.Data ) ;
  strName := PlayConfig.Name ;
  if not InputQuery('提示', '请输入窗口名称：', strName) then Exit;

  PlayConfig.Name := strName  ;
  m_PlayConfigOper.SaveToFile ;

  
  tvFrm.Selected.Text := strName ;

  btnSaveClick(Sender);
end;

procedure TFrmSyConfig.Refresh(Index: Integer);
begin
  ;
end;



procedure TFrmSyConfig.SaveConfig;
var
  PlayConfig : TPlayConfig ;
  index : Integer ;
begin
  index := -1 ;
  if tvFrm.Selected = nil then
  begin
    Exit ;
  end;
  PlayConfig := TPlayConfig (tvFrm.Selected.Data ) ;
  index := m_PlayConfigOper.List.IndexOf(PlayConfig) ;
  if index < 0 then
    Exit ;


  if not DirectoryExists(edtPath.Text) then
  begin
    BoxErr('播放路径不能为空');
    edtPath.SetFocus ;
    Exit;
  end;

  if  StrToInt(edtInterval.Text) <= 0 then
  begin
    BoxErr('播放间隔不能小于0');
    edtInterval.SetFocus ;
    Exit ;
  end;

    //获取数据
  with m_PlayConfigOper.List.Items[index] do
  begin
    rectForm.Left := StrToInt(edt_x.Text);
    rectForm.top := StrToInt(edt_y.Text);
    rectForm.Right := StrToInt(edt_R.Text);
    rectForm.Bottom := StrToInt(edt_B.Text);

    Path := edtPath.Text ;

    Interval := StrToInt(edtInterval.Text);
  end;
//保存
  m_PlayConfigOper.SaveToFile ;
end;

procedure TFrmSyConfig.ShowPlayConfig(PlayConfig: TPlayConfig);
begin

  edt_x.Text := IntToStr( PlayConfig.rectForm.left  );
  edt_y.Text := IntToStr( PlayConfig.rectForm.top  );

  edt_R.Text := IntToStr( PlayConfig.rectForm.Right  );
  edt_B.Text := IntToStr( PlayConfig.rectForm.Bottom  );

  edtPath.Text := PlayConfig.Path ;
  edtInterval.Text := IntToStr(PlayConfig.Interval);

  chkIsEnable.Checked := PlayConfig.Enabled ;

end;

procedure TFrmSyConfig.tvFrmChange(Sender: TObject; Node: TTreeNode);
var
  PlayConfig : TPlayConfig ;
begin
  if tvFrm.Selected = nil then
    Exit ;
  PlayConfig := TPlayConfig (tvFrm.Selected.Data ) ;
  ShowPlayConfig(PlayConfig);
  pnWindow.Caption := PlayConfig.Name ;
end;

end.
