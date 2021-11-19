unit Queue;

interface

type
  tAr = array[1..12] of integer;
  tUser = 0..8;
  tTime = 1..10;
  tPrior = set of tUser;

  tAdr = ^tEl;
  tEl =
  record
    user: tUser;
    next: tAdr;
  end;

var
  Head: tAdr;
  prior: array[1..3] of tPrior = ([1, 2, 3], [4, 5], [6, 7, 8]);
  users: array[1..8] of tAr=((3, 2, 1, 6, 3, 2, 5, 4, 0, 0, 0, 0),
                              (2, 1, 2, 3, 3, 1, 2, 6, 4, 0, 0, 0),
                              (4, 1, 6, 8, 5, 4, 2, 3, 1, 2, 0, 0),
                              (2, 4, 8, 9, 3, 2, 1, 6, 5, 9, 0, 0),
                              (9, 6, 7, 2, 3, 1, 4, 5, 1, 3, 2, 0),
                              (2, 3, 2, 1, 6, 3, 4, 1, 2, 3, 1, 0),
                              (3, 2, 3, 1, 3, 4, 1, 2, 1, 6, 1, 2),
                              (2, 3, 3, 3, 1, 6, 3, 8, 4, 2, 2, 2));
  busy: array[1..8] of integer = (0, 0, 0, 0, 0, 0, 0, 0);


  procedure init;
  function getNextUser: tUser;
  function isEmpty: boolean;

  function getUserTime(const USER: tUser): integer;
  procedure decUserTime(const USER: tUser; const TIME: integer);

  function getTaskSum: integer;

  procedure decBusy(const TIME: integer);
  procedure setBusy(const USER: tUser; const TIME: integer);

implementation

  procedure decBusy(const TIME: integer);
    var
      user: tUser;
    begin
      for user:=1 to 8 do
        if busy[user]>TIME then dec(busy[user], TIME)
            else busy[user]:=0;
    end;

  procedure setBusy(const USER: tUser; const TIME: integer);
    begin
      busy[USER]:=TIME;
    end;

  function isBusy(const USER: tUser): boolean;
    begin
      if busy[USER]<>0 then RESULT:=true
          else RESULT:=false;
    end;


  function getTaskSum: integer;
    var
      user: tUSer;
      i: integer;
    begin
      RESULT:=0;
      for i:=1 to 12 do
        for user:=1 to 8 do
          inc(RESULT, users[user, i]);
    end;

  function getUserTime(const USER: tUser): integer;
    var
      j: integer;
    begin
      j:=1;
      while (j<=12)and(users[USER, j]=0) do
        inc(j);
      RESULT:=users[USER, j];
    end;

  function isEmpty: boolean;
    begin
      if (Head^.next = nil) then RESULT:=true
          else RESULT:=false;
    end;

  function getPrior(const curUser: tUser): tUSer;
  var
    i: integer;
  begin
    for i := 1 to 3 do
      if (curUser IN prior[i]) then RESULT:=i;
  end;

  function pop: tUser;
    var
      adr, tmp: tAdr;
    begin
                                     //список гарантированно не пуст
      adr:=Head;
      while (adr^.next<>nil) do
        begin
          if not isBusy(adr^.next.user) then
              begin
                RESULT:=adr^.next.user;
                tmp:=adr;
                break;
              end;
          adr:=adr^.next;
        end;
      if (adr^.next=nil) then RESULT:=0
        else
          begin
            adr:=tmp^.next;
            tmp^.next:=adr^.next;
            dispose(adr);
          end;
    end;

  procedure push(const USER: tUser);
    var
      adr, tmp: tAdr;
      f: boolean;
    begin
      new(adr);
      adr^.user := USER;

      tmp:=Head;
      if tmp^.next=nil then f:=false
        else f:=true;


      while f do
        begin
          if tmp^.next=nil then f:=false
            else if (getPrior(tmp^.next^.user)>getPrior(adr^.user)) then f:=false;
          if f then tmp:=tmp^.next;
        end;

      adr^.next:=tmp^.next;
      tmp^.next:=adr;
    end;

  function isHaveJob(const USER: tUser): boolean;
    var
      i: integer;
    begin
      RESULT:=false;
      for i:=1 to 12 do
        if (users[USER, i]<>0) then RESULT:=true;
    end;

  procedure clearGarbage;
    var
      adr, tmp: tAdr;
    begin
      adr:=Head;
      while adr^.next<>nil do
        begin
          if not isHaveJob(adr^.next^.user) then
              begin

                tmp:=adr^.next;
                 writeln('WRN: GARBAGE: user ', tmp^.user);
                adr^.next:=tmp^.next;
                dispose(tmp);
              end;
          if adr^.next<>nil then adr:=adr^.next;
        end;
    end;

  function getNextUser: tUser;
    begin
      clearGarbage;

      //извлечь юзера
      //если у него ещё есть работа - а она пока типа ещё есть - положить его назад

      //контроль занятости проводит pop()
      if not isEmpty then
          RESULT:=pop
        else RESULT:=0;

      if RESULT<>0 then
          push(RESULT);
    end;

  procedure init;
  var
    i: tUser;
  begin
    new(Head);
    Head^.user := 1;
    Head^.next := nil;
    for i:=1 to 8 do
      push(i);
  end;

  procedure decUserTime(const USER: tUser; const TIME: integer);
    var
      i: integer;
    begin
      i:=1;
      while (i<=12)and(users[USER, i]=0) do
        inc(i);
      dec(users[USER, i], TIME);
    end;

end.


