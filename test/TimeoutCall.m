// Tests for TimeoutCall intrinsic

// Helper functions for testing
function fast_func(x)
  return x^2;
end function;

function slow_func(x)
  Sleep(10);
  return x^2;
end function;

function multi_return(x)
  return x, x + 1;
end function;

procedure do_nothing(x)
  _ := x;
end procedure;

// Test 1: Function completes within timeout
print "Test 1: Function completes within timeout";
success, output, elapsed := TimeoutCall(5, fast_func, <7>, 1);
assert success;
assert output[1] eq 49;
assert Type(elapsed) eq MonStgElt;  // elapsed is a time string
print "  PASSED";

// Test 2: Function times out
print "Test 2: Function times out";
success, output, elapsed := TimeoutCall(1, slow_func, <5>, 1 : Buffer:=0);
assert not success;
assert #output eq 0;
assert elapsed eq -1.0;  // -1.0 indicates timeout
print "  PASSED";

// Test 3: Multiple return values
print "Test 3: Multiple return values";
success, output, elapsed := TimeoutCall(5, multi_return, <10>, 2);
assert success;
assert output[1] eq 10;
assert output[2] eq 11;
print "  PASSED";

// Test 4: Zero results (procedure)
print "Test 4: Zero results";
success, output, elapsed := TimeoutCall(5, do_nothing, <42>, 0);
assert success;
assert #output eq 0;
print "  PASSED";

// Test 5: Custom buffer
print "Test 5: Custom buffer";
success, output, elapsed := TimeoutCall(2, fast_func, <3>, 1 : Buffer:=2);
assert success;
assert output[1] eq 9;
print "  PASSED";

print "";
print "All tests passed!";
