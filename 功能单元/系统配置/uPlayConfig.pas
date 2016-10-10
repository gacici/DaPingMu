unit uPlayConfig;

interface

uses
  Windows,SysUtils,Graphics,Contnrs,XMLIntf;


const
  PLAY_INTERFAL = 10 ;

type


  TPlayWindowType = (pwUser,pwOne,pwTwo,pwFour,pwSix);

  {系统配置}
  TPlayConfig = class
  public
    constructor Create();
    destructor Destroy();override;
  private
    nId:Integer ;             //序号 ...为了兼容SQL
    strName:string;           //配置名字 ...为了兼容SQL
    bIsEnable : Boolean ;     //是否启用
    strPath :   string;         //DOC所在的路径
    clBakColor : tcolor;       //背景色
    nInterval:Integer;      //播放间隔
  public
    procedure SaveXmlNode(Node: IXMLNode);
    procedure LoadXmlNode(Node: IXMLNode);

    procedure Assign(AObject:TPlayConfig) ;
  public
    rectForm : TRect;       //窗体的位置

    property Id:Integer read nId write nId ;           //序号 ...为了兼容SQL
    property Name:string read strName write strName  ;        //配置名字 ...为了兼容SQL
    property Enabled:Boolean read bIsEnable write  bIsEnable ;
    property Path :   string read strPath write  strPath;          //DOC所在的路径
    property BakColor : tcolor read clBakColor write  clBakColor;
    property Interval:Integer read nInterval write nInterval;  //播放间隔
  end;

  {系统配置列表}
  TPlayConfigList = class(TObjectList)
  public
    procedure SaveXmlNode(ParentNode: IXMLNode);
    procedure LoadXmlNode(ParentNode: IXMLNode);

    function GetItem(Index: Integer): TPlayConfig;
    procedure SetItem(Index: Integer; AObject: TPlayConfig);
    function Add(AObject: TPlayConfig): Integer;
  public
    property Items[Index: Integer]: TPlayConfig read GetItem write SetItem; default;
  end;


implementation

{ TPlayConfigList }

function TPlayConfigList.Add(AObject: TPlayConfig): Integer;
begin
  Result := inherited Add(AObject);
end;

function TPlayConfigList.GetItem(Index: Integer): TPlayConfig;
begin
  Result :=   TPlayConfig ( inherited GetItem(Index) );
end;

procedure TPlayConfigList.LoadXmlNode(ParentNode: IXMLNode);
var
  I: Integer;
  PlayConfig: TPlayConfig;
  Node: IXMLNode;
begin
  Clear;
  if ParentNode = nil then Exit;

  Node := ParentNode.ChildNodes.Nodes['PlayConfig'];
  for I := 0 to Node.ChildNodes.Count - 1 do
  begin
    PlayConfig := TPlayConfig.Create;
    PlayConfig.LoadXmlNode(Node.ChildNodes.Nodes[i]);
    Add(PlayConfig);
  end;
end;

procedure TPlayConfigList.SaveXmlNode(ParentNode: IXMLNode);
var
  I: Integer;
  Node,ChildNode: IXMLNode;
begin
  if ParentNode = nil then Exit;

  Node := ParentNode.ChildNodes.Nodes['PlayConfig'];
  Node.ChildNodes.Clear;
  for I := 0 to Count - 1 do
  begin
    ChildNode := Node.AddChild('Play' + IntToStr(i + 1));
    Items[i].SaveXmlNode(ChildNode);
  end;
end;

procedure TPlayConfigList.SetItem(Index: Integer; AObject: TPlayConfig);
begin
  inherited SetItem(Index,AObject);
end;

{ TPlayConfig }

procedure TPlayConfig.Assign(AObject: TPlayConfig);
begin
  Self.nId := AObject.nId ;
  Self.bIsEnable := AObject.bIsEnable ;
  Self.strName:= AObject.strName;        //配置名字 ...为了兼容SQL

  //Self.rectForm := AObject.rectForm;       //窗体的位置
  Self.rectForm.Left := AObject.rectForm.Left ;
  Self.rectForm.Top := AObject.rectForm.Top ;
  self.rectForm.Right := AObject.rectForm.Right ;
  Self.rectForm.Bottom := AObject.rectForm.Bottom ;

  Self.strPath := AObject.strPath;         //DOC所在的路径
  Self.clBakColor := AObject.clBakColor;
  Self.nInterval:= AObject.nInterval;  //播放间隔
end;

constructor TPlayConfig.Create;
begin
  nInterval := PLAY_INTERFAL ;
  bIsEnable := True ;
end;

destructor TPlayConfig.Destroy;
begin

  inherited;
end;

procedure TPlayConfig.LoadXmlNode(Node: IXMLNode);
begin
  strName := Node.Attributes['Name'];
  bIsEnable := Node.Attributes['Enabled']  ;

  rectForm.Left := StrToInt( Node.Attributes['Left'] );
  rectForm.Top := StrToInt( Node.Attributes['Top'] );
  rectForm.Right := StrToInt( Node.Attributes['Right'] );
  rectForm.Bottom := StrToInt( Node.Attributes['Bottom'] );

  strPath := Node.Attributes['Path'];
  //clBakColor := StrToInt( Node.Attributes['clBakColor'] ) ;
  nInterval :=StrToInt(  Node.Attributes['Interval'] );

end;

procedure TPlayConfig.SaveXmlNode(Node: IXMLNode);
begin
  Node.Attributes['Name'] := strName ;
  Node.Attributes['Enabled'] := bIsEnable ;

  Node.Attributes['Left'] := rectForm.Left ;
  Node.Attributes['Top'] := rectForm.Top ;
  Node.Attributes['Right'] := rectForm.Right ;
  Node.Attributes['Bottom'] := rectForm.Bottom ;

  Node.Attributes['Path'] := strPath ;
  //Node.Attributes['clBakColor'] := clBakColor ;
  Node.Attributes['Interval'] := nInterval ;
end;

end.
