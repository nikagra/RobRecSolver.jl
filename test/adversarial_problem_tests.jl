@testset "Adversarial problem tests" begin
    @test adversarialProblem([1, 3], [3, 1], [2, 2], 2, getKnapsackConstraints([1, 2], 1), 0.5) == 5.0

    @test adversarialProblem([1, 3], [3, 1], [2, 2], 2, getKnapsackConstraints([1, 2], 1), 1.0) == 4.0
end
