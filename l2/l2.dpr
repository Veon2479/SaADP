program l2;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type
  tString = String[20];


  tNumAdr = ^tNumEl;
  tNumEl =
    record
      field: integer;
      next: tNumAdr;
    end;

  tField =
    record
      Term: tString;
      lvl: byte;
    end;

  tAdr = ^tEl;
  tEl =
    record
      Field: tField;
      subTerms: tAdr;
      Pages: tNumAdr;
      Next: tAdr;
    end;

  tFile = file of TField;
  tPages = file of integer;

const
  LEN = 200;
  PATH_F = 'field.txt';
  PATH_P = 'pages.txt';
var
  Head: tAdr;
  Table: array[1..LEN] of tAdr;

procedure Done;
  begin
    writeln('   Done..');
  end;


function getParent(const ADR: tAdr): tAdr;
  var
    i: integer;
    cur: tAdr;
    f: boolean;
  begin
    if adr^.field.lvl=1 then RESULT:=nil
      else
        for i:=1 to LEN do
          if Table[i]<> nil then
            begin
              cur:=Table[i]^.subTerms;
              if cur^.Next<>nil then f:=true
                else f:=false;
              while f do
                begin
                  cur:=cur^.Next;
                  if cur=ADR then RESULT:=Table[i];
                  if cur^.Next=nil then f:=false;
                end;
            end;

  end;

function getHead(const ADR: tAdr): tAdr;
  begin
    RESULT:=getParent(ADR);
    if RESULT=nil then RESULT:=Head
      else RESULT:=RESULT^.subTerms;
  end;


function getStr: tString;
  begin
    RESULT:='';
    while RESULT='' do
      begin
        write('> ');
        readln(RESULT);
      end;
  end;

function getNumber: integer;
  var
    str: string;
    code: integer;
  begin
    code:=1;
    while code<>0 do
      begin
        str:=getStr;
        val(str, RESULT, code);
        if code<>0 then writeln(' Incorrect Input!');
      end;

  end;

procedure setLvl(adr: tAdr; const LVL: byte);
  begin
    adr^.Field.lvl:=LVL;
  end;

function getLvl(adr: tAdr): byte;
  begin
    RESULT:=adr^.Field.lvl;
  end;

procedure newHead(var adr: tAdr);
  begin
    new(adr);
    with adr^, adr^.field do
      begin
        Term:='';
        lvl:=1;
        subTerms:=nil;
        Pages:=nil;
        Next:=nil;
      end;
  end;

procedure newNumHead(var adr: tNumAdr);
  begin
    new(adr);
    adr^.field:=0;
    adr^.Next:=nil;
  end;

procedure Initiate;
  var
    i: integer;
  begin
    newHead(Head);
    for i:=1 to 200 do
      Table[i]:=nil;

  end;

procedure writeTerm(const TERM: tAdr);
  var
    i: integer;
  begin
    for i:=2 to TERM^.field.lvl do
      write('   -');
    write('   ',TERM^.field.Term);
  end;

procedure writePages(const HEAD: tNumAdr);
  var
    cur: tNumAdr;
  begin
    cur:=HEAD;
    write(' - ');
    while cur^.Next<>nil do
      begin
        cur:=cur^.Next;
        write(cur^.field,' ');
      end;
  end;

procedure writeIndex(const HEAD: tAdr);
  var
    cur: tAdr;
  begin
    cur:=HEAD;
   
    while cur^.NEXT<>nil do
      begin
        cur:=cur^.Next;
        writeTerm(cur);
        writePages(cur^.Pages);
        writeln;
        if cur^.subTerms<>nil then writeIndex(cur^.subTerms);
      end;
  end;

procedure uiView;

  begin
    writeln('   Index:');
    if Head^.Next=nil then
      writeln('       There''s nothing to see..');
    writeIndex(Head);
    writeln('   Press any key..');
    readln;
  end;

function hash(const STR: tString): integer;
  var
    i: integer;
  begin
    RESULT:=0;
    for i:=1 to length(STR) do
      inc(RESULT, ord(STR[i]));
    i:=RESULT;
    RESULT:=0;
    while i<>0 do
      begin
        inc(RESULT, (i mod 10)*7);
        i:= i div 10;
      end;
    RESULT:=RESULT mod LEN;
  end;

function isExist(const STR: tString): integer;
  var
    tmp, i: integer;
    f: boolean;
  begin
    RESULT:=-1;
    f:=true;
    tmp:=hash(STR);
    i:=tmp;
    while f do
      begin
        if Table[i]<>nil then
          if (Table[i].field.Term=STR) then
            begin
              RESULT:=i;
              f:=false;
            end;

              inc(i);
              if i>=LEN then i:=1;
              if i=tmp then f:=false;

      end;

  end;

