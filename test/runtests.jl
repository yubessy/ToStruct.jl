using Test

import ToStruct.tostruct

struct S1
    i::Int
    s::String
end

struct S2
    s1::S1
end

struct S3
    si::Union{String,Int}
    ni::Union{Nothing,Int}
    mi::Union{Missing,Int}
end

@testset "Any" begin
    @test tostruct(Any, 1) == 1.
    @test tostruct(Any, 1.) == 1.
    @test tostruct(Any, "foo") == "foo"
    @test tostruct(Any, [1, 2, 3]) == [1, 2, 3]
    @test tostruct(Any, Dict("a" => 1)) == Dict("a" => 1)
end

@testset "Primitive" begin
    @test tostruct(Int, 1) == 1
    @test tostruct(Float64, 1.) == 1.
    @test tostruct(String, "foo") == "foo"
    @test tostruct(Float64, 1) == 1.
end

@testset "Union" begin
    @test tostruct(Union{Nothing,Int}, 1) == 1
    @test tostruct(Union{Nothing,Int}, nothing) == nothing
    # Left type will be given priority
    @test tostruct(Union{Float64,Int}, 1.) == 1
    # Union{Int,Float64} will be automatically reordered to Union{Float64,Int} by julia compiler
    @test tostruct(Union{Int,Float64}, 1.) == 1
end

@testset "Vector" begin
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
    @test tostruct(S3, Dict("si" => "foo", "ni" => 1, "mi" => 1)) == S3("foo", 1, 1)
    @test tostruct(S3, Dict("si" => 1, "mi" => 1)).ni == nothing
    @test ismissing(tostruct(S3, Dict("si" => 1, "ni" => 1)).mi)
    @test_throws KeyError tostruct(S3, Dict("ni" => 1, "mi" => 1))
end
