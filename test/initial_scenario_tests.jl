# Initial scenario tests

@test initialScenario([0], [10], 5) == [5]

@test initialScenario([2, 3, 4, 8, 1], [5, 9, 7, 10, 10], 13) == [5, 5, 5, 8, 5]
