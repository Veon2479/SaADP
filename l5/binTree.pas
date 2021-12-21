unit binTree;

interface

type

  tAdr = ^node;
  node = record
    data: integer;
    isStRight, isStLeft: boolean;
    left, right: tAdr;
  end;


  function  init: tAdr;
  procedure insert(var ROOT: tAdr; const DATA: integer);

  procedure bypassARB(var ROOT: tAdr);
  procedure bypassRAB(var ROOT: tAdr);
  procedure bypassABR(var ROOT: tAdr);


  procedure ARB_Stretch(var ROOT: tAdr);
  procedure ARB_delete(var ROOT: tAdr; const DATA: integer);


  procedure Any_ShowTree(const ROOT: tAdr);

implementation

  function init: tAdr;
    begin
      new(RESULT);
      with RESULT^ do
        begin
          data:=high(integer);
          isStRight:=false;
          isStLeft:=false;
          left:=nil;
          right:=nil;
        end;
    end;

///////////////////////////////////////////////////

  procedure setData(var NODE: tAdr; const DATA: integer);
    begin
      NODE^.data:=DATA;
    end;

  function getData(const NODE: tAdr): integer;
    begin
      RESULT:=NODE^.data;
    end;

///////////////////////////////////////////////////

  procedure add(var ROOT: tAdr; const DATA: integer);
    var
      newNode: tAdr;
    begin
      if (ROOT = nil) then
          begin
            newNode:=init;
            ROOT:=newNode;
            setData(newNode, DATA);
          end
        else
          begin
            if (DATA <= getData(ROOT)) then
                add(ROOT^.left, DATA)
              else
                add(ROOT^.right, DATA);
          end;


    end;

  procedure insert(var ROOT: tAdr; const DATA: integer);
    var
      newNode: tAdr;
    begin
      if (ROOT^.data = high(integer)) then
          add(ROOT^.right, DATA)
        else
          add(ROOT, DATA);
    end;

////////////////////////////////////////////////////

  procedure bypassARB(var ROOT: tAdr);
    begin
      if (ROOT <> nil) then
        begin
          if ROOT^.data = high(integer) then bypassARB(ROOT^.right)
            else
              begin
                bypassARB(ROOT^.left);
                write(ROOT^.data,' ');
                bypassARB(ROOT^.right);
              end;
        end;
    end;

  procedure bypassRAB(var ROOT: tAdr);
    begin

      if (ROOT <> nil) then
        begin
          if ROOT^.data = high(integer) then bypassRAB(ROOT^.right)
            else
              begin
                write(ROOT^.data,' ');
                bypassRAB(ROOT^.left);
                bypassRAB(ROOT^.right);
              end;
        end;
    end;

  procedure bypassABR(var ROOT: tAdr);
    begin

      if (ROOT <> nil) then
        begin
          if ROOT^.data = high(integer) then bypassABR(ROOT^.right)
            else
              begin
                bypassABR(ROOT^.left);
                bypassABR(ROOT^.right);
                write(ROOT^.data,' ');
              end;

        end;
    end;

///////////////////////////////////////////////////

  function findMaxLeftNode_ANY(const ROOT: tAdr): tAdr;
    begin
      if (ROOT^.isStLeft) then
          RESULT:=nil
        else
          RESULT:=ROOT^.left;
      if RESULT<>nil then
        while ((RESULT^.right<>nil) and (not RESULT^.isStRight)) do
            begin
              RESULT:=RESULT^.right;
            end;

    end;

  procedure ARB_right_sewing(var ROOT: tAdr);
    var
      res: tAdr;
    begin
      if (not ROOT^.isStLeft) and (ROOT^.left<>nil) then
          begin
            ARB_right_sewing(ROOT^.left);
          end;
      res:=findMaxLeftNode_ANY(ROOT);
      if (res<>nil) then
          begin
            res^.isStRight:=true;
            res^.right:=ROOT;
          end;
      if (not ROOT^.isStRight) and (ROOT^.right<>nil) then
          begin
            ARB_right_sewing(ROOT^.right);
          end;

    end;

  procedure ARB_Stretch(var ROOT: tAdr);
    begin
      ARB_right_sewing(ROOT^.right);
    end;

  function isExist_ANY(ROOT: tAdr; const DATA: integer): tAdr;
    var
      f: boolean;
    begin
      f:=true;
      RESULT:=nil;
      ROOT:=ROOT^.right;
      while (f) do
        begin
          if (ROOT^.data = DATA) then
              begin
                RESULT:=ROOT;
                f:=false;
              end
            else
              if (ROOT^.data > DATA) then
                  begin

                    if (ROOT^.isStLeft) then
                        begin
                          f:=false;
                        end
                      else
                        ROOT:=ROOT^.left;

                  end
                else
                  begin
                    if (ROOT^.isStRight) then
                        begin
                          f:=false;
                        end
                      else
                        ROOT:=ROOT^.right;
                  end;
          if (ROOT=nil) then
              f:=false;
        end;

    end;



  {procedure del_tree(var ROOT: tAdr; const DATA: integer);
    var
      q: tAdr;

    procedure del(w: tAdr);
      begin
        if (w^.right<>nil)and(not w^.isStRight) then
            del(w^.right)
          else
            begin
              q:=w;
              ROOT^.data:=w^.data;
              w:=w^.left;
            end;
      end;
    begin
      if (ROOT<>nil) then
          if (DATA<ROOT^.data) then
              del_tree(ROOT^.left, DATA)
            else
              if (DATA>ROOT^.data) then
                  del_tree(ROOT^.right, DATA)
                else
                  begin
                    q:=ROOT;
                    if (ROOT^.right = nil) or (ROOT^.isStRight) then
                        ROOT:=ROOT^.left
                      else
                        if (ROOT^.left = nil)and(not ROOT^.isStRight) then
                            ROOT:=ROOT^.Right
                          else
                            del(ROOT^.left);
                    dispose(q);

                  end;
    end;   }


  {function deleteElement(var head: PNode; value: integer): Boolean;
    var
      tnode, leftmnode, leftmnodepar, parent: PNode; tmp: integer;
    begin
      result:= false;
      tnode:= search(head, value, parent);
      if tnode <> nil then
          begin
            if (tnode.left = nil) and (tnode.right = nil) then
                begin // no childs
                  dispose(tnode);
                  if value > parent.val then
                      parent.right:= nil
                    else
                      parent.left:= nil
                end
              else if (tnode.left <> nil) and (tnode.right <> nil) and not (tnode.is_threaded) then
                  begin // 2 childs
                    leftmnodepar := tnode;
                    leftmnode:= leftMost(tnode.right, leftmnodepar);
                    tmp := leftmnode.val;
                    // delete founded
                    deleteElement(tnode, leftmnode.val);
                    // assign value
                    tnode.val := tmp;
                  end
                else // 1 child
                  begin
                  // get what node is not nill
                  leftmnode:= nil;
                  if tnode.left <> nil then
                  leftmnode := tnode.left
                  else if not (tnode.is_threaded) then
                      leftmnode := tnode.right;

                  if value > parent.val then
                      parent.right := leftmnode
                    else
                      parent.left := leftmnode;

                  dispose(tnode);
                  end;



            result:= true;
          end;
    end;         }

  function findSewingNode_ARB(var ROOT, AIM, RES: tAdr): tAdr;
    begin
      if (ROOT<>nil) then
          begin
            if (not ROOT^.isStLeft) then
                findSewingNode_ARB(ROOT^.left, AIM, RES);
            if  (ROOT^.right = AIM)and(ROOT^.isStRight) then
                RES:=ROOT;
            if (not ROOT^.isStRight) then
                findSewingNode_ARB(ROOT^.right, AIM, RES);

          end;
    end;

  procedure del_tree(var ROOT: tAdr; var PARENT: tAdr; const DATA: integer);
    var
      res: tAdr;
    begin
      if (ROOT<>nil) then
          begin
            res:=nil;
