# Lagrangian lower bound tests

begin
    α = 0.5
    l = 2 * (1 - α)
    @time @test relaxedIncrementalProblem([2 3; 1 4], [2 2; 3 1], [5 4; 3 4], 6, getAssignmentConstraints(2), 0.5, l) == 11
end

begin
    α = 0.5
    l = 2 * (1 - α)
    @time @test lagrangianLowerBound([2 3; 1 4], [2 2; 3 1], [5 4; 3 4], 6, getAssignmentConstraints(2), l) == 11
end
