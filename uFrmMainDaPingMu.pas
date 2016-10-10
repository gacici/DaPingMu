unit uFrmMainDaPingMu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, Grids, Menus, uTFSystem, RzTray, uFrmPlayer,
  Buttons, PngSpeedButton, ActnList, RzStatus, XPMan, AdvMenus, AdvMenuStylers;

type
  TFrmMainDaPingMu = class(TForm)
    TrayIcon: TRzTrayIcon;
    RzPanel1: TRzPanel;
    btnStop: TPngSpeedButton;
    btnStart: TPngSpeedButton;
    actlst1: TActionList;
    actStart: TAction;
    actEnd: TAction;
    StatusBar1: TRzStatusBar;
    StatusPane1: TRzStatusPane;
    actSetUP: TAction;
    actClose: TAction;
    timer2: TTimer;
    xpmnfst1: TXPManifest;
    btnClose: TPngSpeedButton;
    btnStart1: TPngSpeedButton;
    bvl1: TBevel;
    advmnmn1: TAdvMainMenu;
    mniN2: TMenuItem;
    mniStart2: TMenuItem;
    mniClose2: TMenuItem;
    mniN3: TMenuItem;
    mniN4: TMenuItem;
    mniN5: TMenuItem;
    mniStart3: TMenuItem;
    mniEnd2: TMenuItem;
    MenuOfficeStyler1: TAdvMenuOfficeStyler;
    advpmn1: TAdvPopupMenu;
    mniStart1: TMenuItem;
    mniEnd1: TMenuItem;
    mniN1: TMenuItem;
    mniSetUP1: TMenuItem;
    mniClose1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure E1Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure actStartExecute(Sender: TObject);
    procedure actEndExecute(Sender: TObject);
    procedure actSetUPExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure timer2Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure mniN5Click(Sender: TObject);
  private
    {功能:拦截CMD消息}
    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;
    {功能:拦截关机消息}
    procedure WMQueryEndSession(var Message: TMessage); message WM_QUERYENDSESSION;
    {功能:窗体自动吸附}
    procedure WMWINDOWPOSCHANGING(var Msg: TWMWINDOWPOSCHANGING); message WM_WINDOWPOSCHANGING;
  private
    {开始播放}
    procedure StartPlay();
    {关闭播放}
    procedure StopPlay();
    {释放播放器}
    procedure FreePlayer();
  private
    { Private declarations }
    {播放器数组}
    m_FrmPlayerArray: TFrmPlayerArray;
    {是否关闭程序}
    m_bIsClose: Boolean;
  end;

var
  FrmMainDaPingMu: TFrmMainDaPingMu;

implementation

uses
  uFrmSyConfig, uGlobalDM, uFrmAbout;

{$R *.dfm}

procedure TFrmMainDaPingMu.actCloseExecute(Sender: TObject);
begin
  if TBox('确认退出吗?') then
  begin
    m_bIsClose := True;
    Close;
  end;
end;

procedure TFrmMainDaPingMu.actEndExecute(Sender: TObject);
begin
  StopPlay;
end;

procedure TFrmMainDaPingMu.actSetUPExecute(Sender: TObject);
begin
  TFrmSyConfig.EditConfig;
end;

procedure TFrmMainDaPingMu.actStartExecute(Sender: TObject);
begin
  StartPlay;
end;

procedure TFrmMainDaPingMu.E1Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmMainDaPingMu.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if m_bIsClose = False then
  begin
    Action := caNone;
    TrayIcon.MinimizeApp;
    Exit;
  end;
end;

procedure TFrmMainDaPingMu.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if m_bIsClose = False then
  begin
    CanClose := False;
  end;
end;

procedure TFrmMainDaPingMu.FormCreate(Sender: TObject);
begin
  btnStart.Enabled := True;
  btnStop.Enabled := False;
end;

procedure TFrmMainDaPingMu.FormDestroy(Sender: TObject);
begin
  //GlobalDM.StartAuto(Application.ExeName)   ;
  GlobalDM.ShowTray;
  FreePlayer;
end;

procedure TFrmMainDaPingMu.FreePlayer;
var
  i: Integer;
  nCount: Integer;
begin

  nCount := Length(m_FrmPlayerArray);
  for I := 0 to nCount - 1 do
  begin
    if not m_FrmPlayerArray[i].IsClosed then
    begin
      m_FrmPlayerArray[i].EndPlay;
      m_FrmPlayerArray[i].Free;
    end;
  end;
end;

procedure TFrmMainDaPingMu.mniN5Click(Sender: TObject);
begin
  TfrmAbout.ShowAbout;
