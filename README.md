# ToStruct.jl

Easy way to convert dict to struct

## Installation

```julia
using Pkg
Pkg.add("ToStruct)
```

## Usage

```julia
using ToStruct

struct Foo
    i::Int
    s::String
end

struct Bar
    foo::Foo
end

raw = Dict("foo" => Dict("i" => 1, "s" => "hello"))
ToStruct.tostruct(raws, Bar)
Bar(Foo(1, "hello"))
```
