
freeze;

parentpid := Getpid();
intrinsic IsParentProcess() -> BoolElt
  { True iff is the parent process }
  return parentpid eq Getpid();
end intrinsic;

intrinsic MultiFork(n::RngIntElt) -> SeqEnum[RngIntElt], RngIntElt
  { Fork n copies of self and return the enumerator of self, and pids of the children }
  res := [];
  for i in [1..n] do
    if #res eq i - 1 then // only the parent gets inside of this loop
      f := Fork();
      if f ne 0 then // parent branch
        Append(~res, f);
      else
        return [], i; // child branch
      end if;
    end if;
  end for;
  return res, 0;
end intrinsic;

function _Call(f, input, nvals) // to allow f to be an UserProgram or Intrinsic
  tmp := f;
  input_string := Join([Sprintf("input[%o]", i) : i->_ in input], ", ");
  output_string := Join([Sprintf("output[%o]", i) : i in [1..nvals]], ", ");
  // The string that is used in the eval expression can refer to any variable that is in scope during the evaluation of the eval expression.
  // However, it is not possible for the expression to modify any of these variables. 
  call_string := Sprintf("
  output := [* 0 : _ in [1..nvals] *];
  %o := tmp(%o);
  return output;", output_string, input_string);
  try
    output := eval call_string;
    success_call := true;
  catch e
    print e;
    success_call := false;
    output := [* *];
  end try;
  return success_call, output;
end function;

intrinsic Call(f::UserProgram, input::Tup, nvals::RngIntElt) -> BoolElt, List
  { Call f on the input and return nvals }
  return _Call(f, input, nvals);
end intrinsic;

intrinsic Call(f::Intrinsic, input::Tup, nvals::RngIntElt) -> BoolElt, List
  { " } //"
  return _Call(f, input, nvals);
end intrinsic;

intrinsic ParallelFor(f::UserProgram, inputs::List, ncpus::RngIntElt, nout::RngIntElt) -> List
{}
  // r, i := MultiFork(ncpus);
  return [* *];
end intrinsic;
