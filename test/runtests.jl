#!/usr/bin/env julia

#Start Test Script
using VREP
using Base.Test

# Run tests

tic()
println("Test 1")
@time @test include("test1.jl")
println("Test 2")
@time @test include("test2.jl")
toc()
