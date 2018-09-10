@testset "Adversarial Problem Tests" begin
    @time @test relaxedAdversarialProblem([1, 3], [3, 1], [2, 2], 2, [([1.0, 0.0], [0.0, 1.0])]) == ([3.0, 3.0], 4.0)

    @time @test adversarialProblem([1, 3], [3, 1], [2, 2], 2, getKnapsackConstraints([1, 2], 1), 0.5) == 5.0

    @time @test adversarialProblem([1, 3], [3, 1], [2, 2], 2, getKnapsackConstraints([1, 2], 1), 1.0) == 4.0
end
