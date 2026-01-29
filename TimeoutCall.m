freeze;

intrinsic TimeoutCall(timeout::RngIntElt, f::Program, input::Tup, number_of_results::RngIntElt : Parameters:=[], Buffer:=1) -> BoolElt, List, Any
  { Call f on the input with a timeout in seconds. Returns success, output, elapsed time. }
  require timeout ge 1 : "Argument 1 must be at least 1";
  require number_of_results ge 0 : "Argument 4 must be non-negative";
  require Buffer ge 0 : "Buffer must be non-negative";

  outfile, F := TemporaryFile();
  delete F;  // close handle, we'll write from child

  child := Fork(:CloseStdin:=true);
  if child eq 0 then
    // Child process
    Alarm(timeout + Buffer);
    start := Time();
    success, output := Call(f, input, number_of_results : Parameters:=Parameters);
    elapsed := Time(start);
    WriteObject(Open(outfile, "w"), <success, EncodeNone(output), elapsed>);
    exit 0;
  end if;

  // Parent process
  WaitForAllChildren();

  // Check if output file has content (child completed before timeout)
  if #Read(outfile) gt 0 then
    success, output, elapsed := Explode(ReadObject(Open(outfile, "r")));
    Remove(outfile);
    return success, DecodeNone(output), elapsed;
  else
    // Timeout or crash - empty output file
    Remove(outfile);
    return false, None, -1.0;
  end if;
end intrinsic;
