unit uAnalisadorSintatico;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Data.DB, StrUtils,
  Datasnap.DBClient, Vcl.ExtCtrls, Vcl.DBGrids, Vcl.Buttons, Vcl.Menus;

type
  TfAnalisadorSintatico = class(TForm)
    lbl_Gramatica: TLabel;
    stg_Gramatica: TStringGrid;
    dbg_parsing: TDBGrid;
    lbl_TabParsing: TLabel;
    tmr: TTimer;
    src_TabParsing: TDataSource;
    cds_TabParsing: TClientDataSet;
    cds_TabParsinginfo_1: TStringField;
    cds_TabParsinginfo_2: TStringField;
    cds_TabParsinginfo_3: TStringField;
    cds_TabParsinginfo_4: TStringField;
    cds_TabParsinginfo_5: TStringField;
    cds_TabParsinginfo_6: TStringField;
    lbl_Sentenca: TLabel;
    edt_Sentenca: TEdit;
    btn_LimparSentenca: TButton;
    pnl_Resposta: TPanel;
    btn_PassoAPasso: TButton;
    btn_Total: TButton;
    stg_Resultado: TStringGrid;
    cmb_Sentencas: TComboBox;
    procedure btn_LimparSentencaClick(Sender: TObject);
    procedure btn_PassoAPassoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btn_TotalClick(Sender: TObject);
    procedure stg_GramaticaDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure edt_SentencaChange(Sender: TObject);
    procedure edt_SentencaKeyPress(Sender: TObject; var Key: Char);
    procedure stg_ResultadoDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure tmrTimer(Sender: TObject);
    procedure CopiaSentenca(Sender: TObject);
    procedure cmb_SentencasChange(Sender: TObject);
  private
    { Private declarations }
    procedure Processar;
    procedure geraLinha;
    procedure Limpar;
  public
    { Public declarations }
    slPilha: TStringList;
    slEntrada: TStringList;
    slRegra: TStringList;
    iLinha: Integer;
    bFirst: Boolean;
    bLer: Boolean;
    bFim: Boolean;
    bTotal: Boolean;
  end;

var
  fAnalisadorSintatico: TfAnalisadorSintatico;

implementation

{$R *.dfm}

procedure TfAnalisadorSintatico.btn_LimparSentencaClick(Sender: TObject);
begin
  edt_Sentenca.Clear;
  cmb_Sentencas.SetFocus;
end;

procedure TfAnalisadorSintatico.btn_PassoAPassoClick(Sender: TObject);
begin
  if bFim then
    Limpar;

  btn_Total.Enabled := false;
  btn_PassoAPasso.Enabled := true;
  bTotal := false;

  edt_Sentenca.Enabled := False;
  try
    Processar;
  finally
    edt_Sentenca.Enabled := bFim;
  end;
end;

procedure TfAnalisadorSintatico.btn_TotalClick(Sender: TObject);
begin
  Limpar;
  edt_sentenca.Enabled    := false;
  btn_total.Enabled       := false;
  btn_PassoAPasso.Enabled := false;
  bTotal                  := true;
  tmr.Enabled             := true;
  dbg_parsing.SetFocus;
end;

procedure TfAnalisadorSintatico.cmb_SentencasChange(Sender: TObject);
var
  sItemSelecionado: String;
begin
  sItemSelecionado := cmb_Sentencas.Items[cmb_Sentencas.ItemIndex];
  edt_Sentenca.Text := Copy(sItemSelecionado, 1, Pos(' ', sItemSelecionado) - 1);
end;

procedure TfAnalisadorSintatico.CopiaSentenca(Sender: TObject);
begin
  edt_Sentenca.Clear;
  if Sender is TMenuItem then
    edt_Sentenca.Text := AnsiReplaceStr(TMenuItem(Sender).Caption, '&', '');
end;

procedure TfAnalisadorSintatico.edt_SentencaChange(Sender: TObject);
begin
  Limpar;
  btn_PassoAPasso.Enabled := Length(edt_sentenca.Text) > 0;
  btn_total.Enabled := Length(edt_sentenca.Text) > 0;
  bFirst := Length(edt_sentenca.Text) > 0;
end;

procedure TfAnalisadorSintatico.edt_SentencaKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not(Key in ['a' .. 'd', Chr(8)]) then
    Key := #0;
end;

