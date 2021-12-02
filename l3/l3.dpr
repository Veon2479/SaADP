program l3;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Queue in 'Queue.pas';

var
  CurUser: tUser;
  userTime, curTime, t, sum: integer;
  eff: real;

  tact, proc: tTime;
  graph: array[1..8, 1..1000] of integer;


  function getTime: tTime;
    var
      tmp: integer;
    begin
      tmp:=11;
      while (tmp<0)or(tmp>10) do
        begin
          write('> ');
          readln(tmp);
          if (tmp<0)or(tmp>10) then writeln('Incorrect input!')
            else RESULT:=tmp;
        end;
    end;

  procedure localInit;
    var
      i: tUser;
      j: integer;
    begin
      init;
      for i := 1 to 8 do
        for j := 1 to 1000 do
          graph[i, j]:=-1;
      curTime:=1;
    end;
                  //0 - nothing, 1 - read, 2 - computing
  procedure fillRead(const USER: tUser; const OFFSET, TIME: integer);
    var
      i: integer;
      curUser: tUSer;
    begin
      for i := 1 to tact do
        for curUser := 1 to 8 do
          if (graph[curUser, OFFSET+i-1] = -1) then
            if (USER=curUser) then
                begin
                  if (i<=TIME) then
                      graph[curUser, OFFSET+i-1]:=1
                    else graph[curUser, OFFSET+i-1]:=0;
                end
              else
                begin
                  graph[curUser, OFFSET+i-1]:=0;
                end;
    end;

  procedure fillCompute(const USER: tUSer; const OFFSET: integer);
    var
      i: integer;
    begin
      for i := 1 to proc do
        if (graph[USER, OFFSET+i-1]<>-1) and (graph[USER, OFFSET+i-1]<>0)  then
                writeln('ERR: COMPUTING_NOT_NULL at (user, i, sym): (',USER,', ',OFFSET+i-1,', ',graph[USER, OFFSET+i-1],')')
            else graph[USER, OFFSET+i-1]:=2;
    end;

  function isFree(const USER: tUser; const OFFSET: integer): boolean;
    begin
      if (graph[USER, OFFSET]<>-1) then RESULT:=false
          else RESULT:=true;
    end;

  procedure normalize(var OFFSET: integer);
    var
      user: tUser;
      i: integer;
    begin
      i:=0;
      for user:=1 to 8 do
        if (graph[user, OFFSET]<>-1) then inc(i);
      if i<>0 then
        begin
          fillRead(user, OFFSET, 0);
          inc(OFFSET, tact);
        end;
    end;

  procedure saveGraph(const OFFSET: integer);
    var
      user: tUSer;
      i: integer;
      f: textFile;
    begin
      assignFile(f, 'graph.txt');
      rewrite(f);

      for user := 1 to 8 do
        begin
          for i := 1 to OFFSET-1 do
            begin
              write(f, graph[USER, i]);
              if (i mod tact = 0) then write(f, ' ');

            end;
          writeln(f);
        end;
      closeFIle(F);

    end;

  function validate(const OFFSET: integer): boolean;
    var
      user: tUser;
      i, k: integer;
    begin
      RESULT:=true;
      for i := 1 to OFFSET-1 do
        begin
          k:=0;
          if graph[user, i]=1 then inc(k);
        end;
      if k>1 then
        begin
          writeln('ERR: MULTI_INPUT at (user, i): (',user,', ',i,')');
          RESULT:=false;
        end;
    end;


var
  i: integer;


begin
  writeln('Enter tact time and processing time:');
  sum:=getTaskSum;
  tact:=getTime;
  proc:=getTime;
  localInit;
  while not isEmpty do
    begin
      curUser:=getNextUser;
      if curUser<>0 then
        begin
              userTime:=getUserTime(curUser);

              if userTime<=0 then writeln('ERR: ZERO_USER_TIME at (user, i): (',curUser,', ',curTime,')');

              if (userTime<=tact) then
                  begin
                    fillRead(curUser, curTime, userTime);
                    fillCompute(curUser, curTime+userTime);
                    decUserTime(curUSer, userTime);
                    setBusy(curUser, userTime+proc);
                  end
                else
                  begin
                    fillRead(curUser, curTime, tact);
                    decUserTime(curUSer, tact);
                    setBusy(curUser, tact);
                  end;
        end
        else
          fillRead(curUser, curTime, 0);
      inc(curTime, tact);
      decBusy(tact);
    end;
  normalize(curTime);

  validate(curTime);


  i:=0;
 { for curUser := 1 to 8 do
    if graph[curUser, curTime]<>0 then inc(i);
  if i<>0 then dec(curTime);  }
  if proc = 0 then dec(curTime, tact);
  if (proc = 0) and (tact = 1) then dec(curTime, 1);

  eff:=sum/curTime;
    saveGraph(curTime);




  writeln('all time is: ',curTime);
  writeln('sum of time of tasks: ',sum);
  writeln('ÊÏÄ = ',eff:6:4);
  writeln('..');
  readln;
end.
