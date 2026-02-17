freeze;

intrinsic MultiFork(n::RngIntElt) -> SeqEnum[RngIntElt], RngIntElt
  { Fork n copies of self and return the enumerator of self, and pids of the children }
  res := [];
  for i in [1..n] do
    if #res eq i - 1 then // only the parent gets inside of this loop
      f := _Fork(:CloseStdin:=true);
      if f ne 0 then // parent branch
        Append(~res, f);
      else
        return [], i; // child branch
      end if;
    end if;
  end for;
  return res, 0;
end intrinsic;
