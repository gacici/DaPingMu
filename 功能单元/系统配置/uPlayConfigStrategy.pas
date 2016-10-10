unit uPlayConfigStrategy;

interface

uses
  Windows,uPlayConfig;


const
  {各个窗口之间的间隔}
  WINDOW_SPACE = 0 ;

type
  //==============================================================================
  // 配置侧率类
  //==============================================================================

  TBasePlayConfigStrategy = class
  public
    procedure GetPlayConfigList(Width,Height:Integer;PlayConfigList:TPlayConfigList);virtual;abstract;
  end;

  //==============================================================================
  // 只有1个窗口
  //==============================================================================
  TOnePlayConfigStrategy = class(TBasePlayConfigStrategy)
  public
    procedure GetPlayConfigList(Width,Height:Integer;PlayConfigList:TPlayConfigList);override;
  end;

  //==============================================================================
  // 只有2个窗口
  //==============================================================================
  TTwoPlayConfigStrategy = class(TBasePlayConfigStrategy)
  public
    procedure GetPlayConfigList(Width,Height:Integer;PlayConfigList:TPlayConfigList);override;
  end;

  //==============================================================================
  // 只有4个窗口
  //==============================================================================
  TFourPlayConfigStrategy = class(TBasePlayConfigStrategy)
  public
    procedure GetPlayConfigList(Width,Height:Integer;PlayConfigList:TPlayConfigList);override;
  end;

  //==============================================================================
  // 只有6个窗口
  //==============================================================================
  TSixPlayConfigStrategy = class(TBasePlayConfigStrategy)
  public
    procedure GetPlayConfigList(Width,Height:Integer;PlayConfigList:TPlayConfigList);override;
  end;


  //==============================================================================
  // 只有0个窗口
  //==============================================================================
  TUserPlayConfigStrategy = class(TBasePlayConfigStrategy)
  public
    procedure GetPlayConfigList(Width,Height:Integer;PlayConfigList:TPlayConfigList);override;
  end;



implementation

{ TOnePlayConfigStrategy }

procedure TOnePlayConfigStrategy.GetPlayConfigList(Width,
  Height: Integer;PlayConfigList:TPlayConfigList);
var
  PlayConfig :   TPlayConfig ;
begin
  PlayConfig := TPlayConfig.Create;
  with PlayConfig.rectForm do
  begin
    Left := 0 ;
    Top := 0 ;
    Right := Width ;
    Bottom := Height ;
  end;
  PlayConfig.Name := '窗口1';
  PlayConfigList.Add(PlayConfig);
end;

{ TTwoPlayConfigStrategy }

procedure TTwoPlayConfigStrategy.GetPlayConfigList(Width,
  Height: Integer;PlayConfigList:TPlayConfigList);
var
  PlayConfig :   TPlayConfig ;
  rectLast : TRect ;
  nAvgWidth : Integer ;
begin
  nAvgWidth := Width div 2 ;
  //第一个窗口
  PlayConfig := TPlayConfig.Create;
  with PlayConfig do
  begin
    rectForm.Left := 0 ;
    rectLast.Left := rectForm.Left ;

    rectForm.Top := 0 ;
    rectLast.Top := rectForm.Top ;

    rectForm.Right := nAvgWidth ;
    rectLast.Right := rectForm.Right ;

    rectForm.Bottom := Height ;
    rectLast.Bottom := rectForm.Bottom  ;
  end;
  PlayConfig.Name := '窗口1';
  PlayConfigList.Add(PlayConfig);

  //第二个窗口
  PlayConfig := TPlayConfig.Create;
  with PlayConfig do
  begin
    rectForm.Left := rectLast.Right + WINDOW_SPACE ;
    rectForm.Top := rectLast.top ;
    rectForm.Right := nAvgWidth ;
    rectForm.Bottom := Height ;
  end;
  PlayConfig.Name := '窗口2';
  PlayConfigList.Add(PlayConfig);
end;

{ TUserPlayConfigStrategy }

procedure TUserPlayConfigStrategy.GetPlayConfigList(Width,
  Height: Integer;PlayConfigList:TPlayConfigList);
begin

end;

{ TSixPlayConfigStrategy }

procedure TSixPlayConfigStrategy.GetPlayConfigList(Width,
  Height: Integer;PlayConfigList:TPlayConfigList);
var
  PlayConfig :   TPlayConfig ;
  rectLast : TRect ;
  nAvgWidth : Integer ;
