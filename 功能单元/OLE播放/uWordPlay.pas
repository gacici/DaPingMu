unit uWordPlay;

interface

uses
  Classes,SysUtils,OleCtnrs,WordXP,uBasePlay;
type

//==============================================================================
// WORD播放类
//==============================================================================


  TWordPlay = class(TBasePlay)
  private
    {加载}
    procedure Open();override;
    {关闭}
    procedure Close();override;
    {选中一页}
    procedure Selected();override;
  public
    //初始化
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

  //如果只有一页 那么全选就OK了
  if m_nTotalPage = 1 then
  begin
    m_varApp.Selection.WholeStory;
  end
  else
  begin
      //定位到第i页
    PageRange := m_varApp.Selection.GoTo(wdGoToPage, wdGoToAbsolute, IntToStr(m_nCurPage));
    //如果第i页是最后一页 那么直接将光标移动到最后 并输出内容  
    if m_nCurPage = m_nTotalPage then
    begin
      m_varApp.Selection.EndKey(wdStory,wdExtend);
    end
    else
    begin
      //取第i页的页首位置作为开始位置
      nStart := nEnd;
      //定位到i+1页
      PageRange := m_varApp.Selection.GoTo(wdGoToPage, wdGoToAbsolute, IntToStr(m_nCurPage+1));
      //取第i+1页的页首位置作为结束位置
      nEnd := m_varApp.Selection.Start;
      //根据开始位置和结束位置确定文档选中的内容（第i页的内容）
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
    raise Exception.Create('播放路径为空,请检查配置');
    Exit ;
  end;
  GetFileList(m_strDirPath,'*.doc',m_listFile);
end;


initialization
  RegisterClass(TWordPlay);

finalization
  UnRegisterClass(TWordPlay);

end.
