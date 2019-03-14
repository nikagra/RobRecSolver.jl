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
    hasEqualCardinalityProperty,
    getCardinality


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
