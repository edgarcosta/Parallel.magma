function Multifork(n)
// Fork n copies of self and return the enumerator of self, and pids of the children
  parentpid := Getpid();
  IsParentProcess := func<|parentpid eq Getpid()>;
  res := [];
  for i in [1..n] do
    if IsParentProcess() then
      Append(~res, Fork());
      if not IsParentProcess() then
        return [], i;
      end if;
    end if;
  end for;
  return res, 0;
end function;

b, r := Multifork(10);
print b, r;
