"""
Solving robust recoverable 0-1 optimization problems under interval budgeted uncertainty
"""
module RobRecSolver

files = [
        "minimum_knapsack_problem",
        "minimum_assignment_problem",
        "initial_scenario",
        "evaluation_problem",
        "recoverable_problem",
        "experiment"
    ]

    for file in files
        include("$(file).jl")
    end

end # module
