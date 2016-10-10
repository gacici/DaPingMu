unit uPlayConfigOper;

interface

uses
  SysUtils,Forms,uPlayConfig,uPlayConfigStrategy,XMLIntf,XMLDoc  ;

type
  TPlayConfigOper = class
  public
    constructor Create(Width,Height:Integer);
    destructor Destroy();override;
  public
    {加载XML读取相关信息}
    procedure LoadFromFile();
    {保存XML到文件}
    procedure SaveToFile();
    {初始化播放列表}
    procedure InitList(PlayWindowType:TPlayWindowType);
  private
    //配置文件
    m_strConfigFile:string;
    //xml配置
    m_xmlDoc: IXMLDocument;
    //列表
    m_PlayConfigList : TPlayConfigList ;
    //
    m_nWidth,m_nHeight : Integer ;
  public
    property List:TPlayConfigList  read m_PlayConfigList write m_PlayConfigList;
  end;

implementation

{ TSysConfigOper }



constructor TPlayConfigOper.Create(Width,Height:Integer);
var
  xmlOptions: TXMLDocOptions;
begin

  m_nWidth := Width ;
  m_nHeight :=  Height ;

  m_PlayConfigList := TPlayConfigList.Create ;
  m_strConfigFile := ExtractFilePath(Application.ExeName) + 'config.xml';
  m_xmlDoc := NewXMLDocument();
  m_xmlDoc.Encoding := 'UTF-8';

  xmlOptions := m_xmlDoc.Options;

  Include(xmlOptions,doNodeAutoIndent);
  m_xmlDoc.Options := xmlOptions;
  m_xmlDoc.DocumentElement := m_xmlDoc.CreateNode('root');
end;



destructor TPlayConfigOper.Destroy;
begin
  m_PlayConfigList.Free ;
  m_xmlDoc := nil;
  inherited;
end;



procedure TPlayConfigOper.InitList(PlayWindowType:TPlayWindowType);
var
  PlayConfigStrategy : TBasePlayConfigStrategy ;
begin
  PlayConfigStrategy := nil ;
  case PlayWindowType of
    pwUser:
      begin
        PlayConfigStrategy := TUserPlayConfigStrategy.Create;
      end ;
    pwOne:
      begin
        PlayConfigStrategy := TOnePlayConfigStrategy.Create;
      end;
    pwTwo:
      begin
        PlayConfigStrategy := TTwoPlayConfigStrategy.Create;
      end;
    pwFour:
      begin
        PlayConfigStrategy := TFourPlayConfigStrategy.Create;
      end;
    pwSix:
      begin
        PlayConfigStrategy := TSixPlayConfigStrategy.Create;
      end;
  end;
  try
    m_PlayConfigList.Clear;
    if PlayConfigStrategy = nil then
      Exit ;
    PlayConfigStrategy.GetPlayConfigList(m_nWidth,m_nHeight,m_PlayConfigList);
    SaveToFile;
  finally
    PlayConfigStrategy.Free ;
  end;
end;

procedure TPlayConfigOper.LoadFromFile;
var
  FileName : string ;
begin
  FileName := m_strConfigFile ;
  if not FileExists(FileName) then
    Exit;
  
  m_xmlDoc.LoadFromFile(FileName);

  m_PlayConfigList.LoadXmlNode(m_xmlDoc.DocumentElement);
end;

procedure TPlayConfigOper.SaveToFile;
var
  FileName : string ;
begin
  FileName := m_strConfigFile ;
  m_PlayConfigList.SaveXmlNode(m_xmlDoc.DocumentElement);
  m_xmlDoc.SaveToFile(FileName);
end;



end.
