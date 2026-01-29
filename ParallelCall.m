freeze;

function _ParallelCall(n, f, inputs, parameters, number_of_results)
  n := Min(n, #inputs);
  parameters := IsNone(parameters) select [* <> : _ in inputs *] else parameters;

  tmpdir := TemporaryDirectory();
  tempfiles := [Sprintf("%o/%o.out", tmpdir, i) : i in [1..n]];

  children, index := MultiFork(n);
  if index ne 0 then
    output := [* *];
    for i in [i : i in [1..#inputs] | i mod n eq index-1 ] do
      start := Time();
      b, out := Call(f, inputs[i], number_of_results : Parameters:=parameters[i]);
      t := Time(start);
      Append(~output, <b, EncodeNone(out), t>);
    end for;
    WriteObject(Open(tempfiles[index], "w"), output);
    exit;
  end if;
  WaitForAllChildren();
  output := [* None : _ in inputs *];
  for index in [1..n] do
    indices := [i : i in [1..#inputs] | i mod n eq index-1 ];
    for i->elt in ReadObject(Open(tempfiles[index], "r")) do
      b, out, t := Explode(elt);
      output[indices[i]] := <b, DecodeNone(out), t>;
    end for;
  end for;
  Remove(tmpdir);
  return output;
end function;

intrinsic ParallelCall(n::RngIntElt, f::Program, inputs::SeqEnum[Tup], number_of_results::RngIntElt : Parameters:=None ) -> List
  { Call f on the inputs expecting number_of_results distributed over n workers }
  require n ge 1 : "Argument 1 must be at least 1";
  require number_of_results ge 0 : "Argument 4 must be non-negative";
  return _ParallelCall(n, f, inputs, Parameters, number_of_results);
end intrinsic;

intrinsic ParallelCall(n::RngIntElt, f::Program, inputs::List, number_of_results::RngIntElt : Parameters:=None ) -> List
  { " } //"
  require n ge 1 : "Argument 1 must be at least 1";
  require number_of_results ge 0 : "Argument 4 must be non-negative";
  return _ParallelCall(n, f, inputs, Parameters, number_of_results);
end intrinsic;
