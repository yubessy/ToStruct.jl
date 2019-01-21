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
    @test tostruct(Dict(
        "i" => 1,
        "s2" => Dict(
            "str" => "foo",
            "int" => 1
        )
    ), S1) == S1(
        1,
        S2(
            "foo",
            1
        )
    )
end

@testset "dict" begin
    @test tostruct(Dict("a" => 1, "b" => 2, "c" => 3), Dict) == Dict("a" => 1, "b" => 2, "c" => 3)
    @test tostruct(Dict(
        "a" => Dict("str" => "foo", "int" => 1),
        "b" => Dict("str" => "bar", "int" => 2),
    ), Dict{String,S2}) == Dict(
        "a" => S2("foo", 1),
        "b" => S2("bar", 2),
    )
end

@testset "array" begin
    @test tostruct([1, 2, 3], Vector) == [1, 2, 3]
    @test tostruct([
        Dict("str" => "foo", "int" => 1),
        Dict("str" => "bar", "int" => 2),
    ], Vector{S2}) == [
        S2("foo", 1),
        S2("bar", 2),
    ]
end

@testset "union" begin
    @test tostruct(1, Union{Nothing,Int}) == 1
    @test tostruct(nothing, Union{Nothing,Int}) == nothing
end

@testset "primitive" begin
    @test tostruct(1, Int) == 1
    @test tostruct(1., Float64) == 1.
    @test tostruct("foo", String) == "foo"
    @test tostruct(1, Float64) == 1.
end
