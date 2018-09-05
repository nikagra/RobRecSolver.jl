"""
A Julia package implementing algorithms described in paper "Solving robust recoverable 0-1 optimization problems under interval budgeted uncertainty"
by Adam Kasperski and Pawel Zielinski.
"""
module RobRecSolver

using JuMP
using CPLEX
using MicroLogging
using Plots
import GR # workaround due to https://github.com/JuliaPlots/Plots.jl/issues/1047

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
    selectionLowerBound,

    lagrangianLowerBound,
    relaxedIncrementalProblem,

    # experiments
    generateKnapsackData,
    generateAssignmentData,
    runExperiment,
    drawPlots

files = [
        "minimum_knapsack_problem",
        "minimum_assignment_problem",
        "initial_scenario",
        "evaluation_problem",
        "recoverable_problem",
        "adversarial_problem",
        "incremental_problem",
        "selection_lower_bound",
        "lagrangian_lower_bound",
        "experiment",
        "plots"
    ]

    for file in files
        include("$(file).jl")
    end

end # module
