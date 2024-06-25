object fAnalisadorSintatico: TfAnalisadorSintatico
  Left = 0
  Top = 0
  Caption = 'Analisador Sint'#225'tico'
  ClientHeight = 640
  ClientWidth = 782
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    782
    640)
  TextHeight = 15
  object lbl_Gramatica: TLabel
    Left = 8
    Top = 8
    Width = 57
    Height = 15
    Caption = 'Gram'#225'tica:'
  end
  object lbl_TabParsing: TLabel
    Left = 407
    Top = 8
    Width = 94
    Height = 15
    Caption = 'Tabela de Parsing:'
  end
  object lbl_Sentenca: TLabel
    Left = 8
    Top = 161
    Width = 51
    Height = 15
    Caption = 'Senten'#231'a:'
  end
  object stg_Gramatica: TStringGrid
    Left = 8
    Top = 24
    Width = 393
    Height = 131
    TabStop = False
    BevelInner = bvNone
    ColCount = 9
    Enabled = False
    FixedCols = 0
    FixedRows = 0
    GradientEndColor = clWindow
    Options = [goFixedVertLine, goFixedHorzLine, goRangeSelect]
    ScrollBars = ssNone
    TabOrder = 0
    OnDrawCell = stg_GramaticaDrawCell
  end
  object dbg_parsing: TDBGrid
    Left = 407
    Top = 24
    Width = 369
    Height = 131
    DataSource = src_TabParsing
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [dgTitles, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    ParentFont = False
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'info_1'
        Title.Caption = '      '
        Width = 57
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'info_2'
        Title.Caption = 'a'
        Width = 57
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'info_3'
        Title.Caption = 'b'
        Width = 57
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'info_4'
        Title.Caption = 'c'
        Width = 57
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'info_5'
        Title.Caption = 'd'
        Width = 57
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'info_6'
        Title.Caption = '$'
        Width = 57
        Visible = True
      end>
  end
  object edt_Sentenca: TEdit
    Left = 159
    Top = 182
    Width = 539
    Height = 23
    TabOrder = 3
    OnChange = edt_SentencaChange
    OnKeyPress = edt_SentencaKeyPress
  end
  object btn_LimparSentenca: TButton
    Left = 701
    Top = 182
    Width = 75
    Height = 23
    Caption = 'Limpar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ImageAlignment = iaCenter
    ImageIndex = 0
    ParentFont = False
    TabOrder = 4
    OnClick = btn_LimparSentencaClick
  end
  object pnl_Resposta: TPanel
    Left = 393
    Top = 211
    Width = 168
    Height = 38
    BevelOuter = bvNone
    Caption = 'RESPOSTA'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 7
    StyleElements = [seFont, seBorder]
  end
  object btn_PassoAPasso: TButton
    Left = 680
    Top = 211
    Width = 96
    Height = 38
    Caption = 'Passo a Passo'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ImageAlignment = iaCenter
    ImageIndex = 0
    ParentFont = False
    TabOrder = 5
    OnClick = btn_PassoAPassoClick
  end
  object btn_Total: TButton
    Left = 578
    Top = 211
    Width = 96
    Height = 38
    Caption = 'Total'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ImageAlignment = iaCenter
    ImageIndex = 0
    ParentFont = False
    TabOrder = 6
    OnClick = btn_TotalClick
  end
  object stg_Resultado: TStringGrid
    Left = 8
    Top = 255
    Width = 768
    Height = 377
    TabStop = False
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 4
    DefaultColWidth = 190
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
    TabOrder = 8
    OnDrawCell = stg_ResultadoDrawCell
    ColWidths = (
      30
      190
      190
      190)
  end
  object cmb_Sentencas: TComboBox
    Left = 8
    Top = 182
    Width = 145
    Height = 23
    TabOrder = 2
    OnChange = cmb_SentencasChange
    Items.Strings = (
      'acab - V'#225'lida'
      'aaacabbb - V'#225'lida'
      'accbddab - V'#225'lida'
      'accbcbddddab - V'#225'lida'
      'aaaccb - Inv'#225'lida'
      'aabb - Inv'#225'lida')
  end
  object tmr: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmrTimer
    Left = 744
    Top = 100
  end
  object src_TabParsing: TDataSource
    DataSet = cds_TabParsing
    Left = 688
    Top = 100
  end
  object cds_TabParsing: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'info_1'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'info_2'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'info_3'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'info_4'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'info_5'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'info_6'
        DataType = ftString
        Size = 20
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 624
    Top = 100
    object cds_TabParsinginfo_1: TStringField
      FieldName = 'info_1'
    end
    object cds_TabParsinginfo_2: TStringField
      FieldName = 'info_2'
    end
    object cds_TabParsinginfo_3: TStringField
      FieldName = 'info_3'
    end
    object cds_TabParsinginfo_4: TStringField
      FieldName = 'info_4'
    end
    object cds_TabParsinginfo_5: TStringField
      FieldName = 'info_5'
    end
    object cds_TabParsinginfo_6: TStringField
      FieldName = 'info_6'
    end
  end
end
