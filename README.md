# Parallel.magma

A Magma package for parallel execution of functions using process forking.

## Table of Contents

- [Installation](#installation)
- [Intrinsics](#intrinsics)
  - [Call](#call)
  - [ParallelCall](#parallelcall)
  - [TimeoutCall](#timeoutcall)
  - [MultiFork](#multifork)
  - [ParallelPipe / Pipe](#parallelpipe--pipe)
  - [ParallelGNUPipe](#parallelgnupipe)
- [Example](#example)
- [Running Tests](#running-tests)
- [License](#license)

## Installation

```bash
git clone https://github.com/edgarcosta/Parallel.magma.git
```

Then in Magma:
```
AttachSpec("/path/to/Parallel.magma/spec");
```

## Intrinsics

### Call

```
Call(f::Program, input::Tup, number_of_results::RngIntElt : Parameters:=[]) -> BoolElt, List
```

Call a function `f` on the given `input` tuple, expecting `number_of_results` return values. This is a wrapper that handles both `UserProgram` and `Intrinsic` types uniformly.

**Returns:** `(success, output)` where `success` is a boolean and `output` is a list of return values.

```magma
> success, output := Call(Factorization, <100>, 1);
> output[1];
[ <2, 2>, <5, 2> ]
```

### ParallelCall

```
ParallelCall(n::RngIntElt, f::Program, inputs::SeqEnum[Tup], number_of_results::RngIntElt : Parameters:=None) -> List
ParallelCall(n::RngIntElt, f::Program, inputs::List, number_of_results::RngIntElt : Parameters:=None) -> List
```

Call function `f` on each input in `inputs` using up to `n` parallel workers.

**Returns:** A list of tuples `<success, output, elapsed_time>` for each input.

```magma
> jobs := 4;
> ns := [NextPrime(2^64-2^32*i)*NextPrime(2^64+2^32*i) : i in [1..jobs]];
> results := ParallelCall(jobs, Factorization, [<n> : n in ns], 1);
> results[1];
<true, [* [ <18446744069414584321, 1>, <18446744078004519061, 1> ] *], "0.270">
```

### TimeoutCall

```
TimeoutCall(timeout::RngIntElt, f::Program, input::Tup, number_of_results::RngIntElt : Parameters:=[], Buffer:=1) -> BoolElt, List, Any
```

Call function `f` on `input` with a timeout in seconds. If the function doesn't complete within the timeout, it is killed.

**Returns:** `(success, output, elapsed_time)` where `elapsed_time` is `-1.0` on timeout.

```magma
> // Function that completes in time
> success, output, elapsed := TimeoutCall(5, Factorization, <1000>, 1);
> success;
true

> // Function that times out
> slow := function(x) Sleep(10); return x; end function;
> success, output, elapsed := TimeoutCall(1, slow, <42>, 1 : Buffer:=0);
> success;
false
> elapsed;
-1.0
```

### MultiFork

```
MultiFork(n::RngIntElt) -> SeqEnum[RngIntElt], RngIntElt
```

Fork `n` child processes. Returns `(child_pids, index)` where `index` is 0 for the parent and 1..n for children.

### ParallelPipe / Pipe

```
ParallelPipe(n::RngIntElt, C::SeqEnum[MonStgElt], S::SeqEnum[MonStgElt]) -> SeqEnum[MonStgElt]
Pipe(n::RngIntElt, C::SeqEnum[MonStgElt], S::SeqEnum[MonStgElt]) -> SeqEnum[MonStgElt]
```

Run shell commands in parallel. For each command `C[i]`, send `S[i]` to stdin and collect stdout.

```magma
> outputs := ParallelPipe(2, ["cat", "tr 'a-z' 'A-Z'"], ["hello", "world"]);
> outputs;
[ "hello\n", "WORLD\n" ]
```

### ParallelGNUPipe

```
ParallelGNUPipe(n::RngIntElt, C::SeqEnum[MonStgElt], S::SeqEnum[MonStgElt] : RaiseError:=false) -> SeqEnum[MonStgElt], SeqEnum[MonStgElt]
```

Like `ParallelPipe` but uses GNU parallel (if available) and returns both stdout and stderr.

## Example

```magma
> jobs := 12;
> // Factorize large numbers in parallel
> ns := [NextPrime(2^64-2^32*i)*NextPrime(2^64+2^32*i) : i in [1..jobs]];
> time results := ParallelCall(jobs, Factorization, [<n> : n in ns], 1);
Time: 3.090
> time sequential := [Factorization(n) : n in ns];
Time: 14.840
> // Verify results match
> [results[i, 2, 1] eq elt : i->elt in sequential];
[ true, true, true, true, true, true, true, true, true, true, true, true ]
```

## Running Tests

```bash
magma run_tests.m
```

## License

See [LICENSE](LICENSE) file.
