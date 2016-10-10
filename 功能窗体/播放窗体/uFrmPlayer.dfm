object FrmPlayer: TFrmPlayer
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = #25773#25918'...'
  ClientHeight = 518
  ClientWidth = 417
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  OnDblClick = FormDblClick
  OnDestroy = FormDestroy
  OnMouseDown = FormMouseDown
  OnMouseEnter = FormMouseEnter
  OnMouseLeave = FormMouseLeave
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object OleContainer1: TOleContainer
    Left = 0
    Top = 0
    Width = 417
    Height = 518
    AllowInPlace = False
    AllowActiveDoc = False
    AutoVerbMenu = False
    Align = alClient
    Caption = 'OleContainer1'
    CopyOnSave = False
    Ctl3D = False
    Enabled = False
    ParentCtl3D = False
    SizeMode = smScale
    TabOrder = 0
  end
  object PopupMenu1: TPopupMenu
    Left = 336
    Top = 216
    object mniPlay: TMenuItem
      Action = actPlay
    end
    object mniStop: TMenuItem
      Action = actStop
    end
    object mniLoad: TMenuItem
      Action = actLoad
    end
    object mniN1: TMenuItem
      Caption = '-'
    end
    object mniClose: TMenuItem
      Action = actClose
    end
  end
  object ActionList1: TActionList
    Left = 320
    Top = 344
    object actPlay: TAction
      Caption = #25773#25918
      OnExecute = actPlayExecute
    end
    object actPause: TAction
      Caption = #26242#20572
    end
    object actStop: TAction
      Caption = #20572#27490
      OnExecute = actStopExecute
    end
    object actLoad: TAction
      Caption = #37325#26032#21152#36733
      OnExecute = actLoadExecute
    end
    object actClose: TAction
      Caption = #20851#38381
      OnExecute = actCloseExecute
    end
  end
end
