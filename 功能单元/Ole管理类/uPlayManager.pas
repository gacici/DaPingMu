unit uPlayManager;

interface

uses
  uBasePlay,uWordPlay,Classes,OleCtnrs;

type
//==============================================================================
// 播放管理类
//==============================================================================

  {未用}
  TPlayManager = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    function CreateInstance(Name: string;
        OleContainer: TOleContainer;app: Variant): TBasePlay;
  end;

implementation

{ TPlayManager }

constructor TPlayManager.Create;
begin

end;

function TPlayManager.CreateInstance(Name: string;
  OleContainer: TOleContainer; app: Variant): TBasePlay;
var
  AClass: TPersistentClass;
begin
  Result := nil ;
  AClass := GetClass(Name);
  if Assigned( AClass ) then
  begin
    Result := AClass.NewInstance as TBasePlay ;
    Result.Create(OleContainer,app);
  end;
end;

destructor TPlayManager.Destroy;
begin

  inherited;
end;

end.
