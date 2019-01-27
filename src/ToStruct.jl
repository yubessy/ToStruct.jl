module ToStruct

function tostruct(T::Type, x::Any)
    try
        x::T
    catch
        try
            convert(T, x)
        catch
            T(x)
        end
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

function tostruct(T::DataType, x::AbstractDict{AbstractString})
    args = map(fieldnames(T)) do fname
        FT = fieldtype(T, fname)
        v = getdefault(FT, x, String(fname))
        tostruct(FT, v)
    end
    T(args...)
end

tostruct(T::DataType, x::AbstractDict) = tostruct(T, convert(Dict{AbstractString,Any}, x))

function getdefault(T::Type, x::AbstractDict, k::Any)
    if T >: Nothing
        get(x, k, nothing)
    elseif T >: Missing
        get(x, k, missing)
    else
        x[k]
    end
end

end # module
