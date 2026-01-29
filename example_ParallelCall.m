// Example: Parallel factorization of large semiprimes
//
// Usage:
//   magma example_ParallelCall.m
//   magma jobs:=8 example_ParallelCall.m

AttachSpec("spec");

// Default to 4 jobs if not specified
if not assigned jobs then
  jobs := 4;
else
  jobs := StringToInteger(jobs);
end if;

print Sprintf("Running with %o parallel workers", jobs);

// Generate semiprimes (product of two large primes)
ns := [NextPrime(2^64-2^32*i)*NextPrime(2^64+2^32*i) : i in [1..jobs]];

print "Numbers to factorize:";
for i in [1..Min(3, #ns)] do
  print Sprintf("  ns[%o] = %o", i, ns[i]);
end for;
if #ns gt 3 then
  print Sprintf("  ... and %o more", #ns - 3);
end if;

// Parallel factorization
print "\nParallel factorization:";
time results := ParallelCall(jobs, Factorization, [<n> : n in ns], 1);

// Sequential factorization for comparison
print "\nSequential factorization:";
time sequential := [Factorization(n) : n in ns];

// Verify results match
matches := [results[i, 2, 1] eq elt : i->elt in sequential];
print Sprintf("\nResults match: %o", &and matches);

// Show sample result
print "\nSample result (first factorization):";
print Sprintf("  Success: %o", results[1, 1]);
print Sprintf("  Factors: %o", results[1, 2, 1]);
print Sprintf("  Time: %o seconds", results[1, 3]);

exit 0;
