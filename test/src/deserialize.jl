module DeserializeTests

import Borsh
using Test

@testset "Deserialize - Integers" begin
    @test Borsh.deserialize([0x01], Int8) == Int8(1)
end

@testset verbose = true "Deserialize - Tuples" begin
    t::Tuple{UInt8,UInt8,UInt8} = (0x11, 0x22, 0x33)
    @test Borsh.deserialize([0x11, 0x22, 0x33], typeof(t)) == t
end

@testset "Deserialize - Structs" begin
    struct T
        x::Int8
        y::Int8
    end
    Borsh.serialize!(io::IOBuffer, x::T) = Borsh.serialize_struct!(io, x)
    Borsh.deserialize!(io::IOBuffer, t::Type{T}) = Borsh.deserialize_struct!(io, t)

    t = T(1, 2)
    @test Borsh.deserialize(Borsh.serialize(t), T) == t
end

@testset "Deserialize - Enum" begin
    @enum Tag::UInt8 a = 1 b c
    struct SumType
        tag::Tag
        val::Union{Int8,Int32,Int64}
    end

    Borsh.serialize!(io::IOBuffer, x::SumType) = begin
        Borsh.serialize_enum!(io, UInt8(x.tag), x.val)
    end

    Borsh.deserialize!(io::IOBuffer, ::Type{<:SumType}) = begin
        tag = Tag(Borsh.deserialize!(io, UInt8))
        if tag == a
            val = Borsh.deserialize!(io, Int8)
        elseif tag == b
            val = Borsh.deserialize!(io, Int32)
        elseif tag == c
            val = Borsh.deserialize!(io, Int64)
        else
            throw(ArgumentError("Invalid tag"))
        end
        SumType(tag, val)
    end

    t = SumType(b, Int32(0x02))

    @test Borsh.deserialize(Borsh.serialize(t), typeof(t)) == t
end

@testset "Deserialize - Option" begin
    o = Borsh.Some(Borsh.Some(UInt8(4)))

    @test Borsh.deserialize(Borsh.serialize(o), typeof(o)) == o
end

end
