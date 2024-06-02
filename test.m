AttachSpec("spec");
// we wrap the whole in a procedure to make sure
// that is the file is read and closed before any forking
procedure ()
  ns := [NextPrime(2^64-2^32*i)*NextPrime(2^64+2^32*i) : i in [1..10]];
  time p := ParallelCall(10, Factorization, [<n> : n in ns], 1);
  time np := [Factorization(n) : n in ns];
  [p[i, 2, 1] eq elt : i->elt in np];
end procedure();
