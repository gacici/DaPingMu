object FrmWindowSelect: TFrmWindowSelect
  Left = 0
  Top = 0
  Caption = #35831#36873#25321#19968#20010
  ClientHeight = 257
  ClientWidth = 373
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 337
    Height = 185
    Caption = #31383#21475#36873#25321
    TabOrder = 0
    object rbOne: TRadioButton
      Left = 30
      Top = 39
      Width = 113
      Height = 17
      Caption = #19968#20010
      TabOrder = 0
    end
    object rbTwo: TRadioButton
      Left = 182
      Top = 39
      Width = 113
      Height = 17
      Caption = #20004#20010
      TabOrder = 1
    end
    object rbFour: TRadioButton
      Left = 30
      Top = 87
      Width = 113
      Height = 17
      Caption = #22235#20010
      TabOrder = 2
    end
    object rbSix: TRadioButton
      Left = 182
      Top = 87
      Width = 113
      Height = 17
      Caption = #20845#20010
      TabOrder = 3
    end
    object rbUser: TRadioButton
      Left = 30
      Top = 135
      Width = 219
      Height = 17
      Caption = #33258#23450#20041'('#33258#21161#21019#24314#31383#21475')'
      TabOrder = 4
    end
  end
  object btnOk: TButton
    Left = 144
    Top = 216
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 270
    Top = 216
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
