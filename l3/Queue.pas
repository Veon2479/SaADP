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
  active: array[1..8] of integer = (0, 0, 0, 0, 0, 0, 0, 0);

  function getPrior(const curUser: tUser): tUSer;
  function getNextUser(const curUser: tUser): tUser;

implementation



  function getPrior(const curUser: tUser): tUSer;
  var
    i: integer;
  begin
    for i := 1 to 3 do
      if (curUser IN prior[i]) then RESULT:=i;
  end;

  function getNextUser(const curUser: tUser): tUser;   //*****
    begin

    end;

  function pop: tUser; //******
    begin

    end;

  procedure push(const USER: tUser); //******
    var
      adr: tAdr;
    begin
      new(adr);
      adr^.user := USER;

      if Head^.next = nil then Head^.next:=adr
        else
          begin

          end;

    end;



end.

Initialization
  new(Head);
  Head^.user := 1;
  Head^.next := nil;
end.
