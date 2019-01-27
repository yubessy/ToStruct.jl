module ToStruct

function tostruct(T::Type, x::Any)
    try
        x::T
    catch
        T(x)
    end
end

function tostruct(T::Union, x::Any)
    try
        tostruct(T.a, x)
    catch
        tostruct(T.b, x)
    end
end

function tostruct(T::Type{U} where U<:AbstractVector, x::AbstractVector)
    ET = eltype(T)
    T(collect(tostruct(ET, e) for e in x))
end

function tostruct(T::Type{U} where U<:AbstractDict, x::AbstractDict)
    KT, VT = eltype(T()).types
    T(tostruct(KT, k) => tostruct(VT, v) for (k, v) in x)
end

function tostruct(T::DataType, x::AbstractDict{AbstractString,Any})
    args = map(fieldnames(T)) do fname
        FT = fieldtype(T, fname)
        v = get(x, String(fname), nothing)
        tostruct(FT, v)
    end
    T(args...)
end

tostruct(T::DataType, x::AbstractDict) = tostruct(T, convert(Dict{AbstractString,Any}, x))

end # module
