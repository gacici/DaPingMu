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
  uPlayConfig in '���ܵ�Ԫ\ϵͳ����\uPlayConfig.pas',
  uPlayConfigOper in '���ܵ�Ԫ\ϵͳ����\uPlayConfigOper.pas',
  uWordPlay in '���ܵ�Ԫ\OLE����\uWordPlay.pas',
  uBasePlay in '���ܵ�Ԫ\OLE����\uBasePlay.pas',
  uPlayManager in '���ܵ�Ԫ\Ole������\uPlayManager.pas',
  uGlobalDM in 'uGlobalDM.pas' {GlobalDM: TDataModule},
  uFrmMainDaPingMu in 'uFrmMainDaPingMu.pas' {FrmMainDaPingMu},
  uFrmSyConfig in '���ܴ���\ϵͳ����\uFrmSyConfig.pas' {FrmSyConfig},
  uFrmPlayer in '���ܴ���\���Ŵ���\uFrmPlayer.pas' {FrmPlayer},
  uPlayConfigStrategy in '���ܵ�Ԫ\ϵͳ����\uPlayConfigStrategy.pas',
  uFrmWindowSelect in '���ܴ���\ϵͳ����\ѡ�񲥷�\uFrmWindowSelect.pas' {FrmWindowSelect},
  uFrmAbout in '���ܴ���\ϵͳ����\����\uFrmAbout.pas' {frmAbout};

{$R *.res}


var
  HMutex: DWord;

begin

  HMutex := CreateMutex(nil, TRUE, 'DaPingMu_86BB091E-5F86-4639-832D-1D85021F49A7'); //����Mutex���
  {-----���Mutex�����Ƿ���ڣ�������ڣ��˳�����------------}
  if (GetLastError = ERROR_ALREADY_EXISTS) then
  begin
    ReleaseMutex(hMutex); //�ͷ�Mutex����
    Exit;
  end;

  TimeSeparator := ':';
  DateSeparator := '-';
  ShortDateFormat := 'yyyy-mm-dd';
  ShortTimeFormat := 'hh:nn:ss';
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;

  Application.Title := '����Ļ���Ź���';
  Application.Initialize;
  Application.CreateForm(TGlobalDM, GlobalDM);
  if not GlobalDM.InitData then
  begin
    BoxErr('��⵽Word������,���Ȱ�װOFFICE');
    Exit;
  end;

  Application.CreateForm(TFrmMainDaPingMu, FrmMainDaPingMu);
  Application.Run;
end.

