program l1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type
  tAdr = ^tElement;
  tElement = record
      adrNext:  tAdr;
      degree, factor: integer;
  end;

  Function Equality(const HEAD1, HEAD2: tAdr): boolean;
    var
      adr1, adr2: tAdr;
    begin
      adr1:=HEAD1;
      adr2:=HEAD2;
      RESULT:=true;



      while RESULT do
        begin
          if (adr1^.adrNext=nil)xor(adr2^.adrNext=nil) then
              begin
                Result:=false;
              end
            else

              begin

                if adr1^.degree<>adr2^.degree then RESULT:=false;
                if adr1^.factor<>adr2^.factor then Result:=false;
                if adr1^.adrNext<>nil then
                  begin
                    adr1:=adr1^.adrNext;
                    adr2:=adr2^.adrNext;
                  end
                else break;
              end;
        end;

    end;

  function Meaning(const HEAD: tAdr; const x: integer): integer;
    var
      adr: tAdr;
      i: integer;
    begin
      RESULT:=0;
      adr:=HEAD;



          while adr^.adrNext<>nil do
            begin
              adr:=adr^.adrNext;
              if(adr^.degree <> 0) then
                inc(RESULT, round(exp(x * ln(adr^.degree)))*adr^.factor)
              else
                inc(RESULT, adr^.factor);
            end;



    end;

  procedure create(var LASTEL: tAdr; const A, B: integer);
    var
      newEl: tADr;
    begin
      new(newEl);
      LASTEL^.adrNext:=newEl;
      LASTEL:=newEl;
      newEl^.adrNExt:=nil;
      newEl^.degree:=A;
      newEl^.factor:=B;
    end;

  function addEl(const HEAD, EL: tAdr): tAdr;     //add El to HEAD-list and returns it's adress - maby the same..
    var
      adr: tAdr;
    begin
      adr:=HEAD;
      RESULT:=nil;
      if (EL^.degree=0) and (EL^.factor=0) then RESULT:=HEAD;
      if HEAD^.adrNext=nil then
        begin
          HEAD^.adrNext:=EL;
          EL^.adrNext:=nil;
          RESULT:=EL;
        end;

      while RESULT=nil do
        begin
          if adr^.adrNext=nil then
              begin
                adr^.adrNext:=EL;
                EL^.adrNext:=nil;
                RESULT:=EL;
              end                                                           //   EL
            else                                                         //    []/adrN  -
              begin                                                      //       ^        \
                                                                          //     /          \
                if (EL^.degree>adr^.adrNext^.degree) then               // []/adrNext  ->  []/adr2
                    begin                                               //    adr             adr^.adrNext
                      EL^.adrNext:=adr^.adrNext;
                      adr^.adrNext:=EL;
                      RESULT:=EL;
                    end
                  else if (EL^.degree=adr^.adrNext^.degree) then
                      begin
                        inc(adr^.adrNext^.factor, EL^.factor);
                        RESULT:=adr^.adrNext;
                      end
                    else adr:=adr^.adrNext;
              end;
        end;

    end;

   procedure Add(const HEAD, HEAD1, HEAD2: tAdr);
    var
      adr, adr1, adr2, adrp: tAdr;
      f: boolean;
      tDeg, tFac, lastDeg: integer;
    begin
      adr:=HEAD;
      adr1:=HEAD1;
      adr2:=HEAD2;

      while adr2^.adrNext<>nil do
        begin
          adr2:=adr2^.adrNext;
          create(adr, adr2^.degree, adr2^.factor);
        end;

      adr2:=HEAD;

      new(adr);
      adr^.adrNext:=nil;
      adr^.degree:=0;
      adr^.factor:=0;
      adrp:=adr;

      while adr1^.adrNext<>nil do
        begin
          adr1:=adr1^.adrNext;

          adr:=adrp;
          create(adr, adr1^.degree, adr1^.factor);

          adr2:=addEl(adr2, adr);


          adr:=nil;
        end;


    end;

  {procedure Add(const HEAD, HEAD1, HEAD2: tAdr);
    var
      adr, adr1, adr2: tAdr;
      f: boolean;
      tDeg, tFac, curD: integer;
    begin
      adr:=HEAD;
      adr1:=HEAD1;
      adr2:=HEAD2;
      curD:=100000;
      if (adr1^.adrNext<>nil) or (adr2^.adrNext<>nil) then f:=true;
      while f do
        begin
           if (adr1^.adrNext=nil) and (adr2^.adrNext=nil) then f:=false;
          tDeg:=0;
          tFac:=0;
          if (adr1^.adrNext<>nil) then adr1:=adr1^.adrNext;

          if (adr2^.adrNext<>nil) then adr2:=adr2^.adrNext;


          if (adr1^.degree>adr2^.degree) then
              begin
                if adr1^.degree<curD then
                begin
                  tDeg:=adr1^.degree;
                  tFac:=adr1^.factor;
                  if (adr1^.adrNext<>nil) then adr1:=adr1^.adrNext;
                end
                else
                  begin
                    tDeg:=adr2^.degree;
                  tFac:=adr2^.factor;
                  if (adr2^.adrNext<>nil) then adr2:=adr2^.adrNext;
                  end;

              end
            else if (adr1^.degree<adr2^.degree) then
                begin
                  if adr1^.degree<curD then
                    begin
                      tDeg:=adr2^.degree;
                      tFac:=adr2^.factor;
                      if (adr2^.adrNext<>nil) then adr2:=adr2^.adrNext;
                    end
                  else
                    begin
                            tDeg:=adr1^.degree;
                            tFac:=adr1^.factor;
                            if (adr1^.adrNext<>nil) then adr1:=adr1^.adrNext;
                    end
                end
              else
                begin
                  tDeg:=adr1^.degree;
                  tFac:=adr1^.factor+adr2^.factor;
                  if (adr1^.adrNext<>nil) then adr1:=adr1^.adrNext;
                  if (adr2^.adrNext<>nil) then adr2:=adr2^.adrNext;
                end;

          Create(adr, tDeg, tFac);
          curD:=tDeg;


        end;
    end;   }


  procedure readPol(const HEAD: tADr);
    var
      str: String;
      a, b: integer;
      f: boolean;
      adr: tAdr;
    begin
      adr:=HEAD;
      writeln('Enter polynom as pairs of numbers (each one is on the another line),');
      writeln('Where first number - degree, another one - factor');
      writeln('And degree of elements are in descending order');
      writeln('if you finished, enter "-1 -1"');
      f:=true;
      while f do
        begin
          readln(a, b);
          if (a=-1)and(b=-1) then f:=false
            else
              create(adr, a, b);
        end;
    end;


  procedure writeP(const HEAD: tAdr);
    var
      adr: tAdr;
    begin
      adr:=HEAD;
      if adr^.adrNext=nil then writeln(0);

      while adr^.adrNext<>nil do
        begin
          adr:=adr^.adrNext;
          write(adr^.factor,'*x^',adr^.degree);
          if adr^.adrNext<>nil then write(' + ');
        end;
      writeln;
    end;

var
  headP, headQ, headR: tAdr;
  str: String;
  x, i: integer;

begin
  new(headP);
  headP^.adrNext:=nil;
  headP^.degree:=0;
  headP^.factor:=0;
  new(headQ);
  headQ^.adrNext:=nil;
  headQ^.degree:=0;
  headQ^.factor:=0;
  new(headR);
  headR^.adrNext:=nil;
   headR^.degree:=0;
  headR^.factor:=0;
  writeln('Enter first polynom:');
  readPol(headP);
  writeP(headP);
  writeln('Enter second polynom:');
  readPol(headQ);
  writeP(headQ);
  i:=1;
  while i<>0 do
    begin
      writeln('Enter number x:');
      readln(str);
      val(str, x, i);
      if i<>0 then writeln('Incorrect input, try again');
    end;
  if Equality(headP, headQ) then writeln('Polynoms are equal')
    else writeln('Polynoms aren''t equal');
  writeln('Meaning of first polynom in x - ',Meaning(headP, x),', of second - ', Meaning(headQ, x));
  add(headR, headP, headQ);
  writeln('first polynom plus second one:');
  writeP(headR);
  writeln('press Enter to exit..');
  readln;
end.
