unit uFrmPlayer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uTFSystem, uPlayConfig, OleCtnrs, ActnList, Menus, ExtCtrls,
  StdCtrls, ActiveX, ComObj, ComCtrls,uBasePlay,uWordPlay,uPlayManager;

type
  TProcedureEvent = procedure() of object;

  TUPDateThread = class(TThread)
  public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy(); override;
  public
    procedure Execute; override;
  public
    procedure Stop();
    procedure Continue();
  private
    m_hExit: THandle;
    m_OnExecute: TProcedureEvent;
    m_nInterval: Integer;
  public
    property OnExecute: TProcedureEvent read m_OnExecute write m_OnExecute;
    property Interval: Integer read m_nInterval write m_nInterval;
  end;

  TFrmPlayer = class(TForm)
    PopupMenu1: TPopupMenu;
    ActionList1: TActionList;
    actPlay: TAction;
    actPause: TAction;
    actStop: TAction;
    actLoad: TAction;
    mniPlay: TMenuItem;
    mniStop: TMenuItem;
    mniLoad: TMenuItem;
    OleContainer1: TOleContainer;
    mniN1: TMenuItem;
    actClose: TAction;
    mniClose: TMenuItem;
    procedure FormDestroy(Sender: TObject);
    procedure actPlayExecute(Sender: TObject);
    procedure actStopExecute(Sender: TObject);
    procedure actLoadExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormMouseEnter(Sender: TObject);
    procedure FormMouseLeave(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
  private
    //移动窗口到指定的位置
    procedure MoveWindowPos(Rect: TRect);
  private
    //配置列表
    m_PlayConfig: TPlayConfig;
    //播放
    m_olePlay: TBasePlay;
    { wordAPP不能放到线程创建 }
    m_wordapp: Variant;
    //更新线程
    m_UPDateThread: TUPDateThread;
    //是否关闭
    m_bIsClose: Boolean;
    //
    m_bIsFullScreen: Boolean;
  private
    { Public declarations }
    //执行播放
    procedure DoWork();
    //初始化OLE
    procedure InitOle();
    //释放OLE
    procedure ReleaseOle();
    {日志输出}
    procedure InsertLogs(strLogText: string; AIndex, ACount: Integer);
  public
    //设置配置
    function InitData(PlayConfig: TPlayConfig):Boolean;
    {功能:开始数据}
    procedure StartPlay();
    {功能:结束数据}
    procedure EndPlay();
    {功能:暂停数据同步}
    procedure PausePlay();
    {功能:重新加载}
    procedure ReLoad();
    {是否已经关闭}
    function IsClosed(): Boolean;
  end;

  TFrmPlayerArray = array of TFrmPlayer;




var
  FrmPlayer: TFrmPlayer;

implementation
{$R *.dfm}

uses
  uGlobalDM;


var
    m_cs:TRTLCriticalSection;
procedure Lock;
begin
  EnterCriticalSection(m_cs);
end;

procedure UnLock;
begin
  LeaveCriticalSection(m_cs);
end;


procedure TFrmPlayer.actCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmPlayer.actLoadExecute(Sender: TObject);
begin
  ReLoad;
end;

procedure TFrmPlayer.actPlayExecute(Sender: TObject);
begin
  StartPlay;
end;

procedure TFrmPlayer.actStopExecute(Sender: TObject);
begin
  EndPlay;
end;

procedure TFrmPlayer.DoWork();
begin
  m_olePlay.PlayLoop;
end;

procedure TFrmPlayer.EndPlay;
var
  IsQuit : Boolean;
  dwExitCode : DWORD ;
begin
  if Assigned(m_UPDateThread) then
  begin
    m_UPDateThread.Stop();
    m_UPDateThread.Free;
    m_UPDateThread := nil;
  end;
end;

procedure TFrmPlayer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not TBox('是否确认关闭?') then
    exit;
  Action := caFree;
end;

procedure TFrmPlayer.FormCreate(Sender: TObject);
begin
  //FormStyle := fsStayOnTop ;
  Self.BorderStyle := bsNone;
  m_bIsFullScreen := True;

    //初始化OLE
  InitOle();
  m_bIsClose := False;
  m_PlayConfig := TPlayConfig.Create;
  m_olePlay := TWordPlay.Create(OleContainer1, m_wordapp);
  m_olePlay.LogOutPut := InsertLogs;
end;

procedure TFrmPlayer.FormDblClick(Sender: TObject);
begin
  m_bIsFullScreen := not m_bIsFullScreen;
  if m_bIsFullScreen then
    Self.BorderStyle := bsNone
  else
    Self.BorderStyle := bsSizeToolWin;
end;

procedure TFrmPlayer.FormDestroy(Sender: TObject);
begin
  ReleaseOle;

  EndPlay;

  m_bIsClose := True;
  m_olePlay.Free;
  m_PlayConfig.Free;

end;

procedure TFrmPlayer.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  //发送系统消息，通知窗口标题栏被按下，之后就可以拖了
  SendMessage(Handle, WM_SYSCOMMAND, $F012, 0);
end;

procedure TFrmPlayer.FormMouseEnter(Sender: TObject);
begin
  Exit;
  if Self.BorderStyle <> bsSizeToolWin then
    Self.BorderStyle := bsSizeToolWin;
end;

procedure TFrmPlayer.FormMouseLeave(Sender: TObject);
begin
  Exit;
  if Self.BorderStyle <> bsNone then
    Self.BorderStyle := bsNone;
end;

procedure TFrmPlayer.FormShow(Sender: TObject);
begin
  if System.DebugHook = 0 then
  begin
   SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
  end;
end;

procedure TFrmPlayer.InitOle;
begin
  //禁止双击打开word编辑
  olecontainer1.AutoActivate := aaManual;
  //OleContainer1.DoubleBuffered := true ;
  //禁止右键菜单
  olecontainer1.AutoVerbMenu := False;
  OleContainer1.AllowActiveDoc := False;
  OleContainer1.AllowInPlace := False;
  //OleContainer1.Brush.Color := clNone ;
  OleContainer1.Color := clNone;

  m_wordapp := CreateOleObject('Word.Application');
  m_wordapp.Visible := False;
end;

procedure TFrmPlayer.InsertLogs(strLogText: string; AIndex, ACount: Integer);
var
  strText: string;
begin
  strText := Format('正在播放:[ %s ] ,页面[%d/%d]', [strLogText, AIndex, ACount]);
  Self.Caption := strText;
end;

function TFrmPlayer.IsClosed: Boolean;
begin
  Result := m_bIsClose;
end;



procedure TFrmPlayer.MoveWindowPos(Rect: TRect);
begin
    {
  MoveWindow(Self.Handle,rect.Left,Rect.Top,
    Rect.Right-rect.Left,Rect.Bottom-rect.Top,True);
  }
  MoveWindow(Self.Handle, rect.Left, Rect.Top, Rect.Right, Rect.Bottom, True);
end;

procedure TFrmPlayer.PausePlay;
begin
  m_UPDateThread.Suspend;
end;

procedure TFrmPlayer.ReleaseOle;
begin
  m_wordapp.Quit;
end;

procedure TFrmPlayer.ReLoad;
begin
  //结束
  EndPlay;
  //重新开始
  StartPlay;
end;

function TFrmPlayer.InitData(PlayConfig: TPlayConfig):Boolean;
var
  strText: string ;
begin
  Result :=False ;
  m_PlayConfig.Assign(PlayConfig);
  m_olePlay.DirPath := PlayConfig.Path;
  MoveWindowPos(PlayConfig.rectForm);
  //tmrAutoStart.Enabled := True ;
  Result := True ;
end;

procedure TFrmPlayer.StartPlay;
begin
  try
    m_olePlay.InitData  ;
    m_UPDateThread := TUPDateThread.Create(True);
    m_UPDateThread.Interval := m_PlayConfig.Interval;
    m_UPDateThread.OnExecute := DoWork;
    m_UPDateThread.Continue;
  except
    on e:Exception do
    begin
      ShowMessage(e.Message);
    end;
  end;
end;



{ TUPDateThread }

procedure TUPDateThread.Continue;
begin
  if self.Suspended then
  begin
    self.Resume();
  end;
end;

constructor TUPDateThread.Create(CreateSuspended: Boolean);
begin
  m_hExit := CreateEvent(nil, False, False, nil);
  inherited;
end;

destructor TUPDateThread.Destroy;
begin
  CloseHandle(m_hExit);
  m_hExit := 0;
end;

procedure TUPDateThread.Execute;
var
  strText: string;
begin
  CoInitialize(nil);
  if not Assigned(m_OnExecute) then
    Exit  ;
  while True do
  begin
    try
      Lock ;
      strText := Format('线程[%d] 工作开始',[GetCurrentThreadId]) ;
      OutputDebugString(PAnsiChar(strText));
      //m_OnExecute();
      Synchronize(m_OnExecute);
      strText := Format('线程[%d] 工作结束',[GetCurrentThreadId]) ;
      OutputDebugString(PAnsiChar(strText));
    finally
      UnLock ;
    end;

    strText := Format('线程[%d] SLEEP开始',[GetCurrentThreadId]) ;
    OutputDebugString(PAnsiChar(strText));

    if WAIT_OBJECT_0 = WaitForSingleObject(m_hExit, Interval * 1000) then
      Break;

    strText := Format('线程[%d] SLEEP结束',[GetCurrentThreadId]) ;
    OutputDebugString(PAnsiChar(strText));
  end;
  CoUninitialize(); //加上这两句

  strText := Format('线程[%d] 退出',[GetCurrentThreadId]) ;
  OutputDebugString(PAnsiChar(strText));
end;

procedure TUPDateThread.Stop;
begin
  //等待线程结束
  SetEvent(m_hExit);
  Self.Terminate;
  self.WaitFor ;
end;

initialization
  InitializeCriticalSection(m_cs);//初始化临界区


finalization
  DeleteCriticalSection(m_cs);//删除临界区

end.

