# Selection lower bound tests

@time @test selectionLowerBound([1, 3], [3, 1], [2, 2], 2, 0.5, getKnapsackConstraints([1, 2], 1)) == 3.5
