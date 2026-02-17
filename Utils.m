freeze;

parentpid := Getpid();
intrinsic IsParentProcess() -> BoolElt
  { True iff is the parent process }
  return parentpid eq Getpid();
end intrinsic;

intrinsic _Fork(: CloseStdin:=true) -> RngIntElt
  { Fork with lazy-loaded modules initialized, so parent and child share frozen state }
  // Force loading of modules whose top-level state must be shared across Fork
  _ := IsParentProcess();
  _ := IsNone(None);
  return Fork(:CloseStdin:=CloseStdin);
end intrinsic;
