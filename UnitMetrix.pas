unit UnitMetrix;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, RegExpr, Grids;

type

  TFormMetrix = class(TForm)
    MemoCode: TMemo;
    LCode: TLabel;
    OpenDlgCode: TOpenDialog;
    PCMetrix: TPageControl;
    TShCode: TTabSheet;
    TShSpan: TTabSheet;
    MemoLocalVariables: TMemo;
    EditAverageSpan: TEdit;
    LLocalVariables: TLabel;
    LGlobalVariables: TLabel;
    GBChekedAction: TGroupBox;
    BOpenCode: TButton;
    BCorrectCode: TButton;
    BSpanMetrix: TButton;
    EditRowsCount: TEdit;
    LRowsCount: TLabel;
    LAverageSpan: TLabel;
    StringGridGlobalVariables: TStringGrid;
    procedure BOpenCodeClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TextClear;
    procedure CreateListOfReserveWords;
    Function  FunctionNameInString(ChekedString : string) : string;
    procedure BCorrectCodeClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure MemoCodeKeyPress(Sender: TObject; var Key: Char);
    procedure TShSpanShow(Sender: TObject);
    procedure Span;
    procedure ProcessedFunction(ProcFunctionName : string);
    procedure FindVariables;
    Procedure MakeMetrix;
    procedure BSpanMetrixClick(Sender: TObject);
 end;

var
  FormMetrix : TFormMetrix;
  StringListCode, StringListReserveWords : TStringList;
  VariablesCount, ProgramSpan, VariableSpan, ProcessingStringNumber, EndFunctionStringNumber : integer;

implementation

{$R *.dfm}


Procedure TFormMetrix.FormActivate(Sender : TObject);
begin
  StringListCode := TStringList.Create;
end;

Procedure TFormMetrix.MemoCodeKeyPress(Sender: TObject; var Key: Char);
begin
  EditRowsCount.Text := IntToStr(MemoCode.Lines.Count);
end;

Procedure TFormMetrix.BOpenCodeClick(Sender : TObject);
begin
  if OpenDlgCode.Execute then
  begin
    MemoCode.Lines.LoadFromFile(OpenDlgCode.FileName);
    StringListCode.LoadFromFile(OpenDlgCode.FileName);
    EditRowsCount.Text := IntToStr(MemoCode.Lines.Count);
  end;
end;


Procedure TFormMetrix.TextClear;

procedure DeleteGaps;
var
  count : integer;
begin
  for count := 0 to StringListCode.Count-1 do
  begin
  if (length(StringListCode[count]) > 0) then
    if (StringListCode[count][length(StringListCode[count])] = ' ') and
      (length(StringListCode[count]) > 1) then
    repeat
      StringListCode[count] := Copy(StringListCode[count],1,length(StringListCode[count])-1);
    until (StringListCode[count][length(StringListCode[count])] <> ' ') or (length(StringListCode[count]) = 1);
  end;
end;

procedure DeleteLongComments;

const
  OpenCommentSymbols = '/*';
  CloseCommentSymbols = '*/';
var
  SymbolOpenCommentCount, SymbolCloseCommentCount, RowsCount, StartCommentPosition,
  EndCommentPosition, counter, StartCommentStringNumber,EndCommentStringNumber, ChekedSymbolPosition : integer;
  ChekedSymbols:string[2];
  FindCommentSymbols : boolean;

