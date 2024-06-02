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

intrinsic MkTemp(:Directory) -> MonStgElt
  { calls mktemp on Unix systems}
  cmd := "mktemp";
  if Directory then
    cmd *:= " -d";
  end if;
  return StripWhiteSpace(Pipe(cmd, ""));
end intrinsic;


intrinsic RemoveDirectory(path)
  { remove directory path on Unix systems }
  r := System(Sprintf("rm -r '%o'", path));
  if r ne 0 then
    error Sprintf("Failed to remove '%o'", path);
  end if;
end intrinsic;
