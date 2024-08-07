# Parallel.magma

### Here is a quick example
```
# magma -b
> jobs := 12;
> // The block is necessary to prevent Magma from getting confused when forking
> foo := function ()
>   ns := [NextPrime(2^64-2^32*i)*NextPrime(2^64+2^32*i) : i in [1..jobs]];
>   time p := ParallelCall(jobs, Factorization, [<n> : n in ns], 1);
>   time np := [Factorization(n) : n in ns];
>   [p[i, 2, 1] eq elt : i->elt in np];
>   return p;
> end function();
Time: 3.090[r]
Time: 14.840
[ true, true, true, true, true, true, true, true, true, true, true, true ]
> // it returns a boolean informing it succeeded or not, and then the output in a Tuple, and the running time
> foo[1..5];
[*
<true, <[ <18446744069414584321, 1>, <18446744078004519061, 1> ]>, "2.670">,
<true, <[ <18446744065119617029, 1>, <18446744082299486279, 1> ]>, "2.630">,
<true, <[ <18446744060824649753, 1>, <18446744086594453571, 1> ]>, "2.660">,
<true, <[ <18446744056529682433, 1>, <18446744090889420809, 1> ]>, "2.340">,
<true, <[ <18446744052234715181, 1>, <18446744095184388133, 1> ]>, "2.650">
*]
```
