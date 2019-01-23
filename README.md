# ToStruct.jl

Easy way to convert dict to struct

## Usage

```
julia> using ToStruct

julia> struct S1
         int::Int
         str::String
       end

julia> struct S2
         s1::S1
       end

julia> raws2 = Dict("s1" => Dict("int" => 1, "str" => "foo"))
Dict{String,Dict{String,Any}} with 1 entry:
  "s1" => Dict{String,Any}("int"=>1,"str"=>"foo")

julia> ToStruct.tostruct(raws2, S2)
S2(S1(1, "foo"))
```
