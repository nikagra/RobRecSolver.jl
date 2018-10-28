@testset "Evaluation problem with callback tests" begin
    begin
        obj₁ = evaluationProblem([4, 3], [2, 3], [8, 9], 9, 1.0, [0, 1], getKnapsackConstraints([1, 2], 1), KnapsackProblemDescriptor(3))
        obj₂ = evaluationProblemWithCallback([4, 3], [2, 3], [8, 9], 9, 1.0, [0, 1], getKnapsackConstraints([1, 2], 1), KnapsackProblemDescriptor(3))
        @test obj₁ == obj₂ == 10.0
    end

    begin
        obj₁ = evaluationProblem([2 3; 1 4], [2 2; 3 1], [5 4; 3 4], 6, 1.0, [0 1; 1 0], getAssignmentConstraints(2), KnapsackProblemDescriptor(3))
        obj₂ = evaluationProblemWithCallback([2 3; 1 4], [2 2; 3 1], [5 4; 3 4], 6, 1.0, [0 1; 1 0], getAssignmentConstraints(2), KnapsackProblemDescriptor(3))
        @test obj₁ == obj₂ == 11.0
    end
end
