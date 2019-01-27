module ToStruct

function tostruct(T::DataType, x::AbstractDict)
    # In order to convert to struct, x's keys must be able to be converted to symbol.
    x = Dict(Symbol(k) => v for (k, v) in x)

    args = map(fieldnames(T)) do fname
        FT = fieldtype(T, fname)
        v = get(x, fname, nothing)
        tostruct(FT, v)
    end
    T(args...)
end

function tostruct(T::Type{U} where U<:AbstractDict, x::AbstractDict)
    KT, VT = eltype(T()).types
    T(tostruct(KT, k) => tostruct(VT, v) for (k, v) in x)
end

function tostruct(T::Type{U} where U<:AbstractArray, x::AbstractArray)
    ET = eltype(T)
    T(collect(tostruct(ET, e) for e in x))
end

function tostruct(T::Union, x::Any)
    try
        tostruct(T.a, x)
    catch
        tostruct(T.b, x)
    end
end

function tostruct(T::Type, x::Any)
    try
        x::T
    catch
        T(x)
    end
end

end # module
