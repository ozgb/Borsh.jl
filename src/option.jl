""" Abstract type for Option """
abstract type Option{T} end
struct Some{T} <: Option{T}
    value::T
end
struct None{T} <: Option{T} end

Base.eltype(::Type{Option{T}}) where {T} = T
Base.eltype(::Type{Some{T}}) where {T} = T
Base.eltype(::Type{None{T}}) where {T} = T

Base.:(==)(x::None{T}, y::O) where {T,O<:None} = true
Base.:(==)(x::Type{None{T}}, y::Type{O}) where {T,O<:None} = true

function none()
    None{Any}()
end
