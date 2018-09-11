@testset "Recoverable problem tests" begin
    @test recoverableProblem([1, 2], [5, 3], getKnapsackConstraints([1, 1], 1), 1.0) == ([1.0, 0.0], [0.0, 1.0], 4.0)
end
