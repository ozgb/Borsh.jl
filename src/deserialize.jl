using Base: _counttuple

"Serialize from an array"
function deserialize(arr, type)
    io = IOBuffer(arr)
    deserialize!(io, type)
end

"Deserialize a struct. Use this to implement deserialize! for user-defined types"
function deserialize_struct!(io::IOBuffer, type)
    names = fieldnames(type)
    vals = [deserialize!(io, fieldtype(type, f)) for f in names]
    type(vals...)
end

"Deserialize an enum. Use this to implement deserialize! for user-defined types"
deserialize!(io::IOBuffer, t::Type{<:Integer}) = begin
    i = read(io, t)
    ltoh(i)
end

"Deserialize Floats"
deserialize!(io::IOBuffer, t::Type{<:AbstractFloat}) = begin
    i = read(io, t)
    ltoh(i)
end

"Deserialize Vectors (1-dim Array)"
deserialize!(io::IOBuffer, t::Type{<:Vector}) = begin
    n = read(io, Int32)
    [deserialize!(io, eltype(t)) for _ = 1:n]
end

"Deserialize Bools"
deserialize!(io::IOBuffer, ::Type{Bool}) = begin
    read(io, Bool)
end

"Deserialize Tuples"
deserialize!(io::IOBuffer, t::Type{<:Tuple}) = begin
    n = _counttuple(t)
    t([deserialize!(io, eltype(t)) for _ = 1:n])
end

"Deserialize Strings"
deserialize!(io::IOBuffer, ::Type{String}) = begin
    nb = read(io, UInt32)
    bytes = read(io, nb)
    String(bytes)
end

"Deserialize Option types"
deserialize!(io::IOBuffer, t::Type{O}) where {T,O<:Option{T}} = begin
    if t <: Some{T}
        read(io, UInt8(1))
        Some{T}(deserialize!(io, eltype(t)))
    else
        read(io, UInt8(0))
    end
end
