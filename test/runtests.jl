using RobRecSolver
using Base.Test

tests = [
    "initial_scenario_tests",
    "minimum_knapsack_problem_tests",
    "minimum_assignment_problem_tests"
    ]

for test in tests
    include("$(test).jl")
end