function addNumEl(const lastEl: tNumAdr): tNumAdr;
  begin
    RESULT:=nil;
    new(RESULT);
    lastEl^.next:=RESULT;
    RESULT^.next:=nil;
  end;

procedure enterPages(var HEAD: tNumAdr);
  var
    isCont: boolean;
    code, num: integer;
    str: tString;
    cur: tNumAdr;
  begin
    writeln('   Enter page numbers, to terminate enter ''0''');
    isCont:=true;
    cur:=HEAD;
    while isCont do
      begin
        str:='';
        num:=0;
        code:=0;
        write('> ');
        readln(str);
        val(str, num, code);
        if code=0 then
          begin
            if num=0 then
                begin
                  isCont:=false;
                end
              else
                begin
                  cur:=addNumEl(cur);
                  cur^.field:=num;
                end;
          end
        else writeln('    Incorrect input!');

      end;

  end;

procedure hashAdd(const ADR: tAdr);
  var
    tmp, i: integer;
    f: boolean;
  begin
    i:=hash(ADR^.Field.Term);
    tmp:=i;
    f:=true;
    while f do
      begin
        if Table[i]=nil then
            begin
              Table[i]:=ADR;
              f:=false;
            end
          else
            begin
              inc(i);
              if i>=LEN then i:=1;
            end;
      end;

  end;

procedure enterEl(const EL: tAdr);
  var
    fl: boolean;
    str: tString;
  begin
    fl:=true;
    while fl do
      begin
        writeln('  Enter Term:');
        write('> ');
        readln(str);
        if isExist(str)=-1 then
          begin
            EL^.field.Term:=str;
            fl:=false;
          end
        else writeln('    Incorrect input, there''s already such term!');
      end;
    hashAdd(EL);

    writeln('   Enter pages:');
    enterPages(EL^.Pages);
  end;

function addEl(const lastEl: tAdr): tAdr;
  begin
    RESULT:=nil;
    new(RESULT);
    lastEl^.Next:=RESULT;
    RESULT^.Next:=nil;
    newHead(RESULT^.subTerms);
    newNumHead(RESULT^.Pages);
    enterEl(RESULT);


  end;

function lastEl(const HEAD: tAdr): tAdr;
  begin
    RESULT:=HEAD;
    while RESULT^.Next<>nil do
      RESULT:=RESULT^.Next;
  end;


function uiAdd(const HEAD: tADr): tAdr;
  var
    tmp: tAdr;
  begin
    writeln('   Adding new term..');
    tmp:=lastEl(HEAD);
    tmp:=addEl(tmp);

    RESULT:=tmp;
    writeln('   Done!');
  end;

procedure delNumList(const HEAD: tNumAdr);
  var
    cur: tNumAdr;
  begin
    while HEAD^.Next<>nil do
      begin
        cur:=HEAD^.Next;
        HEAD^.Next:=cur^.Next;
        dispose(cur);
      end;
  end;

procedure hashDel(const ADR: tAdr);
  var
    num: integer;
  begin
    num:=isExist(ADR^.field.Term);
    if num<>-1 then Table[num]:=nil;
  end;

procedure HeadDestroy(var HEAD: tAdr);         //doesn't destroy ADR
  var
    cur: tAdr;
  begin
    cur:=HEAD;
    while HEAD^.Next<>nil do
      begin
        cur:=HEAD^.Next;
        HEAD^.Next:=cur^.Next;
        delNumList(cur^.Pages);
        dispose(cur^.Pages);
        if cur^.subTerms<>nil then HeadDestroy(cur^.subTerms);
        dispose(cur^.subTerms);
        hashDel(cur);
        dispose(cur);
      end;
  end;

procedure delEl(var EL: tAdr);
  var
    cur: tAdr;
  begin

    cur:=getHead(EL);
    while cur^.Next<>EL do
      cur:=cur^.Next;
    cur^.Next:=EL^.Next;
    HeadDestroy(EL^.subTerms);
    delNumList(EL^.Pages);
    dispose(EL^.subTerms);
    dispose(EL^.Pages);
    hashDel(EL);
    dispose(EL);
  end;

