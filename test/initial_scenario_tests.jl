# Initial scenario tests

@time @test initialScenario([0], [10], 5) == [5]

@time @test initialScenario([2, 3], [8, 9], 10) == [7, 7]

@time @test initialScenario([2, 3, 4, 8, 1], [5, 9, 7, 10, 10], 13) == [5, 5, 5, 8, 5]
