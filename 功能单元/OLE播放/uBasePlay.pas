unit uBasePlay;

interface

uses
  Classes,SysUtils,OleCtnrs,Windows,ComObj,uTFSystem;

type

  {��־����¼�}
  TLogOutPut = procedure(strLog: string;AIndex,ACount:Integer) of object;

  TBasePlay = class(TPersistent)
  public
    constructor Create(OleContainer: TOleContainer;app: Variant);
    destructor Destroy();override;
  private
    {����}
    procedure Play();
    //�����ļ�����
    procedure SetFileName(FileName:string);
    {��һ��}
    function  HasNext():Boolean;
    {�Ƿ����}
    function  IsFinish():Boolean;
    //��ǰ
    procedure PlayNext();virtual;
    //�Ⱥ�
    procedure PlayPrev();virtual;
  protected
    {����}
    procedure Open();virtual;abstract;
    {�ز�}
    procedure Close();virtual;abstract;
    {ѡ��һҳ}
    procedure Selected();virtual;abstract;

    {��ȡĿ¼�����DOC�ļ�}
    procedure GetFileList(Dir,Ext:string;List:TStrings;NeedDir:Boolean=False);
  public
    //�����б�
    procedure PlayLoop();
    //��ʼ��
    function InitData():Boolean; virtual;
  protected
    //��ҳ��
    m_nTotalPage:Integer;
    //���ڲ��ŵ�ҳ��
    m_nCurPage:Integer;
    //Ŀ¼
    m_strDirPath:string ;
    //���ڲ��ŵ��ļ�
    m_strFileName:string;
    //�Ƿ��Ѿ����ع�
    m_bIsFinish : Boolean;
    //�ļ��б�
    m_listFile : TStrings ;
    //���ڲ��ŵ����
    m_nCurIndex:Integer;
  protected
    //OLD��Ϣ
    m_OleContainer: TOleContainer;
    m_varApp: Variant;
    {��־���}
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
    //��ҳ��
  m_nTotalPage := 0;
  //���ڲ��ŵ�ҳ��
  m_nCurPage := 1 ;;
  //���ڲ��ŵ��ļ�
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
    if ( ( (FSearchRec.Attr and faDirectory) = 0  ) and (  (FSearchRec.Attr and faHidden) = 0 ) ) then    //�ļ�
    begin
        List.Add(LowerCase(Dir+FSearchRec.Name));
    end;
    if ((FSearchRec.Attr and faDirectory) <> 0) then
    begin
      if ((FSearchRec.Name<> '.') and (FSearchRec.Name <> '..')) then    //�ļ���
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
  {���������ҳ�����ʾ�������}
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
  //ѡ��һҳ
  Selected ;
  try

    strText := Format('�߳�[%d] ������ʼ',[GetCurrentThreadId]) ;
    OutputDebugString(PAnsiChar(strText));

    m_varApp.selection.copy;

    strText := Format('�߳�[%d] ճ����ʼ',[GetCurrentThreadId]) ;
    OutputDebugString(PAnsiChar(strText));


    if m_OleContainer.canpaste then
    begin
      m_OleContainer.paste;
      
      strText := Format('�߳�[%d] ճ������',[GetCurrentThreadId]) ;
      OutputDebugString(PAnsiChar(strText));
    end
    else
    begin
      strText := Format('�߳�[%d] ճ������',[GetCurrentThreadId]) ;
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
  //һ֡ҳ���Ƿ񲥷����
  if IsFinish then
  begin
    FileName := m_listFile.Strings[m_nCurIndex];
    Open;
  end;

  if  HasNext then
    Play ;
  //�ٴμ��һ���Ƿ��ǵ����һҳ��
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
