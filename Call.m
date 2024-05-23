function _Call(f, input, nvals, optional) // to allow f to be an UserProgram or Intrinsic
  tmp := f;
  input_string := Join([Sprintf("input[%o]", i) : i->_ in input], ", ");
  if #optional ge 1 then
    input_string cat:= ": ";
    input_string cat:= Join([Sprintf("%o:=optional[%o, 2]", t[1], i) : i->t in optional], ", ");
  end if;
  output_string := Join([Sprintf("output[%o]", i) : i in [1..nvals]], ", ");
  // The string that is used in the eval expression can refer to any variable that is in scope during the evaluation of the eval expression.
  // However, it is not possible for the expression to modify any of these variables.
  call_string := Sprintf("
  output := [* None : _ in [1..nvals] *];
  %o := tmp(%o);
  return output;", output_string, input_string);
  try
    output := eval call_string;
    output := [* elt: elt in output | output cmpne None *];
    success_call := true;
  catch e
    print e;
    success_call := false;
    output := None;
  end try;
  return success_call, output;
end function;

intrinsic Call(f::UserProgram, input::Tup, nvals::RngIntElt : optional:=<> ) -> BoolElt, List
  { Call f on the input and return nvals }
  return _Call(f, input, nvals, optional);
end intrinsic;

intrinsic Call(f::Intrinsic, input::Tup, nvals::RngIntElt : optional:=<> ) -> BoolElt, List
  { " } //"
  return _Call(f, input, nvals, optional);
end intrinsic;
