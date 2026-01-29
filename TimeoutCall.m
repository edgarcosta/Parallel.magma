freeze;

intrinsic TimeoutCall(timeout::RngIntElt, f::Program, input::Tup, number_of_results::RngIntElt : Parameters:=[], Buffer:=1) -> BoolElt, List, Any
  { Call f on the input with a timeout in seconds. Returns success, output, elapsed time. }
  require timeout ge 1 : "Argument 1 must be at least 1";
  require number_of_results ge 0 : "Argument 4 must be non-negative";
  require Buffer ge 0 : "Buffer must be non-negative";

  // work around the non serialization of None
  none_str := Tempname("__NONE__");
  encode_none := func<t| IsNone(t) select none_str else <IsNone(x) select none_str else x : x in t>>;
  decode_none := func<t| t cmpeq none_str select None else <x cmpeq none_str select None else x : x in t>>;

  outfile, F := TemporaryFile();
  delete F;  // close handle, we'll write from child

  child := Fork(:CloseStdin:=true);
  if child eq 0 then
    // Child process
    Alarm(timeout + Buffer);
    start := Time();
    success, output := Call(f, input, number_of_results : Parameters:=Parameters);
    elapsed := Time(start);
    WriteObject(Open(outfile, "w"), <success, encode_none(output), elapsed>);
    exit 0;
  end if;

  // Parent process
  WaitForAllChildren();

  // Check if output file has content (child completed before timeout)
  if #Read(outfile) gt 0 then
    success, output, elapsed := Explode(ReadObject(Open(outfile, "r")));
    Remove(outfile);
    return success, decode_none(output), elapsed;
  else
    // Timeout or crash - empty output file
    Remove(outfile);
    return false, [* *], -1.0;
  end if;
end intrinsic;