//            findSewingNode_ARB(ROOT, ROOT, res);
//            if res<>nil then
//                begin
//                  res^.right:=nil;
//                  res^.isStRight:=false;
//                end;
            if (DATA<ROOT^.data) then
                begin
                  del_tree(ROOT^.left, ROOT, DATA);
                end
              else
                if (DATA>ROOT^.data) then
                    begin
                      if (not ROOT^.isStRight) then
                          del_tree(ROOT^.right, ROOT, DATA);
                    end
                  else
                    begin
                      if ( ((ROOT^.left = nil) or (ROOT^.isStLeft)) and ((ROOT^.right = nil) or (ROOT^.isStRight)) ) then
                          begin   //0 children
                            if (PARENT^.left= ROOT) then
                                PARENT^.left:=nil
                              else PARENT^.right:=nil;
                              dispose(ROOT);
                              ROOT:=nil;
                          end
                        else if ((ROOT^.left<>nil) and (not ROOT^.isStLeft))and((ROOT^.left<>nil) and (not ROOT^.isStLeft)) then
                            begin     //2 children
                              res:=findMaxLeftNode_ANY(ROOT);
                              ROOT^.data:=res^.data;
                              del_tree(ROOT^.left, ROOT, ROOT^.data);
                            end
                          else
                            begin    //1 children
                              if (ROOT^.left<>nil) then
                                  res:=ROOT^.left
                                else
                                  res:=ROOT^.right;
                              if (PARENT^.left= ROOT) then
                                  PARENT^.left:=res
                                else
                                  PARENT^.right:=res;
                            //  dispose(ROOT);
                            //  ROOT:=nil;
                            end;
                    end;

          end;
    end;

  procedure ARB_delete(var ROOT: tAdr; const DATA: integer);
    begin
      del_tree(ROOT^.right, ROOT, DATA);
      ARB_right_sewing(ROOT^.right);
    end;


////////////////////////////////////////////////////

  procedure showLine(const c: String; p, s: integer);
    var
      t, i: integer;
    begin
      t:=s;
      for i:=0 to p-1 do
        begin
          if (t and 1 = 1) then
              begin
                write('|  ');
              end
            else
              begin
                write('   ');
              end;
          t:=t div 2;
        end;
      write(c);
    end;

  procedure showTree(const ROOT: tAdr; p, s: integer);
    begin
      if (ROOT <> nil) then
        begin
          write(ROOT^.data);
          if ((ROOT^.isStLeft) and (ROOT^.left<>nil)) then
              begin
                write(', L-',ROOT^.left^.data);
              end;
          if (ROOT^.isStRight)and(ROOT^.right<>nil) then
              begin
                write(', R-',ROOT^.right^.data);
              end;
          writeln;
          if ((ROOT^.left <> nil) and (not ROOT^.isStLeft)) then
              begin
                showLine('|'+#13+#10, p, s);
                showLine('L: ', p, s);
                if ((ROOT^.right = nil) or (ROOT^.isStRight)) then
                    showTree(ROOT^.left, p+1, s)
                  else
                    showTree(ROOT^.left, p+1, s+ (1 shl p));
              end;
          if ((ROOT^.right <> nil) and (not ROOT^.isStRight)) then
              begin
                showLine('|'+#13+#10, p, s);
                showLine('R: ', p, s);
                showTree(ROOT^.right, p+1, s);
              end;

        end;
    end;

  procedure Any_ShowTree(const ROOT: tAdr);
    begin
      writeln('Tree:');
      writeln;
      showTree(ROOT^.right, 0, 0);
    end;

end.