begin
  SymbolOpenCommentCount := 0;
  SymbolCloseCommentCount := 0;

  StartCommentStringNumber := 0;
  EndCommentStringNumber := 0;

  StartCommentPosition := 0;
  EndCommentPosition := 0;

  RowsCount := 0;
  while RowsCount < StringListCode.Count do
  begin
    ChekedSymbolPosition := 1;
    while ChekedSymbolPosition < length(StringListCode[RowsCount])do
    begin
      FindCommentSymbols := false;
      ChekedSymbols := Copy(StringListCode[RowsCount], ChekedSymbolPosition, 2);
      if ChekedSymbols = OpenCommentSymbols then
      begin
        FindCommentSymbols := true;
        if (SymbolOpenCommentCount = 0) then
        begin
          StartCommentPosition := ChekedSymbolPosition;
          StartCommentStringNumber := RowsCount;
        end;
        Inc(SymbolOpenCommentCount);
      end
      else
      begin
        if ChekedSymbols = CloseCommentSymbols then
        begin
          FindCommentSymbols := true;
          if (SymbolCloseCommentCount = SymbolOpenCommentCount-1) then
          begin
            EndCommentPosition := ChekedSymbolPosition+1;
            EndCommentStringNumber := RowsCount;
          end;
          Inc(SymbolCloseCommentCount);
        end;
      end;

      if not FindCommentSymbols then
        inc(ChekedSymbolPosition)
      else
        ChekedSymbolPosition := ChekedSymbolPosition+2;
    end;

    if (SymbolOpenCommentCount = SymbolCloseCommentCount) and (SymbolOpenCommentCount <> 0) then
    begin
      if (EndCommentStringNumber = StartCommentStringNumber) then
        StringListCode[StartCommentStringNumber] := Copy(StringListCode[StartCommentStringNumber], 1, StartCommentPosition-1)
        + Copy(StringListCode[StartCommentStringNumber], EndCommentPosition+1, length(StringListCode[StartCommentStringNumber])-EndCommentPosition)
      else
      begin
        for counter := StartCommentStringNumber+1 to  EndCommentStringNumber-1 do
          StringListCode[counter] := ' ';
        StringListCode[StartCommentStringNumber] := Copy(StringListCode[StartCommentStringNumber], 1, StartCommentPosition-1);
        StringListCode[EndCommentStringNumber] := Copy(StringListCode[EndCommentStringNumber], EndCommentPosition+1, length(StringListCode[EndCommentStringNumber])-EndCommentPosition);
      end;
      SymbolOpenCommentCount := 0;
      SymbolCloseCommentCount := 0;
    end;

    Inc(RowsCount);
  end;
end;


procedure DeleteComments;
var
  FindComments : TRegExpr;
begin
  FindComments := TRegExpr.Create;
  FindComments.InputString := StringListCode.Text;
  FindComments.Expression := '('#39'(.*?)'#39')';
  if (FindComments.Exec(StringListCode.Text)) then
    StringListCode.Text := FindComments.Replace(StringListCode.Text,'');
  FindComments.Expression := '(//(.*?)\n)|(///(.*?)\n)|(\/\*\*\(.*?)\*\/)';
  if (FindComments.Exec(StringListCode.Text)) then
    StringListCode.Text := FindComments.Replace(StringListCode.Text,'');
  FindComments.Free;
end;

begin
  DeleteGaps;
  DeleteLongComments;
 // DeleteComments;
end;


Procedure TFormMetrix.CreateListOfReserveWords;
begin
  StringListReserveWords := TStringList.Create;
  with StringListReserveWords do
  begin
    Add('void');
    Add('object');
    Add('string');
    Add('byte');
    Add('sbyte');
    Add('int');
    Add('uint');
    Add('short');
    Add('ushort');
    Add('long');
    Add('ulong');
    Add('float');
    Add('double');
    Add('char');
    Add('bool');
    Add('decimal');
  end;
end;

Function TFormMetrix.FunctionNameInString(ChekedString : string) : string;
var
  FindFunction : boolean;
  CountReservWord : integer;
  NewFunctionName : string;

function SearchFunctionDeclaration(SubString, SearchString : string) : string;
var
  StartOfName, EndOfName : integer;
begin
  Result := '';
  SubString := SubString+' ';
  if SearchString <> '' then
  begin
    if (SearchString[length(SearchString)] = ')') then
      if (pos(SubString, SearchString) <> 0) then
      begin
        EndOfName := pos('(', SearchString);
        StartOfName := pos(SubString, SearchString)+length(SubString);
        Result := Copy(SearchString, StartOfName, EndOfName-StartOfName);
      end;
  end;
end;