procedure uiSelect;
  var
    str: tString;
    num, numEl: integer;
    f: boolean;
    tmp: tAdr;
  begin
    writeln('   Enter term:');
    str:=getStr;
    numEl:=isExist(str);
    if (numEl=-1) then writeln('  Aborted, there''s no such element..')
      else
        begin

          f:=true;
          while f do
            begin

              f:=false;
              writeln(' Enter:');
              writeln(' 1 - for adding subterm');
              writeln(' 2 - for changing term');
              writeln(' 3 - for re-entering pages');
              writeln(' 4 - for deleting this term (and all of it''s subterms)');
              num:=getNumber;
              case num of
                1:
                  begin
                    tmp:=Table[numEl];
                    setLvl(uiAdd(tmp^.subTerms), getLvl(tmp)+1);
                    Done;
                  end;
                2:
                  begin
                    writeln(' Enter new term:');
                    str:=getStr;
                    Table[numEl]^.field.Term:=str;
                    tmp:=Table[numEl];
                    Table[numEl]:=nil;
                    hashAdd(tmp);
                    Done;
                  end;
                3:
                  begin
                    delNumList(Table[numEl]^.Pages);
                    enterPages(Table[numEl]^.Pages);
                    Done;
                  end;
                4:
                  begin
                    delEl(Table[numEl]);
                    Done;
                  end
                else
                  begin
                    writeln('  Incorrect input!');
                    f:=true;
                  end;
              end;
            end;
        end;
  end;

procedure swap(var PREV1, PREV2: tAdr);    //PREV1^.Next...^.Next=PREV2
  var
    tmp: tAdr;
  begin
    if PREV1<>PREV2 then
      begin
        tmp:=PREV1;
        if PREV1^.Next=PREV2 then
            begin
              PREV1:=PREV2;
              PREV2:=PREV1^.Next;
              PREV1^.next:=tmp;
            end
          else
            begin
              PREV1:=PREV2;
              PREV2:=tmp;
              tmp:=PREV2^.next;
              PREV2^.Next:=PREV1^.Next;
              PREV1^.Next:=tmp;
            end;
      end;
  end;

procedure sort(const HEAD: tAdr);
  var
    cur, tmp, max: tAdr;
  begin
    cur:=HEAD;
    if cur^.Next<>nil then
      if cur^.Next^.Next<>nil then
      while cur^.Next^.Next<>nil do
        begin

          tmp:=cur^.Next;
          max:=cur;
          while tmp^.Next<>nil do
            begin
              if tmp^.Next^.field.term<=max^.Next^.field.Term then
                  max:=tmp;
              tmp:=tmp^.Next;
            end;
          swap(cur^.Next, max^.Next);
          cur:=cur^.Next;

        end;
    cur:=HEAD;
    while cur^.Next<>nil do
      begin
        cur:=cur^.Next;
        sort(cur^.subTerms);
      end;
  end;

procedure uiSort;
  begin
    sort(Head);
    Done;
  end;


procedure showAnc(const ADR: tAdr);
  var
    cur: tAdr;
  begin
    if ADR<>HEAD then
      begin
        cur:=getParent(ADR);
        if cur<>nil then
            begin
              showAnc(cur);
              cur:=getHead(ADR);
            end
      end;
    if ADR<>HEAD then cur:=getHead(ADR);
    while cur<>ADR do
      begin
        cur:=cur^.Next;
        writeTerm(cur);
        writePages(cur^.Pages);
        writeln;
      end;
   
  end;


procedure uiFind;
  var
    str: tString;
    i: integer;
    adr: tAdr;
  begin
    writeln('   Enter term for searching:');
    str:=getStr;
    if isExist(str)<>-1 then
        begin
          for i:=1 to LEN do
            if Table[i]<>nil then
              if Table[i]^.field.Term=str then adr:=Table[i];
          showAnc(adr);
          if adr^.subTerms<>nil then writeIndex(adr^.subTerms);
          writeln('   Press Enter to continue..');
          readln;
          Done;
        end
      else
        begin
          writeln('   Incorrect input, there''s no such term!');
        end;

  end;

function findRightPos(const LVL: integer; const HEAD: tAdr): tAdr;
  begin
    RESULT:=lastEl(HEAD);
    if RESULT^.field.lvl<>LVL then RESULT:=findRightPos(LVL, RESULT^.subTerms);
  end;

procedure readList(const prevLvl: byte; const HEAD: tAdr; var f1: tFile; var f2: tPages);
  var
    cur, nxt, prev: tAdr;
    num: tNumAdr;
    tmp: integer;
    field: tField;
    f: boolean;
  begin

    cur:=HEAD;
    while not EoF(f1) do
      begin


        read(f1, field);
        new(nxt);

        nxt^.field:=field;
        hashAdd(nxt);
        newHead(nxt^.subTerms);
        nxt^.subTerms^.field.lvl:=field.lvl+1;
        newNumHead(nxt^.Pages);
        num:=nxt^.Pages;

        f:=true;
        while f do
          begin
            read(f2, tmp);
            if tmp=0 then f:=false
              else
                begin
                  num:=addNumEl(num);
                  num^.field:=tmp;
                end;
          end;
        nxt^.Next:=nil;

        prev:=findRightPos(field.lvl, HEAD);
        prev^.next:=nxt;


      end;
  end;

