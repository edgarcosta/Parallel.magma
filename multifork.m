freeze;

intrinsic MultiFork(n::RngIntElt) -> SeqEnum[RngIntElt], RngIntElt
  { Fork n copies of self and return the enumerator of self, and pids of the children }
  parentpid := Getpid();
  IsParent := func<|parentpid eq Getpid()>;
  res := [];
  for i in [1..n] do
    if IsParent() then
      Append(~res, Fork());
      if not IsParent() then
        return [], i;
      end if;
    end if;
  end for;
  return res, 0;
end intrinsic;
