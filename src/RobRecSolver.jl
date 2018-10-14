"""
A Julia package implementing algorithms described in paper "Solving robust recoverable 0-1 optimization problems under interval budgeted uncertainty"
by Adam Kasperski and Pawel Zielinski.
"""
module RobRecSolver

using Base.Distributed
using JuMP
using CPLEX
using MicroLogging
using LaTeXStrings
using Plots
import PyPlot # workaround due to https://github.com/JuliaPlots/Plots.jl/issues/1047
using ConfParser
using DataFrames
using CSV

export
    # Types
    ProblemDescriptor,
    KnapsackProblemDescriptor,
    AssignmentProblemDescriptor,

    # Functions
    minimumAssignmentProblem,
    getAssignmentConstraints,

    minimumKnapsackProblem,
    getKnapsackConstraints,

    initialScenario,

    adversarialProblem,
    adversarialProblemWithCallback,

    evaluationProblem,
    evaluationProblemWithCallback,

    incrementalProblem,
    recoverableProblem,
    selectionLowerBound,

    lagrangianLowerBound,
    relaxedIncrementalProblem,

    # experiments
    runExperiments,
    exportKnapsackResults,
    exportAssignmentResults,
    getProperties,

    # data generators
    generateData,
    getProblemSize,
    getSaneComputationLimit,
    hasEqualCardinalityProperty

files = [
        "minimum_knapsack_problem",
        "minimum_assignment_problem",
        "initial_scenario",
        "evaluation_problem",
        "evaluation_problem_cb",
        "recoverable_problem",
        "adversarial_problem",
        "adversarial_problem_cb",
        "incremental_problem",
        "selection_lower_bound",
        "lagrangian_lower_bound",
        "data_generators",
        "experiment",
        "export",
        "properties",
        "logging"
    ]

    for file in files
        include("$(file).jl")
    end

end # module
