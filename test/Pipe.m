// Tests for Pipe intrinsics

// Helper to strip trailing newline from outputs
rstripnewline := func<s | #s gt 0 and s[#s] eq "\n" select s[1..#s-1] else s>;

// Test 1: Basic ParallelPipe with cat
print "Test 1: Basic ParallelPipe with cat";
commands := ["cat", "cat", "cat"];
inputs := ["hello", "world", "test"];
outputs := ParallelPipe(2, commands, inputs);
assert #outputs eq 3;
assert rstripnewline(outputs[1]) eq "hello";
assert rstripnewline(outputs[2]) eq "world";
assert rstripnewline(outputs[3]) eq "test";
print "  PASSED";

// Test 2: Pipe alias
print "Test 2: Pipe alias";
commands := ["cat", "cat"];
inputs := ["foo", "bar"];
outputs := Pipe(2, commands, inputs);
assert #outputs eq 2;
assert rstripnewline(outputs[1]) eq "foo";
assert rstripnewline(outputs[2]) eq "bar";
print "  PASSED";

// Test 3: Single command
print "Test 3: Single command";
commands := ["cat"];
inputs := ["single"];
outputs := ParallelPipe(1, commands, inputs);
assert #outputs eq 1;
assert rstripnewline(outputs[1]) eq "single";
print "  PASSED";

// Test 4: More workers than commands
print "Test 4: More workers than commands";
commands := ["cat", "cat"];
inputs := ["a", "b"];
outputs := ParallelPipe(10, commands, inputs);
assert #outputs eq 2;
assert rstripnewline(outputs[1]) eq "a";
assert rstripnewline(outputs[2]) eq "b";
print "  PASSED";

// Test 5: Command with transformation
print "Test 5: Command with transformation (tr)";
commands := ["tr 'a-z' 'A-Z'", "tr 'a-z' 'A-Z'"];
inputs := ["hello", "world"];
outputs := ParallelPipe(2, commands, inputs);
assert #outputs eq 2;
assert rstripnewline(outputs[1]) eq "HELLO";
assert rstripnewline(outputs[2]) eq "WORLD";
print "  PASSED";

// Test 6: Empty input
print "Test 6: Empty input strings";
commands := ["cat", "cat"];
inputs := ["", "nonempty"];
outputs := ParallelPipe(2, commands, inputs);
assert #outputs eq 2;
assert rstripnewline(outputs[1]) eq "";
assert rstripnewline(outputs[2]) eq "nonempty";
print "  PASSED";

// Test 7: ParallelGNUPipe returns output and error
print "Test 7: ParallelGNUPipe with stderr";
commands := ["cat"];
inputs := ["test input"];
outputs, errs := ParallelGNUPipe(1, commands, inputs);
assert #outputs eq 1;
assert #errs eq 1;
assert rstripnewline(outputs[1]) eq "test input";
assert rstripnewline(errs[1]) eq "";  // no error expected
print "  PASSED";

print "";
print "All tests passed!";
