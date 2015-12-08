object FormMetrix: TFormMetrix
  Left = 386
  Top = 160
  Align = alCustom
  BorderStyle = bsSingle
  Caption = #1052#1077#1090#1088#1080#1082#1072' '#1055#1088#1086#1075#1088#1072#1084#1084#1084#1085#1086#1075#1086' '#1082#1086#1076#1072' ('#1057'#)'
  ClientHeight = 476
  ClientWidth = 829
  Color = clNavy
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object PCMetrix: TPageControl
    Left = 0
    Top = 0
    Width = 825
    Height = 473
    ActivePage = TShSpan
    TabOrder = 0
    object TShCode: TTabSheet
      Caption = #1050#1086#1076' ('#1057'#)'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Comic Sans MS'
      Font.Style = [fsBold]
      ParentFont = False
      object LCode: TLabel
        Left = 32
        Top = 16
        Width = 119
        Height = 15
        Caption = #1040#1085#1072#1083#1080#1079#1080#1088#1091#1077#1084#1099#1081' '#1082#1086#1076':'
        Color = clNavy
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object LRowsCount: TLabel
        Left = 32
        Top = 408
        Width = 131
        Height = 17
        Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1089#1090#1088#1086#1082':'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWhite
        Font.Height = -15
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object MemoCode: TMemo
        Left = 32
        Top = 40
        Width = 465
        Height = 353
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnKeyPress = MemoCodeKeyPress
      end
      object GBChekedAction: TGroupBox
        Left = 536
        Top = 32
        Width = 265
        Height = 361
        Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1076#1077#1081#1089#1090#1074#1080#1077
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWhite
        Font.Height = -15
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object BOpenCode: TButton
          Left = 56
          Top = 80
          Width = 161
          Height = 33
          Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1082#1086#1076
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = BOpenCodeClick
        end
        object BCorrectCode: TButton
          Left = 56
          Top = 144
          Width = 161
          Height = 33
          Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1090#1100' '#1082#1086#1076
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object BSpanMetrix: TButton
          Left = 56
          Top = 216
          Width = 161
          Height = 33
          Caption = #1055#1086#1076#1089#1095#1105#1090' '#1089#1087#1077#1085#1072
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnClick = BSpanMetrixClick
        end
      end
      object EditRowsCount: TEdit
        Left = 184
        Top = 408
        Width = 201
        Height = 27
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Comic Sans MS'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
      end
    end
    object TShSpan: TTabSheet
      Caption = #1055#1086#1076#1089#1095#1105#1090' '#1089#1087#1077#1085#1072
      ImageIndex = 1
      OnShow = TShSpanShow
      object LLocalVariables: TLabel
        Left = 376
        Top = 8
        Width = 152
        Height = 19
        Caption = #1051#1086#1082#1072#1083#1100#1085#1099#1077' '#1087#1077#1088#1077#1084#1077#1085#1085#1099#1077
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Comic Sans MS'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LAverageSpan: TLabel
        Left = 32
        Top = 344
        Width = 155
        Height = 19
        Caption = #1057#1088#1077#1076#1085#1077#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1089#1087#1077#1085#1072
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Comic Sans MS'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LGlobalVariables: TLabel
        Left = 24
        Top = 16
        Width = 151
        Height = 16
        Caption = #1043#1083#1086#1073#1072#1083#1100#1085#1099#1077' '#1087#1077#1088#1077#1084#1077#1085#1085#1099#1077
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWhite
        Font.Height = -12
        Font.Name = 'Comic Sans MS'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object MemoLocalVariables: TMemo
        Left = 376
        Top = 32
        Width = 345
        Height = 385
        Lines.Strings = (
          '')
        ReadOnly = True
        TabOrder = 0
      end
      object EditAverageSpan: TEdit
        Left = 32
        Top = 376
        Width = 177
        Height = 21
        ReadOnly = True
        TabOrder = 1
      end
      object StringGridGlobalVariables: TStringGrid
        Left = 24
        Top = 48
        Width = 201
        Height = 81
        ColCount = 2
        DefaultColWidth = 75
        DefaultRowHeight = 20
        FixedCols = 0
        RowCount = 1
        FixedRows = 0
        TabOrder = 2
      end
    end
  end
  object OpenDlgCode: TOpenDialog
    Filter = #1082#1086#1076' '#1089'#|*.cs|'#1090#1077#1082#1089#1090#1086#1074#1099#1077' '#1092#1072#1081#1083#1099'|*.txt'
    Left = 240
    Top = 32
  end
end