end;

procedure TFrmMainDaPingMu.N2Click(Sender: TObject);
begin
  TFrmSyConfig.EditConfig;
end;

procedure TFrmMainDaPingMu.N6Click(Sender: TObject);
begin
  StartPlay;
end;

procedure TFrmMainDaPingMu.StartPlay;
var
  strText: string;
  nCount: Integer;
  i, j: Integer;
begin
  j := 0;
  StopPlay;
  SetLength(m_FrmPlayerArray, 0);
  nCount := GlobalDM.PlayConfigList.Count;
  for I := 0 to nCount - 1 do
  begin
    if GlobalDM.PlayConfigList.Items[i].Enabled then
    begin

      if GlobalDM.PlayConfigList.Items[i].Path = '' then
      begin
        strText := Format('播放窗口: %s 路径为空，请检查配置', [GlobalDM.PlayConfigList.Items[i].Name]);
        BoxErr(strText);
        Continue;
      end;

      if not DirectoryExists(GlobalDM.PlayConfigList.Items[i].Path) then
      begin
        strText := Format('播放窗口: %s 路径不存在，请检查配置', [GlobalDM.PlayConfigList.Items[i].Name]);
        BoxErr(strText);
        Continue;
      end;

      SetLength(m_FrmPlayerArray, Length(m_FrmPlayerArray) + 1);
      j := Length(m_FrmPlayerArray) - 1;
      m_FrmPlayerArray[j] := TFrmPlayer.Create(nil);
      m_FrmPlayerArray[j].InitData(GlobalDM.PlayConfigList.Items[i]);
      m_FrmPlayerArray[j].Show;
      m_FrmPlayerArray[j].StartPlay ;
    end;
  end;

  btnStart.Enabled := False;
  btnStop.Enabled := True;

end;

procedure TFrmMainDaPingMu.StopPlay;
var
  i: Integer;
  nCount: Integer;
begin
  try
    nCount := Length(m_FrmPlayerArray);
    for I := 0 to nCount - 1 do
    begin
      if not m_FrmPlayerArray[i].IsClosed then
      begin
        m_FrmPlayerArray[i].EndPlay;
        m_FrmPlayerArray[i].Free;
      end;
    end;
  except
    on e: Exception do
    begin
      ShowMessage(e.Message);
    end;
  end;
  btnStop.Enabled := False;
  btnStart.Enabled := True;
end;

procedure TFrmMainDaPingMu.timer2Timer(Sender: TObject);
begin
  if System.DebugHook = 0 then
  begin
    timer2.Enabled := False;
    TrayIcon.MinimizeApp;
    actStartExecute(Sender);
  end;
end;

procedure TFrmMainDaPingMu.WMQueryEndSession(var Message: TMessage);
begin
  m_bIsClose := True;
end;

procedure TFrmMainDaPingMu.WMSysCommand(var Message: TWMSysCommand);
begin
  with Message do
  begin
    if CmdType and $FFF0 = SC_MINIMIZE then
      ShowWindow(Handle, SW_MINIMIZE)
    else
      inherited;
  end;
end;

procedure TFrmMainDaPingMu.WMWINDOWPOSCHANGING(var Msg: TWMWINDOWPOSCHANGING);
var
  Docked: Boolean;
  rWorkArea: TRect;
  StickAt: Word;
begin
  Docked := False;
  StickAt := 10;
  SystemParametersInfo(SPI_GETWORKAREA, 0, @rWorkArea, 0);
  with Msg.WindowPos^do
  begin
    if true then
      if x <= rWorkArea.Left + StickAt then
      begin
        x := rWorkArea.Left;
        Docked := TRUE;
      end;
    if true then
      if x + cx >= rWorkArea.Right - StickAt then
      begin
        x := rWorkArea.Right - cx;
        Docked := TRUE;
      end;
    if true then
      if y <= rWorkArea.Top + StickAt then
      begin
        y := rWorkArea.Top;
        Docked := TRUE;
      end;
    if true then
      if y + cy >= rWorkArea.Bottom - StickAt then
      begin
        y := rWorkArea.Bottom - cy;
        Docked := TRUE;
      end;
    if Docked then
    begin
      with rWorkArea do
      begin
      // no moving out of the screen
        if x < Left then
          x := Left;
        if x + cx > Right then
          x := Right - cx;
        if y < Top then
          y := Top;
        if y + cy > Bottom then
          y := Bottom - cy;
      end; {with rWorkArea}
    end;
  end;
  inherited;
end;

end.

