@testset "Adversarial problem tests" begin
    @test isapprox(adversarialProblem([1, 3], [3, 1], [2, 2], 2, getKnapsackConstraints([1, 2], 1), 0.5, KnapsackProblemDescriptor(2)), 5.0, atol = 1e-5)

    @test isapprox(adversarialProblem([1, 3], [3, 1], [2, 2], 2, getKnapsackConstraints([1, 2], 1), 1.0, KnapsackProblemDescriptor(2)), 3.99988, atol = 1e-5)
end
