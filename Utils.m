freeze;

parentpid := Getpid();
intrinsic IsParentProcess() -> BoolElt
  { True iff is the parent process }
  return parentpid eq Getpid();
end intrinsic;

intrinsic ParallelFor(f::UserProgram, inputs::List, ncpus::RngIntElt, nout::RngIntElt) -> List
{}
  // r, i := MultiFork(ncpus);
  return [* *];
end intrinsic;
