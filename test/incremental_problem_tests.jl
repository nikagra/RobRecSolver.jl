# Incremental problem tests
@time @test incrementalProblem([1, 2, 3], 0.5, [0, 1, 1], getKnapsackConstraints([1, 2, 3], 3)) == ([1, 1, 0], 3.0)
