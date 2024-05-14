function MultiFork(n)
  res := [];
  for i in [1..n] do
    if #res eq i - 1 then // only the parent gets inside of this loop
      f := Fork();
      if f ne 0 then // parent branch
        Append(~res, f);
      else
        return [], i; // child branch
      end if;
    end if;
  end for;
  return res, 0;
end function;

b, r := MultiFork(10);
print b, r;
if r ne 0 then
  exit 0;
end if;
// If you copy the text above to the interpreter, everything goes as expected
// However, if you save this into a file and call magma on it, it you get some random errors
// And, if you remove these 3 line comments, everything goes as expected
