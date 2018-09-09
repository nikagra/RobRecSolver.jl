# Adversarial problem tests

@time @test relaxedAdversarialProblem([1, 3], [3, 1], [2, 2], 2, [([1.0, 0.0], [0.0, 1.0])]) == ([3.0, 3.0], 4.0)

# The worst second case scenario for α = 0.5 is [5, 1] which gives y = [1.0, 0.0]
@time @test adversarialProblem([1, 3], [3, 1], [2, 2], 2, getKnapsackConstraints([1, 2], 1), 0.5) == 5.0

# The worst second case scenario for α = 1.0 is [3, 3] which gives y = [0.0, 1.0]
@time @test adversarialProblem([1, 3], [3, 1], [2, 2], 2, getKnapsackConstraints([1, 2], 1), 1.0) == 4.0
