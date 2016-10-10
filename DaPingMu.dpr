program DaPingMu;

{%TogetherDiagram 'ModelSupport_DaPingMu\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_DaPingMu\uWordPlay\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_DaPingMu\uFrmPlayer\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_DaPingMu\uFrmSyConfig\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_DaPingMu\uFrmMainDaPingMu\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_DaPingMu\uFrmAbout\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_DaPingMu\uPlayConfig\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_DaPingMu\uPlayManager\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_DaPingMu\uGlobalDM\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_DaPingMu\DaPingMu\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_DaPingMu\uPlayConfigStrategy\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_DaPingMu\uFrmWindowSelect\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_DaPingMu\uBasePlay\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_DaPingMu\uPlayConfigOper\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_DaPingMu\default.txvpck'}
{%TogetherDiagram 'ModelSupport_DaPingMu\DaPingMu\default.txvpck'}

uses
  Forms,
  Windows,
  uTFSystem,
  SysUtils,
  uPlayConfig in '功能单元\系统配置\uPlayConfig.pas',
  uPlayConfigOper in '功能单元\系统配置\uPlayConfigOper.pas',
  uWordPlay in '功能单元\OLE播放\uWordPlay.pas',
  uBasePlay in '功能单元\OLE播放\uBasePlay.pas',
  uPlayManager in '功能单元\Ole管理类\uPlayManager.pas',
  uGlobalDM in 'uGlobalDM.pas' {GlobalDM: TDataModule},
  uFrmMainDaPingMu in 'uFrmMainDaPingMu.pas' {FrmMainDaPingMu},
  uFrmSyConfig in '功能窗体\系统配置\uFrmSyConfig.pas' {FrmSyConfig},
  uFrmPlayer in '功能窗体\播放窗体\uFrmPlayer.pas' {FrmPlayer},
  uPlayConfigStrategy in '功能单元\系统配置\uPlayConfigStrategy.pas',
  uFrmWindowSelect in '功能窗体\系统配置\选择播放\uFrmWindowSelect.pas' {FrmWindowSelect},
  uFrmAbout in '功能窗体\系统配置\关于\uFrmAbout.pas' {frmAbout};

{$R *.res}


var
  HMutex: DWord;

begin

  HMutex := CreateMutex(nil, TRUE, 'DaPingMu_86BB091E-5F86-4639-832D-1D85021F49A7'); //创建Mutex句柄
  {-----检测Mutex对象是否存在，如果存在，退出程序------------}
  if (GetLastError = ERROR_ALREADY_EXISTS) then
  begin
    ReleaseMutex(hMutex); //释放Mutex对象
    Exit;
  end;

  TimeSeparator := ':';
  DateSeparator := '-';
  ShortDateFormat := 'yyyy-mm-dd';
  ShortTimeFormat := 'hh:nn:ss';
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;

  Application.Title := '大屏幕播放工具';
  Application.Initialize;
  Application.CreateForm(TGlobalDM, GlobalDM);
  if not GlobalDM.InitData then
  begin
    BoxErr('检测到Word不存在,请先安装OFFICE');
    Exit;
  end;

  Application.CreateForm(TFrmMainDaPingMu, FrmMainDaPingMu);
  Application.Run;
end.

