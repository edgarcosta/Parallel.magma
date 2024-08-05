
function MagmaPipe(n, C, S)
  out := [];
  for i:=1 to #C by n do
    indices := [i..Min(#C, i+n-1)];
    out cat:= Pipe(C[indices], S[indices]);
  end for;
  return out;
end function;


intrinsic ParallelPipe(n::RngIntElt, C::SeqEnum[MonStgElt], S::SeqEnum[MonStgElt]) -> SeqEnum[MonStgElt]
{ Given a shell command lines in sequence C and parallel input strings in sequence S, create a pipe for each command C[i], send S[i] into the standard input of C[i], and finally return a sequence O such that O[i] has the output of command C[i] (all pipes are run in parallel using at most n threads) }
  require #C eq #S: "Lengths of sequence commands and arguments should be the same";
  try
    Pipe("command -v parallel", "");
    PP := func<n, C, S|ParallelGNUPipe(n, C, S: RaiseError:=true)>;
  catch e
    PP := MagmaPipe;
  end try;
  return PP(n, C, S);
end intrinsic;

intrinsic ParallelGNUPipe(n::RngIntElt, C::SeqEnum[MonStgElt], S::SeqEnum[MonStgElt] : RaiseError:=false) -> SeqEnum[MonStgElt], SeqEnum[MonStgElt]
{ Given a shell command lines in sequence C and parallel input strings in sequence S, create a pipe for each command C[i], send S[i] into the standard input of C[i], and finally return sequences O and E such that O[i] (resp. E[i]) has the output (resp. error) of command C[i] (all pipes are run in parallel using at most n threads) }
  tmpdir := MkTemp(:Directory:=true);
  input := [Sprintf("%o < %o/%o.in > %o/%o.out 2> %o/%o.err\n", c, tmpdir, i, tmpdir, i, tmpdir, i)  : i->c in C];
  inputfn := Sprintf("%o/parallel.input", tmpdir);
  Write(inputfn, Join(input, ""));
  for i->s in S do
    Write(Sprintf("%o/%o.in", tmpdir, i), s);
  end for;
  try
    _ := Pipe(Sprintf("parallel -j %o -a %o", n, inputfn), "");
    success := true;
  catch e
    success := false;
    msg := e;
  end try;
  output := [Read(Sprintf("%o/%o.out", tmpdir, i)) : i->_ in C];
  err := [Read(Sprintf("%o/%o.err", tmpdir, i)) : i->_ in C];
  RemoveDirectory(tmpdir);
  if RaiseError and not success then
     error msg;
  end if;
  return output, err;
end intrinsic;