procedure TfAnalisadorSintatico.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfAnalisadorSintatico.FormCreate(Sender: TObject);
begin
  slPilha := TStringList.Create;
  slEntrada := TStringList.Create;
  slRegra := TStringList.Create;
  iLinha := 0;
  bFirst := true;
  bLer := false;
  bFim := false;
  bTotal := false;
  pnl_Resposta.Caption := EmptyStr;
  pnl_Resposta.Color := clBtnFace;
end;

procedure TfAnalisadorSintatico.FormShow(Sender: TObject);
var
  CanSel: Boolean;
begin
  stg_gramatica.ColWidths[0] := 0;
  stg_gramatica.ColWidths[1] := 40;
  stg_gramatica.ColWidths[2] := 30;
  stg_gramatica.ColWidths[3] := 10;
  stg_gramatica.ColWidths[4] := 30;
  stg_gramatica.ColWidths[5] := 80;
  stg_gramatica.ColWidths[6] := 80;
  stg_gramatica.ColWidths[7] := 30;
  stg_gramatica.ColWidths[8] := 80;
  // Gramática
  stg_gramatica.Cells[1, 0] := 'GLC   ';
  stg_gramatica.Cells[1, 1] := 'S ::=';
  stg_gramatica.Cells[2, 1] := 'aCb';
  stg_gramatica.Cells[3, 1] := '|';
  stg_gramatica.Cells[1, 2] := 'A ::=';
  stg_gramatica.Cells[2, 2] := 'bBd';
  stg_gramatica.Cells[3, 2] := '|';
  stg_gramatica.Cells[4, 2] := 'aSa';
  stg_gramatica.Cells[1, 3] := 'B ::=';
  stg_gramatica.Cells[2, 3] := 'cAd';
  stg_gramatica.Cells[3, 3] := '|';
  stg_gramatica.Cells[4, 3] := 'ε';
  stg_gramatica.Cells[1, 4] := 'C ::=';
  stg_gramatica.Cells[2, 4] := 'aSb';
  stg_gramatica.Cells[3, 4] := '|';
  stg_gramatica.Cells[4, 4] := 'cBa';
  // First
  stg_gramatica.Cells[6, 0] := 'First         ';
  stg_gramatica.Cells[6, 1] := 'S ::= {a}   ';
  stg_gramatica.Cells[6, 2] := 'A ::= {b,a}';
  stg_gramatica.Cells[6, 3] := 'B ::= {c,ε}';
  stg_gramatica.Cells[6, 4] := 'C ::= {a,c}';
  // Follow
  stg_gramatica.Cells[8, 0] := 'Follow            ';
  stg_gramatica.Cells[8, 1] := 'S ::= {$,b,a}    ';
  stg_gramatica.Cells[8, 2] := 'A ::= {d}          ';
  stg_gramatica.Cells[8, 3] := 'B ::= {d,a}       ';
  stg_gramatica.Cells[8, 4] := 'C ::= {b}          ';

  // Tabela
  cds_tabparsing.CreateDataSet;
  cds_tabparsing.Open;

  cds_tabparsing.Append;
  cds_tabparsinginfo_1.AsString := 'S';
  cds_tabparsinginfo_2.AsString := 'S > aCb';
  cds_tabparsing.Post;

  cds_tabparsing.Append;
  cds_tabparsinginfo_1.AsString := 'A';
  cds_tabparsinginfo_2.AsString := 'A > aSa';
  cds_tabparsinginfo_3.AsString := 'A > bBd';
  cds_tabparsing.Post;

  cds_tabparsing.Append;
  cds_tabparsinginfo_1.AsString := 'B';
  cds_tabparsinginfo_2.AsString := 'B > E';
  cds_tabparsinginfo_4.AsString := 'B > cAd';
  cds_tabparsinginfo_5.AsString := 'B > E';
  cds_tabparsing.Post;

  cds_tabparsing.Append;
  cds_tabparsinginfo_1.AsString := 'C';
  cds_tabparsinginfo_2.AsString := 'C > aSb';
  cds_tabparsinginfo_4.AsString := 'C > cBa';
  cds_tabparsing.Post;

  // Principal
  stg_Resultado.Cells[0, 0] := '#';
  stg_Resultado.Cells[1, 0] := 'Pilha';
  stg_Resultado.Cells[2, 0] := 'Entrada';
  stg_Resultado.Cells[3, 0] := 'Ação';

  stg_Resultado.ColWidths[0] := 50;
  stg_Resultado.ColWidths[1] := 231;
  stg_Resultado.ColWidths[2] := 231;
  stg_Resultado.ColWidths[3] := 231;
