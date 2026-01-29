// Tests for None type and utilities

// Test 1: IsNone with None
print "Test 1: IsNone with None";
assert IsNone(None);
print "  PASSED";

// Test 2: IsNone with non-None values
print "Test 2: IsNone with non-None values";
assert not IsNone(0);
assert not IsNone("");
assert not IsNone([]);
assert not IsNone(<>);
assert not IsNone(true);
print "  PASSED";

// Test 3: EncodeNone with None
print "Test 3: EncodeNone with None";
encoded := EncodeNone(None);
assert Type(encoded) eq MonStgElt;  // encoded as sentinel string
print "  PASSED";

// Test 4: DecodeNone recovers None
print "Test 4: DecodeNone recovers None";
encoded := EncodeNone(None);
decoded := DecodeNone(encoded);
assert IsNone(decoded);
print "  PASSED";

// Test 5: EncodeNone/DecodeNone with tuple containing None
print "Test 5: EncodeNone/DecodeNone with tuple containing None";
original := <1, None, "hello", None>;
encoded := EncodeNone(original);
decoded := DecodeNone(encoded);
assert decoded[1] eq 1;
assert IsNone(decoded[2]);
assert decoded[3] eq "hello";
assert IsNone(decoded[4]);
print "  PASSED";

// Test 6: EncodeNone/DecodeNone with tuple without None
print "Test 6: EncodeNone/DecodeNone with tuple without None";
original := <1, 2, 3>;
encoded := EncodeNone(original);
decoded := DecodeNone(encoded);
assert decoded eq original;
print "  PASSED";

// Test 7: EncodeNone/DecodeNone roundtrip via serialization
print "Test 7: Roundtrip via serialization";
original := <true, None, 42>;
fn, F := TemporaryFile();
delete F;
WriteObject(Open(fn, "w"), EncodeNone(original));
recovered := DecodeNone(ReadObject(Open(fn, "r")));
Remove(fn);
assert recovered[1] eq true;
assert IsNone(recovered[2]);
assert recovered[3] eq 42;
print "  PASSED";

print "";
print "All tests passed!";
