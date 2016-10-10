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
    //��ʼ��
    function InitData():Boolean;
    //���ر���������Ϣ
    procedure LoadConfig;
    //���OFFice�Ƿ���� 
    function  IsExistOffice():Boolean;
    //���ӱ������ݿ�
    function ConnectLocalDB(strDatabase: WideString=''):Boolean;
    //��ʾ������
    procedure ShowTray();
    //����������
    procedure HideTray();
    //�����ͽ���
    procedure Lock();
    procedure UnLock();
    //////////��������/////////////
    {����������}
    procedure StartAuto(AppPath:string);
  public
    //�����б�
    property PlayConfigList:TPlayConfigList  read GetPlayConfigList;
  end;


var
  GlobalDM: TGlobalDM;
  G_strSysPath : String;//��ǰϵͳ·��
  G_strSysVersion : String;//��ǰϵͳ�汾��

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

  InitializeCriticalSection(m_cs);//��ʼ���ٽ���
end;

procedure TGlobalDM.DataModuleDestroy(Sender: TObject);
begin
  DeleteCriticalSection(m_cs);//ɾ���ٽ���
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
  wndHandle: THandle; //���ڴ洢ָ�����ڵľ��
begin
  wndHandle := FindWindow('Shell_TrayWnd',nil); //��ȡ���������ڵľ��
  //ShowWindow(wndHandle, SW_Hide); //����Windows������
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
      ;//raise Exception.Create('Word������:'+ e.Message);
    end;
  end;
end;

procedure TGlobalDM.LoadConfig;
begin
  m_PlayConfigOper.LoadFromFile;
end;



procedure TGlobalDM.Lock;
begin
  EnterCriticalSection(m_cs); //�����ٽ���
end;

procedure TGlobalDM.ShowTray;
var
  wndHandle: THandle; //���ڴ洢ָ�����ڵľ��
begin
  wndHandle := FindWindow('Shell_TrayWnd',nil); //��ȡ���������ڵľ��
  //ShowWindow(wndHandle, SW_SHOW); //����Windows������
end;

procedure TGlobalDM.StartAuto(AppPath: string);
begin
  SetExeAutoRun('����Ļ���Ź���',AppPath) ;
end;

procedure TGlobalDM.UnLock;
begin
  LeaveCriticalSection(m_cs); //�뿪�ٽ���
end;

end.
