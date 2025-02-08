module SerializeTests

import Borsh
using Test

@testset "Serialize - Integers" begin
    @test Borsh.serialize(Int8(1)) == [0x01]
    @test Borsh.serialize(Int32(1)) == [0x01, 0x00, 0x00, 0x00]
    @test Borsh.serialize(UInt64(257)) == [0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
end

@testset "Serialize - Tuples" begin
    t = (0x11, 0x22, 0x33)
    @test Borsh.serialize(t) == [0x11, 0x22, 0x33]
end

@testset "Serialize - Structs" begin
    struct T
        x::Int8
        y::Int8
    end
    Borsh.serialize!(io::IOBuffer, x::T) = Borsh.serialize_struct!(io, x)

    t = T(1, 2)
    @test Borsh.serialize(t) == [0x01, 0x02]
end

@testset "Serialize - Enum" begin
    @enum Tag::UInt8 a = 1 b c
    struct SumType
        tag::Tag
        val::Union{Int8,Int32,Int64}
    end

    Borsh.serialize!(io::IOBuffer, x::SumType) = begin
        Borsh.serialize_enum!(io, UInt8(x.tag), x.val)
    end

    t = SumType(b, Int32(0x02))
    @test Borsh.serialize(t) == [0x02, 0x02, 0x00, 0x00, 0x00]
end
@testset "Serialize - Option" begin
    i = Borsh.Some(Borsh.Some(UInt8(4)))

    @test Borsh.serialize(i) == [0x1, 0x1, 0x4]
end

end # module SerializeTests
