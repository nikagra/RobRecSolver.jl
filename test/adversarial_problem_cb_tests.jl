@testset "Adversarial problem with callback tests" begin
    begin
        lb₁ = adversarialProblem([1, 3], [3, 1], [2, 2], 2, getKnapsackConstraints([1, 2], 1), 0.5, KnapsackProblemDescriptor(2))
        lb₂ = adversarialProblemWithCallback([1, 3], [3, 1], [2, 2], 2, getKnapsackConstraints([1, 2], 1), 0.5, KnapsackProblemDescriptor(2))
        @test lb₁ == lb₂ == 5.0
    end

    begin
        lb₁ = adversarialProblem([1, 3], [3, 1], [2, 2], 2, getKnapsackConstraints([1, 2], 1), 1.0, KnapsackProblemDescriptor(2))
        lb₂ = adversarialProblemWithCallback([1, 3], [3, 1], [2, 2], 2, getKnapsackConstraints([1, 2], 1), 1.0, KnapsackProblemDescriptor(2))
        @test lb₁ == lb₂ == 4.0
    end
end
