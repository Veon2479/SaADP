program Graphs;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

const
  LENGTH = 6;

type
  tArray = array[1..LENGTH, 1..LENGTH] of integer;
  way = record
    length: integer;
    path: string;
  end;

var
  graph: tArray = ( (00, 00, 00, 00, 00, 00),
                    (08, 00, 20, 00, 00, 00),
                    (00, 10, 00, 00, 70, 20),
                    (01, 05, 00, 00, 00, 00),
                    (99, 00, 00, 00, 00, 00),
                    (00, 00, 00, 03, 00, 00) );
  minways: tArray;
  ways: array[1..1000] of way;


function getNum: integer;
  begin
    RESULT:=0;
    write('> ');
    readln(RESULT);
  end;

procedure writeGraph;
  var
    i, j: integer;
  begin
    for i := 0 to LENGTH do
      write(i:4);
    writeln;
    for j:=1 to LENGTH do
      begin
        write(j:4);
        for i:=1 to LENGTH do
          write(graph[j, i]:4);
        writeln;
      end;
  end;

function getPrice(const v1, v2: integer): integer;
  begin
    RESULT:=graph[v1, v2];
  end;

function getMinWay(const v1, v2: integer): integer;
  var
    mask: array[1..LENGTH] of boolean;
    price: array[1..LENGTH] of integer;
    i, j: integer;
    f: boolean;
    errCnt: integer;
    minVert, minPrice, oldVert: integer;
  begin
    for i := 1 to LENGTH do
      begin
        mask[i]:=false;
        price[i]:=getPrice(v1, i);
        if price[i]=0 then
            price[i]:=666666;
      end;
    price[v1]:=0;
    mask[v1]:=true;
    RESULT:=0;
    writeln('LOG: finding minimal way between vertices: ',v1,', ',v2);
    if LENGTH=1 then
        begin
          f:=false;
        end
      else
        f:=true;
    errCnt:=0;

    while f do
      begin
        minPrice := 666666;
        minVert:=0;
        for j:=1 to LENGTH do  //searching for minimal price
          begin
            if (mask[j]=false) and (price[j]<=minPrice) then
                begin
                  //if (errCnt=0)or(getPrice(oldVert, j)<>0) then
                      begin
                        minPrice:=price[j];
                        minVert:=j;
                      end;
                end;
          end;

        mask[minVert]:=true;
        for j:=1 to LENGTH do
          if (mask[j]=False)and(getPrice(minVert, j)<>0) then
              if ( price[j] > price[minVert] + getPrice(minVert, j) ) then
                  begin
                    price[j] := price[minVert]+getPrice(minVert, j);
                  //  mask[j]:=true;
                  end;



        for i := 1 to LENGTH do
          f:=f and mask[i];
        f:=not f;
        inc(errCnt);
        if errCnt=666666 then f:=false;
        oldVErt:=minVert;
      end;
  //  if price[v2]<>666666 then
        RESULT:=price[v2];
    writeln('LOG: searching done..');
  end;

function getMaxWay(const v1, v2: integer): integer;
  var
    mask: array[1..LENGTH] of boolean;

  function crawl(const v1, v2: integer): integer;
    var
      i, tmp: integer;
      f: boolean;
      maxLen, maxVert: integer;
    begin

      if (v1=v2) then
          begin
            RESULT:=0;
          end
        else
          begin
            maxLen:=-1;
            maxVert:=-1;
            for i := 1 to LENGTH do
              begin
                tmp:=getPrice(v1, i);
                if ((tmp<>0)and(not mask[i]))or((tmp<>0)and(i=v2)) then
                    begin
                      mask[i]:=true;
                      tmp:=crawl(i, v2);
                      mask[i]:=false;
                      if tmp>maxLen then
                          begin
                            maxLen:=tmp;
                            maxVert:=i;
                          end;
                    end;
              end;
            if (maxVert<>-1) then
                begin
                  mask[maxVert]:=true;
                  write(maxVert,' ');
                  RESULT := getPrice(v1, maxVert) + crawl(maxVert, v2);
                end
              else
                RESULT:=0;
          end;
    end;

  var
    i: integer;
  begin
    for i:=1 to LENGTH do
      mask[i]:=false;
    mask[v1]:=true;
    RESULT := crawl(v1, v2);
  end;

