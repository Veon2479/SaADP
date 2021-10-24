program l1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils, Windows;

type
  tString = String[40];
  tInt = 0..9999999;
  tField =
    record
      fName, sName, pName: tSTring;
      num: tInt;
    end;


  tAdr = ^tElement;
  tElement =
    record
      adrNext:  tAdr;
      field: tField;
    end;

  tEq   = function(t1, t2: tAdr): boolean;    //true, если t1 и t2 - равны по какому-то полю
var
  HEAD, lASTEL: tAdr;
  CURNUM: integer;

 { procedure create(var lastEl, newElement: tAdr);
    begin
      new(newElement);
      lastEl^.adrNext:=newElement;
      newElement^.adrNext:=nil;
      newElement^.field.num:=CURNUM;        //for unique numbers
      inc(CURNUM);
    end;       }

  procedure Initiate;
    begin
      new(HEAD);
      HEAD^.adrNext:=nil;
      LASTEL:=HEAD;
      CURNUM:=1000000;
    end;


  procedure showEl(adr: tAdr);
    begin
      with adr^.field do
        writeln('(',num:7,' - ',fName,', ',sName,', ',pName,')');
    end;

  procedure gShow;
    var
      adr: tAdr;
    begin
      adr:=HEAD;
      if adr^.adrNext=nil then writeln('There''s no items!');
      while adr^.adrNext<>nil do
        begin
          adr:=adr^.adrNext;
          showEl(adr);
        end;
    end;


  function surEq(t1, t2: tAdr): boolean;
    begin
      if t1^.field.sName=t2^.field.sName then RESULT:=true
        else RESULT:=false;
    end;

  function phEq(t1, t2: tAdr): boolean;
    begin
      if t1^.field.num=t2^.field.num then RESULT:=true
        else RESULT:=false;
    end;

  function createEl(fN, sN, pN: tSTring): tAdr;
    begin
      RESULT:=nil;
      new(RESULT);
      with RESULT^, RESULT^.field do
        begin
          adrNext:=nil;
          fName:=fn;
          sName:=sN;
          pName:=pN;
          num:=CURNUM;
          inc(CURNUM);
        end;
    end;
              //true, t1>t2
  function comp(t1, t2: tAdr): boolean;    //surname-f.name-p.name-number
    begin
      RESULT:=true;
      if t1^.field.sName<t2^.field.sName then RESULT:=false
        else if t1^.field.sName=t2^.field.sName then
                 if t1^.field.fName<t2^.field.fName then RESULT:=false
                    else if t1^.field.fName=t2^.field.fName then
                            if t1^.field.pName<t2^.field.pName then RESULT:=false
                              else if t1^.field.pName=t2^.field.pName then
                                    if t1^.field.num<t2^.field.num then RESULT:=false;
    end;

  procedure put(t: tAdr);
    var
      adr: tAdr;
      f: boolean;
    begin
      adr:=HEAD;
      f:=false;
      while not f do
        begin
          if adr^.adrNext=nil then
              begin
                adr^.adrNext:=t;
                f:=true;
              end
            else
              begin
                if comp(adr^.adrNext, t) then     //  adr^.adrNext>t
                    begin
                      t^.adrNext:=adr^.adrNext;
                      adr^.adrNext:=t;
                      f:=true;
                    end
                  else adr:=adr^.adrNext;
              end;
        end;

    end;

  procedure gAdd;
    var
      adr: tAdr;
      s1, s2, s3: tString;
    begin
      writeln('Adding new record with number ',adr^.field.num,'.. ');
      writeln('Enter first name (up to 40 symbols):');
      readln(s1);
      writeln('Enter  surname (up to 40 symbols):');
      readln(s2);
      writeln('Enter  patronymic (up to 40 symbols):');
      readln(s3);
      adr:=createEl(s1, s2, s3);
      put(adr);
      writeln('OK!');
    end;

  procedure search(t: tAdr; f: tEq);
    var
      adr: tAdr;
      fl: boolean;
    begin
      fl:=false;
      adr:=HEAD;
      while adr^.adrNext<>nil do
        begin
          adr:=adr^.adrNext;
          if f(t, adr) then
            begin
              fl:=true;
              showEl(adr);
            end;
        end;
      if not fl then writeln('There''s no such records!');
    end;

  procedure gSearch(f: tEq);
    var
      adr: tAdr;
      str: tString;
      num, code: tInt;
    begin
      new(adr);

      with adr^, adr^.field do
        begin
          adrNext:=nil;
          if (@f=@surEq) then
              begin
                writeln('Enter searching term:');
                readln(str);
                sName:=str;
                search(adr, surEq);
              end
            else
              begin
                code:=1;
                while code<>0 do
                  begin
                    writeln('Enter searching term:');
                    readln(str);
                    val(str, num, code);
                    if code<>0 then writeln('Incorrect input, try again..')
                      else
                        begin
                          search(adr, phEq);
                        end;
                  end;
              end;
        end;

    end;


var
  f: boolean;
  str: tString;
  i: integer;

begin
  Initiate;
  f:=true;
  while f do
    begin
   
      writeln('Press:');
      writeln('   1 for adding new record');
      writeln('   2 for searching by the number');
      writeln('   3 for searching by the surname');
      writeln('   4 for showing list');
      writeln('   5 for quit..');

      writeln;
      writeln('//////////////////////////////////////////////');
      writeln;

      readln(str);
      if str='1' then gAdd
        else if str='2' then gSearch(phEq)
              else if str='3' then gSearch(surEq)
                    else if str='4' then gShow
                        else if str='5' then f:=false
                        else writeln('  Incorrect Input!');

      writeln;
      writeln('//////////////////////////////////////////////');
      writeln;

    end;
end.
