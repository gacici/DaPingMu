unit uWordPlay;

interface

uses
  Classes,SysUtils,OleCtnrs,WordXP,uBasePlay;
type

//==============================================================================
// WORD������
//==============================================================================


  TWordPlay = class(TBasePlay)
  private
    {����}
    procedure Open();override;
    {�ر�}
    procedure Close();override;
    {ѡ��һҳ}
    procedure Selected();override;
  public
    //��ʼ��
    function InitData():Boolean;override;
  private
    nStart, nEnd : Integer;
    m_WordDoc: Variant;
  end;



implementation


{ TWordPlay }





procedure TWordPlay.Open;
begin
  try
    m_varApp.Visible := False;
    if m_varApp.Documents.Count >= 1 Then
    begin
      m_varApp.Documents.Close;
    end;


    m_varApp.Visible := False;
    m_WordDoc := m_varApp.Documents.Open(
      FileName := m_strFileName,
      ReadOnly:= True,
      AddToRecentFiles:=False,Visible := True);

    //m_WordDoc := m_wordapp.Documents.Open(m_strFileName,True);
    m_nTotalPage := m_varApp.Selection.Information[wdNumberOfPagesInDocument];
    m_nCurPage := 1;
    nStart := 0;
    nEnd  := 0 ;
  except
    on e:Exception do
    begin
      raise Exception.Create(e.Message);
    end;
  end;
end;


procedure TWordPlay.Selected;
var
  PageRange: Variant;
  strFileName:string;
begin
  strFileName := ChangeFileExt(ExtractFileName(m_strFileName),'');
  if Assigned(LogOutPut) then
    LogOutPut(ExtractFileName(strFileName),m_nCurPage,m_nTotalPage) ;

  //���ֻ��һҳ ��ôȫѡ��OK��
  if m_nTotalPage = 1 then
  begin
    m_varApp.Selection.WholeStory;
  end
  else
  begin
      //��λ����iҳ
    PageRange := m_varApp.Selection.GoTo(wdGoToPage, wdGoToAbsolute, IntToStr(m_nCurPage));
    //�����iҳ�����һҳ ��ôֱ�ӽ�����ƶ������ ���������  
    if m_nCurPage = m_nTotalPage then
    begin
      m_varApp.Selection.EndKey(wdStory,wdExtend);
    end
    else
    begin
      //ȡ��iҳ��ҳ��λ����Ϊ��ʼλ��
      nStart := nEnd;
      //��λ��i+1ҳ
      PageRange := m_varApp.Selection.GoTo(wdGoToPage, wdGoToAbsolute, IntToStr(m_nCurPage+1));
      //ȡ��i+1ҳ��ҳ��λ����Ϊ����λ��
      nEnd := m_varApp.Selection.Start;
      //���ݿ�ʼλ�úͽ���λ��ȷ���ĵ�ѡ�е����ݣ���iҳ�����ݣ�
      m_WordDoc.Range(nStart,nEnd).Select;
    end;
  end;
end;

procedure TWordPlay.Close;
begin
  ;
end;

function TWordPlay.InitData:Boolean;
begin
  Result := True;
  if m_strDirPath = '' then
  begin
    Result := False ;
    raise Exception.Create('����·��Ϊ��,��������');
    Exit ;
  end;
  GetFileList(m_strDirPath,'*.doc',m_listFile);
end;


initialization
  RegisterClass(TWordPlay);

finalization
  UnRegisterClass(TWordPlay);

end.
