@testset "Initial scenario tests" begin
    @test isapprox(initialScenario([0], [10], 5), [5.00061], atol = 1e-5)

    @test isapprox(initialScenario([2, 3], [8, 9], 10), [7.50073, 7.50073], atol = 1e-5)

    @test isapprox(initialScenario([2, 3, 4, 8, 1], [5, 9, 7, 10, 10], 13), [5.74969, 5.74969, 5.74969, 8.0, 5.74969], atol = 1e-5)
end
