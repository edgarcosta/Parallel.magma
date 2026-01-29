// Tests for ParallelCall intrinsic

// Helper functions for testing
function add(a, b)
  return a + b;
end function;

function square(x)
  return x^2;
end function;

procedure do_nothing(x)
  _ := x;
end procedure;

function multi_return(x)
  return x, x + 1;
end function;

function with_param(x : Offset := 0)
  return x + Offset;
end function;

// Test 1: Basic SeqEnum input
print "Test 1: Basic SeqEnum input";
inputs := [<2, 3>, <4, 5>, <6, 7>];
results := ParallelCall(2, add, inputs, 1);
assert #results eq 3;
for i in [1..3] do
  success, output, elapsed := Explode(results[i]);
  assert success;
  assert output[1] eq inputs[i][1] + inputs[i][2];
end for;
print "  PASSED";

// Test 2: Basic List input
print "Test 2: Basic List input";
inputs := [* <10>, <20>, <30> *];
results := ParallelCall(2, square, inputs, 1);
assert #results eq 3;
assert results[1][2][1] eq 100;
assert results[2][2][1] eq 400;
assert results[3][2][1] eq 900;
print "  PASSED";

// Test 3: Single worker
print "Test 3: Single worker";
inputs := [<1>, <2>, <3>, <4>];
results := ParallelCall(1, square, inputs, 1);
assert #results eq 4;
for i in [1..4] do
  success, output, elapsed := Explode(results[i]);
  assert success;
  assert output[1] eq i^2;
end for;
print "  PASSED";

// Test 4: More workers than inputs
print "Test 4: More workers than inputs";
inputs := [<5>, <6>];
results := ParallelCall(10, square, inputs, 1);
assert #results eq 2;
assert results[1][2][1] eq 25;
assert results[2][2][1] eq 36;
print "  PASSED";

// Test 5: Zero results (procedure call)
print "Test 5: Zero results";
inputs := [<1>, <2>, <3>];
results := ParallelCall(2, do_nothing, inputs, 0);
assert #results eq 3;
for i in [1..3] do
  success, output, elapsed := Explode(results[i]);
  assert success;
  assert #output eq 0;
end for;
print "  PASSED";

// Test 6: Multiple return values
print "Test 6: Multiple return values";
inputs := [<10>, <20>];
results := ParallelCall(2, multi_return, inputs, 2);
assert #results eq 2;
success, output, elapsed := Explode(results[1]);
assert success;
assert output[1] eq 10;
assert output[2] eq 11;
success, output, elapsed := Explode(results[2]);
assert success;
assert output[1] eq 20;
assert output[2] eq 21;
print "  PASSED";

// Test 7: With parameters
print "Test 7: With parameters";
inputs := [<10>, <20>];
params := [[<"Offset", 5>], [<"Offset", 10>]];
results := ParallelCall(2, with_param, inputs, 1 : Parameters := params);
assert #results eq 2;
assert results[1][2][1] eq 15;  // 10 + 5
assert results[2][2][1] eq 30;  // 20 + 10
print "  PASSED";

// Test 8: Empty inputs
print "Test 8: Empty inputs";
inputs := [car<Integers()>| ];
results := ParallelCall(2, square, inputs, 1);
assert #results eq 0;
print "  PASSED";

print "";
print "All tests passed!";
