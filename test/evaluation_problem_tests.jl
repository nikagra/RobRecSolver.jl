# Evaluation problem tests

@time @test relaxedAdversarialProblem([1], [3], 2, [2]) == ([3.0], 6.0)

@time @test evaluationProblem([4, 3], [2, 3], [8, 9], 9, 1.0, [0, 1], getKnapsackConstraints([1, 2], 1)) == 10.0

@time @test evaluationProblem([2 3; 1 4], [2 2; 3 1], [5 4; 3 4], 6, 1.0, [0 1; 1 0], getAssignmentConstraints(2)) == 11.0