begin
  Result := '';
  CountReservWord := 0;
  FindFunction := false;
  while (CountReservWord < StringListReserveWords.Count) and (not (FindFunction))  do
  begin
    NewFunctionName := SearchFunctionDeclaration(StringListReserveWords[CountReservWord], ChekedString);
    if NewFunctionName <> '' then
    begin
      FindFunction := true;
      Result := NewFunctionName;
    end;
    Inc(CountReservWord);
  end;
end;

function ExistInString(ChekedVariableName, StringForSearch : string ) : integer;
var
  VariablesPosition : integer;
begin
  Result := 0;
  VariablesPosition := pos(ChekedVariableName, StringForSearch);
  if (VariablesPosition <> 0) and (not (StringForSearch[VariablesPosition-1] in ['a'..'z','A'..'Z','а'..'я','А'..'Я']))
   and (not (StringForSearch[VariablesPosition+length(ChekedVariableName)+1] in ['a'..'z','A'..'Z','а'..'я','А'..'Я']))  then
        Result := VariablesPosition;
end;

function VariableDeclarationInString(StringForSearch : string) : string;
var
  findWord : boolean;
  ReserveWordCounter, StartOfName : integer;
  SubString : string;
begin
  result := '';
  if StringForSearch <> '' then
    if (StringForSearch[length(StringForSearch)] = ';') or (StringForSearch[length(StringForSearch)] = ')')  then
    begin
      findWord := false;
      ReserveWordCounter := 1;
      while (ReserveWordCounter < StringListReserveWords.Count) and (not findWord) do
      begin
        SubString := StringListReserveWords[ReserveWordCounter];
        if ((pos(SubString+' ', StringForSearch)<>0) and (StringForSearch[length(StringForSearch)] = ';')) or
          ((StringForSearch[length(StringForSearch)] = ')') and (pos('(',StringForSearch)<length(StringForSearch))) then
        begin
          findWord := true;
          Result:='';
          StartOfName := pos(SubString, StringForSearch)+length(SubString)+1;
          if ((StringForSearch[length(StringForSearch)] = ')') and (pos('(',StringForSearch)<length(StringForSearch))
           and (pos('(',StringForSearch)<StartOfName)) or  (StringForSearch[length(StringForSearch)] = ';') then
            while StringForSearch[StartOfName] in ['a'..'z','A'..'Z','а'..'я','А'..'Я','0'..'9','_','*'] do
            begin
              Result := Result + StringForSearch[StartOfName];
              inc(StartOfName);
            end;
        end
        else
          Inc(ReserveWordCounter);
      end;
    end;
end;

function CountingSpanOneVariable (CheckedVariableName : string; StartCheckStringNumber, EndCheckStringNumber : integer) : integer;
var
  OneVariableSpan, VariablePositionInString, StringForCheckVariableNumber : integer;
begin
  OneVariableSpan := 0;
  StringForCheckVariableNumber := StartCheckStringNumber;
  while StringForCheckVariableNumber < EndCheckStringNumber do
  begin
    repeat
      VariablePositionInString := ExistInString(CheckedVariableName, StringListCode[StringForCheckVariableNumber]);
      if VariablePositionInString <>0 then
      begin
        Inc(OneVariableSpan);
        StringListCode[StringForCheckVariableNumber] := Copy(StringListCode[StringForCheckVariableNumber],1, VariablePositionInString-2)+Copy(StringListCode[StringForCheckVariableNumber], VariablePositionInString+length(CheckedVariableName), length(StringListCode[StringForCheckVariableNumber])- (VariablePositionInString+length(CheckedVariableName)));
      end;
    until VariablePositionInString=0;
    inc(StringForCheckVariableNumber);
  end;
  result := OneVariableSpan;
end;

procedure TFormMetrix.FindVariables;
var
  VariableName : string;
  VariableSpan, counter : integer;
