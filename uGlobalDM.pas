unit uGlobalDM;

interface

uses
  SysUtils,StrUtils, Classes,Forms,Windows,registry,IniFiles,uTFSystem,
  DB, ADODB,uPlayConfig,uPlayConfigOper,ComObj;

type
  TGlobalDM = class(TDataModule)
    LocalADOConnection: TADOConnection;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    m_cs:TRTLCriticalSection;
    m_PlayConfigOper: TPlayConfigOper ;
  private
    { Private declarations }
    function GetAppPath: string;
    function GetPlayConfigList():TPlayConfigList;
  public
    //初始化
    function InitData():Boolean;
    //加载本地配置信息
    procedure LoadConfig;
    //检测OFFice是否存在 
    function  IsExistOffice():Boolean;
    //连接本地数据库
    function ConnectLocalDB(strDatabase: WideString=''):Boolean;
    //显示任务栏
    procedure ShowTray();
    //隐藏任务栏
    procedure HideTray();
    //加锁和解锁
    procedure Lock();
    procedure UnLock();
    //////////公共函数/////////////
    {程序自启动}
    procedure StartAuto(AppPath:string);
  public
    //配置列表
    property PlayConfigList:TPlayConfigList  read GetPlayConfigList;
  end;


var
  GlobalDM: TGlobalDM;
  G_strSysPath : String;//当前系统路径
  G_strSysVersion : String;//当前系统版本号

implementation

{$R *.dfm}

{ TGlobalDM }


function TGlobalDM.ConnectLocalDB(strDatabase: WideString): Boolean;
var
  strConnection: string;
begin
  result := false;
  if LocalADOConnection.Connected then LocalADOConnection.Connected := false;

  if strDatabase = '' then strDatabase := ExtractFilePath(Application.ExeName)+'FileTransmit.mdb';
  strConnection := 'Provider=Microsoft.Jet.OLEDB.4.0;Persist Security Info=False;Data Source='+strDatabase+';User Id=admin;Jet OLEDB:Database Password=thinkfreely;';
  try
    LocalADOConnection.Close;
    LocalADOConnection.ConnectionString := strConnection;
    LocalADOConnection.Open;
  except
  end;
  if LocalADOConnection.Connected then
    result := true;
end;

procedure TGlobalDM.DataModuleCreate(Sender: TObject);
begin
  G_strSysPath := ExtractFileDir(Application.ExeName)+'\';
  G_strSysVersion := GetFileVersion(Application.ExeName);

  m_PlayConfigOper := TPlayConfigOper.Create(Screen.Width,Screen.Height);
  m_PlayConfigOper.LoadFromFile;

  InitializeCriticalSection(m_cs);//初始化临界区
end;

procedure TGlobalDM.DataModuleDestroy(Sender: TObject);
begin
  DeleteCriticalSection(m_cs);//删除临界区
  m_PlayConfigOper.Free ;;
end;

function TGlobalDM.GetAppPath: string;
begin
   Result := ExtractFilePath(Application.ExeName)
end;


function TGlobalDM.GetPlayConfigList: TPlayConfigList;
begin
  m_PlayConfigOper.List.Clear;
  m_PlayConfigOper.LoadFromFile ;
  Result := m_PlayConfigOper.List ;
end;


procedure TGlobalDM.HideTray;
var
  wndHandle: THandle; //用于存储指定窗口的句柄
begin
  wndHandle := FindWindow('Shell_TrayWnd',nil); //获取任务栏窗口的句柄
  //ShowWindow(wndHandle, SW_Hide); //隐藏Windows任务栏
end;

function TGlobalDM.InitData: Boolean;
begin
  LoadConfig;
  Result := IsExistOffice ;
end;

function TGlobalDM.IsExistOffice: Boolean;
begin
  Result := False ;
  try
    HideTray;
    Result := True ;
  except
    on e:Exception do
    begin
      ;//raise Exception.Create('Word不存在:'+ e.Message);
    end;
  end;
end;

procedure TGlobalDM.LoadConfig;
begin
  m_PlayConfigOper.LoadFromFile;
end;



procedure TGlobalDM.Lock;
begin
  EnterCriticalSection(m_cs); //进入临界区
end;

procedure TGlobalDM.ShowTray;
var
  wndHandle: THandle; //用于存储指定窗口的句柄
begin
  wndHandle := FindWindow('Shell_TrayWnd',nil); //获取任务栏窗口的句柄
  //ShowWindow(wndHandle, SW_SHOW); //隐藏Windows任务栏
end;

procedure TGlobalDM.StartAuto(AppPath: string);
begin
  SetExeAutoRun('大屏幕播放工具',AppPath) ;
end;

procedure TGlobalDM.UnLock;
begin
  LeaveCriticalSection(m_cs); //离开临界区
end;

end.
