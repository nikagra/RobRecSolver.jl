@testset "Minimum knapsack problem tests" begin
    @test minimumKnapsackProblem([3, 5, 6], [1, 2, 3], 5) == [0, 1, 1]
end