end;

procedure TfAnalisadorSintatico.geraLinha;
begin
  iLinha := iLinha + 1;
  stg_Resultado.Cells[0, iLinha] := IntToStr(iLinha);

  if slPilha[slPilha.Count - 1] = '$' then
    stg_Resultado.Cells[1, iLinha] := slPilha[slPilha.Count - 1]
  else
    stg_Resultado.Cells[1, iLinha] := '$' + slPilha[slPilha.Count - 1];

  if slEntrada[slEntrada.Count - 1] = '$' then
    stg_Resultado.Cells[2, iLinha] := slEntrada[slEntrada.Count - 1]
  else
    stg_Resultado.Cells[2, iLinha] := slEntrada[slEntrada.Count - 1] + '$';

  stg_Resultado.Cells[3, iLinha] := slRegra[slRegra.Count - 1];

  if bLer then
  begin
    slPilha[slPilha.Count - 1] := Copy(slPilha[slPilha.Count - 1], 1,
      Length(slPilha[slPilha.Count - 1]) - 1);

    bLer := false;
  end;
end;

procedure TfAnalisadorSintatico.Limpar;
var
  I, j: Integer;
begin
  pnl_Resposta.Caption := EmptyStr;
  pnl_Resposta.Color := clBtnFace;

  for I := 0 to stg_Resultado.ColCount - 1 do
    for j := 1 to stg_Resultado.RowCount do
      stg_Resultado.Cells[I, j] := EmptyStr;

  stg_Resultado.RowCount := 1;
  iLinha := 0;
  bFirst := true;
  bLer := false;
  bFim := false;
  slPilha.clear;
  slEntrada.clear;
  slRegra.clear;
end;

