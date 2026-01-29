freeze;

parentpid := Getpid();
intrinsic IsParentProcess() -> BoolElt
  { True iff is the parent process }
  return parentpid eq Getpid();
end intrinsic;
