# Borsh.jl

[Borsh](https://borsh.io/) serialization and deserialization for Julia.

## Features

- Supports all Borsh types: Primitive, Struct, Enum, FixedArray (Tuple), VariableArray (Vector), Options
- Adds an `Option` type to represent the `Option` type in Borsh

TODO:
- Map
- Set

## Usage

```julia
using Borsh

struct MyStruct
    a::Int32
    b::String
end
# Implement serialization for MyStruct
Borsh.serialize!(io::IOBuffer, s::MyStruct) = Borsh.serialize_struct!(io, s)

res = Borsh.serialize(MyStruct(42, "hello"))

# Result: 
# 13-element Vector{UInt8}:
#  [0x2a, 0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00, 0x68, 0x65, 0x6c, 0x6c, 0x6f]
```

Option types:
```julia
using Borsh: Some;
i = Some(Some(UInt8(4)))

res = Borsh.serialize(i)

# Result: [0x1, 0x1, 0x4]
```
