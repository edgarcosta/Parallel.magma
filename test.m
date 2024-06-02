AttachSpec("spec");
ns := [NextPrime(2^64-2^32*i)*NextPrime(2^64+2^32*i) : i in [1..10]];
time p := function()
  return ParallelCall(10, Factorization, [<n> : n in ns], 1);
end function();
time np := [Factorization(n) : n in ns];
[p[i, 2, 1] eq elt : i->elt in np];
