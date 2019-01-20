module ToStruct

function tostruct(x::AbstractDict, T::DataType)
    args = map(fieldnames(T)) do fname
        FT = fieldtype(T, fname)
        v = get(x, String(fname), nothing)
        tostruct(v, FT)
    end
    T(args...)
end

function tostruct(x::AbstractDict, T::Type{U} where U<:AbstractDict)
    KT, VT = eltype(T()).types
    T(tostruct(k, KT) => tostruct(v, VT) for (k, v) in x)
end

function tostruct(x::AbstractArray, T::Type{U} where U<:AbstractArray)
    ET = eltype(T)
    T(collect(tostruct(v, ET) for v in x))
end

function tostruct(x::Any, T::Union)
    try
        tostruct(x, T.a)
    catch
        tostruct(x, T.b)
    end
end

function tostruct(x::Any, T::Type)
    x::T
end

end # module
