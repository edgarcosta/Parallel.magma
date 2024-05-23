Attach("multifork.m");
procedure()
  b, r := MultiFork(10);
  print b, r;
  if r ne 0 then
    exit 0;
  end if;
  Sleep(1);
end procedure();
