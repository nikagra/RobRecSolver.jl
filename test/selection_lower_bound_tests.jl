@testset "Selection lower bound tests" begin
    @test selectionLowerBound([1, 3], [3, 1], [2, 2], 2, getKnapsackConstraints([1, 2], 1), 0.5, KnapsackProblemDescriptor(2)) == 3.5

    @test selectionLowerBound([2 3; 1 4], [2 2; 3 1], [5 4; 3 4], 6, getAssignmentConstraints(2), 0.5, AssignmentProblemDescriptor(2)) == 11
end
