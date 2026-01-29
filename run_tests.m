// usage: magma target:=SUBSTRING exitsignal:=BOOL run_tests.m
if assigned filename then
  if "test/" eq filename[1..5] then
    filename := filename[6..#filename];
  end if;
  tests := [filename];
else
  tests := Split(Pipe("ls test", ""), "\n");
end if;
if assigned debug then
  SetDebugOnError(true);
end if;
AttachSpec("spec");
failed := [];
if not assigned target then
  target := "";
end if;

counter := 0;
for filename in tests do
  if target in filename then
    counter +:=1;
    fullPath := "test/" cat filename;
    timestamp := Time();
    if assigned debug then
      printf "%o: ", filename;
      assert eval (Read(fullPath) cat  "return true;");
      printf "Success! %o s\n", Time(timestamp);
    else
      try
        printf "%o: ", filename;
        assert eval (Read(fullPath) cat  "return true;");
        printf "Success! %o s\n", Time(timestamp);
      catch e
        Append(~failed, filename);
        printf "Fail! %o s\n %o\n", e, Time(timestamp);;
      end try;
    end if;
  end if;
end for;
if counter eq 0 then
  print "No matching target";
  exit 1;
end if;
if #failed gt 0 then
  print "Tests failed:";
  for f in failed do
    print f;
  end for;
end if;
if assigned exitsignal then
  exit #failed;
end if;
exit 0;

