// Tests for Call intrinsic

// Helper functions for testing
function add(a, b)
  return a + b;
end function;

procedure no_return(x)
  // procedure with no return value
  _ := x;
end procedure;

function no_args()
  return 42;
end function;

function multi_return(x)
  return x, x + 1, x + 2;
end function;

function with_param(x : Offset := 0)
  return x + Offset;
end function;

// Test 1: Normal case with 1 result
print "Test 1: Normal case with 1 result";
success, output := Call(add, <2, 3>, 1);
assert success;
assert output[1] eq 5;
print "  PASSED";

// Test 2: Multiple results
print "Test 2: Multiple results";
success, output := Call(multi_return, <10>, 3);
assert success;
assert output[1] eq 10;
assert output[2] eq 11;
assert output[3] eq 12;
print "  PASSED";

// Test 3: Zero results (procedure-like call)
print "Test 3: Zero results";
success, output := Call(no_return, <5>, 0);
assert success;
assert #output eq 0;
print "  PASSED";

// Test 4: No inputs
print "Test 4: No inputs";
success, output := Call(no_args, <>, 1);
assert success;
assert output[1] eq 42;
print "  PASSED";

// Test 5: With parameters
print "Test 5: With parameters";
success, output := Call(with_param, <10>, 1 : Parameters := [<"Offset", 5>]);
assert success;
assert output[1] eq 15;
print "  PASSED";

// Test 6: No inputs and zero results
print "Test 6: No inputs and zero results";
procedure empty_proc()
end procedure;
success, output := Call(empty_proc, <>, 0);
assert success;
assert #output eq 0;
print "  PASSED";

// Test 7: Function with return value, but request 0 results (ignore return)
print "Test 7: Ignore return value";
success, output := Call(no_args, <>, 0);
assert success;
assert #output eq 0;
print "  PASSED";

print "";
print "All tests passed!";
