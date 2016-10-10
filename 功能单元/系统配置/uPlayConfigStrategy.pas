unit uPlayConfigStrategy;

interface

uses
  Windows,uPlayConfig;


const
  {��������֮��ļ��}
  WINDOW_SPACE = 0 ;

type
  //==============================================================================
  // ���ò�����
  //==============================================================================

  TBasePlayConfigStrategy = class
  public
    procedure GetPlayConfigList(Width,Height:Integer;PlayConfigList:TPlayConfigList);virtual;abstract;
  end;

  //==============================================================================
  // ֻ��1������
  //==============================================================================
  TOnePlayConfigStrategy = class(TBasePlayConfigStrategy)
  public
    procedure GetPlayConfigList(Width,Height:Integer;PlayConfigList:TPlayConfigList);override;
  end;

  //==============================================================================
  // ֻ��2������
  //==============================================================================
  TTwoPlayConfigStrategy = class(TBasePlayConfigStrategy)
  public
    procedure GetPlayConfigList(Width,Height:Integer;PlayConfigList:TPlayConfigList);override;
  end;

  //==============================================================================
  // ֻ��4������
  //==============================================================================
  TFourPlayConfigStrategy = class(TBasePlayConfigStrategy)
  public
    procedure GetPlayConfigList(Width,Height:Integer;PlayConfigList:TPlayConfigList);override;
  end;

  //==============================================================================
  // ֻ��6������
  //==============================================================================
  TSixPlayConfigStrategy = class(TBasePlayConfigStrategy)
  public
    procedure GetPlayConfigList(Width,Height:Integer;PlayConfigList:TPlayConfigList);override;
  end;


  //==============================================================================
  // ֻ��0������
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
  PlayConfig.Name := '����1';
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
  //��һ������
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
  PlayConfig.Name := '����1';
  PlayConfigList.Add(PlayConfig);

  //�ڶ�������
  PlayConfig := TPlayConfig.Create;
  with PlayConfig do
  begin
    rectForm.Left := rectLast.Right + WINDOW_SPACE ;
    rectForm.Top := rectLast.top ;
    rectForm.Right := nAvgWidth ;
    rectForm.Bottom := Height ;
  end;
  PlayConfig.Name := '����2';
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
  //��һ������
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
  PlayConfig.Name := '����1';
  PlayConfigList.Add(PlayConfig);

  //�ڶ�������
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
  PlayConfig.Name := '����2';
  PlayConfigList.Add(PlayConfig);

  //�����ڴ���
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
  PlayConfig.Name := '����3';
  PlayConfigList.Add(PlayConfig);
  //���ĸ�����
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
  PlayConfig.Name := '����4';
  PlayConfigList.Add(PlayConfig);
  //���������
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
  PlayConfig.Name := '����5';
  PlayConfigList.Add(PlayConfig);
  //��6������
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
  PlayConfig.Name := '����6';
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
  //��һ������
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
  PlayConfig.Name := '����1';
  PlayConfigList.Add(PlayConfig);

  //�ڶ�������
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
  PlayConfig.Name := '����2';
  PlayConfigList.Add(PlayConfig);

  //�����ڴ���
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
  PlayConfig.Name := '����3';
  PlayConfigList.Add(PlayConfig);
  //���ĸ�����
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
  PlayConfig.Name := '����4';
  PlayConfigList.Add(PlayConfig);
end;

end.
