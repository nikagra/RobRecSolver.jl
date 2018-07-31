# Recoverable problem tests

@time @test recoverableProblem([1, 2], [5, 3], 1.0, getKnapsackConstraints([1, 1], 1)) == ([1.0, 0.0], [0.0, 1.0], 4.0)