begin
  nAvgWidth := Width div 6 ;
  //第一个窗口
  PlayConfig := TPlayConfig.Create;
  with PlayConfig do
  begin
    rectForm.Left := 0 ;
    rectLast.Left := rectForm.Left ;

    rectForm.Top := 0 ;
    rectLast.Top := rectForm.Top ;

    rectForm.Right := nAvgWidth ;
    rectLast.Right := rectForm.Right ;

    rectForm.Bottom := Height ;
    rectLast.Bottom := rectForm.Bottom  ;
  end;
  PlayConfig.Name := '窗口1';
  PlayConfigList.Add(PlayConfig);

  //第二个窗口
  PlayConfig := TPlayConfig.Create;
  with PlayConfig do
  begin
    rectForm.Left := rectLast.Right + WINDOW_SPACE ;
    rectLast.Left := rectForm.Left ;

    rectForm.Top := rectLast.Top ;
    rectLast.Top := rectForm.Top ;

    rectForm.Right := nAvgWidth  ;
    rectLast.Right := rectForm.Left + rectForm.Right ;

    rectForm.Bottom := Height ;
    rectLast.Bottom := rectForm.Bottom  ;
  end;
  PlayConfig.Name := '窗口2';
  PlayConfigList.Add(PlayConfig);

  //第三口窗口
  PlayConfig := TPlayConfig.Create;
  with PlayConfig do
  begin
    rectForm.Left := rectLast.Right + WINDOW_SPACE ;
    rectLast.Left := rectForm.Left ;

    rectForm.Top := rectLast.Top ;
    rectLast.Top := rectForm.Top ;

    rectForm.Right := nAvgWidth   ;
    rectLast.Right := rectForm.Left + rectForm.Right ;

    rectForm.Bottom := Height ;
    rectLast.Bottom := rectForm.Bottom  ;
  end;
  PlayConfig.Name := '窗口3';
  PlayConfigList.Add(PlayConfig);
  //第四个窗口
  PlayConfig := TPlayConfig.Create;
  with PlayConfig do
  begin
    rectForm.Left := rectLast.Right + WINDOW_SPACE ;
    rectLast.Left := rectForm.Left ;

    rectForm.Top := rectLast.Top ;
    rectLast.Top := rectForm.Top ;

    rectForm.Right := nAvgWidth  ;
    rectLast.Right := rectForm.Left + rectForm.Right ;

    rectForm.Bottom := Height ;
    rectLast.Bottom := rectForm.Bottom  ;
  end;
  PlayConfig.Name := '窗口4';
  PlayConfigList.Add(PlayConfig);
  //第五个窗口
  PlayConfig := TPlayConfig.Create;
  with PlayConfig do
  begin
    rectForm.Left := rectLast.Right + WINDOW_SPACE ;
    rectLast.Left := rectForm.Left ;

    rectForm.Top := rectLast.Top ;
    rectLast.Top := rectForm.Top ;

    rectForm.Right := nAvgWidth  ;
    rectLast.Right := rectForm.Left + rectForm.Right ;

    rectForm.Bottom := Height ;
    rectLast.Bottom := rectForm.Bottom  ;
  end;
  PlayConfig.Name := '窗口5';
  PlayConfigList.Add(PlayConfig);
  //第6个窗口
  PlayConfig := TPlayConfig.Create;
  with PlayConfig do
  begin
    rectForm.Left := rectLast.Right + WINDOW_SPACE ;
    rectLast.Left := rectForm.Left ;

    rectForm.Top := rectLast.Top ;
    rectLast.Top := rectForm.Top ;

    rectForm.Right := nAvgWidth   ;
    rectLast.Right := rectForm.Left +  rectForm.Right ;

    rectForm.Bottom := Height ;
    rectLast.Bottom := rectForm.Bottom  ;
  end;
  PlayConfig.Name := '窗口6';
  PlayConfigList.Add(PlayConfig);

end;

{ TFourPlayConfigStrategy }

procedure TFourPlayConfigStrategy.GetPlayConfigList(Width,
  Height: Integer;PlayConfigList:TPlayConfigList);
var
  PlayConfig :   TPlayConfig ;
  rectLast : TRect ;
  nAvgWidth : Integer ;
begin
  nAvgWidth := Width div 4 ;
  //第一个窗口
  PlayConfig := TPlayConfig.Create;
  with PlayConfig do
  begin
    rectForm.Left := 0 ;
    rectLast.Left := rectForm.Left ;

    rectForm.Top := 0 ;
    rectLast.Top := rectForm.Top ;

    rectForm.Right := nAvgWidth ;
    rectLast.Right := rectForm.Right ;

    rectForm.Bottom := Height ;
    rectLast.Bottom := rectForm.Bottom  ;
  end;
  PlayConfig.Name := '窗口1';
  PlayConfigList.Add(PlayConfig);

  //第二个窗口
  PlayConfig := TPlayConfig.Create;
  with PlayConfig do
  begin
    rectForm.Left := rectLast.Right + WINDOW_SPACE ;
    rectLast.Left := rectForm.Left ;

    rectForm.Top := rectLast.Top ;
    rectLast.Top := rectForm.Top ;

    rectForm.Right := nAvgWidth  ;
    rectLast.Right := rectForm.Left +  rectForm.Right ;

    rectForm.Bottom := Height ;
    rectLast.Bottom := rectForm.Bottom  ;
  end;
  PlayConfig.Name := '窗口2';
  PlayConfigList.Add(PlayConfig);

  //第三口窗口
  PlayConfig := TPlayConfig.Create;
  with PlayConfig do
  begin
    rectForm.Left := rectLast.Right + WINDOW_SPACE ;
    rectLast.Left := rectForm.Left ;

    rectForm.Top := rectLast.Top ;
    rectLast.Top := rectForm.Top ;

    rectForm.Right := nAvgWidth   ;
    rectLast.Right := rectForm.Left +   rectForm.Right ;

    rectForm.Bottom := Height ;
    rectLast.Bottom := rectForm.Bottom  ;
  end;
  PlayConfig.Name := '窗口3';
  PlayConfigList.Add(PlayConfig);
  //第四个窗口
  PlayConfig := TPlayConfig.Create;
  with PlayConfig do
  begin
    rectForm.Left := rectLast.Right + WINDOW_SPACE ;
    rectLast.Left := rectForm.Left ;

    rectForm.Top := rectLast.Top ;
    rectLast.Top := rectForm.Top ;

    rectForm.Right := nAvgWidth  ;
    rectLast.Right := rectForm.Left +  rectForm.Right ;

    rectForm.Bottom := Height ;
    rectLast.Bottom := rectForm.Bottom  ;
  end;
  PlayConfig.Name := '窗口4';
  PlayConfigList.Add(PlayConfig);
end;

end.
