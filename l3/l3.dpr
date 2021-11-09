program l3;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type
  tAr = array[1..12] of integer;
  tUser = 1..8;
  tTime = 1..10;
  tPrior = set of tUser;

var
  CurUser: tUser;
  users: array[tUser] of tAr=((3, 2, 1, 6, 3, 2, 5, 4, 0, 0, 0, 0),
                              (2, 1, 2, 3, 3, 1, 2, 6, 4, 0, 0, 0),
                              (4, 1, 6, 8, 5, 4, 2, 3, 1, 2, 0, 0),
                              (2, 4, 8, 9, 3, 2, 1, 6, 5, 9, 0, 0),
                              (9, 6, 7, 2, 3, 1, 4, 5, 1, 3, 2, 0),
                              (2, 3, 2, 1, 6, 3, 4, 1, 2, 3, 1, 0),
                              (3, 2, 3, 1, 3, 4, 1, 2, 1, 6, 1, 2),
                              (2, 3, 3, 3, 1, 6, 3, 8, 4, 2, 2, 2));

  prior: array[1..3] of tPrior = ([1, 2, 3], [4, 5], [6, 7, 8]);
  tact, proc: tTime;

function getTime: tTime;
  var
    tmp: integer;
  begin
    tmp:=11;
    while (tmp<0)or(tmp>10) do
      begin
        write('>');
        readln(tmp);
        if (tmp<0)or(tmp>10) then writeln('Incorrect input!')
          else RESULT:=tmp;
      end;
  end;

function isEmpty: boolean;
  var
    i, j: integer;
  begin
    for i:=
  end;

begin
  writeln('Enter tact time and processing time:');
  tact:=getTime;
  proc:=getTime;




end.
