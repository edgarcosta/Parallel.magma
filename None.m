declare type None;

instrinsic IsNone(x::Any) -> BolElt
{ Checks if x is None }
  return x cmpeq None;
end instrinsic;
