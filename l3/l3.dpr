program l3;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Queue in 'Queue.pas';

var
  CurUser: tUser;
  users: array[1..8] of tAr=((3, 2, 1, 6, 3, 2, 5, 4, 0, 0, 0, 0),
                              (2, 1, 2, 3, 3, 1, 2, 6, 4, 0, 0, 0),
                              (4, 1, 6, 8, 5, 4, 2, 3, 1, 2, 0, 0),
                              (2, 4, 8, 9, 3, 2, 1, 6, 5, 9, 0, 0),
                              (9, 6, 7, 2, 3, 1, 4, 5, 1, 3, 2, 0),
                              (2, 3, 2, 1, 6, 3, 4, 1, 2, 3, 1, 0),
                              (3, 2, 3, 1, 3, 4, 1, 2, 1, 6, 1, 2),
                              (2, 3, 3, 3, 1, 6, 3, 8, 4, 2, 2, 2));


  tact, proc: tTime;
  graph: array[1..8, 1..1000] of integer;


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
    RESULT:=true;
    for i := 1 to 8 do
      for j := 1 to 12 do
        if users[i, j]<>0 then RESULT:=false;
  end;

function getUserTime(const USER: tUser): integer;
  begin
    RESULT:=active[USER];
  end;

begin
  writeln('Enter tact time and processing time:');
  tact:=getTime;
  proc:=getTime;




end.
