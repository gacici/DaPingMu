unit uBasePlay;

interface

uses
  Classes,SysUtils,OleCtnrs,Windows,ComObj,uTFSystem;

type

  {日志输出事件}
  TLogOutPut = procedure(strLog: string;AIndex,ACount:Integer) of object;

  TBasePlay = class(TPersistent)
  public
    constructor Create(OleContainer: TOleContainer;app: Variant);
    destructor Destroy();override;
  private
    {播放}
    procedure Play();
    //设置文件名字
    procedure SetFileName(FileName:string);
    {下一个}
    function  HasNext():Boolean;
    {是否结束}
    function  IsFinish():Boolean;
    //向前
    procedure PlayNext();virtual;
    //先后
    procedure PlayPrev();virtual;
  protected
    {加载}
    procedure Open();virtual;abstract;
    {关不}
    procedure Close();virtual;abstract;
    {选中一页}
    procedure Selected();virtual;abstract;

    {获取目录里面的DOC文件}
    procedure GetFileList(Dir,Ext:string;List:TStrings;NeedDir:Boolean=False);
  public
    //播放列表
    procedure PlayLoop();
    //初始化
    function InitData():Boolean; virtual;
  protected
    //总页数
    m_nTotalPage:Integer;
    //正在播放的页数
    m_nCurPage:Integer;
    //目录
    m_strDirPath:string ;
    //正在播放的文件
    m_strFileName:string;
    //是否已经加载过
    m_bIsFinish : Boolean;
    //文件列表
    m_listFile : TStrings ;
    //正在播放的序号
    m_nCurIndex:Integer;
  protected
    //OLD信息
    m_OleContainer: TOleContainer;
    m_varApp: Variant;
    {日志输出}
    m_LogOutPut:TLogOutPut;
  public
    property TotalPage:Integer  read m_nTotalPage;
    property CurrentPage:Integer read m_nCurPage ;
    property FileName:string read m_strFileName write SetFileName ;
    property DirPath:string read m_strDirPath write m_strDirPath ;
    property LogOutPut:  TLogOutPut read m_LogOutPut write m_LogOutPut;
  end;


implementation

{ TOlePlay }


constructor TBasePlay.Create(OleContainer: TOleContainer; app: Variant);
begin

  m_listFile := TStringList.Create ;
  m_strDirPath := '' ;
    //总页数
  m_nTotalPage := 0;
  //正在播放的页数
  m_nCurPage := 1 ;;
  //正在播放的文件
  m_strFileName :='';

  m_bIsFinish := False ;
  m_OleContainer := OleContainer;
  m_varApp := app ;
end;

destructor TBasePlay.Destroy;
begin
  m_listFile.Free ;
  inherited;
end;



procedure TBasePlay.GetFileList(Dir, Ext: string; List: TStrings;
  NeedDir: Boolean);
var
  FSearchRec: TSearchRec;
  FindResult: Integer;
begin
  if Dir[length(Dir)]<>'\' then
    Dir:= Dir+'\';
  FindResult:=FindFirst(Dir + Ext ,faAnyFile ,FSearchRec);
  while FindResult = 0 do
  begin
    if ( ( (FSearchRec.Attr and faDirectory) = 0  ) and (  (FSearchRec.Attr and faHidden) = 0 ) ) then    //文件
    begin
        List.Add(LowerCase(Dir+FSearchRec.Name));
    end;
    if ((FSearchRec.Attr and faDirectory) <> 0) then
    begin
      if ((FSearchRec.Name<> '.') and (FSearchRec.Name <> '..')) then    //文件夹
      begin
        if NeedDir then
          GetFileList( dir + FSearchRec.Name,Ext,List);
      end;
    end;
     FindResult:=FindNext(FSearchRec);
  end;
  FindClose(FSearchRec.FindHandle);
end;

function TBasePlay.HasNext: Boolean;
begin
  Result := True ;
  {如果大于总页数则表示播放完毕}
  if m_nCurPage > m_nTotalPage then
  begin
    m_nCurPage := 1 ;
    m_bIsFinish := True ;

    inc(m_nCurIndex)  ;
    if m_nCurIndex > m_listFile.Count - 1  then
      m_nCurIndex := 0 ;

    Result := False ;
  end
end;

function TBasePlay.InitData:Boolean;
begin
  Result := True ;
end;



function TBasePlay.IsFinish: Boolean;
begin
  if m_strFileName = '' then
    Result := True
  else
    Result := m_bIsFinish ;
end;



procedure TBasePlay.Play;
var
  strText: string;
begin
  //选中一页
  Selected ;
  try

    strText := Format('线程[%d] 拷贝开始',[GetCurrentThreadId]) ;
    OutputDebugString(PAnsiChar(strText));

    m_varApp.selection.copy;

    strText := Format('线程[%d] 粘贴开始',[GetCurrentThreadId]) ;
    OutputDebugString(PAnsiChar(strText));


    if m_OleContainer.canpaste then
    begin
      m_OleContainer.paste;
      
      strText := Format('线程[%d] 粘贴结束',[GetCurrentThreadId]) ;
      OutputDebugString(PAnsiChar(strText));
    end
    else
    begin
      strText := Format('线程[%d] 粘贴错误',[GetCurrentThreadId]) ;
      OutputDebugString(PAnsiChar(strText));
    end;
  finally
    //m_OleContainer.Repaint ;
    m_OleContainer.Update;
    Inc(m_nCurPage);
  end;
end;


procedure TBasePlay.PlayLoop;
begin
  //一帧页面是否播放完毕
  if IsFinish then
  begin
    FileName := m_listFile.Strings[m_nCurIndex];
    Open;
  end;

  if  HasNext then
    Play ;
  //再次检测一下是否是到最后一页了
  HasNext ;
end;

procedure TBasePlay.PlayNext;
begin
  if m_nCurPage < m_listFile.Count - 1 then
    Inc(m_nCurPage)
  else
    m_nCurPage := 0 ;
end;

procedure TBasePlay.PlayPrev;
begin
  if m_nCurPage > 0  then
    Dec(m_nCurPage)
  else
   m_nCurPage :=  m_listFile.Count - 1 ;
end;

procedure TBasePlay.SetFileName(FileName: string);
begin
  m_strFileName := FileName ;
  m_bIsFinish := False ;
end;


end.
