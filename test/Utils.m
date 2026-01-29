// Tests for Utils intrinsics

// Test 1: IsParentProcess in parent
print "Test 1: IsParentProcess in parent";
assert IsParentProcess();
print "  PASSED";

// Test 2: IsParentProcess after fork
print "Test 2: IsParentProcess after fork";
child := Fork(:CloseStdin:=true);
if child eq 0 then
  // Child process
  assert not IsParentProcess();
  exit 0;
end if;
WaitForAllChildren();
assert IsParentProcess();
print "  PASSED";

print "";
print "All tests passed!";
