"Serialize to an array"
function serialize(x)
    io = IOBuffer()
    serialize!(io, x)
    take!(io)
end

"Serialize a struct. Use this to implement serialize! for user-defined types"
function serialize_struct!(io::IOBuffer, x)
    type = typeof(x)
    names = fieldnames(type)
    for f in names
        serialize!(io, getfield(x, f))
    end
end

"Serialize an enum. Use this to implement serialize! for user-defined types"
function serialize_enum!(io::IOBuffer, tag::UInt8, value)
    serialize!(io, tag)
    serialize!(io, value)
end

serialize!(io::IOBuffer, x::Integer) = begin
    x = htol(x)
    write(io, x)
end

"""Serialize Floats"""
serialize!(io::IOBuffer, x::AbstractFloat) = begin
    if x == NaN
        throw(ArgumentError("Cannot serialize NaN"))
    end
    x = htol(x)
    write(io, x)
end

"""Serialize Vectors (1-dim Array)"""
serialize!(io::IOBuffer, x::Vector) = begin
    write(io, UInt32(length(x)))
    for i in x
        serialize!(io, i)
    end
end

"""Serialize Bools"""
serialize!(io::IOBuffer, x::Bool) = begin
    write(io, Int8(x))
end

"""Serialize Tuples"""
serialize!(io::IOBuffer, x::Tuple) = begin
    for i in x
        serialize!(io, i)
    end
end

"""Serialize Strings"""
serialize!(io::IOBuffer, x::String) = begin
    write(io, UInt32(length(x)))
    write(io, x)
end

"""Serialize Option types"""
serialize!(io::IOBuffer, x::Option) = begin
    if typeof(x) <: Some
        write(io, UInt8(1))
        serialize!(io, x.value)
    else
        write(io, UInt8(0))
    end
end
