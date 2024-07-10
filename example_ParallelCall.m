// We wrap the whole block in a procedure to make sure
// that the file is read and closed before any forking
jobs := StringToInteger(jobs);
procedure ()
  ns := [NextPrime(2^64-2^32*i)*NextPrime(2^64+2^32*i) : i in [1..jobs]];
  time p := ParallelCall(jobs, Factorization, [<n> : n in ns], 1);
  time np := [Factorization(n) : n in ns];
  [p[i, 2, 1] eq elt : i->elt in np];
end procedure();
