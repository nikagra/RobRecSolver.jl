"""
`$(current_module())` is a Julia programming language package developed to test performance of algorithms
proposed in _Robust recoverable 0-1 optimization problems under polyhedral uncertainty_
(Mikita Hradovich, Adam Kasperski, Pawel Zielinski) which is available as preprint on
[arxiv.org](https://arxiv.org/abs/1811.06719). This work will later be referenced as _publication_.
"""
module RobRecSolver

using Base.Distributed
using JuMP
using CPLEX

using MicroLogging
using ConfParser

export
    #Modules
    Experiments,

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

    evaluationProblem,

    incrementalProblem,
    recoverableProblem,
    selectionLowerBound,

    lagrangianLowerBound,
    relaxedIncrementalProblem,

    # Utils
    loadProperties,
    getProperty,
    getProblemSize,
    getSaneComputationLimit,
    hasEqualCardinalityProperty


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
        "problem_descriptors",
        "properties",
    ]

    for file in files
        include("$(file).jl")
    end

    # Import experiments
    include(joinpath("experiments", "Experiments.jl"))
    using .Experiments

    configure_logging(min_level=:debug)

end # module