procedure uiRead;
  var
    f_f: tFile;
    f_p: tPages;
    El: tAdr;
    NumEL: tNumAdr;
  begin
    assignFile(f_f, PATH_F);
    reset(f_f);
    assignFile(f_p, PATH_P);
    reset(f_p);
    headDestroy(Head);
    dispose(Head);
    Initiate;
    readList(1, Head, f_f, f_p);

    closeFile(f_f);
    closeFile(f_p);
    writeln('Done!');
  end;

procedure writeList(const HEAD: tAdr; var f1: tFile; var f2: tPages);
  var
    cur: tAdr;
    num: tNumAdr;
    tmp: integer;
  begin

    cur:=HEAD;
    while cur^.Next<>nil do
      begin
        cur:=cur^.Next;
        write(f1, cur^.field);
        num:=cur^.Pages;
        while num^.Next<>nil do
          begin
            num:=num^.Next;
            write(f2, num^.field);
          end;
        tmp:=0;
        write(f2, tmp);
        writeList(cur^.subTerms, f1, f2);
      end;

  end;

procedure uiWrite;
  var
    f_f: tFile;
    f_p: tPages;
    El: tAdr;
    NumEL: tNumAdr;
  begin
    assignFile(f_f, PATH_F);
    rewrite(f_f);
    assignFile(f_p, PATH_P);
    rewrite(f_p);

    writeList(Head, f_f, f_p);

    closeFile(f_f);
    closeFile(f_p);
    writeln('Done!');
  end;

procedure writeTable;
  var
    i: integer;
  begin
    for i:=1 to LEN do
      if Table[i]<>nil then
        begin
          writeln(i,' ',Table[i]^.field.Term,' ',Table[i]^.field.lvl);
        end;
      writeln;
  end;

function compByPage(const adr1, adr2: tAdr): boolean;    //true, adr1<=adr2
  begin
    if adr1^.Pages^.Next=nil then RESULT:=true
      else if adr2^.Pages^.Next = nil then RESULT:=false
        else if (adr1^.Pages^.Next^.field<=adr2^.Pages^.Next^.field) then RESULT:=true
          else RESULT:=false;
  end;

procedure sortPages(const HEAD: tAdr);
  var
    cur, tmp, max: tAdr;
  begin
    cur:=HEAD;
    if cur^.Next<>nil then
      if cur^.Next^.Next<>nil then
      while cur^.Next^.Next<>nil do
        begin

          tmp:=cur^.Next;
          max:=cur;
          while tmp^.Next<>nil do
            begin
              //if tmp^.Next^.field.term<=max^.Next^.field.Term then
              //    max:=tmp;
              if compByPage(tmp^.Next, max^.Next) then
                max:=tmp;
              tmp:=tmp^.Next;
            end;
          swap(cur^.Next, max^.Next);
          cur:=cur^.Next;

        end;
    cur:=HEAD;
    while cur^.Next<>nil do
      begin
        cur:=cur^.Next;
        sortPages(cur^.subTerms);
      end;
  end;

procedure uiSortPages;
  begin
    sortPages(Head);
    Done;
  end;

procedure UI;
  var
    isCont: boolean;
    code, num: integer;
    str: String;
  begin
    isCont:=true;
    while isCont do
      begin

        writeTable;

        writeln('Enter: ');
        writeln('   1 to view index');
        writeln('   2 to add new term');
        writeln('   3 to select item and delete it or change (and adding subterms)');
        writeln('   4 to sort index by terms');
        writeln('   5 to find elements');
        writeln('   6 to read index from file');
        writeln('   7 to write index to file');
        writeln('   8 to exit');
        writeln('   9 to sort index by first pages');
        write('> ');
        str:='';
        readln(str);
        code:=0;
        num:=0;
        val(str, num, code);
        if code<>0 then
            writeln('Incorrect input!')
          else
            begin
              case num of
                1: uiView;
                2: setLvl(uiAdd(Head), 1);
                3: uiSelect;
                4: uiSort;
                5: uiFind;
                6: uiRead;
                7: uiWrite;
                8:
                  begin
                    isCOnt:=false;
                    writeln('Press any key..');
                    readln;
                  end;
                9: uiSortPages;
                else writeln('Incorrect input!');
              end;
            end;
        writeln;
        writeln('////////////////////////////////////////////////');
        writeln;
      end;
  end;

begin
  Initiate;
  UI;
end.