procedure TfAnalisadorSintatico.Processar;
  function BuscaRegra(sLinha, sColuna: string): string;
  var
    I, j: Integer;
  begin
    //Pilha = sLinha
    //Entrada = sColuna

    //Pilha e Entrada vazia = Sentença Válida
    if (sLinha = EmptyStr) and (sColuna = EmptyStr) then
    begin
      btn_total.Enabled := false;
      slPilha.Add('$');
      slEntrada.Add('$');
      slRegra.Add('Aceito em ' + IntToStr(iLinha + 1) + ' Iterações');
      pnl_Resposta.Color := clLime;
      pnl_Resposta.Caption := 'ACEITO';
      bFim := true;
      btn_total.Enabled := True;
      btn_PassoAPasso.Enabled := True;
      Exit;
    end
    //Pilha ainda possui elementos e Entrada vazia = Sentença Inválida
    else if (sLinha <> EmptyStr) and (sColuna = EmptyStr) then
    begin
      btn_total.Enabled := false;
      slEntrada.Add('$');
      slRegra.Add('Erro em ' + IntToStr(iLinha + 1) + ' Iterações');
      pnl_Resposta.Color := clRed;
      pnl_Resposta.Caption := 'ERRO';
      bFim := true;
      btn_total.Enabled := True;
      btn_PassoAPasso.Enabled := True;
      Exit;
    end
    //Pilha vazia e Entrada ainda possui elementos = Sentença Inválida
    else if (sLinha = EmptyStr) and (sColuna <> EmptyStr) then
    begin
      btn_total.Enabled := false;
      slEntrada.Add('$');
      slRegra.Add('Erro em ' + IntToStr(iLinha + 1) + ' Iterações');
      pnl_Resposta.Color := clRed;
      pnl_Resposta.Caption := 'ERRO';
      btn_total.Enabled := True;
      btn_PassoAPasso.Enabled := True;
      bFim := true;
      Exit;
    end;
    cds_tabparsing.First;
    while not cds_tabparsing.Eof do
    begin
      if cds_tabparsinginfo_1.AsString = sLinha then
      begin
        if dbg_parsing.Columns[1].Title.Caption = sColuna then
        begin
          j := 2;
          Break;
        end
        else if dbg_parsing.Columns[2].Title.Caption = sColuna then
        begin
          j := 3;
          Break;
        end
        else if dbg_parsing.Columns[3].Title.Caption = sColuna then
        begin
          j := 4;
          Break;
        end
        else if dbg_parsing.Columns[4].Title.Caption = sColuna then
        begin
          j := 5;
          Break;
        end
        else if dbg_parsing.Columns[5].Title.Caption = sColuna then
        begin
          j := 6;
          Break;
        end
        else
        begin
          j := -1;
          Break;
        end
      end;
      cds_tabparsing.Next;
    end;

    if j = -1 then
      Result := ''
    else
    begin
      if j = 2 then
        Result := cds_tabparsinginfo_2.AsString
      else if j = 3 then
        Result := cds_tabparsinginfo_3.AsString
      else if j = 4 then
        Result := cds_tabparsinginfo_4.AsString
      else if j = 5 then
        Result := cds_tabparsinginfo_5.AsString
      else if j = 6 then
        Result := cds_tabparsinginfo_6.AsString
    end;

  end;

  function BuscaLinha: String;
  begin
    Result := Copy(AnsiReverseString(slPilha[slPilha.Count - 1]), 1, 1);
  end;

  function BuscaColuna: String;
  begin
    Result := Copy(slEntrada[slEntrada.Count - 1], 1, 1);
  end;

  procedure MontaDerivacao;
  var
    sEps: string;
  begin
    //Substitui Não Terminal
    if (Copy(slRegra[slRegra.Count - 1], 1, 2) <> 'Lê') then
    begin
      if Copy(slRegra[slRegra.Count - 1],5,3) = 'E' then
        sEps := EmptyStr
      else if Copy(slRegra[slRegra.Count - 1],5,3) = '' then
      begin
        btn_total.Enabled := false;
        slEntrada.Add('$');
        slRegra.Add('Erro em ' + IntToStr(iLinha + 1) + ' Iterações');
        pnl_Resposta.Color := clRed;
        pnl_Resposta.Caption := 'ERRO';
        btn_total.Enabled := True;
        btn_PassoAPasso.Enabled := True;
        bFim := true;
        Exit;
      end
      else
        sEps := AnsiReverseString(Copy(slRegra[slRegra.Count - 1],5,3));

      slPilha[slPilha.Count - 1] := Copy(slPilha[slPilha.Count - 1], 1, Length(slPilha[slPilha.Count - 1]) - 1) + sEps;
    end
    else
    //Lê Terminal
    begin
      slEntrada[slEntrada.Count - 1] := Copy(slEntrada[slEntrada.Count - 1], 2, Length(slEntrada[slEntrada.Count - 1]));
      slRegra.Add(BuscaRegra(BuscaLinha, BuscaColuna));

      if bFim then
        slRegra.Delete(slRegra.Count - 1);
    end;

    if (not bFim) and (BuscaLinha = BuscaColuna) then
    begin
      slRegra.Add('Lê ' + BuscaLinha);
      bLer := true;
    end;
  end;

begin
  try
    if bFirst then
    begin
      Limpar;
      slPilha.Add('S');
      slEntrada.Add(edt_sentenca.Text);
      bFirst := false;
      slRegra.Add(BuscaRegra(BuscaLinha, BuscaColuna));
    end
    else
      MontaDerivacao;

    stg_Resultado.RowCount := stg_Resultado.RowCount + 1;
    stg_Resultado.Row := stg_Resultado.RowCount - 1;

    geraLinha;
  finally
    edt_sentenca.Enabled := bFim;
  end;
end;

procedure TfAnalisadorSintatico.stg_GramaticaDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  sTexto: String;
begin
  with TStringGrid(Sender) do
  begin
    Canvas.Brush.Color := clWhite;
    Canvas.FillRect(Rect); // Limpa o conteúdo da célula.
    sTexto := Cells[ACol, ARow];
    Canvas.TextRect(Rect, sTexto, [tfWordBreak, tfVerticalCenter, tfCenter]);
  end;
end;

procedure TfAnalisadorSintatico.stg_ResultadoDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  sTexto: String;
begin
  if ARow = 0 then
  begin
    with TStringGrid(Sender) do
    begin
      Canvas.Brush.Color := clWhite;
      Canvas.FillRect(Rect); // Limpa o conteúdo da célula.
      sTexto := Cells[ACol, ARow];
      Canvas.Font.Style := [fsBold];
      Canvas.TextRect(Rect, sTexto, [tfWordBreak, tfVerticalCenter, tfCenter]);
    end;
  end;
end;

procedure TfAnalisadorSintatico.tmrTimer(Sender: TObject);
begin
  Processar;

  if bFim then
    tmr.Enabled := false;
end;

end.
