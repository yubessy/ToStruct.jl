using Test

import ToStruct.tostruct

struct S1
    i::Int
    s::String
end

struct S2
    s1::S1
end

@testset "Any" begin
    @test tostruct(Int, 1) == 1
    @test tostruct(Float64, 1.) == 1.
    @test tostruct(String, "foo") == "foo"
    @test tostruct(Float64, 1) == 1.
end

@testset "Union" begin
    @test tostruct(Union{Nothing,Int}, 1) == 1
    @test tostruct(Union{Nothing,Int}, nothing) == nothing
end

@testset "Array" begin
    @test tostruct(Vector{S1}, [
        Dict("i" => 1, "s" => "foo"),
        Dict("i" => 2, "s" => "bar"),
    ]) == [
        S1(1, "foo"),
        S1(2, "bar"),
    ]
end

@testset "Dict" begin
    @test tostruct(Dict{String,S1}, Dict(
        "a" => Dict("i" => 1, "s" => "foo"),
        "b" => Dict("i" => 2, "s" => "bar"),
    )) == Dict(
        "a" => S1(1, "foo"),
        "b" => S1(2, "bar"),
    )
end

@testset "type" begin
    @test tostruct(S2, Dict(
        "s1" => Dict("i" => 1, "s" => "foo")
    )) == S2(
        S1(1, "foo")
    )
    @test tostruct(S2, Dict{Any,Any}(
        "s1" => Dict{Any,Any}("i" => 1, "s" => "foo")
    )) == S2(
        S1(1, "foo")
    )
end
