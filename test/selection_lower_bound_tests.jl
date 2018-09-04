# Selection lower bound tests

@time @test selectionLowerBound([1, 3], [3, 1], [2, 2], 2, getKnapsackConstraints([1, 2], 1), 0.5) == 3.5

@time @test selectionLowerBound([2 3; 1 4], [2 2; 3 1], [5 4; 3 4], 6, getAssignmentConstraints(2), 0.5) == 9.5
