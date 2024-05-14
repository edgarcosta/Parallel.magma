AttachSpec("spec");
r := 0;
b, r := MultiFork(10);
printf "%o, %o\n", r, b;
if r ne 0 then
  exit 0;
end if;
// foo := func<x,y,z|x + y + z>;
// b, bar := Call(foo, <1,2,3>, 1);
