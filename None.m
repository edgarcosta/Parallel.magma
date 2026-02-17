freeze;

declare type None;

// Unique sentinel for serialization (generated once at load time)
NONE_SENTINEL := Tempname("__MAGMA_NONE_SENTINEL__");

intrinsic IsNone(x::Any) -> BoolElt
  { Checks if x is None }
  return x cmpeq None;
end intrinsic;

intrinsic EncodeNone(t) -> Any
  { Encode None values for serialization }
  return IsNone(t) select NONE_SENTINEL else <IsNone(x) select NONE_SENTINEL else x : x in t>;
end intrinsic;

intrinsic DecodeNone(t) -> Any
  { Decode None values after deserialization }
  return t cmpeq NONE_SENTINEL select None else <x cmpeq NONE_SENTINEL select None else x : x in t>;
end intrinsic;

