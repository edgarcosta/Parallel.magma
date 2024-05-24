freeze;

declare type None;

intrinsic IsNone(x::Any) -> BoolElt
  { Checks if x is None }
  return x cmpeq None;
end intrinsic;