begin
  for counter := ProcessingStringNumber to EndFunctionStringNumber do
  begin
    repeat
      VariableName := VariableDeclarationInString(StringListCode[counter]);
      if VariableName <> '' then
      begin
        VariableSpan := CountingSpanOneVariable (VariableName, counter, EndFunctionStringNumber)-1;
        if EndFunctionStringNumber = StringListCode.Count-1 then
        begin
          StringGridGlobalVariables.Height := StringGridGlobalVariables.Height+20;
          StringGridGlobalVariables.RowCount := StringGridGlobalVariables.RowCount+1;
          StringGridGlobalVariables.Cells[0,StringGridGlobalVariables.RowCount] := VariableName;
          StringGridGlobalVariables.Cells[1,StringGridGlobalVariables.RowCount] := IntToStr(VariableSpan);
        end
        else
          MemoLocalVariables.Lines.Add(VariableName+IntToStr(VariableSpan));
        inc(VariablesCount);
        inc(ProgramSpan, VariableSpan);
      end;
    until VariableName = '';
  end;
end;

procedure TFormMetrix.ProcessedFunction(ProcFunctionName : string);

function FindEndStringFunctionNumber : integer;
var
  OpenBracketCount, CloseBracketCount, CurrentStringNumber : integer;
begin
  OpenBracketCount := 0;
  CloseBracketCount := 0;
  CurrentStringNumber := ProcessingStringNumber;
  repeat
    if pos('{', StringListCode[CurrentStringNumber])<>0 then
      inc(OpenBracketCount);
    if pos('}', StringListCode[CurrentStringNumber])<>0 then
      inc(CloseBracketCount);
    Inc(CurrentStringNumber);
  until (OpenBracketCount=CloseBracketCount) and (OpenBracketCount<>0);
  result := CurrentStringNumber-1;
end;

begin
  MemoLocalVariables.Lines.Add(ProcFunctionName);
  EndFunctionStringNumber := FindEndStringFunctionNumber();
  FindVariables;
  ProcessingStringNumber := EndFunctionStringNumber+1;
end;


procedure TFormMetrix.Span;
var
  FindFunctionName, ChekedString : string;
begin
  ProcessingStringNumber := 0;
  while ProcessingStringNumber < StringListCode.Count do
  begin
    ChekedString := StringListCode[ProcessingStringNumber];
    if ChekedString <> '' then
    begin
      FindFunctionName := FunctionNameInString(ChekedString);
      if FindFunctionName <> '' then
        ProcessedFunction(FindFunctionName)
    end;
    inc(ProcessingStringNumber);
  end;
  ProcessingStringNumber := 0;
  EndFunctionStringNumber := StringListCode.Count-1;
  FindVariables;
end;


Procedure TFormMetrix.FormPaint(Sender: TObject);
begin
  EditRowsCount.Text := '0';
end;

Procedure TFormMetrix.MakeMetrix;
begin
  ProgramSpan := 1;
  VariablesCount := 0;
  CreateListOfReserveWords;
  Span;
  ProgramSpan := ProgramSpan div VariablesCount;
  EditAverageSpan.Text:=IntToStr(ProgramSpan);
end;

Procedure TFormMetrix.BSpanMetrixClick(Sender : TObject);
begin
  if MemoCode.Text = '' then
    MessageDLG('Загрузите код!',mtError,[mbOk],0)
  else
  begin
    MemoLocalVariables.Clear;
    TextClear;
    PCMetrix.ActivePageIndex := 1;
    MakeMetrix;
  end;
end;

procedure TFormMetrix.BCorrectCodeClick(Sender: TObject);
begin
   if MemoCode.Text = '' then
    MessageDLG('Загрузите код!',mtError,[mbOk],0)
  else
  begin
    TextClear;
    MemoCode.Text := StringListCode.Text;
    EditRowsCount.Text := IntToStr(MemoCode.Lines.Count);
  end;
end;


procedure TFormMetrix.TShSpanShow(Sender: TObject);
begin
  with StringGridGlobalVariables do
  begin
    Cells[0,0]:='Переменная';
    Cells[1,0]:='Спен';
    RowHeights[0]:=24;
  end;

  MemoLocalVariables.Lines.Add('Функция '+'   Переменная '+'   Спен');
end;

end.
