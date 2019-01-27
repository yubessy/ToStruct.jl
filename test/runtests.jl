using Test

import ToStruct.tostruct

struct S2
    str::String
    int::Int
end

struct S1
    i::Int
    s2::S2
end

@testset "struct" begin
    @test tostruct(S1, Dict(
        "i" => 1,
        "s2" => Dict(
            "str" => "foo",
            "int" => 1
        )
    )) == S1(
        1,
        S2(
            "foo",
            1
        )
    )
    @test tostruct(S1, Dict{Any,Any}(
        "i" => 1,
        "s2" => Dict{Any,Any}(
            "str" => "foo",
            "int" => 1
        )
    )) == S1(
        1,
        S2(
            "foo",
            1
        )
    )
end

@testset "dict" begin
    @test tostruct(Dict, Dict("a" => 1, "b" => 2, "c" => 3)) == Dict("a" => 1, "b" => 2, "c" => 3)
    @test tostruct(Dict{String,S2}, Dict(
        "a" => Dict("str" => "foo", "int" => 1),
        "b" => Dict("str" => "bar", "int" => 2),
    )) == Dict(
        "a" => S2("foo", 1),
        "b" => S2("bar", 2),
    )
end

@testset "array" begin
    @test tostruct(Vector, [1, 2, 3]) == [1, 2, 3]
    @test tostruct(Vector{S2}, [
        Dict("str" => "foo", "int" => 1),
        Dict("str" => "bar", "int" => 2),
    ]) == [
        S2("foo", 1),
        S2("bar", 2),
    ]
end

@testset "union" begin
    @test tostruct(Union{Nothing,Int}, 1) == 1
    @test tostruct(Union{Nothing,Int}, nothing) == nothing
end

@testset "primitive" begin
    @test tostruct(Int, 1) == 1
    @test tostruct(Float64, 1.) == 1.
    @test tostruct(String, "foo") == "foo"
    @test tostruct(Float64, 1) == 1.
end
