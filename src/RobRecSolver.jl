"""
A Julia package implementing algorithms described in paper "Solving robust recoverable 0-1 optimization problems under interval budgeted uncertainty"
by Adam Kasperski and Pawel Zielinski.
"""
module RobRecSolver

using JuMP, Cbc

export
    minimumAssignmentProblem,
    getAssignmentConstraints,
    minimumKnapsackProblem,
    getKnapsackConstraints,
    initialScenario,
    adversarialProblem,
    relaxedAdversarialProblem,
    evaluationProblem,
    incrementalProblem,
    recoverableProblem,

    # experiments
    generateKnapsackData,
    generateAssignmentData,
    runExperiment

files = [
        "minimum_knapsack_problem",
        "minimum_assignment_problem",
        "initial_scenario",
        "evaluation_problem",
        "recoverable_problem",
        "adversarial_problem",
        "Incremental_problem",
        "experiment"
    ]

    for file in files
        include("$(file).jl")
    end

end # module