procedure floid;
  var
    i: Integer;
    j: Integer;
    k: Integer;
  begin
    for i := 1 to LENGTH do
      for j := 1 to LENGTH do
        begin
          minways[i,j] := graph[i,j];
          if (i<>j)and(graph[i, j] = 0) then
              minways[i,j] := 666666;
        end;
    for k := 1 to LENGTH do
      for i := 1 to LENGTH do
        for j:=1 to LENGTH do
          if minways[i, k]+minways[k, j]<minways[i,j] then
              minways[i,j]:=minways[i, k]+minways[k, j];

  end;

function getCenter: integer;
  var
    i, j, max, exc: integer;
  begin
    exc:=666666;
    RESULT:=1;
    for j := 1 to LENGTH do
      begin
        max:=minways[1, j];
        for i := 1 to LENGTH do
          if minways[i,j]>max then
              max:=minways[i,j];
        if exc>max then
            begin
              exc:=max;
              RESULT:=j;
            end;
      end;

  end;

function getEmpty: integer;
  var
    i: integer;
  begin
    i:=1;
    while ways[i].length<>0 do
      inc(i);
    RESULT:=i;    
  end;
  
procedure getWays(const v1, v2: integer);
  var
    mask: array[1..LENGTH] of boolean;
    
  procedure crawl(const v1, v2, len: integer; path: string);
    var
      i, tmp, newLen: integer;
      f, fl: boolean;
      str: String;
    begin
      f:=true;
      for i := 1 to LENGTH do
        f:=f and mask[i];
      if f and (v1=v2) then
          begin
            if v1=v2 then
                begin
                  tmp:=getEmpty;
                  ways[tmp].length := len;
                  ways[tmp].path := ''+path;
                end;
          end
        else
          begin
            fl:=false;
            for i := 1 to LENGTH do
              if (not mask[i])and(getPrice(v1, i)<>0) then
                 begin
                   fl:=true;
                   mask[i]:=true;
                   str:=path+intToSTr(i)+' ';
                   newLen:=getPrice(v1, i);
                   crawl(i, v2, len+newLen, str);
                   mask[i]:=false;
                 end;
            if ((not fl) and (v1=v2))or(v1=v2) then
              begin
                tmp:=getEmpty;
                ways[tmp].length := len;
                ways[tmp].path := ''+path;
              end
          end;
    
    end;
    
  var
    i, j, border: integer;
    minI, minL: integer;
    field: way;
    str: String;
  begin
    for i:=1 to LENGTH do
      mask[i]:=false;
    mask[v1]:=true;
    str:=intToStr(v1)+' ';
    crawl(v1, v2, 0, str);
    border:=getEmpty-1;

    for i:=1 to border do
      begin
        minI:=i;
        minL:=ways[i].length;
        for j := i+1 to border do
          if ways[j].length<minL then
              begin
                minL:=ways[j].length;
                minI:=j;
              end;
        field:=ways[i];
        ways[i]:=ways[minI];
        ways[minI]:=field;
      end;

  end;

var
  i,  v1, v2, center: integer;
  f: boolean;
  minWay, maxWay: integer;
begin
  f:=true;
  writeln;
  floid;
  center := getCenter;
  writeln('Graph''s center is: ', center);
  writeln;
  while (f) do
    begin
      writeln('Graph:');
      writeGraph;
      writeln('Enter two vertices or -1 to exit..');
      v1 := getNum;
      if (v1 <> -1) then
          begin
            v2:=getNum;
            //writeln(getPrice(v1, v2));

            minWay:=getMinWay(v1, v2);
            if (minWay<>666666) then
                begin
                  writeln('Minimal way is: ',minWay);
                  if (minWay<>0) or ((minWay=0) and (v1<>v2)) then
                    begin
                     getWays(v1, v2);
                      writeln('Maximal way is: ',ways[getEmpty-1].length);
                      writeln;
                      writeln('All ways are:');
                      for i := 1 to getEmpty-1 do
                        begin
                          writeln(ways[i].length,' - ',ways[i].path);
                          ways[i].length:=0;
                          ways[i].path:='';
                        end;
                    end;
                end
              else
                writeln('There''s no ways between them!');

          end
        else
          begin
            f:=false;
          end;
    end;

  readln;
end.
