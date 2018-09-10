@testset "Adversarial Problem With Callback Tests" begin
    begin
        Δt₁ = @elapsed lb₁ = adversarialProblem([1, 3], [3, 1], [2, 2], 2, getKnapsackConstraints([1, 2], 1), 0.5)
        println("adversarialProblem solved in $Δt₁ sec")
        Δt₂ = @elapsed lb₂ = adversarialProblemWithCallback([1, 3], [3, 1], [2, 2], 2, getKnapsackConstraints([1, 2], 1), 0.5)
        println("adversarialProblemWithCallback solved in $Δt₂ sec")
        @test lb₁ == lb₂ == 5.0
    end

    begin
        Δt₁ = @elapsed lb₁ = adversarialProblem([1, 3], [3, 1], [2, 2], 2, getKnapsackConstraints([1, 2], 1), 1.0)
        Δt₂ = @elapsed lb₂ = adversarialProblemWithCallback([1, 3], [3, 1], [2, 2], 2, getKnapsackConstraints([1, 2], 1), 1.0)
        @test lb₁ == lb₂ == 4.0
    end
end
