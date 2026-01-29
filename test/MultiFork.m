// Tests for MultiFork intrinsic

// Test 1: MultiFork with 2 children
print "Test 1: MultiFork with 2 children";
children, index := MultiFork(2);
if index ne 0 then
  // Child process - just exit
  exit 0;
end if;
// Parent process
assert #children eq 2;
assert index eq 0;
WaitForAllChildren();
print "  PASSED";

// Test 2: MultiFork with 1 child
print "Test 2: MultiFork with 1 child";
children, index := MultiFork(1);
if index ne 0 then
  exit 0;
end if;
assert #children eq 1;
assert index eq 0;
WaitForAllChildren();
print "  PASSED";

// Test 3: Children get correct indices
print "Test 3: Children get correct indices";
tmpdir := TemporaryDirectory();
children, index := MultiFork(3);
if index ne 0 then
  // Child writes its index to a file
  Write(Sprintf("%o/%o.txt", tmpdir, index), IntegerToString(index));
  exit 0;
end if;
WaitForAllChildren();
// Parent reads and verifies
for i in [1..3] do
  content := Read(Sprintf("%o/%o.txt", tmpdir, i));
  assert StringToInteger(content) eq i;
end for;
Remove(tmpdir);
print "  PASSED";

print "";
print "All tests passed!";
