program Notation;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type
  tRec = record
    relPrior, stPrior, rank: integer;
  end;

var
  stack: array[1..200] of char;
  SP: integer = 0;
  prior: array[char] of tRec;

procedure push(const CHR: char);
  begin
    inc(SP);
    stack[SP]:=CHR;
  end;

function pop: char;
  begin
    RESULT:=stack[SP];
    stack[SP]:=stack[SP+1];
    dec(SP);
    if sp<0 then sp:=0;

  end;

function peek: char;
  begin
    RESULT:=stack[SP];
  end;

procedure initialize;
  var
    i: char;
  begin
    for i := 'A' to high(prior) do
    with prior[i] do
      begin
        relPrior:=7;
        stPrior:=8;
        rank:=1;
      end;
  with prior['+'] do
      begin
        relPrior:=1;
        stPrior:=2;
        rank:=-1;
      end;
  with prior['-'] do
      begin
        relPrior:=1;
        stPrior:=2;
        rank:=-1;
      end;
  with prior['*'] do
      begin
        relPrior:=3;
        stPrior:=4;
        rank:=-1;
      end;
  with prior['/'] do
      begin
        relPrior:=3;
        stPrior:=4;
        rank:=-1;
      end;
  with prior['^'] do
      begin
        relPrior:=6;
        stPrior:=5;
        rank:=-1;
      end;
  with prior['('] do
      begin
        relPrior:=9;
        stPrior:=0;
        rank:=0;
      end;
  with prior[')'] do
      begin
        relPrior:=0;
        stPrior:=0;
        rank:=0;
      end;
  end;

function isEmpty: boolean;
  begin
    if SP=0 then RESULT:=true
      else RESULT:=false;
  end;

function rank(const STR: String): integer;
  var
    i: integer;
  begin
    RESULT:=0;
    for i := 1 to length(STR) do
      inc(RESULT, prior[STR[i]].rank);
  end;

var
  str, res: String;
  i, len: integer;
  chr, tmp: char;
begin
  initialize;
  writeln('Enter input string..');
  write('> ');
  readln(str);
    //str:='a+b*c-d/e*h';
    //str:='a+b';
    //str:='a+b+c';
    //str:='a+(b+c)';
    //str:='a+b*c';
    //str:='a';
    //str:='a*(b+c)';
    //str:='a*(b*c)';
    //str:='((a-b)*d+n^x^y)/(n+m)';
    //str:='x^y^z';
    //str:='(x^y)^z';
    writeln('   ',str);
  for i := 1 to length(str) do
    begin
      chr:=str[i];
      if isEmpty then
          push(chr)
        else
      if (prior[chr].relPrior > prior[peek].stPrior) then push(chr)
        else
          begin
            while (not isEmpty) and (prior[chr].relPrior < prior[peek].stPrior)  do
              begin
                if peek<>'(' then

                res:=res+pop;
              end;
            if not isEmpty then
                begin
                    if peek='(' then tmp:=pop;
                    //tmp:=pop;
                    if (chr<>')') then
                      push(chr);
                    //if (tmp<>'(') then
                     // res:=res+tmp;
                end
              else
                begin
                  if (chr<>')') then
                    push(chr);
                end;

          end;
    end;
  while not isEmpty do
    res:=res+pop;
  writeln('Polish notation:');
  writeln('   ',res);
  writeln('Rank is: ',rank(res));
  if rank(res)<>1 then writeln('RANK_ERROR!');

  readln;

end.
