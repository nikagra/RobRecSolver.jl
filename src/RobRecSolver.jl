"""
Solving robust recoverable 0-1 optimization problems under interval budgeted uncertainty
"""
module RobRecSolver

files = [
        "minimum_knapsack_problem",
        "minimum_assignment_problem",
        "initial_scenario",
        "recoverable_model",
        "experiment"
    ]

    for file in files
        include("$(file).jl")
    end

end # module
