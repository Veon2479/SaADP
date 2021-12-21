program l5;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  binTree in 'binTree.pas';

var
  root: tAdr;
  randomTable: array[0..99] of boolean;
  i, k, d: integer;
  f: boolean;

begin

  root:=init;
  for i:=0 to 99 do
    randomTable[i]:=true;
  for i:=1 to 20 do
    begin
      f:=true;
      k:=(random(100)+random(100)) mod 100;
      while f do
        begin
          if randomTable[k]=true then
              begin
                randomTable[k]:=false;
                insert(root, k);
                f:=false;
              end
            else
              begin
                k:=(k+1) mod 100;
              end;
        end;
    end;
  ANY_showTree(root);
  writeln;

  writeln('ARB bypass:');
  bypassARB(root);
  writeln;

  writeln('ABR bypass:');
  bypassABR(root);
  writeln;

  writeln('RAB bypass:');
  bypassRAB(root);
  writeln;

  writeln('Sewed tree:');
  ARB_stretch(root);
  ANY_showTree(root);

  f:=true;
  while f do
    begin
      writeln('Enter node to delete or (-1) to exit:');
      readln(d);
      if (d<>-1) then
          begin
            ARB_delete(root, d);
            ANY_showTree(root);
          end
        else
          f:=false;

    end;


  readln;
end.
