freeze;

// to allow f to be an UserProgram or Intrinsic
function _ParallelCall(n, f, inputs, parameters, number_of_results)
  n := Min(n, #inputs);
  if IsNone(parameters) then
    parameters := [<> : _ in inputs];
  end if;
  // work around the non serialization of None
  none_str := Tempname("__NONE__");
  encode_none := func<t| IsNone(t) select none_str else <IsNone(x) select none_str else x : x in t>>;
  decode_none := func<t| t cmpeq none_str select None else <x cmpeq none_str select None else x : x in t>> ;

  tmpdir := MkTemp(:Directory:=true);
  filename := func<i|Sprintf("%o/%o.out", tmpdir, i)>;
  children, index := MultiFork(n);
  if index ne 0 then
    output := [* *];
    for i in [i : i in [1..#inputs] | i mod n eq index-1 ] do
      start := Time();
      // this always succeeds
      b, out := Call(f, inputs[i],  number_of_results : Parameters:=parameters[i]);
      t := Time(start);
      Append(~output, <b, encode_none(out), t>);
    end for;
    WriteObject(Open(filename(index), "w"), output);
    exit;
  end if;
  WaitForAllChildren();
  output := [* None  : _ in inputs *];
  for index in [1..n] do
    indices := [i : i in [1..#inputs] | i mod n eq index-1 ];
    for i->elt in ReadObject(Open(filename(index), "r")) do // should be a list of pairs
      b, out, t := Explode(elt);
      output[indices[i]] := <b, decode_none(out), t>;
    end for;
  end for;
  RemoveDirectory(tmpdir);
  return output;
end function;

intrinsic ParallelCall(n::RngIntElt, f::UserProgram, inputs::SeqEnum[Tup], number_of_results::RngIntElt : Parameters:=None ) -> BoolElt, List
  { Call f on the inputs expecting return_nvals distributed over n workers}
  return _ParallelCall(n, f, inputs, Parameters, number_of_results);
end intrinsic;

intrinsic ParallelCall(n::RngIntElt, f::UserProgram, inputs::List, number_of_results::RngIntElt : Parameters:=None ) -> BoolElt, List
  { " } //"
  return _ParallelCall(n, f, inputs, Parameters, number_of_results);
end intrinsic;

intrinsic ParallelCall(n::RngIntElt, f::Intrinsic, inputs::SeqEnum[Tup], number_of_results::RngIntElt : Parameters:=None ) -> BoolElt, List
  { " } //"
  return _ParallelCall(n, f, inputs, Parameters, number_of_results);
end intrinsic;

intrinsic ParallelCall(n::RngIntElt, f::Intrinsic, inputs::List, number_of_results::RngIntElt : Parameters:=None ) -> BoolElt, List
  { " } //"
  return _ParallelCall(n, f, inputs, Parameters, number_of_results);
end intrinsic;
