using RobRecSolver
using Base.Test

tests = [
    "initial_scenario_tests",
    "minimum_knapsack_problem_tests",
    "minimum_assignment_problem_tests",
    "incremental_problem_tests",
    "recoverable_problem_tests",
    "evaluation_problem_tests",
    "evaluation_problem_cb_tests",
    "adversarial_problem_tests",
    "adversarial_problem_cb_tests",
    "selection_lower_bound_tests",
    "lagrangian_lower_bound_tests"
    ]

@time for test in tests
    println("Starting $(test)...")
    include("$(test).jl")
    println("$(test) finished.")
end
